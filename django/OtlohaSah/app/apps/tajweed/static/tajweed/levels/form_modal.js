var LevelFormModal = function () {

    var LevelFormModal

  function initializeFormModal() {
    LevelFormModal = FormModal.setOptions("levels", {
      title: {
        create: {
          text: gettext('Add New Level')
        },
        edit: {
          text: gettext('Edit Level')
        }
      },
      onClickCallback: function (element,e) {
        var name = $(LevelFormModal.form).find('#id_name')

                if ($(element).data('form-edit-mode')) {
                    var details = $(element).data('form-details')
                    name.val(JSON.stringify(details.name))
                    TranslationWidget.createInstances()
                }
                TranslationWidget.createInstances()

            },
            onSubmitCallback: function (res) {
                LevelFormModal.modal.hide()
                toastr.success(res['message'])
                location.reload()
            }
        })
    }

    return {
        init() {
            initializeFormModal()
        }
    }
}()

if (document.readyState !== 'loading' && document.body) {
    LevelFormModal.init()
} else {
    document.addEventListener('DOMContentLoaded', LevelFormModal.init)
}
