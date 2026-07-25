import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:otloha_sah_flutter/core/utils/constant/constants.dart';
import 'package:otloha_sah_flutter/modules/auth_module/presentation/pages/check_otp_page.dart';
import '../../../../core/utils/constant/utils.dart';
import '../../../../data_source/enums/roles.dart';
import 'terms_conditions_page.dart';
import '../widget/auth_button.dart';
import '../../../../core/utils/themes/color.dart';
import '../../../../core/widgets/text_from_fielid.dart';
import '../../business_logic/auth_cubit.dart';
import '../widget/page_layout.dart';
import '../widget/picked_role.dart';
import '../widget/unpicked_role.dart';
import '../../../profile/presentation/page/settings/register_as_techer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';

import '../../../../core/widgets/vali_errorr_text.dart';
import '../../../home/presentation/pages/home/home_page.dart';

class SocialLoginCompeleteFormPage extends StatelessWidget {
  static const routeName = '/socialLoginCompeleteFormPage';

  const SocialLoginCompeleteFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is RegisterSuccessState) {
              if (AuthCubit.get(context).isTeacher) {
                Get.offAll(const RegisterAsTeacher());
              } else {
                if (AuthCubit.get(context).userProfile.phoneVerifiedAt ==
                        null &&
                    Constants.hasOTP) {
                  Get.offAll(() => CheckOTPPage());
                } else {
                  Get.offAll(() => const HomePage());
                }
              }
            }
          },
          builder: (context, state) {
            var cubit = AuthCubit.get(context);
            return PageAuthLayout(
              pageComponents: signupComponents(context, cubit),
            );
          },
        ),
      ),
    );
  }

  Widget signupComponents(BuildContext context, AuthCubit cubit) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        roles(),
        SignForm(cubit: cubit),
      ],
    );
  }

  roles() => BlocBuilder<AuthCubit, AuthState>(
        builder: (context, child) {
          return Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    AuthCubit.get(context).studentPressed();
                  },
                  child: AuthCubit.get(context).isStudent
                      ? PickedRole(RoleTypes.student, AppColor.headTextColor)
                      : const UnpickedRole(RoleTypes.student,
                          AppColor.lightBlue, AppColor.white),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () => AuthCubit.get(context).teacherPressed(),
                  child: AuthCubit.get(context).isTeacher
                      ? PickedRole(RoleTypes.teacher, AppColor.headTextColor)
                      : const UnpickedRole(RoleTypes.teacher,
                          AppColor.lightBlue, AppColor.white),
                ),
              ),
            ],
          );
        },
      );
}

class SignForm extends StatefulWidget {
  const SignForm({Key? key, required this.cubit}) : super(key: key);
  final AuthCubit cubit;

  @override
  State<SignForm> createState() => _SignFormState();
}

