var Permissions = function () {
  var modelSelectAllCheckboxes, permissionsCheckboxes, appSelectAllCheckboxes, adminSelectAllCheckbox;

  function updateCheckboxes(targetCheckboxes, isChecked) {
    targetCheckboxes.forEach(function (checkbox) {
      checkbox.checked = isChecked;
    });
  }

  function updateSelectAllCheckbox(targetCheckboxes, selectAllCheckbox) {
    selectAllCheckbox.checked = Array.from(targetCheckboxes).every(function (checkbox) {
      return checkbox.checked;
    });
  }

  function groupPermissionsByAppAndModel() {
    var groupedPermissions = {};

    permissionsCheckboxes.forEach(function (checkbox) {
      var app = checkbox.getAttribute('data-app');
      var model = checkbox.getAttribute('data-model');

      if (!groupedPermissions[app]) {
        groupedPermissions[app] = {};
      }

      if (!groupedPermissions[app][model]) {
        groupedPermissions[app][model] = [];
      }

      groupedPermissions[app][model].push(checkbox);
    });

    return groupedPermissions;
  }

  function initHandlers() {
    adminSelectAllCheckbox.addEventListener('change', function (e) {
      var checkboxes = document.querySelectorAll('[data-permission-select], [data-model-select], [data-app-select]');

      updateCheckboxes(checkboxes, e.target.checked);
    });

    appSelectAllCheckboxes.forEach(function (checkbox) {
      checkbox.addEventListener('change', function (e) {
        var app = checkbox.getAttribute('data-app-select')

        updateCheckboxes(
          document.querySelectorAll(`[data-app="${app}"]`),
          e.target.checked);

        updateSelectAllCheckbox(
          document.querySelectorAll('[data-permission-select], [data-model-select], [data-app-select]'),
          adminSelectAllCheckbox
        );
      })
    });

    modelSelectAllCheckboxes.forEach(function (checkbox) {
      checkbox.addEventListener('change', function (e) {
        var model = checkbox.getAttribute('data-model-select'),
          app = checkbox.getAttribute('data-app')

        updateCheckboxes(
          document.querySelectorAll(`[data-model="${model}"]`),
          e.target.checked
        );

        updateSelectAllCheckbox(document.querySelectorAll(`[data-app="${app}"]`), document.querySelector(`[data-app-select="${app}"]`));

        updateSelectAllCheckbox(document.querySelectorAll('[data-permission-select], [data-model-select], [data-app-select]'), adminSelectAllCheckbox);
      })
    });

    permissionsCheckboxes.forEach(function (checkbox) {
      checkbox.addEventListener('change', function (e) {
        var model = checkbox.getAttribute('data-model'),
          app = checkbox.getAttribute('data-app')

        updateSelectAllCheckbox(
          document.querySelectorAll(`[data-model="${model}"]`),
          document.querySelector(`[data-model-select="${model}"]`)
        );
        updateSelectAllCheckbox(
          document.querySelectorAll(`[data-app="${app}"]`),
          document.querySelector(`[data-app-select="${app}"]`)
        );
        updateSelectAllCheckbox(
          document.querySelectorAll('[data-permission-select], [data-model-select], [data-app-select]'),
          adminSelectAllCheckbox
        );

      });
    });
  }


  function initialize() {
    var apps = groupPermissionsByAppAndModel();
    for (var app in apps) {
      if (apps.hasOwnProperty(app)) {
        var models = apps[app];
        for (var model in models) {
          if (models.hasOwnProperty(model)) {
            updateSelectAllCheckbox(
              document.querySelectorAll(`[data-model="${model}"][data-app="${app}"]`),
              document.querySelector(`[data-model-select="${model}"][data-app="${app}"]`)
            )
          }
        }
        updateSelectAllCheckbox(
          document.querySelectorAll(`[data-app="${app}"]`),
          document.querySelector(`[data-app-select="${app}"]`)
        )
      }
    }
    updateSelectAllCheckbox(
      document.querySelectorAll('[data-permission-select], [data-model-select], [data-app-select]'),
      adminSelectAllCheckbox
    );
  }

  return {
    init() {
      adminSelectAllCheckbox = document.getElementById('admin-select-all')
      appSelectAllCheckboxes = document.querySelectorAll('[data-app-select]')
      modelSelectAllCheckboxes = document.querySelectorAll('[data-model-select]')
      permissionsCheckboxes = document.querySelectorAll('[data-permission-select]')

      initHandlers()
      initialize()
    }
  }
}()

if (document.readyState !== 'loading' && document.body) {
  Permissions.init()
} else {
  document.addEventListener('DOMContentLoaded', Permissions.init)
}