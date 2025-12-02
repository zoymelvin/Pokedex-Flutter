import 'package:dio/dio.dart';
import 'package:pokedex/data/state/remote_state.dart';

const String imageUrl =
    'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/';

class DioApiClient {
  // create dio singleton instance
  static final DioApiClient _instance = DioApiClient._internal();
  factory DioApiClient() {
    return _instance;
  }
  DioApiClient._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: 'https://pokeapi.co/api/v2',
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        preserveHeaderCase: false,
        responseType: ResponseType.json,
        contentType: 'application/json',
        validateStatus: (status) {
          return status != null && status >= 200 && status < 400;
        },
        receiveDataWhenStatusError: true,
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onError: (error, handler) {
          _dioErorrHandler(error);
          return handler.next(error);
        },
      ),
    );
  }

  _dioErorrHandler(DioException error) {
    return RemoteStateError('${error.message}');
  }

  late final Dio _dio;
  Dio get dio => _dio;
}