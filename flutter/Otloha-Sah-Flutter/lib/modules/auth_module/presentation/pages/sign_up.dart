import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:otloha_sah_flutter/core/design_system/components/cards/app_card.dart';
import 'package:otloha_sah_flutter/core/design_system/tokens/app_colors.dart';
import 'package:otloha_sah_flutter/core/design_system/tokens/app_radius.dart';
import 'package:otloha_sah_flutter/core/design_system/tokens/app_spacing.dart';
import 'package:otloha_sah_flutter/core/design_system/tokens/app_typography.dart';
import 'package:otloha_sah_flutter/core/utils/constant/constants.dart';
import 'package:otloha_sah_flutter/core/utils/constant/utils.dart';
import 'package:otloha_sah_flutter/core/utils/res/icons_app.dart';
import 'package:otloha_sah_flutter/core/utils/themes/color.dart';
import 'package:otloha_sah_flutter/core/widgets/password_form_field.dart';
import 'package:otloha_sah_flutter/core/widgets/text_from_fielid.dart';
import 'package:otloha_sah_flutter/core/widgets/tool_bar_app.dart';
import 'package:otloha_sah_flutter/core/widgets/vali_errorr_text.dart';
import 'package:otloha_sah_flutter/data_source/enums/roles.dart';
import 'package:otloha_sah_flutter/modules/auth_module/business_logic/auth_cubit.dart';
import 'package:otloha_sah_flutter/modules/auth_module/presentation/pages/check_otp_page.dart';
import 'package:otloha_sah_flutter/modules/auth_module/presentation/pages/terms_conditions_page.dart';
import 'package:otloha_sah_flutter/modules/auth_module/presentation/widget/page_head_text.dart';
import 'package:otloha_sah_flutter/modules/auth_module/presentation/widget/page_layout.dart';
import 'package:otloha_sah_flutter/modules/home/presentation/pages/home/home_page.dart';
import 'package:otloha_sah_flutter/modules/profile/presentation/page/settings/register_as_techer.dart';
import 'package:password_strength_checker/password_strength_checker.dart';

class SignUpPage extends StatelessWidget {
  static const routeName = '/signUpPage';

