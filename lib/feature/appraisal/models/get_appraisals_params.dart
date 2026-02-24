// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:car_rongsok_app/core/enums/model_entity_enums.dart';

class GetAppraisalsParams extends Equatable {
  final String? search;
  final AppraisalStatus? status;
  final int? yearMin;
  final int? yearMax;
  final String? sortBy;
  final String? sortDir;
  final int? perPage;
  final String? cursor;

  const GetAppraisalsParams({
    this.search,
    this.status,
    this.yearMin,
    this.yearMax,
    this.sortBy,
    this.sortDir,
    this.perPage,
    this.cursor,
  });

  Map<String, dynamic> toQueryParams() {
    return <String, dynamic>{
      if (search != null) 'search': search,
      if (status != null) 'status': status!.value,
      if (yearMin != null) 'year_min': yearMin,
      if (yearMax != null) 'year_max': yearMax,
      if (sortBy != null) 'sort_by': sortBy,
      if (sortDir != null) 'sort_dir': sortDir,
      if (perPage != null) 'per_page': perPage,
      if (cursor != null) 'cursor': cursor,
    };
  }

  GetAppraisalsParams copyWith({
    String? search,
    AppraisalStatus? status,
    int? yearMin,
    int? yearMax,
    String? sortBy,
    String? sortDir,
    int? perPage,
    String? cursor,
  }) {
    return GetAppraisalsParams(
      search: search ?? this.search,
      status: status ?? this.status,
      yearMin: yearMin ?? this.yearMin,
      yearMax: yearMax ?? this.yearMax,
      sortBy: sortBy ?? this.sortBy,
      sortDir: sortDir ?? this.sortDir,
      perPage: perPage ?? this.perPage,
      cursor: cursor ?? this.cursor,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [
    search,
    status,
    yearMin,
    yearMax,
    sortBy,
    sortDir,
    perPage,
    cursor,
  ];
}
