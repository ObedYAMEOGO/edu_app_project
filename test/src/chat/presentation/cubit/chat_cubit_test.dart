import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:edu_app_project/core/errors/exceptions.dart';
import 'package:edu_app_project/core/errors/failures.dart';
import 'package:edu_app_project/src/chat/data/models/group_model.dart';
import 'package:edu_app_project/src/chat/data/models/message_model.dart';
import 'package:edu_app_project/src/chat/domain/entities/group.dart';
import 'package:edu_app_project/src/chat/domain/usecases/get_groups.dart';
import 'package:edu_app_project/src/chat/domain/usecases/get_messages.dart';
import 'package:edu_app_project/src/chat/domain/usecases/get_previous_messages.dart';
import 'package:edu_app_project/src/chat/domain/usecases/join_group.dart';
import 'package:edu_app_project/src/chat/domain/usecases/leave_group.dart';
import 'package:edu_app_project/src/chat/domain/usecases/send_message.dart';
import 'package:edu_app_project/src/chat/presentation/app/cubit/chat_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSendMessage extends Mock implements SendMessage {}

class MockGetMessages extends Mock implements GetMessages {}

class MockGetGroups extends Mock implements GetGroups {}

class MockJoinGroup extends Mock implements JoinGroup {}

class MockLeaveGroup extends Mock implements LeaveGroup {}

class MockGetPreviousMessages extends Mock implements GetPreviousMessages {}

