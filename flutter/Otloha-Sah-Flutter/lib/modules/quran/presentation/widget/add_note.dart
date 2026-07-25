import 'package:flutter/material.dart';
import 'package:otloha_sah_flutter/data_source/local/database/database/database.dart';
import '../../../../core/widgets/text_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';

import '../../../../core/utils/constant/utils.dart';
import '../../../../core/utils/res/svg_app.dart';
import '../../../../core/utils/themes/color.dart';
import '../../business_logic/cubit/addnote_cubit.dart';

class AddNoteWidget extends StatefulWidget {
  const AddNoteWidget({
    Key? key,
    // required this.verseNote,
    this.isEdit = false,
    this.title,
  }) : super(key: key);

  // final VerseNote verseNote;
  final bool isEdit;
  final String? title;

  @override
  State<AddNoteWidget> createState() => _AddNoteWidgetState();
}

class _AddNoteWidgetState extends State<AddNoteWidget> {
  AddNoteCubit? _cubit;
  late FocusNode myFocusNode;

  @override
  void initState() {
    super.initState();
    _cubit = AddNoteCubit.get(context);
    // _cubit!.setIsEdit(widget.isEdit, verseNote: widget.verseNote);
    myFocusNode = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    myFocusNode.dispose();
    _cubit!.con.text = '';
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddNoteCubit, AddNoteState>(
      listener: (context, state) {
        if (state is AddNoteSuccess) {
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        return Container(
          height: 380,
          decoration: BoxDecoration(
            color: AppColor.background,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          child: Stack(
            children: [
              _viewTop(context),
              _viewPage(context),
            ],
          ),
        );
      },
    );
  }

  Widget _viewPage(context) {
    return Padding(
        padding: const EdgeInsets.only(top: 40),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
            color: AppColor.background,
          ),
          child: Column(
            children: [
              if (widget.title != null) _viewAyah(),
              TextField(
                  focusNode: myFocusNode,
                  controller: _cubit!.con,
                  // autofocus: true,
                  decoration: InputDecoration(
                    enabled: _cubit!.isEnable,
                    contentPadding: const EdgeInsets.all(12),
                    filled: true,
                    enabledBorder: _cubit!.border,
                    focusedBorder: _cubit!.border,
                    errorBorder: _cubit!.border,
                    focusedErrorBorder: _cubit!.border,
                    disabledBorder: _cubit!.border,
                    hintText: translate('AddNote'),
                    fillColor: AppColor.background,
                  ),
                  maxLines: 10,
                  textAlign: TextAlign.start,
                  textDirection: _cubit!.textDirection,
                  onChanged: (val) {
                    _cubit!.setText(val);
                  }),
            ],
          ),
        ));
  }

  _viewAyah() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: AppColor.background, borderRadius: BorderRadius.circular(8)),
      child: TextView(
        padding: EdgeInsets.zero,
        text: widget.title ?? '',
        sizeText: 18,
        weightText: FontWeight.w900,
        colorText: AppColor.txtColor3,
        textAlign: TextAlign.start,
        fontFamily: 'Hafs17',
      ),
    );
  }

  Widget _viewTop(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: GestureDetector(
        child: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
            image: DecorationImage(
              image: Svg(
                AppSVG.back2,
                color: AppColor.white,
              ),
              fit: BoxFit.cover,
              opacity: .08,
              repeat: ImageRepeat.noRepeat,
              scale: 2,
            ),
            color: AppColor.darkBlue,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        _cubit!.con.text = '';
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(
                        Icons.arrow_back_sharp,
                        color: AppColor.txtColor2,
                        size: 20,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        if (!_cubit!.isEnable) {
                          _cubit!.setEnable(true);
                          myFocusNode.requestFocus();
                        } else {
                          // _cubit!.saveNote(verseNote: widget.verseNote);
                        }
                      },
                      icon: Icon(
                        _cubit!.isEnable ? Icons.done_all : Icons.edit,
                        color: AppColor.txtColor2,
                        size: 20,
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 50,
              )
            ],
          ),
        ),
      ),
    );
  }
}
