import 'package:flutter/material.dart';

class CustomTextFormField extends StatefulWidget {
  final bool autovalidate;
  final bool autofocus;
  final TextInputType keyboardType;
  final FormFieldSetter<String> onSaved;
  final ValueChanged<String> onFieldSubmitted;
  final FormFieldValidator<String> validator;
  final IconData icon;
  final String labelText;
  final TextInputAction textInputAction;
  final bool obscureText;
  final FocusNode focusNode;

  CustomTextFormField(
      {this.onSaved,
      this.textInputAction,
      this.keyboardType,
      this.focusNode,
      this.obscureText = false,
      this.autovalidate = false,
      this.autofocus = false,
      this.onFieldSubmitted,
      this.labelText,
      this.icon,
      this.validator})
      : assert(autofocus != null),
        assert(obscureText != null),
        assert(autovalidate != null);

  @override
  _CustomTextFormFieldState createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofocus: true,
      onSaved: widget.onSaved,
      validator: widget.validator,
      decoration: InputDecoration(
        focusedBorder:
            UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
        enabledBorder:
            UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
        fillColor: Colors.white,
        prefixIcon: Icon(
          widget.icon,
          color: Colors.white,
        ),
        labelText: widget.labelText,
        labelStyle: TextStyle(color: Colors.white, fontSize: 14),
      ),
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      onFieldSubmitted: widget.onFieldSubmitted,
      style: TextStyle(color: Colors.white),
    );
  }
}
