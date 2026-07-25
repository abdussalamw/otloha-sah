import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import '../../../../../core/utils/constant/utils.dart';
import 'package:otloha_sah_flutter/core/utils/themes/color.dart';
import '../../../../../core/widgets/text_from_fielid.dart';
import '../../../../../core/widgets/vali_errorr_text.dart';
import '../../../../../core/widgets/warnings_and_alerts/warning.dart';
import '../../../../auth_module/presentation/pages/login_page.dart';
import '../../../../auth_module/presentation/widget/auth_button.dart';
import 'package:otloha_sah_flutter/modules/home/presentation/pages/home/home_page.dart';
import '../../../business_logic/register_as_teacher/register_as_teacher_cubit.dart';
import '../../../business_logic/register_as_teacher/register_as_teacher_state.dart';
import '../../widget/add_teach_narration_dialog.dart';
import '../../widget/file_upload.dart';
import 'package:otloha_sah_flutter/modules/profile/presentation/widget/selected_narration_element.dart';
import '../../../../settings/business_logic/settings/settings_cubit.dart';
import 'package:quran_widget_flutter/data_source/local/local_data_source/narration_local_data_source.dart';
import 'package:quran_widget_flutter/model/narration.dart';

class RegisterAsTeacher extends StatelessWidget {
  const RegisterAsTeacher({Key? key}) : super(key: key);

