import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:sheeba_sample/model/chat_user.dart';
import 'package:sheeba_sample/model/notification.dart';
import 'package:sheeba_sample/util/firebase_constants.dart';
import 'package:sheeba_sample/util/util.dart';

class ViewModel {
  User? currentUser;                // ユーザー認証情報
  Stream<DocumentSnapshot>? chatUserStream;
  File? imageFile;                  // 画像ファイル情報
  bool isLoading = false;           // リロードの有無
  List<ChatUser> allUsers = [];     // 全ユーザー

  // DB
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  String? email;
  String? password;
  String? username;
  String? profileImageUrl;
  String? age;
  String? address;

  /// 初期亜処理
  ///
  /// @param なし
  /// @return なし
  void init() {
    imageFile = null;
    email = "";
    password = "";
    username = "";
    profileImageUrl = "";
    age = "";
    address = "";

    isLoading = false;
  }

  /// サインアップ
  ///
  /// @param なし
  /// @return なし
  Future<void> signUp() async {
    // firebase authでユーザー作成
    if (email != null && password != null) {
      final userCredential = await _auth
          .createUserWithEmailAndPassword(email: email!, password: password!);
      currentUser = userCredential.user;
    }
  }

  /// ログイン
  ///
  /// @param なし
  /// @return なし
  Future<void> login() async {
    if (email != null && password != null) {
      final userCredential = await _auth
          .signInWithEmailAndPassword(email: email!, password: password!);
      currentUser = userCredential.user;
    }
  }

  /// ログアウト
  ///
  /// @param なし
  /// @return なし
  Future<void> logout() async {
    await _auth.signOut();
  }

  /// UserをDBに保存
  ///
  /// @param
  /// - user ユーザー情報
  /// @return なし
  Future<void> persistUser(User user) async {
    await _firestore
        .collection(FirebaseChatUser().users)
        .doc(user.uid)
        .set({
      FirebaseChatUser().uid: user.uid,
      FirebaseChatUser().email: email,
      FirebaseChatUser().profileImageUrl: profileImageUrl,
      FirebaseChatUser().point: Util().regisrationPoint,
      FirebaseChatUser().username: username,
      FirebaseChatUser().age: age,
      FirebaseChatUser().address: address,
      FirebaseChatUser().isStore: false,
      FirebaseChatUser().isOwner: false,
      FirebaseChatUser().os: Platform.isAndroid ? 'Android' : 'iOS',
    });
  }

  /// 画像をFirebaseStorageに保存
  ///
  /// @param
  /// - user ユーザー情報
  /// - doc ドキュメント
  /// @return なし
  Future<void> persistImage(User user, bool isPersist) async {
    // TODO - doc取得する意味あるのか？
    final doc = _firestore
        .collection(FirebaseChatUser().users)
        .doc(user.uid);

    // 画像をFirebaseStorageにアップロード
    final task = await _storage
        .ref('profile/${doc.id}')
        .putFile(imageFile!);
    profileImageUrl = await task.ref.getDownloadURL();

    // 新規会員登録のみ実行
    if (isPersist) {
      await persistUser(user);
    }
  }

  /// ユーザー情報を取得
  ///
  /// @param なし
  /// @return なし
  // Future<void> fetchCurrentUser() async {
  //   final user = _auth.currentUser;
  //
  //   if (user != null) {
  //     final docRef = _firestore.collection("users").doc(user.uid);
  //     await docRef.get().then(
  //           (DocumentSnapshot doc) {
  //         final data = doc.data() as Map<String, dynamic>;
  //         final String uid = doc.id;
  //         final String email = data[FirebaseChatUser().email];
  //         final String profileImageUrl = data[FirebaseChatUser().profileImageUrl];
  //         final int point = data[FirebaseChatUser().point];
  //         final String username = data[FirebaseChatUser().username];
  //         final String age = data[FirebaseChatUser().age];
  //         final String address = data[FirebaseChatUser().address];
  //         final bool isStore = data[FirebaseChatUser().isStore];
  //         final bool isOwner = data[FirebaseChatUser().isOwner];
  //         final String os = data[FirebaseChatUser().os];
  //         currentChatUser = ChatUser(uid, email, profileImageUrl, point, username, age, address, isStore, isOwner, os);
  //         // print('fetchCurrentUser -> curretnChatUser: $currentChatUser');
  //       },
  //       onError: (e) => print("ユーザー情報取得エラー: $e"),
  //     );
  //   } else {
  //     print("ユーザー情報取得エラー");
  //   }
  // }

  /// ユーザー情報を取得
  ///
  /// @param なし
  /// @return ユーザー情報
  Stream<DocumentSnapshot>? fetchCurrentUser() {
    final user = _auth.currentUser;
    if (user != null) {
      final docRef = _firestore
          .collection(FirebaseChatUser().users)
          .doc(user.uid);
      return docRef.snapshots();
    }
    return null;
  }

  /// 全ユーザー情報を取得
  ///
  /// @param なし
  /// @return なし
  Future<void> fetchAllUsers() async {
    final collectionRef = _firestore.collection(FirebaseChatUser().users);
    final querySnapshot = await collectionRef.get();
    final queryDocSnapshot = querySnapshot.docs;

    // 各ユーザー情報をallUsersに保存
    for (final snapshot in queryDocSnapshot) {
      final data = snapshot.data();
      final String uid = snapshot.id;
      final String email = data[FirebaseChatUser().email];
      final String profileImageUrl = data[FirebaseChatUser().profileImageUrl];
      final int point = data[FirebaseChatUser().point];
      final String username = data[FirebaseChatUser().username];
      final String age = data[FirebaseChatUser().age];
      final String address = data[FirebaseChatUser().address];
      final bool isStore = data[FirebaseChatUser().isStore];
      final bool isOwner = data[FirebaseChatUser().isOwner];
      final String os = data[FirebaseChatUser().os];
      final user = ChatUser(uid: uid, email: email, profileImageUrl: profileImageUrl, point: point, username: username, age: age, address: address, isStore: isStore, isOwner: isOwner, os: os);
      allUsers.add(user);
    }
  }

  /// 全ユーザー情報をポイントが高い順に並べて取得
  ///
  /// @param なし
  /// @return 全ユーザー（ポイントが高い順）
  Stream<List<ChatUser>>? fetchAllUsersOrderByMoney() {
    final user = _auth.currentUser;
    if (user != null) {
      final collectionRef = _firestore
          .collection(FirebaseChatUser().users)
          .orderBy(FirebaseChatUser().point, descending: true);
      final stream = collectionRef.snapshots();
      return stream.map((snapshot) =>
          snapshot.docs.map((doc) => ChatUser.fromMap(doc.data())).toList());
    }
    return null;
  }

  /// 全お知らせを取得
  ///
  /// @param なし
  /// @return 全お知らせ
  Stream<List<NotificationModel>>? fetchNotifications() {
    final user = _auth.currentUser;
    if (user != null) {
      final collectionRef = _firestore
          .collection(FirebaseNotification().notifications)
          .doc(user.uid)
          .collection(FirebaseNotification().notification);
      final stream = collectionRef.snapshots();
      return stream.map((snapshot) =>
          snapshot.docs.map((doc) => NotificationModel.fromMap(doc.data())).toList());
    }
    return null;
  }

  /// ユーザー情報を更新
  ///
  /// @param
  /// - doc ドキュメント
  /// - data 更新データ
  /// @return なし
  Future<void> updateUser(String doc, Map<String, dynamic> data) async {
    await _firestore.collection(FirebaseChatUser().users)
        .doc(doc).update(data);
  }
}