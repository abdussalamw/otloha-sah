from django.core.exceptions import ValidationError
from django.db import models

from apps.invitations import config
from apps.users.models import User
from quran_api_client.models import Chapter, Verse, Narration, Part


class Khatma(models.Model):
    class Meta:
        constraints = [
            models.CheckConstraint(check=models.Q(from_part__lte=models.F('to_part')),
                                   name='from_part_lte_to_part'),
        ]
        indexes = [
            models.Index(fields=['status', 'active']),
            models.Index(fields=['from_part', 'to_part']),
        ]

    def clean(self):
        if self.to_part.part_number > 30:
            raise ValidationError('The "to_part" cannot have a part number greater than 30.')

    def save(self, *args, **kwargs):
        self.full_clean()
        super().save(*args, **kwargs)

    from_part = models.ForeignKey(Part, on_delete=models.CASCADE, related_name='from_part', default=1)
    to_part = models.ForeignKey(Part, on_delete=models.CASCADE, related_name='to_part', default=30)
    narration = models.ForeignKey(Narration, on_delete=models.CASCADE, related_name="narration",
                                  blank=True, null=True)
    status = models.CharField(max_length=20, choices=config.KHATMA_TYPES, default='pending')
    active = models.BooleanField(default=False)
    created_by = models.ForeignKey(User, on_delete=models.CASCADE)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    def __str__(self):
        return str(self.id)


class KhatmaUsers(models.Model):
    class Meta:
        constraints = [
            models.CheckConstraint(check=models.Q(from_chapter__lte=models.F('to_chapter')),
                                   name='from_chapter_lte_to_chapter'),
        ]
        unique_together = ('khatma', 'user', 'is_teacher')

    khatma = models.ForeignKey(Khatma, on_delete=models.CASCADE)
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    is_teacher = models.BooleanField()
    from_chapter = models.ForeignKey(Chapter, on_delete=models.CASCADE, related_name='from_chapter_user', null=True)
    to_chapter = models.ForeignKey(Chapter, on_delete=models.CASCADE, related_name='to_chapter_user', null=True)
    from_verse = models.ForeignKey(Verse, on_delete=models.CASCADE, related_name='from_verse', null=True)
    to_verse = models.ForeignKey(Verse, on_delete=models.CASCADE, related_name='to_verse', null=True)
    created_at = models.DateTimeField(auto_now_add=True, null=True)
    updated_at = models.DateTimeField(auto_now=True, null=True)

    def __str__(self):
        return self.khatma
