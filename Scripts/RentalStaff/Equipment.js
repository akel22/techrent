(function () {
    var rentalDatesStorageKey = 'techrent.rentalDates';
    var selected = {};
    var search = document.getElementById('equipmentSearch');
    var category = document.getElementById('equipmentCategory');
    var items = Array.prototype.slice.call(document.querySelectorAll('.equipment-item'));
    var buttons = Array.prototype.slice.call(document.querySelectorAll('.equipment-add-button'));
    var summaryItems = document.getElementById('summaryItems');
    var summaryEmpty = document.getElementById('summaryEmpty');
    var summaryTotal = document.getElementById('summaryTotal');
    var continueButton = document.getElementById('continueButton');
    var noEquipment = document.getElementById('noEquipmentMessage');
    var rentalStartDate = document.getElementById('rentalStartDate');
    var rentalEndDate = document.getElementById('rentalEndDate');
    var rentalDateValidation = document.getElementById('rentalDateValidation');
    var appliedSearchTerm = '';
    var selectedEquipmentStorageKey = 'techrent.selectedEquipment';

    function formatDateTimeForInput(date) {
        var year = date.getFullYear();
        var month = String(date.getMonth() + 1).padStart(2, '0');
        var day = String(date.getDate()).padStart(2, '0');
        var hours = String(date.getHours()).padStart(2, '0');
        var minutes = String(date.getMinutes()).padStart(2, '0');
        return year + '-' + month + '-' + day + 'T' + hours + ':' + minutes;
    }

    function getBillableHours() {
        var start = new Date(rentalStartDate.value);
        var end = new Date(rentalEndDate.value);
        if (isNaN(start.getTime()) || isNaN(end.getTime()) || end <= start) {
            return 0;
        }

        return Math.ceil((end.getTime() - start.getTime()) / 3600000);
    }

    function validateRentalDates() {
        var start = rentalStartDate.value;
        var end = rentalEndDate.value;
        var message = '';
        var startDate = new Date(start);
        var endDate = new Date(end);
        var minimum = new Date(rentalStartDate.min);
        var valid = !!start && !!end && !isNaN(startDate.getTime()) && !isNaN(endDate.getTime()) && startDate >= minimum && endDate > startDate;

        if (!start || !end) {
            message = 'Select both a rental start date and time and a return date and time.';
        } else if (isNaN(startDate.getTime()) || isNaN(endDate.getTime())) {
            message = 'Enter valid rental start and return date-times.';
        } else if (startDate < minimum) {
            message = 'The rental start date and time cannot be in the past.';
        } else if (endDate <= startDate) {
            message = 'The return date and time must be after the rental start date and time.';
        }

        rentalStartDate.classList.toggle('is-invalid', !valid && (!start || isNaN(startDate.getTime()) || startDate < minimum || (!!end && !isNaN(endDate.getTime()) && endDate <= startDate)));
        rentalEndDate.classList.toggle('is-invalid', !valid && (!end || isNaN(endDate.getTime()) || (!!start && !isNaN(startDate.getTime()) && endDate <= startDate)));
        rentalDateValidation.textContent = message;
        rentalDateValidation.classList.toggle('d-none', valid);
        continueButton.disabled = !valid || Object.keys(selected).length === 0;
        return valid;
    }

    function restoreRentalDates() {
        var storedDates;

        try {
            storedDates = JSON.parse(sessionStorage.getItem(rentalDatesStorageKey));
        } catch (error) {
            storedDates = null;
        }

        if (storedDates) {
            rentalStartDate.value = storedDates.startDate || '';
            rentalEndDate.value = storedDates.returnDate || '';
        }
    }

    function storeRentalDates() {
        try {
            sessionStorage.setItem(rentalDatesStorageKey, JSON.stringify({
                startDate: rentalStartDate.value,
                returnDate: rentalEndDate.value
            }));
        } catch (error) {
        }
    }

    function money(value) {
        return '\u20b1' + value.toLocaleString('ph-PH', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
    }

    function normalizeCategory(value) {
        return (value || '').trim().toLowerCase();
    }

    function applyFilters() {
        var term = appliedSearchTerm;
        var selectedCategory = normalizeCategory(category.value);
        var visible = 0;

        items.forEach(function (item) {
            var matchesTerm = !term || item.getAttribute('data-equipment-search').indexOf(term) !== -1;
            var matchesCategory = selectedCategory === 'all' || normalizeCategory(item.getAttribute('data-category')) === selectedCategory;
            var visibleItem = matchesTerm && matchesCategory;
            item.classList.toggle('d-none', !visibleItem);
            if (visibleItem) {
                visible++;
            }
        });

        noEquipment.classList.toggle('d-none', visible !== 0);
    }

    function renderSummary() {
        var totalUnits = 0;
        var rentalFees = 0;
        var securityDeposit = 0;
        var total = 0;
        var billableHours = getBillableHours();
        var markup = '';

        Object.keys(selected).forEach(function (id) {
            var item = selected[id];
            var lineRentalFee = item.quantity * item.rate * billableHours;
            var lineDeposit = item.quantity * item.securityDeposit;
            totalUnits += item.quantity;
            rentalFees += lineRentalFee;
            securityDeposit += lineDeposit;
            markup += '<div class="rental-staff-summary-item">' +
                '<div><strong>' + item.name + '</strong><span> Rental fee: ' + money(item.rate) + '/hr × ' + billableHours + ' ' + (billableHours === 1 ? 'hour' : 'hours') + '</span>' +
                '<span> Security deposit: '+ money(item.securityDeposit) + '</span></div>' +
                '<div class="rental-staff-summary-controls" aria-label="Quantity for ' + item.name + '">' +
                '<button type="button" class="btn btn-sm btn-outline-secondary summary-quantity-button" data-action="decrease" data-id="' + id + '">−</button>' +
                '<span>' + item.quantity + '</span>' +
                '<button type="button" class="btn btn-sm btn-outline-secondary summary-quantity-button" data-action="increase" data-id="' + id + '">+</button>' +
                '<button type="button" class="btn btn-sm btn-link text-danger summary-remove-button" data-action="remove" data-id="' + id + '">Remove</button>' +
                '</div><strong>' + money(lineRentalFee + lineDeposit) + '</strong></div>';
        });

        total = rentalFees + securityDeposit;
        summaryEmpty.classList.toggle('d-none', totalUnits !== 0);
        summaryItems.querySelectorAll('.rental-staff-summary-item').forEach(function (node) { node.remove(); });
        summaryItems.insertAdjacentHTML('afterbegin', markup);
        summaryTotal.textContent = money(total);
        continueButton.disabled = totalUnits === 0;
        validateRentalDates();
    }

    function addItem(button) {
        var id = button.getAttribute('data-equipment-id');
        var current = selected[id];
        var stock = Number(button.getAttribute('data-equipment-stock'));

        if (!current) {
            selected[id] = {
                name: button.getAttribute('data-equipment-name'),
                category: button.getAttribute('data-equipment-category'),
                sku: button.getAttribute('data-equipment-sku'),
                rate: Number(button.getAttribute('data-equipment-rate')) || 0,
                rentalFee: Number(button.getAttribute('data-equipment-rental-fee')) || 0,
                securityDeposit: Number(button.getAttribute('data-equipment-security-deposit')) || 0,
                stock: stock,
                quantity: 1
            };
        } else if (current.quantity < current.stock) {
            current.quantity++;
        }

        button.disabled = selected[id].quantity >= stock;
        sessionStorage.setItem(selectedEquipmentStorageKey, JSON.stringify(selected));
        renderSummary();
    }

    function changeQuantity(id, action) {
        var item = selected[id];
        if (!item) {
            return;
        }
        if (action === 'increase' && item.quantity < item.stock) {
            item.quantity++;
        } else if (action === 'decrease') {
            item.quantity--;
        }
        if (action === 'remove' || item.quantity < 1) {
            delete selected[id];
        }
        buttons.forEach(function (button) {
            if (button.getAttribute('data-equipment-id') === id) {
                button.disabled = !!selected[id] && selected[id].quantity >= item.stock;
            }
        });
        renderSummary();
        sessionStorage.setItem(selectedEquipmentStorageKey, JSON.stringify(selected));
    }

    buttons.forEach(function (button) {
        button.addEventListener('click', function () { addItem(button); });
    });
    summaryItems.addEventListener('click', function (event) {
        var button = event.target.closest('.summary-quantity-button, .summary-remove-button');

        if (button && summaryItems.contains(button)) {
            changeQuantity(button.getAttribute('data-id'), button.getAttribute('data-action'));
        }
    });
    search.addEventListener('keydown', function (event) {
        if (event.key === 'Enter') {
            event.preventDefault();
            appliedSearchTerm = search.value.toLowerCase().trim();
            applyFilters();
        }
    });
    continueButton.addEventListener('click', function () {
        if (!continueButton.disabled && validateRentalDates()) {
            storeRentalDates();
            window.location.href = continueButton.getAttribute('data-next-url');
        }
    });
    category.addEventListener('change', applyFilters);
    var now = new Date();
    var nowValue = formatDateTimeForInput(now);
    rentalStartDate.min = nowValue;
    rentalEndDate.min = nowValue;
    rentalStartDate.addEventListener('change', function () {
        rentalEndDate.min = rentalStartDate.value || nowValue;
        validateRentalDates();
    });
    rentalEndDate.addEventListener('change', validateRentalDates);
    restoreRentalDates();
    rentalEndDate.min = rentalStartDate.value || nowValue;
    validateRentalDates();
}());
