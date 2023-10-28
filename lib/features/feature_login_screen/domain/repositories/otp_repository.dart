import 'package:movie_chi/features/feature_login_screen/data/models/user_login_model.dart';
import 'package:movie_chi/features/feature_login_screen/data/models/user_login_params.dart';

import '../../../../core/resources/data_state.dart';
import '../../data/models/otp_phone_model.dart';

abstract class OTPRepository {
  // send
  Future<DataState<OTPModel>> sendCode(String phoneNumber);

  // validate
  Future<DataState<OTPModel>> validateCode(String code, String phoneNumber);

  // login user
  Future<DataState<UserLoginModel>> loginUser(UserLoginParams loginParams);
}
