import type { Components, JSX } from "../types/components";

interface ChartCard extends Components.ChartCard, HTMLElement {}
export const ChartCard: {
    prototype: ChartCard;
    new (): ChartCard;
};
/**
 * Used to define this component and all nested components recursively.
 */
export const defineCustomElement: () => void;
