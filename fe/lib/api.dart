// ignore_for_file: type_literal_in_constant_pattern

import 'dart:async';
import 'dart:convert';
import 'package:chopper/chopper.dart';
import 'package:json_annotation/json_annotation.dart' hide JsonConverter;

part 'api.g.dart';
part 'api.chopper.dart';

const login = "piotr";

@JsonSerializable()
class UserRes {
  final String login;
  final String name;
  @JsonKey(name: 'image_url')
  final String imageUrl;

  UserRes({required this.login, required this.name, required this.imageUrl});

  factory UserRes.fromJson(Map<String, dynamic> json) =>
      _$UserResFromJson(json);
  Map<String, dynamic> toJson() => _$UserResToJson(this);
}

@JsonSerializable()
class SwipeRes {
  final bool matched;

  SwipeRes({required this.matched});

  factory SwipeRes.fromJson(Map<String, dynamic> json) =>
      _$SwipeResFromJson(json);
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

@JsonSerializable()
class ScenarioInfoRes {
  final int id;
  final String title;
  @JsonKey(name: "image_url")
  final String imageUrl;
  final String description;

  ScenarioInfoRes({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.description,
  });

  factory ScenarioInfoRes.fromJson(Map<String, dynamic> json) =>
      _$ScenarioInfoResFromJson(json);
  Map<String, dynamic> toJson() => _$ScenarioInfoResToJson(this);
}

@JsonSerializable()
class StepInfoRes {
  final int id;
  final double lat;
  final double long;

  StepInfoRes({required this.id, required this.lat, required this.long});

  factory StepInfoRes.fromJson(Map<String, dynamic> json) =>
      _$StepInfoResFromJson(json);
  Map<String, dynamic> toJson() => _$StepInfoResToJson(this);
}

sealed class Step {
  Step();

  factory Step.fromJson(Map<String, dynamic> json) => switch (json["type"]) {
    "question" => Question.fromJson(json),
    "task" => Task.fromJson(json),
    _ => throw Exception("Invalid step type ${json['type']}"),
  };
}

@JsonSerializable()
class Question extends Step {
  final int id;
  final String type;
  final double lat;
  final double long;
  @JsonKey(name: 'image_url')
  final String imageUrl;
  final String question;
  final List<String> answers;
  final int validAnswerIndex;
  final String curiocity;

  Question({
    required this.id,
    required this.type,
    required this.lat,
    required this.long,
    required this.imageUrl,
    required this.question,
    required this.answers,
    required this.validAnswerIndex,
    required this.curiocity,
  });

  factory Question.fromJson(Map<String, dynamic> json) =>
      _$QuestionFromJson(json);
  Map<String, dynamic> toJson() => _$QuestionToJson(this);
}

@JsonSerializable()
class Task extends Step {
  final int id;
  final String type;
  final double lat;
  final double long;
  @JsonKey(name: 'image_url')
  final String imageUrl;
  final String task;
  final String curiocity;

  Task({
    required this.id,
    required this.type,
    required this.lat,
    required this.long,
    required this.imageUrl,
    required this.task,
    required this.curiocity,
  });

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);
  Map<String, dynamic> toJson() => _$TaskToJson(this);
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

  // Scenarios endpoints
  @GET(path: '/scenarios/')
  Future<Response<List<ScenarioInfoRes>>> getScenarios();

  @GET(path: '/scenarios/{id}/steps/')
  Future<Response<List<StepInfoRes>>> getScenarioSteps(@Path('id') int id);

  @GET(path: '/scenarios/{id}/steps/{stepId}')
  Future<Response<Step>> getStep(
    @Path('id') int id,
    @Path('stepId') int stepId,
  );
}

class ApiConverter extends JsonConverter {
  const ApiConverter();

  @override
  FutureOr<Response<BodyType>> convertResponse<BodyType, SingleItemType>(
    Response response,
  ) {
    // Don't call super - handle the conversion ourselves
    final rawBody = response.body;

    if (rawBody == null) {
      return Response(response.base, null, error: response.error);
    }

    // Parse JSON string if needed
    dynamic jsonBody;
    if (rawBody is String) {
      try {
        jsonBody = json.decode(rawBody);
      } catch (e) {
        return Response(response.base, null, error: e);
      }
    } else {
      jsonBody = rawBody;
    }

    final convertedBody =
        switch (BodyType) {
              UserRes => UserRes.fromJson(jsonBody),
              SwipeRes => SwipeRes.fromJson(jsonBody),
              Item => Item.fromJson(jsonBody),
              ScenarioInfoRes => ScenarioInfoRes.fromJson(jsonBody),
              StepInfoRes => StepInfoRes.fromJson(jsonBody),
              Question => Question.fromJson(jsonBody),
              Task => Task.fromJson(jsonBody),
              Step => Step.fromJson(jsonBody),
              const (List<UserRes>) =>
                (jsonBody as List)
                    .map((item) => UserRes.fromJson(item))
                    .toList(),
              const (List<ScenarioInfoRes>) =>
                (jsonBody as List)
                    .map((item) => ScenarioInfoRes.fromJson(item))
                    .toList(),
              const (List<StepInfoRes>) =>
                (jsonBody as List)
                    .map((item) => StepInfoRes.fromJson(item))
                    .toList(),
              const (Map<String, Item>) =>
                (jsonBody as Map<String, dynamic>).map(
                  (key, value) => MapEntry(key, Item.fromJson(value)),
                ),
              _ => super.convertResponse<BodyType, SingleItemType>(response),
            }
            as BodyType;

    return Response(response.base, convertedBody, error: response.error);
  }
}

class ApiClient {
  late final ChopperClient _chopperClient;
  late final ApiService _apiService;

  ApiClient({String? baseUrl}) {
    _chopperClient = ChopperClient(
      baseUrl: Uri.parse(baseUrl ?? 'http://192.168.1.10:8000'),
      services: [ApiService.create()],
      converter: const ApiConverter(),
      interceptors: [HttpLoggingInterceptor(), HeadersInterceptor()],
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
  FutureOr<Response<BodyType>> intercept<BodyType>(
    Chain<BodyType> chain,
  ) async {
    final request = chain.request.copyWith(
      headers: {
        ...chain.request.headers,
        'Content-Type': 'application/json',
        "X-Login": login,
      },
    );
    return chain.proceed(request);
  }
}
