using System;
using System.Security.Cryptography;

namespace Techrent.ApplicationLayer.Services
{
    public sealed class PasswordHashResult
    {
        public byte[] Hash { get; set; }
        public byte[] Salt { get; set; }
    }

    public static class PasswordService
    {
        private const int SaltSize = 16;
        private const int HashSize = 32;
        private const int IterationCount = 100000;
        private const int MinimumLength = 8;
        private const int MaximumLength = 128;

        public static PasswordHashResult HashPassword(string password)
        {
            ValidatePassword(password);

            var salt = new byte[SaltSize];
            using (var random = RandomNumberGenerator.Create())
            {
                random.GetBytes(salt);
            }

            return new PasswordHashResult
            {
                Salt = salt,
                Hash = DeriveKey(password, salt)
            };
        }

        public static bool VerifyPassword(string password, byte[] expectedHash, byte[] salt)
        {
            if (string.IsNullOrEmpty(password) || expectedHash == null || salt == null || expectedHash.Length == 0 || salt.Length == 0)
            {
                return false;
            }

            var actualHash = DeriveKey(password, salt);
            return FixedTimeEquals(actualHash, expectedHash);
        }

        public static void ValidatePassword(string password)
        {
            if (string.IsNullOrEmpty(password) || password.Length < MinimumLength || password.Length > MaximumLength)
            {
                throw new ArgumentException("Password must be between 8 and 128 characters.", nameof(password));
            }

            var hasUpper = false;
            var hasLower = false;
            var hasDigit = false;
            foreach (var character in password)
            {
                hasUpper |= char.IsUpper(character);
                hasLower |= char.IsLower(character);
                hasDigit |= char.IsDigit(character);
            }

            if (!hasUpper || !hasLower || !hasDigit)
            {
                throw new ArgumentException("Password must contain uppercase, lowercase, and numeric characters.", nameof(password));
            }
        }

        private static byte[] DeriveKey(string password, byte[] salt)
        {
            using (var derivation = new Rfc2898DeriveBytes(password, salt, IterationCount))
            {
                return derivation.GetBytes(HashSize);
            }
        }

        private static bool FixedTimeEquals(byte[] left, byte[] right)
        {
            if (left == null || right == null || left.Length != right.Length)
            {
                return false;
            }

            var difference = 0;
            for (var index = 0; index < left.Length; index++)
            {
                difference |= left[index] ^ right[index];
            }

            return difference == 0;
        }
    }
}
