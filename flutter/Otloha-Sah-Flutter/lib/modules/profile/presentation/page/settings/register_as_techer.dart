import 'dart:ui' as ui;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:otloha_sah_flutter/core/design_system/components/cards/app_card.dart';
import 'package:otloha_sah_flutter/core/design_system/tokens/app_colors.dart';
import 'package:otloha_sah_flutter/core/design_system/tokens/app_radius.dart';
import 'package:otloha_sah_flutter/core/design_system/tokens/app_spacing.dart';
import 'package:otloha_sah_flutter/core/design_system/tokens/app_typography.dart';
import 'package:otloha_sah_flutter/core/utils/constant/utils.dart';
import 'package:otloha_sah_flutter/core/widgets/text_from_fielid.dart';
import 'package:otloha_sah_flutter/core/widgets/tool_bar_app.dart';
import 'package:otloha_sah_flutter/core/widgets/vali_errorr_text.dart';
import 'package:otloha_sah_flutter/core/widgets/warnings_and_alerts/warning.dart';
import 'package:otloha_sah_flutter/data_source/models/translation/translatable.dart';
import 'package:otloha_sah_flutter/modules/auth_module/presentation/pages/login_page.dart';
import 'package:otloha_sah_flutter/modules/home/presentation/pages/home/home_page.dart';
import 'package:otloha_sah_flutter/modules/profile/business_logic/register_as_teacher/register_as_teacher_cubit.dart';
import 'package:otloha_sah_flutter/modules/profile/business_logic/register_as_teacher/register_as_teacher_state.dart';
import 'package:otloha_sah_flutter/modules/profile/presentation/widget/add_teach_narration_dialog.dart';
import 'package:otloha_sah_flutter/modules/profile/presentation/widget/file_upload.dart';
import 'package:otloha_sah_flutter/modules/profile/presentation/widget/selected_narration_element.dart';
import 'package:otloha_sah_flutter/modules/settings/business_logic/settings/settings_cubit.dart';

