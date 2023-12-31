
import 'dart:convert';

CountryInfo countryInfoFromJson(String str) => CountryInfo.fromJson(json.decode(str));

String countryInfoToJson(CountryInfo data) => json.encode(data.toJson());

class CountryInfo {
  CountryInfo({
    this.country,
    this.currency,
    this.currencyCode,
    this.symbol,
    this.dialingCode,
    this.countryCode,
  });

  String? country;
  String? currency;
  String? currencyCode;
  String? symbol;
  String? dialingCode;
  String? countryCode;

  factory CountryInfo.fromJson(Map<String, dynamic> json) => CountryInfo(
    country: json["country"],
    currency: json["currency"],
    currencyCode: json["currencyCode"],
    symbol: json["symbol"],
    dialingCode: json["dialingCode"],
    countryCode: json["countryCode"],
  );

  Map<String, dynamic> toJson() => {
    "country": country,
    "currency": currency,
    "currencyCode": currencyCode,
    "symbol": symbol,
    "dialingCode": dialingCode,
    "countryCode": countryCode,
  };

   data(String country){
    Map<String, dynamic> dataInfo = jsonDecode(jsonEncode(countryInfomation[country])) as  Map<String, dynamic>;(countryInfomation[country].runtimeType);
     CountryInfo.fromJson(dataInfo);
  }
}

