import 'package:digit_components/digit_components.dart';
import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';
import '../utils/i18_key_constants.dart' as i18;
import '../widgets/header/back_navigation_help_header.dart';
import '../widgets/localized.dart';
import '../router/app_router.dart';

class StockIssuedDetailsPage extends LocalizedStatefulWidget {
  const StockIssuedDetailsPage({
    super.key,
    super.appLocalizations,
  });
  @override
  State<StockIssuedDetailsPage> createState() => _StockIssuedDetailsPageState();
}

class _StockIssuedDetailsPageState
    extends LocalizedState<StockIssuedDetailsPage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: ReactiveFormBuilder(
        form: buildForm,
        builder: (context, form, child) {
          return ScrollableContent(
            header: Column(children: const [
              BackNavigationHelpHeaderWidget(),
            ]),
            footer: SizedBox(
              height: 90,
              child: DigitCard(
                child: DigitElevatedButton(
                  onPressed: () {
                    if (form.valid) {
                      // TODO: Complete implementation
                      context.router.push(AcknowledgementRoute());
                    } else {
                      form.markAllAsTouched();
                    }
                  },
                  child: Center(
                    child: Text(
                      localizations.translate(i18.common.coreCommonSubmit),
                    ),
                  ),
                ),
              ),
            ),
            children: [
              DigitCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      localizations.translate(
                        i18.stockDetails.stockIssuedDetailsLabel,
                      ),
                      style: theme.textTheme.displayMedium,
                    ),
                    Column(children: [
                      DigitDropdown(
                        label: localizations.translate(
                          i18.stockDetails.selectProduct,
                        ),
                        initialValue: '',
                        menuItems: [MenuItemModel('', '')],
                        onChanged: (value) {
                          // TODO: Complete implementation
                        },
                        formControlName: 'product',
                      ),
                      DigitDropdown(
                        label: localizations.translate(
                          i18.stockDetails.receivedFrom,
                        ),
                        initialValue: '',
                        menuItems: [MenuItemModel('', '')],
                        onChanged: (value) {
                          // TODO: Complete implementation
                        },
                        formControlName: 'destination',
                      ),
                      DigitTextFormField(
                        formControlName: 'quantitySent',
                        label: localizations.translate(
                          i18.stockDetails.quantitySent,
                        ),
                      ),
                      DigitTextFormField(
                        formControlName: 'noOfNetsIndicatedOnThePackingSlip',
                        label: localizations.translate(
                          i18.stockDetails.noOfNetsIndicatedOnThePackingSlip,
                        ),
                      ),
                      DigitTextFormField(
                        formControlName: 'nOOfPackingSlip',
                        label: localizations.translate(
                          i18.stockDetails.nOOfPackingSlip,
                        ),
                      ),
                    ]),
                    const SizedBox(height: 16),
                    DigitDropdown(
                      label: localizations.translate(
                        i18.stockDetails.typeOfTransport,
                      ),
                      initialValue: '',
                      menuItems: [MenuItemModel('', '')],
                      onChanged: (value) {
                        // TODO: Complete implementation
                      },
                      formControlName: 'typeOfTransport',
                    ),
                    DigitTextFormField(
                      formControlName: 'vehicleNumber',
                      label: localizations.translate(
                        i18.stockDetails.vehicleNumber,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  FormGroup buildForm() => fb.group(<String, Object>{
        'product': FormControl<String>(value: ''),
        'destination': FormControl<String>(value: ''),
        'quantitySent': FormControl<String>(value: ''),
        'noOfNetsIndicatedOnThePackingSlip': FormControl<String>(value: ''),
        'nOOfPackingSlip': FormControl<String>(value: ''),
        'typeOfTransport': FormControl<String>(value: ''),
        'vehicleNumber': FormControl<String>(value: ''),
      });
}
