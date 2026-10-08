(function () {
    var form = document.getElementById('equipmentInsertionForm');
    var previewButton = document.getElementById('equipmentPreviewButton');
    var imageInput = document.getElementById('equipmentImage');
    var imagePreview = document.getElementById('equipmentImagePreview');
    var imagePlaceholder = document.getElementById('equipmentImagePlaceholder');
    var imageError = document.getElementById('equipmentImageError');
    var formAlert = document.getElementById('equipmentFormAlert');
    var allowedExtensions = ['jpg', 'png', 'heic'];

    if (!form) {
        return;
    }

    function getExtension(fileName) {
        var lastDot = fileName.lastIndexOf('.');
        return lastDot === -1 ? '' : fileName.substring(lastDot + 1).toLowerCase();
    }

    function isAllowedImage(file) {
        return !file || allowedExtensions.indexOf(getExtension(file.name)) !== -1;
    }

    function resetImagePreview() {
        imagePreview.classList.add('d-none');
        imagePlaceholder.classList.remove('d-none');
        imagePreview.removeAttribute('src');
    }

    imageInput.addEventListener('change', function () {
        var file = imageInput.files && imageInput.files.length ? imageInput.files[0] : null;
        var isAllowed = isAllowedImage(file);

        imageError.hidden = isAllowed;
        imageInput.classList.toggle('is-invalid', !isAllowed);
        resetImagePreview();

        if (!file || !isAllowed) {
            imagePlaceholder.textContent = 'No attached image';
            return;
        }

        if (getExtension(file.name) === 'heic') {
            imagePlaceholder.textContent = 'HEIC image selected; preview depends on browser support';
        } else {
            imagePlaceholder.textContent = 'Loading image preview...';
        }

        var reader = new FileReader();
        reader.onload = function (event) {
            imagePreview.onload = function () {
                imagePlaceholder.classList.add('d-none');
                imagePreview.classList.remove('d-none');
            };
            imagePreview.onerror = function () {
                imagePlaceholder.textContent = 'Image selected; preview unavailable in this browser';
                imagePlaceholder.classList.remove('d-none');
                imagePreview.classList.add('d-none');
            };
            imagePreview.src = event.target.result;
        };
        reader.readAsDataURL(file);
    });

    previewButton.addEventListener('click', function () {
        var controls = form.querySelectorAll('input, select');
        var isValid = true;
        var file = imageInput.files && imageInput.files.length ? imageInput.files[0] : null;

        Array.prototype.forEach.call(controls, function (control) {
            if (control === imageInput) {
                return;
            }

            if (!control.checkValidity()) {
                control.classList.add('is-invalid');
                isValid = false;
            } else {
                control.classList.remove('is-invalid');
            }
        });

        var validImage = isAllowedImage(file);
        imageError.hidden = validImage;
        imageInput.classList.toggle('is-invalid', !validImage);
        isValid = isValid && validImage;

        if (!isValid) {
            formAlert.classList.add('d-none');
            form.classList.add('was-validated');
            return;
        }

        formAlert.classList.remove('d-none');
        formAlert.focus();
    });
}());
