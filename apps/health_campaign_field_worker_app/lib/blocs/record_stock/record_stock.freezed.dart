// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'record_stock.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$RecordStockEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            DateTime dateOfRecord,
            FacilityModel? facilityModel,
            String primaryType,
            String primaryId,
            String loggedInUserId)
        saveWarehouseDetails,
    required TResult Function(StockModel stockModel) saveStockDetails,
    required TResult Function() createStockEntry,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(DateTime dateOfRecord, FacilityModel? facilityModel,
            String primaryType, String primaryId, String loggedInUserId)?
        saveWarehouseDetails,
    TResult? Function(StockModel stockModel)? saveStockDetails,
    TResult? Function()? createStockEntry,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(DateTime dateOfRecord, FacilityModel? facilityModel,
            String primaryType, String primaryId, String loggedInUserId)?
        saveWarehouseDetails,
    TResult Function(StockModel stockModel)? saveStockDetails,
    TResult Function()? createStockEntry,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(RecordStockSaveWarehouseDetailsEvent value)
        saveWarehouseDetails,
    required TResult Function(RecordStockSaveStockDetailsEvent value)
        saveStockDetails,
    required TResult Function(RecordStockCreateStockEntryEvent value)
        createStockEntry,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(RecordStockSaveWarehouseDetailsEvent value)?
        saveWarehouseDetails,
    TResult? Function(RecordStockSaveStockDetailsEvent value)? saveStockDetails,
    TResult? Function(RecordStockCreateStockEntryEvent value)? createStockEntry,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(RecordStockSaveWarehouseDetailsEvent value)?
        saveWarehouseDetails,
    TResult Function(RecordStockSaveStockDetailsEvent value)? saveStockDetails,
    TResult Function(RecordStockCreateStockEntryEvent value)? createStockEntry,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RecordStockEventCopyWith<$Res> {
  factory $RecordStockEventCopyWith(
          RecordStockEvent value, $Res Function(RecordStockEvent) then) =
      _$RecordStockEventCopyWithImpl<$Res, RecordStockEvent>;
}

