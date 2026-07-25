import type { Components, JSX } from "../types/components";

interface WorldHeatmap extends Components.WorldHeatmap, HTMLElement {}
export const WorldHeatmap: {
    prototype: WorldHeatmap;
    new (): WorldHeatmap;
};
/**
 * Used to define this component and all nested components recursively.
 */
export const defineCustomElement: () => void;
