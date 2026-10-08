document.addEventListener("DOMContentLoaded", function () {
    var markDoneModalElement = document.getElementById("markDoneModal");
    var markDoneModal = new bootstrap.Modal(markDoneModalElement);
    var returnConditionNotes = document.getElementById("returnConditionNotes");
    var returnConditionCount = document.getElementById("returnConditionCount");
    var selectedTransactionIdHidden = document.getElementById("SelectedTransactionIdHidden");
    var returnConditionNotesHidden = document.getElementById("ReturnConditionNotesHidden");
    var selectedRow;

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
            updateNotesCount();

            markDoneModal.show();
        });
    });

    returnConditionNotes.addEventListener("input", function () {
        updateNotesCount();
        saveAuditValues();
        returnConditionNotesHidden.value = returnConditionNotes.value;
    });
});