/// @nodoc
class _$RecordStockEventCopyWithImpl<$Res, $Val extends RecordStockEvent>
    implements $RecordStockEventCopyWith<$Res> {
  _$RecordStockEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$RecordStockSaveWarehouseDetailsEventImplCopyWith<$Res> {
  factory _$$RecordStockSaveWarehouseDetailsEventImplCopyWith(
          _$RecordStockSaveWarehouseDetailsEventImpl value,
          $Res Function(_$RecordStockSaveWarehouseDetailsEventImpl) then) =
      __$$RecordStockSaveWarehouseDetailsEventImplCopyWithImpl<$Res>;
  @useResult
  $Res call(
      {DateTime dateOfRecord,
      FacilityModel? facilityModel,
      String primaryType,
      String primaryId,
      String loggedInUserId});
}

/// @nodoc
class __$$RecordStockSaveWarehouseDetailsEventImplCopyWithImpl<$Res>
    extends _$RecordStockEventCopyWithImpl<$Res,
        _$RecordStockSaveWarehouseDetailsEventImpl>
    implements _$$RecordStockSaveWarehouseDetailsEventImplCopyWith<$Res> {
  __$$RecordStockSaveWarehouseDetailsEventImplCopyWithImpl(
      _$RecordStockSaveWarehouseDetailsEventImpl _value,
      $Res Function(_$RecordStockSaveWarehouseDetailsEventImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? dateOfRecord = null,
    Object? facilityModel = freezed,
    Object? primaryType = null,
    Object? primaryId = null,
    Object? loggedInUserId = null,
  }) {
    return _then(_$RecordStockSaveWarehouseDetailsEventImpl(
      dateOfRecord: null == dateOfRecord
          ? _value.dateOfRecord
          : dateOfRecord // ignore: cast_nullable_to_non_nullable
              as DateTime,
      facilityModel: freezed == facilityModel
          ? _value.facilityModel
          : facilityModel // ignore: cast_nullable_to_non_nullable
              as FacilityModel?,
      primaryType: null == primaryType
          ? _value.primaryType
          : primaryType // ignore: cast_nullable_to_non_nullable
              as String,
      primaryId: null == primaryId
          ? _value.primaryId
          : primaryId // ignore: cast_nullable_to_non_nullable
              as String,
      loggedInUserId: null == loggedInUserId
          ? _value.loggedInUserId
          : loggedInUserId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$RecordStockSaveWarehouseDetailsEventImpl
    implements RecordStockSaveWarehouseDetailsEvent {
  const _$RecordStockSaveWarehouseDetailsEventImpl(
      {required this.dateOfRecord,
      this.facilityModel,
      required this.primaryType,
      required this.primaryId,
      required this.loggedInUserId});

  @override
  final DateTime dateOfRecord;
  @override
  final FacilityModel? facilityModel;
  @override
  final String primaryType;
  @override
  final String primaryId;
  @override
  final String loggedInUserId;

  @override
  String toString() {
    return 'RecordStockEvent.saveWarehouseDetails(dateOfRecord: $dateOfRecord, facilityModel: $facilityModel, primaryType: $primaryType, primaryId: $primaryId, loggedInUserId: $loggedInUserId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RecordStockSaveWarehouseDetailsEventImpl &&
            (identical(other.dateOfRecord, dateOfRecord) ||
                other.dateOfRecord == dateOfRecord) &&
            (identical(other.facilityModel, facilityModel) ||
                other.facilityModel == facilityModel) &&
            (identical(other.primaryType, primaryType) ||
                other.primaryType == primaryType) &&
            (identical(other.primaryId, primaryId) ||
                other.primaryId == primaryId) &&
            (identical(other.loggedInUserId, loggedInUserId) ||
                other.loggedInUserId == loggedInUserId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, dateOfRecord, facilityModel,
      primaryType, primaryId, loggedInUserId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RecordStockSaveWarehouseDetailsEventImplCopyWith<
          _$RecordStockSaveWarehouseDetailsEventImpl>
      get copyWith => __$$RecordStockSaveWarehouseDetailsEventImplCopyWithImpl<
          _$RecordStockSaveWarehouseDetailsEventImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            DateTime dateOfRecord,
            FacilityModel? facilityModel,
            String primaryType,
            String primaryId,
            String loggedInUserId)
        saveWarehouseDetails,
    required TResult Function(StockModel stockModel) saveStockDetails,
    required TResult Function() createStockEntry,
  }) {
    return saveWarehouseDetails(
        dateOfRecord, facilityModel, primaryType, primaryId, loggedInUserId);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(DateTime dateOfRecord, FacilityModel? facilityModel,
            String primaryType, String primaryId, String loggedInUserId)?
        saveWarehouseDetails,
    TResult? Function(StockModel stockModel)? saveStockDetails,
    TResult? Function()? createStockEntry,
  }) {
    return saveWarehouseDetails?.call(
        dateOfRecord, facilityModel, primaryType, primaryId, loggedInUserId);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(DateTime dateOfRecord, FacilityModel? facilityModel,
            String primaryType, String primaryId, String loggedInUserId)?
        saveWarehouseDetails,
    TResult Function(StockModel stockModel)? saveStockDetails,
    TResult Function()? createStockEntry,
    required TResult orElse(),
  }) {
    if (saveWarehouseDetails != null) {
      return saveWarehouseDetails(
          dateOfRecord, facilityModel, primaryType, primaryId, loggedInUserId);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(RecordStockSaveWarehouseDetailsEvent value)
        saveWarehouseDetails,
    required TResult Function(RecordStockSaveStockDetailsEvent value)
        saveStockDetails,
    required TResult Function(RecordStockCreateStockEntryEvent value)
        createStockEntry,
  }) {
    return saveWarehouseDetails(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(RecordStockSaveWarehouseDetailsEvent value)?
        saveWarehouseDetails,
    TResult? Function(RecordStockSaveStockDetailsEvent value)? saveStockDetails,
    TResult? Function(RecordStockCreateStockEntryEvent value)? createStockEntry,
  }) {
    return saveWarehouseDetails?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(RecordStockSaveWarehouseDetailsEvent value)?
        saveWarehouseDetails,
    TResult Function(RecordStockSaveStockDetailsEvent value)? saveStockDetails,
    TResult Function(RecordStockCreateStockEntryEvent value)? createStockEntry,
    required TResult orElse(),
  }) {
    if (saveWarehouseDetails != null) {
      return saveWarehouseDetails(this);
    }
    return orElse();
  }
}

abstract class RecordStockSaveWarehouseDetailsEvent
    implements RecordStockEvent {
  const factory RecordStockSaveWarehouseDetailsEvent(
          {required final DateTime dateOfRecord,
          final FacilityModel? facilityModel,
          required final String primaryType,
          required final String primaryId,
          required final String loggedInUserId}) =
      _$RecordStockSaveWarehouseDetailsEventImpl;

  DateTime get dateOfRecord;
  FacilityModel? get facilityModel;
  String get primaryType;
  String get primaryId;
  String get loggedInUserId;
  @JsonKey(ignore: true)
  _$$RecordStockSaveWarehouseDetailsEventImplCopyWith<
          _$RecordStockSaveWarehouseDetailsEventImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$RecordStockSaveStockDetailsEventImplCopyWith<$Res> {
  factory _$$RecordStockSaveStockDetailsEventImplCopyWith(
          _$RecordStockSaveStockDetailsEventImpl value,
          $Res Function(_$RecordStockSaveStockDetailsEventImpl) then) =
      __$$RecordStockSaveStockDetailsEventImplCopyWithImpl<$Res>;
  @useResult
  $Res call({StockModel stockModel});
}

/// @nodoc
class __$$RecordStockSaveStockDetailsEventImplCopyWithImpl<$Res>
    extends _$RecordStockEventCopyWithImpl<$Res,
        _$RecordStockSaveStockDetailsEventImpl>
    implements _$$RecordStockSaveStockDetailsEventImplCopyWith<$Res> {
  __$$RecordStockSaveStockDetailsEventImplCopyWithImpl(
      _$RecordStockSaveStockDetailsEventImpl _value,
      $Res Function(_$RecordStockSaveStockDetailsEventImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? stockModel = null,
  }) {
    return _then(_$RecordStockSaveStockDetailsEventImpl(
      stockModel: null == stockModel
          ? _value.stockModel
          : stockModel // ignore: cast_nullable_to_non_nullable
              as StockModel,
    ));
  }
}

/// @nodoc

class _$RecordStockSaveStockDetailsEventImpl
    implements RecordStockSaveStockDetailsEvent {
  const _$RecordStockSaveStockDetailsEventImpl({required this.stockModel});

  @override
  final StockModel stockModel;

  @override
  String toString() {
    return 'RecordStockEvent.saveStockDetails(stockModel: $stockModel)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RecordStockSaveStockDetailsEventImpl &&
            (identical(other.stockModel, stockModel) ||
                other.stockModel == stockModel));
  }

  @override
  int get hashCode => Object.hash(runtimeType, stockModel);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RecordStockSaveStockDetailsEventImplCopyWith<
          _$RecordStockSaveStockDetailsEventImpl>
      get copyWith => __$$RecordStockSaveStockDetailsEventImplCopyWithImpl<
          _$RecordStockSaveStockDetailsEventImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            DateTime dateOfRecord,
            FacilityModel? facilityModel,
            String primaryType,
            String primaryId,
            String loggedInUserId)
        saveWarehouseDetails,
    required TResult Function(StockModel stockModel) saveStockDetails,
    required TResult Function() createStockEntry,
  }) {
    return saveStockDetails(stockModel);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(DateTime dateOfRecord, FacilityModel? facilityModel,
            String primaryType, String primaryId, String loggedInUserId)?
        saveWarehouseDetails,
    TResult? Function(StockModel stockModel)? saveStockDetails,
    TResult? Function()? createStockEntry,
  }) {
    return saveStockDetails?.call(stockModel);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(DateTime dateOfRecord, FacilityModel? facilityModel,
            String primaryType, String primaryId, String loggedInUserId)?
        saveWarehouseDetails,
    TResult Function(StockModel stockModel)? saveStockDetails,
    TResult Function()? createStockEntry,
    required TResult orElse(),
  }) {
    if (saveStockDetails != null) {
      return saveStockDetails(stockModel);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(RecordStockSaveWarehouseDetailsEvent value)
        saveWarehouseDetails,
    required TResult Function(RecordStockSaveStockDetailsEvent value)
        saveStockDetails,
    required TResult Function(RecordStockCreateStockEntryEvent value)
        createStockEntry,
  }) {
    return saveStockDetails(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(RecordStockSaveWarehouseDetailsEvent value)?
        saveWarehouseDetails,
    TResult? Function(RecordStockSaveStockDetailsEvent value)? saveStockDetails,
    TResult? Function(RecordStockCreateStockEntryEvent value)? createStockEntry,
  }) {
    return saveStockDetails?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(RecordStockSaveWarehouseDetailsEvent value)?
        saveWarehouseDetails,
    TResult Function(RecordStockSaveStockDetailsEvent value)? saveStockDetails,
    TResult Function(RecordStockCreateStockEntryEvent value)? createStockEntry,
    required TResult orElse(),
  }) {
    if (saveStockDetails != null) {
      return saveStockDetails(this);
    }
    return orElse();
  }
}