class RegisterAsTeacher extends StatelessWidget {
  const RegisterAsTeacher({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Directionality(
      textDirection: ui.TextDirection.rtl,
      child: BlocConsumer<SettingsCubit, SettingsState>(
        listener: (ctx, state) {
          if (state is RegisterAsTeacherSuccessState) {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
            Fluttertoast.showToast(
              msg: translate('Your request to be a teacher is created successfully'),
              backgroundColor: AppColors.primary,
              timeInSecForIosWeb: 4,
              gravity: ToastGravity.BOTTOM,
            );

            Navigator.of(context).pushNamedAndRemoveUntil(
              HomePage.routeName,
              (route) => false,
            );
          } else if (state is AuthErrorState) {
            Fluttertoast.showToast(
              msg: translate('The Token has expired, go to "Login" to login'),
              backgroundColor: AppColors.primary,
              timeInSecForIosWeb: 4,
              gravity: ToastGravity.BOTTOM,
            );
            Navigator.of(context).pushNamedAndRemoveUntil(
              LoginPage.routeName,
              (route) => false,
            );
          }
        },
        builder: (ctx, settingsState) {
          var cubit = SettingsCubit.get(context);

          return Scaffold(
            backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
            body: SafeArea(
              child: Column(
                children: [
                  ToolBarApp(
                    backIcon: IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new_rounded),
                      onPressed: () {
                        if (Navigator.of(context).canPop()) {
                          Navigator.of(context).pop();
                        }
                      },
                    ),
                    title: tr('طلب التسجيل كمعلم تجويد'),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      child: Column(
                        children: [
                          AppCard(
                            padding: const EdgeInsets.all(AppSpacing.md),
                            child: BlocProvider(
                              create: (context) => TeacherRegistrationCubit()..initData(),
                              child: BlocBuilder<TeacherRegistrationCubit, TeacherRegistrationState>(
                                builder: (context, state) {
                                  if (state is TeacherRegistrationChangeState) {
                                    return Form(
                                      key: TeacherRegistrationCubit.cubit(context).formKey,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            tr('تقديم بيانات المعلم والإجازات القرآنية'),
                                            style: AppTypography.h3Bold(
                                              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                                            ),
                                          ),
                                          const SizedBox(height: AppSpacing.xs),
                                          Text(
                                            translate('نسعد بأن تكون معلماً معنا. نرجو إدخال المؤهل العلمي وإرفاق السيرة الذاتية والإجازات.'),
                                            style: AppTypography.bodySmall(
                                              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                                            ),
                                          ),
                                          const SizedBox(height: AppSpacing.md),

                                          if (settingsState is InvalidDataErrorState)
                                            ValidationErrorText(
                                              error: (settingsState.error.errors!.containsKey('full_name'))
                                                  ? settingsState.error.errors!['full_name'][0]
                                                  : '',
                                            ),
                                          TextFormFieldApp(
                                            color: AppColors.primary,
                                            controller: TeacherRegistrationCubit.cubit(context).educationController,
                                            keyboardType: TextInputType.name,
                                            title: tr('المؤهل العلمي والتخصص'),
                                            validator: [
                                              FormBuilderValidators.required(),
                                            ],
                                          ),

                                          if (settingsState is InvalidDataErrorState)
                                            ValidationErrorText(
                                              error: (settingsState.error.errors!.containsKey('education_degree'))
                                                  ? settingsState.error.errors!['education_degree'][0]
                                                  : '',
                                            ),
                                          const SizedBox(height: AppSpacing.md),

                                          UploadFile(
                                            onCancel: (string) {
                                              TeacherRegistrationCubit.cubit(context).removeCVFile();
                                            },
                                            onUpload: (file) {
                                              TeacherRegistrationCubit.cubit(context).uploadCVFile(file?[0]);
                                            },
                                            title: translate('السيرة الذاتية (C.V.)'),
                                            titleStyle: AppTypography.bodyLarge(
                                              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                                            ).copyWith(fontWeight: FontWeight.bold),
                                          ),

                                          if (settingsState is InvalidDataErrorState)
                                            ValidationErrorText(
                                              error: (settingsState.error.errors!.containsKey('cv'))
                                                  ? settingsState.error.errors!['cv'][0]
                                                  : '',
                                            ),
                                          const SizedBox(height: AppSpacing.md),
                                          const Divider(),
                                          const SizedBox(height: AppSpacing.xs),

                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                tr('الروايات والإجازات'),
                                                style: AppTypography.h3Bold(
                                                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: AppSpacing.xs),

                                          if (TeacherRegistrationCubit.cubit(context).selectedNarrations.isEmpty)
                                            WarningMessage(
                                              text: translate('يجب إضافة إجازة أو رواية واحدة على الأقل'),
                                            ),

                                          for (var m in TeacherRegistrationCubit.cubit(context).selectedNarrations.keys) ...[
                                            SelectedNarrationElement(
                                              narration: m,
                                              name: m.name.translate() ?? '',
                                              file: TeacherRegistrationCubit.cubit(context).selectedNarrations[m]?.split('/').last,
                                            ),
                                          ],

                                          Align(
                                            alignment: AlignmentDirectional.topStart,
                                            child: TextButton.icon(
                                              icon: const Icon(Icons.add_circle_outline_rounded, color: AppColors.primary),
                                              label: Text(
                                                translate('إضافة شهادة أو إجازة جديدة'),
                                                style: AppTypography.bodyMedium(color: AppColors.primary).copyWith(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              onPressed: TeacherRegistrationCubit.cubit(context).selectedNarrations.length >=
                                                      TeacherRegistrationCubit.cubit(context).narrations!.length
                                                  ? null
                                                  : () {
                                                      showDialog(
                                                        context: context,
                                                        builder: (dialogContext) => Dialog(
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius: AppRadius.radiusLg,
                                                          ),
                                                          child: AddTeacherNarrationDialog(
                                                            narrations: TeacherRegistrationCubit.cubit(context).getRestNarrations(),
                                                            onSubmit: (result) {
                                                              TeacherRegistrationCubit.cubit(context).addNarration(result);
                                                              Navigator.pop(context);
                                                            },
                                                          ),
                                                        ),
                                                      );
                                                    },
                                            ),
                                          ),
                                          const SizedBox(height: AppSpacing.md),

                                          if (settingsState is RegisterAsTeacherLoadingState)
                                            const Center(child: CircularProgressIndicator())
                                          else
                                            SizedBox(
                                              width: double.infinity,
                                              height: 48,
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: AppColors.primary,
                                                  shape: RoundedRectangleBorder(borderRadius: AppRadius.radiusMd),
                                                ),
                                                onPressed: () {
                                                  TeacherRegistrationCubit.cubit(context).update(cubit, settingsState, context);
                                                },
                                                child: Text(
                                                  tr('تقديم طلب الانضمام'),
                                                  style: AppTypography.bodyMedium(color: Colors.white).copyWith(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    );
                                  }
                                  return const Center(child: CircularProgressIndicator());
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
