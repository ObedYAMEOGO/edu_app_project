import 'package:edu_app_project/core/common/widgets/i_fields.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

class SignInForm extends StatefulWidget {
  const SignInForm(
      {super.key,
      required this.emailController,
      required this.passwordController,
      required this.formKey});

  final TextEditingController emailController;
  final TextEditingController passwordController;
  final GlobalKey<FormState> formKey;

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  bool obscurePassword = true;
  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          IField(
            controller: widget.emailController,
            hintText: 'Votre adresse email svp',
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 15),
          IField(
            controller: widget.passwordController,
            hintText: 'Mot de passe',
            obscureText: obscurePassword,
            keyboardType: TextInputType.visiblePassword,
            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  obscurePassword = !obscurePassword;
                });
              },
              icon: Icon(
                obscurePassword ? IconlyLight.show : IconlyLight.hide,
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
