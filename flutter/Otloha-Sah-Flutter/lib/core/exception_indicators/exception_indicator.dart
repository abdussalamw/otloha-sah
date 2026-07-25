import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// Basic layout for indicating that an exception occurred.
class ExceptionIndicator extends StatelessWidget {
  const ExceptionIndicator({
    required this.title,
    //required this.assetName,
    this.message,
    this.onTryAgain,
    Key? key,
  }) : super(key: key);
  final String title;
  final String? message;
  // final String assetName;
  final VoidCallback? onTryAgain;

  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.warning_amber_outlined,
                size: 100,
              ),
              const SizedBox(
                height: 32,
              ),
              Text(
                title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              if (message != null)
                const SizedBox(
                  height: 16,
                ),
              if (message != null)
                Text(
                  message!,
                  textAlign: TextAlign.center,
                ),
              if (onTryAgain != null)
                const SizedBox(
                  height: 50,
                ),
              if (onTryAgain != null)
                SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: onTryAgain,
                    // color: CustomColors.blue,
                    icon: const Icon(
                      Icons.refresh,
                      color: Colors.white,
                    ),
                    label: Text(
                      tr('Try Again'),
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      );
}
