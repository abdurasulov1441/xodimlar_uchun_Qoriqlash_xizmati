import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:xodimlar_uchun/back/api/appConfig.dart';
import 'package:xodimlar_uchun/front/components/snack_bar.dart';
import 'package:xodimlar_uchun/front/pages/pult_boshligi_pages/pult_boshligi_home.dart';
import 'package:xodimlar_uchun/front/style/app_colors.dart';
import 'package:xodimlar_uchun/front/style/app_style.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isHiddenPassword = true;
  TextEditingController emailTextInputController = TextEditingController();
  TextEditingController passwordTextInputController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailTextInputController.dispose();
    passwordTextInputController.dispose();
    super.dispose();
  }

  void togglePasswordView() {
    setState(() {
      isHiddenPassword = !isHiddenPassword;
    });
  }

  Future<void> login() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;
    final url = Uri.parse('${AppConfig.serverAddress}/api/v1/auth/login');
    final headers = {"Content-Type": "application/json"};
    final body = jsonEncode({
      "password": passwordTextInputController.text,
      "phone_number": emailTextInputController.text
    });

    // Create an instance of FlutterSecureStorage
    final storage = FlutterSecureStorage();

    try {
      final response = await http.post(url, headers: headers, body: body);
      final responseBody = jsonDecode(response.body);
      print(responseBody['status_code']);

      if (responseBody['status_code'] == 200) {
        final accessToken = responseBody['data']['access_token'];
        final refreshToken = responseBody['data']['refresh_token'];

        // Store the tokens in secure storage
        await storage.write(key: 'accessToken', value: accessToken);
        await storage.write(key: 'refreshToken', value: refreshToken);

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PultBoshligiHome()),
        );
      } else {
        SnackBarService.showSnackBar(
          context,
          responseBody['detail'],
          true,
        );
      }
    } catch (e) {
      SnackBarService.showSnackBar(
        context,
        'Error occurred: $e',
        true,
      );
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackgroundColor,
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(height: 50),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Xush kelibsiz !',
                      style: AppStyle.fontStyle.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Tizimga kirishingiz mumkin',
                      style: AppStyle.fontStyle.copyWith(
                        color: AppColors.lightDividerColor,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Image.asset(
                      'assets/images/set.png',
                      width: 100,
                      height: 100,
                    ),
                    Text(
                      'Qo\'riqlash Xizmati'.toUpperCase(),
                      style: AppStyle.fontStyle.copyWith(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Text(
                          'Telefon raqam',
                          style: AppStyle.fontStyle.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    TextFormField(
                      // style: TextStyle(color: AppColors.lightTextColor),
                      keyboardType: TextInputType.phone,
                      autocorrect: false,
                      controller: emailTextInputController,
                      decoration: InputDecoration(
                        fillColor: AppColors.fillColor,
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                        hintText: '+998901234567',
                        hintStyle: AppStyle.fontStyle,
                        label: Icon(
                          Icons.phone,
                          color: AppColors.lightIconGuardColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Row(
                      children: [
                        Text(
                          'Parol',
                          style: AppStyle.fontStyle.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    TextFormField(
                      // style:
                      //     const TextStyle(color: AppColors.lightDividerColor),
                      autocorrect: false,
                      controller: passwordTextInputController,
                      obscureText: isHiddenPassword,
                      validator: (value) => value != null && value.length < 6
                          ? 'Минимум 6 символов'
                          : null,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: InputDecoration(
                        fillColor: AppColors.fillColor,
                        filled: true,
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                        hintText: 'Parolingizni kiriting',
                        hintStyle: AppStyle.fontStyle,
                        label: const Icon(
                          Icons.lock,
                          color: AppColors.lightIconGuardColor,
                        ),
                        suffix: InkWell(
                          onTap: togglePasswordView,
                          child: Icon(
                            isHiddenPassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        backgroundColor: AppColors.lightIconGuardColor,
                      ),
                      onPressed: login,
                      child: Center(
                        child: Text(
                          'Kirish',
                          style: AppStyle.fontStyle.copyWith(
                            color: AppColors.lightBackgroundColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 250,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
