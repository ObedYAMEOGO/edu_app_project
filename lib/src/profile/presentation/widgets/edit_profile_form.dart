import 'package:edu_app_project/core/extensions/string_extensions.dart';
import 'package:edu_app_project/src/authentication/domain/entities/user.dart';
import 'package:edu_app_project/src/profile/presentation/widgets/edit_profile_form_field.dart';
import 'package:flutter/material.dart';

class EditProfileForm extends StatelessWidget {
  const EditProfileForm({
    required this.fullNameController,
    required this.emailController,
    required this.passwordController,
    required this.oldPasswordController,
    required this.bioController,
    required this.user,
    super.key,
  });

  final TextEditingController fullNameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController oldPasswordController;
  final TextEditingController bioController;
  final LocalUser user;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        EditProfileFormField(
          controller: fullNameController,
          hintText: user.fullName,
          fieldTitle: 'Nom & Prénom(s)',
          prefixIcon: Icon(Icons.person),
        ),
        EditProfileFormField(
          controller: emailController,
          hintText: user.email.obscureEmail,
          fieldTitle: 'Email',
          prefixIcon: Icon(Icons.email),
        ),
        EditProfileFormField(
          controller: oldPasswordController,
          hintText: '********',
          fieldTitle: 'Mot de passe actuel',
          prefixIcon: Icon(Icons.verified_user),
        ),
        StatefulBuilder(
          builder: (_, setState) {
            oldPasswordController.addListener(() => setState(() {}));
            return EditProfileFormField(
              controller: passwordController,
              hintText: '********',
              fieldTitle: 'Nouveau mot de passe',
              readOnly: oldPasswordController.text.isEmpty,
              prefixIcon: Icon(Icons.verified_user),
            );
          },
        ),
        EditProfileFormField(
          controller: bioController,
          hintText: user.bio,
          fieldTitle: 'Bio',
          prefixIcon: Icon(Icons.person),
        ),
      ],
    );
  }
}
