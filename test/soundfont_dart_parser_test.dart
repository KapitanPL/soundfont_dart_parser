import 'package:soundfont_dart_parser/soundfont_dart_parser.dart';
import 'package:test/test.dart';

void main() {
  group('Parser test', () {
    late SoundFontParser parser;

    setUpAll(() async {
      parser = SoundFontParser("soundfonts/Soccer_Shootout_Soundfont.sf2");
      await parser.init();
    });

    test('First Test', () {
      expect(parser.segments.size, 66636);
      expect(parser.version!.major, 2);
      expect(parser.version!.minor, 1);
      expect(parser.infoStrings['isng'], 'EMU8000');
      expect(parser.infoStrings['INAM'], 'Soccer Shootout Soundfont');
      expect(parser.infoStrings['ISFT'], 'Polyphone');

      expect(parser.presetHeaders!.length, 4);
      expect(parser.presetHeaders![0].presetName, 'Wave');
      expect(parser.presetHeaders![1].presetName, 'Kick');
      expect(parser.presetHeaders![2].presetName, '19');
      expect(parser.presetHeaders![3].presetName, 'EOP');

      expect(parser.instrumentList!.length, 4);
      expect(parser.instrumentList![0].instrumentName, 'Wave');
      expect(parser.instrumentList![1].instrumentName, 'Kick');
      expect(parser.instrumentList![2].instrumentName, '19');
      expect(parser.instrumentList![3].instrumentName, 'EOI');
    });
  });
}
