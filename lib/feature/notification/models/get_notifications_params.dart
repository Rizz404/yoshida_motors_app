import 'package:equatable/equatable.dart';

class GetNotificationsParams extends Equatable {
  final int? perPage;
  final String? cursor;

  const GetNotificationsParams({this.perPage, this.cursor});

  Map<String, dynamic> toQueryParams() {
    return <String, dynamic>{
      if (perPage != null) 'per_page': perPage,
      if (cursor != null) 'cursor': cursor,
    };
  }

  GetNotificationsParams copyWith({int? perPage, String? cursor}) {
    return GetNotificationsParams(
      perPage: perPage ?? this.perPage,
      cursor: cursor ?? this.cursor,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [perPage, cursor];
}
