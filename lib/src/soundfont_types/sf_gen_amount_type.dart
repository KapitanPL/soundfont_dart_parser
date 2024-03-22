import '../utils.dart';
import 'ranges.dart';

class GenAmountType {
  List<int> data;

  GenAmountType(this.data);

  GenAmountType.fromDataChunk(this.data);

  int get shValue =>
      Utils.intFromChunkData(data, 0, chunkBytes: 2, isSigned: true);
  int get wValue =>
      Utils.intFromChunkData(data, 0, chunkBytes: 2, isSigned: false);
  RangesType get rValue => RangesType.fromDataChunk(data);

  set shValue(int value) {
    data = Utils.chunkDataFromSignedInt(value, chunkBytes: 2);
  }

  set wValue(int value) {
    data = Utils.chunkDataFromUnsignedInt(value, chunkBytes: 2);
  }

  set rValue(RangesType value) {
    data = [value.byLo, value.byHi];
  }
}
