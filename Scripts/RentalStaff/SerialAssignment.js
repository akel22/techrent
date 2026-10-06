(function () {
    var form = document.getElementById('serialAssignmentForm');
    var finalizeButton = document.getElementById('finalizeAssignmentButton');

    form.addEventListener('submit', function (event) {
        event.preventDefault();
        form.classList.add('was-validated');
        if (!form.checkValidity()) {
            form.reportValidity();
            return;
        }
        finalizeButton.textContent = 'Assignment confirmed';
        finalizeButton.classList.remove('btn-success');
        finalizeButton.classList.add('btn-primary');
        var nextUrl = finalizeButton.getAttribute('data-next-url');
        if (nextUrl) {
            window.location.href = nextUrl;
        }
    });
}());