class _SignFormState extends State<SignForm> {
  List gender = [
    'Male',
    'Female',
  ];

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: FormBuilder(
            key: widget.cubit.signupformKey,
            child: BlocBuilder<AuthCubit, AuthState>(
              builder: (context, state) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        const SizedBox(height: 5),
                        if (AuthCubit.get(context).userProfile.username ==
                                null ||
                            AuthCubit.get(context).userProfile.username == '')
                          TextFormFieldApp(
                              controller: widget.cubit.userNameController,
                              keyboardType: TextInputType.name,
                              title: tr('User Name'),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                  RegExp(
                                      '[a-zA-Z!#()*&^%\$@_+|~=`{}\\[\\]:;"<>?,./]'),
                                )
                              ],
                              validator: [
                                FormBuilderValidators.required(),
                              ]),
                        (state is RegisterErrorState)
                            ? ValidationErrorText(
                                error: (state.error['username'] != null)
                                    ? state.error['username'][0]
                                    : '')
                            : const SizedBox(),
                      ],
                    ),
                    if (AuthCubit.get(context).userProfile.username == null ||
                        AuthCubit.get(context).userProfile.username == '')
                      const SizedBox(height: 20),
                    if (AuthCubit.get(context).userProfile.email == null ||
                        AuthCubit.get(context).userProfile.email == '')
                      Column(
                        children: [
                          TextFormFieldApp(
                              title: tr('Email'),
                              controller: widget.cubit.emailController,
                              keyboardType: TextInputType.emailAddress,
                              validator: [
                                FormBuilderValidators.required(),
                                FormBuilderValidators.email(),
                              ]),
                          (state is RegisterErrorState)
                              ? ValidationErrorText(
                                  error: (state.error['email'] != null)
                                      ? state.error['email'][0]
                                      : '')
                              : const SizedBox(),
                        ],
                      ),
                    if (AuthCubit.get(context).userProfile.email == null ||
                        AuthCubit.get(context).userProfile.email == '')
                      const SizedBox(height: 20),
                    if (AuthCubit.get(context).userProfile.phone == null ||
                        AuthCubit.get(context).userProfile.phone == '')
                      Column(
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
                              fillColor: Colors.blue.withOpacity(.0),
                              filled: true,
                              enabledBorder: border,
                              focusedBorder: borderFocuse,
                              errorBorder: border,
                              focusedErrorBorder: borderFocuse,
                              disabledBorder: border,
                              labelStyle:
                                  const TextStyle(color: AppColor.txtGrey),
                              labelText: tr('EnterYourphone'),
                              contentPadding: const EdgeInsets.all(11),
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
                            onFieldSubmitted: ((value) => print(value)),
                          ),
                          (state is RegisterErrorState)
                              ? ValidationErrorText(
                                  error: (state.error['phone'] != null)
                                      ? state.error['phone'][0]
                                      : '')
                              : const SizedBox(),
                        ],
                      ),
                    if (AuthCubit.get(context).userProfile.phone == null ||
                        AuthCubit.get(context).userProfile.phone == '')
                      const SizedBox(height: 20),
                    if (AuthCubit.get(context).userProfile.gender == null ||
                        AuthCubit.get(context).userProfile.gender == '')
                      Column(
                        children: [
                          selectGender(),
                          (state is RegisterErrorState)
                              ? ValidationErrorText(
                                  error: (state.error['gender'] != null)
                                      ? state.error['gender'][0]
                                      : '')
                              : const SizedBox(),
                        ],
                      ),
                    if (AuthCubit.get(context).userProfile.gender == null ||
                        AuthCubit.get(context).userProfile.gender == '')
                      const SizedBox(height: 20),
                    if (AuthCubit.get(context).userProfile.birthdate == null ||
                        AuthCubit.get(context).userProfile.birthdate == '')
                      Column(
                        children: [
                          dateTimeSelector(),
                          (state is RegisterErrorState)
                              ? ValidationErrorText(
                                  error: (state.error['birthdate'] != null)
                                      ? state.error['birthdate'][0]
                                      : '')
                              : const SizedBox(),
                        ],
                      ),
                    if (AuthCubit.get(context).userProfile.birthdate == null ||
                        AuthCubit.get(context).userProfile.birthdate == '')
                      const SizedBox(height: 20),
                    Column(
                      children: [
                        FormBuilderCheckbox(
                          name: 'agree',
                          decoration: const InputDecoration(
                              border: InputBorder.none,
                              contentPadding:
                                  EdgeInsets.symmetric(vertical: 10)),
                          validator: FormBuilderValidators.equal(true,
                              errorText:
                                  'You should accept the terms and condition to continue'),
                          title: Row(
                            children: [
                              Text(
                                translate('I accept the '),
                                style: Theme.of(context).textTheme.labelSmall,
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, TermsAndConditions.routeName);
                                },
                                child: Text(
                                  translate('terms and conditions'),
                                  style: const TextStyle(
                                      decoration: TextDecoration.underline,
                                      fontSize: 16,
                                      color: AppColor.primaryColor),
                                ),
                              )
                            ],
                          ),
                          initialValue: false,
                          // tristate: true,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    BlocBuilder<AuthCubit, AuthState>(
                      builder: (context, state) {
                        return (state is RegisterLoadingState ||
                                state is RegisterSuccessState)
                            ? const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              )
                            : ButtonApp(
                                buttonText: tr('RegisterNow'),
                                onPressed: () {
                                  FocusScope.of(context).unfocus();

                                  widget.cubit.updateProfile();

                                  if (state is RegisterErrorState) {
                                    return state.error;
                                  }
                                },
                                width: double.infinity,
                                colors: const [
                                  AppColor.btn2Color,
                                  AppColor.btn2lColor,
                                ],
                              );
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  passwordValidatePoints(String text) => ListTile(
      leading: const Icon(
        Icons.circle,
        color: Color(0xff08226c),
        size: 10,
      ),
      title: Text(translate(text)));

  FormBuilderDateTimePicker dateTimeSelector() {
    return FormBuilderDateTimePicker(
      inputType: InputType.date,
      format: DateFormat('dd-MM-yyyy'),
      validator:
          FormBuilderValidators.compose([FormBuilderValidators.required()]),
      decoration: InputDecoration(
        labelText: tr('Date of Birth'),
        labelStyle: const TextStyle(color: AppColor.lightBlue),
        isDense: true,
        enabledBorder: border,
        focusedBorder: borderFocuse,
        errorBorder: border,
        focusedErrorBorder: borderFocuse,
        disabledBorder: border,
        border: OutlineInputBorder(
          borderSide: const BorderSide(
            color: AppColor.lightBlue,
            width: 10,
          ),
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      name: 'date',
      onChanged: (value) {
        setState(() {
          widget.cubit.currentDate = value!;
        });
      },
    );
  }

  FormBuilderDropdown<String> selectGender() {
    return FormBuilderDropdown(
      validator:
          FormBuilderValidators.compose([FormBuilderValidators.required()]),
      decoration: InputDecoration(
        labelText: tr('Gender'),
        labelStyle: const TextStyle(color: AppColor.lightBlue),
        isDense: true,
        enabledBorder: border,
        focusedBorder: borderFocuse,
        errorBorder: border,
        focusedErrorBorder: borderFocuse,
        disabledBorder: border,
        border: OutlineInputBorder(
          borderSide: const BorderSide(
            color: AppColor.lightBlue,
            width: 10,
          ),
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      disabledHint: Text(
        tr('Select Gender'),
        style: const TextStyle(color: AppColor.lightBlue),
      ),
      items: gendersView
          .map((gender) => DropdownMenuItem(value: gender, child: Text(gender)))
          .toList(),
      name: 'gender',
      onChanged: (value) {
        setState(() {
          widget.cubit.select = genders[gendersView.indexOf(value!)];
        });
      },
    );
  }

  var genders = ['Male', 'Female'];
  var gendersView = [translate('Male'), translate('Female')];
}
