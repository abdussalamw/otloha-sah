import { Segment } from "../../../utils/types";
export declare class DonutChart {
    el: HTMLElement;
    data: Segment[];
    colors: string[];
    width: number;
    height: number;
    holeRadius: number;
    strokeWidth: number;
    private canvas;
    componentDidLoad(): void;
    dataChanged(): void;
    drawChart(): void;
    render(): any;
}
