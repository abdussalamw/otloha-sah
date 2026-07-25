import type { Components, JSX } from "../types/components";

interface StatisticsIcon extends Components.StatisticsIcon, HTMLElement {}
export const StatisticsIcon: {
    prototype: StatisticsIcon;
    new (): StatisticsIcon;
};
/**
 * Used to define this component and all nested components recursively.
 */
export const defineCustomElement: () => void;
