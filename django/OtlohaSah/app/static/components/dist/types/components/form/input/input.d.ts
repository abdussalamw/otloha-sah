import { EventEmitter } from '../../../stencil-public-runtime';
export declare class Input {
    label: string;
    errors: any;
    value: string;
    type: string;
    internalValue: string;
    valueChange: EventEmitter<string>;
    handleInput(event: Event): void;
    render(): any;
}
