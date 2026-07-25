import 'package:flutter/material.dart';
import '../../../../core/utils/constant/utils.dart';

import '../../../../core/utils/themes/color.dart';
import '../../../../core/widgets/text_view.dart';

class SearchBarApp extends StatefulWidget {
  const SearchBarApp({
    Key? key,
    this.backIcon,
    required this.title,
    this.actionIcon,
    this.onSearch,
  }) : super(key: key);

  final Widget? backIcon;
  final Widget? actionIcon;
  final String title;

  final Function(String val)? onSearch;

  @override
  State<SearchBarApp> createState() => _SearchBarAppState();
}

class _SearchBarAppState extends State<SearchBarApp> {
  final TextEditingController _controller = TextEditingController();

  String valueSearch = '';

  var borderSide = const BorderSide(width: 1, color: AppColor.lightBlue);

  var border = OutlineInputBorder(
    borderRadius: BorderRadius.circular(8.0),
    borderSide: BorderSide.none,
  );

  bool showSearch = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
      child: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              widget.backIcon ?? Container(),
              Expanded(
                child: TextView(
                  text: widget.title,
                  colorText: AppColor.txtColor3,
                  weightText: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        showSearch = !showSearch;
                      });
                    },
                    icon: const Icon(Icons.search),
                  ),
                  widget.actionIcon ?? Container()
                ],
              )
            ],
          ),
          if (showSearch) _searchBox()
        ],
      ),
    );
  }

  Widget _searchBox() {
    return Form(
      child: AnimatedContainer(
        duration: const Duration(seconds: 1),
        curve: Curves.easeIn,
        color: AppColor.background1,
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: GestureDetector(
                  onTap: () {
                    setState(() {
                      showSearch = false;
                    });
                  },
                  child: const Icon(
                    Icons.arrow_back,
                    color: AppColor.darkBlue,
                  )),
            ),
            Expanded(
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  //  color: Colors.blue,
                  isDense: true,
                  contentPadding: const EdgeInsets.all(12),
                  filled: true,
                  enabledBorder: border,
                  focusedBorder: border,
                  errorBorder: border,
                  focusedErrorBorder: border,
                  disabledBorder: border,
                  hintText: translate('Search'),

                  fillColor: AppColor.white,
                ),
                onChanged: (val) {
                  setState(() {
                    valueSearch = val;
                  });
                  widget.onSearch!(val);
                },
              ),
            ),
            if (valueSearch.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(8),
                child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _controller.text = '';
                        valueSearch = '';
                      });
                    },
                    child: const Icon(
                      Icons.clear,
                      color: AppColor.darkBlue,
                    )),
              ),
          ],
        ),
      ),
    );
  }
}
