import 'package:collection/collection.dart';
import 'package:digit_components/digit_components.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../../blocs/localization/app_localization.dart';
import '../../models/entities/facility.dart';
import '../../router/app_router.dart';
import '../../widgets/header/back_navigation_help_header.dart';
import '../../utils/i18_key_constants.dart' as i18;

class FacilitySelectionPage extends StatelessWidget {
  final List<FacilityModel> facilities;

  const FacilitySelectionPage({
    Key? key,
    required this.facilities,
  }) : super(key: key);

  static const _facilityName = 'facilityKey';
  static const _selectedFacility = 'selectedFacilityKey';

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);
    final BorderSide borderSide = BorderSide(
      color: theme.colorScheme.outline,
      width: 1.0,
    );
    final localizations = AppLocalizations.of(context);

    return ReactiveFormBuilder(
      form: _form,
      builder: (context, form, child) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: ReactiveFormConsumer(
            builder: (context, form, _) {
              final filteredFacilities = facilities.where((element) {
                final query = form.control(_facilityName).value as String?;
                if (query == null || query.isEmpty) return true;
                final name = element.name ?? "";
                if (name.toLowerCase().contains(query.toLowerCase())) {
                  return true;
                }

                return false;
              });

              return ScrollableContent(
                backgroundColor: Colors.white,
                header: const BackNavigationHelpHeaderWidget(
                  showHelp: false,
                ),
                slivers: [
                  SliverToBoxAdapter(
                   child: Padding(padding: const EdgeInsets.all(16),
                      child: DigitTextFormField(
                        label: localizations.translate(
                          i18.stockReconciliationDetails.facilityNameCommunitySupervisor,
                      ), 
                      formControlName: _facilityName,
                        ),
                      ),
                    ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final facility = filteredFacilities.elementAt(index);

                        return Container(
                          color: Colors.white,
                          padding: const EdgeInsets.only(left: 8, right: 8),
                          child: Container(
                            margin: const EdgeInsets.only(left: 8, right: 8),
                            decoration: BoxDecoration(
                              color: DigitTheme.instance.colors.alabasterWhite,
                              border: Border(
                                top: index == 0 ? borderSide : BorderSide.none,
                                bottom: index == filteredFacilities.length - 1
                                    ? borderSide
                                    : BorderSide.none,
                                left: borderSide,
                                right: borderSide,
                              ),
                            ),
                            child: InkWell(
                              onTap: () {
                                context.router.pop(facility);
                              },
                              child: Container(
                                margin: const EdgeInsets.only(
                                  top: kPadding,
                                  left: kPadding,
                                  right: kPadding,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      DigitTheme.instance.colors.alabasterWhite,
                                  border: Border(
                                    bottom: BorderSide(
                                      //                   <--- left side
                                      color: theme.colorScheme.outline,
                                      width: 1.0,
                                    ),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    left: kPadding * 2,
                                    bottom: kPadding * 2,
                                    top: kPadding * 2,
                                  ),
                                  child: Text(facility.name ?? facility.id),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      childCount: filteredFacilities.length,
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  FormGroup _form() {
    return fb.group({
      _facilityName: FormControl<String>(),
      _selectedFacility: FormControl<FacilityModel>(
        validators: [Validators.required],
      ),
    });
  }
}

class FacilityValueAccessor
    extends ControlValueAccessor<FacilityModel, String> {
  final List<FacilityModel> models;

  FacilityValueAccessor(this.models);

  @override
  String? modelToViewValue(FacilityModel? modelValue) {
    return modelValue?.name;
  }

  @override
  FacilityModel? viewToModelValue(String? viewValue) {
    return models.firstWhereOrNull(
      (element) => (element.name == viewValue || element.id == viewValue),
    );
  }
}
