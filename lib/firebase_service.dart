import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'dart:developer';


const String __app_id = 'your-default-app-id'; 
const String __firebase_config = '{"apiKey": "", "authDomain": "", "projectId": "", "storageBucket": "", "messagingSenderId": "", "appId": ""}';
const String __initial_auth_token = ''; 

class FirebaseService {
  FirebaseApp? _app;
  FirebaseFirestore? _db;
  FirebaseAuth? _auth;
  String? userId;
  bool isInitialized = false;

  static final FirebaseService _instance = FirebaseService._internal();
  factory FirebaseService() => _instance;
  FirebaseService._internal();

  
  FirebaseFirestore get db {
    if (_db == null) {
      throw Exception("FirebaseFirestore is not initialized. Please ensure main() has called Firebase.initializeApp().");
    }
    return _db!;
  }
  
  FirebaseAuth get auth {
    if (_auth == null) {
      throw Exception("FirebaseAuth is not initialized. Please ensure main() has called Firebase.initializeApp().");
    }
    return _auth!;
  }


  Future<void> initializeFirebase() async {
    if (_app != null) { 
        if (_auth != null) {
            isInitialized = true;
        }
        return;
    }

    try {
      final firebaseConfig = json.decode(__firebase_config) as Map<String, dynamic>;
      
      _app = await Firebase.initializeApp(
        options: FirebaseOptions(
          apiKey: firebaseConfig['apiKey'] ?? '',
          authDomain: firebaseConfig['authDomain'] ?? '',
          projectId: firebaseConfig['projectId'] ?? '',
          storageBucket: firebaseConfig['storageBucket'] ?? '',
          messagingSenderId: firebaseConfig['messagingSenderId'] ?? '',
          appId: firebaseConfig['appId'] ?? '',
        ),
      );

      _db = FirebaseFirestore.instanceFor(app: _app!);
      _auth = FirebaseAuth.instanceFor(app: _app!);

      if (__initial_auth_token.isNotEmpty) {
        await _auth!.signInWithCustomToken(__initial_auth_token);
      } else {
        await _auth!.signInAnonymously(); 
      }

      userId = _auth!.currentUser?.uid;
      isInitialized = true;
      log('Firebase initialized and user signed in: $userId');

    } catch (e) {
      log('Error during Firebase initialization: $e', error: e);
      isInitialized = false; 
    }
  }
  
  
  
  DocumentReference getPrivateDocRef(String collectionName, String docId) {
    if (userId == null) throw Exception('User not authenticated.');
    final appId = __app_id;
    return db.doc('artifacts/$appId/users/$userId/$collectionName/$docId');
  }

  Future<void> savePrivateData(String collectionName, String docId, Map<String, dynamic> data) async {
    
    try {
      final docRef = getPrivateDocRef(collectionName, docId);
      await docRef.set(data, SetOptions(merge: true));
      log('Data saved successfully to $collectionName/$docId.');
    } catch (e) {
      log('Error saving private data: $e', error: e);
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> readPrivateData(String collectionName, String docId) async {
    
    try {
      final docRef = getPrivateDocRef(collectionName, docId);
      final snapshot = await docRef.get();
      if (snapshot.exists) {
        return snapshot.data() as Map<String, dynamic>?; 
      }
      return null;
    } catch (e) {
      log('Error reading private data: $e', error: e);
      return null;
    }
  }
}
