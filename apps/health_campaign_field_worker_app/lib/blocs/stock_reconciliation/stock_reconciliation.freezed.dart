// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stock_reconciliation.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$StockReconciliationEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(FacilityModel facilityModel, bool isDistributor,
            String loggedInUserId, String? teamCode)
        selectFacility,
    required TResult Function(
            String? productVariantId, bool isDistributor, String loggedInUserId)
        selectProduct,
    required TResult Function(
            DateTime? dateOfReconciliation, String loggedInUserId)
        selectDateOfReconciliation,
    required TResult Function(
            bool isDistributor, String? teamCode, String loggedInUserId)
        calculate,
    required TResult Function(StockReconciliationModel stockReconciliationModel)
        create,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(FacilityModel facilityModel, bool isDistributor,
            String loggedInUserId, String? teamCode)?
        selectFacility,
    TResult? Function(String? productVariantId, bool isDistributor,
            String loggedInUserId)?
        selectProduct,
    TResult? Function(DateTime? dateOfReconciliation, String loggedInUserId)?
        selectDateOfReconciliation,
    TResult? Function(
            bool isDistributor, String? teamCode, String loggedInUserId)?
        calculate,
    TResult? Function(StockReconciliationModel stockReconciliationModel)?
        create,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(FacilityModel facilityModel, bool isDistributor,
            String loggedInUserId, String? teamCode)?
        selectFacility,
    TResult Function(String? productVariantId, bool isDistributor,
            String loggedInUserId)?
        selectProduct,
    TResult Function(DateTime? dateOfReconciliation, String loggedInUserId)?
        selectDateOfReconciliation,
    TResult Function(
            bool isDistributor, String? teamCode, String loggedInUserId)?
        calculate,
    TResult Function(StockReconciliationModel stockReconciliationModel)? create,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(StockReconciliationSelectFacilityEvent value)
        selectFacility,
    required TResult Function(StockReconciliationSelectProductEvent value)
        selectProduct,
    required TResult Function(
            StockReconciliationSelectDateOfReconciliationEvent value)
        selectDateOfReconciliation,
    required TResult Function(StockReconciliationCalculateEvent value)
        calculate,
    required TResult Function(StockReconciliationCreateEvent value) create,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(StockReconciliationSelectFacilityEvent value)?
        selectFacility,
    TResult? Function(StockReconciliationSelectProductEvent value)?
        selectProduct,
    TResult? Function(StockReconciliationSelectDateOfReconciliationEvent value)?
        selectDateOfReconciliation,
    TResult? Function(StockReconciliationCalculateEvent value)? calculate,
    TResult? Function(StockReconciliationCreateEvent value)? create,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(StockReconciliationSelectFacilityEvent value)?
        selectFacility,
    TResult Function(StockReconciliationSelectProductEvent value)?
        selectProduct,
    TResult Function(StockReconciliationSelectDateOfReconciliationEvent value)?
        selectDateOfReconciliation,
    TResult Function(StockReconciliationCalculateEvent value)? calculate,
    TResult Function(StockReconciliationCreateEvent value)? create,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StockReconciliationEventCopyWith<$Res> {
  factory $StockReconciliationEventCopyWith(StockReconciliationEvent value,
          $Res Function(StockReconciliationEvent) then) =
      _$StockReconciliationEventCopyWithImpl<$Res, StockReconciliationEvent>;
}

