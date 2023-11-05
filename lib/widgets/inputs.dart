import 'package:aSensvy/config/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputDefault extends StatelessWidget {
  // label, obscureText = false, validator, controller, keyboardType, hint
  String label;
  bool enabled = true;
  String? Function(String?) validator;
  TextInputType keyboardType;
  String hint;
  Icon icon;
  List<TextInputFormatter>? inputFormatters;
  TextEditingController controller;

  InputDefault(this.label, this.keyboardType, this.icon, this.hint,
      this.inputFormatters, this.enabled,
      {super.key, required this.validator, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: const TextStyle(
              fontSize: 15, fontWeight: FontWeight.w400, color: Colors.black),
        ),
        const SizedBox(
          height: 5,
        ),
        TextFormField(
          validator: validator,
          keyboardType: keyboardType,
          controller: controller,
          inputFormatters: inputFormatters,
          enabled: enabled,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: icon,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: const BorderSide(color: AppColors.primaryColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: const BorderSide(color: AppColors.primaryColor),
            ),
            focusColor: AppColors.primaryColor,
          ),
        ),
        const SizedBox(
          height: 5,
        ),
      ],
    );
  }
}

class InputPassword extends StatefulWidget {
  // label, obscureText = false, validator, controller, keyboardType, hint
  String label;
  bool enabled = true;
  String? Function(String?) validator;
  TextInputType keyboardType;
  String hint;
  Icon icon;

  TextEditingController controller;

  InputPassword(
      this.label, this.keyboardType, this.icon, this.hint, this.enabled,
      {super.key, required this.validator, required this.controller});

  @override
  State<InputPassword> createState() => _InputPasswordState();
}

class _InputPasswordState extends State<InputPassword> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          widget.label,
          style: const TextStyle(
              fontSize: 15, fontWeight: FontWeight.w400, color: Colors.black),
        ),
        const SizedBox(
          height: 5,
        ),
        TextFormField(
          validator: widget.validator,
          keyboardType: widget.keyboardType,
          controller: widget.controller,
          obscureText: _obscureText,
          enabled: widget.enabled,
          decoration: InputDecoration(
            hintText: widget.hint,
            prefixIcon: widget.icon,
            suffixIcon: IconButton(
              icon: Icon(
                _obscureText ? Icons.visibility : Icons.visibility_off,
                color: _obscureText ? Colors.grey : AppColors.primaryColor,
              ),
              onPressed: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
            ),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: const BorderSide(color: AppColors.primaryColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: const BorderSide(color: AppColors.primaryColor),
            ),
            focusColor: AppColors.primaryColor,
          ),
        ),
        const SizedBox(
          height: 5,
        ),
      ],
    );
  }
}

class InputCode extends StatelessWidget {
  TextEditingController controller;

  InputCode({super.key, required this.controller});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 68,
      width: 50,
      child: TextFormField(
        validator: (code) {
          if (code == null || code.isEmpty) {
            return "Por favor, informe sua senha";
          }
          return null;
        },
        keyboardType: TextInputType.number,
        controller: controller,
        textAlign: TextAlign.center,
        inputFormatters: [
          LengthLimitingTextInputFormatter(1),
          FilteringTextInputFormatter.digitsOnly,
        ],
        decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: const BorderSide(color: AppColors.primaryColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: const BorderSide(color: AppColors.primaryColor),
            ),
            focusColor: AppColors.primaryColor),
      ),
    );
  }
}