void main() {
  late SendMessage sendMessage;
  late GetMessages getMessages;
  late GetGroups getGroups;
  late JoinGroup joinGroup;
  late LeaveGroup leaveGroup;
  late GetPreviousMessages getPreviousMessages;
  late ChatCubit chatCubit;

  setUp(() {
    sendMessage = MockSendMessage();
    getMessages = MockGetMessages();
    getGroups = MockGetGroups();
    joinGroup = MockJoinGroup();
    leaveGroup = MockLeaveGroup();
    getPreviousMessages = MockGetPreviousMessages();
    chatCubit = ChatCubit(
      sendMessage: sendMessage,
      getMessages: getMessages,
      getGroups: getGroups,
      joinGroup: joinGroup,
      getPreviousMessages: getPreviousMessages,
      leaveGroup: leaveGroup,
    );
  });

  tearDown(() {
    chatCubit.close();
  });

  test('initial state is ChatInitial', () {
    expect(chatCubit.state, const ChatInitial());
  });

  group('sendMessage', () {
    final message = MessageModel.empty();

    blocTest<ChatCubit, ChatState>(
      'emits [SendingMessage, MessageSent] when successful',
      build: () {
        when(() => sendMessage(message)).thenAnswer(
          (_) async => const Right(null),
        );
        return chatCubit;
      },
      act: (cubit) => cubit.sendMessage(message),
      expect: () => const [
        SendingMessage(),
        MessageSent(),
      ],
      verify: (_) {
        verify(() => sendMessage(message)).called(1);
        verifyNoMoreInteractions(sendMessage);
      },
    );

    blocTest<ChatCubit, ChatState>(
      'emits [SendingMessage, ChatError] when unsuccessful',
      build: () {
        when(() => sendMessage(message)).thenAnswer(
          (_) async => const Left(
            ServerFailure(message: 'Server Error', statusCode: 500),
          ),
        );
        return chatCubit;
      },
      act: (cubit) => cubit.sendMessage(message),
      expect: () => const [
        SendingMessage(),
        ChatError('500: Server Error'),
      ],
      verify: (_) {
        verify(() => sendMessage(message)).called(1);
        verifyNoMoreInteractions(sendMessage);
      },
    );
  });

  group('joinGroup', () {
    const tJoinGroupParams = JoinGroupParams.empty();
    setUpAll(() => registerFallbackValue(tJoinGroupParams));
    blocTest<ChatCubit, ChatState>(
      'emits [JoiningGroup, JoinedGroup] when successful',
      build: () {
        when(() => joinGroup(any())).thenAnswer(
          (_) async => const Right(null),
        );
        return chatCubit;
      },
      act: (cubit) => cubit.joinGroup(
        groupId: tJoinGroupParams.groupId,
        userId: tJoinGroupParams.userId,
      ),
      expect: () => const [
        JoiningGroup(),
        JoinedGroup(),
      ],
      verify: (_) {
        verify(() => joinGroup(tJoinGroupParams)).called(1);
        verifyNoMoreInteractions(joinGroup);
      },
    );

    blocTest<ChatCubit, ChatState>(
      'emits [JoiningGroup, ChatError] when unsuccessful',
      build: () {
        when(() => joinGroup(any())).thenAnswer(
          (_) async => const Left(
            ServerFailure(message: 'Server Error', statusCode: 500),
          ),
        );
        return chatCubit;
      },
      act: (cubit) => cubit.joinGroup(
        groupId: tJoinGroupParams.groupId,
        userId: tJoinGroupParams.userId,
      ),
      expect: () => const [
        JoiningGroup(),
        ChatError('500: Server Error'),
      ],
      verify: (_) {
        verify(() => joinGroup(tJoinGroupParams)).called(1);
        verifyNoMoreInteractions(joinGroup);
      },
    );
  });

  group('leaveGroup', () {
    const tLeaveGroupParams = LeaveGroupParams.empty();
    setUpAll(() => registerFallbackValue(tLeaveGroupParams));
    blocTest<ChatCubit, ChatState>(
      'emits [LeavingGroup, LeftGroup] when successful',
      build: () {
        when(() => leaveGroup(any())).thenAnswer(
          (_) async => const Right(null),
        );
        return chatCubit;
      },
      act: (cubit) => cubit.leaveGroup(
        groupId: tLeaveGroupParams.groupId,
        userId: tLeaveGroupParams.userId,
      ),
      expect: () => const [
        LeavingGroup(),
        LeftGroup(),
      ],
      verify: (_) {
        verify(() => leaveGroup(tLeaveGroupParams)).called(1);
        verifyNoMoreInteractions(leaveGroup);
      },
    );

    blocTest<ChatCubit, ChatState>(
      'emits [LeavingGroup, ChatError] when unsuccessful',
      build: () {
        when(() => leaveGroup(any())).thenAnswer(
          (_) async => const Left(
            ServerFailure(message: 'Server Error', statusCode: 500),
          ),
        );
        return chatCubit;
      },
      act: (cubit) => cubit.leaveGroup(
        groupId: tLeaveGroupParams.groupId,
        userId: tLeaveGroupParams.userId,
      ),
      expect: () => const [
        LeavingGroup(),
        ChatError('500: Server Error'),
      ],
      verify: (_) {
        verify(() => leaveGroup(tLeaveGroupParams)).called(1);
        verifyNoMoreInteractions(leaveGroup);
      },
    );
  });

  group('getGroups', () {
    final tGroup = GroupModel.empty();
    test(
      'should return [Stream<Either<ChatError, List<Group>>>] when '
      'successful',
      () async {
        when(() => getGroups())
            .thenAnswer((_) => Stream.value(Right([tGroup])));

        final result = chatCubit.getGroups();

        expect(result, isA<Stream<Either<ChatError, List<Group>>>>());

        verify(() => getGroups()).called(1);
        verifyNoMoreInteractions(getGroups);
      },
    );

    test(
      'should return [Stream<Either<ChatError, List<Group>>>] when '
      'unsuccessful',
      () async {
        when(() => getGroups()).thenAnswer(
          (_) => Stream.value(
            const Left(
              ServerFailure(message: 'Server Error', statusCode: 500),
            ),
          ),
        );

        final result = chatCubit.getGroups();

        expect(result, isA<Stream<Either<ChatError, List<Group>>>>());

        verify(() => getGroups()).called(1);
        verifyNoMoreInteractions(getGroups);
      },
    );
  });

  group('getMessages', () {
    final messages = [MessageModel.empty()];
    blocTest<ChatCubit, ChatState>(
      'should emit [LoadingMessages, MessagesLoaded] when successful',
      build: () {
        when(() => getMessages(any())).thenAnswer(
          (_) => Stream.value(Right(messages)),
        );
        return chatCubit;
      },
      act: (cubit) => cubit.getMessages('groupId'),
      expect: () => [
        const LoadingMessages(),
        MessagesLoaded(messages: messages, isPrevious: false),
      ],
      verify: (_) {
        verify(() => getMessages('groupId')).called(1);
        verifyNoMoreInteractions(getMessages);
      },
    );
    blocTest<ChatCubit, ChatState>(
      'should emit [LoadingMessages, ChatError] '
      'when unsuccessful',
      build: () {
        when(() => getMessages(any())).thenAnswer(
          (_) => Stream.value(
            Left(
              ServerFailure.fromException(
                const ServerException(
                  message: 'Unknown error occurred',
                  statusCode: '505',
                ),
              ),
            ),
          ),
        );
        return chatCubit;
      },
      act: (cubit) => cubit.getMessages('groupId'),
      expect: () => [
        const LoadingMessages(),
        const ChatError('505: Unknown error occurred'),
      ],
      verify: (_) {
        verify(() => getMessages('groupId')).called(1);
        verifyNoMoreInteractions(getMessages);
      },
    );
  });

/*  group('getMessages', () {
    final tMessage = MessageModel.empty();
    test(
      'should return [Stream<Either<ChatError, List<Message>>>] when '
      'successful',
      () async {
        when(() => getMessages(any()))
            .thenAnswer((_) => Stream.value(Right([tMessage])));

        final result = chatCubit.getMessages('1');

        expect(result, isA<Stream<Either<ChatError, List<Message>>>>());

        verify(() => getMessages('1')).called(1);
        verifyNoMoreInteractions(getMessages);
      },
    );

    test(
      'should return [Stream<Either<ChatError, List<Message>>>] when '
      'unsuccessful',
      () async {
        when(() => getMessages(any())).thenAnswer(
          (_) => Stream.value(
            const Left(
              ServerFailure(message: 'Server Error', statusCode: 500),
            ),
          ),
        );

        final result = chatCubit.getMessages('1');

        expect(result, isA<Stream<Either<ChatError, List<Message>>>>());

        verify(() => getMessages('1')).called(1);
        verifyNoMoreInteractions(getMessages);
      },
    );
  });*/
}
