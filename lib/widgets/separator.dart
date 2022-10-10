import 'package:flutter/material.dart';
import 'package:supervision_icatech/repo/repository.dart';

Widget separatorText(
    {required BuildContext context, required String text, Color? color}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Container(
          padding: const EdgeInsets.fromLTRB(20, 15, 20, 5),
          child: Text(text,
              style: TextStyle(
                  color: Repository.subTextColor(context), fontSize: 30))),
      Divider(
        color: Repository.dividerColor(context),
        thickness: 2,
      ),
      Container(padding: const EdgeInsets.fromLTRB(20, 25, 20, 10)),
    ],
  );
}
