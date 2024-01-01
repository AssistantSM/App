class AppImage {
  static const String imageAssetPathPrefix = 'assets/img';
  static const String base = '$imageAssetPathPrefix/';
  static const String unknown = base + 'unknown.png';
  static const String rating = 'rating/';
  static const String tile = 'tile/';
  static const String raid = 'raid/';
  static const String drawerFolder = 'drawer/';

  static const String drawer = base + 'drawerHeader.png';
  static const String steamNewsDefault = base + 'steamNewsDefault.jpg';
  static const String dimensionsCube = base + 'dimensionsCube.png';
  static const String dimensionsCylinder = base + 'dimensionsCylinder.png';
  static const String chest = base + 'chest.png';
  static const String chestGold = base + 'chestGold.png';
  static const String upgradeButton = base + 'upgradeButton.png';
  static const String componentKit = base + 'componentKit.png';
  static const String successForm = base + 'successForm.png';

  static const String whatIsNew = drawerFolder + 'whatIsNew.png';
  static const String twitter = drawerFolder + 'twitter.png';
  static const String github = drawerFolder + 'github.png';
  static const String patreon = drawerFolder + 'patreon.png';
  static const String assistantApps = drawerFolder + 'assistantApps.png';

  static const String buyMeACoffee = 'donation/buyMeACoffee.png';

  static const String dark = 'dark/';
  static const String light = 'light/';
  static String _darkLightFolder(bool isDark) => isDark ? dark : light;

  static String buoyancy(bool isDark) =>
      base + rating + _darkLightFolder(isDark) + 'buoyancy.png';
  static String durability(bool isDark) =>
      base + rating + _darkLightFolder(isDark) + 'durability.png';
  static String flammable(bool isDark) =>
      base + rating + _darkLightFolder(isDark) + 'flammable.png';
  static String friction(bool isDark) =>
      base + rating + _darkLightFolder(isDark) + 'friction.png';
  static String weight(bool isDark) =>
      base + rating + _darkLightFolder(isDark) + 'weight.png';
  static String health(bool isDark) =>
      base + rating + _darkLightFolder(isDark) + 'heart.png';
  static String food(bool isDark) =>
      base + rating + _darkLightFolder(isDark) + 'food.png';
  static String water(bool isDark) =>
      base + rating + _darkLightFolder(isDark) + 'water.png';

  static const String block = base + tile + 'block.png';
  static const String cookingTile = base + tile + 'cooking.png';
  static const String craftTile = base + tile + 'craft.png';
  static const String dressTile = base + tile + 'dress.png';
  static const String raidTile = base + tile + 'raid.png';
  static const String refinerTile = base + tile + 'refiner.png';
  static const String resourceTile = base + tile + 'resource.png';
  static const String traderTile = base + tile + 'trader.png';
  static const String workshopTile = base + tile + 'workshop.png';

  static const String customLoading = base + 'loading.png';
  static const String translate = base + 'translate.png';

  static const String outfitCommon = base + 'outfitCommon.png';
  static const String outfitRare = base + 'outfitRare.png';
  static const String outfitEpic = base + 'outfitEpic.png';

  static const String totebot = base + raid + 'totebot.png';
  static const String haybot = base + raid + 'haybot.png';
  static const String tapebot = base + raid + 'tapebot.png';
  static const String farmbot = base + raid + 'farmbot.png';

  static const String assistantSMSWindowIcon = 'window_icon.png';
}
