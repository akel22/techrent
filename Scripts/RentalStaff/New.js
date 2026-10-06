(function () {
    var search = document.getElementById('customerSearch');
    var rows = Array.prototype.slice.call(document.querySelectorAll('#customerList tr'));
    var count = document.getElementById('customerCount');
    var emptyMessage = document.getElementById('noCustomersMessage');
    var detailsModal = document.getElementById('customerDetailsModal');

    function filterCustomers() {
        var term = search.value.toLowerCase().trim();
        var visible = 0;

        rows.forEach(function (row) {
            var matches = !term || row.getAttribute('data-customer-search').indexOf(term) !== -1;
            row.classList.toggle('d-none', !matches);
            if (matches) {
                visible++;
            }
        });

        count.textContent = visible + (visible === 1 ? ' customer' : ' customers');
        emptyMessage.classList.toggle('d-none', visible !== 0);
    }

    function setDetail(id, value) {
        document.getElementById(id).textContent = value || 'Not provided';
    }

    function populateDetails(row) {
        setDetail('customerDetailId', row.getAttribute('data-customer-id'));
        setDetail('customerDetailFirstName', row.getAttribute('data-first-name'));
        setDetail('customerDetailLastName', row.getAttribute('data-last-name'));
        setDetail('customerDetailEmail', row.getAttribute('data-email'));
        setDetail('customerDetailMobile', row.getAttribute('data-mobile-number'));
        setDetail('customerDetailTelephone', row.getAttribute('data-telephone-number'));
        setDetail('customerDetailOrganization', row.getAttribute('data-organization'));
        setDetail('customerDetailAddress', row.getAttribute('data-address'));
        setDetail('customerDetailStatus', row.getAttribute('data-account-status'));
    }

    search.addEventListener('keydown', function (event) {
        if (event.key === 'Enter') {
            event.preventDefault();
            filterCustomers();
        }
    });

    detailsModal.addEventListener('show.bs.modal', function (event) {
        var button = event.relatedTarget;
        var row = button.closest('tr');
        if (row) {
            populateDetails(row);
        }
    });
}());
