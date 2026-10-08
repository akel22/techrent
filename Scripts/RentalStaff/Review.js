(function () {
    var rentalDatesStorageKey = 'techrent.rentalDates';
    var selectedEquipmentStorageKey = 'techrent.selectedEquipment';
    var auditLog = document.getElementById('preRentalAuditLog');
    var auditLogCount = document.getElementById('auditLogCount');
    var confirmButton = document.getElementById('confirmReviewButton');
    var confirmation = document.getElementById('reviewConfirmation');
    var receiptModalElement = document.getElementById('rentalReceiptModal');
    var receiptModal = bootstrap.Modal.getOrCreateInstance(receiptModalElement);
    var paymentAmountInput = document.getElementById('paymentAmount');
    var receiptAmountPaid = document.getElementById('rentalReceiptAmountPaid');
    var receiptChange = document.getElementById('rentalReceiptChange');
    var rentalTotal = 0;
    var receiptAuditLog = document.getElementById('rentalReceiptAuditLog');
    var reviewRentalStartDate = document.getElementById('reviewRentalStartDate');
    var reviewRentalReturnDate = document.getElementById('reviewRentalReturnDate');
    var receiptRentalStartDate = document.getElementById('rentalReceiptStartDate');
    var receiptRentalReturnDate = document.getElementById('rentalReceiptReturnDate');
    var printReceiptButton = document.getElementById('printRentalReceiptButton');

    function getSelectedEquipment() {
        try {
            return JSON.parse(sessionStorage.getItem(selectedEquipmentStorageKey)) || {};
        } catch (error) {
            return {};
        }
    }

    function formatEquipmentCell(value) {
        return String(value || '').replace(/[&<>"']/g, function (character) {
            return { '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[character];
        });
    }

    function populateEquipment() {
        var reviewRows = document.getElementById('reviewEquipmentRows');
        var rows = document.getElementById('rentalReceiptEquipmentRows');
        var rentalFees = 0;
        var securityDeposit = 0;
        var selectedEquipment = getSelectedEquipment();
        reviewRows.innerHTML = '';
        rows.innerHTML = '';

        Object.keys(selectedEquipment).forEach(function (id) {
            var item = selectedEquipment[id];
            var quantity = Number(item.quantity) || 0;
            var rentalFee = quantity * (Number(item.rentalFee) || 0);
            var deposit = quantity * (Number(item.securityDeposit) || 0);
            rentalFees += rentalFee;
            securityDeposit += deposit;
            var equipmentName = formatEquipmentCell(item.name);
            var equipmentDetails = formatEquipmentCell((item.category || '') + ' · ' + quantity + ' ' + (quantity === 1 ? 'unit' : 'units'));
            reviewRows.insertAdjacentHTML('beforeend', '<tr><th scope="row"><span class="d-block">' + equipmentName + '</span><span class="small text-muted">' + equipmentDetails + '</span></th><td class="text-end">' + formatCurrency(rentalFee) + '</td><td class="text-end">' + formatCurrency(deposit) + '</td></tr>');
            rows.insertAdjacentHTML('beforeend', '<tr><th scope="row">' + formatEquipmentCell(item.name) + '</th><td class="text-end">' + formatCurrency(rentalFee) + '</td><td class="text-end">' + formatCurrency(deposit) + '</td></tr>');
        });

        rentalTotal = rentalFees + securityDeposit;
        document.getElementById('reviewRentalFees').textContent = formatCurrency(rentalFees);
        document.getElementById('reviewSecurityDeposit').textContent = formatCurrency(securityDeposit);
        document.getElementById('reviewTotal').textContent = formatCurrency(rentalTotal);
        document.getElementById('rentalReceiptRentalFees').textContent = formatCurrency(rentalFees);
        document.getElementById('rentalReceiptSecurityDeposit').textContent = formatCurrency(securityDeposit);
        document.getElementById('rentalReceiptTotal').textContent = formatCurrency(rentalTotal);
        paymentAmountInput.min = rentalTotal.toFixed(2);
        document.getElementById('paymentAmountError').textContent = 'Payment must be at least ' + formatCurrency(rentalTotal) + '.';
    }

    function refreshAuditLogCount() {
        auditLogCount.textContent = auditLog.value.length + ' / ' + auditLog.maxLength;
    }

    function getRentalDates() {
        try {
            return JSON.parse(sessionStorage.getItem(rentalDatesStorageKey)) || {};
        } catch (error) {
            return {};
        }
    }

    function formatRentalDate(value) {
        if (!value) {
            return 'Not provided';
        }

        var parts = value.split('-');
        if (parts.length !== 3) {
            return 'Not provided';
        }

        var date = new Date(Number(parts[0]), Number(parts[1]) - 1, Number(parts[2]));
        return isNaN(date.getTime()) ? 'Not provided' : date.toLocaleDateString('en-US', {
            year: 'numeric',
            month: 'long',
            day: 'numeric'
        });
    }

    function populateRentalDates() {
        var dates = getRentalDates();
        var startDate = formatRentalDate(dates.startDate);
        var returnDate = formatRentalDate(dates.returnDate);

        reviewRentalStartDate.textContent = startDate;
        reviewRentalReturnDate.textContent = returnDate;
        receiptRentalStartDate.textContent = startDate;
        receiptRentalReturnDate.textContent = returnDate;
    }

    function formatCurrency(value) {
        return '₱' + value.toLocaleString('en-US', {
            minimumFractionDigits: 2,
            maximumFractionDigits: 2
        });
    }

    function populateReceipt(paymentAmount) {
        populateRentalDates();
        receiptAuditLog.textContent = auditLog.value.trim() || 'No pre-rental details recorded.';
        receiptAmountPaid.textContent = formatCurrency(paymentAmount);
        receiptChange.textContent = formatCurrency(paymentAmount - rentalTotal);
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

    window.showRentalReceiptModal = function () {
        receiptModal.show();
    };

    auditLog.addEventListener('input', refreshAuditLogCount);
    confirmButton.addEventListener('click', function () {
        var paymentAmount = Number(paymentAmountInput.value);
        if (!paymentAmountInput.value || !isFinite(paymentAmount) || paymentAmount < rentalTotal) {
            paymentAmountInput.classList.add('is-invalid');
            paymentAmountInput.setAttribute('aria-invalid', 'true');
            paymentAmountInput.focus();
            return;
        }

        paymentAmountInput.classList.remove('is-invalid');
        paymentAmountInput.removeAttribute('aria-invalid');
        confirmButton.disabled = false;
        confirmButton.textContent = 'Confirm rental details';
        populateReceipt(paymentAmount);
        document.getElementById('selectedEquipmentJson').value = JSON.stringify(getSelectedEquipment());
        document.getElementById('rentalStartDateValue').value = getRentalDates().startDate || '';
        document.getElementById('rentalReturnDateValue').value = getRentalDates().returnDate || '';
        document.getElementById('paymentAmountValue').value = paymentAmount.toFixed(2);
        receiptModal.show();
        confirmation.scrollIntoView({ behavior: 'smooth', block: 'nearest' });
    });

    printReceiptButton.addEventListener('click', saveReceiptAsPdf);

    populateEquipment();
    populateRentalDates();
    refreshAuditLogCount();
}());
