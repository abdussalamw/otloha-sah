import { r as registerInstance, h } from './index-77994f1e.js';

const ListingActions = class {
    constructor(hostRef) {
        registerInstance(this, hostRef);
        this.actions = [];
        this.icon = true;
    }
    renderContent() {
        return this.icon ? (h("span", { class: "svg-icon svg-icon-5 m-0" }, h("svg", { width: "24", height: "24", viewBox: "0 0 24 24", fill: "none", xmlns: "http://www.w3.org/2000/svg" }, h("rect", { x: "10", y: "10", width: "4", height: "4", rx: "2", fill: "currentColor" }), h("rect", { x: "10", y: "3", width: "4", height: "4", rx: "2", fill: "currentColor" }), h("rect", { x: "10", y: "17", width: "4", height: "4", rx: "2", fill: "currentColor" })))) : "Actions";
    }
    get classes() {
        return [
            'btn',
            'btn-sm',
            this.icon ? 'btn-icon' : '',
            'btn-light',
            'show',
            'menu-dropdown'
        ].join(' ');
    }
    componentDidLoad() {
        // @ts-ignore
        if (window.KTMenu && typeof window.KTMenu.createInstances === 'function') {
            // @ts-ignore
            window.KTMenu.createInstances();
        }
        else {
            console.warn('KTMenu or KTMenu.createInstances not found');
        }
    }
    render() {
        return (h("div", { key: '48f239aaf8631934107f9b95c0ff326e83f1e270' }, h("a", { key: '3ff14370fe6acc065ed0bb849a8283b3644e12fa', href: "#", class: this.classes, "data-kt-menu-trigger": "click", "data-kt-menu-placement": "bottom-end" }, this.renderContent()), h("div", { key: '1efcfc2772ee76748b781b34cc94eed3c7a1130d', class: "menu menu-sub menu-sub-dropdown menu-column menu-rounded menu-gray-600 menu-state-bg-light-primary fw-semibold fs-7 w-250px py-4", "data-kt-menu": "true" }, this.actions.map((action) => (h("div", { class: "menu-item px-3" }, h("a", Object.assign({}, action.attrs), action.text)))))));
    }
};

export { ListingActions as c_listing_actions };

//# sourceMappingURL=c-listing-actions.entry.js.map