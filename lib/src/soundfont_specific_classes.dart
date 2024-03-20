import 'utils.dart';

class Version {
  int major;
  int minor;
  Version(this.minor, this.major);

  Version.fromDataChunk(List<int> data)
      : major = Utils.intFromChunkData(data, 0, chunkBytes: 2),
        minor = Utils.intFromChunkData(data, 2, chunkBytes: 2);
}
