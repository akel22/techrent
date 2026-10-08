document.addEventListener("DOMContentLoaded", function () {
    var markDoneModalElement = document.getElementById("markDoneModal");
    var markDoneModal = new bootstrap.Modal(markDoneModalElement);
    var returnConditionNotes = document.getElementById("returnConditionNotes");
    var returnConditionCount = document.getElementById("returnConditionCount");
    var selectedTransactionIdHidden = document.getElementById("SelectedTransactionIdHidden");
    var returnConditionNotesHidden = document.getElementById("ReturnConditionNotesHidden");
    var additionalChargesHidden = document.getElementById("AdditionalChargesHidden");
    var additionalCharges = document.getElementById("additionalCharges");
    var additionalChargesEmpty = document.getElementById("additionalChargesEmpty");
    var addAdditionalCharge = document.getElementById("addAdditionalCharge");
    var selectedRow;

    function updateChargesEmptyState() {
        additionalChargesEmpty.hidden = additionalCharges.children.length > 0;
    }

    function createSelect(className, options) {
        var select = document.createElement("select");
        select.className = "form-select " + className;
        options.forEach(function (option) {
            var optionElement = document.createElement("option");
            optionElement.value = option;
            optionElement.textContent = option;
            select.appendChild(optionElement);
        });
        return select;
    }

    function addChargeRow() {
        var row = document.createElement("div");
        row.className = "row g-2 align-items-end additional-charge-row";

        var typeColumn = document.createElement("div");
        typeColumn.className = "col-md-4";
        var typeLabel = document.createElement("label");
        typeLabel.className = "form-label small mb-1";
        typeLabel.textContent = "Charge type";
        var type = createSelect("additional-charge-type", ["LateFee", "DamageCharge"]);
        typeColumn.appendChild(typeLabel);
        typeColumn.appendChild(type);

        var amountColumn = document.createElement("div");
        amountColumn.className = "col-md-3";
        var amountLabel = document.createElement("label");
        amountLabel.className = "form-label small mb-1";
        amountLabel.textContent = "Amount";
        var amount = document.createElement("input");
        amount.type = "number";
        amount.min = "0";
        amount.step = "0.01";
        amount.inputMode = "decimal";
        amount.className = "form-control additional-charge-amount";
        amount.placeholder = "0.00";
        amount.required = true;
        amountColumn.appendChild(amountLabel);
        amountColumn.appendChild(amount);

        var methodColumn = document.createElement("div");
        methodColumn.className = "col-md-3";
        var methodLabel = document.createElement("label");
        methodLabel.className = "form-label small mb-1";
        methodLabel.textContent = "Payment method";
        var method = createSelect("additional-charge-method", ["Cash", "GCash"]);
        methodColumn.appendChild(methodLabel);
        methodColumn.appendChild(method);

        var removeColumn = document.createElement("div");
        removeColumn.className = "col-md-2 d-grid";
        var remove = document.createElement("button");
        remove.type = "button";
        remove.className = "btn btn-outline-danger";
        remove.textContent = "Remove";
        remove.addEventListener("click", function () {
            row.remove();
            updateChargesEmptyState();
        });
        removeColumn.appendChild(remove);

        row.appendChild(typeColumn);
        row.appendChild(amountColumn);
        row.appendChild(methodColumn);
        row.appendChild(removeColumn);
        additionalCharges.appendChild(row);
        updateChargesEmptyState();
    }

    function serializeCharges() {
        var charges = [];
        var valid = true;
        additionalCharges.querySelectorAll(".additional-charge-row").forEach(function (row) {
            var amount = row.querySelector(".additional-charge-amount");
            var value = Number(amount.value);
            amount.classList.remove("is-invalid");
            if (!amount.value || !Number.isFinite(value) || value < 0) {
                amount.classList.add("is-invalid");
                valid = false;
                return;
            }

            charges.push({
                paymentType: row.querySelector(".additional-charge-type").value,
                amount: amount.value,
                paymentMethod: row.querySelector(".additional-charge-method").value
            });
        });

        if (valid) {
            additionalChargesHidden.value = JSON.stringify(charges);
        }

        return valid;
    }

    window.prepareCompletionSubmission = function () {
        return serializeCharges();
    };

    function updateNotesCount() {
        returnConditionCount.textContent = returnConditionNotes.value.length + " / 500";
    }

    function saveAuditValues() {
        if (!selectedRow) {
            return;
        }

        selectedRow.dataset.returnConditionNotes = returnConditionNotes.value;
    }

    document.querySelectorAll("[data-mark-done]").forEach(function (button) {
        button.addEventListener("click", function () {
            selectedRow = button.closest("[data-transaction-row]");
            selectedTransactionIdHidden.value = selectedRow.dataset.transactionCode;

            markDoneModalElement.querySelector("[data-modal-transaction]").textContent = selectedRow.dataset.transactionCode;
            markDoneModalElement.querySelector("[data-modal-customer]").textContent = selectedRow.dataset.customerName;
            markDoneModalElement.querySelector("[data-modal-customer-id]").textContent = selectedRow.dataset.customerId;
            markDoneModalElement.querySelector("[data-modal-due-date]").textContent = selectedRow.dataset.dueDate;
            markDoneModalElement.querySelector("[data-modal-status]").textContent = selectedRow.querySelector("[data-transaction-status]").textContent;
            returnConditionNotes.value = selectedRow.dataset.returnConditionNotes || "";
            returnConditionNotesHidden.value = returnConditionNotes.value;
            additionalCharges.innerHTML = "";
            additionalChargesHidden.value = "[]";
            updateChargesEmptyState();
            updateNotesCount();

            markDoneModal.show();
        });
    });

    returnConditionNotes.addEventListener("input", function () {
        updateNotesCount();
        saveAuditValues();
        returnConditionNotesHidden.value = returnConditionNotes.value;
    });

    addAdditionalCharge.addEventListener("click", addChargeRow);
});
