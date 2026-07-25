import {Component, h, Prop} from "@stencil/core";

@Component({
  tag: 'c-user-avatar',
  shadow: false
})

export class UserAvatar {

  @Prop() link?: string
  @Prop() name?: string
  @Prop() image: string = '';

  get symbolStyles() {
    return this.image ? {
      "background-image": `url(${this.image})"`
    } : {}
  }

  render() {
    return (
      <div class="d-flex">
        <a href={this.link} class="symbol symbol-55px symbol-circle mx-3">
          <div class="symbol-label" style={this.symbolStyles}>
            {this.image ? '' : this.name[0].toUpperCase()}
          </div>
        </a>
        <slot></slot>
      </div>
    )
  }
}
