import { r as registerInstance, h } from './index-77994f1e.js';

const Gender = class {
    constructor(hostRef) {
        registerInstance(this, hostRef);
        this.gender = "male";
    }
    get text() {
        return this.gender === 'male' ? 'Male' : 'Female';
    }
    get color() {
        return this.gender === 'male' ? 'text-primary' : 'text-danger';
    }
    get icon() {
        return this.gender === 'male' ? 'fa-mars' : 'fa-venus';
    }
    render() {
        const classes = [
            'fa-solid', this.icon, this.color, 'fs-2', 'me-2',
        ].join(' ');
        return (h("div", { key: '914168b902975be133d7af93dd7069da4547dd68', class: "border border-gray-500 border-dashed rounded min-w-75px p-2 me-2" }, h("div", { key: '5bf68a7eed4c8587f12745525c39c9886e0817c6', class: "d-flex align-items-center" }, h("i", { key: '56e30a7c5c22f94247d0609589382ca509fbf8ba', class: classes }), h("div", { key: 'a196ed075d3965ab5da63807e6e3e722da768e74', class: "fw-semibold fs-5 text-gray-600" }, this.text))));
    }
};

export { Gender as c_gender };

//# sourceMappingURL=c-gender.entry.js.map