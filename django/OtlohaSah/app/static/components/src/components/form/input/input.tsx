import {Component, Event, EventEmitter, h, Prop, State} from '@stencil/core';

@Component({
  tag: 'c-input',
  shadow: false
})
export class Input {
  @Prop() label: string;
  @Prop() errors: any;
  @Prop() value: string = '';
  @Prop() type: string = 'text'

  @State() internalValue: string;

  @Event() valueChange: EventEmitter<string>;

  handleInput(event: Event) {
    const input = event.target as HTMLInputElement;
    this.internalValue = input.value;
    this.valueChange.emit(this.internalValue);
  }

  render() {
    return (
      <div class="">
        {this.label && <label class="form-label">{this.label}</label>}
        <input
          class={`form-control ${this.errors ? 'is-invalid' : ''}`}
          type={this.type}
          value={this.internalValue}
          onInput={(event) => this.handleInput(event)}
        />
        {this.errors && <p class="invalid-feedback">{this.errors}</p>}
      </div>
    );
  }
}
