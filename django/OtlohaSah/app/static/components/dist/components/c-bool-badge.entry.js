import { r as registerInstance, h } from './index-77994f1e.js';

const BoolBadge = class {
    constructor(hostRef) {
        registerInstance(this, hostRef);
        this.extraClass = undefined;
        this.test = false;
        this.successClass = 'success';
        this.failedClass = 'danger';
        this.successText = 'Yes';
        this.failedText = 'No';
    }
    render() {
        const classes = [
            'badge',
            'fw-bold',
            this.extraClass,
            `badge-${this.test ? this.successClass : this.failedClass}`
        ].filter(Boolean).join(' ');
        return (h("span", { key: '6afcd093c0a67a060d057cbe8b15a4d20959cfa2', class: classes }, h("slot", { key: '45af92ed74f316130c6f3252c523fb29944134c0' }, this.test ? this.successText : this.failedText)));
    }
};

export { BoolBadge as c_bool_badge };

//# sourceMappingURL=c-bool-badge.entry.js.map