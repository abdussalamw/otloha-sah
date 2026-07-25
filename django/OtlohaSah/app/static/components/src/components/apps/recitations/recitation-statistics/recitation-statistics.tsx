import {Component, h, Prop, State} from '@stencil/core';
import {ChartData} from "../../../../utils/types";

@Component({
  tag: 'recitation-statistics',
  shadow: false,
})
export class RecitationStatistics {
  @Prop() baseUrl?: string;
  @State() data: any = {};


  async fetchData() {
    try {
      const response = await fetch(this.baseUrl);
      if (response.ok) {
        this.data = await response.json();
      } else {
        console.error("Failed to fetch data:", response.statusText);
      }
    } catch (error) {
      console.error("Error fetching data:", error);
    } finally {

    }
  }

  async componentWillLoad() {
    if (this.baseUrl) {
      this.fetchData();
    }
  }

  renderCartCards(data: Record<string, ChartData> | undefined) {
    if (!data) return null; // Check if data is defined

    return Object.entries(data).map(([key, item]) => (
      <div class="col-xl-4" key={key}>
        <chart-card component={item.component.component} data={item}/>
      </div>
    ));
  }

  renderSection(section: Record<string, any> | undefined) {
    if (!section) return null; // Check if data is defined
    return (

      <div class="row gx-5 gx-xl-10 mb-xl-10">
        <div class="col-12">
          <h2 class="fs-1 fw-bold text-gray-800  mb-5 mb-xl-10">{section.title}</h2>
        </div>
        {this.renderCartCards(section.items)}
      </div>
    )

  }

  render() {
    return (
      <div class="app-container container-fluid">
        <div class="row gx-5 gx-xl-10 mb-xl-10">
          <div class="col-xl-8">
            <world-heatmap heatData={this.data['heatmap_data']}/>
          </div>
          <div class="col-xl-4">
            <counties-table heatData={this.data['heatmap_data']}/>
          </div>
        </div>
        {this.data['overall'] ? this.renderSection(this.data['overall']) : null}
        {this.data['narrations'] ? this.data['narrations'].map(narration => this.renderSection(narration)) : null}
      </div>
    );
  }
}