/// @nodoc
class _$StockReconciliationEventCopyWithImpl<$Res,
        $Val extends StockReconciliationEvent>
    implements $StockReconciliationEventCopyWith<$Res> {
  _$StockReconciliationEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$StockReconciliationSelectFacilityEventImplCopyWith<$Res> {
  factory _$$StockReconciliationSelectFacilityEventImplCopyWith(
          _$StockReconciliationSelectFacilityEventImpl value,
          $Res Function(_$StockReconciliationSelectFacilityEventImpl) then) =
      __$$StockReconciliationSelectFacilityEventImplCopyWithImpl<$Res>;
  @useResult
  $Res call(
      {FacilityModel facilityModel,
      bool isDistributor,
      String loggedInUserId,
      String? teamCode});
}

/// @nodoc
class __$$StockReconciliationSelectFacilityEventImplCopyWithImpl<$Res>
    extends _$StockReconciliationEventCopyWithImpl<$Res,
        _$StockReconciliationSelectFacilityEventImpl>
    implements _$$StockReconciliationSelectFacilityEventImplCopyWith<$Res> {
  __$$StockReconciliationSelectFacilityEventImplCopyWithImpl(
      _$StockReconciliationSelectFacilityEventImpl _value,
      $Res Function(_$StockReconciliationSelectFacilityEventImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? facilityModel = null,
    Object? isDistributor = null,
    Object? loggedInUserId = null,
    Object? teamCode = freezed,
  }) {
    return _then(_$StockReconciliationSelectFacilityEventImpl(
      null == facilityModel
          ? _value.facilityModel
          : facilityModel // ignore: cast_nullable_to_non_nullable
              as FacilityModel,
      isDistributor: null == isDistributor
          ? _value.isDistributor
          : isDistributor // ignore: cast_nullable_to_non_nullable
              as bool,
      loggedInUserId: null == loggedInUserId
          ? _value.loggedInUserId
          : loggedInUserId // ignore: cast_nullable_to_non_nullable
              as String,
      teamCode: freezed == teamCode
          ? _value.teamCode
          : teamCode // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$StockReconciliationSelectFacilityEventImpl
    implements StockReconciliationSelectFacilityEvent {
  const _$StockReconciliationSelectFacilityEventImpl(this.facilityModel,
      {this.isDistributor = false,
      required this.loggedInUserId,
      this.teamCode});

  @override
  final FacilityModel facilityModel;
  @override
  @JsonKey()
  final bool isDistributor;
  @override
  final String loggedInUserId;
  @override
  final String? teamCode;

  @override
  String toString() {
    return 'StockReconciliationEvent.selectFacility(facilityModel: $facilityModel, isDistributor: $isDistributor, loggedInUserId: $loggedInUserId, teamCode: $teamCode)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StockReconciliationSelectFacilityEventImpl &&
            (identical(other.facilityModel, facilityModel) ||
                other.facilityModel == facilityModel) &&
            (identical(other.isDistributor, isDistributor) ||
                other.isDistributor == isDistributor) &&
            (identical(other.loggedInUserId, loggedInUserId) ||
                other.loggedInUserId == loggedInUserId) &&
            (identical(other.teamCode, teamCode) ||
                other.teamCode == teamCode));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, facilityModel, isDistributor, loggedInUserId, teamCode);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$StockReconciliationSelectFacilityEventImplCopyWith<
          _$StockReconciliationSelectFacilityEventImpl>
      get copyWith =>
          __$$StockReconciliationSelectFacilityEventImplCopyWithImpl<
              _$StockReconciliationSelectFacilityEventImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(FacilityModel facilityModel, bool isDistributor,
            String loggedInUserId, String? teamCode)
        selectFacility,
    required TResult Function(
            String? productVariantId, bool isDistributor, String loggedInUserId)
        selectProduct,
    required TResult Function(
            DateTime? dateOfReconciliation, String loggedInUserId)
        selectDateOfReconciliation,
    required TResult Function(
            bool isDistributor, String? teamCode, String loggedInUserId)
        calculate,
    required TResult Function(StockReconciliationModel stockReconciliationModel)
        create,
  }) {
    return selectFacility(
        facilityModel, isDistributor, loggedInUserId, teamCode);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(FacilityModel facilityModel, bool isDistributor,
            String loggedInUserId, String? teamCode)?
        selectFacility,
    TResult? Function(String? productVariantId, bool isDistributor,
            String loggedInUserId)?
        selectProduct,
    TResult? Function(DateTime? dateOfReconciliation, String loggedInUserId)?
        selectDateOfReconciliation,
    TResult? Function(
            bool isDistributor, String? teamCode, String loggedInUserId)?
        calculate,
    TResult? Function(StockReconciliationModel stockReconciliationModel)?
        create,
  }) {
    return selectFacility?.call(
        facilityModel, isDistributor, loggedInUserId, teamCode);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(FacilityModel facilityModel, bool isDistributor,
            String loggedInUserId, String? teamCode)?
        selectFacility,
    TResult Function(String? productVariantId, bool isDistributor,
            String loggedInUserId)?
        selectProduct,
    TResult Function(DateTime? dateOfReconciliation, String loggedInUserId)?
        selectDateOfReconciliation,
    TResult Function(
            bool isDistributor, String? teamCode, String loggedInUserId)?
        calculate,
    TResult Function(StockReconciliationModel stockReconciliationModel)? create,
    required TResult orElse(),
  }) {
    if (selectFacility != null) {
      return selectFacility(
          facilityModel, isDistributor, loggedInUserId, teamCode);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(StockReconciliationSelectFacilityEvent value)
        selectFacility,
    required TResult Function(StockReconciliationSelectProductEvent value)
        selectProduct,
    required TResult Function(
            StockReconciliationSelectDateOfReconciliationEvent value)
        selectDateOfReconciliation,
    required TResult Function(StockReconciliationCalculateEvent value)
        calculate,
    required TResult Function(StockReconciliationCreateEvent value) create,
  }) {
    return selectFacility(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(StockReconciliationSelectFacilityEvent value)?
        selectFacility,
    TResult? Function(StockReconciliationSelectProductEvent value)?
        selectProduct,
    TResult? Function(StockReconciliationSelectDateOfReconciliationEvent value)?
        selectDateOfReconciliation,
    TResult? Function(StockReconciliationCalculateEvent value)? calculate,
    TResult? Function(StockReconciliationCreateEvent value)? create,
  }) {
    return selectFacility?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(StockReconciliationSelectFacilityEvent value)?
        selectFacility,
    TResult Function(StockReconciliationSelectProductEvent value)?
        selectProduct,
    TResult Function(StockReconciliationSelectDateOfReconciliationEvent value)?
        selectDateOfReconciliation,
    TResult Function(StockReconciliationCalculateEvent value)? calculate,
    TResult Function(StockReconciliationCreateEvent value)? create,
    required TResult orElse(),
  }) {
    if (selectFacility != null) {
      return selectFacility(this);
    }
    return orElse();
  }
}

