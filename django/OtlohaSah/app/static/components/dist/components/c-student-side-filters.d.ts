import type { Components, JSX } from "../types/components";

interface CStudentSideFilters extends Components.CStudentSideFilters, HTMLElement {}
export const CStudentSideFilters: {
    prototype: CStudentSideFilters;
    new (): CStudentSideFilters;
};
/**
 * Used to define this component and all nested components recursively.
 */
export const defineCustomElement: () => void;
