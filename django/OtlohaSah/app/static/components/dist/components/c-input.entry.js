import { r as registerInstance, a as createEvent, h } from './index-77994f1e.js';

const Input = class {
    constructor(hostRef) {
        registerInstance(this, hostRef);
        this.valueChange = createEvent(this, "valueChange", 7);
        this.label = undefined;
        this.errors = undefined;
        this.value = '';
        this.type = 'text';
        this.internalValue = undefined;
    }
    handleInput(event) {
        const input = event.target;
        this.internalValue = input.value;
        this.valueChange.emit(this.internalValue);
    }
    render() {
        return (h("div", { key: '4da91702bf17338c0a0235adcfe55f9a3117a4a5', class: "" }, this.label && h("label", { key: '2325c59f1b27423d614aa3a9ac7d78fe85c0a641', class: "form-label" }, this.label), h("input", { key: 'dc91b230f881cc39738520747df9f85187e42701', class: `form-control ${this.errors ? 'is-invalid' : ''}`, type: this.type, value: this.internalValue, onInput: (event) => this.handleInput(event) }), this.errors && h("p", { key: '2472710698cdad75570d9ffe17c45a50c149c7e2', class: "invalid-feedback" }, this.errors)));
    }
};

export { Input as c_input };

//# sourceMappingURL=c-input.entry.js.map