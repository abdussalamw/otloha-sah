import { r as registerInstance, h } from './index-77994f1e.js';

function counterUp(startValue, endValue, duration, updateCallback) {
    let startTime = null;
    function animate(time) {
        if (!startTime)
            startTime = time;
        const elapsed = time - startTime;
        const progress = Math.min(elapsed / duration, 1);
        const currentValue = Math.floor(startValue + (endValue - startValue) * progress);
        updateCallback(currentValue);
        if (progress < 1) {
            requestAnimationFrame(animate);
        }
    }
    requestAnimationFrame(animate);
}

const indicatorCss = ".indicator{display:flex;align-items:center;width:100%;height:fit-content;padding:12px;border:1px solid var(--item-border-color, #f0f0f0);border-radius:8px;background-color:var(--item-bg-color, #fff);color:var(--item-color, #181C32);text-decoration:none;gap:12px;flex-grow:1}.indicator:last-child{margin-right:0}.indicator__body{display:flex;flex-direction:column;justify-content:center}.indicator__value,.indicator__label{margin:0}.indicator__value{font-size:20px;font-weight:bold}.indicator__label{font-size:14px}";

const Indicator = class {
    constructor(hostRef) {
        registerInstance(this, hostRef);
        this.label = undefined;
        this.color = 'var(--primary-color, #181C32)';
        this.bgColor = 'var(--background-color, #ffffff)';
        this.borderColor = 'var(--border-color, #f0f0f0)';
        this.requestUrl = undefined;
        this.requestMethod = 'GET';
        this.link = undefined;
        this.csrfToken = undefined;
        this.value = undefined;
        this.displayValue = 0;
        this.hasError = false;
    }
    async connectedCallback() {
        if (this.value === undefined) {
            await this.fetchValue();
        }
        else {
            this.displayValue = this.value;
        }
    }
    async fetchValue() {
        var _a, _b, _c;
        try {
            const response = await fetch(this.requestUrl, {
                method: this.requestMethod,
                headers: {
                    'X-CSRF-Token': (_a = this.csrfToken) !== null && _a !== void 0 ? _a : '',
                },
            });
            if (!response.ok)
                throw new Error('Network response was not ok');
            const data = await response.json();
            this.displayValue = (_c = (_b = data.count) !== null && _b !== void 0 ? _b : data.value) !== null && _c !== void 0 ? _c : 0;
        }
        catch (error) {
            console.error('Error fetching value:', error);
            this.hasError = true;
        }
    }
    handleValueChange() {
        if (this.value !== undefined) {
            counterUp(this.displayValue, this.value, 1000, (newDisplayValue) => {
                this.displayValue = newDisplayValue;
            });
        }
    }
    render() {
        return (h("a", { key: 'b05b6ef7c55012df805357b40fb0c46c57b6b4e0', href: this.link, class: "indicator", style: {
                '--item-color': this.color,
                '--item-bg-color': this.bgColor,
                '--item-border-color': this.borderColor
            } }, h("span", { key: '11af32ebe1300a77337372a984f25d2712feb506', class: "indicator__icon" }, h("slot", { key: '2831c32af40aa98f39cabf659b360f216dd212cd', name: "icon" })), h("span", { key: 'ce898c94b74aef82302eb39c88a5b2c0f0282ff2', class: "indicator__body" }, h("p", { key: '04b564d553c181c9c68bf147c560dee14bad05d9', class: "indicator__value" }, this.hasError ? 'N/A' : this.displayValue), h("p", { key: '6c84a0671c289cccff83264879cfb6bc154d8375', class: "indicator__label" }, this.label))));
    }
    static get watchers() { return {
        "value": ["handleValueChange"]
    }; }
};
Indicator.style = indicatorCss;

export { Indicator as c_indicator };

//# sourceMappingURL=c-indicator.entry.js.map