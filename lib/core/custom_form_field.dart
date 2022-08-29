// ignore_for_file: avoid_unnecessary_containers, sized_box_for_whitespace, non_constant_identifier_names, must_be_immutable, unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'constant/colors.dart';
import 'customWidgets.dart';

class CustomTextField extends StatelessWidget {
  // ignore: use_key_in_widget_constructors
  const CustomTextField({
    this.hint,
    this.label,
    this.pretext,
    this.sufText,
    this.maxLength,
    this.initialValue,
    this.hintColor,
    this.icon,
    this.enabled,
    this.prefixIcon,
    this.suffixIcon,
    this.keyType,
    this.keyAction,
    this.textEditingController,
    this.onSubmited,
    this.onTap,
    this.validate,
    this.inputformater,
    this.onChanged,
    this.validatorText,
    this.onClick,
    this.AllowClickable = false,
    this.color,
    this.fillColor,
    this.borderColor,
    this.colors,
    this.enableColor,
    this.labelSize,
  });

  final VoidCallback? onClick;
  final bool? AllowClickable;
  final String? hint;
  final String? label;
  final Color? color;
  final Color? colors;
  final Color? fillColor;
  final Color? hintColor;
  final Color? borderColor;
  final Color? enableColor;
  final String? pretext;
  final String? sufText;
  final String? initialValue;
  final int? maxLength;
  final double? labelSize;
  final bool? enabled;
  final Widget? icon, prefixIcon, suffixIcon;
  final TextInputType? keyType;
  final TextEditingController? textEditingController;
  final TextInputAction? keyAction;
  final ValueChanged<String>? validate;
  final ValueChanged<String>? onSubmited;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;
  final String? validatorText;
  final List<TextInputFormatter>? inputformater;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 5),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: customDescriptionText(
                    label ?? '',
                    fontSize: labelSize ?? 14,
                    fontWeight: FontWeight.w600,
                    colors: AppColor().textColor,
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                (validatorText != null && validatorText!.isNotEmpty)
                    ? Container(
                        margin: const EdgeInsets.only(top: 5),
                        child: customDescriptionText(
                          "",
                          colors: AppColor().primaryColor,
                          fontSize: 12,
                        ),
                      )
                    : Container()
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              if (AllowClickable!) onClick!();
            },
            child: Container(
              child: TextFormField(
                inputFormatters: inputformater ?? [],
                autofocus: false,
                onChanged: onChanged,
                maxLength: maxLength,
                controller: textEditingController,
                enabled: enabled,
                keyboardType: keyType,
                textInputAction: keyAction,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return validatorText;
                  } else if (value != null) {
                    return RegExp(
                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(value)
                        ? null
                        : "Please enter a valid email";
                  }
                  return null;
                },
                initialValue: initialValue,
                decoration: InputDecoration(
                  fillColor: fillColor ?? AppColor().whiteColor,
                  filled: true,
                  isDense: true,
                  prefixText: pretext,
                  suffixText: sufText,
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: colors ?? AppColor().lightTextColor,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(10)),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: enableColor ?? AppColor().lightTextColor,
                          width: 1),
                      borderRadius: BorderRadius.circular(10)),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: borderColor ?? AppColor().lightTextColor,
                          width: 1),
                      borderRadius: BorderRadius.circular(10)),
                  hintText: hint,
                  prefixIcon: prefixIcon,
                  suffixIcon: suffixIcon,
                  hintStyle: GoogleFonts.openSans(
                    color: hintColor ?? Colors.black54,
                    fontSize: 14,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                // validator: validate,
                onFieldSubmitted: onSubmited,
                onTap: onTap,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class CustomPassWord extends StatefulWidget {
  // ignore: use_key_in_widget_constructors
  const CustomPassWord({
    this.hint,
    this.label,
    this.pretext,
    this.sufText,
    this.maxLength,
    this.initialValue,
    this.hintColor,
    this.icon,
    this.enabled,
    this.prefixIcon,
    this.suffixIcon,
    this.keyType,
    this.keyAction,
    this.textEditingController,
    this.onSubmited,
    this.validate,
    this.inputformater,
    this.onChanged,
    this.validatorText,
    this.onClick,
    this.AllowClickable = false,
    this.color,
    this.fillColor,
    this.borderColor,
    this.colors,
    this.enableColor,
    this.labelSize,
    required this.obscureText,
  });

  final VoidCallback? onClick;
  final bool? AllowClickable;
  final String? hint;
  final String? label;
  final Color? color;
  final Color? colors;
  final Color? fillColor;
  final Color? hintColor;
  final Color? borderColor;
  final Color? enableColor;
  final String? pretext;
  final String? sufText;
  final String? initialValue;
  final int? maxLength;
  final double? labelSize;
  final bool? enabled;
  final Widget? icon, prefixIcon, suffixIcon;
  final TextInputType? keyType;
  final TextEditingController? textEditingController;
  final TextInputAction? keyAction;
  final ValueChanged<String>? validate;
  final ValueChanged<String>? onSubmited;
  final ValueChanged<String>? onChanged;
  final String? validatorText;
  final bool obscureText;
  final List<TextInputFormatter>? inputformater;

  @override
  State<CustomPassWord> createState() => _CustomPassWordState();
}

class _CustomPassWordState extends State<CustomPassWord> {
  bool isHiddenPassword = true;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 5),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: customDescriptionText(
                    widget.label ?? '',
                    fontSize: widget.labelSize ?? 14,
                    fontWeight: FontWeight.w600,
                    colors: AppColor().textColor,
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                (widget.validatorText != null &&
                        widget.validatorText!.isNotEmpty)
                    ? Container(
                        margin: const EdgeInsets.only(top: 5),
                        child: customDescriptionText(
                          "",
                          colors: AppColor().primaryColor,
                          fontSize: 12,
                        ),
                      )
                    : Container()
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              if (widget.AllowClickable!) widget.onClick!();
            },
            child: SizedBox(
              child: Row(
                children: [
                  Expanded(
                    flex: 6,
                    child: TextFormField(
                      autofocus: false,
                      enabled: widget.enabled,
                      keyboardType: widget.keyType,
                      textInputAction: widget.keyAction,
                      initialValue: widget.initialValue,
                      cursorColor: AppColor().primaryColor,
                      controller: widget.textEditingController,
                      obscureText: isHiddenPassword,
                      style: GoogleFonts.openSans(
                        color: AppColor().textColor,
                        fontSize: 12,
                      ),
                      decoration: InputDecoration(
                        isDense: true,
                        filled: true,
                        fillColor: widget.fillColor ?? AppColor().whiteColor,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color:
                                widget.enableColor ?? AppColor().lightTextColor,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: widget.colors ?? AppColor().textColor,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color:
                                widget.borderColor ?? AppColor().lightTextColor,
                            width: 1,
                          ),
                        ),
                        suffixIcon: widget.suffixIcon ??
                            InkWell(
                              onTap: _togglePasswordView,
                              child: Icon(
                                isHiddenPassword
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: isHiddenPassword
                                    ? AppColor().primaryColor.withOpacity(0.5)
                                    : AppColor().primaryColor,
                              ),
                            ),
                        hintText: widget.hint ?? 'Enter your password',
                        hintStyle: GoogleFonts.openSans(
                          color: widget.hintColor ?? Colors.black54,
                          fontSize: 14,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      onFieldSubmitted: widget.onSubmited,
                      validator: (value) {
                        if (value!.length < 6) {
                          return 'Your password should be at least 6 characters long';
                        } else if (value.isEmpty) {
                          return 'Enter your password';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  void _togglePasswordView() {
    setState(() {
      isHiddenPassword = !isHiddenPassword;
    });
  }
}

class CustomDatePicker extends StatelessWidget {
  const CustomDatePicker({
    Key? key,
    this.hint,
    this.label,
    this.pretext,
    this.sufText,
    this.maxLength,
    this.initialValue,
    this.icon,
    this.enabled,
    this.prefixIcon,
    this.suffixIcon,
    this.keyType,
    this.keyAction,
    this.textEditingController,
    this.onSubmited,
    this.validate,
    this.inputformater,
    this.onChanged,
    this.validatorText,
    this.onClick,
    this.AllowClickable = false,
    this.color,
    this.width,
    this.fillColor,
    this.borderColor,
    this.colors,
    this.enableColor,
    this.labelSize,
    this.hintColor,
  }) : super(key: key);

  final VoidCallback? onClick;
  final bool? AllowClickable;
  final String? hint;
  final String? label;
  final Color? color;
  final Color? colors;
  final Color? fillColor;
  final Color? borderColor;
  final Color? enableColor;
  final Color? hintColor;
  final String? pretext;
  final String? sufText;
  final String? initialValue;
  final int? maxLength;
  final double? labelSize;
  final double? width;
  final bool? enabled;
  final Widget? icon, prefixIcon, suffixIcon;
  final TextInputType? keyType;
  final TextEditingController? textEditingController;
  final TextInputAction? keyAction;
  final ValueChanged<String>? validate;
  final ValueChanged<String>? onSubmited;
  final ValueChanged<String>? onChanged;
  final String? validatorText;
  final List<TextInputFormatter>? inputformater;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 5),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: customDescriptionText(
                    label ?? '',
                    fontSize: labelSize ?? 10,
                    colors: AppColor().textColor,
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                (validatorText != null && validatorText!.isNotEmpty)
                    ? Container(
                        margin: const EdgeInsets.only(top: 5),
                        child: customDescriptionText(
                          "",
                          colors: AppColor().primaryColor,
                          fontSize: 12,
                        ),
                      )
                    : Container()
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              if (AllowClickable!) onClick!();
            },
            child: Container(
              child: TextField(
                controller: textEditingController,
                inputFormatters: inputformater ?? [],
                autofocus: false,
                onChanged: onChanged,
                maxLength: maxLength,
                enabled: enabled,
                keyboardType: keyType,
                textInputAction: keyAction,
                decoration: InputDecoration(
                  fillColor: fillColor ?? AppColor().whiteColor,
                  filled: true,
                  isDense: true,
                  prefixText: pretext,
                  suffixText: sufText,
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: colors ?? AppColor().lightTextColor,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(10)),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: enableColor ?? AppColor().lightTextColor,
                          width: 1),
                      borderRadius: BorderRadius.circular(10)),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: borderColor ?? AppColor().lightTextColor,
                          width: 1),
                      borderRadius: BorderRadius.circular(10)),
                  hintText: hint,
                  prefixIcon: prefixIcon,
                  suffixIcon: suffixIcon,
                  hintStyle: GoogleFonts.openSans(
                    color: hintColor ?? Colors.black26,
                    fontSize: 12,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                //               onSubmitted,: (val) => setState(() => _time = val),
                //  ....
                //   )
              ),
            ),
          )
        ],
      ),
    );
  }
}

