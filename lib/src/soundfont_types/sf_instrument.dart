// original c-struct: 22 bytes
/*
struct sfInst
{
 CHAR achInstName[20];
 WORD wInstBagNdx;
}; 
*/

import '../utils.dart';
import './c_types.dart';
import './sf_base_class.dart';

/*class SFInstrument {
  static const int STRUCT_SIZE = 22;
  String _achInstName;
  Word wInstBagNdx;

  SFInstrument.fromData(List<int> chunk)
      : _achInstName = Utils.stringFromChunkData(chunk, 0, 20),
        wInstBagNdx = Utils.intFromChunkData(chunk, 20, chunkBytes: 2).toWord();

  String get presetName => _achInstName;
  set presetName(String name) {
    _achInstName = name.substring(0, name.length < 20 ? name.length : 20);
  }
}*/

class SFInstrument implements SFBase {
  static const _size = 22;

  late String _achInstName;
  late Word wInstBagNdx;

  @override
  int structSize() {
    return _size;
  }

  @override
  void initFromData(List<int> chunk) {
    _achInstName = Utils.stringFromChunkData(chunk, 0, 20);
    wInstBagNdx = Utils.intFromChunkData(chunk, 20, chunkBytes: 2).toWord();
  }

  String get instrumentName => _achInstName;
  set instrumentName(String name) {
    _achInstName = name.substring(0, name.length < 20 ? name.length : 20);
  }
}
