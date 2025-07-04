import 'package:evochurch/src/constants/sizedbox.dart';
import 'package:evochurch/src/view/auth/widget/login_text_form_field.dart';
import 'package:evochurch/src/view_model/index_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class MobileLoginView extends HookWidget {
  const MobileLoginView({super.key});

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
                  content: Text(authService.errorMessage ?? 'Login failed')),
            );
          }
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('An unexpected error occurred: $e')),
          );
        } finally {
          isLoading.value = false;
        }
      }
    }

    return SingleChildScrollView(
      child: Form(
        key: formKey,
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
              EvoBox.h40,
              // Username Field
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
                  suffixIcon: null),
              EvoBox.h20,
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
              EvoBox.h20,

              // Loading Indicator
              if (isLoading.value)
                const Center(
                  child: CircularProgressIndicator(),
                ),
              // Error Message
              if (authService.errorMessage != null)
                Text(
                  authService.errorMessage!,
                  style: TextStyle(
                    color: theme.colorScheme.error,
                    fontSize: 14,
                  ),
                ),
              EvoBox.h20,
              // Login Button

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: login,
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
              EvoBox.h20,
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
      ),
    );
  }
}
