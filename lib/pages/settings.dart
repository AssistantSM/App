import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../components/bottomNavbar.dart';
import '../components/dialogs/prettyDialog.dart';
import '../components/modalBottomSheet/logsModalBottomSheet.dart';
import '../components/tilePresenters/settingTilePresenter.dart';
import '../constants/AnalyticsEvent.dart';
import '../constants/AppImage.dart';
import '../state/modules/base/appState.dart';
import '../state/modules/setting/settingViewModel.dart';

class SettingsPage extends StatelessWidget {
  SettingsPage({Key key}) : super(key: key) {
    getAnalytics().trackEvent(AnalyticsEvent.settingsPage);
  }

  void _changeBrightness(BuildContext ctx) {
    bool isDark = getTheme().getIsDark(ctx);
    getTheme().setBrightness(ctx, !isDark);
    getAnalytics().trackEvent(
        isDark ? AnalyticsEvent.lightMode : AnalyticsEvent.darkMode);
  }

  @override
  Widget build(BuildContext context) {
    return getBaseWidget().appScaffold(
      context,
      appBar: getBaseWidget().appBarForSubPage(
        context,
        showHomeAction: true,
        title: Text(getTranslations().fromKey(LocaleKey.settings)),
      ),
      body: StoreConnector<AppState, SettingViewModel>(
        converter: (store) => SettingViewModel.fromStore(store),
        builder: (_, viewModel) => getBody(context, viewModel),
      ),
      bottomNavigationBar: const BottomNavbar(),
    );
  }

  Widget getBody(BuildContext context, SettingViewModel viewModel) {
    List<Widget> widgets = List.empty(growable: true);

    widgets.add(headingSettingTilePresenter(
        getTranslations().fromKey(LocaleKey.general)));

    widgets.add(languageSettingTilePresenter(
      context,
      getTranslations().fromKey(LocaleKey.appLanguage),
      viewModel.selectedLanguage,
      onChange: (Locale locale) {
        viewModel.changeLanguage(locale);
        LocalizationMap newLocal = getTranslations()
            .getCurrentLocalizationMap(context, locale.languageCode);
        if (newLocal.code == 'it' || newLocal.code == 'zh-hans') {
          prettyDialog(
            context,
            AppImage.translate,
            getTranslations().fromKey(LocaleKey.translation),
            getTranslations()
                .fromKey(LocaleKey.translationIssue)
                .replaceAll('{0}', getTranslations().fromKey(newLocal.name)),
            onlyCancelButton: true,
          );
        }
      },
    ));

    widgets.add(boolSettingTilePresenter(
      context,
      getTranslations().fromKey(LocaleKey.darkModeEnabled),
      getTheme().getIsDark(context),
      onChange: () => _changeBrightness(context),
    ));

    widgets.add(
      headingSettingTilePresenter(getTranslations().fromKey(LocaleKey.other)),
    );

    widgets.add(linkSettingTilePresenter(
      context,
      'Logs',
      icon: Icons.code,
      onTap: () => adaptiveBottomModalSheet(
        context,
        hasRoundedCorners: true,
        builder: (BuildContext innerContext) => const LogsModalBottomSheet(),
      ),
    ));

    widgets.add(linkSettingTilePresenter(
      context,
      getTranslations().fromKey(LocaleKey.privacyPolicy),
      icon: Icons.description,
      onTap: () => launchExternalURL(ExternalUrls.privacyPolicy),
    ));

    widgets.add(linkSettingTilePresenter(
      context,
      getTranslations().fromKey(LocaleKey.termsAndConditions),
      icon: Icons.description,
      onTap: () => launchExternalURL(ExternalUrls.termsAndConditions),
    ));

    widgets.add(
      legalTilePresenter(description: LocaleKey.fairUseDisclaimer),
    );

    widgets.add(emptySpace3x());

    return listWithScrollbar(
        itemCount: widgets.length,
        itemBuilder: (context, index) => widgets[index]);
  }
}
