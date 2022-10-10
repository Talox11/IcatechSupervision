import 'package:flutter/material.dart';
import 'package:supervision_icatech/repo/repository.dart';
import 'package:supervision_icatech/utils/iconly/iconly_light.dart';
import 'package:gap/gap.dart';

AppBar myAppBar({
  required String title,
  required String connStatus,
  required Color connStatusColor,
  String? stringColor,
  required bool implyLeading,
  required BuildContext context,
  bool? hasAction,
}) {
  return AppBar(
    centerTitle: true,
    title: Text(
      title,
      style: TextStyle(color: Repository.textColor(context), fontSize: 18),
    ),
    bottom: PreferredSize(
      preferredSize: const Size.fromHeight(40),
      child: Container(
        height: 20,
        color: connStatusColor,
        child: Center(child:Text(connStatus, style: TextStyle(color: Color.fromARGB(255, 3, 96, 53)),))
      ),
    ),
    backgroundColor: Colors.transparent,
    elevation: 0,
    leading: implyLeading == true
        ? Transform.scale(
            scale: 0.7,
            child: IconButton(
              icon: Icon(Icons.keyboard_backspace_rounded,
                  size: 33, color: Repository.textColor(context)),
              onPressed: () => Navigator.pop(context),
            ))
        : const SizedBox(),
    actions:
        hasAction == true ? const [Icon(IconlyBroken.Search), Gap(15)] : null,
  );
}
