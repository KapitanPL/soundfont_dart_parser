class Utils {
  static String stringFromChunkData(List<int> chunk, int start, int length) {
    while (length > 1 && chunk[length - 1] == 0) {
      length -= 1;
    }
    return String.fromCharCodes(chunk.sublist(start, start + length));
  }

  static int intFromChunkData(List<int> chunk, int start,
      {int chunkBytes = 4}) {
    int res = chunk[start];
    for (var i = 1; i < chunkBytes; ++i) {
      res |= chunk[start + i] << i * 8;
    }
    return res;
  }
}
