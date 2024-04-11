import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;

import '../../core/constants/variables.dart';
import '../models/requests/user_request_model.dart';
import '../models/responses/user_response_model.dart';
import 'auth_local_datasource.dart';

class UserRemoteDatasource {
  Future<Either<String, UserResponseModel>> getUser() async {
    try {
      final authData = await AuthLocalDatasource().getAuthData();
      final response = await http.get(
        Uri.parse('${Variables.baseUrl}/api/users'),
        headers: {
          'Authorization': 'Bearer ${authData!.accessToken}',
          'Accept': 'application/json',
          'Content-type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        return Right(UserResponseModel.fromJson(response.body));
      } else {
        return const Left('Error');
      }
    } catch (e) {
      return const Left('Error');
    }
  }

  Future<bool> hasAddress() async {
    final userEither = await getUser();
    return userEither.fold(
      (error) => false, // Jika terjadi kesalahan, kembalikan false
      (user) =>
          user.data?.address !=
          null, // Jika alamat ada, kembalikan true, jika tidak, kembalikan false
    );
  }

  Future<Either<String, String>> addAddress(UserRequestModel data) async {
    try {
      final authData = await AuthLocalDatasource().getAuthData();
      final response = await http.post(
        Uri.parse('${Variables.baseUrl}/api/users/update'),
        headers: {
          'Authorization': 'Bearer ${authData!.accessToken}',
          'Accept': 'application/json',
          'Content-type': 'application/json',
        },
        body: data.toJson(),
      );
      if (response.statusCode == 201) {
        return const Right('Success');
      } else {
        return const Left('Error');
      }
    } catch (e) {
      return const Left('Error');
    }
  }
}
