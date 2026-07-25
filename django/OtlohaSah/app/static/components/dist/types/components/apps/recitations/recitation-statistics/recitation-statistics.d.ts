import { ChartData } from "../../../../utils/types";
export declare class RecitationStatistics {
    baseUrl?: string;
    data: any;
    fetchData(): Promise<void>;
    componentWillLoad(): Promise<void>;
    renderCartCards(data: Record<string, ChartData> | undefined): any[];
    renderSection(section: Record<string, any> | undefined): any;
    render(): any;
}
