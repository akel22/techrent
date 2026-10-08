(function () {
    var form = document.getElementById('customerRegistrationForm');
    var mobileNumber = document.getElementById('mobileNumber');
    var photoInput = document.getElementById('customerPhoto');
    var photoPreview = document.getElementById('photoPreview');
    var photoPlaceholder = document.getElementById('photoPlaceholder');
    var photoError = document.getElementById('photoError');
    var registrationAlert = document.getElementById('registrationAlert');
    var allowedExtensions = ['jpg', 'png', 'heic'];

    if (!form) {
        return;
    }

    mobileNumber.addEventListener('keydown', function (event) {
        var allowedControlKeys = ['Backspace', 'Delete', 'ArrowLeft', 'ArrowRight', 'Home', 'End', 'Tab'];

        if (!event.ctrlKey && !event.metaKey && event.key.length === 1 && !/[0-9]/.test(event.key) && allowedControlKeys.indexOf(event.key) === -1) {
            event.preventDefault();
        }
    });

    mobileNumber.addEventListener('input', function () {
        mobileNumber.value = mobileNumber.value.replace(/[^0-9]/g, '');
    });

    photoInput.addEventListener('change', function () {
        var file = photoInput.files && photoInput.files.length ? photoInput.files[0] : null;
        var fileName = file ? file.name.toLowerCase() : '';
        var extension = fileName.indexOf('.') === -1 ? '' : fileName.split('.').pop();
        var isAllowed = file && allowedExtensions.indexOf(extension) !== -1;

        photoError.hidden = isAllowed || !file;
        photoInput.classList.toggle('is-invalid', !isAllowed && !!file);
        photoPreview.classList.add('d-none');
        photoPlaceholder.classList.remove('d-none');
        photoPreview.removeAttribute('src');

        if (!isAllowed) {
            return;
        }

        var reader = new FileReader();
        reader.onload = function (event) {
            photoPreview.onload = function () {
                photoPlaceholder.classList.add('d-none');
                photoPreview.classList.remove('d-none');
            };
            photoPreview.onerror = function () {
                photoPlaceholder.classList.remove('d-none');
                photoPreview.classList.add('d-none');
            };
            photoPreview.src = event.target.result;
        };
        reader.readAsDataURL(file);
    });

    form.addEventListener('submit', function (event) {
        event.preventDefault();
        photoError.hidden = !photoInput.files.length || !photoInput.classList.contains('is-invalid');

        if (!form.checkValidity() || photoInput.classList.contains('is-invalid')) {
            form.classList.add('was-validated');
            return;
        }

        registrationAlert.classList.remove('d-none');
        registrationAlert.focus();
    });
}());
