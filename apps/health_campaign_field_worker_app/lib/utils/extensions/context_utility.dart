part of 'extensions.dart';

extension ContextUtilityExtensions on BuildContext {
  int millisecondsSinceEpoch([DateTime? dateTime]) {
    return (dateTime ?? DateTime.now()).millisecondsSinceEpoch;
  }

  Future<String> get packageInfo async {
    final info = await PackageInfo.fromPlatform();

    return info.version;
  }

  ProjectModel get selectedProject {
    final projectBloc = _get<ProjectBloc>();

    final projectState = projectBloc.state;
    final selectedProject = projectState.selectedProject;

    if (selectedProject == null) {
      throw AppException('No project is selected');
    }

    return selectedProject;
  }

  String get projectId => selectedProject.id;

  Cycle get selectedCycle {
    final projectBloc = _get<ProjectBloc>();

    final projectState = projectBloc.state;
    final selectedCycle = projectState.selectedCycle;

    if (selectedCycle == null) {
      return const Cycle();
    }

    return selectedCycle;
  }

  ProjectType? get selectedProjectType {
    final projectBloc = _get<ProjectBloc>();

    final projectState = projectBloc.state;
    final projectType = projectState.projectType;

    if (selectedCycle == null) {
      return null;
    }

    return projectType;
  }

  List<String> get cycles {
    final projectBloc = _get<ProjectBloc>();

    final projectState = projectBloc.state;

    if (projectState.projectType?.cycles != null &&
        (projectState.projectType?.cycles?.length ?? 0) > 0) {
      List<String> resultList = [];

      for (int i = 1;
          i <= (projectState.projectType?.cycles?.length ?? 0);
          i++) {
        resultList.add('0${i.toString()}');
      }

      return resultList;
    } else {
      return [];
    }
  }

  BoundaryModel get boundary {
    final boundaryBloc = _get<BoundaryBloc>();
    final boundaryState = boundaryBloc.state;

    final selectedBoundary = boundaryState.selectedBoundaryMap.entries
        .where((element) => element.value != null)
        .lastOrNull
        ?.value;

    if (selectedBoundary == null) {
      throw AppException('No boundary is selected');
    }

    return selectedBoundary;
  }

  BeneficiaryType get beneficiaryType {
    final projectBloc = _get<ProjectBloc>();

    final projectState = projectBloc.state;

    final BeneficiaryType selectedBeneficiary =
        projectState.projectType?.beneficiaryType ==
                BeneficiaryType.household.toValue()
            ? BeneficiaryType.household
            : BeneficiaryType.individual;

    if (selectedBeneficiary == null) {
      throw AppException('No beneficiary type is selected');
    }

    return selectedBeneficiary;
  }

  BoundaryModel? get boundaryOrNull {
    try {
      return boundary;
    } catch (_) {
      return null;
    }
  }

  bool get isDownSyncEnabled {
    try {
      bool isDownSyncEnabled = loggedInUserRoles
          .where(
            (role) =>
                role.code == RolesType.communityDistributor.toValue() ||
                role.code == RolesType.healthFacilitySupervisor.toValue(),
          )
          .toList()
          .isNotEmpty;
      // TODO remove this when downsync is required
      return false;
      return isDownSyncEnabled;
    } catch (_) {
      return false;
    }
  }

  bool get isWarehouseMgr {
    try {
      bool isWarehouseMgr = loggedInUserRoles
          .where(
            (role) => (role.code == RolesType.wareHouseManager.toValue() ||
                role.code == RolesType.healthFacilitySupervisor.toValue()),
          )
          .toList()
          .isNotEmpty;

      return isWarehouseMgr;
    } catch (_) {
      return false;
    }
  }

  bool get isHealthFacilitySupervisor {
    try {
      bool isDownSyncEnabled = loggedInUserRoles
          .where(
            (role) => role.code == RolesType.healthFacilitySupervisor.toValue(),
          )
          .toList()
          .isNotEmpty;

      return isDownSyncEnabled;
    } catch (_) {
      return false;
    }
  }

