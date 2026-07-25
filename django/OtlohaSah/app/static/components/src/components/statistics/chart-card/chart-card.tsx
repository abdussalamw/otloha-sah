import {Component, h, Prop} from '@stencil/core';
import {ChartData} from "../../../utils/types";

@Component({
  tag: 'chart-card',

  shadow: false,
})
export class ChartCard {
  @Prop() data: ChartData = {} as ChartData;
  @Prop() component = 'donut-chart';

  renderSegment(segment: { count: number; name: string, color: string }) {
    return (
      <div class="d-flex fw-semibold align-items-center">
        <div class="bullet w-8px h-3px rounded-2 me-3" style={{"backgroundColor": segment.color}}></div>

        <div class="text-gray-500 flex-grow-1 me-4">{segment.name}</div>

        <div class=" fw-bolder text-gray-700 text-xxl-end">{segment.count}</div>
      </div>
    )
  }


  render() {
    return (
      <div class="card card-flush card-stretch mb-5 mb-xl-10">
        <div class="card-header pt-5">
          <div class="card-title d-flex flex-column">
            <div class="d-flex align-items-center">
              <span class="fs-2hx fw-bold text-gray-900 me-2 lh-1 ls-n2">{this.data.count}</span>
            </div>
            <span class="text-gray-500 pt-1 fw-semibold fs-6">{this.data.label}</span>
          </div>
        </div>

        <div class="card-body pt-2 pb-4 d-flex flex-wrap align-items-center">
          <div class="d-flex flex-center me-5 pt-2">

              {h(this.component, {data: this.data.segments, ...this.data.component.props})}

          </div>

          <div class="d-flex flex-column content-justify-center flex-row-fluid">
            {this.data?.segments?.map(segment => this.renderSegment(segment))}
          </div>
        </div>
      </div>
    );
  }
}
