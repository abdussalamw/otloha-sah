import type { Components, JSX } from "../types/components";

interface CBadge extends Components.CBadge, HTMLElement {}
export const CBadge: {
    prototype: CBadge;
    new (): CBadge;
};
/**
 * Used to define this component and all nested components recursively.
 */
export const defineCustomElement: () => void;
