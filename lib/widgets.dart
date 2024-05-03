import 'package:flutter/material.dart';

Widget buildButton({
  required BuildContext context,
  required String text,
  required VoidCallback onPressed,
}) {
  return SizedBox(
    width: double.infinity,
    height: 50,
    child: ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: Theme.of(context).colorScheme.onSecondary,
        backgroundColor: Theme.of(context).colorScheme.secondary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
      ),
    ),
  );
}

Widget buildTextField({
  TextEditingController? controller,
  String? labelText,
  int? maxLines,
  double? maxWidth,
}) {
  return ConstrainedBox(
    constraints: maxWidth == null ? const BoxConstraints() : BoxConstraints(maxWidth: maxWidth),
    child: TextField(
      controller: controller,
      decoration: InputDecoration(labelText: labelText, border: const OutlineInputBorder()),
      maxLines: maxLines,
    ),
  );
}
