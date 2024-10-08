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
  "207": {
    "chaosValue": 0.9,
    "id": 113715,
    "name": "Abyss Scarab",
    "icon": "3950aa1074a16e81e7026b01bea94224f63e3c90d0a16fb3e4a3a2b7f7346b8a"
  },
  "209": {
    "chaosValue": 1,
    "id": 113743,
    "name": "Abyss Scarab of Edifice",
    "icon": "023427d181260e08aa813aacb071bddfd3799d1c4078eac088bbbd1e67c39898"
  },
  "208": {
    "chaosValue": 0.91,
    "id": 113731,
    "name": "Abyss Scarab of Multitudes",
    "icon": "b6e03832012cddfcd4d3143aa148395aac8f379a023de5dead3da8febd8fa290"
  },
  "210": {
    "chaosValue": 1.62,
    "id": 117977,
    "name": "Abyss Scarab of Profound Depth",
    "icon": "9a6d62155447351cd9f4c477a167fcbcebcdd94e80e8aeacd682f837ff90b22c"
  },
  "156": {
    "chaosValue": 4.14,
    "id": 113728,
    "name": "Ambush Scarab",
    "icon": "375758149049af493c2ca226ae673a5630b4ee57dfb18a42cf877a78af455fe4"
  },
  "159": {
    "chaosValue": 224.92,
    "id": 113826,
    "name": "Ambush Scarab of Containment",
    "icon": "ef200d681b6c0c7cc6e230ee5a05026134486d5284e62d9c0d275e73f9668259"
  },
  "160": {
    "chaosValue": 11.53,
    "id": 113709,
    "name": "Ambush Scarab of Discernment",
    "icon": "e1c40785e872578fa02d53029502854fad2edcb4ccef170ad7d135b42d0012c1"
  },
  "157": {
    "chaosValue": 0.9,
    "id": 113738,
    "name": "Ambush Scarab of Hidden Compartments",
    "icon": "492b2d9af02e0555b44dc709cec7254e6c90e912462349ca8b42d9bf4fc6934d"
  },
  "158": {
    "chaosValue": 0.9,
    "id": 113711,
    "name": "Ambush Scarab of Potency",
    "icon": "fcff69d8fda6a69fabd847ed1a8693f82aea2504b2b875c383b3c522a9e86524"
  },
  "37": {
    "chaosValue": 0.94,
    "id": 113683,
    "name": "Anarchy Scarab",
    "icon": "0cae3cac26eb0755292ee4ea474b38f0d15c0297cf4d2f95120b054d230b3e63"
  },
  "38": {
    "chaosValue": 1.67,
    "id": 113729,
    "name": "Anarchy Scarab of Gigantification",
    "icon": "cee2fc3bedba84fbe7e9ca2d9eaf7763d141bb25cbee12221b908967c4531975"
  },
  "39": {
    "chaosValue": 1,
    "id": 113765,
    "name": "Anarchy Scarab of Partnership",
    "icon": "2b98174810ecf9fef56561a687b59fadd590ecaa984c09f29f82930db0b66d1a"
  },
  "69": {
    "chaosValue": 0.67,
    "id": 113733,
    "name": "Bestiary Scarab",
    "icon": "b0b7ff74e5fceeeebc889d7c4090c5313ff94201165961b61e51f8e9472973e4"
  },
  "71": {
    "chaosValue": 2.69,
    "id": 113726,
    "name": "Bestiary Scarab of Duplicating",
    "icon": "ece46ad4eb477d03b2dbc5b9a83c9f5df4f9e08e1940e109bc22ba2562b49e32"
  },
  "70": {
    "chaosValue": 2.5,
    "id": 113721,
    "name": "Bestiary Scarab of the Herd",
    "icon": "a37cbbf72c664ab5b528850cfb74c44339e9bdc76596d410b7d04863ce8cc07a"
  },
  "91": {
    "chaosValue": 0.72,
    "id": 113739,
    "name": "Betrayal Scarab",
    "icon": "8d701e1370fe5e41cd568d1429dc2b4fe1b4886d21e4b72c30091f8d77354010"
  },
  "92": {
    "chaosValue": 1,
    "id": 113688,
    "name": "Betrayal Scarab of Intelligence",
    "icon": "e94ed5491a73ff618df4bee33abc0837730b64fe5be817499c59d2fc51d481dd"
  },
  "93": {
    "chaosValue": 1,
    "id": 113770,
    "name": "Betrayal Scarab of Reinforcements",
    "icon": "1ddcb0c9a644318230b8e7efaa61dfc89bb0834a4e45e34ddcdd373a727770ae"
  },
  "244": {
    "chaosValue": 1.14,
    "id": 113697,
    "name": "Breach Scarab",
    "icon": "1d3af36d5930337a1bb2955b50f3b0a33044d89475dcd55f1715677191b8cb7f"
  },
  "245": {
    "chaosValue": 1,
    "id": 113734,
    "name": "Breach Scarab of Lordship",
    "icon": "f1f6e94261af613850331d0aba526fe8a0a07a28b018d10f7de7e842a687ba90"
  },
  "248": {
    "chaosValue": 7,
    "id": 117976,
    "name": "Breach Scarab of Resonant Cascade",
    "icon": "c7ee8bd0b43ac06981d36ea41cc3d29759c0d5cec5f5711c872d55238eb00bc6"
  },
  "247": {
    "chaosValue": 4,
    "id": 113879,
    "name": "Breach Scarab of Snares",
    "icon": "bcf4840c31779a377310702d40ec8f85d5b8b3665a61ed95c4b0844de4369844"
  },
  "246": {
    "chaosValue": 0.67,
    "id": 113710,
    "name": "Breach Scarab of Splintering",
    "icon": "92567643988bfc7b5c4366a82125f9314a9e7714a9514d19b5fd29e0b34202ca"
  },
  "141": {
    "chaosValue": 10,
    "id": 113706,
    "name": "Cartography Scarab of Corruption",
    "icon": "0e714cceef88bba6c073e985a02727db50ea156c79638f47c338b2055bff0bc3"
  },
  "139": {
    "chaosValue": 1.24,
    "id": 118277,
    "name": "Cartography Scarab of Escalation",
    "icon": "1cfcea496bd2abe227e520bbba40745cd27b05bd9fb0066b9f09d67e6e584381"
  },
  "140": {
    "chaosValue": 5,
    "id": 118275,
    "name": "Cartography Scarab of Risk",
    "icon": "97e82ab861f025d92262bad92f3cd44640668e962e306e5d83114c8330062681"
  },
  "142": {
    "chaosValue": 6.82,
    "id": 118273,
    "name": "Cartography Scarab of the Multitude",
    "icon": "785279c20dc9788ae48e2cc706e853d679b88ad146ebfd25e67d5554111fbd17"
  },
  "180": {
    "chaosValue": 0.7,
    "id": 113716,
    "name": "Delirium Scarab",
    "icon": "366bc71fdb2fff6ffca90f60c35b1087d7e143606e3320eeb05fcc504168bcbc"
  },
  "184": {
    "chaosValue": 0.8,
    "id": 113769,
    "name": "Delirium Scarab of Delusions",
    "icon": "1706a8ade38e3006413cd2a170bee6234ccadb833e2fa263262924a1829d7a2e"
  },
  "181": {
    "chaosValue": 1,
    "id": 113718,
    "name": "Delirium Scarab of Mania",
    "icon": "185e656604cfcaf12f80491455e5b40e65635391130c8d8ce04c60bb1ae507de"
  },
  "183": {
    "chaosValue": 0.67,
    "id": 113691,
    "name": "Delirium Scarab of Neuroses",
    "icon": "9bce7612a1524cf73e8447471b8d48f1acfb048a311383c18dcc86639f1c27f9"
  },
  "182": {
    "chaosValue": 4.5,
    "id": 113730,
    "name": "Delirium Scarab of Paranoia",
    "icon": "e3496f966e340b8d80b2c04cda85b1672933bab6f6e1a6ea473b89355100cd17"
  },
  "146": {
    "chaosValue": 0.67,
    "id": 113701,
    "name": "Beyond Scarab",
    "icon": "e8f3dac7ba18bdcf50f71658a78ec282ce2892035e301d39e72717b83eb069cd"
  },
  "147": {
    "chaosValue": 0.6,
    "id": 113747,
    "name": "Beyond Scarab of Haemophilia",
    "icon": "62199a2c11bd1ec47463b9931ecfae1133f3fcebeeb839c157a6c9880669681f"
  },
  "148": {
    "chaosValue": 0.66,
    "id": 113831,
    "name": "Beyond Scarab of Resurgence",
    "icon": "d8efd890051093d439c8c1179fe86f34d1b9b0a1c88a4997ad2f284f80337dbd"
  },
  "149": {
    "chaosValue": 1,
    "id": 113737,
    "name": "Beyond Scarab of the Invasion",
    "icon": "a33debe6e97986d2ac87c58cd830de01a663d7a4aa67821dc35ceaf9a4b06f47"
  },
  "30": {
    "chaosValue": 6,
    "id": 118282,
    "name": "Divination Scarab of Pilfering",
    "icon": "b9870b5c3f2bd0d7992a65a9fae1c426214c3430cb6a7693ff5619c616e721ef"
  },
  "29": {
    "chaosValue": 1,
    "id": 118281,
    "name": "Divination Scarab of Plenty",
    "icon": "8f84695e5cc8641a3bbd1a2b609833991681f553e2a92ee67c6ae3ed06a0a5c4"
  },
  "28": {
    "chaosValue": 5.17,
    "id": 121388,
    "name": "Divination Scarab of The Cloister",
    "icon": "0035cf63dacde7e10842806e986b08749aea82bb6c7eb1ded58ef17104292d61"
  },
  "96": {
    "chaosValue": 1,
    "id": 113740,
    "name": "Domination Scarab",
    "icon": "72028444a2fc25e9d01b42dc1eec315bd27d1ac41cffa9884d25942b245f3a84"
  },
  "97": {
    "chaosValue": 0.7,
    "id": 118279,
    "name": "Domination Scarab of Apparitions",
    "icon": "039310cf4f9992acacbaba8aa9a95eaafd49c1318527d97fdee9f30ad8b6b23c"
  },
  "98": {
    "chaosValue": 1.1,
    "id": 118284,
    "name": "Domination Scarab of Evolution",
    "icon": "221f3fe7c6947f665d2497281c30a46c3d8387aaf61a61ac14ebb2ccf10652e7"
  },
  "99": {
    "chaosValue": 29.37,
    "id": 113761,
    "name": "Domination Scarab of Terrors",
    "icon": "2496bc51cd6f953ff3b95cc026333146496a5e13ad31b1827497c70665e2d2a3"
  },
  "197": {
    "chaosValue": 0.62,
    "id": 113705,
    "name": "Blight Scarab",
    "icon": "0a846d9cb5a52cb4c7a0dc68fe2a3c224c85aa55be0e3c601c0a34d2ca8b1e8b"
  },
  "199": {
    "chaosValue": 8,
    "id": 113766,
    "name": "Blight Scarab of Blooming",
    "icon": "bb234e781d103d63645de750615d6b1500b39d3a30302f899495b5b0dc24c3a4"
  },
  "200": {
    "chaosValue": 2,
    "id": 117975,
    "name": "Blight Scarab of Invigoration",
    "icon": "f84d6e85c5e2d0b484b96b6da2ec04dab78d9c043ef5f704e12ef9de670f26b3"
  },
  "198": {
    "chaosValue": 1,
    "id": 118276,
    "name": "Blight Scarab of the Blightheart",
    "icon": "d45557938ee4d8ab7d22898da209cb5c87f71ffcf25eac05e2dafe4c2b99127c"
  },
  "214": {
    "chaosValue": 1,
    "id": 113687,
    "name": "Essence Scarab",
    "icon": "8e0c13d7d35a575bf60eaf02467001a0bcef97f48b0ed53e2c324ef6ac503998"
  },
  "218": {
    "chaosValue": 3,
    "id": 117973,
    "name": "Essence Scarab of Adaptation",
    "icon": "99c5b3a955fead8b4510cc07d9cbbc009fca26416cea45b1a5d12f32575ae913"
  },
  "215": {
    "chaosValue": 1.5,
    "id": 113745,
    "name": "Essence Scarab of Ascent",
    "icon": "dec0e1fdc2204408c4d70c861d010ccba229b0877184388636882611e9f5867f"
  },
  "217": {
    "chaosValue": 29.69,
    "id": 113945,
    "name": "Essence Scarab of Calcification",
    "icon": "143f1156e68710a5702c7c6480cd25b6e15001c316222e5cef4bf633a3ed073f"
  },
  "216": {
    "chaosValue": 0.83,
    "id": 113690,
    "name": "Essence Scarab of Stability",
    "icon": "5e8d2c327d52b1982b27108e09a0fbce372d4da5b089bb84d9b2a1878e6746d2"
  },
  "173": {
    "chaosValue": 0.67,
    "id": 113736,
    "name": "Expedition Scarab",
    "icon": "cceb0e4862d9c2b708c92a4a9cfb70d00c664364c05b18316a6e9b2541ce85d5"
  },
  "176": {
    "chaosValue": 1,
    "id": 113829,
    "name": "Expedition Scarab of Archaeology",
    "icon": "493e7bb47e5ebb9dcb4d259c4bd1070ff169c77f3fa7d835fe220a9f66be6604"
  },
  "174": {
    "chaosValue": 1,
    "id": 113746,
    "name": "Expedition Scarab of Runefinding",
    "icon": "9ba2531caaa89fc624e12f73ca0d79002a23d82a7220eaa0fb47ae1376dc2efc"
  },
  "175": {
    "chaosValue": 0.8,
    "id": 113700,
    "name": "Expedition Scarab of Verisium Powder",
    "icon": "05ae299a3d42a4449da4f521ae198899376aeb82ca595abe8bdb4665fb058ab5"
  },
  "79": {
    "chaosValue": 3.12,
    "id": 113714,
    "name": "Harbinger Scarab",
    "icon": "16e2994d5a77ded1b828d2e8c4d8257da1ff3fab4d9158d35cc31d9cc3aa34f6"
  },
  "80": {
    "chaosValue": 0.7,
    "id": 118278,
    "name": "Harbinger Scarab of Obelisks",
    "icon": "d0561b31ca112fdaeff4829edaa39827d54c1d8fd6439273fbda493cde99ffc6"
  },
  "81": {
    "chaosValue": 10,
    "id": 113749,
    "name": "Harbinger Scarab of Regency",
    "icon": "f2187d2febea0f22cade399162ce3951afbabde2303ed2342694d2bb84942f8e"
  },
  "82": {
    "chaosValue": 8.33,
    "id": 113832,
    "name": "Harbinger Scarab of Warhoards",
    "icon": "f61630d4bf36ae042a95b137ab405a98f7007d99bc2f337d112d5fab4e6b7e38"
  },
  "45": {
    "chaosValue": 0.75,
    "id": 113694,
    "name": "Harvest Scarab",
    "icon": "07e2bfb516463ef845bb47d2c1734465aff62f9acf3dbadba80d79444fef1b02"
  },
  "47": {
    "chaosValue": 48,
    "id": 113909,
    "name": "Harvest Scarab of Cornucopia",
    "icon": "fa57f5a3fc7d09b675d8c7c5fd98980a0dc1a566af83588ec0412aed02221303"
  },
  "46": {
    "chaosValue": 40,
    "id": 113827,
    "name": "Harvest Scarab of Doubling",
    "icon": "56edf1fdad608924eba239f46e1e833cfc6bdc52e57bd964d12515207e9d610b"
  },
  "284": {
    "chaosValue": 269.91,
    "id": 114030,
    "name": "Horned Scarab of Awakening",
    "icon": "76937bd4ca7525e140ae05101f69ab033e47d95597974d00105f7f1cf1167ec7"
  },
  "281": {
    "chaosValue": 120,
    "id": 113922,
    "name": "Horned Scarab of Bloodlines",
    "icon": "6ac7a51ed1e8801d101d472a9fc17ae2d4b26e6e27ca52ba2ed5e0817acdd323"
  },
  "300": {
    "chaosValue": 254.92,
    "id": 113900,
    "name": "Horned Scarab of Glittering",
    "icon": "9fdfca4878949f22d8615657f6357f1497401044a5cc21fbdedd92e2c0f5bcbc"
  },
  "282": {
    "chaosValue": 6,
    "id": 113873,
    "name": "Horned Scarab of Nemeses",
    "icon": "57e085a5ea4473b5e214d2b746816d4e920d8efb4376b9a64997d3337540a4f4"
  },
  "301": {
    "chaosValue": 35,
    "id": 113860,
    "name": "Horned Scarab of Pandemonium",
    "icon": "e1f0bb150d7199c11b7a13ecbba7c78a4e6a7eb1646d8837196e71b7897970ce"
  },
  "283": {
    "chaosValue": 374.88,
    "id": 113919,
    "name": "Horned Scarab of Preservation",
    "icon": "480daababeb0cb0e79fecc2069bcad79d6e9e39715aea137ab2ee75b3657adb0"
  },
  "285": {
    "chaosValue": 1,
    "id": 113896,
    "name": "Horned Scarab of Tradition",
    "icon": "b977d915dcbb6323d34a2e515166eef5bbc56a0127eb528f2e64182fa4e57a65"
  },
  "86": {
    "chaosValue": 0.62,
    "id": 113702,
    "name": "Incursion Scarab",
    "icon": "4bd34bb957e3136b4a89640611218aa8d8e3869fdca3758764776504042067a7"
  },
  "88": {
    "chaosValue": 0.79,
    "id": 113828,
    "name": "Incursion Scarab of Champions",
    "icon": "455660faacee1beb17307de0199aaf796d774a1e676cd8c14e8da0aae96d8885"
  },
  "87": {
    "chaosValue": 0.81,
    "id": 113707,
    "name": "Incursion Scarab of Invasion",
    "icon": "70276a2337b806cc3702b49253dcf9daaceb2a84e17227b30a9555577d3952f1"
  },
  "89": {
    "chaosValue": 28,
    "id": 113830,
    "name": "Incursion Scarab of Timelines",
    "icon": "3d645dc587e7ee2fdbdd7cec27ac9c93b0e6f289a302472b5a5155ca54108896"
  },
  "77": {
    "chaosValue": 1,
    "id": 113686,
    "name": "Influencing Scarab of Conversion",
    "icon": "281138f79a904da8b811d106139f5f16776135efeb5e37291f7ca50940b8951e"
  },
  "76": {
    "chaosValue": 1.1,
    "id": 113744,
    "name": "Influencing Scarab of Hordes",
    "icon": "2d4e28c5a6020cc4f12f75206af14282fbb5fdb84d88d6b9c4c2bf3dfdbed245"
  },
  "75": {
    "chaosValue": 0.91,
    "id": 113741,
    "name": "Influencing Scarab of the Elder",
    "icon": "d5477b422c18e464c990661e5b2f1de41c3c1d2d60b0e897a6e07fcc488248f2"
  },
  "74": {
    "chaosValue": 0.65,
    "id": 113722,
    "name": "Influencing Scarab of the Shaper",
    "icon": "3d1aed188e21b98a768ff7b0327145114c5091753b22b43d9c44ca0ff064d176"
  },
  "190": {
    "chaosValue": 1,
    "id": 113698,
    "name": "Legion Scarab",
    "icon": "02562a38bc43c26ca9f34db55a40b0bc3e74e172973fcc60a6f313910251d3a8"
  },
  "192": {
    "chaosValue": 0.67,
    "id": 113704,
    "name": "Legion Scarab of Command",
    "icon": "3953999b06326e30a8503a190b1f00a767720b8ff6283b3355f1bf35846d7cd4"
  },
  "193": {
    "chaosValue": 5,
    "id": 113875,
    "name": "Legion Scarab of Eternal Conflict",
    "icon": "413d065e311ee7b92317790e4f5dff4666bbcb8e610436ae233bf7f7f9ffc5b1"
  },
  "191": {
    "chaosValue": 1,
    "id": 113862,
    "name": "Legion Scarab of Officers",
    "icon": "a68a195cb4fccf265a0b85eac2598504358d73d789af6f01adf68141683d3060"
  },
  "43": {
    "chaosValue": 3.75,
    "id": 113760,
    "name": "Ritual Scarab of Abundance",
    "icon": "f3870e90f6010d82b85dbf7cdc5a5685b92dfef4eb864d3cae3aaa63bc7f2801"
  },
  "41": {
    "chaosValue": 1,
    "id": 113695,
    "name": "Ritual Scarab of Selectiveness",
    "icon": "5eb2fa6b8f146bcd97c9215240dc2fcad7bc4d4b3054849cd0d87a947dd0f31a"
  },
  "42": {
    "chaosValue": 1,
    "id": 118274,
    "name": "Ritual Scarab of Wisps",
    "icon": "f26bf7b4e22af24d484ee07db918f99c4db5ada3e8c6ba345f966bfdb458df1b"
  },
  "276": {
    "chaosValue": 1.5,
    "id": 113712,
    "name": "Scarab of Adversaries",
    "icon": "bda62035e312d6ca687ac407439f35ad5b48729ea0f190b6431acbf409cef0bb"
  },
  "295": {
    "chaosValue": 1,
    "id": 121392,
    "name": "Scarab of Bisection",
    "icon": "53a0613fca5fe41c9328e8db41c782f3d334ae99112c65af93e97c50eb357024"
  },
  "277": {
    "chaosValue": 1,
    "id": 118272,
    "name": "Scarab of Divinity",
    "icon": "538d105695fa2d74bac5fa073da0ad34fd57100f948047efd8799434709c8e7d"
  },
  "278": {
    "chaosValue": 1,
    "id": 113742,
    "name": "Scarab of Hunted Traitors",
    "icon": "4190e60cc03b26f0cab8b8b175a40eb030ea54d3eafcb3fede99c091abe9e91c"
  },
  "275": {
    "chaosValue": 1.3,
    "id": 113685,
    "name": "Scarab of Monstrous Lineage",
    "icon": "5bd3c6cf8ff900763505921a67041a677a845658fee5ceae00406b2c2747c82c"
  },
  "294": {
    "chaosValue": 1,
    "id": 117974,
    "name": "Scarab of Radiant Storms",
    "icon": "c1213ab29bde04f4b5d3d77887569ae4e8a2727e1bad44dbc988fd76560d5009"
  },
  "292": {
    "chaosValue": 0.83,
    "id": 113859,
    "name": "Scarab of Stability",
    "icon": "78c2bb4cb715d32652253d3d2ac32521e517ec058ab51e81bacb737d058a8095"
  },
  "293": {
    "chaosValue": 9,
    "id": 117971,
    "name": "Scarab of Wisps",
    "icon": "fd5ac7e8c621a32af6c14ecbfb089a262412522cd794e0b7acec5e8fc15c4921"
  },
  "24": {
    "chaosValue": 0.79,
    "id": 113689,
    "name": "Sulphite Scarab",
    "icon": "507dff9805f418907e7a20e956b6452693b96bbef2fd07b9fbf6a58e6f6097b7"
  },
  "25": {
    "chaosValue": 0.67,
    "id": 113713,
    "name": "Sulphite Scarab of Fumes",
    "icon": "c177d23e1c16478e6266eb4e1cfe0681c13626c3cc241a26468d2bcb31bde03d"
  },
  "20": {
    "chaosValue": 1,
    "id": 118280,
    "name": "Titanic Scarab",
    "icon": "25def812cb435f8b7c546003e3e38998c3f6766cb6959b8cbe1009190559e471"
  },
  "22": {
    "chaosValue": 3.75,
    "id": 121389,
    "name": "Titanic Scarab of Legend",
    "icon": "062a44d616c2e072604505c56b224d819ce9a61816336561b99e1198d2533fbe"
  },
  "21": {
    "chaosValue": 2,
    "id": 121391,
    "name": "Titanic Scarab of Treasures",
    "icon": "a238c5b22eb0cb04540b4743e4475711016cd0a75d1befb30eef3366085dcede"
  },
  "108": {
    "chaosValue": 0.88,
    "id": 113720,
    "name": "Torment Scarab",
    "icon": "0afb45b3cecc816646a67391e7f9ccf9992e97056bcdbc1857a63a9c3127e2b7"
  },
  "109": {
    "chaosValue": 0.6,
    "id": 113692,
    "name": "Torment Scarab of Peculiarity",
    "icon": "2b63e32c5989a1ab4a8f2cf8a75e47e4673baa06fc23e60a53344358bb763155"
  },
  "110": {
    "chaosValue": 0.65,
    "id": 117972,
    "name": "Torment Scarab of Possession",
    "icon": "001574f29a6f4e75b8e73944b68900c4e5ff5578fb9f254bd4011907361736e1"
  },
  "163": {
    "chaosValue": 0.62,
    "id": 113708,
    "name": "Ultimatum Scarab",
    "icon": "b83c6e2a041081b2c1b276a46503c3a289ec16786b6374bd5fbbaa44d0764844"
  },
  "164": {
    "chaosValue": 1.1,
    "id": 113732,
    "name": "Ultimatum Scarab of Bribing",
    "icon": "58a425b5d983b9c8ff4643fcd7dedb57b1aaac6b24e405ed23f1b4ea03dc4c31"
  },
  "166": {
    "chaosValue": 120,
    "id": 114031,
    "name": "Ultimatum Scarab of Catalysing",
    "icon": "2461b4bb521340174cab4af75fd6cb45e9ce9decd59ed522776a656f9953774d"
  },
  "165": {
    "chaosValue": 8,
    "id": 113872,
    "name": "Ultimatum Scarab of Dueling",
    "icon": "2ebc642a5a272fb01e77cc4082f496701801e0012792e63601a392d5adaa033e"
  },
  "167": {
    "chaosValue": 1,
    "id": 113771,
    "name": "Ultimatum Scarab of Inscription",
    "icon": "5c30ccb61cb3c5675d9c8dbe8db1a0adfd56f8b264ec3a55500327b024bf7bf3"
  }
}.map((key, value) =>
    MapEntry(int.parse(key), PoeNinjaItem.fromMap(item: value)));