Map<String, dynamic> countryInfomation = {
  "Afghanistan": {
    "country": "Afghanistan",
    "currency": "Afghanistani Afghani",
    "currencyCode": "AFNAFN",
    "symbol": "؋",
    "dialingCode": "+93",
    "countryCode": "AFG",
  },
  "Armenia": {
    "country": "Armenia",
    "currency": "Armenian Dram",
    "currencyCode": "AMD",
    "symbol": "դր",
    "dialingCode": "+374",
    "countryCode": "ARM",
  },
  "Azerbaijan": {
    "country": "Azerbaijan",
    "currency": "Azerbaijani Manat",
    "currencyCode": "AZN",
    "symbol": "₼",
    "dialingCode": "+994	",
    "countryCode": "AZE",
  },
  "Bahrain": {
    "country": "Bahrain",
    "currency": "Bahraini Dinar",
    "currencyCode": "BHD",
    "symbol": ".د.ب",
    "dialingCode": "+973",
    "countryCode": "BHR",
  },
  "Bangladesh": {
    "country": "Bangladesh",
    "currency": "Bangladeshi Taka",
    "currencyCode": "BDT",
    "symbol": "৳",
    "dialingCode": "+880",
    "countryCode": "BGD",
  },
  "Bhutan": {
    "country": "Bhutan",
    "currency": "Bhutanese Ngultrum",
    "currencyCode": "BTN",
    "symbol": "Nu.",
    "dialingCode": "+975",
    "countryCode": "BTN",
  },
  "Brunei": {
    "country": "Brunei",
    "currency": "Brunei Dollar",
    "currencyCode": "BND",
    "symbol": "\$",
    "dialingCode": "+673",
    "countryCode": "BRN",
  },
  "Cambodia	KHM": {
    "country": "Cambodia",
    "currency": "Cambodian Riel",
    "currencyCode": "KHR",
    "symbol": "៛",
    "dialingCode": "+855",
    "countryCode": "KHM",
  },
  "China": {
    "country": "China",
    "currency": "Chinese Yuan Renminbi",
    "currencyCode": "CNY",
    "symbol": "¥",
    "dialingCode": "+86",
    "countryCode": "CHN",
  },
  "Cyprus": {
    "country": "Cyprus",
    "currency": "Cypriot Pound",
    "currencyCode": "CYP",
    "symbol": "£",
    "dialingCode": "+357",
    "countryCode": "CYP",
  },
  "Georgia": {
    "country": "Georgia",
    "currency": "Georgian Lari",
    "currencyCode": "GEL",
    "symbol": "ლ",
    "dialingCode": "+995",
    "countryCode": "GEO",
  },
  "India": {
    "country": "India",
    "currency": "Indian Rupee",
    "currencyCode": "INR",
    "symbol": "₹",
    "dialingCode": "+91",
    "countryCode": "IND",
  },
  "Indonesia": {
    "country": "Indonesia",
    "currency": "Indonesian Rupiah",
    "currencyCode": "IDR",
    "symbol": "Rp",
    "dialingCode": "+62",
    "countryCode": "IDN",
  },
  "Iran": {
    "country": "Iran",
    "currency": "Iranian Rial",
    "currencyCode": "IRR",
    "symbol": "﷼",
    "dialingCode": "+98",
    "countryCode": "IRN",
  },
  "Iraq": {
    "country": "Iraq",
    "currency": "Iraqi Dinar",
    "currencyCode": "IQD",
    "symbol": "ع.د",
    "dialingCode": "+964",
    "countryCode": "IRQ",
  },
  "Israel": {
    "country": "Israel",
    "currency": "Israeli New Sheqel",
    "currencyCode": "ILS",
    "symbol": "₪",
    "dialingCode": "+972",
    "countryCode": "ISR",
  },
  "Japan": {
    "country": "Japan",
    "currency": "Japanese Yen",
    "currencyCode": "JPY",
    "symbol": "¥",
    "dialingCode": "+81",
    "countryCode": "JPN",
  },
  "Jordan": {
    "country": "Jordan",
    "currency": "Jordanian Dinar",
    "currencyCode": "JOD",
    "symbol": "د.ا",
    "dialingCode": "+962",
    "countryCode": "JOR",
  },
  "Kazakhstan": {
    "country": "Kazakhstan",
    "currency": "Kazakhstani Tenge",
    "currencyCode": "KZT",
    "symbol": "лв",
    "dialingCode": "+7",
    "countryCode": "KAZ",
  },
  "Kuwait": {
    "country": "Kuwait",
    "currency": "Kuwaiti Dinar",
    "currencyCode": "KWD",
    "symbol": "د.ك",
    "dialingCode": "+965",
    "countryCode": "KWT",
  },
  "Kyrgyzstan": {
    "country": "Kyrgyzstan",
    "currency": "Kyrgyzstani Som",
    "currencyCode": "KGS",
    "symbol": "лв",
    "dialingCode": "+996",
    "countryCode": "KGZ",
  },
  "Laos": {
    "country": "Laos",
    "currency": "Lao Kip",
    "currencyCode": "LAK",
    "symbol": "₭",
    "dialingCode": "+856",
    "countryCode": "LAO",
  },
  "Lebanon": {
    "country": "Lebanon",
    "currency": "Lebanese Pound",
    "currencyCode": "LBP",
    "symbol": "£",
    "dialingCode": "+961",
    "countryCode": "LBN",
  },
  "Malaysia": {
    "country": "Malaysia",
    "currency": "Malaysian Ringgit",
    "currencyCode": "MYR",
    "symbol": "RM",
    "dialingCode": "+60",
    "countryCode": "MYS",
  },
  "Maldives": {
    "country": "Maldives",
    "currency": "Maldives Rufiyaa",
    "currencyCode": "MVR",
    "symbol": "Rf",
    "dialingCode": "+960",
    "countryCode": "MDV",
  },
  "Mongolia": {
    "country": "Mongolia",
    "currency": "Mongolian Tugrik",
    "currencyCode": "MNT",
    "symbol": "₮",
    "dialingCode": "+976",
    "countryCode": "MNG",
  },
  "Myanmar (Burma)": {
    "country": "	Myanmar (Burma)",
    "currency": "	Myanmar Kyat",
    "currencyCode": "MMK",
    "symbol": "K",
    "dialingCode": "+95",
    "countryCode": "MMR",
  },
  "Nepal": {
    "country": "Nepal",
    "currency": "Nepalese Rupee",
    "currencyCode": "NPR",
    "symbol": "₨",
    "dialingCode": "+977",
    "countryCode": "NPL",
  },
  "	North Korea": {
    "country": "	North Korea",
    "currency": "North Korean Won",
    "currencyCode": "KPW",
    "symbol": "₩",
    "dialingCode": "+850",
    "countryCode": "PRK",
  },
  "Oman": {
    "country": "Oman",
    "currency": "Omani Rial",
    "currencyCode": "OMR",
    "symbol": "﷼",
    "dialingCode": "+968",
    "countryCode": "OMN",
  },
  "Pakistan": {
    "country": "Pakistan",
    "currency": "Pakistan Rupee",
    "currencyCode": "PKR",
    "symbol": "₨",
    "dialingCode": "+92",
    "countryCode": "PAK",
  },
  "Palestine": {
    "country": "Palestine",
    "currency": "Jordanian Dinar",
    "currencyCode": "JOD",
    "symbol": "د.ا",
    "dialingCode": "+970",
    "countryCode": "PSE",
  },
  "Philippines": {
    "country": "Philippines",
    "currency": "Philippine Peso",
    "currencyCode": "PHP",
    "symbol": "₱",
    "dialingCode": "+63",
    "countryCode": "PHL",
  },
  "Qatar": {
    "country": "Qatar",
    "currency": "Qatari Riyal",
    "currencyCode": "QAR",
    "symbol": "﷼",
    "dialingCode": "+974",
    "countryCode": "QAT",
  },
  "Russia": {
    "country": "Russia",
    "currency": "Russian Ruble",
    "currencyCode": "RUB",
    "symbol": "₽",
    "dialingCode": "+7",
    "countryCode": "RUS",
  },
  "Saudi Arabia": {
    "country": "Saudi Arabia",
    "currency": "Saudi Arabian Riyal",
    "currencyCode": "SAR",
    "symbol": "﷼",
    "dialingCode": "+966",
    "countryCode": "SAU",
  },
  "Singapore": {
    "country": "Singapore",
    "currency": "Singapore Dollar",
    "currencyCode": "SGD",
    "symbol": "\$",
    "dialingCode": "+65",
    "countryCode": "SGP",
  },
  "South Korea": {
    "country": "South Korea",
    "currency": "Korean Won",
    "currencyCode": "KRW",
    "symbol": "₩",
    "dialingCode": "+82",
    "countryCode": "KOR",
  },
  "Sri Lanka": {
    "country": "Sri Lankan Rupee",
    "currency": "LKR",
    "currencyCode": "LKR",
    "symbol": "₨",
    "dialingCode": "+94",
    "countryCode": "LKA",
  },
  "Syria": {
    "country": "Syria",
    "currency": "Syrian Pound",
    "currencyCode": "SYP",
    "symbol": "£",
    "dialingCode": "+963",
    "countryCode": "SYR",
  },
  "Taiwan": {
    "country": "Taiwan",
    "currency": "New Taiwan Dollar",
    "currencyCode": "TWD",
    "symbol": "NT\$",
    "dialingCode": "+886",
    "countryCode": "TWN",
  },
  "Tajikistan": {
    "country": "Tajikistan",
    "currency": "Tajikistan Somoni",
    "currencyCode": "TJS",
    "symbol": "ЅM",
    "dialingCode": "+992",
    "countryCode": "TJK",
  },
  "Thailand": {
    "country": "Thailand",
    "currency": "Thai Baht",
    "currencyCode": "THB",
    "symbol": "฿",
    "dialingCode": "+66",
    "countryCode": "THA",
  },
  "Timor": {
    "country": "Timor",
    "currency": "United States Dollar",
    "currencyCode": "USD",
    "symbol": "\$",
    "dialingCode": "+670",
    "countryCode": "TLS",
  },
  "Turkey": {
    "country": "Turkey",
    "currency": "Turkish New Lira",
    "currencyCode": "TRY",
    "symbol": "₺",
    "dialingCode": "+90",
    "countryCode": "TUR",
  },
  "Turkmenistan": {
    "country": "Turkmenistan",
    "currency": "Turkmenistani Manat",
    "currencyCode": "TMM",
    "symbol": "T",
    "dialingCode": "+993",
    "countryCode": "TKM",
  },
  "United Arab Emirates (UAE)": {
    "country": "United",
    "currency": "United Arab Emirates Dirham	",
    "currencyCode": "AED",
    "symbol": "د.إ",
    "dialingCode": "+971",
    "countryCode": "ARE",
  },
  "Uzbekistan": {
    "country": "Uzbekistan",
    "currency": "Uzbekistani Som",
    "currencyCode": "UZS",
    "symbol": "лв",
    "dialingCode": "+998",
    "countryCode": "UZB",
  },
  "Vietnam": {
    "country": "Vietnam",
    "currency": "Viet Nam Dong",
    "currencyCode": "VND",
    "symbol": "₫",
    "dialingCode": "+84",
    "countryCode": "VNM",
  },
  "Yemen": {
    "country": "Yemen",
    "currency": "Yemeni Rial",
    "currencyCode": "YER",
    "symbol": "﷼",
    "dialingCode": "+967",
    "countryCode": "YEM",
  },
  "Algeria": {
    "country": "Algeria",
    "currency": "Algerian Dinar",
    "currencyCode": "DZD",
    "symbol": "دج",
    "dialingCode": "+213",
    "countryCode": "DZA",
  },
  "Angola": {
    "country": "Angola",
    "currency": "Angolan Kwanza",
    "currencyCode": "AOA",
    "symbol": "Kz",
    "dialingCode": "+244",
    "countryCode": "AGO",
  },
  "Benin": {
    "country": "Benin",
    "currency": "West African CFA",
    "currencyCode": "XOF",
    "symbol": "CFA",
    "dialingCode": "+229",
    "countryCode": "BEN",
  },
  "Botswana": {
    "country": "Botswana",
    "currency": "Botswana Pula",
    "currencyCode": "BWP",
    "symbol": "P",
    "dialingCode": "+267",
    "countryCode": "BWA",
  },
  "Burkina Faso": {
    "country": "Burkina",
    "currency": "West African CFA",
    "currencyCode": "XOF",
    "symbol": "CFA",
    "dialingCode": "+226",
    "countryCode": "BFA",
  },
  "Burundi": {
    "country": "Burundi",
    "currency": "Burundian Franc",
    "currencyCode": "BIF",
    "symbol": "FBu",
    "dialingCode": "+257",
    "countryCode": "BDI",
  },
  "Cape Verde": {
    "country": "Cape Verde",
    "currency": "Cape Verde Escudo",
    "currencyCode": "CVE",
    "symbol": "\$",
    "dialingCode": "+238",
    "countryCode": "CPV",
  },
  "Cameroon": {
    "country": "Cameroon",
    "currency": "Central African CFA",
    "currencyCode": "XAF",
    "symbol": "FCFA",
    "dialingCode": "+237",
    "countryCode": "CMR",
  },
  "Central African Republic (CAR)": {
    "country": "Central African Republic (CAR)",
    "currency": "Central African CFA",
    "currencyCode": "XAF",
    "symbol": "FCFA",
    "dialingCode": "+236",
    "countryCode": "CAF",
  },
  "Chad": {
    "country": "Chad",
    "currency": "Central African CFA",
    "currencyCode": "XAF",
    "symbol": "FCFA",
    "dialingCode": "+235",
    "countryCode": "TCD",
  },
  "Comoros": {
    "country": "Comoros",
    "currency": "Comorian Franc",
    "currencyCode": "KMF",
    "symbol": "CF",
    "dialingCode": "+269",
    "countryCode": "COM",
  },
  "Democratic Republic of the Congo": {
    "country": "Democratic Republic of the Congo",
    "currency": "Congolese franc",
    "currencyCode": "CDF",
    "symbol": "FC",
    "dialingCode": "+243",
    "countryCode": "COD",
  },
  "Republic of the Congo": {
    "country": "Republic of the Congo",
    "currency": "Central African CFA",
    "currencyCode": "XAF",
    "symbol": "FCFA",
    "dialingCode": "+243",
    "countryCode": "COD",
  },
  "Djibouti": {
    "country": "Djibouti",
    "currency": "Djiboutian Franc",
    "currencyCode": "DJF",
    "symbol": "Fdj",
    "dialingCode": "+253",
    "countryCode": "DJI",
  },
  "Egypt": {
    "country": "Egypt",
    "currency": "Egyptian Pound",
    "currencyCode": "EGP",
    "symbol": "£",
    "dialingCode": "+20",
    "countryCode": "EGY",
  },
  "Equatorial Guinea ": {
    "country": "Equatorial",
    "currency": "Central African CFA",
    "currencyCode": "XAF",
    "symbol": "FCFA",
    "dialingCode": "+240",
    "countryCode": "GNQ",
  },
  "Eritrea": {
    "country": "Eritrea",
    "currency": "Eritrean Nakfa",
    "currencyCode": "ERN",
    "symbol": "ናቕፋ",
    "dialingCode": "+291",
    "countryCode": "ERI",
  },
  "Ethiopia": {
    "country": "Ethiopia",
    "currency": "Ethiopian Birr",
    "currencyCode": "ETB",
    "symbol": "ብር",
    "dialingCode": "+251",
    "countryCode": "ETH",
  },
  "Gabon": {
    "country": "Gabon",
    "currency": "Central African CFA",
    "currencyCode": "XAF",
    "symbol": "FCFA",
    "dialingCode": "+241",
    "countryCode": "GAB",
  },
  "Gambia": {
    "country": "Gambia",
    "currency": "Gambian Dalasi",
    "currencyCode": "GMD",
    "symbol": "D",
    "dialingCode": "+220",
    "countryCode": "GMB",
  },
  "Ghana": {
    "country": "Ghana",
    "currency": "Ghanaian Cedi",
    "currencyCode": "GHS",
    "symbol": "GH₵",
    "dialingCode": "+233",
    "countryCode": "GHA",
  },
  "Guinea": {
    "country": "Guinea",
    "currency": "Guinean Franc",
    "currencyCode": "GNF",
    "symbol": "FG",
    "dialingCode": "+675",
    "countryCode": "PNG",
  },
  "Guinea-Bissau": {
    "country": "Guinea-Bissau",
    "currency": "West African CFA",
    "currencyCode": "XOF",
    "symbol": "CFA",
    "dialingCode": "+245",
    "countryCode": "GNB",
  },
  "Kenya": {
    "country": "Kenya",
    "currency": "Kenyan Shilling",
    "currencyCode": "KES",
    "symbol": "KSh",
    "dialingCode": "+254",
    "countryCode": "KEN",
  },
  "Lesotho": {
    "country": "Lesotho",
    "currency": "Lesotho Loti",
    "currencyCode": "LSL",
    "symbol": "L",
    "dialingCode": "+266",
    "countryCode": "LSO",
  },
  "Liberia": {
    "country": "Liberia",
    "currency": "Liberian Dollar",
    "currencyCode": "LRD",
    "symbol": "\$",
    "dialingCode": "+231",
    "countryCode": "LBR",
  },
  "Libya": {
    "country": "Libya",
    "currency": "Libyan Dinar",
    "currencyCode": "LYD",
    "symbol": "ل.د",
    "dialingCode": "+218",
    "countryCode": "LBY",
  },
  "Madagascar": {
    "country": "Madagascar",
    "currency": "Malagasy Ariary",
    "currencyCode": "MGA",
    "symbol": "Ar",
    "dialingCode": "+261",
    "countryCode": "MDG",
  },
  "Malawi": {
    "country": "Malawi",
    "currency": "Malawian Kwacha",
    "currencyCode": "MWK",
    "symbol": "MK",
    "dialingCode": "+265",
    "countryCode": "MWI",
  },
  "Mali": {
    "country": "Mali",
    "currency": "West African CFA",
    "currencyCode": "XOF",
    "symbol": "CFA",
    "dialingCode": "+223",
    "countryCode": "MLI",
  },
  "Mauritania": {
    "country": "Mauritania",
    "currency": "Mauritanian Ouguiya",
    "currencyCode": "MRO",
    "symbol": "UM",
    "dialingCode": "+222",
    "countryCode": "MRT",
  },
  "Mauritius": {
    "country": "Mauritius",
    "currency": "Mauritian Rupee",
    "currencyCode": "MUR",
    "symbol": "₨",
    "dialingCode": "+230",
    "countryCode": "MUS",
  },
  "Morocco": {
    "country": "Morocco",
    "currency": "Moroccan Dirham",
    "currencyCode": "MAD",
    "symbol": "DH",
    "dialingCode": "+212",
    "countryCode": "MAR",
  },
  "Mozambique": {
    "country": "Mozambique",
    "currency": "Mozambican Metical",
    "currencyCode": "MZN",
    "symbol": "MT",
    "dialingCode": "+258",
    "countryCode": "MOZ",
  },
  "Namibia": {
    "country": "Namibia",
    "currency": "Namibian Dollar",
    "currencyCode": "NAD",
    "symbol": "\$",
    "dialingCode": "+264",
    "countryCode": "NAM",
  },
  "Niger": {
    "country": "Niger",
    "currency": "West African CFA",
    "currencyCode": "XOF",
    "symbol": "CFA",
    "dialingCode": "+227",
    "countryCode": "NER",
  },
  "Nigeria": {
    "country": "Nigeria",
    "currency": "Nigerian Naira",
    "currencyCode": "NGN",
    "symbol": "₦",
    "dialingCode": "+234",
    "countryCode": "NGA",
  },
  "Rwanda": {
    "country": "Rwanda",
    "currency": "Rwandan Franc",
    "currencyCode": "RWF",
    "symbol": "FRw",
    "dialingCode": "+250",
    "countryCode": "RWA",
  },
  "Sao Tome and Principe ": {
    "country": "Sao Tome and Principe",
    "currency": "Sao Tome Dobra",
    "currencyCode": "STD",
    "symbol": "Db",
    "dialingCode": "+239",
    "countryCode": "	STP",
  },
  "Senegal": {
    "country": "Senegal",
    "currency": "West African CFA",
    "currencyCode": "XOF",
    "symbol": "CFA",
    "dialingCode": "+221",
    "countryCode": "SEN",
  },
  "Seychelles": {
    "country": "Seychelles",
    "currency": "Seychelles Rupee",
    "currencyCode": "SCR",
    "symbol": "₨",
    "dialingCode": "+248",
    "countryCode": "SYC",
  },
  "Sierra Leone": {
    "country": "Sierra Leone",
    "currency": "Sierra Leonean Leone",
    "currencyCode": "SLL",
    "symbol": "Le",
    "dialingCode": "+232",
    "countryCode": "SLE",
  },
  "Somalia": {
    "country": "Somalia",
    "currency": "Somali Shilling",
    "currencyCode": "SOS",
    "symbol": "S",
    "dialingCode": "+252",
    "countryCode": "SOM",
  },
  "South Africa": {
    "country": "South Africa",
    "currency": "South African Rand",
    "currencyCode": "ZAR",
    "symbol": "R",
    "dialingCode": "+27",
    "countryCode": "ZAF",
  },
  "South Sudan": {
    "country": "South Sudan",
    "currency": "South Sudanese pound",
    "currencyCode": "SSP",
    "symbol": "£",
    "dialingCode": "+211",
    "countryCode": "SSD",
  },
  "Sudan": {
    "country": "Sudan",
    "currency": "Sudanese pound",
    "currencyCode": "SDG",
    "symbol": "SD",
    "dialingCode": "+249",
    "countryCode": "SDN",
  },
  "Swaziland": {
    "country": "Swaziland",
    "currency": "Swazi Lilangeni",
    "currencyCode": "SZL",
    "symbol": "E",
    "dialingCode": "+268",
    "countryCode": "SWZ",
  },
  "Tanzania": {
    "country": "Tanzania",
    "currency": "Tanzanian Shilling",
    "currencyCode": "TZS",
    "symbol": "TSh",
    "dialingCode": "+255",
    "countryCode": "TZA",
  },
  "Togo": {
    "country": "Togo",
    "currency": "West African CFA",
    "currencyCode": "XOF",
    "symbol": "CFA",
    "dialingCode": "+228",
    "countryCode": "TGO",
  },
  "Tunisia": {
    "country": "Tunisia",
    "currency": "Tunisian Dinar",
    "currencyCode": "TND",
    "symbol": "د.ت",
    "dialingCode": "+216",
    "countryCode": "TUN",
  },
  "Uganda": {
    "country": "Uganda",
    "currency": "Ugandan Shilling",
    "currencyCode": "UGX",
    "symbol": "USh",
    "dialingCode": "+256",
    "countryCode": "UGA",
  },
  "Zambia": {
    "country": "Zambia",
    "currency": "Zambian Kwacha",
    "currencyCode": "ZMK",
    "symbol": "ZK",
    "dialingCode": "+260",
    "countryCode": "ZMB",
  },
  "Zimbabwe": {
    "country": "Zimbabwe",
    "currency": "Zimbabwean Dollar",
    "currencyCode": "ZWD",
    "symbol": "\$",
    "dialingCode": "+263",
    "countryCode": "ZWE",
  },
  "Albania": {
    "country": "Albania",
    "currency": "Albanian Lek",
    "currencyCode": "ALL",
    "symbol": "Lek",
    "dialingCode": "+355",
    "countryCode": "ALB",
  },
  "Andorra": {
    "country": "Andorra",
    "currency": "European Euro",
    "currencyCode": "EUR",
    "symbol": "€",
    "dialingCode": "+376",
    "countryCode": "AND",
  },
  "Austria": {
    "country": "Austria",
    "currency": "European Euro",
    "currencyCode": "EUR",
    "symbol": "€",
    "dialingCode": "+43",
    "countryCode": "AUT",
  },
  "Belarus": {
    "country": "Belarus",
    "currency": "Belarusian Ruble",
    "currencyCode": "BYR",
    "symbol": "Br",
    "dialingCode": "+375",
    "countryCode": "BLR",
  },
  "Belgium": {
    "country": "Belgium",
    "currency": "European Euro",
    "currencyCode": "EUR",
    "symbol": "€",
    "dialingCode": "+32",
    "countryCode": "BEL",
  },
  "Bosnia and Herzegovina": {
    "country": "Bosnia and Herzegovina ",
    "currency": "Bosnia-Herzegovina Convertible Mark",
    "currencyCode": "BAM",
    "symbol": "KM",
    "dialingCode": "+387",
    "countryCode": "BIH",
  },
  "Bulgari": {
    "country": "Bulgaria",
    "currency": "Bulgarian Lev",
    "currencyCode": "BGN",
    "symbol": "лв",
    "dialingCode": "+359",
    "countryCode": "BGR",
  },
  "Croatia": {
    "country": "Croatia",
    "currency": "Croatian Kuna",
    "currencyCode": "HRK",
    "symbol": "kn",
    "dialingCode": "+385",
    "countryCode": "HRV",
  },
  "Czech Republic": {
    "country": "Czech Republic",
    "currency": "Czech Koruna",
    "currencyCode": "CZK",
    "symbol": "Kč",
    "dialingCode": "+420",
    "countryCode": "CZE",
  },
  "Denmark": {
    "country": "Denmark",
    "currency": "Danish Krone",
    "currencyCode": "DKK",
    "symbol": "kr.",
    "dialingCode": "+45",
    "countryCode": "DNK",
  },
  "Estonia": {
    "country": "Estonia",
    "currency": "Estonian Kroon",
    "currencyCode": "EEK",
    "symbol": "EEK",
    "dialingCode": "+372",
    "countryCode": "EST",
  },
  "Finland": {
    "country": "Finland",
    "currency": "European Euro",
    "currencyCode": "EUR",
    "symbol": "€",
    "dialingCode": "+",
    "countryCode": "",
  },
  "France": {
    "country": "France",
    "currency": "European Euro",
    "currencyCode": "EUR",
    "symbol": "€",
    "dialingCode": "+33",
    "countryCode": "FRA",
  },
  "Germany": {
    "country": "Germany",
    "currency": "European Euro",
    "currencyCode": "EUR",
    "symbol": "€",
    "dialingCode": "+49",
    "countryCode": "DEU",
  },
  "Greece": {
    "country": "Greece",
    "currency": "European Euro",
    "currencyCode": "EUR",
    "symbol": "€",
    "dialingCode": "+30",
    "countryCode": "GRC",
  },
  "Hungary": {
    "country": "Hungary",
    "currency": "Hungarian Forint",
    "currencyCode": "HUF",
    "symbol": "Ft",
    "dialingCode": "+36",
    "countryCode": "HUN",
  },
  "Iceland": {
    "country": "Iceland",
    "currency": "Icelandic Krona",
    "currencyCode": "ISK",
    "symbol": "kr",
    "dialingCode": "+354",
    "countryCode": "ISL",
  },
  "Ireland": {
    "country": "Ireland",
    "currency": "European Euro",
    "currencyCode": "EUR",
    "symbol": "€",
    "dialingCode": "+353",
    "countryCode": "IRL",
  },
  "Italy": {
    "country": "Italy",
    "currency": "European Euro ",
    "currencyCode": "EUR ",
    "symbol": "€ ",
    "dialingCode": "+39",
    "countryCode": "ITA",
  },
  "Kosovo": {
    "country": "Kosovo",
    "currency": "Euro",
    "currencyCode": "EUR",
    "symbol": "€",
    "dialingCode": "+383",
    "countryCode": "XKX",
  },
  "Latvia": {
    "country": "Latvia",
    "currency": "Latvian Lats",
    "currencyCode": "LVL",
    "symbol": "Ls",
    "dialingCode": "+371",
    "countryCode": "LVA",
  },
  "Liechtenstein": {
    "country": "Liechtenstein",
    "currency": "Swiss Franc",
    "currencyCode": "CHF",
    "symbol": "CHF",
    "dialingCode": "+423",
    "countryCode": "LIE",
  },
  "Lithuania": {
    "country": "Lithuania",
    "currency": "Lithuanian Litas",
    "currencyCode": "LTL",
    "symbol": "Lt",
    "dialingCode": "+370",
    "countryCode": "LTU",
  },
  "Luxembourg": {
    "country": "Luxembourg",
    "currency": "European Euro",
    "currencyCode": "EUR",
    "symbol": "€",
    "dialingCode": "+352",
    "countryCode": "LUX",
  },
  "Macedonia (FYROM)": {
    "country": "Macedonia (FYROM)",
    "currency": "Macedonian Denar",
    "currencyCode": "MKD",
    "symbol": "ден",
    "dialingCode": "+389",
    "countryCode": "MKD",
  },
  "Malta": {
    "country": "Malta",
    "currency": "Maltese Lira",
    "currencyCode": "MTL",
    "symbol": "₤",
    "dialingCode": "+356",
    "countryCode": "MLT",
  },
  "Moldova": {
    "country": "Moldova",
    "currency": "Moldovan Leu",
    "currencyCode": "MDL",
    "symbol": "L",
    "dialingCode": "+373",
    "countryCode": "MDA",
  },
  "Monaco": {
    "country": "Monaco",
    "currency": "European Euro",
    "currencyCode": "EUR",
    "symbol": "€",
    "dialingCode": "+377",
    "countryCode": "MCO",
  },
  "Montenegro": {
    "country": "Montenegro",
    "currency": "European Euro",
    "currencyCode": "EUR",
    "symbol": "€",
    "dialingCode": "+382",
    "countryCode": "MNE",
  },
  "Netherlands": {
    "country": "Netherlands",
    "currency": "European Euro",
    "currencyCode": "EUR",
    "symbol": "€",
    "dialingCode": "+599",
    "countryCode": "ANT",
  },
  "Norway": {
    "country": "Norway",
    "currency": "Norwegian Krone",
    "currencyCode": "NOK",
    "symbol": "kr",
    "dialingCode": "+47",
    "countryCode": "NOR",
  },
  "Poland": {
    "country": "Poland",
    "currency": "Polish Zloty",
    "currencyCode": "PLN",
    "symbol": "zł",
    "dialingCode": "+48",
    "countryCode": "POL",
  },
  "Portugal": {
    "country": "Portugal",
    "currency": "European Euro",
    "currencyCode": "EUR",
    "symbol": "€",
    "dialingCode": "+351",
    "countryCode": "PRT",
  },
  "Romania": {
    "country": "Romania",
    "currency": "Romanian Leu",
    "currencyCode": "RON",
    "symbol": "lei",
    "dialingCode": "+40",
    "countryCode": "ROU",
  },
  "San Marino": {
    "country": "San Marino",
    "currency": "European Euro",
    "currencyCode": "EUR",
    "symbol": "€",
    "dialingCode": "+378",
    "countryCode": "SMR",
  },
  "Serbia": {
    "country": "Serbia",
    "currency": "Serbian Dinar",
    "currencyCode": "RSD",
    "symbol": "Дин.",
    "dialingCode": "+381",
    "countryCode": "SRB",
  },
  "Slovakia": {
    "country": "Slovakia",
    "currency": "Slovak Koruna",
    "currencyCode": "SKK",
    "symbol": "",
    "dialingCode": "+421",
    "countryCode": "SVK",
  },
  "Slovenia": {
    "country": "Slovenia",
    "currency": "European Euro",
    "currencyCode": "EUR",
    "symbol": "€",
    "dialingCode": "+386",
    "countryCode": "SVN",
  },
  "Spain": {
    "country": "Spain",
    "currency": "European Euro",
    "currencyCode": "EUR",
    "symbol": "€",
    "dialingCode": "+34",
    "countryCode": "ESP",
  },
  "Sweden": {
    "country": "Sweden",
    "currency": "Swedish Krona",
    "currencyCode": "SEK",
    "symbol": "kr",
    "dialingCode": "+46",
    "countryCode": "SWE",
  },
  "Switzerland": {
    "country": "Switzerland",
    "currency": "Swiss Franc",
    "currencyCode": "CHF",
    "symbol": "CHF",
    "dialingCode": "+41",
    "countryCode": "CHE",
  },
  "Turkey": {
    "country": "Turkey",
    "currency": "Turkish New Lira",
    "currencyCode": "TRY",
    "symbol": "₺",
    "dialingCode": "+90",
    "countryCode": "TUR",
  },
  "Ukraine": {
    "country": "Ukraine",
    "currency": "Ukrainian Hryvnia",
    "currencyCode": "UAH",
    "symbol": "₴",
    "dialingCode": "+380",
    "countryCode": "UKR",
  },
  "United Kingdom (UK)": {
    "country": "United Kingdom (UK)",
    "currency": "United Kingdom Pound Sterling",
    "currencyCode": "GBP",
    "symbol": "£",
    "dialingCode": "+44",
    "countryCode": "GBR",
  },
  "Vatican City (Holy See)": {
    "country": "Vatican City (Holy See)",
    "currency": "European Euro",
    "currencyCode": "EUR",
    "symbol": "€",
    "dialingCode": "+379",
    "countryCode": "VAT",
  },
  "Antigua and Barbuda ": {
    "country": "Antigua and Barbuda",
    "currency": "East Caribbean Dollar",
    "currencyCode": "XCD",
    "symbol": "\$",
    "dialingCode": "+1",
    "countryCode": "ATG",
  },
  "Bahamas": {
    "country": "Bahamas",
    "currency": "Bahamian Dollar",
    "currencyCode": "BSD",
    "symbol": "\$",
    "dialingCode": "+1",
    "countryCode": "BHS",
  },
  "Barbados": {
    "country": "Barbados",
    "currency": "Barbados Dollar",
    "currencyCode": "BBD",
    "symbol": "\$",
    "dialingCode": "+1",
    "countryCode": "BRB",
  },
  "Belize": {
    "country": "Belize",
    "currency": "Belize Dollar",
    "currencyCode": "BZD",
    "symbol": "BZ\$",
    "dialingCode": "+501",
    "countryCode": "BLZ",
  },
  "Canada": {
    "country": "Canada",
    "currency": "Canadian Dollar",
    "currencyCode": "CAD",
    "symbol": "\$",
    "dialingCode": "+1",
    "countryCode": "CAN",
  },
  "Costa Rica": {
    "country": "Costa Rica",
    "currency": "Costa Rican Colon",
    "currencyCode": "CRC",
    "symbol": "₡",
    "dialingCode": "+506",
    "countryCode": "CRI",
  },
  "Cuba": {
    "country": "Cuba",
    "currency": "Cuban Convertible Peso",
    "currencyCode": "CUC",
    "symbol": "\$",
    "dialingCode": "+53",
    "countryCode": "CUB",
  },
  "Dominica": {
    "country": "Dominica",
    "currency": "East Caribbean Dollar",
    "currencyCode": "XCD",
    "symbol": "\$",
    "dialingCode": "+1",
    "countryCode": "DMA",
  },
  "Dominican Republic": {
    "country": "Dominican Republic",
    "currency": "Dominican Peso",
    "currencyCode": "DOP",
    "symbol": "RD\$",
    "dialingCode": "+1",
    "countryCode": "DOM",
  },
  "El Salvador": {
    "country": "El Salvador",
    "currency": "United States Dollar",
    "currencyCode": "USD",
    "symbol": "\$",
    "dialingCode": "+503",
    "countryCode": "SLV",
  },
  "Grenada": {
    "country": "Grenada",
    "currency": "East Caribbean Dollar",
    "currencyCode": "XCD",
    "symbol": "\$",
    "dialingCode": "+1",
    "countryCode": "GRD",
  },
  "Guatemala": {
    "country": "Guatemala",
    "currency": "Guatemalan Quetzal",
    "currencyCode": "GTQ",
    "symbol": "Q",
    "dialingCode": "+502",
    "countryCode": "GTM",
  },
  "Haiti": {
    "country": "Haiti",
    "currency": "Haitian Gourde",
    "currencyCode": "HTG",
    "symbol": "G",
    "dialingCode": "+509",
    "countryCode": "HTI",
  },
  "Honduras": {
    "country": "Honduras",
    "currency": "Honduran Lempira",
    "currencyCode": "HNL",
    "symbol": "L",
    "dialingCode": "+504",
    "countryCode": "HND",
  },
  "Jamaica": {
    "country": "Jamaica",
    "currency": "Jamaican Dollar",
    "currencyCode": "JMD",
    "symbol": "J\$",
    "dialingCode": "+1",
    "countryCode": "JAM",
  },
  "Mexico": {
    "country": "Mexico",
    "currency": "Mexican Peso",
    "currencyCode": "MXN",
    "symbol": "\$",
    "dialingCode": "+52",
    "countryCode": "MEX",
  },
  "Nicaragua": {
    "country": "Nicaragua",
    "currency": "Nicaraguan Córdoba",
    "currencyCode": "NIO",
    "symbol": "C\$",
    "dialingCode": "+505",
    "countryCode": "NIC",
  },
  "Panama": {
    "country": "Panama",
    "currency": "Panamanian Balboa",
    "currencyCode": "PAB",
    "symbol": "B/.",
    "dialingCode": "+507",
    "countryCode": "PAN",
  },
  "Saint Kitts and Nevis": {
    "country": "Saint Kitts and Nevis",
    "currency": "East Caribbean Dollar",
    "currencyCode": "XCD",
    "symbol": "\$",
    "dialingCode": "+1",
    "countryCode": "KNA",
  },
  "Saint Lucia": {
    "country": "Saint Lucia",
    "currency": "East Caribbean Dollar",
    "currencyCode": "XCD",
    "symbol": "\$",
    "dialingCode": "+1",
    "countryCode": "LCA",
  },
  "Saint Vincent and the Grenadines": {
    "country": "Saint Vincent and the Grenadines",
    "currency": "East Caribbean Dollar",
    "currencyCode": "XCD",
    "symbol": "\$",
    "dialingCode": "+1",
    "countryCode": "VCT",
  },
  "Trinidad and Tobago": {
    "country": "Trinidad and Tobago",
    "currency": "Trinidad and Tobago Dollar",
    "currencyCode": "TTD",
    "symbol": "TT\$",
    "dialingCode": "+1",
    "countryCode": "TTO",
  },
  "United States of America": {
    "country": "United States of America (USA)",
    "currency": "United States Dollar",
    "currencyCode": "USD",
    "symbol": "\$",
    "dialingCode": "+1",
    "countryCode": "USA",
  },
  "Argentina": {
    "country": "Argentina",
    "currency": "Argentine Peso",
    "currencyCode": "ARS",
    "symbol": "\$",
    "dialingCode": "+54",
    "countryCode": "ARG",
  },
  "Bolivia": {
    "country": "Bolivia",
    "currency": "Bolivian Boliviano",
    "currencyCode": "BOB",
    "symbol": "\$b",
    "dialingCode": "+591",
    "countryCode": "BOL",
  },
  "Brazil": {
    "country": "Brazil",
    "currency": "Brazilian Real",
    "currencyCode": "BRL",
    "symbol": "R\$",
    "dialingCode": "+55",
    "countryCode": "BRA",
  },
  "Chile": {
    "country": "Chile",
    "currency": "Chilean Peso",
    "currencyCode": "CLP",
    "symbol": "\$",
    "dialingCode": "+56",
    "countryCode": "CHL",
  },
  "Colombia": {
    "country": "Colombia",
    "currency": "Colombian Peso",
    "currencyCode": "COP",
    "symbol": "\$",
    "dialingCode": "+57",
    "countryCode": "COL",
  },
  "Ecuador": {
    "country": "Ecuador",
    "currency": "United States Dollar",
    "currencyCode": "USD",
    "symbol": "\$",
    "dialingCode": "+593",
    "countryCode": "ECU",
  },
  "Guyana": {
    "country": "Guyana",
    "currency": "Guyanese Dollar",
    "currencyCode": "GYD",
    "symbol": "\$",
    "dialingCode": "+592",
    "countryCode": "GUY",
  },
  "Paragua": {
    "country": "Paragua",
    "currency": "Paraguay Guarani",
    "currencyCode": "PYG",
    "symbol": "Gs",
    "dialingCode": "+595",
    "countryCode": "PRY",
  },
  "Peru": {
    "country": "Per",
    "currency": "Peruvian Nuevo Sol",
    "currencyCode": "PEN",
    "symbol": "S/.",
    "dialingCode": "+51",
    "countryCode": "PER",
  },
  "Suriname": {
    "country": "Suriname",
    "currency": "Suriname Dollar",
    "currencyCode": "SRD",
    "symbol": "\$",
    "dialingCode": "+597",
    "countryCode": "SUR",
  },
  "Uruguay": {
    "country": "Uruguay",
    "currency": "Uruguayan peso",
    "currencyCode": "UYU",
    "symbol": "\$U",
    "dialingCode": "+598",
    "countryCode": "URY",
  },
  "Venezuela": {
    "country": "Venezuela",
    "currency": "Venezuelan Bolivar",
    "currencyCode": "VEF",
    "symbol": "Bs",
    "dialingCode": "+58",
    "countryCode": "VEN",
  },
  "Fiji": {
    "country": "Fiji",
    "currency": "Fiji Dollar",
    "currencyCode": "FJD",
    "symbol": "\$",
    "dialingCode": "+679",
    "countryCode": "FJI",
  },
  "Kiribati": {
    "country": "Kiribati",
    "currency": "Australian Dollar",
    "currencyCode": "AUD",
    "symbol": "\$",
    "dialingCode": "+686",
    "countryCode": "KIR",
  },
  "Marshall Island": {
    "country": "Marshall Island",
    "currency": "United States Dollar",
    "currencyCode": "USD",
    "symbol": "\$",
    "dialingCode": "+692",
    "countryCode": "MHL",
  },
  "Micronesia": {
    "country": "Micronesia",
    "currency": "United States Dollar",
    "currencyCode": "USD",
    "symbol": "\$",
    "dialingCode": "+691",
    "countryCode": "FSM",
  },
  "Nauru": {
    "country": "Nauru",
    "currency": "Australian Dollar",
    "currencyCode": "AUD",
    "symbol": "\$",
    "dialingCode": "+674",
    "countryCode": "NRU",
  },
  "New Zealand": {
    "country": "New Zealand",
    "currency": "New Zealand Dollar",
    "currencyCode": "NZD",
    "symbol": "\$",
    "dialingCode": "+64",
    "countryCode": "NZL",
  },
  "Palau": {
    "country": "Palau",
    "currency": "United States Dollar",
    "currencyCode": "USD",
    "symbol": "\$",
    "dialingCode": "+680",
    "countryCode": "PLW",
  },
  "Papua New Guinea": {
    "country": "Papua New Guinea",
    "currency": "New Guinea Kina",
    "currencyCode": "PGK",
    "symbol": "K",
    "dialingCode": "+675",
    "countryCode": "PNG",
  },
  "Samoa": {
    "country": "Samoa",
    "currency": "Samoan Tala",
    "currencyCode": "WST",
    "symbol": "WS\$",
    "dialingCode": "+685",
    "countryCode": "WSM",
  },
  "Solomon Islands": {
    "country": "Solomon Islands",
    "currency": "Solomon Islands Dollar",
    "currencyCode": "SBD",
    "symbol": "\$",
    "dialingCode": "+677",
    "countryCode": "SLB",
  },
  "Tonga": {
    "country": "Tonga",
    "currency": "Tongan Pa'Anga",
    "currencyCode": "TOP",
    "symbol": "T\$",
    "dialingCode": "+676",
    "countryCode": "TON",
  },
  "Tuvalu": {
    "country": "Tuvalu",
    "currency": "Australian Dollar",
    "currencyCode": "AUD",
    "symbol": "\$",
    "dialingCode": "+688",
    "countryCode": "TUV",
  },
};
