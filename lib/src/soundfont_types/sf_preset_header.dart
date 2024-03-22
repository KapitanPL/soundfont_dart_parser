// original c struct: 38 bytes
/*struct sfPresetHeader
{
 CHAR achPresetName[20];
 WORD wPreset;
 WORD wBank;
 WORD wPresetBagNdx;
 DWORD dwLibrary;
 DWORD dwGenre;
 DWORD dwMorphology;
};*/

import '../utils.dart';
import './c_types.dart';
import './sf_base_class.dart';

/*class SFPresetHeader {
  static const int STRUCT_SIZE = 38;
  String _achPresetName;
  Word wPreset;
  Word wBank;
  Word wPresetBagNdx;
  DWord dwLibrary;
  DWord dwGenre;
  DWord dwMorphology;

  SFPresetHeader.fromData(List<int> chunk)
      : _achPresetName = Utils.stringFromChunkData(chunk, 0, 20),
        wPreset = Utils.intFromChunkData(chunk, 20, chunkBytes: 2).toWord(),
        wBank = Utils.intFromChunkData(chunk, 22, chunkBytes: 2).toWord(),
        wPresetBagNdx =
            Utils.intFromChunkData(chunk, 24, chunkBytes: 2).toWord(),
        dwLibrary = Utils.intFromChunkData(chunk, 26, chunkBytes: 4).toDWord(),
        dwGenre = Utils.intFromChunkData(chunk, 30, chunkBytes: 4).toDWord(),
        dwMorphology =
            Utils.intFromChunkData(chunk, 24, chunkBytes: 4).toDWord();

  String get presetName => _achPresetName;
  set presetName(String name) {
    _achPresetName = name.substring(0, name.length < 20 ? name.length : 20);
  }
}*/

class SFPresetHeader implements SFBase {
  static const _size = 38;

  late String _achPresetName;
  late Word wPreset;
  late Word wBank;
  late Word wPresetBagNdx;
  late DWord dwLibrary;
  late DWord dwGenre;
  late DWord dwMorphology;

  @override
  int structSize() {
    return _size;
  }

  @override
  void initFromData(List<int> chunk) {
    _achPresetName = Utils.stringFromChunkData(chunk, 0, 20);
    wPreset = Utils.intFromChunkData(chunk, 20, chunkBytes: 2).toWord();
    wBank = Utils.intFromChunkData(chunk, 22, chunkBytes: 2).toWord();
    wPresetBagNdx = Utils.intFromChunkData(chunk, 24, chunkBytes: 2).toWord();
    dwLibrary = Utils.intFromChunkData(chunk, 26, chunkBytes: 4).toDWord();
    dwGenre = Utils.intFromChunkData(chunk, 30, chunkBytes: 4).toDWord();
    dwMorphology = Utils.intFromChunkData(chunk, 24, chunkBytes: 4).toDWord();
  }

  String get presetName => _achPresetName;
  set presetName(String name) {
    _achPresetName = name.substring(0, name.length < 20 ? name.length : 20);
  }
}
