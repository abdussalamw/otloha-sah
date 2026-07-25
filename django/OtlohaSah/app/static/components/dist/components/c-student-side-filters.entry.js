import { r as registerInstance, h } from './index-77994f1e.js';

const StudentSideFilters = class {
    constructor(hostRef) {
        registerInstance(this, hostRef);
    }
    render() {
        return (h("div", { key: '4b55410e3d1f44747d07f2915cc480d0cf3e4b32', class: "card-body" }, h("c-filter-input", { key: '414fb495bca6e392583779f6953819ed4ec99c68', inputComponent: "c-input", componentProps: {
                placeholder: "Enter text",
                label: "Search",
                name: "search"
            }, initialValue: "" }), h("c-filter-input", { key: '03c9d60ec72688cf40a775a78d18d3942a399560', class: "mb-10", inputComponent: "c-input", componentProps: {
                placeholder: "Enter text",
                name: 'username',
                label: "Username"
            }, initialValue: "" })));
    }
};

export { StudentSideFilters as c_student_side_filters };

//# sourceMappingURL=c-student-side-filters.entry.js.map