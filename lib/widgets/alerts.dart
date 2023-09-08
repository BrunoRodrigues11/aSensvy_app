import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';

void showErrorAlert(BuildContext context, String message) {
  QuickAlert.show(
    context: context,
    type: QuickAlertType.error,
    title: "Oops...",
    text: message,
  );
}

void showSuccessAlert(BuildContext context, String message) {
  QuickAlert.show(
    context: context,
    type: QuickAlertType.success,
    title: "Sucesso!",
    text: message,
  );
}

void showAlert(BuildContext context, QuickAlertType type, String title, String message) {
  QuickAlert.show(
    context: context,
    type: type,
    title: title,
    text: message,
  );
}
