import '../utils.dart';

class SFGenerator {
  // TODO not sure about the structure from doc, so far just a copy of SFModulator
  // it should be 2 bytes
  int _value;

  SFGenerator(this._value);

  SFGenerator.fromData(List<int> data)
      : _value = Utils.intFromChunkData(data, 0, chunkBytes: 2);
}
