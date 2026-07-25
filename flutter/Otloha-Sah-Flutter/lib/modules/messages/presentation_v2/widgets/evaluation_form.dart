import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otloha_sah_flutter/data_source/user_services_data.dart';
import '../../../../core/utils/themes/color.dart';
import '../../../../core/utils/themes/text_style.dart';
import '../../business_logic_v2/cubit/message_details_cubit.dart';
import '../../business_logic_v2/cubit/record_cubit.dart';
import '../../business_logic_v2/evaluation_form/evaluation_form_cubit.dart';
import '../../business_logic_v2/evaluation_form/evaluation_form_state.dart';
import 'chat_input_field.dart';
import 'record_view.dart';
import '../../../settings/business_logic/themes/theme_cubit.dart';
import 'package:web_socket_channel/io.dart';

class EvaluationForm extends StatelessWidget {
  const EvaluationForm({
    Key? key,
    required this.channel,
  }) : super(key: key);
  final IOWebSocketChannel channel;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 20),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: Color(ThemeCubit.isDark ? 0xFF323E40 : 0xffe0faff),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          EvaluationFormHeader(),
          EvaluationFormBody(),
          SizedBox(height: 4),
          EvaluationFormFooter(),
        ],
      ),
    );
  }
}

class EvaluationFormHeader extends StatelessWidget {
  const EvaluationFormHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<MessageDetailsCubit, MessageDetailsState>(
        listenWhen: (previous, current) =>
            current is MessageDetailsChangeSelectedTextState,
        listener: (context, formState) {
          EvaluationFormCubit.get(context)
              .setErrorText(MessageDetailsCubit.get(context).selectAyha);
        },
        child: BlocBuilder<MessageDetailsCubit, MessageDetailsState>(
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(4.0),
              child: UserDataServices.instance
                          .getUserDataFast()
                          ?.teacherProfile
                          ?.canReplyOnEveryVerseInRecitation ??
                      false
                  ? Text(
                      EvaluationFormCubit.get(context).errorText ??
                          'select_fault_text'.tr(),
                      style: TextStyle(
                        color: AppColor.userNameColor,
                        fontWeight: FontWeight.normal,
                        fontFamily: 'Hafs20',
                        fontSize: 14,
                      ),
                    )
                  : const SizedBox(),
            );
          },
        ));
  }
}

class EvaluationFormBody extends StatelessWidget {
  const EvaluationFormBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EvaluationFormCubit, EvaluationFormState>(
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: AppColor.background,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: AppColor.lightBlue,
              width: 1,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  children: [
                    TextFieldMessageWidget(
                      title: 'add_correction'.tr(),
                      controller:
                          EvaluationFormCubit.get(context).commentController,
                    ),
                  ],
                ),
              ),
              RecordingView(
                onStop: (recordPath) {
                  print('set record path');
                  EvaluationFormCubit.get(context).setRecordPath(recordPath);
                },
                hasCancel: false,
              ),
            ],
          ),
        );
      },
    );
  }
}

class EvaluationFormFooter extends StatelessWidget {
  const EvaluationFormFooter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EvaluationFormCubit, EvaluationFormState>(
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              'fault_type'.tr(),
              style: AppStyle().textStyle1.copyWith(
                    fontSize: 14,
                    color: AppColor.headTextColor,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            SizedBox(
              height: 40,
              width: MediaQuery.of(context).size.width - 250,
              child: DropdownButtonFormField<FaultType>(
                value: EvaluationFormCubit.get(context).faultType,
                items:
                    [FaultType.tajweed, FaultType.pronunciation, FaultType.word]
                        .map(
                          (e) => DropdownMenuItem(
                            value: e,
                            child: Text(
                              e.toShortString().tr(),
                              style: const TextStyle(height: 1.4),
                            ),
                          ),
                        )
                        .toList(),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 6),
                  fillColor: AppColor.white,
                ),
                focusColor: AppColor.white,
                onChanged: (value) {
                  if (value != null) {
                    EvaluationFormCubit.get(context).setFaultType(value);
                  }
                },
              ),
            ),
            // const ErrorTypeView(title: 'tajweed', errorType: FaultType.tajweed),
            // const ErrorTypeView(
            //   title: 'pronunciation',
            //   errorType: FaultType.pronunciation,
            // ),
            // const ErrorTypeView(
            //   title: 'word',
            //   errorType: FaultType.word,
            // ),
            ActionAudioIcon(
              iconWidget: Icon(
                Icons.clear,
                size: 16,
                color: AppColor.headTextColor,
              ),
              colorBack: AppColor.background,
              colorText: AppColor.headTextColor,
              action: () async {
                await RecordCubit.get(context).reset(isReset: false);
                EvaluationFormCubit.get(context).reset();
                MessageDetailsCubit.get(context).resetVerse();
              },
            ),
            Container(
              padding: const EdgeInsets.all(4),
              margin: const EdgeInsets.all(4),
              height: 25,
              width: 25,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.5),
                color: state is EvaluationFormLoadingSate
                    ? AppColor.grey
                    : AppColor.headTextColor,
              ),
              child: Center(
                child: InkWell(
                  onTap: state is EvaluationFormLoadingSate
                      ? null
                      : () async {
                          await RecordCubit.get(context).stopRecord();
                          await EvaluationFormCubit.get(context)
                              .submitEvaluationForm();

                          print('form submitted');
                          // await MessageDetailsCubit.get(context).resetVerse();

                          await RecordCubit.get(context).reset(isReset: false);
                        },
                  child: const Icon(
                    Icons.done,
                    size: 18,
                    color: AppColor.white,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class ErrorTypeView extends StatelessWidget {
  const ErrorTypeView({
    Key? key,
    required this.title,
    required this.errorType,
  }) : super(key: key);

  final String title;
  final FaultType errorType;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EvaluationFormCubit, EvaluationFormState>(
      builder: (context, state) {
        return GestureDetector(
          onTap: () {
            EvaluationFormCubit.get(context).setFaultType(errorType);
          },
          child: Container(
            margin: const EdgeInsets.all(4),
            padding: const EdgeInsets.all(4),
            width: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: AppColor.background,
              border: Border.all(
                color: EvaluationFormCubit.get(context).faultType == errorType
                    ? AppColor.hidenBlue
                    : AppColor.background,
                width: 1,
              ),
            ),
            child: Center(
              child: Text(
                title.tr(),
                style: AppStyle().textStyle1.copyWith(
                    fontSize: 12,
                    color: AppColor.headTextColor,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        );
      },
    );
  }
}
