import {Component, h, Prop} from "@stencil/core";

@Component({
  tag: 'statistics-icon',
  shadow: false
})
export class StatisticsIcon {
  @Prop() classes: string

  render() {
    return (
      <div class="d-flex align-items-center justify-content-center" style={{'min-width': '80px', 'min-height': '80px'}}>
        <i class={this.classes}></i>
      </div>
    );
  }
}
