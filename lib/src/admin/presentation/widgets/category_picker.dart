import 'package:edu_app_project/core/common/features/category/domain/entities/category.dart';
import 'package:edu_app_project/core/common/features/category/presentation/cubit/category_cubit.dart';
import 'package:edu_app_project/core/res/colours.dart';
import 'package:edu_app_project/core/res/fonts.dart';
import 'package:edu_app_project/core/utils/core_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryPicker extends StatefulWidget {
  const CategoryPicker(
      {super.key, required this.controller, required this.notifier});
  final TextEditingController controller;
  final ValueNotifier<Category?> notifier;

  @override
  State<CategoryPicker> createState() => _CategoryPickerState();
}

class _CategoryPickerState extends State<CategoryPicker> {
  void getCategories() {
    context.read<CategoryCubit>().getCategories();
  }

  @override
  void initState() {
    super.initState();
    getCategories();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CategoryCubit, CategoryState>(
      listener: (context, state) {
        if (state is CategoryError) {
          Utils.showSnackBar(
              context,
              "Une erreur s\'est produite. Verifiez vos informations et réessayer !",
              ContentType.failure,
              title: "Oups !");
          Navigator.pop(context);
        } else if (state is CategoriesLoaded && state.categories.isEmpty) {
          Utils.showSnackBar(
              context,
              'Aucune catégorie disponible \nVeuillez ajouter une catégorie',
              ContentType.warning,
              title: 'Humm');
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        return TextFormField(
            controller: widget.controller,
            readOnly: true,
            decoration: InputDecoration(
              labelText: 'Choisir Catégorie',
              hintStyle: TextStyle(
                fontFamily: Fonts.merriweather,
                fontSize: 12,
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colours.redColour,
                ),
              ),
              border: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colours.redColour,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 10),
              suffixIcon: state is CategoriesLoaded
                  ? PopupMenuButton<String>(
                      offset: Offset(0, 50),
                      surfaceTintColor: Colors.white,
                      icon: const Icon(Icons.arrow_drop_down_outlined),
                      itemBuilder: (context) {
                        return state.categories
                            .map(
                              (category) => PopupMenuItem<String>(
                                child: Text(
                                  category.categoryTitle,
                                  style: TextStyle(
                                      fontFamily: Fonts.merriweather,
                                      fontWeight: FontWeight.w300),
                                ),
                                onTap: () {
                                  widget.controller.text =
                                      category.categoryTitle;
                                  widget.notifier.value = category;
                                },
                              ),
                            )
                            .toList();
                      },
                    )
                  : const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        'Entrain de charger...',
                        style: TextStyle(
                          fontFamily: Fonts.merriweather,
                        ),
                      ),
                    ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Veuillez choisir une catégorie';
              }
              return null;
            });
      },
    );
  }
}
