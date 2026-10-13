# Otloha Sah (أطلها صح) — دليل المهارة الشامل وقواعد العمل البرمجي (Universal AI Skill)

> **تنبيه إلزامي لجميع نماذج ووكلاء الذكاء الاصطناعي (AI Models & Agents):**
> هذا الملف هو المرجع السيادي الأول لجميع مهام التطوير في هذا المشروع. يُلزم أي نموذج ذكاء اصطناعي (Gemini, Claude, GPT, Cursor, Copilot, Antigravity) بقراءة هذا الملف والالتزام بجميع بنوده حرفياً قبل تنفيذ أو اقتراح أي تعديل برمجي.

---

## 1. الهيكل العام للمشروع (Project Architecture)

المشروع عبارة عن منظومة متكاملة لتعليم القرآن الكريم وتصحيح التلاوة والتجويد، ويتكون من:

```text
otloha/
├── flutter/
│   ├── Otloha-Sah-Flutter/       # تطبيق الهاتف الأساسي (Flutter Multiplatform)
│   │   ├── lib/
│   │   │   ├── core/             # التصميم والشبكة والأخطاء والخدمات العامة
│   │   │   │   ├── design_system/# التوكنز: AppColors, AppTypography, AppSpacing...
│   │   │   │   └── network/      # ApiBaseHelper, Interceptors, NetworkInfo
│   │   │   ├── data_source/      # قواعد البيانات المحلية والخدمات البعيدة
│   │   │   │   ├── local/        # Drift/Floor SQLite Database & DAOs
│   │   │   │   └── remote/       # QuranEncService, AuthServices...
│   │   │   └── modules/          # الوحدات الوظيفية (Feature-First Architecture)
│   │   │       ├── quran_hafs/   # مصحف حفص (QCF4 + SQLite أوفلاين)
│   │   │       ├── quran/        # القارئ العام، التفسير، الإشارات المرجعية
│   │   │       ├── audio/        # مشغل الصوتيات وتسجيل التلاوات
│   │   │       ├── messages/     # تصحيح التلاوات والمحادثات
│   │   │       ├── settings/     # الإعدادات والتفاسير والروايات
│   │   │       └── auth_module/  # تسجيل الدخول والمصادقة
│   └── quran_flutter_widget/     # حزمة ودجت المصحف المحلية المخصصة
├── django/                       # خادم الباك إند (Django Backend & REST APIs)
├── systemdesigne.md              # نظام التصميم البصري المعتمد
└── skill.md                      # هذا الدليل الإرشادي الموحد
```

---

## 2. القواعد الصارمة — لا استثناءات (Zero Breakage & Safety Rules)

| القاعدة | التفاصيل والتطبيق الإلزامي |
| :--- | :--- |
| **مبدأ عدم الكسر وحماية الميزات** | تنفيذ المطلوب بدقة دون حذف أي ميزة سابقة، ويُمنع منعاً باتاً كسر أو حذف أي كود إلا بعد التحقق القطعي والبحث الشامل والتأكد من أنه لا يوجد أي كود آخر يعتمد عليه. لا تقم بإعادة كتابة الملفات الكبيرة بالكامل، بل استخدم التعديلات الموضعية الدقيقة. |
| **حظر بناء التطبيق إلا بإذن خطي** | **ممنوع نهائياً وباتاً** تشغيل أوامر بناء التطبيق (`flutter build apk`, `flutter build appbundle`, إلخ) إلا بعد الحصول على إذن وموافقة خطية صريحة ومباشرة من المستخدم. |
| **حظر الرفع للمستودع إلا بإذن خطي** | **ممنوع نهائياً وباتاً** تنفيذ أمر رفع التعديلات للمستودع البعيد (`git push`) إلا بعد الحصول على إذن وموافقة خطية صريحة ومباشرة من المستخدم. |
| **العمل بدون إنترنت (Offline-First)** | المصحف، التفسير، الترجمة، الإشارات المرجعية، والآيات المفضلة يجب أن تعمل 100% دون الحاجة لأي اتصال بالإنترنت مع وجود Fallback دائم. |
| **قواعد بيانات SQLite / Drift** | **ممنوع نهائياً** تمرير معرّف ثابت مثل `id: 0` عند الإدراج. استخدم دائماً `const Value.absent()` للمفاتيح الرئيسية التلقائية (`autoIncrement`). |
| **تسجيل الدخول غير إلزامي** | التصفح، قراءة المصحف، الاستماع، حفظ العلامات، واستعراض التفسير متاح بالكامل للزائر (`Guest` / `userId == 0`) دون أي إجبار على تسجيل الدخول. |
| **البروتوكول والشبكة** | الروابط تستخدم `http` و `ws` أثناء التطوير لتجاوز قيود SSL. دالة `checkNetwork` تعتمد على `Connectivity` وتفحص وجود اتصال فعلي دون إطلاق استثناءات وهمية. |
| **الحفاظ على التوثيق والتعليقات** | احتفظ بجميع التعليقات البرمجية الموجودة والتوثيقات السابقة ما لم يطلب المستخدم حذفها صراحة. |

