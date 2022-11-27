import 'package:flutter/material.dart';

Widget appbarLeadingTitle({
  required BuildContext context,
  required String title,
  required Widget? leading,
}) {
  return Row(
    children: [
      leading ?? Container(),
      Padding(
        padding: EdgeInsets.only(left: leading == null ? 18 : 0),
        child: Text(
          title,
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
    ],
  );
}

Widget appbarSearch(
  BuildContext context,
) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 12),
    child: TextFormField(
      decoration: InputDecoration(
        isDense: true,
        hintText: "Search",
        hintStyle: Theme.of(context).textTheme.labelMedium,
        prefixIcon: const Icon(
          Icons.search,
          size: 25,
        ),
        contentPadding: const EdgeInsets.fromLTRB(0, 13, 15, 13),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(
            style: BorderStyle.none,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(
            style: BorderStyle.none,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(
            style: BorderStyle.none,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(
            style: BorderStyle.none,
          ),
        ),
        // constraints: const BoxConstraints(maxHeight: 30),
        // alignLabelWithHint: false,
        // contentPadding: const EdgeInsets.only(
        //   top: 6,
        //   bottom: 6,
        // ),
      ),
    ),
  );
}

Widget appbarLeading({
  required BuildContext context,
  VoidCallback? willPopFunc,
}) {
  return IconButton(
    onPressed: willPopFunc ??
        () {
          Navigator.of(context).pop();
        },
    icon: const Icon(
      Icons.arrow_back_ios_new_rounded,
      color: Colors.black,
    ),
  );
}
