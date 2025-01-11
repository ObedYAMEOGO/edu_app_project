import 'package:edu_app_project/core/common/views/custom_circular_progress_bar.dart';
import 'package:edu_app_project/core/common/widgets/gradient_background.dart';
import 'package:edu_app_project/core/common/widgets/i_fields.dart';
import 'package:edu_app_project/core/common/widgets/rounded_button.dart';
import 'package:edu_app_project/core/res/colours.dart';
import 'package:edu_app_project/core/res/fonts.dart';
import 'package:edu_app_project/core/res/media_res.dart';
import 'package:edu_app_project/core/utils/core_utils.dart';
import 'package:edu_app_project/src/authentication/presentation/bloc/authentication_bloc.dart';
import 'package:edu_app_project/src/authentication/presentation/views/sign_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  static const routeName = '/forgot-password';

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colours.primaryColour,
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (_, state) {
          if (state is AuthError) {
            Utils.showSnackBar(
              context,
              "Informations incorrectes ou soucis d'accès à internet. Veuillez réessayer!",
              ContentType.failure,
              title: "Oups!",
            );
          } else if (state is ForgotPasswordSent) {
            Utils.showSnackBar(
              context,
              'Email de réinitialisation envoyé. Veuillez vérifier vos emails!',
              ContentType.success,
              title: "Parfait!",
            );
            Navigator.pushReplacementNamed(context, SignInScreen.routeName);
          }
        },
        builder: (context, state) {
          return Scaffold(
            body: GradientBackground(
              image: Res.backgroundImg,
              child: SafeArea(
                child: Center(
                  child: ListView(
                    shrinkWrap: true,
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    children: [
                      const Text(
                        'Réinitialiser le mot de passe',
                        style: TextStyle(
                          fontFamily: Fonts.merriweather,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Column(
                        children: [
                          const SizedBox(height: 25),
                          Form(
                            key: formKey,
                            child: Column(
                              children: [
                                IField(
                                  controller: emailController,
                                  hintText: 'Adresse email',
                                  keyboardType: TextInputType.emailAddress,
                                  prefixIcon: Icon(Icons.email),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Veuillez entrer votre email';
                                    } else if (!RegExp(
                                            r'^[^@\s]+@[^@\s]+\.[^@\s]+$')
                                        .hasMatch(value)) {
                                      return 'Veuillez entrer une adresse email valide';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 20),
                              ],
                            ),
                          ),
                          if (state is AuthLoading)
                            const Center(
                                child: CustomCircularProgressBarIndicator())
                          else
                            RoundedButton(
                              height: 45,
                              label: 'Envoyer',
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  context.read<AuthBloc>().add(
                                        ForgotPasswordEvent(
                                          email: emailController.text.trim(),
                                        ),
                                      );
                                }
                              },
                            ),
                          const SizedBox(height: 20),
                          TextButton(
                            onPressed: () {
                              Navigator.pushReplacementNamed(
                                context,
                                SignInScreen.routeName,
                              );
                            },
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Mot de passe?   ',
                                  style: TextStyle(
                                    fontFamily: Fonts.merriweather,
                                    fontSize: 12,
                                    color: Colours.darkColour,
                                  ),
                                ),
                                Text(
                                  'Se Connecter',
                                  style: TextStyle(
                                    color: Colours.primaryColour,
                                    fontFamily: Fonts.merriweather,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
