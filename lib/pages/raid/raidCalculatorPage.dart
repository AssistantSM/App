import 'package:flutter/material.dart';

import '../../components/adaptive/gridWithScrollbar.dart';
import '../../components/adaptive/listWithScrollbar.dart';
import '../../components/common/image.dart';
import '../../components/scaffoldTemplates/genericPageScaffold.dart';
import '../../components/tilePresenters/raidTilePresenter.dart';
import '../../contracts/raid/raidFarmDetails.dart';
import '../../helpers/external.dart';
import '../../helpers/raidHelper.dart';
import '../../localization/localeKey.dart';
import '../../localization/translations.dart';
import 'raidCalculatorResultComponent.dart';

const greenyDevGithubImage =
    'https://avatars0.githubusercontent.com/u/3734204?s=460&u=7eb6ec6aa9200855109647c7fcdd159069b673fe&v=4';
const greenyDevGithubLink = 'https://github.com/greeny';
const greenyDevTool = 'https://scrapmechanic.greeny.dev/';

class RaidCalcPage extends StatefulWidget {
  const RaidCalcPage({Key key}) : super(key: key);

  @override
  _RaidCalcWidget createState() => _RaidCalcWidget();
}

// https://scrapmechanic.greeny.dev/
class _RaidCalcWidget extends State<RaidCalcPage> {
  Widget _inputScreen = Container(width: 0, height: 0);
  _RaidCalcWidget() {
    _inputScreen = gridWithScrollbar(
      itemCount: (RaidHelper.plants.length + 1),
      itemBuilder: (context, index) {
        if (index < RaidHelper.plants.length) {
          return raidGridTilePresenter(
              context, RaidHelper.plants[index], setFarmQuantity);
        }
        return GestureDetector(
          child: Card(
            child: Column(
              children: [
                networkImage(greenyDevGithubImage, height: 110),
                Padding(
                    child: Text(
                      'Original work by GreenyDev',
                      textAlign: TextAlign.center,
                    ),
                    padding: EdgeInsets.all(8)),
              ],
            ),
          ),
          onTap: () => launchExternalURL(greenyDevTool),
        );
      },
    );
  }

  RaidFarmDetails details = RaidFarmDetails();

  void setFarmQuantity(String itemId, int quantity) {
    RaidFarmDetails temp = RaidHelper.setFarmDetailsQuantity(
      details,
      itemId,
      quantity,
    );

    if (temp == null) return;

    this.setState(() {
      details = temp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return genericPageScaffold(
      context,
      Translations.get(context, LocaleKey.raidCalculator),
      null,
      body: getBody,
      showShortcutLinks: true,
    );
  }

  Widget getBody(BuildContext context, dynamic snapshot) {
    List<Widget> columnWidgets = List<Widget>();

    columnWidgets.add(_inputScreen);
    columnWidgets.add(RaidCalculatorResultComponent(details));

    return listWithScrollbar(
        itemCount: columnWidgets.length,
        itemBuilder: (context, index) => columnWidgets[index]);
  }
}
