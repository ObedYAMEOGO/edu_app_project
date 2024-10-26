import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edu_app_project/src/authentication/data/datasources/auth_remote_data_source.dart';
import 'package:edu_app_project/src/authentication/data/repos/auth_repo_impl.dart';
import 'package:edu_app_project/src/authentication/domain/repos/auth_repo.dart';
import 'package:edu_app_project/src/authentication/domain/usecases/forgot_password.dart';
import 'package:edu_app_project/src/authentication/domain/usecases/sign_in.dart';
import 'package:edu_app_project/src/authentication/domain/usecases/sign_up.dart';
import 'package:edu_app_project/src/authentication/domain/usecases/update_user.dart';
import 'package:edu_app_project/src/authentication/presentation/bloc/authentication_bloc.dart';
import 'package:edu_app_project/src/on_boarding/data/datasources/on_boarding_local_data_source.dart';
import 'package:edu_app_project/src/on_boarding/data/repos/on_boarding_repo_impl.dart';
import 'package:edu_app_project/src/on_boarding/domain/repos/on_boarding_repo.dart';
import 'package:edu_app_project/src/on_boarding/domain/usecases/cache_first_timer.dart';
import 'package:edu_app_project/src/on_boarding/domain/usecases/check_if_user_is_first_timer.dart';
import 'package:edu_app_project/src/on_boarding/presentation/cubit/on_boarding_cubit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'injection_container.main.dart';

