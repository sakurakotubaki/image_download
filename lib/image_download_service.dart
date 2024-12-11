import 'package:dio/dio.dart';
import 'api_response.dart';

class ImageDownloadService {
  final Dio _dio = Dio();

  Future<ApiResponse<List<int>>> downloadImage(String url) async {
    try {
      final response = await _dio.get<List<int>>(
        url,
        options: Options(responseType: ResponseType.bytes),
      );
      
      return Success(response.data!);
    } on DioException catch (e) {
      switch (e.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return const Failure('接続がタイムアウトしました');
        case DioExceptionType.connectionError:
          return const Failure('インターネット接続がありません');
        case DioExceptionType.badResponse:
          return Failure('サーバーエラー: ${e.response?.statusCode}');
        default:
          return Failure('ダウンロードに失敗しました: ${e.message}');
      }
    } catch (e) {
      return Failure('予期せぬエラーが発生しました: $e');
    }
  }
}
