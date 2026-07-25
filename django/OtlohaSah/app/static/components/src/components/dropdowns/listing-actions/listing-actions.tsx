import {Component, h, Prop} from "@stencil/core";

@Component({
  tag: 'c-listing-actions',
  shadow: false
})
export class ListingActions {
  @Prop() actions = [];
  @Prop() icon: boolean = true;

  renderContent() {
    return this.icon ? (
      <span class="svg-icon svg-icon-5 m-0">
        <svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
          <rect x="10" y="10" width="4" height="4" rx="2" fill="currentColor"></rect>
          <rect x="10" y="3" width="4" height="4" rx="2" fill="currentColor"></rect>
          <rect x="10" y="17" width="4" height="4" rx="2" fill="currentColor"></rect>
        </svg>
      </span>
    ) : "Actions"
  }

  get classes() {
    return [
      'btn',
      'btn-sm',
      this.icon ? 'btn-icon' : '',
      'btn-light',
      'show',
      'menu-dropdown'
    ].join(' ')
  }

  componentDidLoad() {
    // @ts-ignore
    if (window.KTMenu && typeof window.KTMenu.createInstances === 'function') {
      // @ts-ignore
      window.KTMenu.createInstances();
    } else {
      console.warn('KTMenu or KTMenu.createInstances not found');
    }
  }

  render() {
    return (
      <div>
        <a href="#" class={this.classes}
           data-kt-menu-trigger="click" data-kt-menu-placement="bottom-end">
          {this.renderContent()}
        </a>
        <div
          class="menu menu-sub menu-sub-dropdown menu-column menu-rounded menu-gray-600 menu-state-bg-light-primary fw-semibold fs-7 w-250px py-4"
          data-kt-menu="true">
          {this.actions.map((action) => (
            <div class="menu-item px-3">
              <a {...action.attrs}>{action.text}</a>
            </div>
          ))}
        </div>
      </div>
    )
  }
}
