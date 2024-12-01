import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Event {
  const Event({
    required this.id,
    required this.creatorId,
    required this.attendeeIds,
  });

  Event.fromMap(Map<String, dynamic> map)
      : id = map['id'] as String,
        creatorId = map['creatorId'] as String,
        attendeeIds = (map['attendeeIds'] as List<dynamic>).cast<String>();

  final String id;
  final String creatorId;

  // if in your UI, you wanna be able to display the attendee's, you could
  // add a list of all attendee ids and with those ids, you can query their
  // current usernames and display them
  final List<String> attendeeIds;

  // Other properties you need

  Event copyWith({
    String? id,
    String? creatorId,
    List<String>? attendeeIds,
  }) {
    return Event(
      id: id ?? this.id,
      creatorId: creatorId ?? this.creatorId,
      attendeeIds: attendeeIds ?? this.attendeeIds,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'creatorId': creatorId,
      'attendeeIds': attendeeIds,
    };
  }
}

class RemoteDataSource {
  RemoteDataSource({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
  })  : _firestore = firestore,
        _auth = auth;

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  /// This will go to the user's collection and create a sub-collection called
  /// events and add the event to it
  Future<void> addEvent(Event event) async {
    final eventRef = _firestore
        .collection('users')
        .doc(event.creatorId)
        .collection('events')
        .doc();
    await eventRef.set(event.copyWith(id: eventRef.id).toMap());
    // Error handling
  }

  /// This will go to the attendee's collection and create
  /// a sub-collection called
  /// invites and add the event to it
  Future<void> inviteUser({
    required String attendeeId,
    required Event event,
  }) async {
    await _firestore
        .collection('users')
        .doc(attendeeId)
        .collection('invites')
        // Here, because it's going into the invitee's collection, we don't want
        // them knowing who else was invited, unless you don't mind them knowing
        .add(event.copyWith(attendeeIds: []).toMap());

    await _firestore
        .collection('users')
        .doc(event.creatorId)
        .collection('events')
        .doc(event.id)
        // In the creator's sub-collection, we will append the attendee's id to
        // the list
        .update({
      'attendeeIds': FieldValue.arrayUnion([attendeeId]),
    });
    // Error handling
  }

  /// This will fetch the current User's events
  Future<List<Event>> getEvents() async {
    final events = await _firestore
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .collection('events')
        .get();
    return events.docs.map((e) => Event.fromMap(e.data())).toList();
  }

  /// This will fetch the current User's invites
  Future<List<Event>> getInvites() async {
    final invites = await _firestore
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .collection('invites')
        .get();
    return invites.docs.map((e) => Event.fromMap(e.data())).toList();
  }

  Future<String> getUsername(String userId) async {
    final user = await _firestore.collection('users').doc(userId).get();
    return user.data()!['username'] as String;
  }
}
