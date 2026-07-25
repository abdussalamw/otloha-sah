import {Component, Element, h, Prop, Watch} from '@stencil/core';
import * as am5 from "@amcharts/amcharts5";
import * as am5map from "@amcharts/amcharts5/map";
import am5themes_Animated from "@amcharts/amcharts5/themes/Animated";
import am5geodata_worldLow from "../../../utils/amcharts5-geodata/worldLow";


@Component({
  tag: 'world-heatmap',
  shadow: false,
})
export class WorldHeatmap {
  @Element() el: HTMLElement;
  @Prop() heatData: { code: string; count: number }[] = [];

  private root: am5.Root;
  private chart: am5map.MapChart;
  private tooltip?: am5.Tooltip;
  private polygonSeries?: am5map.MapPolygonSeries;
  private maxCount: number = 0;

  @Watch('heatData')
  heatDataChanged() {
    if (this.chart && this.polygonSeries) {
      this.maxCount = Math.max(...this.heatData.map(item => item.count))
      this.updateChartData();
    }
  }

  componentDidLoad() {
    this.initializeChart();
  }

  disconnectedCallback() {
    if (this.root) {
      this.root.dispose();
    }
  }

  setTooltip() {
    // @ts-ignore
    this.tooltip = am5.Tooltip.new(this.root, {});
    this.tooltip.label.setAll({
      fontSize: 14,
      fontWeight: "bold",
      padding: 10,
      fill: am5.color(0xffffff),
      cornerType: "rounded",
      pointerLength: 0,
      pointerBaseWidth: 0,
      direction: document.documentElement.getAttribute('dir') || 'ltr' as 'ltr' | 'rtl'
    } as any);
  }

  setPolygonSeries() {
    // Polygon series (map)
    this.polygonSeries = this.chart.series.push(
      am5map.MapPolygonSeries.new(this.root, {geoJSON: am5geodata_worldLow, exclude: ["AQ"]})
    );
    // @ts-ignore
    this.polygonSeries.mapPolygons.template.setAll({
      tooltipText: "{name} {count}",
      // toggleKey: "active",
      interactive: true,
      templateField: "polygonSettings"
    });
    // @ts-ignore
    this.polygonSeries.mapPolygons.template.states.create("hover", {
      fill: am5.color(0x677935)
    });
  }

  setZoomControl() {
    // @ts-ignore
    this.chart.set("zoomControl", am5map.ZoomControl.new(this.root, {}));
    this.chart.chartContainer.get("background").events.on("click", () => {
      this.chart.goHome();
    });
  }

  initializeChart() {
    // @ts-ignore
    this.root = am5.Root.new(this.el.querySelector('#map'));
    this.root.setThemes([am5themes_Animated.new(this.root)]);
    this.setTooltip()
    this.chart = this.root.container.children.push(am5map.MapChart.new(this.root, {
      panX: "translateX",
      panY: "translateY",
      projection: am5map.geoMercator(),
      tooltip: this.tooltip
    }));
    this.setPolygonSeries()
    this.setZoomControl()
    this.updateChartData()
  }

  getRedShade(count: number) {
    const intensity = count / this.maxCount; // Normalize count to a 0-1 range

    // RGB values for low and high counts
    const lowColor = {r: 215, g: 128, b: 128}; // #d78080
    const highColor = {r: 239, g: 0, b: 0};    // #ef0000

    // Interpolate between lowColor and highColor based on intensity
    const r = Math.floor(lowColor.r + (highColor.r - lowColor.r) * intensity);
    const g = Math.floor(lowColor.g + (highColor.g - lowColor.g) * intensity);
    const b = Math.floor(lowColor.b + (highColor.b - lowColor.b) * intensity);

    // Convert RGB to hexadecimal format 0xRRGGBB
    const hexColor = (r << 16) + (g << 8) + b;

    return am5.color(hexColor);
  }

  prepareData() {
    return this.heatData.map(item => ({
      id: item.code,
      count: item.count,
      polygonSettings: {
        fill: this.getRedShade(item.count)
      }
    }))
  }

  updateChartData() {
    this.polygonSeries.data.setAll(this.prepareData());
    this.chart.appear(1000, 100);
  }

  render() {
    return (
      <div class="card">
        <div class="card-body h-600px min-h-600px mh-600px">
          <div id="map" class="h-100"></div>
        </div>
      </div>
    );
  }
}
