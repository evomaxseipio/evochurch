
import 'package:evochurch/src/constants/constant_index.dart';
import 'package:evochurch/src/utils/utils_index.dart';
import 'package:evochurch/src/view_model/auth_services.dart';
import 'package:evochurch/src/widgets/button/button.dart';
import 'package:evochurch/src/widgets/text/evo_custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class LoginView extends HookWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final authService = Provider.of<AuthServices>(context, listen: false);
    final isLoading = useState(false);
    final isPasswordVisible = useState(false);
    final rememberMe = useState(false);


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

    return Scaffold(
      // backgroundColor: EvoColor.background,
      body: Row(
        children: [
          _FormSection(
            emailController: emailController,
            passwordController: passwordController,
            formKey: formKey,
            isLoading: isLoading.value,
            isPasswordVisible: isPasswordVisible,
            onLogin: login,
            rememberMe: rememberMe,
          ),
          const _ImageSection(),
        ],
      ),
    );
  }
}

class _FormSection extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final GlobalKey<FormState> formKey;
  final bool isLoading;
  final ValueNotifier<bool> isPasswordVisible;
  final VoidCallback onLogin;
  final ValueNotifier<bool> rememberMe;


  const _FormSection({
    required this.emailController,
    required this.passwordController,
    required this.formKey,
    required this.isLoading,
    required this.isPasswordVisible,
    required this.onLogin,
    required this.rememberMe,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.isDarkMode ? EvoColor.appleDark : EvoColor.appbarLightBG,
      width: 448,
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Form(
        key: formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              IconlyBroken.adminKit,
              width: 90,
              height: 55.5,
            ),
            const SizedBox(height: 30),
            const Text(
              "Log in",
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 25.63),
            ),
            const SizedBox(height: 41),
            EvoCustomTextField(
              controller: emailController,
              labelText: "Email Address",
              hintText: "example@gmail.com",
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            EvoCustomTextField(
              controller: passwordController,
              labelText: "Password",
              hintText: "********",
              obscureText: !isPasswordVisible.value,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }
                return null;
              },
              suffixIcon: IconButton(
                icon: Icon(
                  isPasswordVisible.value
                      ? Icons.visibility
                      : Icons.visibility_off,
                ),
                onPressed: () =>
                    isPasswordVisible.value = !isPasswordVisible.value,
              ),
            ),
            const SizedBox(height: 25),
            Row(
              children: [
                Checkbox(
                  value: rememberMe.value,
                  onChanged: (newValue) {
                    rememberMe.value = newValue ?? false;
                  },
                ),
                const Text(
                  "Remember me",
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    // TODO: Implement reset password functionality
                  },
                  child: const Text(
                    "Reset Password?",
                    style: TextStyle(
                        color: EvoColor.primary,
                        fontWeight: FontWeight.w500,
                        fontSize: 16),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            EvoButton(
              onPressed: isLoading ? null : onLogin,
              text: "Log in",
              borderRadius: 8.0,
              height: 50,
              minWidth: 348,
              color: EvoColor.primary,
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Don't have an account yet?",
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                ),
                TextButton(
                  onPressed: () => context.go('/signup'),
                  child: const Text(
                    "New Account",
                    style: TextStyle(
                        color: EvoColor.primary,
                        fontWeight: FontWeight.w500,
                        fontSize: 16),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ImageSection extends StatelessWidget {
  const _ImageSection();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SvgPicture.asset(
            "svg/login.svg",
            width: 647,
            height: 602,
          ),
        ),
      ),
    );
  }
}
