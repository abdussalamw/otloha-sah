"use strict";

var CircleChart = function () {
  var cards

  function createCategorySection(category) {
    var section = document.createElement('div'),
      bullet = document.createElement('div'),
      labelDiv = document.createElement('div'),
      countDiv = document.createElement('div'),
      color = category.is_variable_color ? KTUtil.getCssVariableValue(category.color) : category.color;

    section.classList.add('d-flex', 'fs-6', 'fw-semibold', 'align-items-center');

    bullet.classList.add('bullet', 'w-8px', 'h-6px', 'rounded-2', 'me-3');
    bullet.style.backgroundColor = color;

    labelDiv.classList.add('text-gray-500', 'flex-grow-1', 'me-4');
    labelDiv.textContent = category.label

    countDiv.classList.add('fw-bolder', 'text-gray-700', 'text-xxl-end');
    countDiv.textContent = category.value

    section.appendChild(bullet);
    section.appendChild(labelDiv);
    section.appendChild(countDiv);

    return section;
  }

  function createChartDiv(data) {
    var container = document.createElement('div'),
      chartDiv = document.createElement('div'),
      canvas = document.createElement('canvas'),
      span = document.createElement('span'),
      ctx = canvas.getContext('2d'),
      options = {
        size: data.conf.size ? parseInt(data.conf.size) : 70,
        lineWidth: data.conf.line_width ? parseInt(data.conf.line_width) : 11,
      }
    container.classList.add('d-flex', 'flex-center', 'pt-2', 'me-5');

    chartDiv.style.minWidth = `${options.size}px`
    chartDiv.style.minHeight = `${options.size}px`

    if (typeof (G_vmlCanvasManager) !== 'undefined') {
      G_vmlCanvasManager.initElement(canvas);
    }

    canvas.width = canvas.height = options.size;
    chartDiv.appendChild(span);
    chartDiv.appendChild(canvas);
    ctx.translate(options.size / 2, options.size / 2);

    var radius = (options.size - options.lineWidth) / 2;

    drawPieChart(ctx, radius, data.categories);

    container.appendChild(chartDiv)
    return container;
  }

  function ChartCard(data) {
    // Create the main card element
    var card = document.createElement('div');
    card.classList.add('card', 'card-flush');

    // Create the card header
    var cardHeader = document.createElement('div');
    cardHeader.classList.add('card-header', 'pt-5');

    // Create the card title
    var cardTitle = document.createElement('div');
    cardTitle.classList.add('card-title', 'd-flex', 'flex-column');

    var countSpan = document.createElement('span');
    countSpan.classList.add('fs-2hx', 'fw-bold', 'text-dark', 'me-2', 'lh-1', 'ls-n2');
    countSpan.textContent = data.total

    var titleSpan = document.createElement('span');
    titleSpan.classList.add('text-gray-600', 'pt-1', 'fw-semibold', 'fs-4');
    titleSpan.textContent = data.label

    cardTitle.appendChild(countSpan);
    cardTitle.appendChild(titleSpan);

    // Append title to header
    cardHeader.appendChild(cardTitle);

    // Create the card body
    var cardBody = document.createElement('div');
    cardBody.classList.add('card-body', 'pt-2', 'pb-4', 'd-flex', 'align-items-center');

    // Create the circular chart div
    var chartDiv = createChartDiv(data);

    // Create the content for categories
    var categoryDiv = document.createElement('div');
    categoryDiv.classList.add('d-flex', 'flex-column', 'content-justify-center', 'w-100');

    for (var category of data.categories) {
      categoryDiv.appendChild(createCategorySection(category));
    }

    // Append chart and categories to card body
    cardBody.appendChild(chartDiv);
    cardBody.appendChild(categoryDiv);

    // Append header and body to the main card element
    card.appendChild(cardHeader);
    card.appendChild(cardBody);

    // Return the fully constructed card element
    return card;
  }

  function drawPieChart(ctx, radius, categories) {
    var totalPercentage = categories.reduce(function (acc, category) {
      return acc + category.percentage;
    }, 0);

    var startAngle = -Math.PI / 2;

    for (var category of categories) {
      var endAngle = startAngle + (2 * Math.PI * (category.percentage / totalPercentage)),
        color = category.is_variable_color ? KTUtil.getCssVariableValue(category.color) : category.color

      ctx.beginPath();
      ctx.moveTo(0, 0);
      ctx.arc(0, 0, radius, startAngle, endAngle, false);
      ctx.closePath();
      ctx.fillStyle = color;
      ctx.fill();

      startAngle = endAngle;
    }
  }

  function initialize() {
    cards.forEach(function (card) {
      var data = JSON.parse(card.getAttribute('data-circle-chart-data'));
      card.appendChild(ChartCard(data));
    })
  }

  return {
    init: function () {
      cards = document.querySelectorAll('[data-circle-chart-card]');
      initialize();
    },
    refresh(data) {
      cards = document.querySelectorAll('[data-circle-chart-card]');
      cards.forEach(function (card) {
        var chartData = JSON.parse(data['charts_data'][card.getAttribute('data-circle-chart-card')]);
        card.innerHTML = '';
        card.appendChild(ChartCard(chartData));
      });
    }
  }
}();

KTUtil.onDOMContentLoaded(function () {
  CircleChart.init();
});




