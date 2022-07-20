import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../components/common/cachedFutureBuilder.dart';
import '../../components/common/positioned.dart';
import '../../components/modalBottomSheet/devDetailModalBottomSheet.dart';
import '../../components/scaffoldTemplates/genericPageScaffold.dart';
import '../../components/scrapSpecific/itemDetailComponents.dart';
import '../../components/webSpecific/mousePointer.dart';
import '../../constants/AnalyticsEvent.dart';
import '../../constants/AppImage.dart';
import '../../constants/AppPadding.dart';
import '../../constants/Routes.dart';
import '../../contracts/craftingIngredient/craftedUsing.dart';
import '../../contracts/gameItem/gameItem.dart';
import '../../contracts/gameItem/gameItemPageItem.dart';
import '../../contracts/generated/LootChance.dart';
import '../../contracts/packing/packedUsing.dart';
import '../../contracts/usedInRecipe/usedInRecipe.dart';
import '../../helpers/futureHelper.dart';
import '../../helpers/genericHelper.dart';
import '../../state/modules/base/appState.dart';
import '../../state/modules/cart/cartItemState.dart';
import '../../state/modules/gameItem/gameItemViewModel.dart';
import '../recipe/recipeDetailPage.dart';

class GameItemDetailPage extends StatelessWidget {
  final String itemId;
  final bool isInDetailPane;
  final void Function(Widget newDetailView) updateDetailView;

  GameItemDetailPage(
    this.itemId, {
    Key key,
    this.isInDetailPane = false,
    this.updateDetailView,
  }) : super(key: key) {
    getAnalytics().trackEvent('${AnalyticsEvent.itemDetailPage}: $itemId');
  }

  @override
  Widget build(BuildContext context) {
    String loading = getTranslations().fromKey(LocaleKey.loading);
    var loadingWidget = getLoading().fullPageLoading(
      context,
      loadingText: loading,
    );
    return CachedFutureBuilder<ResultWithValue<GameItemPageItem>>(
      future: gameItemPageItemFuture(context, itemId),
      whileLoading: isInDetailPane
          ? loadingWidget
          : genericPageScaffold(context, loading, null,
              body: (_, __) => loadingWidget, showShortcutLinks: true),
      whenDoneLoading:
          (AsyncSnapshot<ResultWithValue<GameItemPageItem>> snapshot) {
        StoreConnector<AppState, GameItemViewModel> bodyWidget =
            StoreConnector<AppState, GameItemViewModel>(
          converter: (store) => GameItemViewModel.fromStore(store),
          builder: (_, viewModel) => getBody(context, viewModel, snapshot),
        );
        if (isInDetailPane) return bodyWidget;
        return genericPageScaffold<ResultWithValue<GameItemPageItem>>(
          context,
          snapshot?.data?.value?.gameItem?.title ?? loading,
          snapshot,
          body: (_, __) => bodyWidget,
          showShortcutLinks: true,
        );
      },
    );
  }