---

## 3. معايير الهوية البصرية ونظام التصميم (System Design Tokens)

يجب الالتزام الحرفي بنظام التصميم في `systemdesigne.md` وملفات `lib/core/design_system/`:

1. **الألوان المعتمدة (AppColors):**
   - **الرئيسي (Primary):** الأزرق الملكي (`AppColors.primary = Color(0xFF0056B3)`).
   - **الداكن (Dark):** الكحلي الليلي (`AppColors.primaryDark = Color(0xFF003366)`).
   - **الفاتح (Secondary / Tint):** أزرق ثلجي ناعم (`#E7F1FF`).
   - **التدرج الرئاسي:** `AppColors.headerGradient` لجميع شاشات الـ Top Bar و AppBars.
   - **ممنوع استخدام ألوان Hardcoded عشوائية** داخل الواجهات.
2. **الخطوط والطباعة (Typography):**
   - الاعتماد على `AppTypography` (`Cairo` / `Tajawal` / `Beiruti`).
   - خطوط المصحف: خطوط مجمع الملك فهد الرسمية `QCF4_XXX` لمصحف حفص.
3. **الحواف والظلال (Radius & Shadows):**
   - الأزرار: `AppRadius.sm` (8px).
   - البطاقات (Cards): `AppRadius.md` (12px) مع ظلال ناعمة `AppShadows.softCardLight`.

---

## 4. منظومة التفسير والترجمات (QuranEnc Integration)

1. **الخدمة المركزية:** تُدار جميع بيانات التفسير والترجمة عبر [QuranEncService](file:///c:/xampp/htdocs/otloha/flutter/Otloha-Sah-Flutter/lib/data_source/remote/quranenc_service.dart).
2. **الإصدارات المعتمدة:**
   - المختصر في التفسير (`arabic_mokhtasar` - ~4.8 MB).
   - التفسير الميسر (`arabic_moyassar` - ~4.2 MB).
   - تفسير السعدي (`arabic_saadi` - ~5.5 MB).
   - Saheeh International (`english_saheeh` - ~3.9 MB).
3. **التخزين المحلي:** تخزن البيانات محلياً في SQLite (`quranenc_tafseer_cache.db`).
4. **عنصر العرض:** استخدام [QuranEncTafseerWidget](file:///c:/xampp/htdocs/otloha/flutter/Otloha-Sah-Flutter/lib/modules/quran/presentation/widget/quranenc_tafseer_widget.dart) كنافذة موحدة في جميع المصاحف والإعدادات ومتصفح التفسير [TafsirBrowserPage](file:///c:/xampp/htdocs/otloha/flutter/Otloha-Sah-Flutter/lib/modules/quran/presentation/page/tafsir_browser_page.dart).

---

## 5. قواعد التسجيل الصوتي وتلاوات المستخدمين (Audio & Recitations)

1. **الأذونات:** فحص الميكروفون يتم عبر `recorder.hasPermission()` المدمج من الحزمة أولاً، مع تفادي التنبيهات المزعجة للمستخدم في حال عدم الرفض الدائم.
2. **مسار الحفظ:** يتم إنشاء مجلد مخصص `FilesGeneratedRecord` داخل مسار التطبيق الآمن قبل بدء أي تسجيل.
3. **حفظ التسجيل:** تُحفظ التلاوة محلياً عبر `DatabaseRepository.insertUserRecitations` في جدول `LocalRecitation` مع استخراج المسار الفعلي من `recorder.stop()`.

---

## 6. إجراءات دورة العمل قبل اعتماد أي تعديل (Checklist)

قبل إعلان اكتمال أي مهمة للمستخدم:
1. فحص الكود بأداة التحليل `dart analyze` والتأكد من خلوه من أي أخطاء تجميعية (`0 Errors`).
2. التأكد من حفظ التعديلات في فرع مستقل (Feature Branch) إذا كانت الميزة تجريبية، لسهولة التراجع أو الدمج.
3. **عدم بناء التطبيق نهائياً** إلا إذا طلب المستخدم ذلك كتابةً وبشكل صريح.
4. **عدم تنفيذ `git push` نهائياً** إلا إذا طلب المستخدم ذلك كتابةً وبشكل صريح.
5. الرد على المستخدم باللغة العربية دائماً وبصيغة مهنية واضحة ودقيقة.
