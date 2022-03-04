import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

import '../../components/tilePresenters/raidTilePresenter.dart';
import '../../helpers/raidHelper.dart';
import '../../state/modules/raid/raidViewModel.dart';

const greenyDevGithubImage =
    'https://avatars0.githubusercontent.com/u/3734204?s=460&u=7eb6ec6aa9200855109647c7fcdd159069b673fe&v=4';
const greenyDevGithubLink = 'https://github.com/greeny/?ref=AssistantSMS';
const greenyDevTool = 'https://scrapmechanic.greeny.dev/?ref=AssistantSMS';

class RaidCalcMobileInputScreen extends StatelessWidget {
  final RaidViewModel currentDetails;
  const RaidCalcMobileInputScreen(this.currentDetails, {Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var currentPlants = RaidHelper.getPlantsWithQuantity(currentDetails);
    bool hasAllPlants = currentPlants.length >= RaidHelper.plants.length;

    List<Widget> columnWidgets = List.empty(growable: true);
    Future<void> Function() onGreenyPress;
    onGreenyPress = () => launchExternalURL(greenyDevTool);
    columnWidgets.add(ListTile(
      leading: Padding(
        padding: const EdgeInsets.only(right: 6),
        child: networkImage(
          greenyDevGithubImage,
          boxfit: BoxFit.contain,
          height: 50.0,
          width: 50.0,
        ),
      ),
      title: Text(getTranslations().fromKey(LocaleKey.originalWorkByGreenyDev)),
      trailing: popupMenu(context, additionalItems: [
        PopupMenuActionItem(
          icon: Icons.open_in_new,
          text: 'Open tool in new Window',
          onPressed: onGreenyPress,
        )
      ]),
      onTap: onGreenyPress,
    ));

    for (var plantId in currentPlants) {
      columnWidgets.add(
        raidTilePresenter(
          context,
          plantId,
          currentDetails,
          onEdit: _setFarmQuantity,
          onDelete: (String itemId) => _setFarmQuantity(itemId, 0),
        ),
      );
    }

    if (!hasAllPlants) {
      columnWidgets.add(raidAddPlantTilePresenter(
        context,
        currentDetails,
        _setFarmQuantity,
      ));
      columnWidgets.add(emptySpace1x());
    }

    return Column(children: columnWidgets);
  }

  void _setFarmQuantity(String itemId, int quantity) {
    RaidViewModel temp = RaidHelper.setFarmDetailsQuantity(
      currentDetails,
      itemId,
      quantity,
    );

    if (temp == null) return;
    currentDetails.editRaidItem(
      carrot: temp.carrot,
      tomato: temp.tomato,
      beetroot: temp.beetroot,
      banana: temp.banana,
      berry: temp.berry,
      orange: temp.orange,
      potato: temp.potato,
      pineapple: temp.pineapple,
      broccoli: temp.broccoli,
      cotton: temp.cotton,
    );
  }
}
