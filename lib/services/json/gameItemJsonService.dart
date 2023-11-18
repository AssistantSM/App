import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';

import '../../contracts/gameItem/gameItem.dart';
import '../../contracts/gameItem/gameItemBase.dart';
import '../../contracts/gameItem/gameItemLang.dart';
import '../../mapper/gameItemMapper.dart';
import './interface/IGameItemJsonService.dart';

class GameItemJsonService extends BaseJsonService
    implements IGameItemJsonService {
  String baseJson;
  LocaleKey detailsJsonLocale;
  GameItemJsonService(this.baseJson, this.detailsJsonLocale);
  //
  @override
  Future<ResultWithValue<List<GameItem>>> getAll(context) async {
    String detailJson = getTranslations().fromKey(detailsJsonLocale);
    try {
      List responseJson = await getListfromJson(context, baseJson);
      List responseDetailsJson = await getListfromJson(context, detailJson);
      List<GameItemBase> baseItems =
          responseJson.map((m) => GameItemBase.fromJson(m)).toList();
      List<GameItemLang> detailedItems =
          responseDetailsJson.map((m) => GameItemLang.fromJson(m)).toList();

      return ResultWithValue<List<GameItem>>(
          true, mapGameItemItems(context, baseItems, detailedItems), '');
    } catch (exception) {
      getLog().e(
          "GameItemJsonService($baseJson, $detailJson) Exception: ${exception.toString()}");
      return ResultWithValue<List<GameItem>>(
          false, List.empty(growable: true), exception.toString());
    }
  }

  @override
  Future<ResultWithValue<GameItem>> getById(context, String id) async {
    ResultWithValue<List<GameItem>> allGenericItemsResult =
        await getAll(context);
    if (allGenericItemsResult.hasFailed) {
      return ResultWithValue(
        false,
        GameItem.initial(),
        allGenericItemsResult.errorMessage,
      );
    }
    try {
      GameItem selectedGeneric =
          allGenericItemsResult.value.firstWhere((r) => r.id == id);
      return ResultWithValue<GameItem>(true, selectedGeneric, '');
    } catch (exception) {
      getLog().e(
          "GameItemJsonService($baseJson) Exception: ${exception.toString()}");
      return ResultWithValue<GameItem>(
        false,
        GameItem.initial(),
        exception.toString(),
      );
    }
  }
}
