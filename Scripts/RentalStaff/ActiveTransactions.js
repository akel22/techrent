document.addEventListener("DOMContentLoaded", function () {
    document.querySelectorAll("[data-mark-done]").forEach(function (button) {
        button.addEventListener("click", function () {
            var row = button.closest("[data-transaction-row]");
            var status = row.querySelector("[data-transaction-status]");

            status.textContent = "Done";
            status.classList.remove("status-ongoing");
            status.classList.add("status-done");
            button.textContent = "Done";
            button.classList.remove("btn-success");
            button.classList.add("btn-outline-secondary");
            button.disabled = true;
        });
    });
});
