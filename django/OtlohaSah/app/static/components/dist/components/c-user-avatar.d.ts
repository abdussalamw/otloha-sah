import type { Components, JSX } from "../types/components";

interface CUserAvatar extends Components.CUserAvatar, HTMLElement {}
export const CUserAvatar: {
    prototype: CUserAvatar;
    new (): CUserAvatar;
};
/**
 * Used to define this component and all nested components recursively.
 */
export const defineCustomElement: () => void;
