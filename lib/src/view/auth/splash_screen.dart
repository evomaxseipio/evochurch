
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  final ValueNotifier<bool> isAuth;
  const SplashScreen({super.key, required this.isAuth});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 5), () {
      if (widget.isAuth.value) {
        context.go('/home');
      } else {
        context.go('/login');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // const Image(
            //   height: 200,
            //   width: 200,
            //   fit: BoxFit.fitWidth,
            //   image: AssetImage(lbcLogoTransparente),
            // ),
            const SizedBox(height: 20),
            Text(
              'LBC',
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            Text(
              'Liga de Baloncesto Cristiana',
              style: TextStyle(
                fontSize: 18,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
