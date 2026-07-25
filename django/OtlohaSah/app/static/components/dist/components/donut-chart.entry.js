import { r as registerInstance, h, g as getElement } from './index-77994f1e.js';

const DonutChart = class {
    constructor(hostRef) {
        registerInstance(this, hostRef);
        this.colors = [
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
        this.data = [];
        this.width = 80;
        this.height = 80;
        this.holeRadius = 0.5;
        this.strokeWidth = 12;
    }
    componentDidLoad() {
        this.drawChart();
    }
    dataChanged() {
        this.drawChart(); // Redraw chart when data changes
    }
    drawChart() {
        if (!this.canvas)
            return;
        const ctx = this.canvas.getContext('2d');
        if (!ctx)
            return;
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
        return (h("div", { key: 'ff0227514af8b10ce3c06d263107ff4e180f580c', style: { 'min-width': '80px', 'min-height': '80px' } }, h("canvas", { key: '27413655d0443da61c3b9d453117b1fc57ac452a', ref: (el) => (this.canvas = el), width: this.width, height: this.height })));
    }
    get el() { return getElement(this); }
    static get watchers() { return {
        "data": ["dataChanged"]
    }; }
};

export { DonutChart as donut_chart };

//# sourceMappingURL=donut-chart.entry.js.map