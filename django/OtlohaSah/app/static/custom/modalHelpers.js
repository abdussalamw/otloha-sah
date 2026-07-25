function handleFormModalClose(modal, form) {
  return Swal.fire({
    text: gettext("Are you sure you would like to cancel?"),
    icon: "warning",
    showCancelButton: true,
    buttonsStyling: false,
    confirmButtonText: gettext("Yes, cancel it!"),
    cancelButtonText: gettext("No, return"),
    customClass: {
      confirmButton: "btn btn-primary",
      cancelButton: "btn btn-active-light"
    }
  }).then(function (result) {
    if (result.value) {
      form[0].reset();
      modal.hide();
    } else if (result.dismiss === 'cancel') {
      Swal.fire({
        text: gettext("Your form has not been cancelled!."),
        icon: "error",
        buttonsStyling: false,
        confirmButtonText: gettext("Ok, got it!"),
        customClass: {
          confirmButton: "btn btn-primary",
        }
      });
    }
  });
}


function handleConfirm(options, callback, site=false) {
  return Swal.fire({
    text: options.message,
    icon: "warning",
    showCancelButton: true,
    buttonsStyling: false,
    confirmButtonText: options.confirm,
    cancelButtonText: gettext("No, return"),
    customClass: {
      confirmButton: site? "btn btn--primary": "btn btn-primary",
      cancelButton: site? "btn btn--danger": "btn btn-active-light"
    }
  }).then(function (result) {
    if (result.value) {
      callback()
    } else if (result.dismiss === 'cancel') {
      Swal.fire({
        text: gettext("Your action has not been cancelled!."),
        icon: "error",
        buttonsStyling: false,
        confirmButtonText: gettext("Ok, got it!"),
        customClass: {
          confirmButton: site? "btn btn--primary": "btn btn-primary",
        }
      });
    }
  });
}

function getModalTitle(options) {
  function resolveText(item) {
    if (item['formatText'])
      return interpolate(item['text'], [...item['formatText']])

    return item['text']
  }

  return resolveText(options.editing ? options['edit'] : options['create'])
}

window.handleFormModalClose = handleFormModalClose
window.getModalTitle = getModalTitle
window.handleConfirm = handleConfirm