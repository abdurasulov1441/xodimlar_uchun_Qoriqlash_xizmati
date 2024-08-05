import 'package:another_flutter_splash_screen/another_flutter_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

import 'package:http/http.dart' as http;
import 'package:xodimlar_uchun/back/api/appConfig.dart';
import 'package:xodimlar_uchun/back/api/login/login_page.dart';
import 'package:xodimlar_uchun/front/components/app_data_provider.dart';
import 'package:xodimlar_uchun/front/pages/pult_boshligi_pages/pult_boshligi_home.dart';
import 'dart:convert';

import 'package:xodimlar_uchun/front/style/app_style.dart';

class QoriqlashXizmatiApp extends StatelessWidget {
  const QoriqlashXizmatiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AppDataProvider()),
      ],
      child: Consumer<AppDataProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: themeProvider.currentTheme,
            routes: {
              '/': (context) => const SplashScreenWidget(),
            },
            initialRoute: '/',
          );
        },
      ),
    );
  }
}

class SplashScreenWidget extends StatelessWidget {
  const SplashScreenWidget({super.key});

  Future<Widget> determineNextScreen() async {
    final storage = FlutterSecureStorage();

    // Получение токена доступа и токена обновления из безопасного хранилища
    String? accessToken = await storage.read(key: 'accessToken');
    String? refreshToken = await storage.read(key: 'refreshToken');

    if (accessToken != null) {
      // Проверка статуса пользователя с помощью токена доступа
      final response = await http.get(
        Uri.parse('${AppConfig.serverAddress}/api/v1/user/status'),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        // Токен доступа действителен
        return PultBoshligiHome();
      } else if (response.statusCode == 401 && refreshToken != null) {
        // Токен доступа истек, пробуем обновить токен
        return await _refreshTokenAndRetry(refreshToken, storage);
      }
    }

    // В случае ошибки или отсутствия токенов перенаправляем на экран входа
    return LoginScreen();
  }

  Future<Widget> _refreshTokenAndRetry(
      String refreshToken, FlutterSecureStorage storage) async {
    // Запрос на обновление токена
    final refreshResponse = await http.post(
      Uri.parse('${AppConfig.serverAddress}/api/v1/auth/refresh'),
      body: jsonEncode({'refreshToken': refreshToken}),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (refreshResponse.statusCode == 200) {
      // Токен обновлён успешно, сохраняем новый токен доступа
      final newAccessToken = jsonDecode(refreshResponse.body)['accessToken'];
      await storage.write(key: 'accessToken', value: newAccessToken);

      // Повторяем проверку статуса пользователя с новым токеном доступа
      final retryResponse = await http.get(
        Uri.parse('${AppConfig.serverAddress}/api/v1/user/status'),
        headers: {
          'Authorization': 'Bearer $newAccessToken',
        },
      );

      if (retryResponse.statusCode == 200) {
        return PultBoshligiHome();
      }
    }

    // В случае неудачи при обновлении токена или повторной проверке
    return LoginScreen();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      future: determineNextScreen(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text('Erraaaor: ${snapshot.error}'),
            ),
          );
        } else {
          return FlutterSplashScreen.fadeIn(
            backgroundColor: Colors.white,
            duration: const Duration(seconds: 3),
            childWidget: const SplashScreenContent(),
            nextScreen: snapshot.data!,
          );
        }
      },
    );
  }
}

class SplashScreenContent extends StatelessWidget {
  const SplashScreenContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/set.png',
            width: 200,
            height: 200,
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Qo\'riqlash',
                style: AppStyle.fontStyle.copyWith(fontSize: 20),
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                'Xizmati',
                style: AppStyle.fontStyle.copyWith(fontSize: 20),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
