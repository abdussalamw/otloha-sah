import { Component, h, Prop, State, Watch } from "@stencil/core";
import { counterUp } from '../../../utils/counterUp';

@Component({
  tag: 'c-indicator',
  styleUrl: 'indicator.scss',
  shadow: true
})
export class Indicator {
  @Prop() label?: string;
  @Prop() color: string = 'var(--primary-color, #181C32)';
  @Prop() bgColor: string = 'var(--background-color, #ffffff)';
  @Prop() borderColor: string = 'var(--border-color, #f0f0f0)';
  @Prop() requestUrl?: string;
  @Prop() requestMethod: string = 'GET';
  @Prop() link?: string;
  @Prop() csrfToken?: string;
  @Prop() value?: number;

  @State() displayValue: number = 0;
  @State() hasError: boolean = false;

  async connectedCallback() {
    if (this.value === undefined) {
      await this.fetchValue();
    } else {
      this.displayValue = this.value;
    }
  }

  async fetchValue() {
    try {
      const response = await fetch(this.requestUrl!, {
        method: this.requestMethod,
        headers: {
          'X-CSRF-Token': this.csrfToken ?? '',
        },
      });
      if (!response.ok) throw new Error('Network response was not ok');
      const data = await response.json();
      this.displayValue = data.count ?? data.value ?? 0;
    } catch (error) {
      console.error('Error fetching value:', error);
      this.hasError = true;
    }
  }

  @Watch('value')
  handleValueChange() {
    if (this.value !== undefined) {
      counterUp(this.displayValue, this.value, 1000, (newDisplayValue) => {
        this.displayValue = newDisplayValue;
      });
    }
  }

  render() {
    return (
      <a href={this.link} class="indicator"
         style={{
           '--item-color': this.color,
           '--item-bg-color': this.bgColor,
           '--item-border-color': this.borderColor
         }}>
        <span class="indicator__icon">
          <slot name="icon" />
        </span>
        <span class="indicator__body">
          <p class="indicator__value">
            {this.hasError ? 'N/A' : this.displayValue}
          </p>
          <p class="indicator__label">{this.label}</p>
        </span>
      </a>
    );
  }
}
