$(function () {
  'use strict'

  var setInputValue = function ($input, inputType) {
    switch (inputType){
      case "radio":
      case "checkbox":
        $($input).attr('checked', 'checked')
        break
    }
  }

  $('.filters-form').each(function () {
    var form = $(this)
    var params = new URLSearchParams(window.location.search)

    form.find(":input").each(function () {
      var name = $(this).attr('name'),
        type = $(this).attr('type'),
        values = params.getAll(name)

      if (values.includes($(this).val()))
        setInputValue(this, type)

      $(this).on('input', function () {
        form.submit()
      })
    })
  })

})