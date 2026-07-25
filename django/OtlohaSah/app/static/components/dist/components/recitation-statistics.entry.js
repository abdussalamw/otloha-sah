import { r as registerInstance, h } from './index-77994f1e.js';

const RecitationStatistics = class {
    constructor(hostRef) {
        registerInstance(this, hostRef);
        this.baseUrl = undefined;
        this.data = {};
    }
    async fetchData() {
        try {
            const response = await fetch(this.baseUrl);
            if (response.ok) {
                this.data = await response.json();
            }
            else {
                console.error("Failed to fetch data:", response.statusText);
            }
        }
        catch (error) {
            console.error("Error fetching data:", error);
        }
        finally {
        }
    }
    async componentWillLoad() {
        if (this.baseUrl) {
            this.fetchData();
        }
    }
    renderCartCards(data) {
        if (!data)
            return null; // Check if data is defined
        return Object.entries(data).map(([key, item]) => (h("div", { class: "col-xl-4", key: key }, h("chart-card", { component: item.component.component, data: item }))));
    }
    renderSection(section) {
        if (!section)
            return null; // Check if data is defined
        return (h("div", { class: "row gx-5 gx-xl-10 mb-xl-10" }, h("div", { class: "col-12" }, h("h2", { class: "fs-1 fw-bold text-gray-800  mb-5 mb-xl-10" }, section.title)), this.renderCartCards(section.items)));
    }
    render() {
        return (h("div", { key: 'f4f645e8bca3efbf17febc27b7da4b2259f8754a', class: "app-container container-fluid" }, h("div", { key: '5ef99dd4b3dc336e566334d64b7fa42d973d3ef2', class: "row gx-5 gx-xl-10 mb-xl-10" }, h("div", { key: '6454da1a87ce37b01bd59f7ee8797a2b066ad614', class: "col-xl-8" }, h("world-heatmap", { key: '48a8e9bcce58a9329ef96f2b0861c2a27c7cbe63', heatData: this.data['heatmap_data'] })), h("div", { key: 'f6a057c887d5ef721a4cf82d87895aceb5463c49', class: "col-xl-4" }, h("counties-table", { key: 'f73df16bcd378498fe62e0d3197572b77e4723a1', heatData: this.data['heatmap_data'] }))), this.data['overall'] ? this.renderSection(this.data['overall']) : null, this.data['narrations'] ? this.data['narrations'].map(narration => this.renderSection(narration)) : null));
    }
};

export { RecitationStatistics as recitation_statistics };

//# sourceMappingURL=recitation-statistics.entry.js.map