import 'dart:convert';
import 'dart:io';
import 'package:edu_app_project/core/common/app/providers/tab_navigator.dart';
import 'package:edu_app_project/core/common/app/providers/user_provider.dart';
import 'package:edu_app_project/core/common/views/custom_circular_progress_bar.dart';
import 'package:edu_app_project/core/common/widgets/gradient_background.dart';
import 'package:edu_app_project/core/common/widgets/nested_back_button.dart';
import 'package:edu_app_project/core/enums/update_user.dart';
import 'package:edu_app_project/core/res/colours.dart';
import 'package:edu_app_project/core/res/fonts.dart';
import 'package:edu_app_project/core/res/media_res.dart';
import 'package:edu_app_project/core/utils/core_utils.dart';
import 'package:edu_app_project/src/authentication/domain/entities/user.dart';
import 'package:edu_app_project/src/authentication/presentation/bloc/authentication_bloc.dart';
import 'package:edu_app_project/src/profile/presentation/widgets/edit_profile_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileView extends StatefulWidget {
  const EditProfileView({super.key});

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final bioController = TextEditingController();
  final oldPasswordController = TextEditingController();

  File? pickedImage;

  Future<void> pickImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        pickedImage = File(image.path);
      });
    }
  }

  late LocalUser user;

  bool get nameChanged =>
      user.fullName.trim() != fullNameController.text.trim();

  bool get emailChanged => emailController.text.trim().isNotEmpty;

  bool get passwordChanged => passwordController.text.trim().isNotEmpty;

  bool get bioChanged => user.bio?.trim() != bioController.text.trim();

  bool get imageChanged => pickedImage != null;

  bool get nothingChanged =>
      !nameChanged &&
      !emailChanged &&
      !passwordChanged &&
      !bioChanged &&
      !imageChanged;

  @override
  void initState() {
    user = context.read<UserProvider>().user!;
    fullNameController.text = user.fullName.trim();
    bioController.text = user.bio?.trim() ?? '';
    super.initState();
  }

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is UserUpdated) {
          Utils.showSnackBar(
              context,
              'Opération réussi, votre profil a été mis à jour',
              title: "Parfait !",
              ContentType.success);
          context.read<TabNavigator>().pop();
        } else if (state is AuthError) {
          Utils.showSnackBar(
              context,
              "Une erreur s\'est produite. Verifiez vos informations et réessayer !",
              ContentType.failure,
              title: "Oups !");
        }
      },
      builder: (_, state) {
        return Scaffold(
          extendBodyBehindAppBar: true,
          backgroundColor: Colors.white,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(60.0),
            child: Stack(
              children: [
                // Background layer with gradient and opacity
                Container(
                  decoration: BoxDecoration(
                      // gradient: LinearGradient(
                      //   colors: Colours.gradient
                      //       .map((color) => color.withOpacity(0.5))
                      //       .toList(),
                      //   begin: Alignment.topLeft,
                      //   end: Alignment.bottomRight,
                      // ),
                      ),
                ),
                // Transparent AppBar to show the gradient background
                AppBar(
                  backgroundColor: Colors.transparent,
                  titleSpacing: 0,
                  elevation: 0,
                  title: const Text(
                    "Modifier",
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 17,
                        fontFamily: Fonts.merriweather,
                        color: Colours.darkColour),
                  ),
                  leading: NestedBackButton(),
                  actions: [
                    TextButton(
                      onPressed: () {
                        if (nothingChanged) context.read<TabNavigator>().pop();
                        final bloc = context.read<AuthBloc>();
                        if (nameChanged) {
                          bloc.add(
                            UpdateUserEvent(
                              action: UpdateUserAction.displayName,
                              userData: fullNameController.text.trim(),
                            ),
                          );
                        }
                        if (emailChanged) {
                          bloc.add(
                            UpdateUserEvent(
                              action: UpdateUserAction.email,
                              userData: emailController.text.trim(),
                            ),
                          );
                        }
                        if (passwordChanged) {
                          if (oldPasswordController.text.isEmpty) {
                            Utils.showSnackBar(
                                context,
                                'Veuillez entrer votre ancien mot de passe',
                                ContentType.failure,
                                title: 'Oups!');
                            return;
                          }
                          bloc.add(
                            UpdateUserEvent(
                              action: UpdateUserAction.password,
                              userData: jsonEncode({
                                'oldPassword':
                                    oldPasswordController.text.trim(),
                                'newPassword': passwordController.text.trim(),
                              }),
                            ),
                          );
                        }
                        if (bioChanged) {
                          bloc.add(
                            UpdateUserEvent(
                              action: UpdateUserAction.bio,
                              userData: bioController.text.trim(),
                            ),
                          );
                        }
                        if (imageChanged) {
                          bloc.add(
                            UpdateUserEvent(
                              action: UpdateUserAction.profilePic,
                              userData: pickedImage,
                            ),
                          );
                        }
                      },
                      child: state is AuthLoading
                          ? const Center(
                              child: CustomCircularProgressBarIndicator(),
                            )
                          : StatefulBuilder(
                              builder: (_, refresh) {
                                // add listeners for the controllers and refresh
                                fullNameController
                                    .addListener(() => refresh(() {}));
                                emailController
                                    .addListener(() => refresh(() {}));
                                passwordController
                                    .addListener(() => refresh(() {}));
                                bioController.addListener(() => refresh(() {}));
                                return Text(
                                  'OK!',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: nothingChanged
                                        ? Colors.grey
                                        : Colours.successColor,
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          body: GradientBackground(
            image: '',
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                Builder(
                  builder: (context) {
                    final user = context.read<UserProvider>().user!;
                    final image =
                        user.profilePic == null || user.profilePic!.isEmpty
                            ? null
                            : user.profilePic;
                    return Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: pickedImage != null
                            ? FileImage(pickedImage!)
                            : image != null
                                ? NetworkImage(image)
                                : const AssetImage(Res.user) as ImageProvider,
                        child: Stack(
                          children: [
                            Center(
                              child: Container(
                                height: 100,
                                width: 100,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.black.withOpacity(0.5),
                                ),
                              ),
                            ),
                            Center(
                              child: IconButton(
                                onPressed: pickImage,
                                icon: Icon(
                                  (pickedImage != null ||
                                          user.profilePic != null)
                                      ? Icons.edit
                                      : Icons.add_a_photo,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 10),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'Nous recommendons une image 400x400',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: Fonts.montserrat,
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF777E90),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                EditProfileForm(
                  fullNameController: fullNameController,
                  emailController: emailController,
                  passwordController: passwordController,
                  oldPasswordController: oldPasswordController,
                  bioController: bioController,
                  user: user,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
