import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:yc_icmc_2025/states/constants.dart';
import 'package:yc_icmc_2025/widgets/ui_color.dart';

class TextInputs {
  emailVerify(value) {
    return EmailValidator.validate(value ?? "") ? null : "Please enter a valid email";
  }

  passwordVerify(value) {
    return (value == null || value.isEmpty || value.length < 6) ? "Please enter password of at least 6 length" : null;
  }

  textVerify(value) {
    return (value == null || value.isEmpty) ? "Please enter a valid text" : null;
  }

  campusCodeVerify(value) {
    return (value == null || value.isEmpty || value.length != 5) ? "Please enter a code of length 5" : null;
  }

  Widget editingTextWidget({required Function validator, required TextEditingController controller, bool expands = false, bool enabled = true}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
      child: expands
          ? SizedBox(
              height: Constants().inputTextHeight * 7,
              child: TextFormField(
                cursorColor: UIColor().blueBlack,
                enabled: enabled,
                expands: expands,
                minLines: null,
                maxLines: null,
                autovalidateMode: AutovalidateMode.onUnfocus,
                validator: (value) => validator(value),
                controller: controller,
                style: TextStyle(color: UIColor().primaryBlue),
                textAlignVertical: TextAlignVertical.top,
              ),
            )
          : TextFormField(
              cursorColor: UIColor().blueBlack,
              enabled: enabled,
              autovalidateMode: AutovalidateMode.onUnfocus,
              validator: (value) => validator(value),
              controller: controller,
              style: TextStyle(color: UIColor().primaryBlue),
            ),
    );
  }

  Widget inputTextWidget({required String hint, required Function validator, required TextEditingController controller}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
      child: TextFormField(
        cursorColor: UIColor().blueBlack,
        autovalidateMode: AutovalidateMode.onUnfocus,
        validator: (value) => validator(value),
        controller: controller,
        style: TextStyle(color: UIColor().primaryBlue),
        decoration: InputDecoration(
          hintText: hint,
        ),
      ),
    );
  }

  Widget obscureInputTextWidget(
      {required String hint,
      required Function validator,
      required TextEditingController controller,
      required Function getFunc,
      required Function setFunc}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
      child: TextFormField(
        cursorColor: UIColor().blueBlack,
        obscureText: getFunc(),
        autovalidateMode: AutovalidateMode.onUnfocus,
        validator: (value) => validator(value),
        controller: controller,
        style: TextStyle(color: UIColor().primaryBlue),
        decoration: InputDecoration(
          suffixIcon: IconButton(
            icon: Icon(
              getFunc() ? Icons.visibility : Icons.visibility_off,
              color: UIColor().primaryBlue,
            ),
            onPressed: () {
              setFunc();
            },
          ),
          hintText: hint,
        ),
      ),
    );
  }
}
