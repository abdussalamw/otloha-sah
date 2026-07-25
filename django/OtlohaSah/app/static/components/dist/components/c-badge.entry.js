import { r as registerInstance, h } from './index-77994f1e.js';

const Badge = class {
    constructor(hostRef) {
        registerInstance(this, hostRef);
        this.extraClass = undefined;
        this.text = undefined;
    }
    render() {
        const classes = [
            'badge',
            'fw-bold',
            this.extraClass
        ].join(' ');
        return (h("span", { key: '005c9aad074d64328c7948625383ab9b337b901e', class: classes }, h("slot", { key: 'c89352a15bde2df2b91b4de6e1baf3dba32f6852' }, this.text)));
    }
};

export { Badge as c_badge };

//# sourceMappingURL=c-badge.entry.js.map