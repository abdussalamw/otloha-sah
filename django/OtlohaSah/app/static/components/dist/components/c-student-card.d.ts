import type { Components, JSX } from "../types/components";

interface CStudentCard extends Components.CStudentCard, HTMLElement {}
export const CStudentCard: {
    prototype: CStudentCard;
    new (): CStudentCard;
};
/**
 * Used to define this component and all nested components recursively.
 */
export const defineCustomElement: () => void;
