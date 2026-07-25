import {Component, h, Prop} from "@stencil/core";

@Component({
  tag: 'c-gender',
  shadow: false
})
export class Gender {
  @Prop() gender: "male" | "female" = "male";

  get text() {
    return this.gender === 'male' ? 'Male' : 'Female';
  }

  get color() {
    return this.gender === 'male' ? 'text-primary' : 'text-danger';
  }

  get icon(): string {
    return this.gender === 'male' ? 'fa-mars' : 'fa-venus';
  }

  render() {
    const classes = [
      'fa-solid', this.icon, this.color, 'fs-2', 'me-2',
    ].join(' ');
    return (
      <div class="border border-gray-500 border-dashed rounded min-w-75px p-2 me-2">
        <div class="d-flex align-items-center">
          <i class={classes}></i>
          <div class="fw-semibold fs-5 text-gray-600">{this.text}</div>
        </div>
      </div>
    );
  }
}
