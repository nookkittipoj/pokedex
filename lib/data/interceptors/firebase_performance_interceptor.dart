import 'package:dio/dio.dart';
import 'package:firebase_performance/firebase_performance.dart';

class FirebasePerformanceInterceptor extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final method = _getHttpMethod(options.method);

    final httpMetric = FirebasePerformance.instance.newHttpMetric(
      options.uri.toString(),
      method,
    );

    await httpMetric.start();

    final requestType = _getRequestType(options.uri);
    httpMetric.putAttribute('request_type', requestType);

    options.extra['firebase_metric'] = httpMetric;

    handler.next(options); // use handler instead of super for proper chaining
  }

  @override
  void onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) async {
    final metric =
        response.requestOptions.extra['firebase_metric'] as HttpMetric?;

    if (metric != null) {
      print("response.statusCode: ${response.statusCode}");
      try {
        metric
          ..httpResponseCode = response.statusCode ?? 0
          ..responseContentType =
              response.headers.map['content-type']?.join(', ') ?? 'unknown'
          ..responsePayloadSize = _getPayloadSize(response.data);
        await metric.stop();
      } catch (_) {}
    }

    handler.next(response);
  }

  @override
  void onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final metric = err.requestOptions.extra['firebase_metric'] as HttpMetric?;

    if (metric != null) {
      try {
        metric
          ..httpResponseCode = err.response?.statusCode ?? 0
          ..responsePayloadSize = _getPayloadSize(err.response?.data);
        await metric.stop();
      } catch (_) {}
    }

    handler.next(err);
  }

  HttpMethod _getHttpMethod(String method) {
    switch (method.toUpperCase()) {
      case 'GET':
        return HttpMethod.Get;
      case 'POST':
        return HttpMethod.Post;
      case 'PUT':
        return HttpMethod.Put;
      case 'DELETE':
        return HttpMethod.Delete;
      case 'PATCH':
        return HttpMethod.Patch;
      case 'HEAD':
        return HttpMethod.Head;
      case 'OPTIONS':
        return HttpMethod.Options;
      default:
        return HttpMethod.Get; // fallback to avoid crashes
    }
  }

  String _getRequestType(Uri uri) {
    final path = uri.path;
    if (path == '/api/v2/pokemon' &&
        uri.queryParameters.containsKey('offset')) {
      return 'list';
    } else if (path.startsWith('/api/v2/pokemon/') && !path.endsWith('/')) {
      return 'detail';
    } else {
      return 'other';
    }
  }

  int _getPayloadSize(dynamic data) {
    try {
      if (data == null) return 0;
      if (data is String) return data.length;
      return data.toString().length;
    } catch (_) {
      return 0;
    }
  }
}
