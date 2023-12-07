import 'package:aSensvy/config/email_utils.dart';
import 'package:aSensvy/config/helper_functions.dart';
import 'package:aSensvy/config/theme.dart';
import 'package:aSensvy/widgets/alerts.dart';
import 'package:aSensvy/widgets/buttons.dart';
import 'package:aSensvy/widgets/inputs.dart';
import 'package:flutter/material.dart';

class EmailValidation extends StatefulWidget {
  String email;
  EmailValidation({super.key, required this.email});

  @override
  State<EmailValidation> createState() => _EmailValidationState();
}

class _EmailValidationState extends State<EmailValidation> {
  // INSTÂNCIA DA CLASSE DE ROTAS DE TELAS
  GoToScreen goToScreen = GoToScreen();

  final emailUtils = EmailUtils();
  final _formkey = GlobalKey<FormState>();

  final _codController0 = TextEditingController();
  final _codController1 = TextEditingController();
  final _codController2 = TextEditingController();
  final _codController3 = TextEditingController();
  final _codController4 = TextEditingController();
  final _codController5 = TextEditingController();
  final _fullCode = [];

  final _firstNumberFocus = FocusNode();
  final _secondNumberFocus = FocusNode();
  final _thirdNumberFocus = FocusNode();
  final _fourthNumberFocus = FocusNode();
  final _fifthNumberFocus = FocusNode();
  final _sixthtNumberFocus = FocusNode();

  String _code = "";
  bool _validated = false;

  bool _isLoading = false;
  bool _isEnabled = true;

  @override
  void dispose() {
    _firstNumberFocus.dispose();
    _secondNumberFocus.dispose();
    _thirdNumberFocus.dispose();
    _fourthNumberFocus.dispose();
    _fifthNumberFocus.dispose();
    _sixthtNumberFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.primaryColor,
      body: _body(),
    );
  }

  _body() {
    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          color: AppColors.primaryColor,
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height,
            maxWidth: MediaQuery.of(context).size.width,
          ),
          child: Column(
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Column(
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: const Icon(
                                Icons.arrow_back_ios,
                                size: 20,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        const Text(
                          "Código de verificação",
                          style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Informe o código que foi enviado em seu email",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey[50],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                    Expanded(
                      flex: 5,
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0,
                                  3), // deslocamento horizontal e vertical da sombra
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(15),
                              child: Column(
                                children: [
                                  Image.asset(
                                    "assets/email_send.png",
                                    width: 300,
                                    height: 300,
                                  ),
                                  Form(
                                    key: _formkey,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        InputCode(
                                          context: context,
                                          focusMode: _firstNumberFocus,
                                          nextFocus: _secondNumberFocus,
                                          controller: _codController0,
                                          validated: _validated,
                                          onChanged: (p0) {},
                                        ),
                                        InputCode(
                                          context: context,
                                          focusMode: _secondNumberFocus,
                                          nextFocus: _thirdNumberFocus,
                                          controller: _codController1,
                                          validated: _validated,
                                          onChanged: (p1) {},
                                        ),
                                        InputCode(
                                          context: context,
                                          focusMode: _thirdNumberFocus,
                                          nextFocus: _fourthNumberFocus,
                                          controller: _codController2,
                                          validated: _validated,
                                          onChanged: (p2) {},
                                        ),
                                        InputCode(
                                          context: context,
                                          focusMode: _fourthNumberFocus,
                                          nextFocus: _fifthNumberFocus,
                                          controller: _codController3,
                                          validated: _validated,
                                          onChanged: (p3) {},
                                        ),
                                        InputCode(
                                          context: context,
                                          focusMode: _fifthNumberFocus,
                                          nextFocus: _sixthtNumberFocus,
                                          controller: _codController4,
                                          validated: _validated,
                                          onChanged: (p4) {},
                                        ),
                                        InputCode(
                                          context: context,
                                          focusMode: _sixthtNumberFocus,
                                          nextFocus: _sixthtNumberFocus,
                                          controller: _codController5,
                                          validated: _validated,
                                          onChanged: (p5) {},
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            BtnDefaultLoading(
                              "Validar código",
                              _isEnabled,
                              _isLoading,
                              onPressed: () {
                                _getCode();
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _getCode() {
    _fullCode.clear();
    _fullCode.add(_codController0.text);
    _fullCode.add(_codController1.text);
    _fullCode.add(_codController2.text);
    _fullCode.add(_codController3.text);
    _fullCode.add(_codController4.text);
    _fullCode.add(_codController5.text);
    _code = _fullCode.join();

    if (_code.length < 6) {
      _validated = false;
      showErrorAlert(context, 'Código inválido.');
      _fullCode.clear();
      _codController0.clear();
      _codController1.clear();
      _codController2.clear();
      _codController3.clear();
      _codController4.clear();
      _codController5.clear();
    } else {
      validar(context);
    }
  }

  void validar(BuildContext context) async {
    setState(
      () {
        _isLoading = true;
        _isEnabled = false;
      },
    );
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (_formkey.currentState!.validate()) {
      bool deuCerto = await verifyCode(context, widget.email, _code);
      if (!currentFocus.hasPrimaryFocus) {
        currentFocus.unfocus();
      }
      if (deuCerto) {
        _validated = true;
        // Aguarde um pouco antes de redirecionar para a próxima tela.
        Future.delayed(
          const Duration(seconds: 1),
          () {
            Navigator.pop(context);
            goToScreen.goToNewPswdPage(context, widget.email);
          },
        );
      } else {
        _validated = false;
        _fullCode.clear();
        _codController0.clear();
        _codController1.clear();
        _codController2.clear();
        _codController3.clear();
        _codController4.clear();
        _codController5.clear();
      }
    } else {
      showSuccessAlert(context, 'Código válido.');
      setState(
        () {
          _isLoading = false;
          _isEnabled = true;
        },
      );
    }
  }

  Future<bool> verifyCode(
      BuildContext context, String email, String code) async {
    final success = await emailUtils.doVerifyCode(email, code);
    setState(
      () {
        _isLoading = false;
        _isEnabled = true;
      },
    );
    return success;
  }
}
