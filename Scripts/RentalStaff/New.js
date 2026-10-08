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
        var element = document.getElementById(id);
        if (element) {
            element.textContent = value || 'Not provided';
        }
    }

    function getImageMimeType(imageData) {
        if (imageData.indexOf('/9j/') === 0) {
            return 'image/jpeg';
        }

        if (imageData.indexOf('iVBORw0KGgo') === 0) {
            return 'image/png';
        }

        return 'image/jpeg';
    }

    function populateDetails(row) {
        setDetail('customerDetailId', row.getAttribute('data-customer-id'));
        setDetail('customerDetailFirstName', row.getAttribute('data-first-name'));
        setDetail('customerDetailLastName', row.getAttribute('data-last-name'));
        setDetail('customerDetailEmail', row.getAttribute('data-email'));
        setDetail('customerDetailMobile', row.getAttribute('data-mobile-number'));
        setDetail('customerDetailTelephone', row.getAttribute('data-telephone-number'));
        setDetail('customerDetailOccupation', row.getAttribute('data-occupation'));
        setDetail('customerDetailAddress', row.getAttribute('data-organization-address'));
        setDetail('customerDetailStatus', row.getAttribute('data-account-status'));
        var image = document.getElementById('customerProfileImage');
        var placeholder = document.getElementById('customerProfileImagePlaceholder');
        var imageData = row.getAttribute('data-image');
        if (imageData) {
            image.src = 'data:' + getImageMimeType(imageData) + ';base64,' + imageData;
            image.classList.remove('d-none');
            placeholder.classList.add('d-none');
        } else {
            image.removeAttribute('src');
            image.classList.add('d-none');
            placeholder.classList.remove('d-none');
        }
        var selectButton = document.getElementById('customerDetailSelectButton');
        if (selectButton) {
            selectButton.href = selectButton.href.split('?')[0] + '?customerId=' + encodeURIComponent(row.getAttribute('data-customer-id'));
        }
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
