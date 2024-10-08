import 'package:http/http.dart';

/// A mixin that provides a method to retry a request.
mixin class RetryRequestMixin {
  /// Retries the request.
  Future<StreamedResponse> retryRequest(
    StreamedResponse response, [
    Client? client,
  ]) async {
    final oldRequest = response.request;
    final $client = client ?? Client();

    if (oldRequest is Request) {
      final newRequest = Request(
        oldRequest.method,
        oldRequest.url,
      );

      newRequest.headers.addAll(oldRequest.headers);
      newRequest.followRedirects = oldRequest.followRedirects;
      newRequest.maxRedirects = oldRequest.maxRedirects;
      newRequest.persistentConnection = oldRequest.persistentConnection;
      newRequest.bodyBytes = oldRequest.bodyBytes;

      final response = await $client.send(newRequest);
      return response;
    }

    if (oldRequest is MultipartRequest) {
      final newRequest = MultipartRequest(
        oldRequest.method,
        oldRequest.url,
      );

      newRequest.headers.addAll(oldRequest.headers);
      newRequest.followRedirects = oldRequest.followRedirects;
      newRequest.maxRedirects = oldRequest.maxRedirects;
      newRequest.persistentConnection = oldRequest.persistentConnection;

      for (final field in oldRequest.fields.entries) {
        newRequest.fields[field.key] = field.value;
      }

      newRequest.files.addAll(oldRequest.files);

      final response = await $client.send(newRequest);
      return response;
    }

    throw ArgumentError('Unknown request type: ${oldRequest.runtimeType}');
  }
}
