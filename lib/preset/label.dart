import 'package:third_party_archive/third_party_archive.dart';

const String APP_TITLE = 'ThirdPartyArchive';

const String TAG_CRAFT = 'CRAFT';
const String TAG_TRADE = 'TRADE';
const String TAG_INFO = 'INFO';
const String TAG_COMMUNITY = 'COMMUNITY';
const String TAG_CURRENCY = 'CURRENCY';
const String TAG_BUILD = 'BUILD';
const String TAG_PATCHNOTE = 'PATCHNOTE';
const String TAG_ITEMFILTER = 'ITEMFILTER';

const String BTN_DONT_SEE_AGAIN = '오늘 그만보기';
const String BTN_CLOSE = '닫기';

const String THIRD_PARTY = '써드파티앱 목록';
const String RANDOM_BUILD = '랜덤빌드 선택기';
const String NINJA_PRICE = '시세확인';
const String RECEIVING_DAMAGE = '받는피해 계산기';
const String SCARAB_TABLE = '갑충석 시세표';

const String CURRENCY = 'Currency';
const String FRAGMENT = 'Fragment';
const String SCARAB = 'Scarab';
const String MAP = 'Map';
const String INVITATION = 'invitation';

const String BUY = '구매';
const String SELL = '판매';

const String ETC = 'ETC';

const String SCARAB_TITANIC = 'Titanic Scarab';
const String SCARAB_ANARCHY = 'Anarchy Scarab';
const String SCARAB_SULPHITE = 'Sulphite Scarab';
const String SCARAB_RITUAL = 'Ritual Scarab';
const String SCARAB_DIVINATION = 'Divination Scarab';
const String SCARAB_HARVEST = 'Harvest Scarab';
const String SCARAB_BESTIARY = 'Bestiary Scarab';
const String SCARAB_INCURSION = 'Incursion Scarab';
const String SCARAB_INFLUENCING = 'Influencing Scarab';
const String SCARAB_BETRAYAL = 'Betrayal Scarab';
const String SCARAB_TORMENT = 'Torment Scarab';
const String SCARAB_HARBINGER = 'Harbinger Scarab';
const String SCARAB_DOMINATION = 'Domination Scarab';
const String SCARAB_CARTOGRAPHY = 'Cartography Scarab';
const String SCARAB_AMBUSH = 'Ambush Scarab';
const String SCARAB_EXPEDITION = 'Expedition Scarab';
const String SCARAB_LEGION = 'Legion Scarab';
const String SCARAB_ABYSS = 'Abyss Scarab';
const String SCARAB_BEYOND = 'Beyond Scarab';
const String SCARAB_ULTIMATUM = 'Ultimatum Scarab';
const String SCARAB_DELIRIUM = 'Delirium Scarab';
const String SCARAB_BLIGHT = 'Blight Scarab';
const String SCARAB_ESSENCE = 'Essence Scarab';
const String SCARAB_BREACH = 'Breach Scarab';
const String SCARAB_HORNED = 'Horned Scarab';

const List<String> SCARAB_DIVISION = [
  SCARAB_TITANIC,
  SCARAB_ANARCHY,
  SCARAB_SULPHITE,
  SCARAB_RITUAL,
  SCARAB_DIVINATION,
  SCARAB_HARVEST,
  SCARAB_BESTIARY,
  SCARAB_INCURSION,
  SCARAB_INFLUENCING,
  SCARAB_BETRAYAL,
  SCARAB_TORMENT,
  SCARAB_HARBINGER,
  SCARAB_DOMINATION,
  SCARAB_CARTOGRAPHY,
  SCARAB_AMBUSH,
  SCARAB_EXPEDITION,
  SCARAB_LEGION,
  SCARAB_ABYSS,
  SCARAB_BEYOND,
  SCARAB_ULTIMATUM,
  SCARAB_DELIRIUM,
  SCARAB_BLIGHT,
  SCARAB_ESSENCE,
  SCARAB_BREACH,
  SCARAB_HORNED,
  // 'scarab of monstrous lineage',
  // 'scarab of adversaries',
  // 'scarab of divinity',
  // 'scarab of hunted traitors',
  // 'scarab of stability',
  // 'scarab of wisps',
  // 'scarab of radiant storms',
  // 'scarab of bisection',
];

