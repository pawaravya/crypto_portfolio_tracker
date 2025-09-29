import 'package:flutter/material.dart';

/// basic api service
abstract class BaseApiServices {
  Future<dynamic> generateGetAPIResponse(BuildContext context, String uri);
}
