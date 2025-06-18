import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../presentation/providers/global_loading_provider.dart';

class GlobalLoadingInterceptor extends Interceptor {
  final WidgetRef ref;

  GlobalLoadingInterceptor(this.ref);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    ref.read(globalLoadingProvider.notifier).state = true;
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    ref.read(globalLoadingProvider.notifier).state = false;
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    ref.read(globalLoadingProvider.notifier).state = false;
    super.onError(err, handler);
  }
}
