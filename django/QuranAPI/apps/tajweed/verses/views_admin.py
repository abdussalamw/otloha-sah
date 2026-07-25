from django import forms
from django.contrib import messages
from django.contrib.auth.mixins import LoginRequiredMixin
from django.forms import modelformset_factory
from django.shortcuts import render, get_object_or_404, reverse, redirect
from django.utils.safestring import mark_safe
from django.utils.translation import gettext_lazy as _
from django.views import View

from apps.main.views_admin import AdminListView
from apps.narrations.models import Verse
from apps.narrations.verses.filters import VerseFilter
from apps.tajweed.models import Character, Book


class VersesListingView(LoginRequiredMixin, AdminListView):
    model = Verse
    filterset_class = VerseFilter
    title = _('All Verses')
    list_display = (
        ('id', _('ID')),
        ('image', _('Image')),
        ('text', _('Text')),
        ('verse_number', _('Verse Number')),
        ('chapter', _('Chapter')),
        ('part', _('Part')),
    )
    book = None
    narration = None

    def get_title(self):
        return _("All Verses of {book} Book").format(book=self.book.translated_name)

    def get_queryset(self):
        self.book = get_object_or_404(Book, pk=self.kwargs['book_id'])
        self.narration = self.book.narration
        queryset = super().get_queryset()
        queryset = queryset.filter(narration=self.narration).order_by('chapter__pk', "verse_number")
        if self.filterset_class:
            queryset = self.filterset_class(self.request.GET, queryset).qs
        return queryset

    def get_breadcrumb(self):
        return [
            {"name": _("Home"), "url": reverse('admin:main:home')},
            {"name": self.book, "url": reverse('admin:tajweed:books:details', args=[self.book.id])},
            {"name": self.title}
        ]

    def load_text(self, obj):
        details = reverse('admin:tajweed:books:verses:details', args=[self.book.pk, obj.pk])
        return mark_safe('<td class="main-cell uthmainc-font"><a href="{}">{}</a></td>'.format(details, obj.text))

    def load_verse_number(self, obj):
        return mark_safe('<td>{}</td>'.format(obj.verse_number))

    def load_page(self, obj):
        details = reverse('admin:narrations:pages:details', args=[obj.narration_id, obj.page.id])
        return mark_safe('<td><a href="{}">{}</a></td>'.format(details, obj.page_number))

    def load_chapter(self, obj):
        return mark_safe('<td class="uthmainc-font">{}</td>'.format(obj.chapter.translated_name))

    def load_part(self, obj):
        return mark_safe('<td class="uthmainc-font">{}</td>'.format(obj.part.translated_name))


class VerseDetailsView(View):
    def get(self, request, book_id, verse_id, *args, **kwargs):
        book = get_object_or_404(Book, pk=book_id)
        verse = get_object_or_404(Verse, pk=verse_id)
        characters = verse.character_set.all()

        return render(request, 'tajweed/verses/details.html', {
            # "prev_verse_url": reverse('admin:tajweed:verses:details',
            #                           args=[verse.previous_verse.id]) if verse.previous_verse else None,
            # "next_verse_url": reverse('admin:tajweed:verses:details',
            #                           args=[verse.next_verse.id]) if verse.next_verse else None,
            "book": book,
            'verse': verse,
            'characters': characters,
            'title': _('Verse ( {text} ) Tajweed Details').format(text=verse.text)
        })


class VerseUpdateView(View):
    # def get_formset(self):
    #     return modelformset_factory(
    #         Character,
    #         fields=(
    #             'character_text', 'character_number', 'word', 'word_number', 'rule_text',
    #             'verse_number'),
    #         widgets={'rule': forms.Textarea(attrs={'rows': 2})})

    def get(self, request, book_id, verse_id, *args, **kwargs):
        book = get_object_or_404(Book, pk=book_id)
        verse = get_object_or_404(Verse, pk=verse_id)
        characters = verse.character_set.all()
        # formset = self.get_formset()(queryset=characters)
        return render(request, 'tajweed/verses/update.html', {
            # "prev_verse_url": reverse('admin:tajweed:verses:update',
            #                           args=[verse.previous_verse.id]) if verse.previous_verse else None,
            # "next_verse_url": reverse('admin:tajweed:verses:update',
            #                           args=[verse.next_verse.id]) if verse.next_verse else None,
            "book": book,
            'verse': verse,
            'characters': characters,
            'words': verse.verse_words.all(),
            # 'formset': formset,
            'title': _('Update Characters')
        })

    def post(self, request, verse_id, *args, **kwargs):
        verse = get_object_or_404(Verse, pk=verse_id)
        characters = Character.objects.filter(tajweed_verse=verse)
        formset = self.get_formset()(request.POST, queryset=characters)

        if formset.is_valid():
            formset.save()
            messages.success(request, _("Characters Submitted Successfully"))
            if 'submit_and_finish' in request.POST:
                return redirect(reverse('admin:tajweed:verses:details', args=[verse_id]))

        return render(request, 'tajweed/verses/update.html', {
            # "prev_verse_url": reverse('admin:tajweed:verses:update',
            #                           args=[verse.previous_verse.id]) if verse.previous_verse else None,
            # "next_verse_url": reverse('admin:tajweed:verses:update',
            #                           args=[verse.next_verse.id]) if verse.next_verse else None,
            'verse': verse,
            'characters': characters,
            'formset': formset,
            'title': _('Update Characters')
        })
