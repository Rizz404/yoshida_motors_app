/// Base sealed class.
/// T adalah tipe data model kamu (misal: User, Product).
sealed class ApiResult<T> {
  const ApiResult();

  /// Factory magic buat auto-detect response dari JSON
  factory ApiResult.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) {
    // 1. Cek status sukses/gagal dari key 'success'
    final isSuccess = json['success'] as bool? ?? false;

    if (!isSuccess) {
      return ApiFailure.fromJson(json);
    }

    // 2. Cek apakah ini Cursor Pagination (ada key 'meta' & 'next_cursor')
    if (json.containsKey('meta') && json['meta'] != null) {
      return ApiCursorSuccess.fromJson(json, fromJsonT);
    }

    // 3. Kalau sukses biasa (Single Data atau List biasa tanpa cursor)
    return ApiSuccess.fromJson(json, fromJsonT);
  }
}

// ==========================================
// 1. SUCCESS RESPONSE (Biasa)
// ==========================================
class ApiSuccess<T> extends ApiResult<T> {
  final T data;
  final String message;

  const ApiSuccess({required this.data, required this.message});

  factory ApiSuccess.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) {
    return ApiSuccess(
      data: fromJsonT(json['data']),
      message: json['message'] as String? ?? 'Success',
    );
  }
}

// ==========================================
// 2. CURSOR PAGINATED RESPONSE (Infinite Scroll)
// ==========================================
class ApiCursorSuccess<T> extends ApiResult<T> {
  final List<T> items; // Isinya list data
  final CursorMeta meta; // Isinya info cursor
  final String message;

  const ApiCursorSuccess({
    required this.items,
    required this.meta,
    required this.message,
  });

  factory ApiCursorSuccess.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT, // Decoder untuk item tunggal
  ) {
    return ApiCursorSuccess(
      // Map list data dari JSON ke List<T>
      items: (json['data'] as List<dynamic>).map((e) => fromJsonT(e)).toList(),
      meta: CursorMeta.fromJson(json['meta'] as Map<String, dynamic>),
      message: json['message'] as String? ?? 'Success',
    );
  }
}

// ==========================================
// 3. ERROR / FAILURE RESPONSE
// ==========================================
class ApiFailure<T> extends ApiResult<T> {
  final String message;
  final dynamic
  errors; // Bisa String atau Map<String, List> (Validation errors)

  const ApiFailure({required this.message, this.errors});

  factory ApiFailure.fromJson(Map<String, dynamic> json) {
    return ApiFailure(
      message: json['message'] as String? ?? 'Something went wrong',
      errors: json['errors'],
    );
  }
}

class CursorMeta {
  final int perPage;
  final String? nextCursor; // Kunci utama infinite scroll!
  final String? prevCursor;
  final bool hasMore;

  const CursorMeta({
    required this.perPage,
    this.nextCursor,
    this.prevCursor,
    required this.hasMore,
  });

  factory CursorMeta.fromJson(Map<String, dynamic> json) {
    return CursorMeta(
      perPage: json['per_page'] as int? ?? 15,
      nextCursor: json['next_cursor'] as String?,
      prevCursor: json['prev_cursor'] as String?,
      hasMore: json['has_more'] as bool? ?? false,
    );
  }
}