abstract class RecordStockSaveStockDetailsEvent implements RecordStockEvent {
  const factory RecordStockSaveStockDetailsEvent(
          {required final StockModel stockModel}) =
      _$RecordStockSaveStockDetailsEventImpl;

  StockModel get stockModel;
  @JsonKey(ignore: true)
  _$$RecordStockSaveStockDetailsEventImplCopyWith<
          _$RecordStockSaveStockDetailsEventImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$RecordStockCreateStockEntryEventImplCopyWith<$Res> {
  factory _$$RecordStockCreateStockEntryEventImplCopyWith(
          _$RecordStockCreateStockEntryEventImpl value,
          $Res Function(_$RecordStockCreateStockEntryEventImpl) then) =
      __$$RecordStockCreateStockEntryEventImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$RecordStockCreateStockEntryEventImplCopyWithImpl<$Res>
    extends _$RecordStockEventCopyWithImpl<$Res,
        _$RecordStockCreateStockEntryEventImpl>
    implements _$$RecordStockCreateStockEntryEventImplCopyWith<$Res> {
  __$$RecordStockCreateStockEntryEventImplCopyWithImpl(
      _$RecordStockCreateStockEntryEventImpl _value,
      $Res Function(_$RecordStockCreateStockEntryEventImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$RecordStockCreateStockEntryEventImpl
    implements RecordStockCreateStockEntryEvent {
  const _$RecordStockCreateStockEntryEventImpl();

  @override
  String toString() {
    return 'RecordStockEvent.createStockEntry()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RecordStockCreateStockEntryEventImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            DateTime dateOfRecord,
            FacilityModel? facilityModel,
            String primaryType,
            String primaryId,
            String loggedInUserId)
        saveWarehouseDetails,
    required TResult Function(StockModel stockModel) saveStockDetails,
    required TResult Function() createStockEntry,
  }) {
    return createStockEntry();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(DateTime dateOfRecord, FacilityModel? facilityModel,
            String primaryType, String primaryId, String loggedInUserId)?
        saveWarehouseDetails,
    TResult? Function(StockModel stockModel)? saveStockDetails,
    TResult? Function()? createStockEntry,
  }) {
    return createStockEntry?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(DateTime dateOfRecord, FacilityModel? facilityModel,
            String primaryType, String primaryId, String loggedInUserId)?
        saveWarehouseDetails,
    TResult Function(StockModel stockModel)? saveStockDetails,
    TResult Function()? createStockEntry,
    required TResult orElse(),
  }) {
    if (createStockEntry != null) {
      return createStockEntry();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(RecordStockSaveWarehouseDetailsEvent value)
        saveWarehouseDetails,
    required TResult Function(RecordStockSaveStockDetailsEvent value)
        saveStockDetails,
    required TResult Function(RecordStockCreateStockEntryEvent value)
        createStockEntry,
  }) {
    return createStockEntry(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(RecordStockSaveWarehouseDetailsEvent value)?
        saveWarehouseDetails,
    TResult? Function(RecordStockSaveStockDetailsEvent value)? saveStockDetails,
    TResult? Function(RecordStockCreateStockEntryEvent value)? createStockEntry,
  }) {
    return createStockEntry?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(RecordStockSaveWarehouseDetailsEvent value)?
        saveWarehouseDetails,
    TResult Function(RecordStockSaveStockDetailsEvent value)? saveStockDetails,
    TResult Function(RecordStockCreateStockEntryEvent value)? createStockEntry,
    required TResult orElse(),
  }) {
    if (createStockEntry != null) {
      return createStockEntry(this);
    }
    return orElse();
  }
}

