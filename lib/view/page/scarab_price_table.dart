part of third_party_archive;

class PageScarabPriceTable extends StatefulWidget {
  const PageScarabPriceTable({super.key});

  @override
  PageScarabPriceTableState createState() => PageScarabPriceTableState();
}

class PageScarabPriceTableState extends State<PageScarabPriceTable> {
  final GetScarabTable getScarab = Get.put(GetScarabTable());

  String imageUrl = URL.IS_LOCAL
      ? 'http://${URL.LOCAL_URL}/v1/poe_ninja/image'
      : 'https://${URL.FORIEGN_URL}/v1/poe_ninja/image';

  // Map<String, List<PoeNinjaItem>> get data => getScarab.result.value.data;
  List<PoeNinjaItem> get rawData => getScarab.resultRaw.value.data;
  List<PoeNinjaItem> selectableItems = [];

  Map<int, PoeNinjaItem> scarabLocation = LABEL.SCARAB_LOCATION;

  int selectedGridIndex = -1;

  String hoverdString = '';
  Offset mousePosition = Offset.zero;

  @override
  Widget build(BuildContext context) {
    return GetX<GetScarabTable>(
      builder: (_) {
        if (getScarab.resultRaw.value.data == null) {
          return const Center(child: CircularProgressIndicator());
        }
        return Column(
          children: [
            if (kDebugMode)
              Row(
                children: [
                  TextButton(
                      onPressed: () {
                        Map<String, dynamic> asd =
                            scarabLocation.map((key, value) {
                          return MapEntry<String, dynamic>(
                              key.toString(), value.map);
                        });

                        print(jsonEncode(asd));
                      },
                      child: Text('print')),
                ],
              ),
            Row(
              children: [
                GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 10,
                  ),
                  itemCount: 100,
                  itemBuilder: (context, index) {
                    print(
                        'scarabLocation[index]?.name ${scarabLocation[index]?.name}');
                    // TODO : DebugMode일때 보여주는 tile
                    if (kDebugMode) {
                      return TextButton(
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(
                            Colors.white,
                          ),
                        ),
                        child: Text(
                          scarabLocation[index]?.name ?? index.toString(),
                        ),
                        onPressed: () {
                          setState(() {
                            scarabLocation[index] = selectableItems[0];
                            selectableItems.removeAt(0);
                          });
                        },
                        onLongPress: () {
                          setState(() {
                            selectableItems.add(scarabLocation[index]!);
                            selectableItems
                                .sort((a, b) => a.name.compareTo(b.name));
                            scarabLocation.remove(index);
                          });
                        },
                      );
                    }
                    // TODO : releaseMode일때 보여주는 tile
                    return !scarabLocation.containsKey(index)
                        ? Container()
                        : Tooltip(
                            message: scarabLocation[index]?.name ?? '',
                            child: Stack(
                              children: [
                                Image.network(
                                  '$imageUrl/${scarabLocation[index]?.icon}',
                                ),
                                Text(
                                  scarabLocation[index]
                                          ?.chaosValue
                                          .toString() ??
                                      '',
                                ),
                              ],
                            ),
                          );
                  },
                ).expand(),
                if (kDebugMode)
                  ListView.builder(
                    itemCount: selectableItems.length,
                    itemBuilder: (context, index) {
                      PoeNinjaItem item = selectableItems[index];
                      return ListTile(
                        leading: Image.network('$imageUrl/${item.icon}'),
                        title: Text(item.name,
                            style: TextStyle(
                              color: index == 0 ? Colors.amber : Colors.white,
                              fontWeight: index == 0
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            )),
                        subtitle: Text(item.chaosValue.toString()),
                      );
                    },
                  ).expand(),
              ],
            ).expand(),
          ],
        );

        // return Stack(
        //   children: [
        // for (String division in LABEL.SCARAB_DIVISION)
        //   if (shouldDisplayScarab(division))
        //     buildScarab(
        //       data[division]!,
        //       top: getTopPosition(division),
        //       left: getLeftPosition(division),
        //     ),
        // if (hoverdString != '')
        //   Positioned(
        //     // top: 0,
        //     // left: 0,
        //     top: mousePosition.dy,
        //     left: mousePosition.dx + 10,
        //     child: Container(
        //       child: Text(hoverdString),
        //       width: 200,
        //       height: 50,
        //     ),
        //   ),
        // ],
        // );
      },
    );
  }

  Widget buildScarab(
    List<PoeNinjaItem> scarabs, {
    required double top,
    required double left,
  }) {
    double width = 80;
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
                child: Tooltip(
                    message: scarab.name,
                    child: Stack(
                      children: [
                        Opacity(
                          opacity: 0.7,
                          child: Image.network(
                            '$imageUrl/${scarab.icon}',
                          ),
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: Text('${scarab.chaosValue}'),
                        ),
                      ],
                    )),
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

  Future<void> fetch() async {
    // return await getScarab.get();
    RestfulResult getRawResult = await getScarab.getRaw();
    setState(() {
      // selectableItems = getRawResult.data;

      selectableItems = getRawResult.data.where((se) {
        return !LABEL.SCARAB_LOCATION.values.any((e) {
          return e.name == se.name;
        });
      }).toList();

      print(selectableItems.length);

      // selectableItems.removeWhere((element) {
      //   return LABEL.SCARAB_LOCATION.values.contains(element.name);
      // });

      selectableItems.sort((a, b) => a.name.compareTo(b.name));
    });
  }
}
