var WorldMap = function () {
  var mapEl, data, direction, root, chart, tooltip, colors, bubbleSeries;

  function initRoot() {
    root = am5.Root.new("map");
    root.setThemes([am5themes_Animated.new(root)]);
    colors = am5.ColorSet.new(root, {});
  }

  function initTooltip() {
    tooltip = am5.Tooltip.new(root, {});
    tooltip.label.setAll({
      fontSize: 14,
      fontWeight: "bold",
      padding: 10,
      fill: am5.color(0xffffff),
      cornerType: "rounded",
      pointerLength: 0,
      pointerBaseWidth: 0,
      direction
    });
  }

  function initChart() {
    chart = root.container.children.push(am5map.MapChart.new(root, {
      panX: "translateX", panY: "translateY", projection: am5map.geoMercator(),
      tooltip

    }));
  }

  function initPolygons() {
    var polygonSeries = chart.series.push(am5map.MapPolygonSeries.new(root, {
      geoJSON: am5geodata_worldLow, exclude: ["AQ"]
    }));

    polygonSeries.mapPolygons.template.setAll({
      tooltipText: "{name}",
      toggleKey: "active",
      interactive: true,
    });

    polygonSeries.mapPolygons.template.states.create("hover", {
      fill: root.interfaceColors.get("primaryButtonHover")
    });
  }

  function initZoomControl() {
    chart.set("zoomControl", am5map.ZoomControl.new(root, {}));
    chart.chartContainer.get("background").events.on("click", function () {
      chart.goHome();
    })
  }

  function initBubbles() {
    bubbleSeries = chart.series.push(
      am5map.MapPointSeries.new(root, {
        valueField: "count",
        calculateAggregates: true,
        polygonIdField: "code"
      })
    );

    var circleTemplate = am5.Template.new({});

    bubbleSeries.bullets.push(function (root, series, dataItem) {
      var container = am5.Container.new(root, {});

      var circle = container.children.push(
        am5.Circle.new(root, {
          radius: 20,
          fillOpacity: 0.7,
          // fill: am5.color(0x50cd89),
          cursorOverStyle: "pointer",
          tooltip
        }, circleTemplate)
      );

      return am5.Bullet.new(root, {
        sprite: container,
        dynamic: true
      });
    });

    bubbleSeries.bullets.push(function (root, series, dataItem) {
      return am5.Bullet.new(root, {
        sprite: am5.Label.new(root, {
          text: "{value.formatNumber('#.')}",
          fill: am5.color(0xff0000),
          populateText: true,
          centerX: am5.p50,
          centerY: am5.p50,
          textAlign: "center"
        }),
        dynamic: true
      });
    });

    bubbleSeries.set("heatRules", [
      {
        target: circleTemplate,
        dataField: "value",
        min: 10,
        max: 50,
        minValue: 0,
        maxValue: 100,
        key: "radius"
      }
    ]);

    bubbleSeries.data.setAll(data);
  }


  function initialize() {
    am5.ready(function () {
      initRoot()
      initTooltip()
      initChart()
      initZoomControl()
      initPolygons()
      initBubbles()
      chart.appear(1000, 100);
    })
  }

  return {
    init() {
      direction = document.documentElement.getAttribute('dir');
      mapEl = document.getElementById('map');
      data = JSON.parse(mapEl.dataset.items);
      initialize()
    },
    refresh(jsonData) {
      data = JSON.parse(jsonData['countries'])
      root.dispose()
      initialize()
    }
  }
}()

KTUtil.onDOMContentLoaded(function () {
  WorldMap.init();
});