  const SignUpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PageAuthLayout(
      pageComponents: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is RegisterSuccessState) {
            if (AuthCubit.get(context).isTeacher) {
              Get.offAll(const RegisterAsTeacher());
            } else {
              if (Constants.hasOTP) {
                Get.offAll(() => CheckOTPPage());
              } else {
                Get.offAll(() => const HomePage());
              }
            }
          }
        },
        builder: (context, state) {
          var cubit = AuthCubit.get(context);
          return Column(
            children: [
              ToolBarApp(
                backIcon: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                title: tr('Register New Account'),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    children: [
                      const SizedBox(height: AppSpacing.xs),
                      Image.asset(
                        AppIcons.flatLogoIcon,
                        width: 80,
                        height: 80,
                        errorBuilder: (_, __, ___) => const Icon(
                          Icons.menu_book_rounded,
                          size: 60,
                          color: AppColors.primary,
                        ),
                      ),
                      pageLayOutTextHead(tr('Register New Account'), context),
                      AppCard(
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        child: SignForm(cubit: cubit),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class SignForm extends StatefulWidget {
  const SignForm({Key? key, required this.cubit}) : super(key: key);
  final AuthCubit cubit;

  @override
  State<SignForm> createState() => _SignFormState();
}

class _SignFormState extends State<SignForm> {
  final passNotifier = ValueNotifier<PasswordStrength?>(null);
  var genders = ['Male', 'Female'];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    var gendersView = [translate('Male'), translate('Female')];

    return FormBuilder(
      key: widget.cubit.signupformKey,
      child: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Email
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormFieldApp(
                    title: tr('Email'),
                    controller: widget.cubit.emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: [
                      FormBuilderValidators.required(),
                      FormBuilderValidators.email(),
                    ],
                  ),
                  if (state is RegisterErrorState)
                    ValidationErrorText(
                      error: (state.error['email'] != null)
                          ? state.error['email'][0]
                          : '',
                    ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),

              // Username
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormFieldApp(
                    controller: widget.cubit.userNameController,
                    title: tr('User Name'),
                    hintText: tr('e.g. Mohamed_2311'),
                    validator: [
                      FormBuilderValidators.required(),
                    ],
                    suffixIcon: TextButton(
                      onPressed: () {
                        String email = widget.cubit.emailController.text;
                        if (email.contains('@')) {
                          String username = email.split('@')[0];
                          widget.cubit.userNameController.text = username;
                        }
                      },
                      child: Text(
                        tr('Use Email'),
                        style: AppTypography.bodySmall(color: AppColors.primary)
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  if (state is RegisterErrorState)
                    ValidationErrorText(
                      error: (state.error['username'] != null)
                          ? state.error['username'][0]
                          : '',
                    ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),

              // Phone Number
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InternationalPhoneNumberInput(
                    textFieldController: widget.cubit.phoneController,
                    initialValue: widget.cubit.phoneNumber,
                    locale: Get.locale!.languageCode,
                    searchBoxDecoration: InputDecoration(
                      label: Text(
                        translate('search by county name or dial code'),
                      ),
                    ),
                    inputDecoration: InputDecoration(
                      isDense: true,
                      alignLabelWithHint: true,
                      fillColor: Colors.transparent,
                      filled: true,
                      enabledBorder: border,
                      focusedBorder: borderFocuse,
                      errorBorder: border,
                      focusedErrorBorder: borderFocuse,
                      disabledBorder: border,
                      labelStyle: TextStyle(
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                      ),
                      labelText: tr('EnterYourphone'),
                      contentPadding: const EdgeInsets.all(12),
                    ),
                    selectorConfig: const SelectorConfig(
                      selectorType: PhoneInputSelectorType.DIALOG,
                    ),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                    ]),
                    onInputChanged: ((value) {
                      widget.cubit.phoneNumber = value;
                    }),
                  ),
                  if (state is RegisterErrorState)
                    ValidationErrorText(
                      error: (state.error['phone'] != null)
                          ? state.error['phone'][0]
                          : '',
                    ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),

              // Gender Selector
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FormBuilderDropdown<String>(
                    validator: FormBuilderValidators.compose([FormBuilderValidators.required()]),
                    decoration: InputDecoration(
                      labelText: tr('Gender'),
                      labelStyle: TextStyle(
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                      ),
                      isDense: true,
                      enabledBorder: border,
                      focusedBorder: borderFocuse,
                      errorBorder: border,
                      focusedErrorBorder: borderFocuse,
                      disabledBorder: border,
                    ),
                    disabledHint: Text(
                      tr('Select Gender'),
                      style: AppTypography.bodyMedium(
                        color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                      ),
                    ),
                    items: gendersView
                        .map((g) => DropdownMenuItem(
                              value: g,
                              child: Text(g, style: AppTypography.bodyMedium()),
                            ))
                        .toList(),
                    name: 'gender',
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          widget.cubit.select = genders[gendersView.indexOf(value)];
                        });
                      }
                    },
                  ),
                  if (state is RegisterErrorState)
                    ValidationErrorText(
                      error: (state.error['gender'] != null)
                          ? state.error['gender'][0]
                          : '',
                    ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),

              // Account Type (CustomDropdown)
              CustomDropdown<String>(
                label: tr('Account Type'),
                options: const ['Student', 'Teacher'],
                onChanged: (value) {
                  if (value == 'Student') {
                    AuthCubit.get(context).studentPressed();
                  } else {
                    AuthCubit.get(context).teacherPressed();
                  }
                },
              ),
              const SizedBox(height: AppSpacing.md),

              // Date of Birth
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FormBuilderDateTimePicker(
                    inputType: InputType.date,
                    format: DateFormat('dd-MM-yyyy'),
                    validator: FormBuilderValidators.compose([FormBuilderValidators.required()]),
                    decoration: InputDecoration(
                      labelText: tr('Date of Birth'),
                      labelStyle: TextStyle(
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                      ),
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                      enabledBorder: border,
                      focusedBorder: borderFocuse,
                      errorBorder: border,
                      focusedErrorBorder: borderFocuse,
                      disabledBorder: border,
                    ),
                    name: 'date',
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          widget.cubit.currentDate = value;
                        });
                      }
                    },
                  ),
                  if (state is RegisterErrorState)
                    ValidationErrorText(
                      error: (state.error['birthdate'] != null)
                          ? state.error['birthdate'][0]
                          : '',
                    ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),

              // Password
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PasswordFormField(
                    title: tr('password'),
                    controller: widget.cubit.passwordController,
                    onChange: (value) {
                      passNotifier.value = PasswordStrength.calculate(text: value ?? '');
                    },
                    validator: [
                      FormBuilderValidators.required(),
                    ],
                  ),
                  if (state is RegisterErrorState)
                    ValidationErrorText(
                      error: (state.error['password1'] != null)
                          ? state.error['password1'][0]
                          : '',
                    ),
                  const SizedBox(height: 8),
                  PasswordStrengthChecker(
                    strength: passNotifier,
                    configuration: PasswordStrengthCheckerConfiguration(
                      showStatusWidget: false,
                      borderWidth: 1,
                      borderColor: isDark ? AppColors.borderDark : AppColors.borderLight,
                      height: 8,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),

              // Confirm Password
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PasswordFormField(
                    title: tr('EnterConfirmPassword'),
                    controller: widget.cubit.confirmPasswordController,
                    validator: [
                      FormBuilderValidators.required(),
                    ],
                  ),
                  if (state is RegisterErrorState)
                    ValidationErrorText(
                      error: (state.error['password2'] != null)
                          ? state.error['password2'][0]
                          : '',
                    ),
                  FormBuilderCheckbox(
                    name: 'agree',
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 8),
                    ),
                    validator: FormBuilderValidators.equal(
                      true,
                      errorText: 'You should accept the terms and condition to continue',
                    ),
                    title: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          translate('I accept the '),
                          style: AppTypography.bodyMedium(
                            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, TermsAndConditions.routeName);
                          },
                          child: Text(
                            translate('terms and conditions'),
                            style: AppTypography.bodyMedium(
                              color: AppColors.primary,
                            ).copyWith(
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    initialValue: false,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),

              // Submit Button
              BlocBuilder<AuthCubit, AuthState>(
                builder: (context, state) {
                  return (state is RegisterLoadingState || state is RegisterSuccessState)
                      ? const Center(
                          child: CircularProgressIndicator(color: AppColors.primary),
                        )
                      : SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: AppRadius.radiusMd,
                              ),
                              elevation: 0,
                            ),
                            onPressed: () {
                              FocusScope.of(context).unfocus();
                              widget.cubit.startSignUp();
                            },
                            child: Text(
                              tr('RegisterNow'),
                              style: AppTypography.buttonStyle(color: Colors.white).copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        );
                },
              ),
              const SizedBox(height: AppSpacing.sm),
            ],
          );
        },
      ),
    );
  }
}

class CustomDropdown<T> extends StatelessWidget {
  final String label;
  final List<T> options;
  final T? selectedValue;
  final ValueChanged<T?>? onChanged;

  const CustomDropdown({
    super.key,
    required this.label,
    required this.options,
    this.selectedValue,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return FormBuilderDropdown<T>(
      name: label.toLowerCase().replaceAll(' ', '_'),
      validator: FormBuilderValidators.compose([FormBuilderValidators.required()]),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
        ),
        isDense: true,
        enabledBorder: border,
        focusedBorder: borderFocuse,
        errorBorder: border,
        focusedErrorBorder: borderFocuse,
        disabledBorder: border,
      ),
      items: options
          .map((option) => DropdownMenuItem(
                value: option,
                child: Text(
                  tr(option.toString()),
                  style: AppTypography.bodyMedium(),
                ),
              ))
          .toList(),
      onChanged: (value) {
        if (onChanged != null) {
          onChanged!(value);
        }
      },
    );
  }
}
