// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

PopupMenuItem<String> createItem(
    String label, IconData icon, Color iconColor, Function handleOnTap) {
  return PopupMenuItem<String>(
    onTap: () {
      handleOnTap();
    },
    value: label,
    child: Row(children: [
      Icon(
        icon,
        color: iconColor,
      ),
      addPadding(5),
      addLabel(
          text: label,
          fontSize: 15,
          fontWeight: FontWeight.w600,
          fontColor: Colors.black87),
    ]),
  );
}

SizedBox addBigButton(
    {required double maxWidth,
    required double maxHeight,
    required String text,
    required IconData icon,
    required double fontSize,
    required Color bgColor,
    required Function handleOnPress}) {
  return SizedBox(
    width: maxWidth,
    height: maxHeight,
    child: ElevatedButton(
      onPressed: () {
        handleOnPress();
      },
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        backgroundColor: bgColor,
      ),
      child: maxWidth <= 160.0
          ? Icon(
              icon,
              size: 50,
              color: Colors.white70,
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 50,
                  color: Colors.white70,
                ),
                addPadding(5),
                addLabel(
                    text: text,
                    fontSize: fontSize,
                    fontWeight: FontWeight.w700,
                    fontColor: Colors.white),
                // addLabel(text, fontSize, FontWeight.w700, Colors.white)
              ],
            ),
    ),
  );
}

Container getTitle(
    {required String title,
    required double fontSize,
    required FontWeight fontWeight,
    required double maxWidth,
    required double maxHeight,
    double? borderRadius = 15}) {
  return Container(
    width: double.infinity,
    height: 55,
    padding: EdgeInsets.only(top: (maxWidth * .5) * .02, left: 10),
    alignment: Alignment.center,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(borderRadius!),
        topRight: Radius.circular(borderRadius),
      ),
      color: const Color(0xFF9DB2BE),
    ),
    child: addLabel(
        text: title,
        fontSize: fontSize,
        fontWeight: fontWeight,
        alignment: TextAlign.center,
        fontColor: Colors.white),
  );
}

Container addStringDropdown(
    {required double maxWidth,
    double maxHeight = 50,
    String labelText = "",
    required String? value,
    required List<String> listValues,
    required Function(String) handleOnSelect,
    double? borderRadius = 5,
    Color? borderColor = Colors.blueAccent,
    Color? backgroundColor = Colors.white}) {
  return Container(
    width: maxWidth,
    height: maxHeight,
    decoration: BoxDecoration(
        border: Border.all(color: borderColor!),
        borderRadius: BorderRadius.all(
          Radius.circular(borderRadius!),
        ),
        color: backgroundColor),
    child: DropdownButton(
      hint: Text(
        "  $labelText",
        style: const TextStyle(color: Colors.black),
      ),
      menuMaxHeight: 300,
      // iconSize: 40,
      iconDisabledColor: Colors.black38,
      iconEnabledColor: Colors.black38,
      underline: const Text(""),
      borderRadius: const BorderRadius.all(
        Radius.circular(10),
      ),
      style: const TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: 15,
        color: Colors.black87,
      ),
      onTap: () {},
      isExpanded: true,
      value: value,
      items: listValues.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            " $value",
            style: const TextStyle(color: Colors.black87),
          ),
        );
      }).toList(),
      onChanged: (value) {
        handleOnSelect("$value");
      },
    ),
  );
}

SizedBox addSuffixedTextField({
  String? labelText = "",
  String? hintText = "",
  Color? labelTextColor = Colors.black,
  Color? backgroundColor = Colors.white,
  required double maxWidth,
  double maxHeight = 50,
  required TextEditingController controller,
  required IconData icon,
  required Function handleButtonClicked,
  bool? readOnly = false,
  bool? obscureText = false,
  double? borderRadius = 5,
  Color? borderColor = Colors.blueAccent,
  Function? handleOnChange,
}) {
  return SizedBox(
    width: maxWidth,
    height: maxHeight,
    child: TextFormField(
      // onTap: () {
      //   handleButtonClicked();
      // },
      onChanged: (value) {
        handleOnChange?.call(value);
      },
      obscureText: obscureText!,
      readOnly: readOnly!,
      controller: controller,
      decoration: InputDecoration(
          filled: true,
          fillColor: backgroundColor,
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 1, color: borderColor!),
            borderRadius: BorderRadius.circular(borderRadius!),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 1, color: borderColor),
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          labelText: labelText,
          hintText: hintText,
          labelStyle:
              TextStyle(letterSpacing: 2, fontSize: 15, color: labelTextColor),
          suffixIcon: IconButton(
            icon: Icon(
              icon,
              color: borderColor,
            ),
            onPressed: () {
              handleButtonClicked();
            },
          )),
    ),
  );
}

SizedBox addTextField({
  String? labelText = "",
  required double maxWidth,
  Color? backgroundColor = Colors.white,
  double maxHeight = 50,
  required TextEditingController controller,
  bool? readOnly = false,
  Function? handleOnTap,
  Function? handleOnComplete,
  Function(String changedValue)? handleOnChange,
  bool? obscureText = false,
  Color? labelTextColor = Colors.black87,
  Color? borderColor = Colors.blueAccent,
  Color? inputTextColor = Colors.black87,
  double? borderRadius = 5,
  FocusNode? focusNode,
  int? maxLines = 1,
}) {
  return SizedBox(
    width: maxWidth,
    height: maxHeight,
    child: TextFormField(
      maxLines: maxLines,
      focusNode: focusNode,
      controller: controller,
      readOnly: readOnly!,
      obscureText: obscureText!,
      onEditingComplete: () {
        handleOnComplete?.call();
      },
      onTap: () {
        handleOnTap?.call();
      },
      onChanged: (value) {
        handleOnChange?.call(value);
      },
      style: TextStyle(color: inputTextColor, fontSize: 15),
      decoration: InputDecoration(
        fillColor: backgroundColor,
        filled: true,
        // label: Text(labelText!),
        labelText: labelText,
        // hintText: labelText,
        contentPadding: const EdgeInsets.all(5),
        labelStyle:
            TextStyle(letterSpacing: 2, fontSize: 15, color: labelTextColor),
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: borderColor!),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 1, color: borderColor),
          borderRadius: BorderRadius.circular(borderRadius!),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 1, color: borderColor),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    ),
  );
}

