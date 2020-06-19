import 'package:get_it/get_it.dart';
import 'package:scrapmechanic_kurtlourens_com/repository/LocalStorageRepository.dart';
import 'package:scrapmechanic_kurtlourens_com/repository/interface/ILocalStorageRepository.dart';

import '../env/environmentSettings.dart';
import '../helpers/repositoryHelper.dart';
import '../localization/localeKey.dart';
import '../services/LocalStorageService.dart';
import '../services/interface/IGameItemJsonService.dart';
import '../services/interface/ILocalStorageService.dart';
import '../services/interface/IRecipeJsonService.dart';
import '../services/json/gameItemJsonService.dart';
import '../services/json/recipeJsonService.dart';

final getIt = GetIt.instance;

initDependencyInjection(EnvironmentSettings _env) {
  getIt.registerSingleton<EnvironmentSettings>(_env);

  getIt.registerFactoryParam<IRecipeJsonService, LocaleKey, String>(
    (LocaleKey key, String unused) =>
        RecipeJsonService(getBaseFileName(key), key),
  );

  getIt.registerFactoryParam<IGameItemJsonService, LocaleKey, String>(
    (LocaleKey key, String unused) =>
        GameItemJsonService(getBaseFileName(key), key),
  );

  //Repository
  getIt.registerSingleton<ILocalStorageRepository>(
    LocalStorageRepository(),
  );

  //Service
  getIt.registerSingleton<ILocalStorageService>(
    LocalStorageService(),
  );
}

EnvironmentSettings getEnv() => getIt<EnvironmentSettings>();

IRecipeJsonService getRecipeRepo(LocaleKey key) =>
    getIt<IRecipeJsonService>(param1: key, param2: 'di');

IGameItemJsonService getGameItemRepo(LocaleKey key) =>
    getIt<IGameItemJsonService>(param1: key, param2: 'di');

//Repository
ILocalStorageRepository getStorageRepository() =>
    getIt<ILocalStorageRepository>();

//Service
ILocalStorageService getStorageService() => getIt<ILocalStorageService>();
