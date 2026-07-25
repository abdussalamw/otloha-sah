from django.utils.translation import gettext_lazy as _

USER_SETTINGS_GROUP_PRIVACY = 'privacy'

USER_SETTINGS_GROUPS = (
    (USER_SETTINGS_GROUP_PRIVACY, _("Privacy")),
)

USER_SETTINGS_SUBGROUP_GENDER = 'gender'
USER_SETTINGS_SUBGROUP_RECITATIONS = 'recitations'
USER_SETTINGS_SUBGROUPS = (
    (USER_SETTINGS_SUBGROUP_GENDER, _("Gender")),
    (USER_SETTINGS_SUBGROUP_RECITATIONS, _("Recitations")),
)

USER_SETTINGS_DEFAULTS = [
    {
        "user_type": "all",
        "key": 'display_profile_to_opposite_gender',
        "value": False,
        "value_type": "boolean",
        "label": {
            "ar": "عرض الملف الشخصى للمستخدمين من الجنس الاخر",
            "en": 'Show profile to opposite gender'
        },
        "description": {
            "ar": "تنبيه هام: تفعيل هذه الخاصية يعني أنني أوافق على ظهور الملف الشخصي  للمستخدمين من الجنسين رجال "
                  "ونساء",
            "en": "Important Alert: Enabling this feature means that I agree to display the profile to users of "
                  "both genders, males and females."
        },
        "group": USER_SETTINGS_GROUP_PRIVACY,
        "subgroup": USER_SETTINGS_SUBGROUP_GENDER
    },
    {
        "user_type": "student",
        "key": 'display_remarkable_recitations_to_opposite_gender',
        "value": False,
        "value_type": "boolean",
        "label": {
            "ar": "اظهار التلاوات المميزة للمستخدمين من الجنس الآخر",
            "en": "Show Remarkable Recitations to opposite gender",
        },
        "description": {
            "ar": "تنبيه هام: تفعيل هذه الخاصية يعني أنني أوافق على ظهور تلاوتي للمستخدمين من الجنسين رجال ونساء",
            "en": "Important Alert: Activating this feature means that I agree to have my recitation available to users"
                  " of both genders, men and women."
        },
        "group": USER_SETTINGS_GROUP_PRIVACY,
        "subgroup": USER_SETTINGS_SUBGROUP_GENDER
    },
    {
        "user_type": "student",
        "key": 'display_general_box_recitations_to_opposite_gender',
        "value": False,
        "value_type": "boolean",
        "label": {
            "ar": "اظهار تلاوات الصندوق العام للمستخدمين من الجنس الآخر",
            "en": "Show General Box Recitations to opposite gender",
        },
        "description": {
            "ar": "تنبيه هام: تفعيل هذه الخاصية يعني أنني أوافق على ظهور تلاوتي في الصندوق العام  للمستخدمين من الجنسين"
                  " رجال ونساء",
            "en": "Important Notice: Activating this feature means that I agree to have my recitation appear in the"
                  " general box for users of both genders, men and women."
        },
        "group": USER_SETTINGS_GROUP_PRIVACY,
        "subgroup": USER_SETTINGS_SUBGROUP_GENDER
    },
    {
        "user_type": "teacher",
        "key": 'display_teacher_recitations_to_opposite_gender',
        "value": False,
        "value_type": "boolean",
        "label": {
            "ar": "اظهار تلاوات المعلم الخاصة بك للمستخدمين من الجنس الآخر",
            "en": "Show General Box Recitations to opposite gender",
        },
        "description": {
            "ar": "تنبيه هام: تفعيل هذه الخاصية يعنى أنني أوافق على ظهور تلاوة المعلم الخاصة بي فى تلاوات المعلمين "
                  "للمستخدمين من الجنسين رجال ونساء",
            "en": "Important Notice: Enabling this feature means that I agree to have my recitation appear in teachers"
                  " recitations for users of both genders, men and women."
        },
        "group": USER_SETTINGS_GROUP_PRIVACY,
        "subgroup": USER_SETTINGS_SUBGROUP_GENDER
    },
]