abstract class StockReconciliationSelectFacilityEvent
    implements StockReconciliationEvent {
  const factory StockReconciliationSelectFacilityEvent(
      final FacilityModel facilityModel,
      {final bool isDistributor,
      required final String loggedInUserId,
      final String? teamCode}) = _$StockReconciliationSelectFacilityEventImpl;

  FacilityModel get facilityModel;
  bool get isDistributor;
  String get loggedInUserId;
  String? get teamCode;
  @JsonKey(ignore: true)
  _$$StockReconciliationSelectFacilityEventImplCopyWith<
          _$StockReconciliationSelectFacilityEventImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$StockReconciliationSelectProductEventImplCopyWith<$Res> {
  factory _$$StockReconciliationSelectProductEventImplCopyWith(
          _$StockReconciliationSelectProductEventImpl value,
          $Res Function(_$StockReconciliationSelectProductEventImpl) then) =
      __$$StockReconciliationSelectProductEventImplCopyWithImpl<$Res>;
  @useResult
  $Res call(
      {String? productVariantId, bool isDistributor, String loggedInUserId});
}

/// @nodoc
class __$$StockReconciliationSelectProductEventImplCopyWithImpl<$Res>
    extends _$StockReconciliationEventCopyWithImpl<$Res,
        _$StockReconciliationSelectProductEventImpl>
    implements _$$StockReconciliationSelectProductEventImplCopyWith<$Res> {
  __$$StockReconciliationSelectProductEventImplCopyWithImpl(
      _$StockReconciliationSelectProductEventImpl _value,
      $Res Function(_$StockReconciliationSelectProductEventImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? productVariantId = freezed,
    Object? isDistributor = null,
    Object? loggedInUserId = null,
  }) {
    return _then(_$StockReconciliationSelectProductEventImpl(
      freezed == productVariantId
          ? _value.productVariantId
          : productVariantId // ignore: cast_nullable_to_non_nullable
              as String?,
      isDistributor: null == isDistributor
          ? _value.isDistributor
          : isDistributor // ignore: cast_nullable_to_non_nullable
              as bool,
      loggedInUserId: null == loggedInUserId
          ? _value.loggedInUserId
          : loggedInUserId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$StockReconciliationSelectProductEventImpl
    implements StockReconciliationSelectProductEvent {
  const _$StockReconciliationSelectProductEventImpl(this.productVariantId,
      {this.isDistributor = false, required this.loggedInUserId});

  @override
  final String? productVariantId;
  @override
  @JsonKey()
  final bool isDistributor;
  @override
  final String loggedInUserId;

  @override
  String toString() {
    return 'StockReconciliationEvent.selectProduct(productVariantId: $productVariantId, isDistributor: $isDistributor, loggedInUserId: $loggedInUserId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StockReconciliationSelectProductEventImpl &&
            (identical(other.productVariantId, productVariantId) ||
                other.productVariantId == productVariantId) &&
            (identical(other.isDistributor, isDistributor) ||
                other.isDistributor == isDistributor) &&
            (identical(other.loggedInUserId, loggedInUserId) ||
                other.loggedInUserId == loggedInUserId));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, productVariantId, isDistributor, loggedInUserId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$StockReconciliationSelectProductEventImplCopyWith<
          _$StockReconciliationSelectProductEventImpl>
      get copyWith => __$$StockReconciliationSelectProductEventImplCopyWithImpl<
          _$StockReconciliationSelectProductEventImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(FacilityModel facilityModel, bool isDistributor,
            String loggedInUserId, String? teamCode)
        selectFacility,
    required TResult Function(
            String? productVariantId, bool isDistributor, String loggedInUserId)
        selectProduct,
    required TResult Function(
            DateTime? dateOfReconciliation, String loggedInUserId)
        selectDateOfReconciliation,
    required TResult Function(
            bool isDistributor, String? teamCode, String loggedInUserId)
        calculate,
    required TResult Function(StockReconciliationModel stockReconciliationModel)
        create,
  }) {
    return selectProduct(productVariantId, isDistributor, loggedInUserId);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(FacilityModel facilityModel, bool isDistributor,
            String loggedInUserId, String? teamCode)?
        selectFacility,
    TResult? Function(String? productVariantId, bool isDistributor,
            String loggedInUserId)?
        selectProduct,
    TResult? Function(DateTime? dateOfReconciliation, String loggedInUserId)?
        selectDateOfReconciliation,
    TResult? Function(
            bool isDistributor, String? teamCode, String loggedInUserId)?
        calculate,
    TResult? Function(StockReconciliationModel stockReconciliationModel)?
        create,
  }) {
    return selectProduct?.call(productVariantId, isDistributor, loggedInUserId);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(FacilityModel facilityModel, bool isDistributor,
            String loggedInUserId, String? teamCode)?
        selectFacility,
    TResult Function(String? productVariantId, bool isDistributor,
            String loggedInUserId)?
        selectProduct,
    TResult Function(DateTime? dateOfReconciliation, String loggedInUserId)?
        selectDateOfReconciliation,
    TResult Function(
            bool isDistributor, String? teamCode, String loggedInUserId)?
        calculate,
    TResult Function(StockReconciliationModel stockReconciliationModel)? create,
    required TResult orElse(),
  }) {
    if (selectProduct != null) {
      return selectProduct(productVariantId, isDistributor, loggedInUserId);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(StockReconciliationSelectFacilityEvent value)
        selectFacility,
    required TResult Function(StockReconciliationSelectProductEvent value)
        selectProduct,
    required TResult Function(
            StockReconciliationSelectDateOfReconciliationEvent value)
        selectDateOfReconciliation,
    required TResult Function(StockReconciliationCalculateEvent value)
        calculate,
    required TResult Function(StockReconciliationCreateEvent value) create,
  }) {
    return selectProduct(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(StockReconciliationSelectFacilityEvent value)?
        selectFacility,
    TResult? Function(StockReconciliationSelectProductEvent value)?
        selectProduct,
    TResult? Function(StockReconciliationSelectDateOfReconciliationEvent value)?
        selectDateOfReconciliation,
    TResult? Function(StockReconciliationCalculateEvent value)? calculate,
    TResult? Function(StockReconciliationCreateEvent value)? create,
  }) {
    return selectProduct?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(StockReconciliationSelectFacilityEvent value)?
        selectFacility,
    TResult Function(StockReconciliationSelectProductEvent value)?
        selectProduct,
    TResult Function(StockReconciliationSelectDateOfReconciliationEvent value)?
        selectDateOfReconciliation,
    TResult Function(StockReconciliationCalculateEvent value)? calculate,
    TResult Function(StockReconciliationCreateEvent value)? create,
    required TResult orElse(),
  }) {
    if (selectProduct != null) {
      return selectProduct(this);
    }
    return orElse();
  }
}