SizedBox addNumberTextField({
  String? labelText = "",
  required double maxWidth,
  double maxHeight = 50,
  required TextEditingController controller,
  bool? readOnly = false,
  Function? handleOnTap,
  Color? backgroundColor = Colors.white,
  Function? handleOnComplete,
  Function(String)? handleOnChange,
  bool? obscureText = false,
  Color? labelTextColor = Colors.black,
  Color? borderColor = Colors.black,
  Color? inputTextColor = Colors.black,
  double? borderRadius = 10,
}) {
  return SizedBox(
    width: maxWidth,
    height: maxHeight,
    child: TextFormField(
      controller: controller,
      readOnly: readOnly!,
      onChanged: (value) {
        handleOnChange?.call(value);
      },
      onEditingComplete: () {
        handleOnComplete?.call();
      },
      onTap: () {
        handleOnTap?.call();
      },
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
        // You can add more formatters if needed
      ],
      style: TextStyle(color: inputTextColor, fontSize: 15),
      decoration: InputDecoration(
        fillColor: backgroundColor,
        labelText: labelText,
        filled: true,
        contentPadding: const EdgeInsets.all(5),
        labelStyle:
            TextStyle(letterSpacing: 2, fontSize: 15, color: labelTextColor),
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: borderColor ?? Colors.black),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 1, color: borderColor!),
          borderRadius: BorderRadius.circular(borderRadius!),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 1, color: borderColor),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    ),
  );
}

SizedBox addCircularButton(
    {required double maxWidth,
    double maxHeight = 50,
    required String text,
    required double fontSize,
    required FontWeight fontWeight,
    required Color bgColor,
    required Function handleOnPress}) {
  return SizedBox(
    width: maxWidth,
    height: maxHeight,
    child: ElevatedButton(
      style: ButtonStyle(
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(maxHeight),
            ),
          ),
          backgroundColor: WidgetStatePropertyAll(bgColor),
          iconSize: WidgetStatePropertyAll(maxWidth * .13)),
      child: addLabel(
          text: text,
          fontSize: fontSize,
          fontWeight: fontWeight,
          alignment: TextAlign.center,
          fontColor: Colors.white),
      onPressed: () {
        handleOnPress();
      },
    ),
  );
}

SizedBox addElevatedTextButton(
    {required double maxWidth,
    required double maxHeight,
    required String text,
    required double fontSize,
    required FontWeight fontWeight,
    required Color bgColor,
    bool? isLoading = false,
    Color? fontColor = Colors.white,
    double? borderRadius = 5,
    required Function handleOnPress}) {
  return SizedBox(
    width: maxWidth,
    height: maxHeight,
    child: ElevatedButton(
      style: ButtonStyle(
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius!),
            ),
          ),
          backgroundColor: WidgetStatePropertyAll(bgColor),
          iconSize: WidgetStatePropertyAll(maxWidth * .13)),
      child: !isLoading!
          ? addLabel(
              text: text,
              fontSize: fontSize,
              fontWeight: fontWeight,
              alignment: TextAlign.center,
              fontColor: fontColor!)
          : const CircularProgressIndicator(
              color: Colors.white,
            ),
      onPressed: () {
        if (!isLoading) {
          handleOnPress();
        }
      },
    ),
  );
}

SizedBox addTextButton(
    {required double maxWidth,
    required double maxHeight,
    required String text,
    required double fontSize,
    required FontWeight fontWeight,
    required Color bgColor,
    Color? fontColor = Colors.white,
    required Function handleOnPress}) {
  return SizedBox(
    width: maxWidth,
    height: maxHeight,
    child: TextButton(
      style: ButtonStyle(
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
          ),
          backgroundColor: WidgetStatePropertyAll(bgColor),
          iconSize: WidgetStatePropertyAll(maxWidth * .13)),
      child: addLabel(
          text: text,
          fontSize: fontSize,
          fontWeight: fontWeight,
          alignment: TextAlign.center,
          fontColor: fontColor!),
      onPressed: () {
        handleOnPress();
      },
    ),
  );
}

Text addSpacedLabel(
    {required String text,
    required double fontSize,
    required FontWeight fontWeight,
    required TextAlign alignment,
    required Color fontColor}) {
  return Text(
    text,
    textAlign: alignment,
    style: TextStyle(
      letterSpacing: 2.0,
      fontWeight: fontWeight,
      fontSize: fontSize,
      color: fontColor,
    ),
  );
}

Text addLabel(
    {required String text,
    required double fontSize,
    required FontWeight fontWeight,
    TextAlign alignment = TextAlign.center,
    required Color fontColor}) {
  return Text(
    text,
    textAlign: alignment,
    style: TextStyle(
        fontWeight: fontWeight,
        fontSize: fontSize,
        color: fontColor,
        height: 0),
  );
}

Padding addPadding(double value) {
  return Padding(padding: EdgeInsets.all(value));
}
