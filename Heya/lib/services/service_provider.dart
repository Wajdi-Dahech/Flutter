import 'dart:io';

import 'package:chopper/chopper.dart';
import 'package:chopper/src/interceptor.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutterapp/api/post_api_service.dart';
import 'package:flutterapp/api/user_api_service.dart';
import 'package:flutterapp/config/global_variables.dart';

class ServiceProvider {
  ChopperClient chopperClient;
  String authToken;

  void initServices() {
    chopperClient = ChopperClient(
      baseUrl: BASE_URL,
      interceptors: [
        HeadersInterceptor({'Authorization': "Bearer ${USER_TOKEN}"}),
        HttpLoggingInterceptor()
      ],
      services: [
        // inject the generated service
        PostApiService.create(),
        UserApiService.create(),
      ],
    );
  }

  ChopperClient getChopper() {
    if (chopperClient == null) {
      initServices();
    }
    return chopperClient;
  }
}
