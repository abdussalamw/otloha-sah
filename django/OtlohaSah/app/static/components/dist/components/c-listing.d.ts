import type { Components, JSX } from "../types/components";

interface CListing extends Components.CListing, HTMLElement {}
export const CListing: {
    prototype: CListing;
    new (): CListing;
};
/**
 * Used to define this component and all nested components recursively.
 */
export const defineCustomElement: () => void;
