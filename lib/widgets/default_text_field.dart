import 'package:flutter/material.dart';
import 'package:supervision_icatech/repo/repository.dart';
import 'package:supervision_icatech/utils/input_decoration.dart';
import 'package:supervision_icatech/utils/size_config.dart';
import 'package:supervision_icatech/utils/styles.dart';

import 'package:gap/gap.dart';

class DefaultTextField extends StatelessWidget {
  const DefaultTextField({
    Key? key,
    this.focusNode,
    required this.controller,
    required this.title,
    this.mandatory = true,
    this.obscure,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
    this.keyboardType,
    this.onFieldSubmitted,
    this.textInputAction,
    this.enabled,
    this.label,
    this.maxLines,
    required this.isRequired,
  }) : super(key: key);

  final FocusNode? focusNode;
  final TextEditingController? controller;
  final String title;
  final String? label;
  final bool mandatory;
  final bool? obscure;
  final FormFieldValidator<String>? validator;
  final Widget? suffixIcon;
  final IconData? prefixIcon;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onFieldSubmitted;
  final TextInputAction? textInputAction;
  final bool? enabled;
  final int? maxLines;
  final bool isRequired;
  String get _title => title;
  //String? get _label => _label;
  Widget? get _suffixIcon => suffixIcon;
  IconData? get _prefixIcon => prefixIcon;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _title,
          style: TextStyle(
              color: Styles.icatechPurpleColor.withOpacity(0.7),
              fontWeight: FontWeight.w500,
              fontSize: 15),
        ),
        Gap(getProportionateScreenHeight(5)),
        TextFormField(
          minLines: 1,
          maxLines: maxLines ?? 1,
          obscureText: false,
          enabled: enabled,
          focusNode: focusNode,
          keyboardType: keyboardType,
          cursorColor: Styles.icatechGrayColor.withOpacity(0.5),
          textInputAction: textInputAction ?? TextInputAction.next,
          onFieldSubmitted: onFieldSubmitted,
          validator: (value) {
            if ((value == null || value.isEmpty) && isRequired) {
              return 'Este campo es obligatorio';
            }
            return null;
          },
          controller: controller,
          decoration: inputDecoration(
              text: label ?? _title,
              prefixIcon: _prefixIcon,
              suffixIcon: _suffixIcon,
              context: context),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          style: TextStyle(color: Repository.fieldColor(context)),
        ),
        Gap(getProportionateScreenHeight(20)),
      ],
    );
  }
}
