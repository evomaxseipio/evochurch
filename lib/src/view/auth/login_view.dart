import 'package:evochurch/src/constants/constant_index.dart';
import 'package:evochurch/src/utils/utils_index.dart';
import 'package:evochurch/src/view/auth/mobile_login_view.dart';
import 'package:evochurch/src/view/auth/widget/canvas_curve_background.dart';
import 'package:evochurch/src/view/auth/widget/login_text_form_field.dart';
import 'package:evochurch/src/view_model/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class LoginView extends HookWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Use a breakpoint that makes sense for your design
          // Typically 600 is used as the threshold between phone and tablet
          // You can adjust this value based on your needs
          if (constraints.maxWidth < 600) {
            return const MobileLoginView();
          } else {
            return const DesktopLoginLayout();
          }
        },
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
    final authService = Provider.of<AuthServices>(context, listen: false);
    final isLoading = useState(false);
    final isPasswordVisible = useState(false);

    Future<void> login() async {
      if (formKey.currentState!.validate()) {
        isLoading.value = true;
        try {
          final success = await authService.signIn(
            email: emailController.text.trim(),
            password: passwordController.text.trim(),
          );
          if (success) {
            if (!context.mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Login successful')),
            );
            context.go('/');
          } else {
            if (!context.mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(authService.errorMessage ?? 'Login failed'),
              ),
            );
          }
        } catch (e) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('An unexpected error occurred: $e')),
            );
          }
        } finally {
          isLoading.value = false;
        }
      }
    }

    return Row(
      children: [
        // Left side - Login Form
        Expanded(
          flex: 1,
          child: Container(
            color: theme.primaryColor.withOpacity(0.1),
            child: Form(
              key: formKey,
              child: Padding(
                padding: EdgeInsets.all(
                    MediaQuery.of(context).size.width < 600 ? 50 : 80.0),
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
                          border:
                              Border.all(color: theme.primaryColor, width: 2),
                        ),
                        child: Icon(
                          Icons.person_outline,
                          color: theme.primaryColor,
                          size: 60,
                        ),
                      ),
                    ),

                    EvoBox.h40,
                    // Email Field
                    LoginTextFormField(
                      textController: emailController,
                      keyboardType: TextInputType.emailAddress,
                      theme: theme,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                          return 'Please enter a valid email address';
                        }
                        if (value.length < 5) {
                          return 'Email must be at least 5 characters long';
                        }
                        return null;
                      },
                      hintText: "Email Address",
                      prefixIcon: Icon(
                        Icons.email_outlined,
                        color: theme.primaryColor,
                      ),
                      suffixIcon: null,
                    ),

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
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters long';
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
                        Icons.lock_clock_outlined,
                        color: theme.primaryColor,
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Login Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: isLoading.value ? null : login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.colorScheme.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 15),
                        ),
                        child: isLoading.value
                            ? const CircularProgressIndicator()
                            : Text(
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
                    // Remember Me and Forgot Password
                    Row(
                      children: [
                        Checkbox(
                          value: rememberMe.value,
                          onChanged: (value) => rememberMe.value = value!,
                          activeColor: theme.colorScheme.secondary,
                          checkColor: theme.colorScheme.onSecondary,
                          side: BorderSide(color: theme.colorScheme.onSurface),
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
                              color:
                                  theme.colorScheme.onSurface.withOpacity(0.7),
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
                        'Welcome Back to EvoChurch Connect!',
                        style: TextStyle(
                          color: theme.colorScheme.onSurface,
                          fontSize: Responsive.isMobile(context) ? 20 : 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '"Where Faith Meets Purposeful Management"',
                        style: TextStyle(
                          color: theme.colorScheme.onSurface,
                          fontSize: 18,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Sign in to access your church\'s hub for:\n'
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
                      const Spacer(flex: 4),
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
