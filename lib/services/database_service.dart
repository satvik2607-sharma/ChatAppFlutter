import 'package:chat_app_flutter/model/chat.dart';
import 'package:chat_app_flutter/model/message.dart';
import 'package:chat_app_flutter/model/user_profile.dart';
import 'package:chat_app_flutter/services/auth_service.dart';
import 'package:chat_app_flutter/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';

class DatabaseService {
  late AuthService authService;
  final GetIt getIt = GetIt.instance;
  DatabaseService() {
    _setupCollectionReference();
    authService = getIt.get<AuthService>();
  }

  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  CollectionReference? _usersCollection;
  CollectionReference? _chatCollection;

  void _setupCollectionReference() {
    _usersCollection =
        _firebaseFirestore.collection('users').withConverter<UserProfile>(
              fromFirestore: (snapshots, _) => UserProfile.fromMap(
                snapshots.data()!,
              ),
              toFirestore: (userProfile, _) => userProfile.toMap(),
            );

    _chatCollection = _firebaseFirestore
        .collection('chats')
        .withConverter<Chat>(
            fromFirestore: (snapshots, _) => Chat.fromJson(snapshots.data()!),
            toFirestore: (chat, _) => chat.toMap());
  }

  Future<void> createUserProfile({required UserProfile userProfile}) async {
    await _usersCollection?.doc(userProfile.uid).set(userProfile);
  }

  Stream<QuerySnapshot<UserProfile>> getUserProfiles() {
    return _usersCollection
        ?.where("uid", isNotEqualTo: authService.user!.uid)
        .snapshots() as Stream<QuerySnapshot<UserProfile>>;
  }

  Future<bool> checkChatExists(String uid1, String uid2) async {
    String chatId = generateChatId(uid1: uid1, uid2: uid2);
    final result = await _chatCollection?.doc(chatId).get();
    if (result != null) {
      result.exists;
    }
    return false;
  }

  Future<void> createNewChat(String uid1, String uid2) async {
    String chatId = generateChatId(uid1: uid1, uid2: uid2);
    final docRef = _chatCollection!.doc(chatId);
    final chat = Chat(
      id: chatId,
      participants: [uid1, uid2],
      messages: [],
    );
    await docRef.set(chat);
  }

  Future<void> sendChatMessage(
      String uid1, String uid2, Message message) async {
    String chatId = generateChatId(uid1: uid1, uid2: uid2);
    final docRef = _chatCollection!.doc(chatId);
    await docRef.update({
      "messages": FieldValue.arrayUnion(
        [
          message.toMap(),
        ],
      )
    });
  }

  Stream getChatData(String uid1, String uid2) {
    String chatId = generateChatId(uid1: uid1, uid2: uid2);
    return _chatCollection?.doc(chatId).snapshots()
        as Stream<DocumentSnapshot<Chat>>;
  }
}