final Map<int, PoeNinjaItem> SCARAB_LOCATION = {
  "1": {
    "chaosValue": 0.9,
    "id": 113715,
    "name": "Abyss Scarab",
    "icon": "3950aa1074a16e81e7026b01bea94224f63e3c90d0a16fb3e4a3a2b7f7346b8a"
  },
  "12": {
    "chaosValue": 0.9,
    "id": 113715,
    "name": "Abyss Scarab",
    "icon": "3950aa1074a16e81e7026b01bea94224f63e3c90d0a16fb3e4a3a2b7f7346b8a"
  },
  "23": {
    "chaosValue": 1,
    "id": 113743,
    "name": "Abyss Scarab of Edifice",
    "icon": "023427d181260e08aa813aacb071bddfd3799d1c4078eac088bbbd1e67c39898"
  },
  "34": {
    "chaosValue": 0.91,
    "id": 113731,
    "name": "Abyss Scarab of Multitudes",
    "icon": "b6e03832012cddfcd4d3143aa148395aac8f379a023de5dead3da8febd8fa290"
  },
  "44": {
    "chaosValue": 1.57,
    "id": 117977,
    "name": "Abyss Scarab of Profound Depth",
    "icon": "9a6d62155447351cd9f4c477a167fcbcebcdd94e80e8aeacd682f837ff90b22c"
  },
  "43": {
    "chaosValue": 4.05,
    "id": 113728,
    "name": "Ambush Scarab",
    "icon": "375758149049af493c2ca226ae673a5630b4ee57dfb18a42cf877a78af455fe4"
  },
  "33": {
    "chaosValue": 224.91,
    "id": 113826,
    "name": "Ambush Scarab of Containment",
    "icon": "ef200d681b6c0c7cc6e230ee5a05026134486d5284e62d9c0d275e73f9668259"
  },
  "32": {
    "chaosValue": 11.53,
    "id": 113709,
    "name": "Ambush Scarab of Discernment",
    "icon": "e1c40785e872578fa02d53029502854fad2edcb4ccef170ad7d135b42d0012c1"
  },
  "42": {
    "chaosValue": 0.9,
    "id": 113738,
    "name": "Ambush Scarab of Hidden Compartments",
    "icon": "492b2d9af02e0555b44dc709cec7254e6c90e912462349ca8b42d9bf4fc6934d"
  },
  "52": {
    "chaosValue": 0.9,
    "id": 113711,
    "name": "Ambush Scarab of Potency",
    "icon": "fcff69d8fda6a69fabd847ed1a8693f82aea2504b2b875c383b3c522a9e86524"
  },
  "53": {
    "chaosValue": 0.94,
    "id": 113683,
    "name": "Anarchy Scarab",
    "icon": "0cae3cac26eb0755292ee4ea474b38f0d15c0297cf4d2f95120b054d230b3e63"
  },
  "73": {
    "chaosValue": 1.67,
    "id": 113729,
    "name": "Anarchy Scarab of Gigantification",
    "icon": "cee2fc3bedba84fbe7e9ca2d9eaf7763d141bb25cbee12221b908967c4531975"
  },
  "62": {
    "chaosValue": 1,
    "id": 113765,
    "name": "Anarchy Scarab of Partnership",
    "icon": "2b98174810ecf9fef56561a687b59fadd590ecaa984c09f29f82930db0b66d1a"
  }
}.map((key, value) =>
    MapEntry(int.parse(key), PoeNinjaItem.fromMap(item: value)));
