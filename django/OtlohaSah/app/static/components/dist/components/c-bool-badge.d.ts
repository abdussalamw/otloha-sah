import type { Components, JSX } from "../types/components";

interface CBoolBadge extends Components.CBoolBadge, HTMLElement {}
export const CBoolBadge: {
    prototype: CBoolBadge;
    new (): CBoolBadge;
};
/**
 * Used to define this component and all nested components recursively.
 */
export const defineCustomElement: () => void;
