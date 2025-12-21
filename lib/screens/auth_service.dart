// lib/auth_service.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // إضافة Firestore

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance; // متغير للوصول إلى Firestore

  /// دالة التسجيل (Sign Up)
  static Future<User?> signUp(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // إذا نجحت العملية، نُرجع بيانات المستخدم
      return result.user;
    } on FirebaseAuthException catch (e) {
      print("Firebase Sign Up Error: ${e.code} - ${e.message}");
      return null;
    } catch (e) {
      print("General Sign Up Error: $e");
      return null;
    }
  }

  /// دالة الدخول (Sign In)
  static Future<User?> signIn(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } on FirebaseAuthException catch (e) {
      print("Firebase Sign In Error: ${e.code} - ${e.message}");
      return null;
    } catch (e) {
      print("General Sign In Error: $e");
      return null;
    }
  }

  
  static Future<void> savePersonalData({
    required User user,
    required String name,
    required String age,
    required String contactNumber,
    required String location,
  }) async {
    try {
      await _firestore.collection('users').doc(user.uid).set({
        'uid': user.uid,
        'email': user.email,
        'name': name,
        'age': age,
        'contactNumber': contactNumber,
        'location': location,
        'createdAt': FieldValue.serverTimestamp(), // لتسجيل وقت الإنشاء
      });
      print("Personal data saved successfully for user: ${user.uid}");
    } catch (e) {
      print("Error saving personal data: $e");
      throw Exception('Failed to save personal data to Firestore');
    }
  }
}