abstract class StockReconciliationSelectProductEvent
    implements StockReconciliationEvent {
  const factory StockReconciliationSelectProductEvent(
          final String? productVariantId,
          {final bool isDistributor,
          required final String loggedInUserId}) =
      _$StockReconciliationSelectProductEventImpl;

  String? get productVariantId;
  bool get isDistributor;
  String get loggedInUserId;
  @JsonKey(ignore: true)
  _$$StockReconciliationSelectProductEventImplCopyWith<
          _$StockReconciliationSelectProductEventImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$StockReconciliationSelectDateOfReconciliationEventImplCopyWith<
    $Res> {
  factory _$$StockReconciliationSelectDateOfReconciliationEventImplCopyWith(
          _$StockReconciliationSelectDateOfReconciliationEventImpl value,
          $Res Function(
                  _$StockReconciliationSelectDateOfReconciliationEventImpl)
              then) =
      __$$StockReconciliationSelectDateOfReconciliationEventImplCopyWithImpl<
          $Res>;
  @useResult
  $Res call({DateTime? dateOfReconciliation, String loggedInUserId});
}

/// @nodoc
class __$$StockReconciliationSelectDateOfReconciliationEventImplCopyWithImpl<
        $Res>
    extends _$StockReconciliationEventCopyWithImpl<$Res,
        _$StockReconciliationSelectDateOfReconciliationEventImpl>
    implements
        _$$StockReconciliationSelectDateOfReconciliationEventImplCopyWith<
            $Res> {
  __$$StockReconciliationSelectDateOfReconciliationEventImplCopyWithImpl(
      _$StockReconciliationSelectDateOfReconciliationEventImpl _value,
      $Res Function(_$StockReconciliationSelectDateOfReconciliationEventImpl)
          _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? dateOfReconciliation = freezed,
    Object? loggedInUserId = null,
  }) {
    return _then(_$StockReconciliationSelectDateOfReconciliationEventImpl(
      freezed == dateOfReconciliation
          ? _value.dateOfReconciliation
          : dateOfReconciliation // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      loggedInUserId: null == loggedInUserId
          ? _value.loggedInUserId
          : loggedInUserId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$StockReconciliationSelectDateOfReconciliationEventImpl
    implements StockReconciliationSelectDateOfReconciliationEvent {
  const _$StockReconciliationSelectDateOfReconciliationEventImpl(
      this.dateOfReconciliation,
      {required this.loggedInUserId});

  @override
  final DateTime? dateOfReconciliation;
  @override
  final String loggedInUserId;

  @override
  String toString() {
    return 'StockReconciliationEvent.selectDateOfReconciliation(dateOfReconciliation: $dateOfReconciliation, loggedInUserId: $loggedInUserId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StockReconciliationSelectDateOfReconciliationEventImpl &&
            (identical(other.dateOfReconciliation, dateOfReconciliation) ||
                other.dateOfReconciliation == dateOfReconciliation) &&
            (identical(other.loggedInUserId, loggedInUserId) ||
                other.loggedInUserId == loggedInUserId));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, dateOfReconciliation, loggedInUserId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$StockReconciliationSelectDateOfReconciliationEventImplCopyWith<
          _$StockReconciliationSelectDateOfReconciliationEventImpl>
      get copyWith =>
          __$$StockReconciliationSelectDateOfReconciliationEventImplCopyWithImpl<
                  _$StockReconciliationSelectDateOfReconciliationEventImpl>(
              this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(FacilityModel facilityModel, bool isDistributor,
            String loggedInUserId, String? teamCode)
        selectFacility,
    required TResult Function(
            String? productVariantId, bool isDistributor, String loggedInUserId)
        selectProduct,
    required TResult Function(
            DateTime? dateOfReconciliation, String loggedInUserId)
        selectDateOfReconciliation,
    required TResult Function(
            bool isDistributor, String? teamCode, String loggedInUserId)
        calculate,
    required TResult Function(StockReconciliationModel stockReconciliationModel)
        create,
  }) {
    return selectDateOfReconciliation(dateOfReconciliation, loggedInUserId);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(FacilityModel facilityModel, bool isDistributor,
            String loggedInUserId, String? teamCode)?
        selectFacility,
    TResult? Function(String? productVariantId, bool isDistributor,
            String loggedInUserId)?
        selectProduct,
    TResult? Function(DateTime? dateOfReconciliation, String loggedInUserId)?
        selectDateOfReconciliation,
    TResult? Function(
            bool isDistributor, String? teamCode, String loggedInUserId)?
        calculate,
    TResult? Function(StockReconciliationModel stockReconciliationModel)?
        create,
  }) {
    return selectDateOfReconciliation?.call(
        dateOfReconciliation, loggedInUserId);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(FacilityModel facilityModel, bool isDistributor,
            String loggedInUserId, String? teamCode)?
        selectFacility,
    TResult Function(String? productVariantId, bool isDistributor,
            String loggedInUserId)?
        selectProduct,
    TResult Function(DateTime? dateOfReconciliation, String loggedInUserId)?
        selectDateOfReconciliation,
    TResult Function(
            bool isDistributor, String? teamCode, String loggedInUserId)?
        calculate,
    TResult Function(StockReconciliationModel stockReconciliationModel)? create,
    required TResult orElse(),
  }) {
    if (selectDateOfReconciliation != null) {
      return selectDateOfReconciliation(dateOfReconciliation, loggedInUserId);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(StockReconciliationSelectFacilityEvent value)
        selectFacility,
    required TResult Function(StockReconciliationSelectProductEvent value)
        selectProduct,
    required TResult Function(
            StockReconciliationSelectDateOfReconciliationEvent value)
        selectDateOfReconciliation,
    required TResult Function(StockReconciliationCalculateEvent value)
        calculate,
    required TResult Function(StockReconciliationCreateEvent value) create,
  }) {
    return selectDateOfReconciliation(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(StockReconciliationSelectFacilityEvent value)?
        selectFacility,
    TResult? Function(StockReconciliationSelectProductEvent value)?
        selectProduct,
    TResult? Function(StockReconciliationSelectDateOfReconciliationEvent value)?
        selectDateOfReconciliation,
    TResult? Function(StockReconciliationCalculateEvent value)? calculate,
    TResult? Function(StockReconciliationCreateEvent value)? create,
  }) {
    return selectDateOfReconciliation?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(StockReconciliationSelectFacilityEvent value)?
        selectFacility,
    TResult Function(StockReconciliationSelectProductEvent value)?
        selectProduct,
    TResult Function(StockReconciliationSelectDateOfReconciliationEvent value)?
        selectDateOfReconciliation,
    TResult Function(StockReconciliationCalculateEvent value)? calculate,
    TResult Function(StockReconciliationCreateEvent value)? create,
    required TResult orElse(),
  }) {
    if (selectDateOfReconciliation != null) {
      return selectDateOfReconciliation(this);
    }
    return orElse();
  }
}

