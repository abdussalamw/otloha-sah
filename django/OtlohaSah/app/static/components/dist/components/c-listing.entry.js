import { r as registerInstance, h } from './index-77994f1e.js';

const Listing = class {
    constructor(hostRef) {
        registerInstance(this, hostRef);
        this.requestUrl = undefined;
        this.data = {};
        this.loading = true;
        this.queryParameters = {};
        this.listItemComponent = undefined;
        this.sideFiltersComponent = undefined;
        this.topFiltersComponent = undefined;
        this.headerEnabled = false;
        this.topFiltersEnabled = false;
        this.sideFiltersEnabled = false;
        this.searchEnabled = false;
    }
    async componentWillLoad() {
        if (this.requestUrl) {
            this.fetchData();
        }
    }
    async fetchData() {
        this.loading = true;
        try {
            const baseUrl = window.location.origin;
            const fullUrl = this.requestUrl.startsWith('/')
                ? `${baseUrl}${this.requestUrl}`
                : this.requestUrl;
            const url = new URL(fullUrl);
            Object.keys(this.queryParameters).forEach(key => {
                url.searchParams.set(key, this.queryParameters[key].toString());
            });
            const response = await fetch(url.toString());
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
            this.loading = false;
        }
    }
    handleFilterChange(event) {
        const { filterName, value } = event.detail;
        this.queryParameters = Object.assign(Object.assign({}, this.queryParameters), { [filterName]: value });
        this.updateUrlWithQueryParams();
        this.fetchData();
    }
    updateUrlWithQueryParams() {
        const url = new URL(window.location.href);
        url.search = '';
        Object.keys(this.queryParameters).forEach(key => {
            if (this.queryParameters[key]) {
                url.searchParams.set(key, this.queryParameters[key].toString());
            }
            else {
                delete url.searchParams[key];
            }
        });
        window.history.pushState({}, '', url.toString());
    }
    renderHeader() {
        return this.headerEnabled ? (h("div", { class: "d-flex gap-5 gap-xl-8 mb-5 mb-xl-10" }, h("slot", { name: "header" }))) : '';
    }
    renderSideFilters() {
        // <div class="card-body">
        //             <slot name="side-filters" onSlotchange={(event: any) => this.handleFilterChange(event)}></slot>
        //           </div>
        return this.sideFiltersComponent ? (h("div", { class: "col-md-2 col-lg-3" }, h("div", { class: "card card-flush" }, h(this.sideFiltersComponent, {
            onFilterChange: (event) => this.handleFilterChange(event)
        })))) : '';
    }
    renderTopFilters() {
        return this.topFiltersEnabled ? (h("div", { class: "card mb-5" }, h("div", { class: "card-header align-items-center px-4 py-2" }, h("slot", { name: "header-filters", onSlotchange: (event) => this.handleFilterChange(event) })))) : '';
    }
    render() {
        return (h("div", { key: '809a9a49569e22fec31cc6ea144072bb3e052264', class: "app-container container-xxl" }, this.renderHeader(), h("div", { key: 'dd268af600e7c33d8025b8e0015311d045bb1c18', class: "row" }, this.renderSideFilters(), h("div", { key: 'b091b798cdfac0c7370024a59d521797d7f0c735', class: this.sideFiltersComponent ? 'col-md-10 col-lg-9' : 'col-12' }, this.renderTopFilters(), h("div", { key: 'c30fa8d39bae3c71d13d1c3a7bebff9a9f7e28f5' }, this.loading ? (h("p", null, "Loading...")) : (this.data.results.map(item => h(this.listItemComponent, { item: item })))), h("div", { key: '924d72abeb1e6a9497f5ba4142ba95fa7880275a', class: "row" })))));
    }
};

export { Listing as c_listing };

//# sourceMappingURL=c-listing.entry.js.map