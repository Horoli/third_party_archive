part of third_party_archive;

class PageScarabPriceTable extends StatefulWidget {
  const PageScarabPriceTable({super.key});

  @override
  State<PageScarabPriceTable> createState() => PageScarabPriceTableState();
}

class PageScarabPriceTableState extends State<PageScarabPriceTable> {
  final GetScarabTable getScarab = Get.put(GetScarabTable());

  String imageUrl = URL.IS_LOCAL
      ? 'http://${URL.LOCAL_URL}/v1/poe_ninja/image'
      : 'https://${URL.FORIEGN_URL}/v1/poe_ninja/image';

  Map<String, List<PoeNinjaItem>> get data => getScarab.result.value.data;
  @override
  Widget build(BuildContext context) {
    return GetX<GetScarabTable>(
      builder: (_) {
        if (getScarab.result.value.data == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return Stack(
          children: [
            for (String division in LABEL.SCARAB_DIVISION)
              if (shouldDisplayScarab(division))
                buildScarab(
                  data[division]!,
                  top: getTopPosition(division),
                  left: getLeftPosition(division),
                ),
          ],
        );
      },
    );
  }

  Widget buildScarab(
    List<PoeNinjaItem> scarabs, {
    required double top,
    required double left,
  }) {
    double width = 75;
    double height = 55;
    return Positioned(
      top: top,
      left: left,
      width: width * scarabs.length.toDouble(),
      height: height,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: scarabs
            .map(
              (scarab) => Container(
                width: width,
                height: height,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                  ),
                ),
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Image.network('$imageUrl/${scarab.icon}').expand(),
                    Text('${scarab.chaosValue}').expand(),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    fetch();
  }

  bool shouldDisplayScarab(String division) {
    if (division == LABEL.SCARAB_TITANIC) {
      return true;
    }
    if (division == LABEL.SCARAB_ANARCHY) {
      return true;
    }
    if (division == LABEL.SCARAB_SULPHITE) {
      return true;
    }
    if (division == LABEL.SCARAB_RITUAL) {
      return true;
    }
    if (division == LABEL.SCARAB_DIVINATION) {
      return true;
    }
    if (division == LABEL.SCARAB_HARVEST) {
      return true;
    }
    if (division == LABEL.SCARAB_BESTIARY) {
      return true;
    }
    if (division == LABEL.SCARAB_INCURSION) {
      return true;
    }
    if (division == LABEL.SCARAB_INFLUENCING) {
      return true;
    }
    if (division == LABEL.SCARAB_BETRAYAL) {
      return true;
    }
    if (division == LABEL.SCARAB_TORMENT) {
      return true;
    }
    if (division == LABEL.SCARAB_HARBINGER) {
      return true;
    }
    if (division == LABEL.SCARAB_DOMINATION) {
      return true;
    }
    if (division == LABEL.SCARAB_CARTOGRAPHY) {
      return true;
    }
    if (division == LABEL.SCARAB_AMBUSH) {
      return true;
    }
    if (division == LABEL.SCARAB_EXPEDITION) {
      return true;
    }
    if (division == LABEL.SCARAB_LEGION) {
      return true;
    }
    if (division == LABEL.SCARAB_ABYSS) {
      return true;
    }
    if (division == LABEL.SCARAB_BEYOND) {
      return true;
    }
    if (division == LABEL.SCARAB_ULTIMATUM) {
      return true;
    }
    if (division == LABEL.SCARAB_DELIRIUM) {
      return true;
    }
    if (division == LABEL.SCARAB_BLIGHT) {
      return true;
    }
    if (division == LABEL.SCARAB_ESSENCE) {
      return true;
    }
    if (division == LABEL.SCARAB_BREACH) {
      return true;
    }
    // if (division == LABEL.SCARAB_HORNED) {
    //   return true;
    // }
    return false;
  }

  double getLeftPosition(String division) {
    double standard = 100;
    if (division == LABEL.SCARAB_TITANIC) {
      return standard * 1;
    } else if (division == LABEL.SCARAB_ANARCHY) {
      return standard * 1;
    } else if (division == LABEL.SCARAB_SULPHITE) {
      return standard * 4;
    } else if (division == LABEL.SCARAB_RITUAL) {
      return standard * 4;
    } else if (division == LABEL.SCARAB_DIVINATION) {
      return standard * 7;
    } else if (division == LABEL.SCARAB_HARVEST) {
      return standard * 7;
      // 여기까지 첫번째 줄
    } else if (division == LABEL.SCARAB_BESTIARY) {
      return standard * 0;
    } else if (division == LABEL.SCARAB_INCURSION) {
      return standard * 0;
    } else if (division == LABEL.SCARAB_INFLUENCING) {
      return standard * 3.5;
    } else if (division == LABEL.SCARAB_BETRAYAL) {
      return standard * 3.5;
    } else if (division == LABEL.SCARAB_TORMENT) {
      return standard * 3.5;
    } else if (division == LABEL.SCARAB_HARBINGER) {
      return standard * 7.5;
    } else if (division == LABEL.SCARAB_DOMINATION) {
      return standard * 7.5;
      // 여기까지 두번째 줄
    } else if (division == LABEL.SCARAB_CARTOGRAPHY) {
      return standard * 1;
    } else if (division == LABEL.SCARAB_AMBUSH) {
      return standard * 1;
    } else if (division == LABEL.SCARAB_EXPEDITION) {
      return standard * 1;
    } else if (division == LABEL.SCARAB_LEGION) {
      return standard * 1;
    } else if (division == LABEL.SCARAB_ABYSS) {
      return standard * 1;
    } else if (division == LABEL.SCARAB_BEYOND) {
      return standard * 6;
    } else if (division == LABEL.SCARAB_ULTIMATUM) {
      return standard * 6;
    } else if (division == LABEL.SCARAB_DELIRIUM) {
      return standard * 6;
    } else if (division == LABEL.SCARAB_BLIGHT) {
      return standard * 6;
    } else if (division == LABEL.SCARAB_ESSENCE) {
      return standard * 6;
      // 여기까지 세번째 줄
    } else if (division == LABEL.SCARAB_BREACH) {
      return standard * 3.5;
    }
    // } else if (division == LABEL.SCARAB_HORNED) {
    //   return standard * 6.5;
    // }
    return 2400; // 기본값
  }

  double getTopPosition(String division) {
    double standard = 65;
    if (division == LABEL.SCARAB_TITANIC) {
      return standard * 0;
    } else if (division == LABEL.SCARAB_ANARCHY) {
      return standard * 1;
    } else if (division == LABEL.SCARAB_SULPHITE) {
      return standard * 0;
    } else if (division == LABEL.SCARAB_RITUAL) {
      return standard;
    } else if (division == LABEL.SCARAB_DIVINATION) {
      return standard * 0;
    } else if (division == LABEL.SCARAB_HARVEST) {
      return standard * 1;
      // 여기까지 첫번째 줄
    } else if (division == LABEL.SCARAB_BESTIARY) {
      return standard * 2;
    } else if (division == LABEL.SCARAB_INCURSION) {
      return standard * 3;
    } else if (division == LABEL.SCARAB_INFLUENCING) {
      return standard * 2;
    } else if (division == LABEL.SCARAB_BETRAYAL) {
      return standard * 3;
    } else if (division == LABEL.SCARAB_TORMENT) {
      return standard * 4;
    } else if (division == LABEL.SCARAB_HARBINGER) {
      return standard * 2;
    } else if (division == LABEL.SCARAB_DOMINATION) {
      return standard * 3;
      // 여기까지 두번째 줄
    } else if (division == LABEL.SCARAB_CARTOGRAPHY) {
      return standard * 5;
    } else if (division == LABEL.SCARAB_AMBUSH) {
      return standard * 6;
    } else if (division == LABEL.SCARAB_EXPEDITION) {
      return standard * 7;
    } else if (division == LABEL.SCARAB_LEGION) {
      return standard * 8;
    } else if (division == LABEL.SCARAB_ABYSS) {
      return standard * 9;
    } else if (division == LABEL.SCARAB_BEYOND) {
      return standard * 5;
    } else if (division == LABEL.SCARAB_ULTIMATUM) {
      return standard * 6;
    } else if (division == LABEL.SCARAB_DELIRIUM) {
      return standard * 7;
    } else if (division == LABEL.SCARAB_BLIGHT) {
      return standard * 8;
    } else if (division == LABEL.SCARAB_ESSENCE) {
      return standard * 9;
      // 여기까지 세번째 줄
    } else if (division == LABEL.SCARAB_BREACH) {
      return standard * 10;
      // } else if (division == LABEL.SCARAB_HORNED) {
      //   return standard * 11;
    }
    return 1200; // 기본값
  }

  Future<RestfulResult> fetch() async {
    return await getScarab.get();
  }
}
