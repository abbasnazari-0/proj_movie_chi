import 'package:movie_chi/core/resources/data_state.dart';
import 'package:movie_chi/features/feature_login_screen/data/models/otp_phone_model.dart';
import 'package:movie_chi/features/feature_login_screen/data/models/user_login_model.dart';
import 'package:movie_chi/features/feature_login_screen/data/models/user_login_params.dart';

import '../repositories/otp_repository.dart';

class OTPUseCase {
  final OTPRepository otpRepository;

  OTPUseCase(this.otpRepository);

  Future<DataState<OTPModel>> sendCode(String mobile) async {
    return await otpRepository.sendCode(mobile);
  }

  Future<DataState<OTPModel>> validateCode(String code, String mobile) async {
    return await otpRepository.validateCode(code, mobile);
  }

  Future<DataState<UserLoginModel>> loginUser(
      UserLoginParams loginParams) async {
    return await otpRepository.loginUser(loginParams);
  }
}
