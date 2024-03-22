import '../utils.dart';

class SFTransform {
  // TODO not sure about the structure from doc, so far just a copy of SFModulator
  // it should be 2 bytes
  int _value;

  SFTransform(this._value);

  SFTransform.fromData(List<int> data)
      : _value = Utils.intFromChunkData(data, 0, chunkBytes: 2);
}
