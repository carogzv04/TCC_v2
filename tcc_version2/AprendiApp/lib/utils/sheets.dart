import 'package:flutter/material.dart';

Future<T?> showAppSheet<T>({
  required BuildContext context,
  required Widget child,
  bool isScrollControlled = false,
  Color bg = const Color(0xFFF6F7D7),
}) {
  final safeBottom = MediaQuery.of(context).padding.bottom;

  return showModalBottomSheet<T>(
    context: context,
    useSafeArea: true,
    isScrollControlled: isScrollControlled,
    backgroundColor: bg,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.only(bottom: 20 + safeBottom),
        child: child,
      ),
    ),
  );
}
