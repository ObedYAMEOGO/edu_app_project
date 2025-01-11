import 'package:edu_app_project/core/common/app/providers/user_provider.dart';
import 'package:edu_app_project/core/common/views/custom_circular_progress_bar.dart';
import 'package:edu_app_project/core/common/widgets/gradient_background.dart';
import 'package:edu_app_project/core/common/widgets/rounded_button.dart';
import 'package:edu_app_project/core/res/colours.dart';
import 'package:edu_app_project/core/res/fonts.dart';
import 'package:edu_app_project/core/res/media_res.dart';
import 'package:edu_app_project/core/utils/core_utils.dart';
import 'package:edu_app_project/src/authentication/presentation/bloc/authentication_bloc.dart';
import 'package:edu_app_project/src/authentication/presentation/views/sign_up_screen.dart';
import 'package:edu_app_project/src/authentication/presentation/widgets/sign_in_form.dart';
import 'package:edu_app_project/src/dashboard/presentation/views/dashboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  static const routeName = '/sign-in';

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (_, state) {
          if (state is AuthError) {
            Utils.showSnackBar(
                context,
                "Informations incorrects ou soucis d'accès à internet. Veuillez réessayer!",
                ContentType.failure,
                title: "Oups!");
          } else if (state is SignedIn) {
            context.read<UserProvider>().initUser(state.user);
            Navigator.pushReplacementNamed(context, Dashboard.routeName);
            Utils.showSnackBar(
                context, "Vous êtes connecté!", ContentType.success,
                title: "Parfait!");
          }
        },
        builder: (context, state) {
          return GradientBackground(
            image: Res.backgroundImg,
            child: SafeArea(
                child: Center(
              child: ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(horizontal: 30),
                children: [
                  Text(
                    "Connexion",
                    style: TextStyle(
                      fontFamily: Fonts.merriweather,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  SignInForm(
                      emailController: emailController,
                      passwordController: passwordController,
                      formKey: formKey),
                  const SizedBox(
                    height: 10,
                  ),
                  Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                              context, '/forgot-password');
                        },
                        child: Text(
                          'Mot de passe oublié ?',
                          style: TextStyle(
                              fontFamily: Fonts.merriweather,
                              color: Colours.primaryColour,
                              fontSize: 12),
                        ),
                      )),
                  const SizedBox(
                    height: 15,
                  ),
                  if (state is AuthLoading)
                    const Center(
                      child: CustomCircularProgressBarIndicator(),
                    )
                  else
                    RoundedButton(
                      height: 45,
                      label: "Se connecter",
                      onPressed: () {
                        FocusManager.instance.primaryFocus?.unfocus();
                        FirebaseAuth.instance.currentUser?.reload();
                        if (formKey.currentState!.validate()) {
                          context.read<AuthBloc>().add(SignInEvent(
                                email: emailController.text.trim(),
                                password: passwordController.text.trim(),
                              ));
                        }
                      },
                    ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                            context,
                            SignUpScreen.routeName,
                          );
                        },
                        child: const Row(
                          children: [
                            Text(
                              'Pas de compte?   ',
                              style: TextStyle(
                                color: Colours.darkColour,
                                fontSize: 12,
                                fontFamily: Fonts.merriweather,
                              ),
                            ),
                            Text(
                              '  S\'inscrire',
                              style: TextStyle(
                                color: Colours.primaryColour,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                fontFamily: Fonts.merriweather,
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )),
          );
        },
      ),
    );
  }
}
