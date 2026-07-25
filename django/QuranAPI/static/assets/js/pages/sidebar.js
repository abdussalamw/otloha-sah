$(function () {
  "use strict";
  var renderSidebarItem = function (item, options = {}) {
      if (Object.keys(options).length > 0)
        item = $.extend({}, item, options)

      return ` <li class="nav-item${item.has_children ? " menu-open" : ""}">
        <a href="${item.has_children ? "javascript:void(0)" : item.url}"
           class="nav-link${item.is_active ? " active" : ""}">
          <i class="nav-icon ${item.icon}"></i>
          <p>${item.title}</p>
        </a>
        ${item.has_children ? `<ul class="nav nav-treeview">
          ${item.children.map(function (child) {
        return renderSidebarItem(child, {icon: "far fa-circle"})
      }).join('')}
        </ul>` : ""}
      </li>`
    },
    renderSidebarHeader = function (item) {
      return `<li class="nav-header">${item.title}</li>`
    },
    renderSidebar = function (items) {
      return items.map(function (item) {
        var navItem = ''
        switch (item.type) {
          case "header":
            navItem = renderSidebarHeader(item)
            break
          default:
            navItem = renderSidebarItem(item)
        }
        return navItem
      }).join("")
    }

  $('.sidebar').each(function () {
    var self = $(this),
      searchInput = self.find('.form-control-sidebar'),
      nav = self.find('.nav-sidebar'),
      originalList = self.data('list')

    if (originalList) {
      nav.html($(renderSidebar(originalList)))
    }

    searchInput.on('input',function () {
        var search = $(this).val()
        nav.html($(renderSidebar(originalList.filter(function (item) {
          return item.title.indexOf(search.toLowerCase()) !== -1
        }))))
      })
  })

})