class CustomTextFieldOptional extends StatelessWidget {
  // ignore: use_key_in_widget_constructors
  const CustomTextFieldOptional({
    this.hint,
    this.label,
    this.pretext,
    this.sufText,
    this.maxLength,
    this.initialValue,
    this.icon,
    this.enabled,
    this.prefixIcon,
    this.suffixIcon,
    this.keyType,
    this.keyAction,
    this.textEditingController,
    this.onSubmited,
    this.validate,
    this.onChanged,
    this.AllowClickable = false,
    this.validatorText,
    this.onClick,
  });

  final VoidCallback? onClick;
  final bool? AllowClickable;
  final String? hint;
  final String? label;
  final String? pretext;
  final String? sufText;
  final String? initialValue;
  final int? maxLength;
  final bool? enabled;
  final Widget? icon, prefixIcon, suffixIcon;
  final TextInputType? keyType;
  final TextEditingController? textEditingController;
  final TextInputAction? keyAction;
  final ValueChanged<String>? validate;
  final ValueChanged<String>? onSubmited;
  final ValueChanged<String>? onChanged;
  final String? validatorText;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(left: 20, right: 20, top: 9),
            child: customDescriptionText(
              label!,
              colors: Colors.black,
              fontSize: 12,
            ),
          ),
          GestureDetector(
            onTap: () {
              if (AllowClickable!) onClick!();
            },
            child: Container(
              margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
              child: TextFormField(
                  autofocus: false,
                  onChanged: onChanged,
                  maxLength: maxLength,
                  controller: textEditingController,
                  enabled: enabled,
                  keyboardType: keyType,
                  textInputAction: keyAction,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return validatorText;
                    }
                    return null;
                  },
                  initialValue: initialValue,
                  decoration: InputDecoration(
                    isDense: true,
                    prefixText: pretext,
                    suffixText: sufText,
                    focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: AppColor().blackColor, width: 1),
                        borderRadius: BorderRadius.circular(10)),
                    enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: AppColor().blackColor, width: 1),
                        borderRadius: BorderRadius.circular(10)),
                    border: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: AppColor().blackColor, width: 1),
                        borderRadius: BorderRadius.circular(10)),
                    hintText: hint,
                    prefixIcon: prefixIcon,
                    suffixIcon: suffixIcon,
                    hintStyle: GoogleFonts.openSans(
                      fontSize: 14,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  onFieldSubmitted: onSubmited),
            ),
          )
        ],
      ),
    );
  }
}

