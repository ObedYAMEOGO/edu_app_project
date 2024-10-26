import 'package:edu_app_project/core/common/widgets/i_fields.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.formKey,
    required this.fullNameController,
    super.key,
  });

  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final TextEditingController fullNameController;
  final GlobalKey<FormState> formKey;

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  bool obscurePassword = true;
  bool obscureConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          IField(
            controller: widget.fullNameController,
            hintText: 'Nom et Prénom (s)',
            keyboardType: TextInputType.name,
          ),
          const SizedBox(height: 25),
          IField(
            controller: widget.emailController,
            hintText: 'Adresse email',
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 25),
          IField(
            controller: widget.passwordController,
            hintText: 'Mot de Passe',
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
          const SizedBox(height: 25),
          IField(
            controller: widget.confirmPasswordController,
            hintText: 'Confirmer mot de passe',
            obscureText: obscureConfirmPassword,
            keyboardType: TextInputType.visiblePassword,
            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  obscureConfirmPassword = !obscureConfirmPassword;
                });
              },
              icon: Icon(
                obscureConfirmPassword ? IconlyLight.show : IconlyLight.hide,
                color: Colors.grey,
              ),
            ),
            validator: (value) {
              if (value != widget.passwordController.text) {
                return 'Vos mots de passe ne correspondent pas';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}
