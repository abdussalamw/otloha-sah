import {Component, h} from "@stencil/core";

@Component({
  tag: 'c-student-side-filters',
  shadow: false
})

export class StudentSideFilters {

  render() {
    return (
      <div class="card-body">
       <c-filter-input
          inputComponent="c-input"
          componentProps={{
            placeholder: "Enter text",
            label: "Search",
            name: "search"
          }}
          initialValue=""/>

        <c-filter-input
          class="mb-10"
          inputComponent="c-input"
          componentProps={{
            placeholder: "Enter text",
            name: 'username',
            label: "Username"
          }}
          initialValue=""/>
      </div>
    )
  }
}
