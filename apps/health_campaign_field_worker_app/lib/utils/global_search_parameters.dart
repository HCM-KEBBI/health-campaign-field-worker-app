class GlobalSearchParameters {
  final bool isProximityEnabled;
  final double? latitude;
  final String? projectId;
  final double? longitude;
  final double? maxRadius;
  final String? nameSearch;
  final String? beneficiaryId;
  final int? offset;
  final int? limit;
  final int? totalCount;

  GlobalSearchParameters(
      {required this.isProximityEnabled,
      this.latitude,
      this.longitude,
      this.maxRadius,
      this.nameSearch,
      required this.beneficiaryId,
      required this.offset,
      required this.limit,
      this.totalCount,
      this.projectId});
}
