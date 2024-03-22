import '../utils.dart';

class RangesType {
  int byLo;
  int byHi;

  RangesType(this.byLo, this.byHi);

  RangesType.fromDataChunk(List<int> data)
      : byLo = Utils.intFromChunkData(data, 0, chunkBytes: 1),
        byHi = Utils.intFromChunkData(data, 1, chunkBytes: 1);
}
