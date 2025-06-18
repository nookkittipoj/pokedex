import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../interceptors/global_loading_interceptor.dart';

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio();
  dio.interceptors.add(GlobalLoadingInterceptor(ref as WidgetRef));
  return dio;
});
