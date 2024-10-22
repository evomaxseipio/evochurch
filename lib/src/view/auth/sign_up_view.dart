
import 'package:evochurch/src/constants/constant_index.dart';
import 'package:evochurch/src/utils/utils_index.dart';
import 'package:evochurch/src/view_model/auth_services.dart';
import 'package:evochurch/src/widgets/button/button.dart';
import 'package:evochurch/src/widgets/text/evo_custom_text_field.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
class SignUpView extends HookWidget {
  const SignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: EvoColor.background,
      body: Row(
        children: [
          const Expanded( child: _FormSection()),
          if (!Responsive.isMobile(context))
            const Expanded( child: _ImageSection()),
        ],
      ),
    );
  }
}

class _FormSection extends HookWidget {
  const _FormSection();

  @override
  Widget build(BuildContext context) {
    final fullNameController = useTextEditingController();
    final emailController = useTextEditingController();
    final usernameController = useTextEditingController();
    final passwordController = useTextEditingController();
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final authService = Provider.of<AuthServices>(context, listen: false);
    final isLoading = useState(false);
    final isPasswordVisible = useState(false);
    final agreeToTerms = useState(false);

    Future<void> signUp() async {
      if (formKey.currentState!.validate() && agreeToTerms.value) {
        isLoading.value = true;
        try {
          final success = await authService.signUp(
            email: emailController.text.trim(),
            password: passwordController.text.trim(),
            username: usernameController.text.trim(),
            fullName: fullNameController.text.trim(),
          );
          if (success) {
            if (!context.mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text(
                      'Sign up successful. Please check your email for confirmation.')),
            );
            context.go('/login');
          } else {
            if (!context.mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(authService.errorMessage ?? 'Sign up failed')),
            );
          }
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('An unexpected error occurred: $e')),
          );
        } finally {
          isLoading.value = false;
        }
      } else if (!agreeToTerms.value) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content:
                  Text('Please agree to the terms of use and privacy policy')),
        );
      }
    }

    return SizedBox(
      // color: EvoColor.neutral,
      // width: 200,
      child: CustomScrollView(
        slivers: [
          const SliverPadding(padding: EdgeInsets.only(top: 50)),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: SvgPicture.asset(
                        IconlyBroken.adminKit,
                        width: 90,
                        height: 55.5,
                      ),
                    ),
                    const SizedBox(height: 30),
                    const Center(
                      child: Text(
                        "Sign Up",
                        style: TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 25.63),
                      ),
                    ),
                    const SizedBox(height: 41),
                    const Text(
                      "Full Name",
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                    ),
                    const SizedBox(height: 9),
                    EvoCustomTextField(
                      controller: fullNameController,
                      hintText: "John Doe",
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your full name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Email Address",
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                    ),
                    const SizedBox(height: 9),
                    EvoCustomTextField(
                      controller: emailController,
                      hintText: "example@gmail.com",
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                            .hasMatch(value)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Username",
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                    ),
                    const SizedBox(height: 9),
                    EvoCustomTextField(
                      controller: usernameController,
                      hintText: "johnsmith123",
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a username';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Password",
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                    ),
                    const SizedBox(height: 9),
                    EvoCustomTextField(
                      controller: passwordController,
                      hintText: "********",
                      obscureText: !isPasswordVisible.value,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a password';
                        }
                        if (value.length < 8) {
                          return 'Password must be at least 8 characters long';
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Checkbox(
                          value: agreeToTerms.value,
                          onChanged: (value) =>
                              agreeToTerms.value = value ?? false,
                        ),
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  height: 1.4,
                                  color: EvoColor.primary),
                              children: [
                                const TextSpan(
                                    text:
                                        'By creating an account you agree to the '),
                                TextSpan(
                                  text: 'terms of use',
                                  style:
                                      const TextStyle(color: EvoColor.primary),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      // Navigate to terms of use
                                    },
                                ),
                                const TextSpan(text: ' and our '),
                                TextSpan(
                                  text: 'privacy policy.',
                                  style:
                                      const TextStyle(color: EvoColor.primary),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      // Navigate to privacy policy
                                    },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    EvoButton(
                      onPressed: isLoading.value ? null : signUp,
                      text: "Create account",
                      borderRadius: 8.0,
                      height: 50,
                      minWidth: double.infinity,
                      color: EvoColor.primary,
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Already have an account?",
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 16),
                        ),
                        TextButton(
                          onPressed: () => context.go('/login'),
                          child: const Text(
                            "Log in",
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
            ),
          ),
          const SliverPadding(padding: EdgeInsets.only(top: 50)),
        ],
      ),
    );
  }
}

class _ImageSection extends StatelessWidget {
  const _ImageSection();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SvgPicture.asset(
        "assets/svg/login.svg",
        width: 647,
        height: 602,
      ),
    );
  }
}
