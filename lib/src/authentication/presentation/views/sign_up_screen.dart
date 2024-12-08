import 'package:edu_app_project/core/common/app/providers/user_provider.dart';
import 'package:edu_app_project/core/common/views/custom_circular_progress_bar.dart';
import 'package:edu_app_project/core/common/widgets/gradient_background.dart';
import 'package:edu_app_project/core/common/widgets/rounded_button.dart';
import 'package:edu_app_project/core/res/colours.dart';
import 'package:edu_app_project/core/res/fonts.dart';
import 'package:edu_app_project/core/res/media_res.dart';
import 'package:edu_app_project/core/utils/core_utils.dart';
import 'package:edu_app_project/src/authentication/presentation/bloc/authentication_bloc.dart';
import 'package:edu_app_project/src/authentication/presentation/views/sign_in_screen.dart';
import 'package:edu_app_project/src/authentication/presentation/widgets/sign_up_form.dart';
import 'package:edu_app_project/src/dashboard/presentation/views/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  static const routeName = '/sign-up';

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController fullNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    fullNameController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            Utils.showSnackBar(
                context,
                "Informations incorrects ou soucis d'accès à internet. Veuillez réessayer!",
                ContentType.failure,
                title: "Oups !");
          } else if (state is SignedUp) {
            context.read<AuthBloc>().add(
                  SignInEvent(
                    email: emailController.text.trim(),
                    password: passwordController.text.trim(),
                  ),
                );
            Utils.showSnackBar(
                context,
                'Vos informations ont été enregistrées avec succès',
                ContentType.success,
                title: "Parfait!");
          } else if (state is SignedIn) {
            context.read<UserProvider>().initUser(state.user);
            Navigator.pushReplacementNamed(context, Dashboard.routeName);
          }
        },
        builder: (context, state) {
          return GradientBackground(
            image: Res.backgroundImg,
            child: SafeArea(
              child: Center(
                child: ListView(
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    Text(
                      'Inscription',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: Fonts.montserrat,
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                          color: Colours.primaryColour),
                    ),
                    const SizedBox(height: 25),
                    SignUpForm(
                      emailController: emailController,
                      passwordController: passwordController,
                      fullNameController: fullNameController,
                      confirmPasswordController: confirmPasswordController,
                      formKey: formKey,
                    ),
                    const SizedBox(height: 30),
                    state is AuthLoading
                        ? const Center(
                            child: CustomCircularProgressBarIndicator(),
                          )
                        : RoundedButton(
                            label: 'S\'inscrire',
                            height: 45,
                            onPressed: () {
                              FocusManager.instance.primaryFocus?.unfocus();
                              if (formKey.currentState!.validate()) {
                                context.read<AuthBloc>().add(
                                      SignUpEvent(
                                        email: emailController.text.trim(),
                                        password:
                                            passwordController.text.trim(),
                                        name: fullNameController.text.trim(),
                                      ),
                                    );
                              }
                            },
                          ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(
                              context,
                              SignInScreen.routeName,
                            );
                          },
                          child: const Row(
                            children: [
                              Text(
                                'Déjà un compte?   ',
                                style: TextStyle(
                                    color: Colours.secondaryColour,
                                    fontSize: 12,
                                    fontFamily: Fonts.montserrat),
                              ),
                              Text(
                                '  Se connecter',
                                style: TextStyle(
                                    color: Colours.primaryColour,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: Fonts.montserrat),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
