export declare class CountiesTable {
    heatData: {
        code: string;
        count: number;
        name: string;
    }[];
    heatDataChanged(): void;
    renderItem(item: {
        code: string;
        count: number;
        name: string;
    }): any;
    render(): any;
}
