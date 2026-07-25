import type { Components, JSX } from "../types/components";

interface CountiesTable extends Components.CountiesTable, HTMLElement {}
export const CountiesTable: {
    prototype: CountiesTable;
    new (): CountiesTable;
};
/**
 * Used to define this component and all nested components recursively.
 */
export const defineCustomElement: () => void;
