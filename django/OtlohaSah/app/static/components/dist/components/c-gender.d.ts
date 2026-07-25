import type { Components, JSX } from "../types/components";

interface CGender extends Components.CGender, HTMLElement {}
export const CGender: {
    prototype: CGender;
    new (): CGender;
};
/**
 * Used to define this component and all nested components recursively.
 */
export const defineCustomElement: () => void;
