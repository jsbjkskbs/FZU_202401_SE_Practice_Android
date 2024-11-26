import 'package:dio/dio.dart';
import 'package:fulifuli_app/generated/l10n.dart';
import 'package:fulifuli_app/global.dart';
import 'package:fulifuli_app/utils/toastification.dart';

class DioHttpErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response == null) {
      ToastificationUtils.showSimpleToastification(S.current.when_internet_error);
    }
    if (err.response?.statusCode != 200) {
      ToastificationUtils.showSimpleToastification(S.current.when_internet_error0(err.response!.statusCode!));
    }
    super.onError(err, handler);
  }
}

class DioHttpResponseInterceptor extends Interceptor {
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (response.toString() == "null") {
      super.onResponse(response, handler);
      return;
    }
    if (response.data["code"] == null) {
      ToastificationUtils.showSimpleToastification(S.current.when_server_error);
    }
    if (response.data["code"] != Global.successCode) {
      ToastificationUtils.showSimpleToastification(response.data["msg"]);
    }
    super.onResponse(response, handler);
  }
}
