var addProviderForm = function () {
  var modal,
      form,
      modalToggle,
      title,
      action,
      originalAction,
      closeModal,
      validator


  function initProviderFormModal() {
    modalToggle.on('click', function () {
      var $this = $(this),
          editing = $this.data('editing') !== undefined

      if (editing) {
        action = $this.data('action')
      }

      title.text(getModalTitle({
        editing,
        edit: {
          text: gettext('Edit Provider %s'),
          formatText: [$this.data('title')]
        },
        create: {text: gettext('Add New Provider')},
      }))

      closeModal.on("click", function (e) {
        e.preventDefault()
        handleFormModalClose(modal, form)
        action = originalAction
      })
    })
  }

  return {
    init: function () {
      modalToggle = $('.provider-modal-toggle')
      modal = new bootstrap.Modal(document.querySelector('#provider_form_modal'))
      form = $('#provider_form')
      title = $('#provider_form_title')
      closeModal = $('.close-modal-toggle')
      originalAction = form.attr('action')


      initProviderFormModal()
    }
  }
}()


document.addEventListener('DOMContentLoaded', addProviderForm.init);
if (document.readyState !== 'loading' && document.body)
  addProviderForm.init()