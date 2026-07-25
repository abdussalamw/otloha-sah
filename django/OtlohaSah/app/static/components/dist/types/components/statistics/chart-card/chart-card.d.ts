import { ChartData } from "../../../utils/types";
export declare class ChartCard {
    data: ChartData;
    component: string;
    renderSegment(segment: {
        count: number;
        name: string;
        color: string;
    }): any;
    render(): any;
}
