import {Component, h, Prop, State} from "@stencil/core";

interface Data {
  count: number;
  next: string;
  previous: string;
  results: any[];
  page_size: number;
  page: number;
}

@Component({
  tag: 'c-listing',
  shadow: false
})
export class Listing {
  @Prop() requestUrl?: string;
  @State() data: Data = {} as Data;
  @State() loading: boolean = true;
  @State() queryParameters: { [key: string]: string | number } = {};

  // components
  @Prop() listItemComponent: string;
  @Prop() sideFiltersComponent: string;
  @Prop() topFiltersComponent: string;


  // bools
  @Prop() headerEnabled: boolean = false;
  @Prop() topFiltersEnabled: boolean = false;
  @Prop() sideFiltersEnabled: boolean = false;
  @Prop() searchEnabled: boolean = false;


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
      } else {
        console.error("Failed to fetch data:", response.statusText);
      }
    } catch (error) {
      console.error("Error fetching data:", error);
    } finally {
      this.loading = false;
    }
  }

  handleFilterChange(event: CustomEvent<{ filterName: string; value: string | number }>) {
    const {filterName, value} = event.detail;
    this.queryParameters = {...this.queryParameters, [filterName]: value};
    this.updateUrlWithQueryParams();
    this.fetchData();
  }

  updateUrlWithQueryParams() {
    const url = new URL(window.location.href);
    url.search = '';
    Object.keys(this.queryParameters).forEach(key => {
      if (this.queryParameters[key]) {
        url.searchParams.set(key, this.queryParameters[key].toString());
      } else {
        delete url.searchParams[key]
      }
    });
    window.history.pushState({}, '', url.toString());
  }

  renderHeader() {
    return this.headerEnabled ? (
      <div class="d-flex gap-5 gap-xl-8 mb-5 mb-xl-10">
        <slot name="header"></slot>
      </div>
    ) : ''
  }

  renderSideFilters() {
    // <div class="card-body">
    //             <slot name="side-filters" onSlotchange={(event: any) => this.handleFilterChange(event)}></slot>
    //           </div>
    return this.sideFiltersComponent ? (
      <div class="col-md-2 col-lg-3">
        <div class="card card-flush">
          {h(this.sideFiltersComponent, {
            onFilterChange: (event: CustomEvent<{ filterName: string; value: string }>) =>
              this.handleFilterChange(event)
          })}
        </div>
      </div>
    ) : ''
  }

  renderTopFilters() {
    return this.topFiltersEnabled ? (
      <div class="card mb-5">
        <div class="card-header align-items-center px-4 py-2">
          <slot name="header-filters" onSlotchange={(event: any) => this.handleFilterChange(event)}></slot>
        </div>
      </div>
    ) : ''
  }

  render() {
    return (
      <div class="app-container container-xxl">
        {this.renderHeader()}
        <div class="row">
          {this.renderSideFilters()}
          <div class={this.sideFiltersComponent ? 'col-md-10 col-lg-9' : 'col-12'}>
            {this.renderTopFilters()}
            <div>
              {this.loading ? (
                <p>Loading...</p>
              ) : (
                this.data.results.map(item =>
                  h(this.listItemComponent, {item: item})
                )
              )}
            </div>
            <div class="row">

            </div>
          </div>
        </div>
      </div>
    );
  }
}