  bool get isDistributor {
    try {
      bool isDistributorUser = loggedInUserRoles
          .where(
            (role) => role.code == RolesType.communityDistributor.toValue(),
          )
          .toList()
          .isNotEmpty;

      return isDistributorUser;
    } catch (_) {
      return false;
    }
  }

  bool get isSupervisor {
    try {
      bool isSupervisorUser = loggedInUserRoles
          .where(
            (role) => role.code == RolesType.communitySupervisor.toValue(),
          )
          .toList()
          .isNotEmpty;

      return isSupervisorUser;
    } catch (_) {
      return false;
    }
  }

  List<UserRoleModel> get loggedInUserRoles {
    final authBloc = _get<AuthBloc>();
    final userRequestObject = authBloc.state.whenOrNull(
      authenticated: (
        accessToken,
        refreshToken,
        userModel,
        actionsWrapper,
        individualId,
        spaq1,
        spaq2,
      ) {
        return userModel.roles;
      },
    );

    if (userRequestObject == null) {
      throw AppException('User not authenticated');
    }

    return userRequestObject;
  }

  String? get loggedInIndividualId {
    final authBloc = _get<AuthBloc>();
    final individualUUID = authBloc.state.whenOrNull(
      authenticated: (
        accessToken,
        refreshToken,
        userModel,
        actionsWrapper,
        individualId,
        spaq1,
        spaq2,
      ) {
        return individualId;
      },
    );

    if (individualUUID == null) {
      return null;
    }

    return individualUUID;
  }

  int get spaq1 {
    final authBloc = _get<AuthBloc>();
    final spaq1 = authBloc.state.whenOrNull(
      authenticated: (
        accessToken,
        refreshToken,
        userModel,
        actionsWrapper,
        individualId,
        spaq1,
        spaq2,
      ) {
        return spaq1;
      },
    );

    if (spaq1 == null) {
      return 0;
    }

    return spaq1;
  }

  int get spaq2 {
    final authBloc = _get<AuthBloc>();
    final spaq2 = authBloc.state.whenOrNull(
      authenticated: (
        accessToken,
        refreshToken,
        userModel,
        actionsWrapper,
        individualId,
        spaq1,
        spaq2,
      ) {
        return spaq2;
      },
    );

    if (spaq2 == null) {
      return 0;
    }

    return spaq2;
  }

  String get loggedInUserUuid => loggedInUser.uuid;

  UserRequestModel get loggedInUser {
    final authBloc = _get<AuthBloc>();
    final userRequestObject = authBloc.state.whenOrNull(
      authenticated: (
        accessToken,
        refreshToken,
        userModel,
        actions,
        individualId,
        spaq1,
        spaq2,
      ) {
        return userModel;
      },
    );

    if (userRequestObject == null) {
      throw AppException('User not authenticated');
    }

    return userRequestObject;
  }

  bool get showProgressBar {
    UserRequestModel loggedInUser;

    try {
      loggedInUser = this.loggedInUser;
    } catch (_) {
      return false;
    }

    for (final role in loggedInUser.roles) {
      switch (role.code) {
        case "REGISTRAR":
        case "DISTRIBUTOR":
        case "COMMUNITY_DISTRIBUTOR":
          return true;
        default:
          break;
      }
    }

    return false;
  }

  NetworkManager get networkManager => read<NetworkManager>();

  DataRepository<D, R>
      repository<D extends EntityModel, R extends EntitySearchModel>() =>
          networkManager.repository<D, R>(this);

  T _get<T extends BlocBase>() {
    try {
      final bloc = read<T>();

      return bloc;
    } on ProviderNotFoundException catch (_) {
      throw AppException(
        '${T.runtimeType} not found in the current context',
      );
    } catch (error) {
      throw AppException('Could not fetch ${T.runtimeType}');
    }
  }
}
