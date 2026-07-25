import type { Components, JSX } from "../types/components";

interface DonutChart extends Components.DonutChart, HTMLElement {}
export const DonutChart: {
    prototype: DonutChart;
    new (): DonutChart;
};
/**
 * Used to define this component and all nested components recursively.
 */
export const defineCustomElement: () => void;
