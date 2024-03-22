import '../utils.dart';

class SFModulator {
  int _value;

  SFModulator(this._value);

  SFModulator.fromData(List<int> data)
      : _value = Utils.intFromChunkData(data, 0, chunkBytes: 2);

  int get type => (_value >> 10) & 0x3F;
  set type(int newValue) {
    _value = (_value & ~(0x3F << 10)) | ((newValue & 0x3F) << 10);
  }

  bool get polarity => ((_value >> 9) & 0x01) == 1;
  set polarity(bool newValue) {
    _value = (_value & ~(1 << 9)) | ((newValue ? 1 : 0) << 9);
  }

  bool get direction => ((_value >> 8) & 0x01) == 1;
  set direction(bool newValue) {
    _value = (_value & ~(1 << 8)) | ((newValue ? 1 : 0) << 8);
  }

  bool get ccFlag => ((_value >> 7) & 0x01) == 1;
  set ccFlag(bool newValue) {
    _value = (_value & ~(1 << 7)) | ((newValue ? 1 : 0) << 7);
  }

  int get index => _value & 0x7F;
  set index(int newValue) {
    _value = (_value & ~0x7F) | (newValue & 0x7F);
  }
}
