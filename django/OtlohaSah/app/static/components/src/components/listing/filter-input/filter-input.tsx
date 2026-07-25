import {Component, Event, EventEmitter, h, Prop, State} from '@stencil/core';

@Component({
  tag: 'c-filter-input',
  shadow: false
})
export class FilterInput {

  @Prop() initialValue: string = '';
  @Prop() inputComponent: string = 'c-input';
  @Prop() componentProps: { [key: string]: any } = {};
  @Prop() withMargin: boolean = true;

  @State() value: string = this.initialValue;

  private debounceTimeout: any;

  @Event() filterChange: EventEmitter<{ filterName: string; value: string }>;

  handleValueChange(newValue: string) {
    this.value = newValue;
    clearTimeout(this.debounceTimeout);
    this.debounceTimeout = setTimeout(() => {
      this.filterChange.emit({filterName: this.componentProps.name, value: newValue});
    }, 300);
  }

  render() {
    const classes = [
      this.withMargin ? 'mb-10' : ''
    ].join(' ')
    return (
      <div class={classes}>
        {
          h(this.inputComponent, {
            ...this.componentProps,
            value: this.value,
            onValueChange: (event: CustomEvent<string>) => this.handleValueChange(event.detail)
          })
        }
      </div>
    );
  }
}
