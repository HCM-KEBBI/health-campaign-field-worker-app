import 'package:digit_components/digit_components.dart';
import 'package:digit_components/widgets/atoms/digit_toaster.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_campaign_field_worker_app/utils/utils.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../blocs/localization/app_localization.dart';
import '../../blocs/auth/auth.dart';
import '../../blocs/boundary/boundary.dart';
import '../../router/app_router.dart';
import '../../utils/i18_key_constants.dart' as i18;

class SideBar extends StatelessWidget {
  const SideBar({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    var t = AppLocalizations.of(context);
    var tapCount = 0;

    return BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
      return Column(
        children: [
          Container(
            color: theme.colorScheme.secondary.withOpacity(0.12),
            padding: const EdgeInsets.all(kPadding),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 280,
              child: state.maybeMap(
                authenticated: (value) => Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 16.0,
                    ),
                    Text(
                      value.userModel.userName.toString(),
                      style: theme.textTheme.displayMedium,
                    ),
                    Text(
                      value.userModel.mobileNumber.toString(),
                      style: theme.textTheme.labelSmall,
                    ),
                    if (value.userModel.permanentCity != null)
                      Text(
                        value.userModel.permanentCity.toString(),
                        style: theme.textTheme.displayMedium,
                      ),
                    const SizedBox(
                      height: 16.0,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context, rootNavigator: true).pop();
                        context.router.push(UserQRDetailsRoute());
                      },
                      child: Container(
                        height: 155,
                        width: 155,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 2,
                            color: DigitTheme.instance.colorScheme.secondary,
                          ),
                        ),
                        child: QrImageView(
                          data: context.loggedInUserUuid,
                          version: QrVersions.auto,
                          size: 150.0,
                        ),
                      ),
                    ),
                  ],
                ),
                orElse: () => const Offstage(),
              ),
            ),
          ),
          DigitIconTile(
            title: AppLocalizations.of(context).translate(
              i18.common.coreCommonHome,
            ),
            icon: Icons.home,
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop();
              context.router.replace(HomeRoute());
            },
          ),
          context.isDownSyncEnabled
              ? DigitIconTile(
                  title: AppLocalizations.of(context).translate(
                    i18.common.coreCommonViewDownloadedData,
                  ),
                  icon: Icons.download,
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop();
                    context.router.push(const BeneficiariesReportRoute());
                  },
                )
              : const Offstage(),
          DigitIconTile(
            title: AppLocalizations.of(context)
                .translate(i18.common.coreCommonLogout),
            icon: Icons.logout,
            onPressed: () async {
              final isConnected = await getIsConnected();
              if (context.mounted) {
                if (isConnected) {
                  DigitDialog.show(
                    context,
                    options: DigitDialogOptions(
                      titleText: t.translate(
                        i18.common.coreCommonWarning,
                      ),
                      titleIcon: Icon(
                        Icons.warning,
                        color: DigitTheme.instance.colorScheme.error,
                      ),
                      contentText: t.translate(
                        i18.login.logOutWarningMsg,
                      ),
                      primaryAction: DigitDialogActions(
                        label: t.translate(i18.common.coreCommonNo),
                        action: (ctx) => Navigator.of(
                          context,
                          rootNavigator: true,
                        ).pop(true),
                      ),
                      secondaryAction: DigitDialogActions(
                        label: t.translate(i18.common.coreCommonYes),
                        action: (ctx) {
                          tapCount = tapCount + 1;

                          if (tapCount == 1) {
                            context
                                .read<BoundaryBloc>()
                                .add(const BoundaryResetEvent());
                            context
                                .read<AuthBloc>()
                                .add(const AuthLogoutEvent());
                            Navigator.of(
                              context,
                              rootNavigator: true,
                            ).pop(true);
                          }
                        },
                      ),
                    ),
                  );
                } else {
                  DigitToast.show(
                    context,
                    options: DigitToastOptions(
                      AppLocalizations.of(context).translate(
                        i18.login.noInternetError,
                      ),
                      true,
                      theme,
                    ),
                  );
                }
              }
            },
          ),
          PoweredByDigit(
            version: Constants().version,
          ),
        ],
      );
    });
  }
}
