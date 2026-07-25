import { EventEmitter } from '../../../stencil-public-runtime';
export declare class Pagination {
    currentPage: number;
    totalPages: number;
    pageChange: EventEmitter<number>;
    handlePageChange(page: number): void;
    render(): any;
}
