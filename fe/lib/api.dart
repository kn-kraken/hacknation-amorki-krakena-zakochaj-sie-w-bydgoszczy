import 'dart:async';
import 'package:chopper/chopper.dart';
import 'package:json_annotation/json_annotation.dart' hide JsonConverter;

part 'api.g.dart';
part 'api.chopper.dart';

@JsonSerializable()
class UserRes {
  final String login;
  final String name;
  @JsonKey(name: 'image_url')
  final String imageUrl;

  UserRes({
    required this.login,
    required this.name,
    required this.imageUrl,
  });

  factory UserRes.fromJson(Map<String, dynamic> json) => _$UserResFromJson(json);
  Map<String, dynamic> toJson() => _$UserResToJson(this);
}

@JsonSerializable()
class SwipeRes {
  final bool matched;

  SwipeRes({required this.matched});

  factory SwipeRes.fromJson(Map<String, dynamic> json) => _$SwipeResFromJson(json);
  Map<String, dynamic> toJson() => _$SwipeResToJson(this);
}

@JsonSerializable()
class Item {
  final String name;
  @JsonKey(name: 'item_id')
  final String? itemId;

  Item({required this.name, this.itemId});

  factory Item.fromJson(Map<String, dynamic> json) => _$ItemFromJson(json);
  Map<String, dynamic> toJson() => _$ItemToJson(this);
}

@ChopperApi()
abstract class ApiService extends ChopperService {
  static ApiService create([ChopperClient? client]) => _$ApiService(client);

  // Users endpoints
  @GET(path: '/users/')
  Future<Response<List<UserRes>>> getUsers();

  @GET(path: '/users/me')
  Future<Response<UserRes>> getMe();

  @GET(path: '/users/next')
  Future<Response<UserRes>> getNextUser();

  @PUT(path: '/users/{login}/swipe')
  Future<Response<SwipeRes>> swipeUser(
    @Path('login') String login,
    @Query('approved') bool approved,
  );

  // Items endpoints
  @GET(path: '/items/')
  Future<Response<Map<String, Item>>> getItems();

  @GET(path: '/items/{itemId}')
  Future<Response<Item>> getItem(@Path('itemId') String itemId);

  @PUT(path: '/items/{itemId}')
  Future<Response<Item>> updateItem(@Path('itemId') String itemId);

  // Blobs endpoints
  @GET(path: '/blobs/{hash}')
  Future<Response> getBlob(@Path('hash') String hash);
}

class ApiClient {
  late final ChopperClient _chopperClient;
  late final ApiService _apiService;

  ApiClient({String? baseUrl}) {
    _chopperClient = ChopperClient(
      baseUrl: Uri.parse(baseUrl ?? 'http://localhost:8000'),
      services: [ApiService.create()],
      converter: const JsonConverter(),
      interceptors: [
        HttpLoggingInterceptor(),
        HeadersInterceptor(),
      ],
    );
    _apiService = _chopperClient.getService<ApiService>();
  }

  ApiService get api => _apiService;

  void dispose() {
    _chopperClient.dispose();
  }
}

class HeadersInterceptor implements Interceptor {
  @override
  FutureOr<Response<BodyType>> intercept<BodyType>(Chain<BodyType> chain) async {
    final request = chain.request.copyWith(
      headers: {
        ...chain.request.headers,
        'Content-Type': 'application/json',
      },
    );
    return chain.proceed(request);
  }
}
