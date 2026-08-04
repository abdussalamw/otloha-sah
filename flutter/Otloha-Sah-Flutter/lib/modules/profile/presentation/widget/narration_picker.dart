import 'package:flutter/material.dart';
import 'package:otloha_sah_flutter/data_source/models/translation/translatable.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:quran_widget_flutter/model/narration.dart';

class NarrationsPicker extends StatefulWidget {
  const NarrationsPicker({
    Key? key,
    required this.onChanged,
    required this.narrations,
    this.initValue,
  }) : super(key: key);
  final Function(Narration? narration) onChanged;
  final List<Narration> narrations;
  final String? initValue;

  @override
  State<NarrationsPicker> createState() => _NarrationsPickerState();
}

class _NarrationsPickerState extends State<NarrationsPicker> {
  Narration? _narration;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 20,
      child: DropdownButton<Narration>(
        value: _narration,

        items: widget.narrations
            .map<DropdownMenuItem<Narration>>((Narration value) {
          return DropdownMenuItem<Narration>(
            value: value,
            child: Text(
              value.name.translate() ?? '',
              style: const TextStyle(fontSize: 12),
            ),
          );
        }).toList(),

        // Step 5.
        onChanged: (value) {
          setState(() {
            _narration = value;
          });
          widget.onChanged(value);
        },
        underline: const SizedBox(),
      ),
    );
    // FormBuilderDropdown<Narration>(
    //   validator: FormBuilderValidators.compose([
    //     FormBuilderValidators.required(context),
    //   ]),
    // initialValue: widget.initValue != null
    //     ? widget.narrations
    //         .firstWhere((element) => element.name == widget.initValue)
    //     : null,
    //   decoration: InputDecoration(

    //     labelStyle: const TextStyle(color: AppColor.lightBlue),
    //     // isDense: true,
    //     // contentPadding: EdgeInsets.symmetric(horizontal: 60, vertical: 60),
    //     enabledBorder: InputBorder.none,
    //     focusedBorder: InputBorder.none,
    //     errorBorder: InputBorder.none,
    //     focusedErrorBorder: InputBorder.none,
    //     disabledBorder: InputBorder.none,
    //     border: OutlineInputBorder(
    //       borderSide: const BorderSide(
    //         color: AppColor.lightBlue,
    //         width: 10,
    //       ),
    //       borderRadius: BorderRadius.circular(8.0),
    //     ),
    //   ),
    //   hint: Text(
    //     tr('Narration'),
    //     style: const TextStyle(color: AppColor.lightBlue),
    //   ),
    //   items: widget.narrations
    //       .map((narration) => DropdownMenuItem(
    //           value: narration,
    //           child: Text(
    //             narration.name,
    //             style: const TextStyle(fontFamily: ''),
    //           )))
    //       .toList(),
    //   name: 'type',
    //   onChanged: (value) => widget.onChanged(value),
    // );
  }
}

class NarrationPickerRadioGroup extends StatefulWidget {
  const NarrationPickerRadioGroup({
    Key? key,
    required this.narrations,
    this.initValue,
    required this.onChange,
  }) : super(key: key);
  final List<Narration> narrations;
  final Narration? initValue;
  final Function(Narration?) onChange;

  @override
  State<NarrationPickerRadioGroup> createState() =>
      _NarrationPickerRadioGroupState();
}

class _NarrationPickerRadioGroupState extends State<NarrationPickerRadioGroup> {
  Narration? _pickedNarration;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: widget.narrations
          .map(
            (e) => RadioListTile<Narration>(
              value: e,
              groupValue: _pickedNarration ?? widget.initValue,
              title: Text(e.name.translate() ?? ''),
              onChanged: (narration) {
                setState(() {
                  _pickedNarration = narration;
                  widget.onChange(narration);
                });
              },
            ),
          )
          .toList(),
    );
  }
}
