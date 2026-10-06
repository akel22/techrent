(function () {
    var auditLog = document.getElementById('preRentalAuditLog');
    var auditLogCount = document.getElementById('auditLogCount');
    var confirmButton = document.getElementById('confirmReviewButton');
    var confirmation = document.getElementById('reviewConfirmation');
    var receiptModalElement = document.getElementById('rentalReceiptModal');
    var receiptModal = bootstrap.Modal.getOrCreateInstance(receiptModalElement);
    var receiptAuditLog = document.getElementById('rentalReceiptAuditLog');
    var printReceiptButton = document.getElementById('printRentalReceiptButton');
    var closeReceiptButton = document.getElementById('closeRentalReceiptButton');
    var receiptSavedOptions = Array.prototype.slice.call(document.querySelectorAll('input[name="receiptSaved"]'));

    function refreshAuditLogCount() {
        auditLogCount.textContent = auditLog.value.length + ' / ' + auditLog.maxLength;
    }

    function resetPrintConfirmation() {
        receiptSavedOptions.forEach(function (option) {
            option.checked = false;
        });
        closeReceiptButton.disabled = true;
    }

    function populateReceipt() {
        receiptAuditLog.textContent = auditLog.value.trim() || 'No pre-rental details recorded.';
    }

    function saveReceiptAsPdf() {
        var printWindow = window.open('', '_blank', 'width=900,height=700');
        if (!printWindow) {
            return;
        }

        var bootstrapStylesheet = document.querySelector('link[href*="Content/bootstrap.min.css"]').href;
        var reviewStylesheet = document.querySelector('link[href*="RentalStaff.Review.css"]').href;
        printWindow.document.write('<!doctype html><html lang="en"><head><meta charset="utf-8"><title>Rental receipt</title><link rel="stylesheet" href="' + bootstrapStylesheet + '"><link rel="stylesheet" href="' + reviewStylesheet + '"></head><body class="rental-receipt-print-page"><main class="container py-4">' + document.getElementById('rentalReceiptPrintContent').innerHTML + '</main></body></html>');
        printWindow.document.close();
        printWindow.focus();
        setTimeout(function () {
            printWindow.print();
            printWindow.close();
        }, 250);
    }

    auditLog.addEventListener('input', refreshAuditLogCount);
    confirmButton.addEventListener('click', function () {
        confirmButton.disabled = false;
        confirmButton.textContent = 'Confirm rental details';
        populateReceipt();
        resetPrintConfirmation();
        receiptModal.show();
        confirmation.scrollIntoView({ behavior: 'smooth', block: 'nearest' });
    });

    receiptSavedOptions.forEach(function (option) {
        option.addEventListener('change', function () {
            closeReceiptButton.disabled = option.value !== 'yes' || !option.checked;
        });
    });

    printReceiptButton.addEventListener('click', saveReceiptAsPdf);

    refreshAuditLogCount();
}());
