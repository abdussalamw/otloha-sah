// var TajweedForm = function () {
//     var narrations, chapters, verses;
//
//     function initialize() {
//
//         narrations = $('#id_narration')
//         chapters = $('#id_chapter')
//         verses = $('#id_verse')
//
//         console.log(narrations.val())
//         chapters.select2({
//             placeholder: 'Select a chapter',
//             allowClear: true
//         }).on('select2:select', function (e) {
//                 initializeSelect2(verses, `/admin/quran/narration/${narrations.val()}/chapter/${e.params.data.id}/verses/`)
//             }
//         )
//     }
//
//     function initializeSelect2($el, url) {
//         return $el.select2({
//             ajax: {
//                 url: url,
//                 dataType: 'json',
//                 delay: 250,
//             },
//         });
//     }
//
//     return {
//         init() {
//             initialize()
//
//
//             return {
//                 reset() {
//                     narrations.val(null).trigger('change');
//                     chapters.val(null).trigger('change');
//                     verses.val(null).trigger('change');
//                 },
//             };
//         }
//     };
// }();
//
// if (document.readyState !== 'loading' && document.body) {
//     TajweedForm.init()
// } else {
//     document.addEventListener('DOMContentLoaded', TajweedForm.init)
// }