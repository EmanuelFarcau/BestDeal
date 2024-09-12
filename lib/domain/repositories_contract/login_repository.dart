import 'package:firebase_auth/firebase_auth.dart';

import 'package:dartz/dartz.dart';

import 'package:deal_hunter/core/errors/failures.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class LoginRepository {
  Future<Either<Failure, UserCredential>> loginWithGoogle();

  Future<Either<Failure,AuthResponse>> googleSignIn() ;
}
