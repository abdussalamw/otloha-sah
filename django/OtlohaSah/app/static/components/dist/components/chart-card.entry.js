import { r as registerInstance, h } from './index-77994f1e.js';

const ChartCard = class {
    constructor(hostRef) {
        registerInstance(this, hostRef);
        this.data = {};
        this.component = 'donut-chart';
    }
    renderSegment(segment) {
        return (h("div", { class: "d-flex fw-semibold align-items-center" }, h("div", { class: "bullet w-8px h-3px rounded-2 me-3", style: { "backgroundColor": segment.color } }), h("div", { class: "text-gray-500 flex-grow-1 me-4" }, segment.name), h("div", { class: " fw-bolder text-gray-700 text-xxl-end" }, segment.count)));
    }
    render() {
        var _a, _b;
        return (h("div", { key: '029e2017887c1d003bece3be0f45035b9681405a', class: "card card-flush card-stretch mb-5 mb-xl-10" }, h("div", { key: '139bffd34ed7fd25bf058f0b5d6f455761142b27', class: "card-header pt-5" }, h("div", { key: 'bae19730681804ae247f646d836c31ef1c6917ce', class: "card-title d-flex flex-column" }, h("div", { key: 'c530ee068750a3d66d9e898f5b998ddcf0c40b7c', class: "d-flex align-items-center" }, h("span", { key: 'c8636bdaf1ff79fcc5b1f7cdc96c050f5a5d26f7', class: "fs-2hx fw-bold text-gray-900 me-2 lh-1 ls-n2" }, this.data.count)), h("span", { key: '2d431acbe086057495f7423449c8e051f351092b', class: "text-gray-500 pt-1 fw-semibold fs-6" }, this.data.label))), h("div", { key: 'f9d0435ee939bf4645e32db6d30cad9f6bf5d21b', class: "card-body pt-2 pb-4 d-flex flex-wrap align-items-center" }, h("div", { key: '02cd5346a060a81b9519311ba02b48ce3863cc09', class: "d-flex flex-center me-5 pt-2" }, h(this.component, Object.assign({ data: this.data.segments }, this.data.component.props))), h("div", { key: '80f864b25cadf0c9e5e3907ddb2181da41fde7ee', class: "d-flex flex-column content-justify-center flex-row-fluid" }, (_b = (_a = this.data) === null || _a === void 0 ? void 0 : _a.segments) === null || _b === void 0 ? void 0 : _b.map(segment => this.renderSegment(segment))))));
    }
};

export { ChartCard as chart_card };

//# sourceMappingURL=chart-card.entry.js.map