abstract class StockReconciliationSelectDateOfReconciliationEvent
    implements StockReconciliationEvent {
  const factory StockReconciliationSelectDateOfReconciliationEvent(
          final DateTime? dateOfReconciliation,
          {required final String loggedInUserId}) =
      _$StockReconciliationSelectDateOfReconciliationEventImpl;

  DateTime? get dateOfReconciliation;
  String get loggedInUserId;
  @JsonKey(ignore: true)
  _$$StockReconciliationSelectDateOfReconciliationEventImplCopyWith<
          _$StockReconciliationSelectDateOfReconciliationEventImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$StockReconciliationCalculateEventImplCopyWith<$Res> {
  factory _$$StockReconciliationCalculateEventImplCopyWith(
          _$StockReconciliationCalculateEventImpl value,
          $Res Function(_$StockReconciliationCalculateEventImpl) then) =
      __$$StockReconciliationCalculateEventImplCopyWithImpl<$Res>;
  @useResult
  $Res call({bool isDistributor, String? teamCode, String loggedInUserId});
}

/// @nodoc
class __$$StockReconciliationCalculateEventImplCopyWithImpl<$Res>
    extends _$StockReconciliationEventCopyWithImpl<$Res,
        _$StockReconciliationCalculateEventImpl>
    implements _$$StockReconciliationCalculateEventImplCopyWith<$Res> {
  __$$StockReconciliationCalculateEventImplCopyWithImpl(
      _$StockReconciliationCalculateEventImpl _value,
      $Res Function(_$StockReconciliationCalculateEventImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isDistributor = null,
    Object? teamCode = freezed,
    Object? loggedInUserId = null,
  }) {
    return _then(_$StockReconciliationCalculateEventImpl(
      isDistributor: null == isDistributor
          ? _value.isDistributor
          : isDistributor // ignore: cast_nullable_to_non_nullable
              as bool,
      teamCode: freezed == teamCode
          ? _value.teamCode
          : teamCode // ignore: cast_nullable_to_non_nullable
              as String?,
      loggedInUserId: null == loggedInUserId
          ? _value.loggedInUserId
          : loggedInUserId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$StockReconciliationCalculateEventImpl
    implements StockReconciliationCalculateEvent {
  const _$StockReconciliationCalculateEventImpl(
      {this.isDistributor = false,
      this.teamCode,
      required this.loggedInUserId});

  @override
  @JsonKey()
  final bool isDistributor;
  @override
  final String? teamCode;
  @override
  final String loggedInUserId;

  @override
  String toString() {
    return 'StockReconciliationEvent.calculate(isDistributor: $isDistributor, teamCode: $teamCode, loggedInUserId: $loggedInUserId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StockReconciliationCalculateEventImpl &&
            (identical(other.isDistributor, isDistributor) ||
                other.isDistributor == isDistributor) &&
            (identical(other.teamCode, teamCode) ||
                other.teamCode == teamCode) &&
            (identical(other.loggedInUserId, loggedInUserId) ||
                other.loggedInUserId == loggedInUserId));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, isDistributor, teamCode, loggedInUserId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$StockReconciliationCalculateEventImplCopyWith<
          _$StockReconciliationCalculateEventImpl>
      get copyWith => __$$StockReconciliationCalculateEventImplCopyWithImpl<
          _$StockReconciliationCalculateEventImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(FacilityModel facilityModel, bool isDistributor,
            String loggedInUserId, String? teamCode)
        selectFacility,
    required TResult Function(
            String? productVariantId, bool isDistributor, String loggedInUserId)
        selectProduct,
    required TResult Function(
            DateTime? dateOfReconciliation, String loggedInUserId)
        selectDateOfReconciliation,
    required TResult Function(
            bool isDistributor, String? teamCode, String loggedInUserId)
        calculate,
    required TResult Function(StockReconciliationModel stockReconciliationModel)
        create,
  }) {
    return calculate(isDistributor, teamCode, loggedInUserId);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(FacilityModel facilityModel, bool isDistributor,
            String loggedInUserId, String? teamCode)?
        selectFacility,
    TResult? Function(String? productVariantId, bool isDistributor,
            String loggedInUserId)?
        selectProduct,
    TResult? Function(DateTime? dateOfReconciliation, String loggedInUserId)?
        selectDateOfReconciliation,
    TResult? Function(
            bool isDistributor, String? teamCode, String loggedInUserId)?
        calculate,
    TResult? Function(StockReconciliationModel stockReconciliationModel)?
        create,
  }) {
    return calculate?.call(isDistributor, teamCode, loggedInUserId);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(FacilityModel facilityModel, bool isDistributor,
            String loggedInUserId, String? teamCode)?
        selectFacility,
    TResult Function(String? productVariantId, bool isDistributor,
            String loggedInUserId)?
        selectProduct,
    TResult Function(DateTime? dateOfReconciliation, String loggedInUserId)?
        selectDateOfReconciliation,
    TResult Function(
            bool isDistributor, String? teamCode, String loggedInUserId)?
        calculate,
    TResult Function(StockReconciliationModel stockReconciliationModel)? create,
    required TResult orElse(),
  }) {
    if (calculate != null) {
      return calculate(isDistributor, teamCode, loggedInUserId);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(StockReconciliationSelectFacilityEvent value)
        selectFacility,
    required TResult Function(StockReconciliationSelectProductEvent value)
        selectProduct,
    required TResult Function(
            StockReconciliationSelectDateOfReconciliationEvent value)
        selectDateOfReconciliation,
    required TResult Function(StockReconciliationCalculateEvent value)
        calculate,
    required TResult Function(StockReconciliationCreateEvent value) create,
  }) {
    return calculate(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(StockReconciliationSelectFacilityEvent value)?
        selectFacility,
    TResult? Function(StockReconciliationSelectProductEvent value)?
        selectProduct,
    TResult? Function(StockReconciliationSelectDateOfReconciliationEvent value)?
        selectDateOfReconciliation,
    TResult? Function(StockReconciliationCalculateEvent value)? calculate,
    TResult? Function(StockReconciliationCreateEvent value)? create,
  }) {
    return calculate?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(StockReconciliationSelectFacilityEvent value)?
        selectFacility,
    TResult Function(StockReconciliationSelectProductEvent value)?
        selectProduct,
    TResult Function(StockReconciliationSelectDateOfReconciliationEvent value)?
        selectDateOfReconciliation,
    TResult Function(StockReconciliationCalculateEvent value)? calculate,
    TResult Function(StockReconciliationCreateEvent value)? create,
    required TResult orElse(),
  }) {
    if (calculate != null) {
      return calculate(this);
    }
    return orElse();
  }
}

