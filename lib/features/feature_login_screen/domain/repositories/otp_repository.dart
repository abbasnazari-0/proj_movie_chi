import 'package:movie_chi/core/params/check_device_status.dart';
import 'package:movie_chi/features/feature_login_screen/data/models/request_device_model.dart';
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

  // request a new device
  Future<DataState<RequestDeviceModel>> requestNewDevice(String loginParams);

  // check a device status
  Future<DataState<RequestDeviceModel>> checkDeviceStatus(
      CheckDeviceStatusParams checkDeviceStatus);

  // submit a device status
  Future<DataState<RequestDeviceModel>> submitDeviceStatus(
      CheckDeviceStatusParams checkDeviceStatus);
}
