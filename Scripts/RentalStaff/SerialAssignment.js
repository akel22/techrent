(function () {
    var selects = Array.prototype.slice.call(document.querySelectorAll('.serial-select'));
    var form = document.getElementById('serialAssignmentForm');
    var assignedUnitCount = document.getElementById('assignedUnitCount');
    var requiredUnitCount = document.getElementById('requiredUnitCount');
    var assignmentProgress = document.getElementById('assignmentProgress');
    var assignmentStatus = document.getElementById('assignmentStatus');
    var assignmentAlert = document.getElementById('assignmentAlert');
    var finalizeButton = document.getElementById('finalizeAssignmentButton');
    var finalizeMessage = document.getElementById('finalizeAssignmentMessage');

    function refresh() {
        var assigned = selects.filter(function (select) { return select.value !== ''; }).length;
        var required = selects.length;
        var complete = assigned === required;
        var percentage = required ? Math.round((assigned / required) * 100) : 0;

        assignedUnitCount.textContent = assigned;
        requiredUnitCount.textContent = required;
        assignmentProgress.style.width = percentage + '%';
        assignmentProgress.parentElement.setAttribute('aria-valuenow', assigned);
        assignmentStatus.textContent = complete ? 'Ready' : 'Incomplete';
        assignmentStatus.classList.toggle('text-bg-warning', !complete);
        assignmentStatus.classList.toggle('text-bg-success', complete);
        assignmentAlert.classList.toggle('d-none', complete);
        finalizeMessage.textContent = complete
            ? 'All serial numbers are assigned. Continue to the rental details review.'
            : 'All units must have a serial number before continuing.';

        Array.prototype.slice.call(document.querySelectorAll('[data-group-status]')).forEach(function (status) {
            var groupSelects = selects.filter(function (select) {
                return select.getAttribute('data-equipment') === status.getAttribute('data-group-status');
            });
            var groupAssigned = groupSelects.filter(function (select) { return select.value !== ''; }).length;
            var groupComplete = groupAssigned === groupSelects.length;
            status.textContent = groupAssigned + ' / ' + groupSelects.length + ' assigned';
            status.classList.toggle('text-bg-warning', !groupComplete);
            status.classList.toggle('text-bg-success', groupComplete);
        });
    }

    selects.forEach(function (select) {
        select.addEventListener('change', refresh);
    });

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
        finalizeMessage.textContent = 'Serial assignment is complete. Opening the rental details review.';
        var nextUrl = finalizeButton.getAttribute('data-next-url');
        if (nextUrl) {
            window.location.href = nextUrl;
        }
    });

    refresh();
}());
