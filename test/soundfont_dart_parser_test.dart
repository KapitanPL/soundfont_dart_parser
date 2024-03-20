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
    });
  });
}
