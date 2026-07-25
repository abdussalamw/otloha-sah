import {Component, h, Prop} from "@stencil/core";

@Component({
  tag: 'c-badge',
  shadow: false
})
export class Badge {
  @Prop() extraClass?: string
  @Prop() text?: string

  render() {
    const classes = [
      'badge',
      'fw-bold',
      this.extraClass
    ].join(' ');
    return (
      <span class={classes}><slot>{this.text}</slot></span>
    );
  }
}
