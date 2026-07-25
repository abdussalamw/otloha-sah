import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:form_builder_file_picker/form_builder_file_picker.dart';
import '../../../../core/utils/services/file_picker_service.dart';
import '../../../../core/utils/themes/color.dart';
import '../../../auth_module/presentation/widget/auth_button.dart';

class UploadFile extends StatefulWidget {
  const UploadFile({
    Key? key,
    required this.onCancel,
    required this.onUpload,
    required this.title,
    this.titleStyle,
  }) : super(key: key);
  final Function(String) onCancel;
  final Function(List<PlatformFile>? file) onUpload;
  final String title;
  final TextStyle? titleStyle;

  @override
  State<UploadFile> createState() => _UploadFileState();
}

class _UploadFileState extends State<UploadFile> {
  List<PlatformFile>? _file;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.title,
              style: widget.titleStyle ??
                  TextStyle(
                    color: AppColor.headTextColor,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width -
                      (_file != null ? 150 : 200),
                  child: Text(
                    _file?[0].name ?? 'Choose certification file'.tr(),
                    style: const TextStyle(height: 0.9),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (_file != null)
                  GestureDetector(
                    onTap: () {
                      widget.onCancel(_file![0].name);
                      _file = null;
                      setState(() {});
                    },
                    child: const Icon(Icons.cancel_outlined),
                  ),
              ],
            )
          ],
        ),
        if (_file == null)
          SizedBox(
            height: 30,
            child: ButtonApp(
              buttonText: 'upload'.tr(),
              width: 100,
              labelStyle: const TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
              onPressed: () async {
                FilePickerService filePickerService = FilePickerService(
                  type: FileType.custom,
                  onFileLoading: (result) {},
                  allowedExtensions: ['docx', 'pdf'],
                );
                _file = (await filePickerService.pickFile(context))?.files;
                widget.onUpload(_file);
                setState(() {});
              },
              borderRaduis: BorderRadius.circular(10),
              colors: const [
                AppColor.darkBlue,
                AppColor.lightBlue,
              ],
            ),
          ),
      ],
    );
  }
}
