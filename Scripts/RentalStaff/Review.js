(function () {
    var auditLog = document.getElementById('preRentalAuditLog');
    var auditLogCount = document.getElementById('auditLogCount');
    var confirmButton = document.getElementById('confirmReviewButton');
    var confirmation = document.getElementById('reviewConfirmation');

    function refreshAuditLogCount() {
        auditLogCount.textContent = auditLog.value.length + ' / ' + auditLog.maxLength;
    }

    auditLog.addEventListener('input', refreshAuditLogCount);
    confirmButton.addEventListener('click', function () {
        confirmButton.disabled = true;
        confirmButton.textContent = 'Rental details confirmed';
        confirmButton.classList.remove('btn-success');
        confirmButton.classList.add('btn-primary');
        confirmation.classList.remove('d-none');
        confirmation.scrollIntoView({ behavior: 'smooth', block: 'nearest' });
    });

    refreshAuditLogCount();
}());