abstract class StockReconciliationCalculateEvent
    implements StockReconciliationEvent {
  const factory StockReconciliationCalculateEvent(
          {final bool isDistributor,
          final String? teamCode,
          required final String loggedInUserId}) =
      _$StockReconciliationCalculateEventImpl;

  bool get isDistributor;
  String? get teamCode;
  String get loggedInUserId;
  @JsonKey(ignore: true)
  _$$StockReconciliationCalculateEventImplCopyWith<
          _$StockReconciliationCalculateEventImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$StockReconciliationCreateEventImplCopyWith<$Res> {
  factory _$$StockReconciliationCreateEventImplCopyWith(
          _$StockReconciliationCreateEventImpl value,
          $Res Function(_$StockReconciliationCreateEventImpl) then) =
      __$$StockReconciliationCreateEventImplCopyWithImpl<$Res>;
  @useResult
  $Res call({StockReconciliationModel stockReconciliationModel});
}

/// @nodoc
class __$$StockReconciliationCreateEventImplCopyWithImpl<$Res>
    extends _$StockReconciliationEventCopyWithImpl<$Res,
        _$StockReconciliationCreateEventImpl>
    implements _$$StockReconciliationCreateEventImplCopyWith<$Res> {
  __$$StockReconciliationCreateEventImplCopyWithImpl(
      _$StockReconciliationCreateEventImpl _value,
      $Res Function(_$StockReconciliationCreateEventImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? stockReconciliationModel = null,
  }) {
    return _then(_$StockReconciliationCreateEventImpl(
      null == stockReconciliationModel
          ? _value.stockReconciliationModel
          : stockReconciliationModel // ignore: cast_nullable_to_non_nullable
              as StockReconciliationModel,
    ));
  }
}

/// @nodoc

class _$StockReconciliationCreateEventImpl
    implements StockReconciliationCreateEvent {
  const _$StockReconciliationCreateEventImpl(this.stockReconciliationModel);

  @override
  final StockReconciliationModel stockReconciliationModel;

  @override
  String toString() {
    return 'StockReconciliationEvent.create(stockReconciliationModel: $stockReconciliationModel)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StockReconciliationCreateEventImpl &&
            (identical(
                    other.stockReconciliationModel, stockReconciliationModel) ||
                other.stockReconciliationModel == stockReconciliationModel));
  }

  @override
  int get hashCode => Object.hash(runtimeType, stockReconciliationModel);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$StockReconciliationCreateEventImplCopyWith<
          _$StockReconciliationCreateEventImpl>
      get copyWith => __$$StockReconciliationCreateEventImplCopyWithImpl<
          _$StockReconciliationCreateEventImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(FacilityModel facilityModel, bool isDistributor,
            String loggedInUserId, String? teamCode)
        selectFacility,
    required TResult Function(
            String? productVariantId, bool isDistributor, String loggedInUserId)
        selectProduct,
    required TResult Function(
            DateTime? dateOfReconciliation, String loggedInUserId)
        selectDateOfReconciliation,
    required TResult Function(
            bool isDistributor, String? teamCode, String loggedInUserId)
        calculate,
    required TResult Function(StockReconciliationModel stockReconciliationModel)
        create,
  }) {
    return create(stockReconciliationModel);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(FacilityModel facilityModel, bool isDistributor,
            String loggedInUserId, String? teamCode)?
        selectFacility,
    TResult? Function(String? productVariantId, bool isDistributor,
            String loggedInUserId)?
        selectProduct,
    TResult? Function(DateTime? dateOfReconciliation, String loggedInUserId)?
        selectDateOfReconciliation,
    TResult? Function(
            bool isDistributor, String? teamCode, String loggedInUserId)?
        calculate,
    TResult? Function(StockReconciliationModel stockReconciliationModel)?
        create,
  }) {
    return create?.call(stockReconciliationModel);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(FacilityModel facilityModel, bool isDistributor,
            String loggedInUserId, String? teamCode)?
        selectFacility,
    TResult Function(String? productVariantId, bool isDistributor,
            String loggedInUserId)?
        selectProduct,
    TResult Function(DateTime? dateOfReconciliation, String loggedInUserId)?
        selectDateOfReconciliation,
    TResult Function(
            bool isDistributor, String? teamCode, String loggedInUserId)?
        calculate,
    TResult Function(StockReconciliationModel stockReconciliationModel)? create,
    required TResult orElse(),
  }) {
    if (create != null) {
      return create(stockReconciliationModel);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(StockReconciliationSelectFacilityEvent value)
        selectFacility,
    required TResult Function(StockReconciliationSelectProductEvent value)
        selectProduct,
    required TResult Function(
            StockReconciliationSelectDateOfReconciliationEvent value)
        selectDateOfReconciliation,
    required TResult Function(StockReconciliationCalculateEvent value)
        calculate,
    required TResult Function(StockReconciliationCreateEvent value) create,
  }) {
    return create(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(StockReconciliationSelectFacilityEvent value)?
        selectFacility,
    TResult? Function(StockReconciliationSelectProductEvent value)?
        selectProduct,
    TResult? Function(StockReconciliationSelectDateOfReconciliationEvent value)?
        selectDateOfReconciliation,
    TResult? Function(StockReconciliationCalculateEvent value)? calculate,
    TResult? Function(StockReconciliationCreateEvent value)? create,
  }) {
    return create?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(StockReconciliationSelectFacilityEvent value)?
        selectFacility,
    TResult Function(StockReconciliationSelectProductEvent value)?
        selectProduct,
    TResult Function(StockReconciliationSelectDateOfReconciliationEvent value)?
        selectDateOfReconciliation,
    TResult Function(StockReconciliationCalculateEvent value)? calculate,
    TResult Function(StockReconciliationCreateEvent value)? create,
    required TResult orElse(),
  }) {
    if (create != null) {
      return create(this);
    }
    return orElse();
  }
}

