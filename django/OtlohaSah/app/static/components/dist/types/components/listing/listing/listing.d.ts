interface Data {
    count: number;
    next: string;
    previous: string;
    results: any[];
    page_size: number;
    page: number;
}
export declare class Listing {
    requestUrl?: string;
    data: Data;
    loading: boolean;
    queryParameters: {
        [key: string]: string | number;
    };
    listItemComponent: string;
    sideFiltersComponent: string;
    topFiltersComponent: string;
    headerEnabled: boolean;
    topFiltersEnabled: boolean;
    sideFiltersEnabled: boolean;
    searchEnabled: boolean;
    componentWillLoad(): Promise<void>;
    fetchData(): Promise<void>;
    handleFilterChange(event: CustomEvent<{
        filterName: string;
        value: string | number;
    }>): void;
    updateUrlWithQueryParams(): void;
    renderHeader(): any;
    renderSideFilters(): any;
    renderTopFilters(): any;
    render(): any;
}
export {};
