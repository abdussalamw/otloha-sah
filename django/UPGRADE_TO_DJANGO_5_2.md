# الترقية إلى Django 5.2 وPython 3.12

تستهدف خدمات `OtlohaSah` و`QuranAPI` وملف اعتماديات `QuranAPIServer` الإصدار **Django 5.2.17 LTS**. أما خدمتا `OtlohaSah` و`QuranAPI` اللتان تبنيان صور Docker محلياً فتستخدمان **Python 3.12**.

> لا تنفذ الترقية على الإنتاج مباشرة. نفّذها أولاً في بيئة staging بعد استعادة نسخة حديثة من قاعدة البيانات وملفات الوسائط.

## الملفات المقفلة

كل خدمة تحتوي على ملفين:

| الملف | الغرض |
|---|---|
| `requirements.txt` | الاعتمادات المباشرة المثبتة التي يديرها المشروع. |
| `requirements.lock` | حل كامل للاعتمادات الانتقالية تم توليده لـPython 3.12. |

عند تعديل اعتماد مباشر، أعد توليد ملف القفل بالأمر التالي من مجلد الخدمة:

```bash
uv pip compile requirements.txt --python-version 3.12 --output-file requirements.lock
```

واستخدم ملف القفل في التحقق المحلي أو CI:

```bash
uv pip sync requirements.lock
uv pip check
```

## تسلسل النشر الآمن

1. أنشئ نسخة احتياطية قابلة للاستعادة من PostgreSQL و`media` و`uploads` قبل النشر.
2. ابنِ الصور الجديدة في staging، ثم تحقق من إصدار Python عبر `python --version` ومن إصدار Django عبر `python -m django --version`.
3. افحص خطة migrations قبل تنفيذها:

```bash
python manage.py migrate --plan
```

4. نفذ migrations مرة واحدة لكل قاعدة بيانات، ثم شغّل فحص Django:

```bash
python manage.py migrate
python manage.py check --deploy
```

5. أعد تشغيل تطبيق ASGI وCelery وCelery Beat، ثم اختبر API وWebSocket والمهام الدورية وتدفقات تسجيل الدخول والإشعارات.
6. راقب أخطاء 5xx ورسائل Celery وقنوات WebSocket، واحتفظ بصورة Docker السابقة وملف القفل السابق للرجوع السريع.

## ملاحظات التوافق المعالجة

تمت إزالة استعمالات `distutils` المتوقفة في Python 3.12، وإصلاح نموذج رفع الملفات المتعدد غير المتوافق مع Django 5.2، وجعل migrations فهارس PostgreSQL النصية تتجاوز محرك SQLite في الاختبارات مع الحفاظ على تشغيل الـtriggers في PostgreSQL.

`QuranAPIServer` ينشر حالياً صوراً خارجية من `ghcr.io/fritill-team/quranapi`. تعديل `requirements.txt` في هذا المستودع لا يعيد بناء تلك الصورة تلقائياً؛ يجب أن تُبنى وتنشر صورة GHCR جديدة من مصدر الخدمة الفعلي قبل رفع بيئة الإنتاج إلى Django 5.2.

## حالة الاختبارات

نجح حل الاعتمادات وفحص Django والمراجعة الآلية لـmigrations في `OtlohaSah` و`QuranAPI` على Python 3.12. توجد اختبارات قديمة في المستودع تحتاج صيانة مستقلة؛ لذلك لا تفسر نجاح `manage.py check` على أنه بديل عن اختبار قبول كامل في staging.
