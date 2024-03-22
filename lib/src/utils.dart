class Utils {
  static String stringFromChunkData(List<int> chunk, int start, int length) {
    while (length > 1 && chunk[length - 1] == 0) {
      length -= 1;
    }
    return String.fromCharCodes(chunk.sublist(start, start + length));
  }

  static int intFromChunkData(List<int> chunk, int start,
      {int chunkBytes = 4, bool isSigned = false}) {
    assert(chunkBytes > 0 &&
        chunkBytes <= 4); // more does not fit int darts int value
    int res = chunk[start];
    for (var i = 1; i < chunkBytes; ++i) {
      res |= chunk[start + i] << i * 8;
    }

    if (isSigned && (chunk[start + chunkBytes - 1] & 0x80) != 0) {
      // Create a mask for the unused bits in the most significant byte
      int mask = (0xFF << (8 * (chunkBytes - 1)));
      // Extend the sign bit into the unused bits
      res |= (0xFFFFFFFF << (8 * chunkBytes)) & mask;
    }
    return res;
  }

  static List<int> chunkDataFromUnsignedInt(int value, {int chunkBytes = 4}) {
    if (value < 0) {
      throw ArgumentError('Value must be non-negative for unsigned integer.');
    }

    int maxUnsignedValue = (1 << (chunkBytes * 8)) - 1;
    if (value > maxUnsignedValue) {
      throw ArgumentError(
          'Value exceeds the maximum for the specified number of bytes.');
    }

    List<int> chunk = List.filled(chunkBytes, 0);

    for (int i = 0; i < chunkBytes; ++i) {
      chunk[i] = (value >> (8 * i)) & 0xFF;
    }

    return chunk;
  }

  static List<int> chunkDataFromSignedInt(int value, {int chunkBytes = 4}) {
    int minSignedValue = -(1 << (chunkBytes * 8 - 1));
    int maxSignedValue = (1 << (chunkBytes * 8 - 1)) - 1;

    if (value < minSignedValue || value > maxSignedValue) {
      throw ArgumentError(
          'Value exceeds the range that can be represented by the specified number of bytes.');
    }

    List<int> chunk = List.filled(chunkBytes, 0);
    // Handle negative values
    if (value < 0) {
      value =
          (1 << (chunkBytes * 8)) + value; // Convert to two's complement form
    }

    for (int i = 0; i < chunkBytes; ++i) {
      chunk[i] = (value >> (8 * i)) & 0xFF;
    }

    return chunk;
  }
}
