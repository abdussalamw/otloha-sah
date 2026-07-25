function HandleFormErrors(error, validator) {
  if (error.status === 422) {
    console.log(error)
    console.log(error['responseJSON'])
    for (const field in error['responseJSON'])
      if (error['responseJSON'].hasOwnProperty(field))
        validator
          .updateValidatorOption(field, 'blank', 'message', error['responseJSON'][field])
          .updateFieldStatus(field, 'Invalid', 'blank')
  }
}

window.HandleFormErrors = HandleFormErrors
