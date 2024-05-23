import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

class ViewModel {
  final picker = ImagePicker();
  bool isLoading = false;
  File? imageFile;

  // DB
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
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
  // final emailController = TextEditingController();
  // final passwordController = TextEditingController();
  // final usernameController = TextEditingController();
  // final ageController = TextEditingController();
  // final addressController = TextEditingController();

  /// Loadingの開始と終了
  void startLoading() {
    isLoading = true;
    // notifyListeners();
  }
  void endLoading() {
    isLoading = false;
    // notifyListeners();
  }

  /// 各データのセット
  // void setEmail(String? email) {
  //   this.email = email;
  //   notifyListeners();
  // }
  // void setPassword(String? password) {
  //   this.password = password;
  //   notifyListeners();
  // }
  // void setUsername(String? username) {
  //   this.username = username;
  //   notifyListeners();
  // }
  // void setProfileImageUrl(String? profileImageUrl) {
  //   this.profileImageUrl = profileImageUrl;
  //   notifyListeners();
  // }
  // void setAge(String? age) {
  //   this.age = age;
  //   notifyListeners();
  // }
  // void setAddress(String? address) {
  //   this.address = address;
  //   notifyListeners();
  // }

  /// サインアップ
  ///
  /// @param なし
  /// @return なし
  Future<void> signUp() async {
    print(email);
    print(password);
    print(username);
    print(age);
    print(address);
    print(profileImageUrl);
    // this.email = emailController.text;
    // this.password = passwordController.text;

    // firebase authでユーザー作成
    if (email != null && password != null) {
      final userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email!, password: password!);
      final user = userCredential.user;

      // FirebaseFirestoreに追加
      if (user != null) {
        final uid = user.uid;

        final doc = FirebaseFirestore.instance.collection('users').doc(uid);
        await doc.set({
          'uid': uid,
          'email': email,
          'profileImageUrl;': profileImageUrl,
          'age': age,
          'address': address,
        });
      }
    }
  }

  /// ImagePickerを開く
  ///
  /// @param なし
  /// @return なし
  // Future pickImage() async {
  //   final pickedFile = await picker.pickImage(source: ImageSource.gallery);
  //
  //   if (pickedFile != null) {
  //     profileImageUrl = pickedFile.path;
  //     imageFile = File(pickedFile.path);
  //   }
  // }
}