  Future<List<Narration>?> getNarrations() async {
    return await NarrationLocalDataSource().fetchNarrationsList();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SettingsCubit, SettingsState>(
      listener: (ctx, state) {
        if (state is RegisterAsTeacherSuccessState) {
          print('cksjndskcn');
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          }
          // showDialog(
          //     context: context,
          //     builder: (context) => AlertPopup(
          //           alertType: AlertType.seccess,
          //           buttonText: translate('ok'),
          //           message: translate(
          //               'Your request to be a teacher is created successfully'),
          //         ));
          Fluttertoast.showToast(
            msg: translate(
                'Your request to be a teacher is created successfully'),
            backgroundColor: AppColor.lightBlue,
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
            backgroundColor: AppColor.lightBlue,
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
        // cubit.emit(SettingsInitial());

        return Scaffold(
          body: SafeArea(
            child: ListView(
              children: [
                SizedBox(
                  height: 250,
                  width: double.infinity,
                  child: Stack(
                    children: [
                      SvgPicture.asset(
                        'assets/svg/BG.svg',
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                      Column(
                        children: [
                          Text(
                            tr('Register As Teacher'),
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall!
                                .copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 50,
                              vertical: 20,
                            ),
                            child: Text(
                              translate(
                                  'We are so glad you decided to sign up with us as a teacher. here are few steps to get you to sign up and register fast.'),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 100,
                  color: Colors.transparent.withOpacity(0),
                  child: Container(
                    color: Colors.transparent.withOpacity(0),
                    width: 100,
                    padding: EdgeInsets.only(
                      // top: MediaQuery.of(context).size.height * 0.35,
                      left: MediaQuery.of(context).size.width * 0.1,
                      right: MediaQuery.of(context).size.width * 0.1,
                    ),
                    child: BlocProvider(
                      create: (context) =>
                          TeacherRegistrationCubit()..initData(),
                      child: BlocBuilder<TeacherRegistrationCubit,
                          TeacherRegistrationState>(
                        builder: (context, state) {
                          if (state is TeacherRegistrationChangeState) {
                            return Form(
                              key: TeacherRegistrationCubit.cubit(context)
                                  .formKey,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    (settingsState is InvalidDataErrorState)
                                        ? ValidationErrorText(
                                            error: (settingsState.error.errors!
                                                    .containsKey('full_name'))
                                                ? settingsState.error
                                                    .errors!['full_name'][0]
                                                : '')
                                        : const SizedBox(),
                                    const SizedBox(height: 20),
                                    TextFormFieldApp(
                                      color: AppColor.lightBlue,
                                      controller:
                                          TeacherRegistrationCubit.cubit(
                                                  context)
                                              .educationController,
                                      keyboardType: TextInputType.name,
                                      title: tr('Your Education'),
                                      validator: [
                                        FormBuilderValidators.required(),
                                        //  FormBuilderValidators.email(context),
                                      ],
                                    ),

                                    (settingsState is InvalidDataErrorState)
                                        ? ValidationErrorText(
                                            error: (settingsState.error.errors!
                                                    .containsKey(
                                                        'education_degree'))
                                                ? settingsState.error.errors![
                                                    'education_degree'][0]
                                                : '')
                                        : const SizedBox(),
                                    const SizedBox(height: 20),
                                    UploadFile(
                                      onCancel: (string) {
                                        TeacherRegistrationCubit.cubit(context)
                                            .removeCVFile();
                                      },
                                      onUpload: (file) {
                                        TeacherRegistrationCubit.cubit(context)
                                            .uploadCVFile(file?[0]);
                                      },
                                      title: translate('C.V.'),
                                      titleStyle: TextStyle(
                                        color: AppColor.headTextColor,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),

                                    (settingsState is InvalidDataErrorState)
                                        ? ValidationErrorText(
                                            error: (settingsState.error.errors!
                                                    .containsKey('cv'))
                                                ? settingsState
                                                    .error.errors!['cv'][0]
                                                : '')
                                        : const SizedBox(),
                                    const Divider(),
                                    const SizedBox(height: 15),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          tr('Narrations'),
                                          style: TextStyle(
                                            color: AppColor.headTextColor,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    if (TeacherRegistrationCubit.cubit(context)
                                        .selectedNarrations
                                        .isEmpty)
                                      WarningMessage(
                                        text: translate(
                                            'You Should add at least one narration'),
                                      ),

                                    for (var m
                                        in TeacherRegistrationCubit.cubit(
                                                context)
                                            .selectedNarrations
                                            .keys) ...[
                                      SelectedNarrationElement(
                                        narration: m,
                                        name: m.name.translate() ?? '',
                                        file: TeacherRegistrationCubit.cubit(
                                                context)
                                            .selectedNarrations[m]
                                            ?.split('/')
                                            .last,
                                      ),
                                    ],

                                    // ...teacherNarrations,
                                    Align(
                                      alignment: AlignmentDirectional.topStart,
                                      child: TextButton.icon(
                                        icon: const Icon(Icons.add),
                                        label: Text(
                                          translate('Add new certification'),
                                        ),
                                        onPressed: TeacherRegistrationCubit
                                                        .cubit(context)
                                                    .selectedNarrations
                                                    .length >=
                                                TeacherRegistrationCubit.cubit(
                                                        context)
                                                    .narrations!
                                                    .length
                                            ? null
                                            : () {
                                                showDialog(
                                                  context: context,
                                                  builder: (dialogContext) =>
                                                      Dialog(
                                                    shape:
                                                        const RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                        Radius.circular(16.0),
                                                      ),
                                                    ),
                                                    child:
                                                        AddTeacherNarrationDialog(
                                                            narrations: TeacherRegistrationCubit
                                                                    .cubit(
                                                                        context)
                                                                .getRestNarrations(),
                                                            onSubmit: (result) {
                                                              TeacherRegistrationCubit
                                                                      .cubit(
                                                                          context)
                                                                  .addNarration(
                                                                      result);

                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                           ),
                                                  ),
                                                );
                                              },
                                      ),
                                    ),
                                    if (settingsState
                                        is RegisterAsTeacherLoadingState)
                                      const Center(
                                        child: CircularProgressIndicator(),
                                      )
                                    else
                                      Column(
                                        children: [
                                          ButtonApp(
                                            buttonText: tr('Submit'),
                                            onPressed: () {
                                              TeacherRegistrationCubit.cubit(
                                                      context)
                                                  .update(cubit, settingsState,
                                                      context);
                                            },
                                            width: double.infinity,
                                            colors: const [
                                              AppColor.darkBlue,
                                              AppColor.lightBlue,
                                            ],
                                          ),
                                        ],
                                      ),
                                  ],
                                ),
                              ),
                            );
                          }
                          return const SizedBox();
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// class TeacherRegistration extends StatelessWidget {
//   const TeacherRegistration({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<TeacherRegistrationCubit,
//                               TeacherRegistrationState>(
//                             builder: (context, state) {
//                               return Form(
//                                 key: TeacherRegistrationCubit.cubit(context)
//                                     .formKey,
//                                 child: Padding(
//                                   padding: const EdgeInsets.all(8.0),
//                                   child: Column(
//                                     children: [
//                                       TextFormFieldApp(
//                                         color: AppColor.lightBlue,
//                                         controller:
//                                             TeacherRegistrationCubit.cubit(
//                                                     context)
//                                                 .nameController,
//                                         keyboardType: TextInputType.name,
//                                         title: tr('Your Name'),
//                                         validator: [
//                                           FormBuilderValidators.required(
//                                             context,
//                                           ),
//                                           //   FormBuilderValidators.email(context),
//                                         ],
//                                       ),
//                                       (settingsState is InvalidDataErrorState)
//                                           ? ValidationErrorText(
//                                               error: (settingsState
//                                                       .error.errors!
//                                                       .containsKey('full_name'))
//                                                   ? settingsState.error
//                                                       .errors!['full_name'][0]
//                                                   : '')
//                                           : const SizedBox(),
//                                       const SizedBox(height: 8),
//                                       TextFormFieldApp(
//                                         color: AppColor.lightBlue,
//                                         controller:
//                                             TeacherRegistrationCubit.cubit(
//                                                     context)
//                                                 .educationController,
//                                         keyboardType: TextInputType.name,
//                                         title: tr('Your Education'),
//                                         validator: [
//                                           FormBuilderValidators.required(
//                                               context),
//                                           //  FormBuilderValidators.email(context),
//                                         ],
//                                       ),
//                                       (settingsState is InvalidDataErrorState)
//                                           ? ValidationErrorText(
//                                               error: (settingsState
//                                                       .error.errors!
//                                                       .containsKey(
//                                                           'education_degree'))
//                                                   ? settingsState.error.errors![
//                                                       'education_degree'][0]
//                                                   : '')
//                                           : const SizedBox(),
//                                       const SizedBox(height: 8),
//                                       UploadFile(
//                                         onCancel: (string) {
//                                           TeacherRegistrationCubit.cubit(
//                                                   context)
//                                               .removeCVFile();
//                                         },
//                                         onUpload: (file) {
//                                           TeacherRegistrationCubit.cubit(
//                                                   context)
//                                               .uploadCVFile(file?[0]);
//                                         },
//                                         title: 'C.V.',
//                                         titleStyle: TextStyle(
//                                           color: AppColor.headTextColor,
//                                           fontSize: 20,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                       ),

//                                       (settingsState is InvalidDataErrorState)
//                                           ? ValidationErrorText(
//                                               error: (settingsState
//                                                       .error.errors!
//                                                       .containsKey('cv'))
//                                                   ? settingsState
//                                                       .error.errors!['cv'][0]
//                                                   : '')
//                                           : const SizedBox(),
//                                       const Divider(),
//                                       // const SizedBox(height: 8),
//                                       Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.spaceBetween,
//                                         children: [
//                                           Text(
//                                             tr('Narrations'),
//                                             style: TextStyle(
//                                               color: AppColor.headTextColor,
//                                               fontSize: 20,
//                                               fontWeight: FontWeight.bold,
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                       if (TeacherRegistrationCubit.cubit(
//                                               context)
//                                           .selectedNarrations
//                                           .isEmpty)
//                                         const WarningMessage(
//                                           text:
//                                               'You Should add at least one narration',
//                                         ),

//                                       ...TeacherRegistrationCubit.cubit(context)
//                                           .selectedNarrations
//                                           .keys
//                                           .map((k) => Text(k.name))
//                                           .toList(),
//                                       // ...teacherNarrations,
//                                       Align(
//                                         alignment:
//                                             AlignmentDirectional.topStart,
//                                         child: TextButton.icon(
//                                           icon: const Icon(Icons.add),
//                                           label: const Text(
//                                               'Add new certification'),
//                                           onPressed: TeacherRegistrationCubit
//                                                           .cubit(context)
//                                                       .selectedNarrations
//                                                       .length >=
//                                                   narrations.length
//                                               ? null
//                                               : () {
//                                                   showDialog(
//                                                     context: context,
//                                                     builder: (context) =>
//                                                         Dialog(
//                                                       shape:
//                                                           const RoundedRectangleBorder(
//                                                         borderRadius:
//                                                             BorderRadius.all(
//                                                           Radius.circular(16.0),
//                                                         ),
//                                                       ),
//                                                       child:
//                                                           AddTeacherNarrationDialog(
//                                                         narrations: narrations,
//                                                         onSubmit: (result) {
//                                                           TeacherRegistrationCubit
//                                                                   .cubit(
//                                                                       context)
//                                                               .addNarration(
//                                                                   result);

//                                                           Navigator.pop(
//                                                               context);
//                                                         },
//                                                       ),
//                                                     ),
//                                                   );
//                                                 },
//                                         ),
//                                       ),
//                                       if (state
//                                           is RegisterAsTeacherLoadingState)
//                                         const Center(
//                                           child: CircularProgressIndicator(),
//                                         )
//                                       else
//                                         Column(
//                                           children: [
//                                             // const SizedBox(height: 40),
//                                             ButtonApp(
//                                               buttonText: tr('Submit'),
//                                               onPressed: () {
//                                                 TeacherRegistrationCubit.cubit(
//                                                         context)
//                                                     .update(cubit,
//                                                         settingsState, context);
//                                               },
//                                               width: double.infinity,
//                                               colors: const [
//                                                 AppColor.darkBlue,
//                                                 AppColor.lightBlue,
//                                               ],
//                                             ),
//                                           ],
//                                         ),
//                                     ],
//                                   ),
//                                 ),
//                               );
//                             },
//                           );
//   }
// }