abstract class RecordStockCreateStockEntryEvent implements RecordStockEvent {
  const factory RecordStockCreateStockEntryEvent() =
      _$RecordStockCreateStockEntryEventImpl;
}

/// @nodoc
mixin _$RecordStockState {
  StockRecordEntryType get entryType => throw _privateConstructorUsedError;
  String get projectId => throw _privateConstructorUsedError;
  DateTime? get dateOfRecord => throw _privateConstructorUsedError;
  FacilityModel? get facilityModel => throw _privateConstructorUsedError;
  StockModel? get stockModel => throw _privateConstructorUsedError;
  String? get primaryType => throw _privateConstructorUsedError;
  String? get primaryId => throw _privateConstructorUsedError;
  List<StockModel> get existingStocks => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            StockRecordEntryType entryType,
            bool loading,
            String projectId,
            DateTime? dateOfRecord,
            FacilityModel? facilityModel,
            StockModel? stockModel,
            String? primaryType,
            String? primaryId,
            List<StockModel> existingStocks)
        create,
    required TResult Function(
            StockRecordEntryType entryType,
            String projectId,
            DateTime? dateOfRecord,
            FacilityModel? facilityModel,
            StockModel? stockModel,
            String? primaryType,
            String? primaryId,
            List<StockModel> existingStocks)
        persisted,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            StockRecordEntryType entryType,
            bool loading,
            String projectId,
            DateTime? dateOfRecord,
            FacilityModel? facilityModel,
            StockModel? stockModel,
            String? primaryType,
            String? primaryId,
            List<StockModel> existingStocks)?
        create,
    TResult? Function(
            StockRecordEntryType entryType,
            String projectId,
            DateTime? dateOfRecord,
            FacilityModel? facilityModel,
            StockModel? stockModel,
            String? primaryType,
            String? primaryId,
            List<StockModel> existingStocks)?
        persisted,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            StockRecordEntryType entryType,
            bool loading,
            String projectId,
            DateTime? dateOfRecord,
            FacilityModel? facilityModel,
            StockModel? stockModel,
            String? primaryType,
            String? primaryId,
            List<StockModel> existingStocks)?
        create,
    TResult Function(
            StockRecordEntryType entryType,
            String projectId,
            DateTime? dateOfRecord,
            FacilityModel? facilityModel,
            StockModel? stockModel,
            String? primaryType,
            String? primaryId,
            List<StockModel> existingStocks)?
        persisted,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(RecordStockCreateState value) create,
    required TResult Function(RecordStockPersistedState value) persisted,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(RecordStockCreateState value)? create,
    TResult? Function(RecordStockPersistedState value)? persisted,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(RecordStockCreateState value)? create,
    TResult Function(RecordStockPersistedState value)? persisted,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $RecordStockStateCopyWith<RecordStockState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RecordStockStateCopyWith<$Res> {
  factory $RecordStockStateCopyWith(
          RecordStockState value, $Res Function(RecordStockState) then) =
      _$RecordStockStateCopyWithImpl<$Res, RecordStockState>;
  @useResult
  $Res call(
      {StockRecordEntryType entryType,
      String projectId,
      DateTime? dateOfRecord,
      FacilityModel? facilityModel,
      StockModel? stockModel,
      String? primaryType,
      String? primaryId,
      List<StockModel> existingStocks});
}

