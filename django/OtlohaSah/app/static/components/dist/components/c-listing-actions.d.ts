import type { Components, JSX } from "../types/components";

interface CListingActions extends Components.CListingActions, HTMLElement {}
export const CListingActions: {
    prototype: CListingActions;
    new (): CListingActions;
};
/**
 * Used to define this component and all nested components recursively.
 */
export const defineCustomElement: () => void;
