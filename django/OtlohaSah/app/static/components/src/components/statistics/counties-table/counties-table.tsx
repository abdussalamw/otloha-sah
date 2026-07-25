import {Component, h, Prop, Watch} from '@stencil/core';


@Component({
  tag: 'counties-table',
  shadow: false,
})
export class CountiesTable {
  @Prop() heatData: { code: string; count: number, name: string }[] = [];

  @Watch('heatData')
  heatDataChanged() {


  }


  renderItem(item: { code: string; count: number, name: string }) {
    return (
      <div class="d-flex flex-stack">
        <div class="text-gray-700 fw-semibold fs-6 me-2">{item.name}</div>
        <div class="d-flex align-items-senter">
          <span class="text-gray-500 fw-bold fs-6">{item.count}</span>
        </div>
      </div>
    )
  }

  render() {
    return (
      <div class="card">
        <div class="card-body h-600px min-h-600px mh-600px scroll">
          {this.heatData.map((item, index) => (
            <div key={item.code}>
              {this.renderItem(item)}
              {index < this.heatData.length - 1 && (
                <div class="separator separator-dashed my-3"></div>
              )}
            </div>
          ))}
        </div>
      </div>
    );
  }
}