/// @nodoc
class _$RecordStockStateCopyWithImpl<$Res, $Val extends RecordStockState>
    implements $RecordStockStateCopyWith<$Res> {
  _$RecordStockStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? entryType = null,
    Object? projectId = null,
    Object? dateOfRecord = freezed,
    Object? facilityModel = freezed,
    Object? stockModel = freezed,
    Object? primaryType = freezed,
    Object? primaryId = freezed,
    Object? existingStocks = null,
  }) {
    return _then(_value.copyWith(
      entryType: null == entryType
          ? _value.entryType
          : entryType // ignore: cast_nullable_to_non_nullable
              as StockRecordEntryType,
      projectId: null == projectId
          ? _value.projectId
          : projectId // ignore: cast_nullable_to_non_nullable
              as String,
      dateOfRecord: freezed == dateOfRecord
          ? _value.dateOfRecord
          : dateOfRecord // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      facilityModel: freezed == facilityModel
          ? _value.facilityModel
          : facilityModel // ignore: cast_nullable_to_non_nullable
              as FacilityModel?,
      stockModel: freezed == stockModel
          ? _value.stockModel
          : stockModel // ignore: cast_nullable_to_non_nullable
              as StockModel?,
      primaryType: freezed == primaryType
          ? _value.primaryType
          : primaryType // ignore: cast_nullable_to_non_nullable
              as String?,
      primaryId: freezed == primaryId
          ? _value.primaryId
          : primaryId // ignore: cast_nullable_to_non_nullable
              as String?,
      existingStocks: null == existingStocks
          ? _value.existingStocks
          : existingStocks // ignore: cast_nullable_to_non_nullable
              as List<StockModel>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RecordStockCreateStateImplCopyWith<$Res>
    implements $RecordStockStateCopyWith<$Res> {
  factory _$$RecordStockCreateStateImplCopyWith(
          _$RecordStockCreateStateImpl value,
          $Res Function(_$RecordStockCreateStateImpl) then) =
      __$$RecordStockCreateStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {StockRecordEntryType entryType,
      bool loading,
      String projectId,
      DateTime? dateOfRecord,
      FacilityModel? facilityModel,
      StockModel? stockModel,
      String? primaryType,
      String? primaryId,
      List<StockModel> existingStocks});
}

/// @nodoc
class __$$RecordStockCreateStateImplCopyWithImpl<$Res>
    extends _$RecordStockStateCopyWithImpl<$Res, _$RecordStockCreateStateImpl>
    implements _$$RecordStockCreateStateImplCopyWith<$Res> {
  __$$RecordStockCreateStateImplCopyWithImpl(
      _$RecordStockCreateStateImpl _value,
      $Res Function(_$RecordStockCreateStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? entryType = null,
    Object? loading = null,
    Object? projectId = null,
    Object? dateOfRecord = freezed,
    Object? facilityModel = freezed,
    Object? stockModel = freezed,
    Object? primaryType = freezed,
    Object? primaryId = freezed,
    Object? existingStocks = null,
  }) {
    return _then(_$RecordStockCreateStateImpl(
      entryType: null == entryType
          ? _value.entryType
          : entryType // ignore: cast_nullable_to_non_nullable
              as StockRecordEntryType,
      loading: null == loading
          ? _value.loading
          : loading // ignore: cast_nullable_to_non_nullable
              as bool,
      projectId: null == projectId
          ? _value.projectId
          : projectId // ignore: cast_nullable_to_non_nullable
              as String,
      dateOfRecord: freezed == dateOfRecord
          ? _value.dateOfRecord
          : dateOfRecord // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      facilityModel: freezed == facilityModel
          ? _value.facilityModel
          : facilityModel // ignore: cast_nullable_to_non_nullable
              as FacilityModel?,
      stockModel: freezed == stockModel
          ? _value.stockModel
          : stockModel // ignore: cast_nullable_to_non_nullable
              as StockModel?,
      primaryType: freezed == primaryType
          ? _value.primaryType
          : primaryType // ignore: cast_nullable_to_non_nullable
              as String?,
      primaryId: freezed == primaryId
          ? _value.primaryId
          : primaryId // ignore: cast_nullable_to_non_nullable
              as String?,
      existingStocks: null == existingStocks
          ? _value._existingStocks
          : existingStocks // ignore: cast_nullable_to_non_nullable
              as List<StockModel>,
    ));
  }
}

/// @nodoc

class _$RecordStockCreateStateImpl extends RecordStockCreateState {
  _$RecordStockCreateStateImpl(
      {required this.entryType,
      this.loading = false,
      required this.projectId,
      this.dateOfRecord,
      this.facilityModel,
      this.stockModel,
      this.primaryType,
      this.primaryId,
      final List<StockModel> existingStocks = const []})
      : _existingStocks = existingStocks,
        super._();

  @override
  final StockRecordEntryType entryType;
  @override
  @JsonKey()
  final bool loading;
  @override
  final String projectId;
  @override
  final DateTime? dateOfRecord;
  @override
  final FacilityModel? facilityModel;
  @override
  final StockModel? stockModel;
  @override
  final String? primaryType;
  @override
  final String? primaryId;
  final List<StockModel> _existingStocks;
  @override
  @JsonKey()
  List<StockModel> get existingStocks {
    if (_existingStocks is EqualUnmodifiableListView) return _existingStocks;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_existingStocks);
  }

  @override
  String toString() {
    return 'RecordStockState.create(entryType: $entryType, loading: $loading, projectId: $projectId, dateOfRecord: $dateOfRecord, facilityModel: $facilityModel, stockModel: $stockModel, primaryType: $primaryType, primaryId: $primaryId, existingStocks: $existingStocks)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RecordStockCreateStateImpl &&
            (identical(other.entryType, entryType) ||
                other.entryType == entryType) &&
            (identical(other.loading, loading) || other.loading == loading) &&
            (identical(other.projectId, projectId) ||
                other.projectId == projectId) &&
            (identical(other.dateOfRecord, dateOfRecord) ||
                other.dateOfRecord == dateOfRecord) &&
            (identical(other.facilityModel, facilityModel) ||
                other.facilityModel == facilityModel) &&
            (identical(other.stockModel, stockModel) ||
                other.stockModel == stockModel) &&
            (identical(other.primaryType, primaryType) ||
                other.primaryType == primaryType) &&
            (identical(other.primaryId, primaryId) ||
                other.primaryId == primaryId) &&
            const DeepCollectionEquality()
                .equals(other._existingStocks, _existingStocks));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      entryType,
      loading,
      projectId,
      dateOfRecord,
      facilityModel,
      stockModel,
      primaryType,
      primaryId,
      const DeepCollectionEquality().hash(_existingStocks));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RecordStockCreateStateImplCopyWith<_$RecordStockCreateStateImpl>
      get copyWith => __$$RecordStockCreateStateImplCopyWithImpl<
          _$RecordStockCreateStateImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            StockRecordEntryType entryType,
            bool loading,
            String projectId,
            DateTime? dateOfRecord,
            FacilityModel? facilityModel,
            StockModel? stockModel,
            String? primaryType,
            String? primaryId,
            List<StockModel> existingStocks)
        create,
    required TResult Function(
            StockRecordEntryType entryType,
            String projectId,
            DateTime? dateOfRecord,
            FacilityModel? facilityModel,
            StockModel? stockModel,
            String? primaryType,
            String? primaryId,
            List<StockModel> existingStocks)
        persisted,
  }) {
    return create(entryType, loading, projectId, dateOfRecord, facilityModel,
        stockModel, primaryType, primaryId, existingStocks);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            StockRecordEntryType entryType,
            bool loading,
            String projectId,
            DateTime? dateOfRecord,
            FacilityModel? facilityModel,
            StockModel? stockModel,
            String? primaryType,
            String? primaryId,
            List<StockModel> existingStocks)?
        create,
    TResult? Function(
            StockRecordEntryType entryType,
            String projectId,
            DateTime? dateOfRecord,
            FacilityModel? facilityModel,
            StockModel? stockModel,
            String? primaryType,
            String? primaryId,
            List<StockModel> existingStocks)?
        persisted,
  }) {
    return create?.call(entryType, loading, projectId, dateOfRecord,
        facilityModel, stockModel, primaryType, primaryId, existingStocks);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            StockRecordEntryType entryType,
            bool loading,
            String projectId,
            DateTime? dateOfRecord,
            FacilityModel? facilityModel,
            StockModel? stockModel,
            String? primaryType,
            String? primaryId,
            List<StockModel> existingStocks)?
        create,
    TResult Function(
            StockRecordEntryType entryType,
            String projectId,
            DateTime? dateOfRecord,
            FacilityModel? facilityModel,
            StockModel? stockModel,
            String? primaryType,
            String? primaryId,
            List<StockModel> existingStocks)?
        persisted,
    required TResult orElse(),
  }) {
    if (create != null) {
      return create(entryType, loading, projectId, dateOfRecord, facilityModel,
          stockModel, primaryType, primaryId, existingStocks);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(RecordStockCreateState value) create,
    required TResult Function(RecordStockPersistedState value) persisted,
  }) {
    return create(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(RecordStockCreateState value)? create,
    TResult? Function(RecordStockPersistedState value)? persisted,
  }) {
    return create?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(RecordStockCreateState value)? create,
    TResult Function(RecordStockPersistedState value)? persisted,
    required TResult orElse(),
  }) {
    if (create != null) {
      return create(this);
    }
    return orElse();
  }
}

