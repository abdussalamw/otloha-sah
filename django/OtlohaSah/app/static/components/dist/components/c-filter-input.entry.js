import { r as registerInstance, a as createEvent, h } from './index-77994f1e.js';

const FilterInput = class {
    constructor(hostRef) {
        registerInstance(this, hostRef);
        this.filterChange = createEvent(this, "filterChange", 7);
        this.initialValue = '';
        this.inputComponent = 'c-input';
        this.componentProps = {};
        this.withMargin = true;
        this.value = this.initialValue;
    }
    handleValueChange(newValue) {
        this.value = newValue;
        clearTimeout(this.debounceTimeout);
        this.debounceTimeout = setTimeout(() => {
            this.filterChange.emit({ filterName: this.componentProps.name, value: newValue });
        }, 300);
    }
    render() {
        const classes = [
            this.withMargin ? 'mb-10' : ''
        ].join(' ');
        return (h("div", { key: '5c8a754da05b011ee3e01714169e5dce542ea79c', class: classes }, h(this.inputComponent, Object.assign(Object.assign({}, this.componentProps), { value: this.value, onValueChange: (event) => this.handleValueChange(event.detail) }))));
    }
};

export { FilterInput as c_filter_input };

//# sourceMappingURL=c-filter-input.entry.js.map