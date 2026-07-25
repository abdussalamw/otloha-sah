import {Component, h, Prop} from "@stencil/core";

@Component({
  tag: 'c-bool-badge',
  shadow: false
})
export class BoolBadge {
  @Prop() extraClass?: string;
  @Prop() test: boolean = false;
  @Prop() successClass?: string = 'success';
  @Prop() failedClass?: string = 'danger';
  @Prop() successText?: string = 'Yes';
  @Prop() failedText?: string = 'No';

  render() {
    const classes = [
      'badge',
      'fw-bold',
      this.extraClass,
      `badge-${this.test ? this.successClass : this.failedClass}`
    ].filter(Boolean).join(' ');
    return (
      <span class={classes}>
        <slot>
        {this.test ? this.successText : this.failedText}
        </slot>
      </span>
    );
  }
}