abstract class RecordStockCreateState extends RecordStockState {
  factory RecordStockCreateState(
      {required final StockRecordEntryType entryType,
      final bool loading,
      required final String projectId,
      final DateTime? dateOfRecord,
      final FacilityModel? facilityModel,
      final StockModel? stockModel,
      final String? primaryType,
      final String? primaryId,
      final List<StockModel> existingStocks}) = _$RecordStockCreateStateImpl;
  RecordStockCreateState._() : super._();

  @override
  StockRecordEntryType get entryType;
  bool get loading;
  @override
  String get projectId;
  @override
  DateTime? get dateOfRecord;
  @override
  FacilityModel? get facilityModel;
  @override
  StockModel? get stockModel;
  @override
  String? get primaryType;
  @override
  String? get primaryId;
  @override
  List<StockModel> get existingStocks;
  @override
  @JsonKey(ignore: true)
  _$$RecordStockCreateStateImplCopyWith<_$RecordStockCreateStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$RecordStockPersistedStateImplCopyWith<$Res>
    implements $RecordStockStateCopyWith<$Res> {
  factory _$$RecordStockPersistedStateImplCopyWith(
          _$RecordStockPersistedStateImpl value,
          $Res Function(_$RecordStockPersistedStateImpl) then) =
      __$$RecordStockPersistedStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {StockRecordEntryType entryType,
      String projectId,
      DateTime? dateOfRecord,
      FacilityModel? facilityModel,
      StockModel? stockModel,
      String? primaryType,
      String? primaryId,
      List<StockModel> existingStocks});
}

