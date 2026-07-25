import * as am5 from "@amcharts/amcharts5";
export declare class WorldHeatmap {
    el: HTMLElement;
    heatData: {
        code: string;
        count: number;
    }[];
    private root;
    private chart;
    private tooltip?;
    private polygonSeries?;
    private maxCount;
    heatDataChanged(): void;
    componentDidLoad(): void;
    disconnectedCallback(): void;
    setTooltip(): void;
    setPolygonSeries(): void;
    setZoomControl(): void;
    initializeChart(): void;
    getRedShade(count: number): am5.Color;
    prepareData(): {
        id: string;
        count: number;
        polygonSettings: {
            fill: am5.Color;
        };
    }[];
    updateChartData(): void;
    render(): any;
}
