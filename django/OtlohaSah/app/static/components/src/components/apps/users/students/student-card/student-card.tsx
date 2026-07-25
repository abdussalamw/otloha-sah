import {Component, h, Prop} from "@stencil/core";


@Component({
  tag: 'c-student-card',
  shadow: false
})

export class StudentCard {
  @Prop() item: any;

  render() {
    return (
      <div class="card mb-5">
        <div class="card-header flex-nowrap px-4">
          <div class="card-title">
            <c-user-avatar name={this.item.fullname}
                           link={this.item.urls.profile}
                           image={this.item.profile_image}>
              <div class="d-flex flex-column justify-content-center flex-grow-1">
                <a href={this.item.urls.profile} class="fs-5 fw-bold mb-0 me-2">
                  {this.item.fullname}
                </a>
                <p class="fs-7 text-gray-600 mb-1 me-2">{this.item.email}</p>
                <div class="d-flex flex-wrap mb-1">
                  <c-bool-badge class="me-2 fs-8"
                                test={this.item.is_verified}
                                success-text="Verified"
                                failed-text="Unverified"/>

                  <c-badge class="me-2 fs-8" extra-class="badge-light-warning"
                  >
                    <i class="fa fa-star text-warning me-1"></i> { this.item.rate } - { this.item.level_text }
                  </c-badge>
                  <c-bool-badge class="me-2 fs-8"
                                test={this.item.is_active}
                                success-text="Active"
                                failed-text="Blocked"/>
                </div>
              </div>
            </c-user-avatar>
          </div>
          <div class="card-toolbar flex-nowrap">
            <c-gender gender={this.item.gender} />
            <c-listing-actions actions={this.item.actions} />
          </div>
        </div>
        <div class="card-body">
          {this.item.username}
        </div>
      </div>
    );
  }
}