  Widget getBody(
    BuildContext context,
    GameItemViewModel viewModel,
    AsyncSnapshot<ResultWithValue<GameItemPageItem>> snapshot,
  ) {
    TextEditingController controller = TextEditingController();
    Widget errorWidget = asyncSnapshotHandler(context, snapshot,
        isValidFunction: (ResultWithValue<GameItemPageItem> gameItemResult) {
      if (!gameItemResult.isSuccess) return false;
      if (gameItemResult.value == null) return false;
      return true;
    });
    if (errorWidget != null) return errorWidget;

    GameItemPageItem gameItemPage = snapshot?.data?.value;
    GameItem gameItem = gameItemPage?.gameItem;

    List<Widget> widgets = List.empty(growable: true);
    List<Widget> stackWidgets = List.empty(growable: true);

    if (gameItem.icon != null) {
      stackWidgets.add(genericItemImage(
        context,
        '${AppImage.base}${gameItem.icon}',
        name: gameItem.title,
      ));
    }

    if (gameItemPage.devDetails?.isNotEmpty == true) {
      stackWidgets.add(Positioned(
        child: GestureDetector(
          child: const Icon(Icons.code_sharp, size: 40),
          onTap: () {
            adaptiveBottomModalSheet(
              context,
              hasRoundedCorners: true,
              builder: (BuildContext innerContext) =>
                  DevDetailBottomSheet(gameItemPage.devDetails),
            );
          },
        ).showPointerOnHover,
        top: 4,
        right: 0,
      ));
    }
    widgets.add(emptySpace1x());
    widgets.add(Stack(children: stackWidgets));
    widgets.add(emptySpace1x());
    widgets.add(genericItemName(gameItem.title));
    if (gameItem.description != null && gameItem.description.isNotEmpty) {
      widgets.add(genericItemDescription(gameItem.description));
    }
    widgets.add(emptySpace1x());

    if (gameItem.isChallenge) {
      widgets.add(getModeChip(context, 'Challenge')); // TODO translate
    }
    if (gameItem.isCreative) {
      widgets.add(getModeChip(
        context,
        getTranslations().fromKey(LocaleKey.creative),
      ));
    }

    widgets.add(emptySpace1x());

    List<Widget> rowWidgets = List.empty(growable: true);

    if (gameItem.rating != null) {
      ResultWithValue<Widget> tableResult =
          getRatingTableRows(context, gameItem);
      if (tableResult.isSuccess) {
        // widgets.add(tableResult.value);
        rowWidgets.add(Card(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 450),
            padding: const EdgeInsets.all(10),
            child: tableResult.value,
          ),
        ));
      }
    }

    Future Function(String gameItemId) navigateToGameItem;
    navigateToGameItem = (String gameItemId) async {
      if (isInDetailPane && updateDetailView != null) {
        updateDetailView(GameItemDetailPage(
          gameItemId,
          isInDetailPane: isInDetailPane,
          updateDetailView: updateDetailView,
        ));
      } else {
        await getNavigation().navigateAwayFromHomeAsync(
          context,
          navigateToNamed: Routes.gameDetail,
          navigateToNamedParameters: {Routes.itemIdParam: gameItemId},
        );
      }
    };

    Future Function(String recipeItemId) navigateToRecipeItem;
    navigateToRecipeItem = (String recipeItemId) async {
      if (isInDetailPane && updateDetailView != null) {
        updateDetailView(RecipeDetailPage(
          recipeItemId,
          isInDetailPane: isInDetailPane,
          updateDetailView: updateDetailView,
        ));
      } else {
        await getNavigation().navigateAwayFromHomeAsync(
          context,
          navigateToNamed: Routes.recipeDetail,
          navigateToNamedParameters: {Routes.itemIdParam: recipeItemId},
        );
      }
    };

    if (gameItem.upgrade != null) {
      rowWidgets.add(
        itemDetailUpgradeWidget(gameItem.upgrade, navigateToGameItem),
      );
    }

    if (gameItem.box != null) {
      rowWidgets.add(itemDetailBoxWidget(context, gameItem.box));
    }

    if (gameItem.cylinder != null) {
      rowWidgets.add(itemDetailCylinderWidget(context, gameItem.cylinder));
    }

    List<LootChance> lootChances = snapshot?.data?.value?.lootChances ?? [];
    if (lootChances != null && lootChances.isNotEmpty) {
      rowWidgets.add(itemDetailLootChancesWidget(lootChances));
    }

    if (gameItem.features != null && gameItem.features.isNotEmpty) {
      rowWidgets.add(itemDetailFeaturesWidget(context, gameItem.features));
    }

    widgets.add(
      Wrap(
        alignment: WrapAlignment.center,
        children: rowWidgets,
      ),
    );

    List<CraftedUsing> craftingRecipes =
        snapshot?.data?.value?.craftingRecipes ?? [];
    widgets.addAll(itemCraftingRecipesWidget(
      context,
      craftingRecipes,
      gameItem.title,
      navigateToGameItem,
    ));

    List<UsedInRecipe> usedInRecipes =
        snapshot?.data?.value?.usedInRecipes ?? [];
    widgets.addAll(itemUsedInRecipesWidget(
      context,
      usedInRecipes,
      isInDetailPane,
      navigateToRecipeItem,
    ));

    List<PackedUsing> usedInPacking =
        snapshot?.data?.value?.packingInputs ?? [];
    if (usedInPacking.isNotEmpty) {
      widgets.addAll(itemUsedInPackingRecipesWidget(
        context,
        LocaleKey.createXUsingY,
        usedInPacking,
        (_) => Future.value(),
      ));
    }

    List<PackedUsing> packedUsing = snapshot?.data?.value?.packingOutputs ?? [];
    if (packedUsing.isNotEmpty) {
      widgets.addAll(itemUsedInPackingRecipesWidget(
        context,
        LocaleKey.createXUsingY,
        packedUsing,
        navigateToGameItem,
      ));
    }

    List<CartItemState> cartItems = viewModel.cartItems
        .where((CartItemState ci) => ci.itemId == gameItem.id)
        .toList();
    widgets.addAll(inCartWidget(context, gameItem, cartItems, viewModel));

    widgets.add(emptySpace10x());

    var fabColour = getTheme().getSecondaryColour(context);
    return Stack(
      children: [
        listWithScrollbar(
          padding: AppPadding.listSidePadding,
          itemCount: widgets.length,
          itemBuilder: (context, index) => widgets[index],
        ),
        fabPositioned(
          FloatingActionButton(
            child: const Icon(Icons.add_shopping_cart_rounded),
            backgroundColor: fabColour,
            foregroundColor: getTheme().getForegroundTextColour(fabColour),
            onPressed: () {
              getDialog().showQuantityDialog(context, controller,
                  title: getTranslations().fromKey(LocaleKey.quantity),
                  onSuccess: (BuildContext dialogCtx, String quantityString) {
                int quantity = int.tryParse(quantityString);
                if (quantity == null) return;
                viewModel.addToCart(gameItem.id, quantity);
                // getSnackbar().showSnackbar(
                //   context,
                //   LocaleKey.addedToCart,
                //   onPositiveText: getTranslations().fromKey(LocaleKey.cart),
                //   onPositive: () => getNavigation().navigateAwayFromHomeAsync(
                //     context,
                //     navigateToNamed: Routes.cart,
                //   ),
                // );
              });
            },
          ),
        ),
      ],
    );
  }
}
