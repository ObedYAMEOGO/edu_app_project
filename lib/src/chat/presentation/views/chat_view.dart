import 'package:dartz/dartz.dart' hide State;
import 'package:edu_app_project/core/common/views/custom_circular_progress_bar.dart';
import 'package:edu_app_project/core/res/colours.dart';
import 'package:edu_app_project/core/res/fonts.dart';
import 'package:edu_app_project/core/utils/core_utils.dart';
import 'package:edu_app_project/src/chat/domain/entities/group.dart';
import 'package:edu_app_project/src/chat/presentation/app/cubit/chat_cubit.dart';
import 'package:edu_app_project/src/chat/presentation/widgets/other_group_tile.dart';
import 'package:edu_app_project/src/chat/presentation/widgets/your_group_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatView extends StatefulWidget {
  const ChatView({super.key});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView>
    with SingleTickerProviderStateMixin {
  late Stream<Either<ChatError, List<Group>>> groupsStream;
  late TabController _tabController;

  List<Group> yourGroups = [];
  List<Group> otherGroups = [];
  bool loading = false;

  final auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    groupsStream = context.read<ChatCubit>().getGroups();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showErrorSnackBar(String message) {
    Utils.showSnackBar(context, message, ContentType.failure, title: 'Oups!');
  }

  void _showSuccessSnackBar(String message) {
    Utils.showSnackBar(context, message, ContentType.success,
        title: 'Parfait!');
  }

  void _showLoadingDialog() {
    Utils.showLoadingDialog(context);
    loading = true;
  }

  void _clearLoading() {
    if (loading) {
      Navigator.pop(context);
      loading = false;
    }
  }

  void _handleStateChanges(ChatState state) {
    if (state is ChatError) {
      _showErrorSnackBar(
          'Une erreur s\'est produite. Vérifier votre connexion internet puis réessayez!');
    } else if (state is JoinedGroup) {
      _showSuccessSnackBar('Vous êtes désormais membre de ce groupe');
      _clearLoading();
    } else if (state is JoiningGroup) {
      _showLoadingDialog();
    }
  }

  void _processGroupsData(Either<ChatError, List<Group>> data) {
    final groups = data.fold((l) => <Group>[], (r) => r);
    yourGroups = groups
        .where((group) => group.members.contains(auth.currentUser!.uid))
        .toList();
    otherGroups = groups
        .where((group) => !group.members.contains(auth.currentUser!.uid))
        .toList();
  }

  Widget _buildGroupSection(
      List<Group> groups, Widget Function(Group) tileBuilder) {
    if (groups.isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        ...groups.map(tileBuilder),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatCubit, ChatState>(
      listener: (context, state) {
        _handleStateChanges(state);
      },
      builder: (context, state) {
        return StreamBuilder<Either<ChatError, List<Group>>>(
          stream: groupsStream,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              _showErrorSnackBar(snapshot.error.toString());
            } else if (snapshot.hasData && snapshot.data!.isLeft()) {
              _showErrorSnackBar(
                  (snapshot.data! as Left<ChatError, List<Group>>)
                      .value
                      .message);
            } else if (snapshot.hasData && snapshot.data != null) {
              _processGroupsData(snapshot.data!);
            }

            return Scaffold(
              backgroundColor: Colors.white,
              extendBodyBehindAppBar: true,
              appBar: AppBar(
                automaticallyImplyLeading: false,
                title: const Text('Discussions',
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontFamily: Fonts.inter,
                        fontSize: 17,
                        color: Colours.darkColour)),
                bottom: PreferredSize(
                  preferredSize:
                      const Size.fromHeight(50), // Adjust height as needed
                  child: Container(
                    color: Color(
                        0xFFE4E6EA), // Set background color for the tab section
                    child: TabBar(
                      controller: _tabController,
                      indicator: const BoxDecoration(),
                      labelColor: Colours.darkColour,
                      unselectedLabelColor:
                          Colors.grey[500], // Adjust text color for contrast
                      labelStyle: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontFamily: Fonts.inter,
                        fontSize: 14,
                      ),
                      unselectedLabelStyle: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontFamily: Fonts.inter,
                        fontSize: 14,
                      ),
                      tabs: const [
                        Tab(
                          text: 'Mes Groupes',
                        ),
                        Tab(text: 'Autres Groupes'),
                      ],
                    ),
                  ),
                ),
              ),
              body: SafeArea(
                child: state is LoadingGroups
                    ? const Center(child: CustomCircularProgressBarIndicator())
                    : TabBarView(
                        controller: _tabController,
                        children: [
                          _buildGroupSection(
                              yourGroups, (group) => YourGroupTile(group)),
                          _buildGroupSection(
                              otherGroups, (group) => OtherGroupTile(group)),
                        ],
                      ),
              ),
            );
          },
        );
      },
    );
  }
}