/// @nodoc
class __$$RecordStockPersistedStateImplCopyWithImpl<$Res>
    extends _$RecordStockStateCopyWithImpl<$Res,
        _$RecordStockPersistedStateImpl>
    implements _$$RecordStockPersistedStateImplCopyWith<$Res> {
  __$$RecordStockPersistedStateImplCopyWithImpl(
      _$RecordStockPersistedStateImpl _value,
      $Res Function(_$RecordStockPersistedStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? entryType = null,
    Object? projectId = null,
    Object? dateOfRecord = freezed,
    Object? facilityModel = freezed,
    Object? stockModel = freezed,
    Object? primaryType = freezed,
    Object? primaryId = freezed,
    Object? existingStocks = null,
  }) {
    return _then(_$RecordStockPersistedStateImpl(
      entryType: null == entryType
          ? _value.entryType
          : entryType // ignore: cast_nullable_to_non_nullable
              as StockRecordEntryType,
      projectId: null == projectId
          ? _value.projectId
          : projectId // ignore: cast_nullable_to_non_nullable
              as String,
      dateOfRecord: freezed == dateOfRecord
          ? _value.dateOfRecord
          : dateOfRecord // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      facilityModel: freezed == facilityModel
          ? _value.facilityModel
          : facilityModel // ignore: cast_nullable_to_non_nullable
              as FacilityModel?,
      stockModel: freezed == stockModel
          ? _value.stockModel
          : stockModel // ignore: cast_nullable_to_non_nullable
              as StockModel?,
      primaryType: freezed == primaryType
          ? _value.primaryType
          : primaryType // ignore: cast_nullable_to_non_nullable
              as String?,
      primaryId: freezed == primaryId
          ? _value.primaryId
          : primaryId // ignore: cast_nullable_to_non_nullable
              as String?,
      existingStocks: null == existingStocks
          ? _value._existingStocks
          : existingStocks // ignore: cast_nullable_to_non_nullable
              as List<StockModel>,
    ));
  }
}

/// @nodoc

class _$RecordStockPersistedStateImpl extends RecordStockPersistedState {
  _$RecordStockPersistedStateImpl(
      {required this.entryType,
      required this.projectId,
      this.dateOfRecord,
      this.facilityModel,
      this.stockModel,
      this.primaryType,
      this.primaryId,
      final List<StockModel> existingStocks = const []})
      : _existingStocks = existingStocks,
        super._();

