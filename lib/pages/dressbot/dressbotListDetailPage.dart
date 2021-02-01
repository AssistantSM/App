import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:grouped_checkbox/grouped_checkbox.dart';

import '../../components/bottomNavbar.dart';
import '../../components/tilePresenters/gameItemTilePresenter.dart';
import '../../constants/Routes.dart';
import '../../contracts/gameItem/gameItem.dart';
import '../../contracts/search/checkboxOption.dart';
import '../../helpers/searchHelper.dart';
import '../../state/modules/base/appState.dart';
import '../../state/modules/cosmetic/cosmeticViewModel.dart';
import '../dialog/checkboxListPageDialog.dart';
import 'dressbotDetailPage.dart';

class DressBotListDetailPage extends StatelessWidget {
  final List<CheckboxOption> allItemList;
  final List<CheckboxOption> currentSelection;
  final Future<ResultWithValue<List<GameItem>>> Function(
    dynamic context,
    List<CheckboxOption> selection,
    List<String> owned, {
    bool showHat,
    bool showHair,
    bool showFace,
    bool showTorso,
    bool showBackpack,
    bool showGloves,
    bool showLegs,
    bool showShoes,
    bool showOwned,
    bool showNotOwned,
  }) getCustomisationsFiltered;
  final void Function(List<CheckboxOption> newSelection) setSelection;
  final List<String> ownedOptionList;
  final List<String> currentOwnedSelection;
  final void Function(List<String> newSelection) setOwnedSelection;
  final bool showHat;
  final bool showHair;
  final bool showFace;
  final bool showTorso;
  final bool showBackpack;
  final bool showGloves;
  final bool showLegs;
  final bool showShoes;
  final bool showOwned;
  final bool showNotOwned;

  DressBotListDetailPage(
    this.allItemList,
    this.currentSelection,
    this.getCustomisationsFiltered,
    this.setSelection,
    this.ownedOptionList,
    this.currentOwnedSelection,
    this.setOwnedSelection,
    this.showHat,
    this.showHair,
    this.showFace,
    this.showTorso,
    this.showBackpack,
    this.showGloves,
    this.showLegs,
    this.showShoes,
    this.showOwned,
    this.showNotOwned,
  );

  CheckboxOption getOption(String text) => CheckboxOption(text, value: true);

  @override
  Widget build(BuildContext context) {
    return getBaseWidget().appScaffold(
      context,
      appBar: getBaseWidget().appBarForSubPage(context,
          title: Text(getTranslations().fromKey(LocaleKey.dressBot)),
          showHomeAction: true,
          actions: [
            ActionItem(
              icon: Icons.sort,
              onPressed: () async {
                List<CheckboxOption> newSelection =
                    await getNavigation().navigateAsync(
                  context,
                  navigateTo: (context) => CheckboxListPageDialog(
                    getTranslations().fromKey(LocaleKey.dressBot),
                    this.currentSelection ?? allItemList,
                  ),
                );
                if (newSelection == null ||
                    newSelection.length != allItemList.length) return;
                for (var select in newSelection) {
                  print(select.title + ': ' + select.value.toString());
                }
                setSelection(newSelection);
              },
            )
          ]),
      body: StoreConnector<AppState, CosmeticViewModel>(
        converter: (store) => CosmeticViewModel.fromStore(store),
        builder: (_, viewModel) => ResponsiveListDetailView<GameItem>(
          () => getCustomisationsFiltered(
            context,
            this.currentSelection,
            viewModel.owned,
            showHat: showHat,
            showHair: showHair,
            showFace: showFace,
            showTorso: showTorso,
            showBackpack: showBackpack,
            showGloves: showGloves,
            showLegs: showLegs,
            showShoes: showShoes,
            showOwned: showOwned,
            showNotOwned: showNotOwned,
          ),
          gameItemTilePresenter,
          searchGameItem,
          firstListItemWidget: Column(
            children: [
              GroupedCheckbox(
                itemList: ownedOptionList,
                checkedItemList: currentOwnedSelection ?? ownedOptionList,
                onChanged: (itemList) => setOwnedSelection(itemList),
                orientation: CheckboxOrientation.HORIZONTAL,
                checkColor: Colors.white,
                activeColor: getTheme().getSecondaryColour(context),
              ),
              Divider(),
            ],
          ),
          listItemMobileOnTap: (BuildContext context, GameItem gameItem) async {
            return await getNavigation().navigateAwayFromHomeAsync(
              context,
              navigateToNamed: Routes.cosmeticDetail,
              navigateToNamedParameters: {Routes.itemIdParam: gameItem.id},
            );
          },
          listItemDesktopOnTap: (BuildContext context, GameItem recipe,
              void Function(Widget) updateDetailView) {
            return DressBotDetailPage(
              recipe.id,
              isInDetailPane: true,
              updateDetailView: updateDetailView,
            );
          },
          key: _getKeyFromSelection(
            context,
            currentSelection,
            viewModel.owned,
            currentOwnedSelection,
          ),
        ),
      ),
      bottomNavigationBar: BottomNavbar(noRouteSelected: true),
    );
  }

  Key _getKeyFromSelection(BuildContext context, List<CheckboxOption> list,
      List<String> owned, List<String> ownedSelection) {
    String temp = '';
    for (var item in list ?? List<CheckboxOption>()) {
      temp += item.title + (item.value ? '1' : '0');
    }
    for (var item in owned ?? List<String>()) {
      temp += item;
    }
    for (var item in ownedSelection ?? List<String>()) {
      temp += item;
    }
    return Key("${getTranslations().currentLanguage}$temp");
  }
}
