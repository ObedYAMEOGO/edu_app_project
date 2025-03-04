import 'package:dartz/dartz.dart' hide State;
import 'package:edu_app_project/core/common/views/custom_circular_progress_bar.dart';
import 'package:edu_app_project/core/common/widgets/gradient_background.dart';
import 'package:edu_app_project/core/common/widgets/not_found_text.dart';
import 'package:edu_app_project/core/res/colours.dart';
import 'package:edu_app_project/core/res/fonts.dart';
import 'package:edu_app_project/core/res/media_res.dart';
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

  void _handleStateChanges(ChatState state) {
    if (state is ChatError) {
      Utils.showSnackBar(
          context, 'Une erreur s\'est produite.', ContentType.failure,
          title: 'Oups!');
    } else if (state is JoinedGroup) {
      Utils.showSnackBar(context, 'Vous êtes désormais membre de ce groupe',
          ContentType.success,
          title: 'Parfait!');
      loading = false;
    } else if (state is JoiningGroup) {
      Utils.showLoadingDialog(context);
      loading = true;
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
    if (groups.isEmpty) {
      return const Center(
        child: Padding(
            padding: EdgeInsets.all(20.0),
            child: NotFoundText(
                "Vous n'avez adhérer à aucun \ngroupe pour le moment")),
      );
    }
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: groups.length,
      itemBuilder: (context, index) => tileBuilder(groups[index]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatCubit, ChatState>(
      listener: (context, state) => _handleStateChanges(state),
      builder: (context, state) {
        return StreamBuilder<Either<ChatError, List<Group>>>(
          stream: groupsStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) _processGroupsData(snapshot.data!);

            return Scaffold(
              backgroundColor: Colors.white,
              extendBodyBehindAppBar: true,
              appBar: AppBar(
                backgroundColor: Colors.white,
                automaticallyImplyLeading: false,
                title: const Text(
                  'Discussions',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontFamily: Fonts.inter,
                    fontSize: 17,
                    color: Colours.darkColour,
                  ),
                ),
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(50),
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color.fromARGB(255, 2, 82, 201),
                          Color(0xff00c6ff),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: TabBar(
                      controller: _tabController,
                      indicator: const BoxDecoration(),
                      labelColor: Colours.whiteColour,
                      unselectedLabelColor:
                          Colours.whiteColour.withOpacity(0.7),
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
                        Tab(text: 'Mes Groupes'),
                        Tab(text: 'Autres Groupes'),
                      ],
                    ),
                  ),
                ),
              ),
              body: GradientBackground(
                image: Res.universalBackground,
                child: SafeArea(
                  child: Column(
                    children: [
                      if (state is LoadingGroups)
                        const Expanded(
                            child: Center(
                                child: CustomCircularProgressBarIndicator()))
                      else
                        Expanded(
                          child: TabBarView(
                            controller: _tabController,
                            children: [
                              _buildGroupSection(
                                  yourGroups, (group) => YourGroupTile(group)),
                              _buildGroupSection(otherGroups,
                                  (group) => OtherGroupTile(group)),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