  @override
  final StockRecordEntryType entryType;
  @override
  final String projectId;
  @override
  final DateTime? dateOfRecord;
  @override
  final FacilityModel? facilityModel;
  @override
  final StockModel? stockModel;
  @override
  final String? primaryType;
  @override
  final String? primaryId;
  final List<StockModel> _existingStocks;
  @override
  @JsonKey()
  List<StockModel> get existingStocks {
    if (_existingStocks is EqualUnmodifiableListView) return _existingStocks;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_existingStocks);
  }

  @override
  String toString() {
    return 'RecordStockState.persisted(entryType: $entryType, projectId: $projectId, dateOfRecord: $dateOfRecord, facilityModel: $facilityModel, stockModel: $stockModel, primaryType: $primaryType, primaryId: $primaryId, existingStocks: $existingStocks)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RecordStockPersistedStateImpl &&
            (identical(other.entryType, entryType) ||
                other.entryType == entryType) &&
            (identical(other.projectId, projectId) ||
                other.projectId == projectId) &&
            (identical(other.dateOfRecord, dateOfRecord) ||
                other.dateOfRecord == dateOfRecord) &&
            (identical(other.facilityModel, facilityModel) ||
                other.facilityModel == facilityModel) &&
            (identical(other.stockModel, stockModel) ||
                other.stockModel == stockModel) &&
            (identical(other.primaryType, primaryType) ||
                other.primaryType == primaryType) &&
            (identical(other.primaryId, primaryId) ||
                other.primaryId == primaryId) &&
            const DeepCollectionEquality()
                .equals(other._existingStocks, _existingStocks));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      entryType,
      projectId,
      dateOfRecord,
      facilityModel,
      stockModel,
      primaryType,
      primaryId,
      const DeepCollectionEquality().hash(_existingStocks));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RecordStockPersistedStateImplCopyWith<_$RecordStockPersistedStateImpl>
      get copyWith => __$$RecordStockPersistedStateImplCopyWithImpl<
          _$RecordStockPersistedStateImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            StockRecordEntryType entryType,
            bool loading,
            String projectId,
            DateTime? dateOfRecord,
            FacilityModel? facilityModel,
            StockModel? stockModel,
            String? primaryType,
            String? primaryId,
            List<StockModel> existingStocks)
        create,
    required TResult Function(
            StockRecordEntryType entryType,
            String projectId,
            DateTime? dateOfRecord,
            FacilityModel? facilityModel,
            StockModel? stockModel,
            String? primaryType,
            String? primaryId,
            List<StockModel> existingStocks)
        persisted,
  }) {
    return persisted(entryType, projectId, dateOfRecord, facilityModel,
        stockModel, primaryType, primaryId, existingStocks);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            StockRecordEntryType entryType,
            bool loading,
            String projectId,
            DateTime? dateOfRecord,
            FacilityModel? facilityModel,
            StockModel? stockModel,
            String? primaryType,
            String? primaryId,
            List<StockModel> existingStocks)?
        create,
    TResult? Function(
            StockRecordEntryType entryType,
            String projectId,
            DateTime? dateOfRecord,
            FacilityModel? facilityModel,
            StockModel? stockModel,
            String? primaryType,
            String? primaryId,
            List<StockModel> existingStocks)?
        persisted,
  }) {
    return persisted?.call(entryType, projectId, dateOfRecord, facilityModel,
        stockModel, primaryType, primaryId, existingStocks);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            StockRecordEntryType entryType,
            bool loading,
            String projectId,
            DateTime? dateOfRecord,
            FacilityModel? facilityModel,
            StockModel? stockModel,
            String? primaryType,
            String? primaryId,
            List<StockModel> existingStocks)?
        create,
    TResult Function(
            StockRecordEntryType entryType,
            String projectId,
            DateTime? dateOfRecord,
            FacilityModel? facilityModel,
            StockModel? stockModel,
            String? primaryType,
            String? primaryId,
            List<StockModel> existingStocks)?
        persisted,
    required TResult orElse(),
  }) {
    if (persisted != null) {
      return persisted(entryType, projectId, dateOfRecord, facilityModel,
          stockModel, primaryType, primaryId, existingStocks);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(RecordStockCreateState value) create,
    required TResult Function(RecordStockPersistedState value) persisted,
  }) {
    return persisted(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(RecordStockCreateState value)? create,
    TResult? Function(RecordStockPersistedState value)? persisted,
  }) {
    return persisted?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(RecordStockCreateState value)? create,
    TResult Function(RecordStockPersistedState value)? persisted,
    required TResult orElse(),
  }) {
    if (persisted != null) {
      return persisted(this);
    }
    return orElse();
  }
}

abstract class RecordStockPersistedState extends RecordStockState {
  factory RecordStockPersistedState(
      {required final StockRecordEntryType entryType,
      required final String projectId,
      final DateTime? dateOfRecord,
      final FacilityModel? facilityModel,
      final StockModel? stockModel,
      final String? primaryType,
      final String? primaryId,
      final List<StockModel> existingStocks}) = _$RecordStockPersistedStateImpl;
  RecordStockPersistedState._() : super._();

  @override
  StockRecordEntryType get entryType;
  @override
  String get projectId;
  @override
  DateTime? get dateOfRecord;
  @override
  FacilityModel? get facilityModel;
  @override
  StockModel? get stockModel;
  @override
  String? get primaryType;
  @override
  String? get primaryId;
  @override
  List<StockModel> get existingStocks;
  @override
  @JsonKey(ignore: true)
  _$$RecordStockPersistedStateImplCopyWith<_$RecordStockPersistedStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
