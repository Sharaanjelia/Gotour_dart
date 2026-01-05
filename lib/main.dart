import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'splash.dart';
import 'api_example.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Ini adalah widget utama aplikasi GoTour
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GoTour - Aplikasi Wisata',
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        final safeChild = child ?? const SizedBox.shrink();
        if (!kIsWeb) return safeChild;

        final media = MediaQuery.of(context);
        const maxPhoneWidth = 430.0;
        final frameWidth = media.size.width < maxPhoneWidth ? media.size.width : maxPhoneWidth;

        return ColoredBox(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Center(
            child: SizedBox(
              width: frameWidth,
              child: MediaQuery(
                data: media.copyWith(size: Size(frameWidth, media.size.height)),
                child: safeChild,
              ),
            ),
          ),
        );
      },
      theme: ThemeData(
        // Tema warna aplikasi
        primaryColor: Colors.blue,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      // Halaman pertama yang ditampilkan adalah Splash Screen
      home: const SplashScreen(),
      routes: {
        '/api-example': (context) => ApiExampleScreen(),
      },
    );
  }
}

// Tidak perlu MyHomePage lagi karena kita punya LoginScreen
