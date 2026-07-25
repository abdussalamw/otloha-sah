import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../core/widgets/cached_image.dart';
import '../../../../../core/widgets/date_picker_field.dart';
import '../../../../../core/widgets/gender_field.dart';
import '../../../../../core/widgets/loader.dart';
import '../../../../../core/widgets/vali_errorr_text.dart';
import '../../../business_logic/profile_pic_cubit/update_profile_cubit.dart';
import '../../../business_logic/profile_pic_cubit/update_profile_state.dart';

import '../../../../../../core/utils/constant/utils.dart';
import '../../../../../../core/utils/themes/color.dart';
import '../../../../../../core/widgets/text_from_fielid.dart';
import '../../../../auth_module/presentation/widget/auth_button.dart';

class UpdateProfile extends StatefulWidget {
  const UpdateProfile({Key? key}) : super(key: key);

  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  // ignore: prefer_typing_uninitialized_variables
  late final UpdateProfileCubit cubit;
  @override
  void initState() {
    UpdateProfileCubit.get(context).init();
    cubit = UpdateProfileCubit.get(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(translate('Update Profile')),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: BlocConsumer<UpdateProfileCubit, UpdateProfileState>(
                    listener: (context, state) {
                      if (state is UpdateProfileLoading) {
                        showLoader(context);
                      } else {
                        if (Loader.isShown) {
                          hideLoader();
                        }
                      }
                    },
                    builder: (context, state) {
                      return Form(
                        key: cubit.formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              height: 200,
                              width: 200,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppColor.lightBlue,
                                  width: 2,
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: cubit.pickedImage != null
                                    ? Image.file(
                                        File(cubit.pickedImage!.path),
                                        fit: BoxFit.cover,
                                      )
                                    : CachedImage(
                                        url: cubit.remoteImageUrl,
                                        raduis: 100,
                                      ),
                              ),
                            ),
                            changeImage(),
                            TextFormFieldApp(
                              color: AppColor.lightBlue,
                              controller: cubit.firseNameController,
                              keyboardType: TextInputType.emailAddress,
                              title: translate('first_name'),
                              validator: [
                                FormBuilderValidators.required(),
                              ],
                            ),
                            if (state is InvalidDataErrorState)
                              ValidationErrorText(
                                  error: state.errors.containsKey('first_name')
                                      ? state.errors['first_name']![0]
                                      : ''),
                            const SizedBox(height: 10),
                            TextFormFieldApp(
                              color: AppColor.lightBlue,
                              controller: cubit.lastNameController,
                              keyboardType: TextInputType.emailAddress,
                              title: translate('last_name'),
                              validator: [
                                FormBuilderValidators.required(),
                              ],
                            ),
                            if (state is InvalidDataErrorState)
                              ValidationErrorText(
                                  error: state.errors.containsKey('last_name')
                                      ? state.errors['last_name']![0]
                                      : ''),
                            const SizedBox(height: 10),
                            TextFormFieldApp(
                              color: AppColor.lightBlue,
                              controller: cubit.usernameController,
                              keyboardType: TextInputType.emailAddress,
                              title: translate('username'),
                              validator: [
                                FormBuilderValidators.required(),
                              ],
                            ),
                            if (state is InvalidDataErrorState)
                              ValidationErrorText(
                                  error: state.errors.containsKey('username')
                                      ? state.errors['username']![0]
                                      : ''),
                            const SizedBox(height: 10),
                            TextFormFieldApp(
                              color: AppColor.lightBlue,
                              controller: cubit.bioController,
                              keyboardType: TextInputType.emailAddress,
                              title: translate('bio'),
                              minLines: 2,
                              validator: [
                                FormBuilderValidators.required(),
                              ],
                            ),
                            if (state is InvalidDataErrorState)
                              ValidationErrorText(
                                  error: state.errors.containsKey('bio')
                                      ? state.errors['bio']![0]
                                      : ''),
                            const SizedBox(height: 10),
                            GenderField(
                              initValue: cubit.genderController.text,
                              onChanged: (gender) {
                                cubit.genderController.text = gender ?? '';
                              },
                            ),
                            if (state is InvalidDataErrorState)
                              ValidationErrorText(
                                  error: state.errors.containsKey('gender')
                                      ? state.errors['gender']![0]
                                      : ''),
                            const SizedBox(height: 10),
                            DatePickerField(
                              controller: cubit.birthdateController,
                              initValue: cubit.birthDate,
                              onChanged: (date) {
                                cubit.birthDate = date.toString();
                              },
                            ),
                            const SizedBox(height: 30),
                            ButtonApp(
                              buttonText: tr('Update'),
                              onPressed: () {
                                if (cubit.formKey.currentState!.validate()) {
                                  cubit.updateProfile();
                                }
                              },
                              width: double.infinity,
                              colors: const [
                                AppColor.darkBlue,
                                AppColor.lightBlue,
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  profileImageWidget(String image) => CircleAvatar(
        radius: 100,
        child: CachedImage(
          url: image,
          raduis: 100,
        ),
      );

  changeImage() => TextButton(
      onPressed: () =>
          showDialog(context: context, builder: (context) => choosePick()),
      child: Text(tr('Change Your Profile Picture')));

  choosePick() => AlertDialog(
        title: Text(tr('Choose Way')),
        titleTextStyle: const TextStyle(
            color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
        content: SizedBox(
          height: 130,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ListTile(
                  leading: const Icon(Icons.camera),
                  title: Text(tr('Camera')),
                  onTap: () {
                    cubit.pickImage(ImageSource.camera);
                    Navigator.pop(context);
                  }),
              ListTile(
                  leading: const Icon(Icons.photo),
                  title: Text(tr('Gallery')),
                  onTap: () {
                    cubit.pickImage(ImageSource.gallery);
                    Navigator.pop(context);
                  })
            ],
          ),
        ),
      );
}
