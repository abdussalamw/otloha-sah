var GrantGroupAccessForm = function () {
  var modal, modalEl, formEl, cancelButton

  function initialize() {


    cancelButton.forEach(function (button) {
      button.addEventListener('click', function (e) {
        $("#id_users").val(null).trigger('change');
      })
    })
  }

  return {
    init() {
      modalEl = document.getElementById('modal-group-admins')
      modal = new bootstrap.Modal(modalEl)
      formEl = document.getElementById('modal-group-admins-form')
      cancelButton = modalEl.querySelectorAll('[data-bs-dismiss="modal"]')

      initialize()
    }
  }
}()


if (document.readyState !== 'loading' && document.body) {
  GrantGroupAccessForm.init()
} else {
  document.addEventListener('DOMContentLoaded', GrantGroupAccessForm.init)
}
