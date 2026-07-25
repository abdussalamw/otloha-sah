import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:form_builder_file_picker/form_builder_file_picker.dart';
import '../../../../core/utils/services/file_picker_service.dart';
import '../../../../core/utils/themes/color.dart';
import '../../../auth_module/presentation/widget/auth_button.dart';
import 'narration_picker.dart';
import 'package:quran_widget_flutter/quran_widget_flutter.dart';

class AddTeacherNarrationDialog extends StatefulWidget {
  const AddTeacherNarrationDialog({
    super.key,
    required this.narrations,
    required this.onSubmit,
  });

  final List<Narration> narrations;
  final Function(Map<Narration, String?>) onSubmit;

  @override
  State<AddTeacherNarrationDialog> createState() =>
      _AddTeacherNarrationDialogState();
}

class _AddTeacherNarrationDialogState extends State<AddTeacherNarrationDialog> {
  Narration? _selectedNarration;
  bool isNarrationSelected = false;
  PlatformFile? _file;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/images/teacher_dialog_background.png'),
            fit: BoxFit.fill),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.center,
            child: Text(
              'New Narration'.tr(),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                height: 1,
                color: AppColor.txtColor3,
              ),
            ),
          ),
          const Divider(),
          Text(
            'Pick Narration'.tr(),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColor.txtColor3,
            ),
          ),
          ListView(
            shrinkWrap: true,
            children: [
              NarrationPickerRadioGroup(
                narrations: widget.narrations,
                initValue: _selectedNarration,
                onChange: (narration) {
                  setState(() {
                    _selectedNarration = narration;
                  });
                },
              ),
            ],
          ),
          const Divider(),
          Text(
            'Certification'.tr(),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColor.txtColor3,
            ),
          ),
          Row(
            children: [
              if (_file == null)
                const Icon(
                  Icons.add,
                  color: AppColor.txtGrey,
                ),
              GestureDetector(
                onTap: () async {
                  FilePickerService filePickerService = FilePickerService(
                    type: FileType.custom,
                    onFileLoading: (result) {},
                    allowedExtensions: ['docx', 'pdf'],
                  );
                  _file = (await filePickerService.pickFile(context))?.files[0];

                  setState(() {});
                },
                child: RichText(
                  text: TextSpan(
                    children: [
                      if (_file == null)
                        TextSpan(
                          text: _file?.name ?? 'Upload your file'.tr(),
                          style: const TextStyle(
                            color: AppColor.txtGrey,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      if (_file == null)
                        TextSpan(
                          text: ' (${'optional'.tr()})',
                          style: const TextStyle(
                            color: AppColor.txtGrey,
                            fontSize: 12,
                          ),
                        ),
                      if (_file != null)
                        TextSpan(
                          text: _file?.name ?? '',
                          style: const TextStyle(
                            color: AppColor.txtGrey,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                width: 100,
                height: 30,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.lightGrey,
                    elevation: 0,
                  ),
                  onPressed: () {
                    if (isNarrationSelected) {
                      setState(() {
                        isNarrationSelected = false;
                      });
                    }
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Cancel'.tr(),
                    style: const TextStyle(
                      color: AppColor.txtGrayColor,
                      height: 1.5,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 100,
                child: SizedBox(
                  height: 30,
                  child: ButtonApp(
                    buttonText: 'finish'.tr(),
                    width: 80,
                    labelStyle: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      height: 1.5,
                    ),
                    onPressed: _selectedNarration == null
                        ? null
                        : () {
                            setState(() {
                              isNarrationSelected = true;
                            });
                            widget.onSubmit({_selectedNarration!: _file?.path});
                          },
                    borderRaduis: BorderRadius.circular(10),
                    colors: const [
                      AppColor.darkBlue,
                      AppColor.lightBlue,
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
