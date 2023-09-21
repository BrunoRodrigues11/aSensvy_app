import 'package:apptesteapi/config/theme.dart';
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
