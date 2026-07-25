import {Component, Element, h, Prop, Watch} from '@stencil/core';
import {Segment} from "../../../utils/types";

@Component({
  tag: 'donut-chart',
  shadow: false,
})
export class DonutChart {
  @Element() el: HTMLElement;

  @Prop() data: Segment[] = []; // Data for each segment with count and name
  colors: string[] = [
    "#0d6efd",
    "#6610f2",
    "#6f42c1",
    "#d63384",
    "#dc3545",
    "#fd7e14",
    "#ffc107",
    "#198754",
    "#20c997",
    "#0dcaf0",
    "#000000",
  ]; // Array of colors for each segment
  @Prop() width: number = 80; // Width and height of the canvas
  @Prop() height: number = 80;
  @Prop() holeRadius: number = 0.5; // Radius for the donut hole (between 0 and 1)
  @Prop() strokeWidth: number = 12; // Width of the stroke for each segment

  private canvas!: HTMLCanvasElement;

  componentDidLoad() {
    this.drawChart();
  }

  @Watch('data')
  dataChanged() {
    this.drawChart(); // Redraw chart when data changes
  }

  drawChart() {
    if (!this.canvas) return;

    const ctx = this.canvas.getContext('2d');
    if (!ctx) return;

    // Clear the canvas before drawing
    ctx.clearRect(0, 0, this.width, this.height);

    // Calculate total value
    const total = this.data.reduce((acc, segment) => acc + segment.count, 0);
    const centerX = this.width / 2;
    const centerY = this.height / 2;
    const outerRadius = Math.min(this.width, this.height) / 2;
    const innerRadius = outerRadius - this.strokeWidth; // Define inner radius based on stroke width

    let startAngle = -Math.PI / 2; // Start from the top

    // Draw each segment
    this.data.forEach((segment, index) => {
      const sliceAngle = (segment.count / total) * 2 * Math.PI;

      ctx.beginPath();
      ctx.arc(centerX, centerY, (innerRadius + outerRadius) / 2, startAngle, startAngle + sliceAngle);
      ctx.lineWidth = this.strokeWidth;
      ctx.strokeStyle = segment['color'] || (this.colors[index] || '#000');

      ctx.stroke();

      startAngle += sliceAngle;
    });

    // Draw the inner circle to create the donut hole
    if (this.holeRadius > 0) {
      ctx.beginPath();
      ctx.arc(centerX, centerY, outerRadius * this.holeRadius, 0, 2 * Math.PI);
      ctx.fillStyle = '#fff'; // Color for the hole
      ctx.fill();
    }
  }

  render() {
    return (
      <div style={{'min-width': '80px', 'min-height': '80px'}}>
        <canvas
          ref={(el) => (this.canvas = el as HTMLCanvasElement)}
          width={this.width}
          height={this.height}
        ></canvas>
       </div>
    );
  }
}
