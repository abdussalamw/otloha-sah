export declare class Indicator {
    label?: string;
    color: string;
    bgColor: string;
    borderColor: string;
    requestUrl?: string;
    requestMethod: string;
    link?: string;
    csrfToken?: string;
    value?: number;
    displayValue: number;
    hasError: boolean;
    connectedCallback(): Promise<void>;
    fetchValue(): Promise<void>;
    handleValueChange(): void;
    render(): any;
}
