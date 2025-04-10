import 'dart:async';

import 'package:evochurch/src/constants/constant_index.dart';
import 'package:evochurch/src/view_model/auth_services.dart';
import 'package:evochurch/src/widgets/button/button.dart';
import 'package:evochurch/src/widgets/text/evo_custom_text_field.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  // We need to call it manually,
  // because we going to call setPreferredOrientations()
  // before the runApp() call
  WidgetsFlutterBinding.ensureInitialized();

  // Than we setup preferred orientations,
  // and only after it finished we run our app
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((value) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EvoChurch App',
      theme: FlexThemeData.light(scheme: FlexScheme.bahamaBlue), // Light theme
      darkTheme: FlexThemeData.dark(scheme: FlexScheme.bahamaBlue),
      themeMode: ThemeMode.light, // This will follow system theme
      home: const ResponsiveLoginPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class AppTheme {
  // Colors for dark theme
  static const darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: Color.fromARGB(255, 0, 103, 199), // AD Logo blue color
    onPrimary: Colors.white,
    secondary: Colors.indigoAccent,
    onSecondary: Colors.white,
    error: Color(0xFFCF6679),
    onError: Colors.black,
    surface: Color(0xFF2A2542),
    onSurface: Colors.white,
  );

  // Colors for light theme
  static const lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: Color.fromARGB(255, 0, 103, 199), // AD Logo blue color
    onPrimary: Colors.white,
    secondary: Colors.indigoAccent,
    onSecondary: Colors.white,
    error: Color(0xFFB00020),
    onError: Colors.white,
    surface: Colors.white,
    onSurface: Colors.black,
  );

  static final lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: lightColorScheme,
    fontFamily: 'Roboto',
    appBarTheme: AppBarTheme(
      backgroundColor: lightColorScheme.surface,
      foregroundColor: lightColorScheme.onSurface,
      elevation: 0,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: lightColorScheme.secondary,
        foregroundColor: lightColorScheme.onSecondary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        padding: const EdgeInsets.symmetric(vertical: 15),
      ),
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.selected)) {
          return lightColorScheme.secondary;
        }
        return Colors.transparent;
      }),
      checkColor: WidgetStateProperty.all(Colors.white),
      side: BorderSide(color: lightColorScheme.onSurface.withOpacity(0.6)),
    ),
    primaryColor: const Color.fromARGB(255, 83, 85, 223),
    primaryColorDark: const Color(0xFF3700B3),
    primaryColorLight: const Color(0xFFBB86FC),
    scaffoldBackgroundColor: Colors.white,
    cardColor: Colors.white,
    dividerColor: Colors.grey[300],
    textTheme: const TextTheme(
      headlineLarge: TextStyle(fontSize: 34, fontWeight: FontWeight.w400),
      headlineSmall: TextStyle(fontSize: 24, fontWeight: FontWeight.w400),
      titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
      titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
      bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
      bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
      labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
      labelSmall: TextStyle(fontSize: 10, fontWeight: FontWeight.w400),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey[100],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        // borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 14,
      ),
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: const Color(0xFF6200EE),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      padding: const EdgeInsets.symmetric(vertical: 16),
    ),
    // colorScheme: const ColorScheme.light(
    //   primary: Color(0xFF6200EE),
    //   primaryContainer: Color(0xFF3700B3),
    //   secondary: Color(0xFF03DAC6),
    //   secondaryContainer: Color(0xFF018786),
    //   surface: Colors.white,
    //   error: Color(0xFFB00020),
    //   onPrimary: Colors.white,
    //   onSecondary: Colors.black,
    //   onSurface: Colors.black,
    //   onError: Colors.white,
    // ).copyWith(secondary: const Color(0xFF03DAC6)),
  );

  static final darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: darkColorScheme,
    fontFamily: 'Roboto',
    brightness: Brightness.dark,
    primaryColor: const Color.fromARGB(255, 0, 103, 199),
    primaryColorDark: const Color(0xFF3700B3),
    primaryColorLight: const Color(0xFFBB86FC),
    scaffoldBackgroundColor: const Color.fromARGB(255, 44, 40, 40),
    cardColor: const Color(0xFF1E1E1E),
    dividerColor: Colors.grey[800],
    textTheme: const TextTheme(
      headlineLarge: TextStyle(fontSize: 34, fontWeight: FontWeight.w400),
      headlineMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.w400),
      headlineSmall: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
      titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
      bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
      bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
      labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
      labelSmall: TextStyle(fontSize: 10, fontWeight: FontWeight.w400),
    ),
    appBarTheme: const AppBarTheme(
      color: Color(0xFF1E1E1E),
      elevation: 0,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: darkColorScheme.secondary,
        foregroundColor: darkColorScheme.onSecondary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        padding: const EdgeInsets.symmetric(vertical: 15),
      ),
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.selected)) {
          return darkColorScheme.secondary;
        }
        return Colors.white;
      }),
      checkColor: WidgetStateProperty.all(Colors.white),
      side: BorderSide(color: darkColorScheme.onSurface.withOpacity(0.6)),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: darkColorScheme.surface,
      hintStyle: TextStyle(color: darkColorScheme.onSurface.withOpacity(0.6)),
      prefixIconColor: darkColorScheme.primary,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide.none,
      ),
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: const Color(0xFFBB86FC),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      padding: const EdgeInsets.symmetric(vertical: 16),
    ),
  );
}

