import { r as registerInstance, a as createEvent, h } from './index-77994f1e.js';

const paginationCss = "";

const Pagination = class {
    constructor(hostRef) {
        registerInstance(this, hostRef);
        this.pageChange = createEvent(this, "pageChange", 7);
        this.currentPage = 1;
        this.totalPages = 1;
    }
    handlePageChange(page) {
        if (page >= 1 && page <= this.totalPages) {
            this.pageChange.emit(page);
        }
    }
    render() {
        return (h("div", { key: '318bafd69c1331f4f3567a48f0135b961ca3536b', class: "pagination" }, h("button", { key: 'b3a0983e284ef833f1a44a4d6dbc630f2b4f177b', onClick: () => this.handlePageChange(this.currentPage - 1), disabled: this.currentPage === 1 }, "Previous"), Array.from({ length: this.totalPages }, (_, i) => i + 1).map(page => (h("button", { onClick: () => this.handlePageChange(page), class: this.currentPage === page ? 'active' : '' }, page))), h("button", { key: '193f109e6ae1fb8914926972b7dfc1cf0dcb5ab1', onClick: () => this.handlePageChange(this.currentPage + 1), disabled: this.currentPage === this.totalPages }, "Next")));
    }
};
Pagination.style = paginationCss;

export { Pagination as c_pagination };

//# sourceMappingURL=c-pagination.entry.js.map