class CustomTextFieldOnly extends StatelessWidget {
  // ignore: use_key_in_widget_constructors
  const CustomTextFieldOnly({
    this.hint,
    this.label,
    this.pretext,
    this.sufText,
    this.maxLength,
    this.initialValue,
    this.icon,
    this.enabled,
    this.prefixIcon,
    this.suffixIcon,
    this.keyType,
    this.keyAction,
    this.textEditingController,
    this.onSubmited,
    this.validate,
    this.onChanged,
    this.AllowClickable = false,
    this.validatorText,
    this.onClick,
  });

  final VoidCallback? onClick;
  final bool? AllowClickable;
  final String? hint;
  final String? label;
  final String? pretext;
  final String? sufText;
  final String? initialValue;
  final int? maxLength;
  final bool? enabled;
  final Widget? icon, prefixIcon, suffixIcon;
  final TextInputType? keyType;
  final TextEditingController? textEditingController;
  final TextInputAction? keyAction;
  final ValueChanged<String>? validate;
  final ValueChanged<String>? onSubmited;
  final ValueChanged<String>? onChanged;
  final String? validatorText;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
      child: TextFormField(
          autofocus: false,
          onChanged: onChanged,
          maxLength: maxLength,
          controller: textEditingController,
          enabled: enabled,
          keyboardType: keyType,
          textInputAction: keyAction,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return validatorText;
            }
            return null;
          },
          initialValue: initialValue,
          decoration: InputDecoration(
            isDense: true,
            prefixText: pretext,
            suffixText: sufText,
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppColor().blackColor, width: 1),
                borderRadius: const BorderRadius.all(Radius.circular(10))),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppColor().blackColor, width: 1),
                borderRadius: const BorderRadius.all(Radius.circular(10))),
            border: OutlineInputBorder(
                borderSide: BorderSide(color: AppColor().blackColor, width: 1),
                borderRadius: const BorderRadius.all(Radius.circular(10))),
            hintText: hint,
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            hintStyle: GoogleFonts.openSans(
              fontSize: 12,
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.normal,
            ),
          ),
          onFieldSubmitted: onSubmited),
    );
  }
}