class ResponsiveLoginPage extends HookWidget {
  const ResponsiveLoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 800;
          return isMobile
              ? const MobileLoginLayout()
              : const DesktopLoginLayout();
        },
      ),
    );
  }
}

class MobileLoginLayout extends HookWidget {
  const MobileLoginLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final rememberMe = useState(false);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            // Logo and App Name
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: theme.primaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.church,
                    color: theme.colorScheme.onPrimary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'EVOCHURCH APP',
                  style: TextStyle(
                    color: theme.colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 60),
            // Welcome Text for Mobile
            Text(
              'Welcome.',
              style: TextStyle(
                color: theme.colorScheme.onSurface,
                fontSize: 36,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Please login to continue using our app.',
              style: TextStyle(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 40),
            // Profile Icon
            Center(
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: theme.primaryColor, width: 2),
                ),
                child: Icon(
                  Icons.person_outline,
                  color: theme.primaryColor,
                  size: 60,
                ),
              ),
            ),
            const SizedBox(height: 40),
            // Username Field
            TextField(
              controller: emailController,
              style: TextStyle(color: theme.colorScheme.onSurface),
              decoration: InputDecoration(
                hintText: 'Username',
                hintStyle: TextStyle(color: theme.hintColor),
                prefixIcon: Icon(Icons.person, color: theme.primaryColor),
                filled: true,
                fillColor: theme.cardColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Password Field
            TextField(
              controller: passwordController,
              obscureText: true,
              style: TextStyle(color: theme.colorScheme.onSurface),
              decoration: InputDecoration(
                hintText: 'Password',
                hintStyle: TextStyle(color: theme.hintColor),
                prefixIcon: Icon(Icons.lock, color: theme.primaryColor),
                filled: true,
                fillColor: theme.cardColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Login Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.secondary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: Text(
                  'LOGIN',
                  style: TextStyle(
                    color: theme.colorScheme.onSecondary,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Remember Me and Forgot Password
            Row(
              children: [
                Checkbox(
                  value: rememberMe.value,
                  onChanged: (value) => rememberMe.value = value!,
                  activeColor: theme.colorScheme.secondary,
                  checkColor: theme.colorScheme.onSecondary,
                  side: BorderSide(color: theme.dividerColor!),
                ),
                Text(
                  'Remember me',
                  style: TextStyle(
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                    fontSize: 12,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'Forgot password?',
                    style: TextStyle(
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            // Sign Up Link
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Not a member?',
                    style: TextStyle(
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                      fontSize: 14,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'Sign up here',
                      style: TextStyle(
                        color: theme.primaryColor,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DesktopLoginLayout extends HookWidget {
  const DesktopLoginLayout({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final rememberMe = useState(false);

    final formKey = useMemoized(() => GlobalKey<FormState>());
    // final authService = Provider.of<AuthServices>(context, listen: false);
    final isLoading = useState(false);
    final isPasswordVisible = useState(false);

    final _redirecting = useState(false);
    late final StreamSubscription<AuthState> _authStateSubscription;

    Future<void> login() async {
      // if (formKey.currentState!.validate()) {
      //   isLoading.value = true;
      //   try {
      //     final success = await authService.signIn(
      //       email: emailController.text.trim(),
      //       password: passwordController.text.trim(),
      //     );
      //     if (success) {
      //       if (!context.mounted) return;
      //       ScaffoldMessenger.of(context).showSnackBar(
      //         const SnackBar(content: Text('Login successful')),
      //       );
      //       context.go('/');
      //     } else {
      //       if (!context.mounted) return;
      //       ScaffoldMessenger.of(context).showSnackBar(
      //         SnackBar(
      //             content: Text(authService.errorMessage ?? 'Login failed')),
      //       );
      //     }
      //   } catch (e) {
      //     ScaffoldMessenger.of(context).showSnackBar(
      //       SnackBar(content: Text('An unexpected error occurred: $e')),
      //     );
      //   } finally {
      //     isLoading.value = false;
      //   }
      // }
    }

    return Row(
      children: [
        // Left side - Login Form
        Expanded(
          flex: 1,
          child: Container(
            color: theme.primaryColor.withOpacity(0.1),
            width: MediaQuery.of(context).size.width * 0.3,
            height: MediaQuery.of(context).size.height,
            child: Form(
              key: formKey,
              child: Padding(
                padding: const EdgeInsets.all(80.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Logo and App Name
                    Row(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: theme.primaryColor,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.church,
                            color: theme.colorScheme.onPrimary,
                            size: 38,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'EVOCHURCH APP',
                          style: TextStyle(
                            color: theme.colorScheme.onSurface,
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    // Profile Icon
                    Center(
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: theme.primaryColor, width: 2),
                        ),
                        child: Icon(
                          Icons.person_outline,
                          color: theme.primaryColor,
                          size: 60,
                        ),
                      ),
                    ),
              
                    EvoBox.h40,
                    // // Username Field
                    LoginTextFormField(
                        textController: emailController,
                        theme: theme,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          return null;
                        },
                        hintText: "Email Address",
                        prefixIcon: Icon(
                          Icons.person,
                          color: theme.primaryColor,
                        ),
                        suffixIcon: null),
              
                    const SizedBox(height: 20),
                    // Password Field
                    LoginTextFormField(
                      textController: passwordController,
                      theme: theme,
                      isPasswordVisible: !isPasswordVisible.value,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                      hintText: "Password",
                      suffixIcon: IconButton(
                        icon: Icon(
                          isPasswordVisible.value
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () =>
                            isPasswordVisible.value = !isPasswordVisible.value,
                      ),
                      prefixIcon: Icon(
                        Icons.lock,
                        color: theme.primaryColor,
                      ),
                    ),
              
                    const SizedBox(height: 30),
              
                    // Login Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.colorScheme.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 15),
                        ),
                        child: Text(
                          'LOGIN',
                          style: TextStyle(
                            color: theme.colorScheme.onSecondary,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    // // Remember Me and Forgot Password
                    Row(
                      children: [
                        Checkbox(
                          value: rememberMe.value,
                          onChanged: (value) => rememberMe.value = value!,
                          activeColor: theme.colorScheme.secondary,
                          checkColor: theme.colorScheme.onSecondary,
                          side: BorderSide(color: theme.colorScheme.onSurface),
              
                          // side: BorderSide(color: theme.dividerColor!),
                        ),
                        Text(
                          'Remember me',
                          style: TextStyle(
                            color: theme.colorScheme.onSurface.withOpacity(0.7),
                            fontSize: 14,
                          ),
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            'Forgot your password?',
                            style: TextStyle(
                              color: theme.colorScheme.onSurface.withOpacity(0.7),
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            ),
          ),
        ),
        // Right side - Welcome Content
        Expanded(
          flex: 2,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  theme.scaffoldBackgroundColor,
                  theme.primaryColor.withOpacity(0.6),
                  theme.colorScheme.secondary.withOpacity(0.4),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Stack(
              children: [
                // Curved purple-blue wave graphic
                CustomPaint(
                  size: Size.infinite,
                  painter: WavePainter(theme: theme),
                ),
                // Welcome Text Column
                Padding(
                  padding: const EdgeInsets.all(40.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Spacer(flex: 2),
                      Text(
                        'Welcome Back to EvoChurch Connect!.',
                        style: TextStyle(
                          color: theme.colorScheme.onSurface,
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '"Where Faith Meets Purposeful Management".',
                        // textAlign: TextAlign.end,
                        style: TextStyle(
                          color: theme.colorScheme.onSurface,
                          fontSize: 18,
                          fontStyle: FontStyle.italic,
                          // fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Sign in to access your church’s hub for:\n'
                        '    - Members & Visitors\n'
                        '    - Donations & Tithes\n'
                        '    - Ministries & Volunteers\n'
                        '    - Discipleship & Growth\n'
                        '    - Secure Transactions\n'
                        '    - And more!\n',
                        style: TextStyle(
                          color: theme.colorScheme.onSurface.withOpacity(0.7),
                          fontSize: 16,
                        ),
                      ),
                      const Spacer(
                        flex: 4,
                      ),
                      const Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          '"For we aim at what is honorable, not only in the Lord\'s sight but also in the sight of man."\n'
                          '2 Corinthians 8:21',
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            fontSize: 16,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),

//     Members & Visitors – Shepherd your flock with care.

//     Donations & Tithes – Manage gifts with integrity.

//     Ministries & Volunteers – Empower service effortlessly.

//     Discipleship & Growth – Track spiritual journeys.

//     Secure Transactions – Handle finances confidently.

// Need help? Contact [support@evochurch.org] or pray with our team.

// (Note: Ensure your password is strong and kept confidential.)',
//                         style: TextStyle(
//                           color: theme.colorScheme.onSurface.withOpacity(0.7),
//                           fontSize: 16,
//                         ),
//                       ),

                      const Spacer(flex: 2),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class LoginTextFormField extends StatelessWidget {
  const LoginTextFormField(
      {super.key,
      // required this.formKey,
      required this.textController,
      required this.theme,
      required this.validator,
      required this.hintText,
      required this.prefixIcon,
      this.suffixIcon,
      this.isPasswordVisible});

  final TextEditingController textController;
  final ThemeData theme;
  final String? Function(String?)? validator;
  final String hintText;
  final Widget prefixIcon;
  final Widget? suffixIcon;
  final bool? isPasswordVisible;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: textController,
      style: TextStyle(color: theme.colorScheme.onSurface),
      validator: validator,
      obscureText: isPasswordVisible ?? false,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: theme.hintColor),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: theme.cardColor,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: theme.brightness == Brightness.dark
                ? Colors.white.withOpacity(0.8)
                : Colors.black.withOpacity(0.8),
            width: 1.5,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: theme.brightness == Brightness.dark
                ? Colors.white.withOpacity(0.8)
                : Colors.black.withOpacity(0.8),
            width: 1.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: theme.primaryColor, // Use theme primary color for focus
            width: 2.0,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.red, width: 2.0),
        ),
      ),
    );
  }
}

// CustomPainter for the wave effect
class WavePainter extends CustomPainter {
  final ThemeData theme;

  WavePainter({required this.theme});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(
        colors: [
          theme.colorScheme.secondary.withOpacity(0.6),
          theme.primaryColor.withOpacity(0.1),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(size.width * 0.3, size.height * 0.4);
    path.quadraticBezierTo(
      size.width * 0.5,
      size.height * 0.2,
      size.width * 0.7,
      size.height * 0.5,
    );
    path.quadraticBezierTo(
      size.width * 0.85,
      size.height * 0.7,
      size.width,
      size.height * 0.6,
    );
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.lineTo(0, size.height * 0.8);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
