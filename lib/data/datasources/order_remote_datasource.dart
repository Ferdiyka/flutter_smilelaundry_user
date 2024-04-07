import 'package:dartz/dartz.dart';
import 'package:flutter_smilelaundry_user/core/constants/variables.dart';
import 'package:flutter_smilelaundry_user/data/datasources/auth_local_datasource.dart';
import 'package:flutter_smilelaundry_user/data/models/requests/order_request_model.dart';
import 'package:flutter_smilelaundry_user/data/models/responses/order_response_model.dart';
import 'package:http/http.dart' as http;

class OrderRemoterDatasource {
  Future<Either<String, OrderResponseModel>> order(
      OrderRequestModel orderRequestModel) async {
    final authData = await AuthLocalDatasource().getAuthData();
    final response = await http.post(
      Uri.parse('${Variables.baseUrl}/api/order'),
      headers: {
        'Accept': 'application/json',
        'Content-type': 'application/json',
        'Authorization': 'Bearer ${authData!.accessToken}'
      },
      body: orderRequestModel.toJson(),
    );

    if (response.statusCode == 200) {
      return right(OrderResponseModel.fromJson(response.body));
    } else {
      return left('Error');
    }
  }
}