abstract class StockReconciliationCreateEvent
    implements StockReconciliationEvent {
  const factory StockReconciliationCreateEvent(
          final StockReconciliationModel stockReconciliationModel) =
      _$StockReconciliationCreateEventImpl;

  StockReconciliationModel get stockReconciliationModel;
  @JsonKey(ignore: true)
  _$$StockReconciliationCreateEventImplCopyWith<
          _$StockReconciliationCreateEventImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$StockReconciliationState {
  bool get loading => throw _privateConstructorUsedError;
  bool get persisted => throw _privateConstructorUsedError;
  String get projectId => throw _privateConstructorUsedError;
  DateTime get dateOfReconciliation => throw _privateConstructorUsedError;
  FacilityModel? get facilityModel => throw _privateConstructorUsedError;
  String? get productVariantId => throw _privateConstructorUsedError;
  List<StockModel> get stockModels => throw _privateConstructorUsedError;
  StockReconciliationModel? get stockReconciliationModel =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $StockReconciliationStateCopyWith<StockReconciliationState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StockReconciliationStateCopyWith<$Res> {
  factory $StockReconciliationStateCopyWith(StockReconciliationState value,
          $Res Function(StockReconciliationState) then) =
      _$StockReconciliationStateCopyWithImpl<$Res, StockReconciliationState>;
  @useResult
  $Res call(
      {bool loading,
      bool persisted,
      String projectId,
      DateTime dateOfReconciliation,
      FacilityModel? facilityModel,
      String? productVariantId,
      List<StockModel> stockModels,
      StockReconciliationModel? stockReconciliationModel});
}

/// @nodoc
class _$StockReconciliationStateCopyWithImpl<$Res,
        $Val extends StockReconciliationState>
    implements $StockReconciliationStateCopyWith<$Res> {
  _$StockReconciliationStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? loading = null,
    Object? persisted = null,
    Object? projectId = null,
    Object? dateOfReconciliation = null,
    Object? facilityModel = freezed,
    Object? productVariantId = freezed,
    Object? stockModels = null,
    Object? stockReconciliationModel = freezed,
  }) {
    return _then(_value.copyWith(
      loading: null == loading
          ? _value.loading
          : loading // ignore: cast_nullable_to_non_nullable
              as bool,
      persisted: null == persisted
          ? _value.persisted
          : persisted // ignore: cast_nullable_to_non_nullable
              as bool,
      projectId: null == projectId
          ? _value.projectId
          : projectId // ignore: cast_nullable_to_non_nullable
              as String,
      dateOfReconciliation: null == dateOfReconciliation
          ? _value.dateOfReconciliation
          : dateOfReconciliation // ignore: cast_nullable_to_non_nullable
              as DateTime,
      facilityModel: freezed == facilityModel
          ? _value.facilityModel
          : facilityModel // ignore: cast_nullable_to_non_nullable
              as FacilityModel?,
      productVariantId: freezed == productVariantId
          ? _value.productVariantId
          : productVariantId // ignore: cast_nullable_to_non_nullable
              as String?,
      stockModels: null == stockModels
          ? _value.stockModels
          : stockModels // ignore: cast_nullable_to_non_nullable
              as List<StockModel>,
      stockReconciliationModel: freezed == stockReconciliationModel
          ? _value.stockReconciliationModel
          : stockReconciliationModel // ignore: cast_nullable_to_non_nullable
              as StockReconciliationModel?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$StockReconciliationStateImplCopyWith<$Res>
    implements $StockReconciliationStateCopyWith<$Res> {
  factory _$$StockReconciliationStateImplCopyWith(
          _$StockReconciliationStateImpl value,
          $Res Function(_$StockReconciliationStateImpl) then) =
      __$$StockReconciliationStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool loading,
      bool persisted,
      String projectId,
      DateTime dateOfReconciliation,
      FacilityModel? facilityModel,
      String? productVariantId,
      List<StockModel> stockModels,
      StockReconciliationModel? stockReconciliationModel});
}

/// @nodoc
class __$$StockReconciliationStateImplCopyWithImpl<$Res>
    extends _$StockReconciliationStateCopyWithImpl<$Res,
        _$StockReconciliationStateImpl>
    implements _$$StockReconciliationStateImplCopyWith<$Res> {
  __$$StockReconciliationStateImplCopyWithImpl(
      _$StockReconciliationStateImpl _value,
      $Res Function(_$StockReconciliationStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? loading = null,
    Object? persisted = null,
    Object? projectId = null,
    Object? dateOfReconciliation = null,
    Object? facilityModel = freezed,
    Object? productVariantId = freezed,
    Object? stockModels = null,
    Object? stockReconciliationModel = freezed,
  }) {
    return _then(_$StockReconciliationStateImpl(
      loading: null == loading
          ? _value.loading
          : loading // ignore: cast_nullable_to_non_nullable
              as bool,
      persisted: null == persisted
          ? _value.persisted
          : persisted // ignore: cast_nullable_to_non_nullable
              as bool,
      projectId: null == projectId
          ? _value.projectId
          : projectId // ignore: cast_nullable_to_non_nullable
              as String,
      dateOfReconciliation: null == dateOfReconciliation
          ? _value.dateOfReconciliation
          : dateOfReconciliation // ignore: cast_nullable_to_non_nullable
              as DateTime,
      facilityModel: freezed == facilityModel
          ? _value.facilityModel
          : facilityModel // ignore: cast_nullable_to_non_nullable
              as FacilityModel?,
      productVariantId: freezed == productVariantId
          ? _value.productVariantId
          : productVariantId // ignore: cast_nullable_to_non_nullable
              as String?,
      stockModels: null == stockModels
          ? _value._stockModels
          : stockModels // ignore: cast_nullable_to_non_nullable
              as List<StockModel>,
      stockReconciliationModel: freezed == stockReconciliationModel
          ? _value.stockReconciliationModel
          : stockReconciliationModel // ignore: cast_nullable_to_non_nullable
              as StockReconciliationModel?,
    ));
  }
}

/// @nodoc

class _$StockReconciliationStateImpl extends _StockReconciliationState {
  _$StockReconciliationStateImpl(
      {this.loading = false,
      this.persisted = false,
      required this.projectId,
      required this.dateOfReconciliation,
      this.facilityModel,
      this.productVariantId,
      final List<StockModel> stockModels = const [],
      this.stockReconciliationModel})
      : _stockModels = stockModels,
        super._();

  @override
  @JsonKey()
  final bool loading;
  @override
  @JsonKey()
  final bool persisted;
  @override
  final String projectId;
  @override
  final DateTime dateOfReconciliation;
  @override
  final FacilityModel? facilityModel;
  @override
  final String? productVariantId;
  final List<StockModel> _stockModels;
  @override
  @JsonKey()
  List<StockModel> get stockModels {
    if (_stockModels is EqualUnmodifiableListView) return _stockModels;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_stockModels);
  }

  @override
  final StockReconciliationModel? stockReconciliationModel;

  @override
  String toString() {
    return 'StockReconciliationState(loading: $loading, persisted: $persisted, projectId: $projectId, dateOfReconciliation: $dateOfReconciliation, facilityModel: $facilityModel, productVariantId: $productVariantId, stockModels: $stockModels, stockReconciliationModel: $stockReconciliationModel)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StockReconciliationStateImpl &&
            (identical(other.loading, loading) || other.loading == loading) &&
            (identical(other.persisted, persisted) ||
                other.persisted == persisted) &&
            (identical(other.projectId, projectId) ||
                other.projectId == projectId) &&
            (identical(other.dateOfReconciliation, dateOfReconciliation) ||
                other.dateOfReconciliation == dateOfReconciliation) &&
            (identical(other.facilityModel, facilityModel) ||
                other.facilityModel == facilityModel) &&
            (identical(other.productVariantId, productVariantId) ||
                other.productVariantId == productVariantId) &&
            const DeepCollectionEquality()
                .equals(other._stockModels, _stockModels) &&
            (identical(
                    other.stockReconciliationModel, stockReconciliationModel) ||
                other.stockReconciliationModel == stockReconciliationModel));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      loading,
      persisted,
      projectId,
      dateOfReconciliation,
      facilityModel,
      productVariantId,
      const DeepCollectionEquality().hash(_stockModels),
      stockReconciliationModel);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$StockReconciliationStateImplCopyWith<_$StockReconciliationStateImpl>
      get copyWith => __$$StockReconciliationStateImplCopyWithImpl<
          _$StockReconciliationStateImpl>(this, _$identity);
}

abstract class _StockReconciliationState extends StockReconciliationState {
  factory _StockReconciliationState(
          {final bool loading,
          final bool persisted,
          required final String projectId,
          required final DateTime dateOfReconciliation,
          final FacilityModel? facilityModel,
          final String? productVariantId,
          final List<StockModel> stockModels,
          final StockReconciliationModel? stockReconciliationModel}) =
      _$StockReconciliationStateImpl;
  _StockReconciliationState._() : super._();

  @override
  bool get loading;
  @override
  bool get persisted;
  @override
  String get projectId;
  @override
  DateTime get dateOfReconciliation;
  @override
  FacilityModel? get facilityModel;
  @override
  String? get productVariantId;
  @override
  List<StockModel> get stockModels;
  @override
  StockReconciliationModel? get stockReconciliationModel;
  @override
  @JsonKey(ignore: true)
  _$$StockReconciliationStateImplCopyWith<_$StockReconciliationStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
