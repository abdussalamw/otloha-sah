import type { Components, JSX } from "../types/components";

interface CIndicator extends Components.CIndicator, HTMLElement {}
export const CIndicator: {
    prototype: CIndicator;
    new (): CIndicator;
};
/**
 * Used to define this component and all nested components recursively.
 */
export const defineCustomElement: () => void;
