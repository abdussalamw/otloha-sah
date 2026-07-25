import { B as BUILD, c as consoleDevInfo, H, d as doc, N as NAMESPACE, p as promiseResolve, b as bootstrapLazy } from './index-77994f1e.js';
export { s as setNonce } from './index-77994f1e.js';
import { g as globalScripts } from './app-globals-0f993ce5.js';

/*
 Stencil Client Patch Browser v4.22.1 | MIT Licensed | https://stenciljs.com
 */
var patchBrowser = () => {
  if (BUILD.isDev && !BUILD.isTesting) {
    consoleDevInfo("Running in development mode.");
  }
  if (BUILD.cloneNodeFix) {
    patchCloneNodeFix(H.prototype);
  }
  const scriptElm = BUILD.scriptDataOpts ? Array.from(doc.querySelectorAll("script")).find(
    (s) => new RegExp(`/${NAMESPACE}(\\.esm)?\\.js($|\\?|#)`).test(s.src) || s.getAttribute("data-stencil-namespace") === NAMESPACE
  ) : null;
  const importMeta = import.meta.url;
  const opts = BUILD.scriptDataOpts ? (scriptElm || {})["data-opts"] || {} : {};
  if (importMeta !== "") {
    opts.resourcesUrl = new URL(".", importMeta).href;
  }
  return promiseResolve(opts);
};
var patchCloneNodeFix = (HTMLElementPrototype) => {
  const nativeCloneNodeFn = HTMLElementPrototype.cloneNode;
  HTMLElementPrototype.cloneNode = function(deep) {
    if (this.nodeName === "TEMPLATE") {
      return nativeCloneNodeFn.call(this, deep);
    }
    const clonedNode = nativeCloneNodeFn.call(this, false);
    const srcChildNodes = this.childNodes;
    if (deep) {
      for (let i = 0; i < srcChildNodes.length; i++) {
        if (srcChildNodes[i].nodeType !== 2) {
          clonedNode.appendChild(srcChildNodes[i].cloneNode(true));
        }
      }
    }
    return clonedNode;
  };
};

patchBrowser().then(async (options) => {
  await globalScripts();
  return bootstrapLazy([["c-student-card",[[0,"c-student-card",{"item":[8]}]]],["recitation-statistics",[[0,"recitation-statistics",{"baseUrl":[1,"base-url"],"data":[32]}]]],["c-student-side-filters",[[0,"c-student-side-filters"]]],["c-indicator",[[1,"c-indicator",{"label":[1],"color":[1],"bgColor":[1,"bg-color"],"borderColor":[1,"border-color"],"requestUrl":[1,"request-url"],"requestMethod":[1,"request-method"],"link":[1],"csrfToken":[1,"csrf-token"],"value":[2],"displayValue":[32],"hasError":[32]},null,{"value":["handleValueChange"]}]]],["c-input",[[0,"c-input",{"label":[1],"errors":[8],"value":[1],"type":[1],"internalValue":[32]}]]],["c-listing",[[4,"c-listing",{"requestUrl":[1,"request-url"],"listItemComponent":[1,"list-item-component"],"sideFiltersComponent":[1,"side-filters-component"],"topFiltersComponent":[1,"top-filters-component"],"headerEnabled":[4,"header-enabled"],"topFiltersEnabled":[4,"top-filters-enabled"],"sideFiltersEnabled":[4,"side-filters-enabled"],"searchEnabled":[4,"search-enabled"],"data":[32],"loading":[32],"queryParameters":[32]}]]],["c-pagination",[[0,"c-pagination",{"currentPage":[2,"current-page"],"totalPages":[2,"total-pages"]}]]],["donut-chart",[[0,"donut-chart",{"data":[16],"width":[2],"height":[2],"holeRadius":[2,"hole-radius"],"strokeWidth":[2,"stroke-width"]},null,{"data":["dataChanged"]}]]],["statistics-icon",[[0,"statistics-icon",{"classes":[1]}]]],["c-badge",[[4,"c-badge",{"extraClass":[1,"extra-class"],"text":[1]}]]],["c-bool-badge",[[4,"c-bool-badge",{"extraClass":[1,"extra-class"],"test":[4],"successClass":[1,"success-class"],"failedClass":[1,"failed-class"],"successText":[1,"success-text"],"failedText":[1,"failed-text"]}]]],["c-filter-input",[[0,"c-filter-input",{"initialValue":[1,"initial-value"],"inputComponent":[1,"input-component"],"componentProps":[16],"withMargin":[4,"with-margin"],"value":[32]}]]],["c-gender",[[0,"c-gender",{"gender":[1]}]]],["c-listing-actions",[[0,"c-listing-actions",{"actions":[16],"icon":[4]}]]],["c-user-avatar",[[4,"c-user-avatar",{"link":[1],"name":[1],"image":[1]}]]],["chart-card",[[0,"chart-card",{"data":[16],"component":[1]}]]],["counties-table",[[0,"counties-table",{"heatData":[16]},null,{"heatData":["heatDataChanged"]}]]],["world-heatmap",[[0,"world-heatmap",{"heatData":[16]},null,{"heatData":["heatDataChanged"]}]]]], options);
});

//# sourceMappingURL=components.esm.js.map