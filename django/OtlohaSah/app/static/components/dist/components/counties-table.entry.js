import { r as registerInstance, h } from './index-77994f1e.js';

const CountiesTable = class {
    constructor(hostRef) {
        registerInstance(this, hostRef);
        this.heatData = [];
    }
    heatDataChanged() {
    }
    renderItem(item) {
        return (h("div", { class: "d-flex flex-stack" }, h("div", { class: "text-gray-700 fw-semibold fs-6 me-2" }, item.name), h("div", { class: "d-flex align-items-senter" }, h("span", { class: "text-gray-500 fw-bold fs-6" }, item.count))));
    }
    render() {
        return (h("div", { key: '7192bcef97cb4cf81f7ae73ff5af025a7c05e997', class: "card" }, h("div", { key: '422a6e97e42c4323c90c719e9b34810630f4840d', class: "card-body h-600px min-h-600px mh-600px scroll" }, this.heatData.map((item, index) => (h("div", { key: item.code }, this.renderItem(item), index < this.heatData.length - 1 && (h("div", { class: "separator separator-dashed my-3" }))))))));
    }
    static get watchers() { return {
        "heatData": ["heatDataChanged"]
    }; }
};

export { CountiesTable as counties_table };

//# sourceMappingURL=counties-table.entry.js.map