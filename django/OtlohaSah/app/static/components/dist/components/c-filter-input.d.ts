import type { Components, JSX } from "../types/components";

interface CFilterInput extends Components.CFilterInput, HTMLElement {}
export const CFilterInput: {
    prototype: CFilterInput;
    new (): CFilterInput;
};
/**
 * Used to define this component and all nested components recursively.
 */
export const defineCustomElement: () => void;
