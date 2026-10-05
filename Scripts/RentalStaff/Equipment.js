(function () {
    var selected = {};
    var search = document.getElementById('equipmentSearch');
    var category = document.getElementById('equipmentCategory');
    var items = Array.prototype.slice.call(document.querySelectorAll('.equipment-item'));
    var buttons = Array.prototype.slice.call(document.querySelectorAll('.equipment-add-button'));
    var summaryItems = document.getElementById('summaryItems');
    var summaryEmpty = document.getElementById('summaryEmpty');
    var summaryTotal = document.getElementById('summaryTotal');
    var unitCount = document.getElementById('summaryUnitCount');
    var continueButton = document.getElementById('continueButton');
    var noEquipment = document.getElementById('noEquipmentMessage');
    var appliedSearchTerm = '';

    function money(value) {
        return '\u20b1' + value.toLocaleString('ph-PH', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
    }

    function applyFilters() {
        var term = appliedSearchTerm;
        var selectedCategory = category.value;
        var visible = 0;

        items.forEach(function (item) {
            var matchesTerm = !term || item.getAttribute('data-equipment-search').indexOf(term) !== -1;
            var matchesCategory = selectedCategory === 'all' || item.getAttribute('data-category') === selectedCategory;
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
        var total = 0;
        var markup = '';

        Object.keys(selected).forEach(function (id) {
            var item = selected[id];
            var lineTotal = item.quantity * item.rate;
            totalUnits += item.quantity;
            total += lineTotal;
            markup += '<div class="rental-staff-summary-item">' +
                '<div><strong>' + item.name + '</strong><span>' + money(item.rate) + ' each</span></div>' +
                '<div class="rental-staff-summary-controls" aria-label="Quantity for ' + item.name + '">' +
                '<button type="button" class="btn btn-sm btn-outline-secondary summary-quantity-button" data-action="decrease" data-id="' + id + '">−</button>' +
                '<span>' + item.quantity + '</span>' +
                '<button type="button" class="btn btn-sm btn-outline-secondary summary-quantity-button" data-action="increase" data-id="' + id + '">+</button>' +
                '<button type="button" class="btn btn-sm btn-link text-danger summary-remove-button" data-action="remove" data-id="' + id + '">Remove</button>' +
                '</div><strong>' + money(lineTotal) + '</strong></div>';
        });

        summaryEmpty.classList.toggle('d-none', totalUnits !== 0);
        summaryItems.querySelectorAll('.rental-staff-summary-item').forEach(function (node) { node.remove(); });
        summaryItems.insertAdjacentHTML('afterbegin', markup);
        unitCount.textContent = totalUnits + (totalUnits === 1 ? ' unit' : ' units');
        summaryTotal.textContent = money(total);
        continueButton.disabled = totalUnits === 0;
        bindSummaryButtons();
    }

    function addItem(button) {
        var id = button.getAttribute('data-equipment-id');
        var current = selected[id];
        var stock = Number(button.getAttribute('data-equipment-stock'));

        if (!current) {
            selected[id] = {
                name: button.getAttribute('data-equipment-name'),
                rate: Number(button.getAttribute('data-equipment-rate')),
                rentalFee: Number(button.getAttribute('data-equipment-rental-fee')),
                securityDeposit: Number(button.getAttribute('data-equipment-security-deposit')),
                stock: stock,
                quantity: 1
            };
        } else if (current.quantity < current.stock) {
            current.quantity++;
        }

        button.disabled = selected[id].quantity >= stock;
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
                button.disabled = selected[id] && selected[id].quantity >= item.stock;
            }
        });
        renderSummary();
    }

    function bindSummaryButtons() {
        Array.prototype.slice.call(document.querySelectorAll('.summary-quantity-button, .summary-remove-button')).forEach(function (button) {
            button.addEventListener('click', function () {
                changeQuantity(button.getAttribute('data-id'), button.getAttribute('data-action'));
            });
        });
    }

    buttons.forEach(function (button) {
        button.addEventListener('click', function () { addItem(button); });
    });
    search.addEventListener('keydown', function (event) {
        if (event.key === 'Enter') {
            event.preventDefault();
            appliedSearchTerm = search.value.toLowerCase().trim();
            applyFilters();
        }
    });
    continueButton.addEventListener('click', function () {
        if (!continueButton.disabled) {
            window.location.href = continueButton.getAttribute('data-next-url');
        }
    });
    category.addEventListener('change', applyFilters);
}());
