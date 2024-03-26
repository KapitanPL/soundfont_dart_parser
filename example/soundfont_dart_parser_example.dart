import 'package:soundfont_dart_parser/soundfont_dart_parser.dart';

void printParserInfo(SoundFontParser parser) {
  print(" ");
  print('Name: ${parser.filename}');

  if (parser.version != null) {
    print('Version: ${parser.version!.major}.${parser.version!.minor}');
  } else {
    print('Version: null');
  }

  if (parser.romVersion != null) {
    print(
        'Rom Version: ${parser.romVersion!.major}.${parser.romVersion!.minor}');
  } else {
    print('Rom Version: null');
  }

  for (final key in parser.infoStrings.keys) {
    print("$key: ${parser.infoStrings[key]}");
  }

  if (parser.instrumentList != null) {
    for (final instrument in parser.instrumentList!) {
      print('Instrument: ${instrument.instrumentName}');
    }
  } else {
    print("No instruments");
  }

  if (parser.presetHeaders != null) {
    for (final preset in parser.presetHeaders!) {
      print('Preset: ${preset.presetName}');
    }
  } else {
    print("No presets");
  }
  print(" ");
}

void main() async {
  final rhodesParser = SoundFontParser('/home/tpnsvo/Rhodes.sf2');
  final niceKeysparser =
      SoundFontParser('/home/tpnsvo/Nice-Keys-Suite-V1.0.sf2');
  final yamahaParser = SoundFontParser('/home/tpnsvo/Yamaha_C5_grand.sf2');

  await rhodesParser.init();
  printParserInfo(rhodesParser);

  await niceKeysparser.init();
  printParserInfo(niceKeysparser);

  await yamahaParser.init();
  printParserInfo(yamahaParser);
}
