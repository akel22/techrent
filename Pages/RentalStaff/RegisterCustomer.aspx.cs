using System;
using System.IO;
using System.Linq;
using System.Web.UI;
using Techrent.ApplicationLayer.Services;
using Techrent.DataAccessLayer.DTOs;

namespace Techrent.Pages.RentalStaff
{
    public partial class RegisterCustomer : Page
    {
        private const int MaxPhotoSize = 5 * 1024 * 1024;

        protected void Page_Load(object sender, EventArgs e)
        {
        }

        protected void RegisterButton_ServerClick(object sender, EventArgs e)
        {
            var first = (firstName.Value ?? string.Empty).Trim();
            var last = (lastName.Value ?? string.Empty).Trim();
            var emailValue = (email.Value ?? string.Empty).Trim();
            var mobile = (mobileNumber.Value ?? string.Empty).Trim();
            var address = (organizationAddress.Value ?? string.Empty).Trim();

            if (string.IsNullOrWhiteSpace(first) || string.IsNullOrWhiteSpace(last) ||
                string.IsNullOrWhiteSpace(emailValue) || string.IsNullOrWhiteSpace(mobile) ||
                string.IsNullOrWhiteSpace(address))
            {
                ShowMessage("Complete all required customer fields before registering.", false);
                return;
            }

            var occupationValue = (occupation.Value ?? string.Empty).Trim();
            occupationValue = NormalizeOccupation(occupationValue);

            byte[] identificationCard = null;
            if (customerPhoto.PostedFile != null && customerPhoto.PostedFile.ContentLength > 0)
            {
                var uploadedPhoto = customerPhoto.PostedFile;
                var extension = Path.GetExtension(uploadedPhoto.FileName);
                if (uploadedPhoto.ContentLength > MaxPhotoSize || !IsSupportedPhoto(extension))
                {
                    ShowMessage("Attach a JPG or PNG image no larger than 5 MB.", false);
                    return;
                }

                identificationCard = ReadPhoto(uploadedPhoto.InputStream, uploadedPhoto.ContentLength);
                if (!HasSupportedPhotoSignature(identificationCard, extension))
                {
                    ShowMessage("The attached file is not a valid JPG or PNG image.", false);
                    return;
                }
            }

            try
            {
                ServiceFactory.CreateCustomerService().RegisterCustomer(new CustomerDto
                {
                    FirstName = first,
                    LastName = last,
                    Occupation = occupationValue,
                    Email = emailValue,
                    MobileNumber = mobile,
                    OrganizationAddress = address,
                    IdentificationCard = identificationCard
                });
                ShowMessage("Customer registered successfully.", true);
            }
            catch (Exception ex)
            {
                ShowMessage(ex.Message, false);
            }
        }

        private void ShowMessage(string message, bool success)
        {
            registrationAlert.InnerText = message;
            registrationAlert.Attributes["class"] = success
                ? "alert alert-success"
                : "alert alert-danger";
        }

        private static string NormalizeOccupation(string value)
        {
            var allowedOccupations = new[] { "Student", "Employed", "Unemployed", "Other" };
            return allowedOccupations.FirstOrDefault(occupationValue =>
                string.Equals(occupationValue, value, StringComparison.OrdinalIgnoreCase)) ?? "Other";
        }

        private static bool IsSupportedPhoto(string extension)
        {
            return string.Equals(extension, ".jpg", StringComparison.OrdinalIgnoreCase) ||
                   string.Equals(extension, ".jpeg", StringComparison.OrdinalIgnoreCase) ||
                   string.Equals(extension, ".png", StringComparison.OrdinalIgnoreCase);
        }

        private static byte[] ReadPhoto(Stream stream, int length)
        {
            var photo = new byte[length];
            var offset = 0;

            while (offset < photo.Length)
            {
                var bytesRead = stream.Read(photo, offset, photo.Length - offset);
                if (bytesRead == 0)
                {
                    break;
                }

                offset += bytesRead;
            }

            if (offset == photo.Length)
            {
                return photo;
            }

            var completePhoto = new byte[offset];
            System.Buffer.BlockCopy(photo, 0, completePhoto, 0, offset);
            return completePhoto;
        }

        private static bool HasSupportedPhotoSignature(byte[] photo, string extension)
        {
            if (string.Equals(extension, ".png", StringComparison.OrdinalIgnoreCase))
            {
                return photo.Length >= 8 &&
                       photo[0] == 0x89 && photo[1] == 0x50 && photo[2] == 0x4E && photo[3] == 0x47 &&
                       photo[4] == 0x0D && photo[5] == 0x0A && photo[6] == 0x1A && photo[7] == 0x0A;
            }

            return photo.Length >= 3 && photo[0] == 0xFF && photo[1] == 0xD8 && photo[2] == 0xFF;
        }
    }
}
