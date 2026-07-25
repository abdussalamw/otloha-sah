import { EventEmitter } from '../../../stencil-public-runtime';
export declare class FilterInput {
    initialValue: string;
    inputComponent: string;
    componentProps: {
        [key: string]: any;
    };
    withMargin: boolean;
    value: string;
    private debounceTimeout;
    filterChange: EventEmitter<{
        filterName: string;
        value: string;
    }>;
    handleValueChange(newValue: string): void;
    render(): any;
}
