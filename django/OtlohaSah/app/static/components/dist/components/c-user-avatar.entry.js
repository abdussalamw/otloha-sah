import { r as registerInstance, h } from './index-77994f1e.js';

const UserAvatar = class {
    constructor(hostRef) {
        registerInstance(this, hostRef);
        this.link = undefined;
        this.name = undefined;
        this.image = '';
    }
    get symbolStyles() {
        return this.image ? {
            "background-image": `url(${this.image})"`
        } : {};
    }
    render() {
        return (h("div", { key: 'f5307c6dbd3fea02f15a14b2687d5a27d11361bc', class: "d-flex" }, h("a", { key: '3b0ed010537bf019b654de76795717bc269a8437', href: this.link, class: "symbol symbol-55px symbol-circle mx-3" }, h("div", { key: 'c4ac5914a0fd3d747e997e1fcee36b11fa1119c2', class: "symbol-label", style: this.symbolStyles }, this.image ? '' : this.name[0].toUpperCase())), h("slot", { key: 'e5101bb76b97731f2bb7b4344b9e8be77dd24014' })));
    }
};

export { UserAvatar as c_user_avatar };

//# sourceMappingURL=c-user-avatar.entry.js.map