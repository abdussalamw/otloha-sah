var Filters = function () {
  var filterForm, datesFilter, selectEls

  function submit() {
    $.ajax({
      url: filterForm.action,
      data: $(filterForm).serialize(),
      type: 'GET',
      success: function (data) {
        CircleChart.refresh(data)
        WorldMap.refresh(data)
      }
    })
  }

  function initialize() {
    datesFilter.flatpickr();
    selectEls.select2().val(null).trigger('change');
    filterForm.addEventListener('submit', function (e) {
      e.preventDefault()
      submit()

    })
    filterForm.addEventListener('reset', function (e) {
      datesFilter.flatpickr('clear')
      selectEls.select2().val(null).trigger('change');
      filterForm.reset()
      submit()
    })
  }

  return {
    init() {
      filterForm = document.getElementById('filter-form')
      datesFilter = $('[data-filter="date"]')
      selectEls = $('[data-filter="select"]')
      initialize()
    }
  }
}()
KTUtil.onDOMContentLoaded(function () {
  Filters.init();
});