class CustomContainer extends StatelessWidget {
  String? imgName;
  String titleText;
  VoidCallback? onTap;
  Widget? trailing;
  bool? selected;
  Color? selectedColor;
  CustomContainer({
    Key? key,
    this.imgName,
    required this.titleText,
    this.onTap,
    this.trailing,
    this.selected,
    this.selectedColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 60,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: AppColor().whiteColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: ListTile(
          selectedColor: selectedColor,
          selected: false,
          title: customTitleText(
            titleText,
            size: 14,
            colors: AppColor().textColor,
            fontWeight: FontWeight.w700,
          ),
          trailing: trailing,
        ),
      ),
    );
  }
}

class CustomContainer2 extends StatelessWidget {
  String imgName;
  String titleText;
  VoidCallback? onTap;
  Widget? trailing;
  CustomContainer2({
    Key? key,
    required this.imgName,
    required this.titleText,
    this.onTap,
    this.trailing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 60,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: AppColor().whiteColor,
          border: Border.all(width: 1, color: AppColor().blackColor),
          borderRadius: BorderRadius.circular(12),
        ),
        child: ListTile(
          leading: Image.asset(
            imgName,
            height: 26,
          ),
          title: customTitleText(
            titleText,
            size: 14,
            colors: AppColor().textColor,
          ),
          trailing: trailing,
        ),
      ),
    );
  }
}
