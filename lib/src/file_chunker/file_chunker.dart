import 'dart:async';
import 'dart:collection';
import 'dart:io';
import 'dart:math';

class FileChunker {
  final String filePath;
  final int chunkSize;
  final int cacheSize;
  RandomAccessFile? _file;
  final Map<int, List<int>> _chunksCache = {};
  final Queue<int> _cacheNumbers = Queue();

  FileChunker(
      {required this.filePath, this.chunkSize = 1024, this.cacheSize = 100});

  Future<void> open() async {
    _file = await File(filePath).open(mode: FileMode.read);
  }

  Future<List<int>> readData(int offset, int length) async {
    final chunkIdStart = offset ~/ chunkSize;
    final chunkIdEnd = (offset + length - 1) ~/ chunkSize;

    List<int> result = [];

    for (int chunkId = chunkIdStart; chunkId <= chunkIdEnd; chunkId++) {
      List<int>? chunkData = await _readChunkNumber(chunkId);

      if (chunkData == null) break;

      // Calculate the part of the chunk to be added to the result
      int startInChunk = (chunkId == chunkIdStart) ? offset % chunkSize : 0;
      int endInChunk = (chunkId == chunkIdEnd)
          ? min(((offset + length) % chunkSize), chunkData.length)
          : chunkData.length;

      result.addAll(chunkData.sublist(startInChunk, endInChunk));
    }

    return result;
  }

  Future<List<int>?> _readChunkNumber(int chunkNumber) async {
    final offset = chunkNumber * chunkSize;
    if (_file == null) {
      await open();
    }

    if (_chunksCache.containsKey(chunkNumber)) {
      return _chunksCache[chunkNumber];
    }

    await _file!.setPosition(offset);
    final bytes = await _file!.read(chunkSize);
    if (bytes.isEmpty) {
      return null;
    }

    _cacheNumbers.add(chunkNumber);

    _chunksCache[chunkNumber] = bytes;
    if (_chunksCache.length > cacheSize) {
      final chunkID = _cacheNumbers.removeFirst();
      _chunksCache.remove(chunkID);
    }

    return bytes;
  }

  List<int>? getChunkFromCache(int offset) {
    return _chunksCache[offset];
  }

  Future<void> close() async {
    await _file?.close();
    _file = null;
  }
}
