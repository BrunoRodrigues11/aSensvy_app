import 'package:aSensvy/config/theme.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';

void showErrorAlert(BuildContext context, String message) {
  QuickAlert.show(
    context: context,
    type: QuickAlertType.error,
    title: "Oops...",
    text: message,
    confirmBtnColor: AppColors.primaryColor,
  );
}

void showSuccessAlert(BuildContext context, String message) {
  QuickAlert.show(
    context: context,
    type: QuickAlertType.success,
    title: "Sucesso!",
    text: message,
    confirmBtnColor: AppColors.primaryColor,
  );
}

void showInfoAlert(BuildContext context, String message) {
  QuickAlert.show(
    context: context,
    type: QuickAlertType.info,
    title: "Aviso!",
    text: message,
    confirmBtnColor: AppColors.primaryColor,
  );
}

void showAlert(
    BuildContext context, QuickAlertType type, String title, String message) {
  QuickAlert.show(
    context: context,
    type: type,
    title: title,
    text: message,
    confirmBtnColor: AppColors.primaryColor,
  );
}

void showSuccessAlertBtn(
    BuildContext context, String message, Function onBtnOkPress) {
  QuickAlert.show(
      context: context,
      type: QuickAlertType.success,
      title: "Sucesso!",
      text: message,
      confirmBtnColor: AppColors.primaryColor,
      onConfirmBtnTap: onBtnOkPress());
}

void showConfirmAlertBtn(BuildContext context, String message,
    Function onBtnOkPress, Function onBtnCancelPress) {
  QuickAlert.show(
    context: context,
    type: QuickAlertType.confirm,
    text: message,
    confirmBtnText: 'Sim',
    onConfirmBtnTap: onBtnOkPress(),
    cancelBtnText: 'Não',
    onCancelBtnTap: onBtnCancelPress(),
    confirmBtnColor: Colors.green,
  );
}
