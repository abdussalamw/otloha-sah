import { r as registerInstance, h } from './index-77994f1e.js';

const StudentCard = class {
    constructor(hostRef) {
        registerInstance(this, hostRef);
        this.item = undefined;
    }
    render() {
        return (h("div", { key: '2ac13d875cf1cdebcd2cf21073fc88e83c24ec7b', class: "card mb-5" }, h("div", { key: 'f7ec075e567d72f95cb1ff192422f75fbb7b19ba', class: "card-header flex-nowrap px-4" }, h("div", { key: 'a657fe67dcf603c8cfa2dc0f21351f40de14a431', class: "card-title" }, h("c-user-avatar", { key: '50ad037138dd86bb9a6d82cc1002771d4eeea5b0', name: this.item.fullname, link: this.item.urls.profile, image: this.item.profile_image }, h("div", { key: 'f4bcc73cee58734946ef98f171160fa9a82ff4f2', class: "d-flex flex-column justify-content-center flex-grow-1" }, h("a", { key: '1c5f3dcbbbd4b5e3994db1c62cacae3554111970', href: this.item.urls.profile, class: "fs-5 fw-bold mb-0 me-2" }, this.item.fullname), h("p", { key: '5a7c4cb6d2e19720ade35b3eee6aeea8f2f768d4', class: "fs-7 text-gray-600 mb-1 me-2" }, this.item.email), h("div", { key: 'f38a73c892621b24d8f62e5e206579991ec98a50', class: "d-flex flex-wrap mb-1" }, h("c-bool-badge", { key: '15b767625fc720ad5bb3e84eb0ac6bfab674a1db', class: "me-2 fs-8", test: this.item.is_verified, "success-text": "Verified", "failed-text": "Unverified" }), h("c-badge", { key: '6d3a0931bddc74f0ce03ccf9da348b9694f3048c', class: "me-2 fs-8", "extra-class": "badge-light-warning" }, h("i", { key: '6c14c6906be8eb8fab29707bcc6febd4ecf8e9dc', class: "fa fa-star text-warning me-1" }), " ", this.item.rate, " - ", this.item.level_text), h("c-bool-badge", { key: 'fb54d5e30e14f1936d93101e5716c6aaefde522f', class: "me-2 fs-8", test: this.item.is_active, "success-text": "Active", "failed-text": "Blocked" }))))), h("div", { key: '7e6e038a4d304819d15901c3abfdf6ea74ee6ba7', class: "card-toolbar flex-nowrap" }, h("c-gender", { key: 'b049f6b77b17034dd7605a3ecd96c4ef213ebb4c', gender: this.item.gender }), h("c-listing-actions", { key: 'd2302f7cf0958f580d693789906163970ae7550f', actions: this.item.actions }))), h("div", { key: 'de47dff967ae5e80ddac6b00230918b7d8bc4729', class: "card-body" }, this.item.username)));
    }
};

export { StudentCard as c_student_card };

//# sourceMappingURL=c-student-card.entry.js.map