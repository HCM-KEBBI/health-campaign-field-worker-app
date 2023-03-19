import 'package:auto_route/auto_route.dart';
import 'package:digit_components/digit_components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:isar/isar.dart';
import 'package:location/location.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../blocs/boundary/boundary.dart';
import '../blocs/household_details/household_details.dart';
import '../blocs/sync/sync.dart';
import '../data/local_store/no_sql/schema/oplog.dart';
import '../models/data_model.dart';
import '../utils/utils.dart';
import '../widgets/sidebar/side_bar.dart';

class AuthenticatedPageWrapper extends StatefulWidget {
  const AuthenticatedPageWrapper({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return AuthenticatedPageWrapperState();
  }
}

class AuthenticatedPageWrapperState extends State<AuthenticatedPageWrapper> {
  bool visiable = false;
  String selectedBoundaryValue = '';
  int random = 0;

  @override
  Widget build(BuildContext context) {
    return Portal(
      child: (Scaffold(
        appBar: AppBar(
          actions: [
            BlocConsumer<BoundaryBloc, BoundaryState>(
              listener: (ctx, state) {
                state.maybeWhen(
                  orElse: () {},
                  loading: () {
                    Loaders.showLoadingDialog(context);
                  },
                  fetched:
                      (boundaryList, boundaryMapperList, selectedBoundary) {
                    if (boundaryList.isEmpty) return;

                    if (selectedBoundary == null) {
                      setState(() {
                        visiable = true;
                      });
                    }
                  },
                );
              },
              builder: (context, boundaryState) {
                return PortalTarget(
                  visible: visiable,
                  portalFollower: boundaryState.maybeWhen(
                    orElse: () {},
                    loading: () {
                      Loaders.showLoadingDialog(context);
                    },
                    fetched:
                        (boundaryList, boundaryMapperList, selectedBoundary) {
                      return DigitCard(
                        margin: EdgeInsets.only(
                          top: kToolbarHeight * 2,
                          left: 8,
                          right: 8,
                          bottom: MediaQuery.of(context).size.height / 2,
                        ),
                        child: ReactiveFormBuilder(
                          form: buildForm,
                          builder: (context, form, child) {
                            form.addAll(
                              Map.fromEntries(
                                boundaryMapperList.map(
                                  (e) => MapEntry(
                                    e,
                                    FormControl<String>(),
                                  ),
                                ),
                              ),
                            );

                            return SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: Container(
                                color: Colors.white,
                                height: MediaQuery.of(context).size.height / 4,
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      ...boundaryMapperList
                                          .map((e) => StatefulBuilder(
                                                builder:
                                                    (contex, setBuiderState) {
                                                  return DigitDropdown<String>(
                                                    label: e,
                                                    menuItems: boundaryList
                                                        .where((ele) => form
                                                                    .control(e)
                                                                    .value !=
                                                                null
                                                            ? ele.label == e &&
                                                                ele.name
                                                                    .toString()
                                                                    .contains(
                                                                      form
                                                                          .control(
                                                                            e,
                                                                          )
                                                                          .value
                                                                          .toString(),
                                                                    )
                                                            : ele.label == e)
                                                        .toList()
                                                        .map((ele) =>
                                                            ele.name.toString())
                                                        .toList()
                                                        .toSet()
                                                        .toList(),
                                                    formControlName: e,
                                                    valueMapper: (value) =>
                                                        value,
                                                    onChanged: (value) {
                                                      (boundaryMapperList
                                                          .forEach((item) {
                                                        if (e == item) {
                                                          (form
                                                              .control(item)
                                                              .value = value);
                                                          setBuiderState(() {
                                                            random = random + 1;
                                                          });
                                                        }
                                                      }));
                                                    },
                                                  );
                                                },
                                              ))
                                          .toList(),
                                      Container(
                                        margin: const EdgeInsets.only(
                                          top: 16,
                                          bottom: 16,
                                        ),
                                        child: ReactiveFormConsumer(
                                          builder: (context, form, child) =>
                                              DigitElevatedButton(
                                            onPressed: () {
                                              String selectedBoundary = '';
                                              (boundaryMapperList
                                                  .forEach((item) {
                                                if (form.control(item).value !=
                                                    null) {
                                                  selectedBoundary =
                                                      form.control(item).value;
                                                }
                                              }));

                                              if (selectedBoundary != '') {
                                                context
                                                    .read<BoundaryBloc>()
                                                    .add(BoundaryEvent.select(
                                                      selectedBoundary:
                                                          selectedBoundary,
                                                    ));
                                              }
                                              setState(() {
                                                visiable = false;
                                                selectedBoundaryValue =
                                                    selectedBoundary;
                                              });
                                            },
                                            child: const Text('Submit'),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                  child: TextButton(
                    onPressed: () {
                      boundaryState.maybeWhen(
                        fetched: (
                          value,
                          boundaryMapperList,
                          selectedBoundary,
                        ) async {
                          setState(() {
                            visiable = true;
                          });
                        },
                        orElse: () {},
                      );
                    },
                    child: Text(selectedBoundaryValue),
                  ),
                );
              },
            ),
          ],
        ),
        drawer: Container(
          margin: const EdgeInsets.only(top: kToolbarHeight * 1.36),
          child: const Drawer(child: SideBar()),
        ),
        body: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) {
                final userId = context.loggedInUserUuid;

                final isar = context.read<Isar>();
                final bloc = SyncBloc(
                  isar: isar,
                  networkManager: context.read(),
                )..add(SyncRefreshEvent(userId));

                isar.opLogs
                    .filter()
                    .createdByEqualTo(userId)
                    .isSyncedEqualTo(false)
                    .watch()
                    .listen(
                  (event) {
                    bloc.add(
                      SyncRefreshEvent(
                        userId,
                        event.where((element) {
                          switch (element.entityType) {
                            case DataModelType.household:
                            case DataModelType.individual:
                            case DataModelType.task:
                            case DataModelType.householdMember:
                            case DataModelType.projectBeneficiary:
                            case DataModelType.stock:
                            case DataModelType.stockReconciliation:
                            case DataModelType.service:
                              return true;
                            default:
                              return false;
                          }
                        }).length,
                      ),
                    );
                  },
                );

                return bloc;
              },
            ),
            BlocProvider(
              create: (_) => LocationBloc(location: Location())
                ..add(const LoadLocationEvent()),
            ),
            BlocProvider(
              create: (_) =>
                  HouseholdDetailsBloc(const HouseholdDetailsState()),
            ),
          ],
          child: const AutoRouter(),
        ),
      )),
    );
  }

  FormGroup buildForm() => fb.group({});
}
