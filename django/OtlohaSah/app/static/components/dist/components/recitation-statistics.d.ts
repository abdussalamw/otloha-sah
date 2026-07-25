import type { Components, JSX } from "../types/components";

interface RecitationStatistics extends Components.RecitationStatistics, HTMLElement {}
export const RecitationStatistics: {
    prototype: RecitationStatistics;
    new (): RecitationStatistics;
};
/**
 * Used to define this component and all nested components recursively.
 */
export const defineCustomElement: () => void;
