import 'package:dartz/dartz.dart';
import 'package:deal_hunter/domain/repositories_contract/login_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:deal_hunter/core//utils/constants.dart';
import 'package:deal_hunter/core/errors/failures.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supa;

@Singleton(as: LoginRepository)
class LoginRepositoryImpl extends LoginRepository {

  @override
  Future<Either<Failure, UserCredential>> loginWithGoogle() async {

    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    if (googleUser == null) {
      return const Left(FirebaseFailure(AppString.failedToLoginText));
    } else {
      final GoogleSignInAuthentication googleAuth =
      await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      return Right(userCredential);
    }
  }

  @override
  Future<Either<Failure, supa.AuthResponse>> googleSignIn() async {

    const webClientId = AppKeys.webClientId;

    const iosClientId = AppKeys.iosClientId;

    final GoogleSignIn googleSignIn = GoogleSignIn(
      clientId: iosClientId,
      serverClientId: webClientId,
    );
    final googleUser = await googleSignIn.signIn();
    final googleAuth = await googleUser!.authentication;
    final accessToken = googleAuth.accessToken;
    final idToken = googleAuth.idToken;

    if (accessToken == null) {
      throw 'No Access Token found.';
    }
    if (idToken == null) {
      throw 'No ID Token found.';
    }

    final clientToken = await supa.Supabase.instance.client.auth.signInWithIdToken(
      provider: supa.OAuthProvider.google,
      idToken: idToken,
      accessToken: accessToken,
    );
    return Right(clientToken);
  }

}
