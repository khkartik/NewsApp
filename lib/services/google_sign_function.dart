import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:river_pod/providers/providers.dart';

final firebaseAuthProvider = Provider<FirebaseAuth>(
  (ref) => FirebaseAuth.instance,
);
final googleSignInProvider = Provider<GoogleSignIn>((ref) => GoogleSignIn());

final googleSignInHandler = Provider<GoogleSignInHandler>((ref) {
  final auth = ref.watch(firebaseAuthProvider);
  final googleSignIn = ref.watch(googleSignInProvider);
  return GoogleSignInHandler(auth: auth, googleSignIn: googleSignIn, ref: ref);
});

class GoogleSignInHandler {
  final FirebaseAuth auth;
  final GoogleSignIn googleSignIn;
  final Ref ref;

  GoogleSignInHandler({
    required this.auth,
    required this.googleSignIn,
    required this.ref,
  });

  Future<bool> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) return false;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );

      final userCredential = await auth.signInWithCredential(credential);
      final user = userCredential.user;

      if (user != null) {
        // Use Riverpod's addAccountProvider to add the user to Supabase
        await ref.read(
          addAccountProvider({
            "uid": user.uid,
            "name": user.displayName ?? "",
            "email": user.email ?? "",
          }).future,
        );
      }

      return true;
    } catch (e) {
      print("⚠️ Google Sign-In Error: $e");
      return false;
    }
  }

  Future<void> signOut() async {
    await googleSignIn.signOut();
    await auth.signOut();
  }
}
