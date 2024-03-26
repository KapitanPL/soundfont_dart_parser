import 'dart:io';

import 'package:soundfont_dart_parser/src/soundfont_types/sf_base_class.dart';
import 'package:soundfont_dart_parser/src/soundfont_types/sf_preset_header.dart';

import './file_chunker/file_chunker.dart';
import './segment_id_map.dart';
import 'soundfont_types.dart';
import 'utils.dart';

/// Function called on the RIFF segment.
///
/// it can do whatever needs with segment
/// those functions must return true if the process the segment
/// if [true] is returned nothing else inside is parsed
typedef SegmentLeafParser = Future<bool> Function(SegmentIdMap);

class SoundFontParser {
  // mostly internal variables
  String filename;
  late FileChunker _chunker;
  late SegmentIdMap segments;
  late final Map<String, SegmentLeafParser> leafSegmentParsers;
  bool _break = false;

  // users might be interested in this
  Version? version;
  Version? romVersion;
  final Map<String, String> infoStrings = {};
  List<SFPresetHeader>? presetHeaders;
  List<SFInstrument>? instrumentList;

  SoundFontParser(this.filename,
      {Map<String, SegmentLeafParser>? customSegmentParsers,
      bool overrideDefaultParsers = false}) {
    _initLeafSegmentParsers();
    if (customSegmentParsers != null) {
      if (overrideDefaultParsers) {
        leafSegmentParsers = customSegmentParsers;
      } else {
        leafSegmentParsers.addAll(customSegmentParsers);
      }
    }
  }

  void _initLeafSegmentParsers() {
    leafSegmentParsers = {
      'ifil': _parseLeaf_ifil,
      'iver': _parseLeaf_iver,
      'isng': (SegmentIdMap segment) => _parseLeaf_string(segment, 'isng'),
      'irom': (SegmentIdMap segment) => _parseLeaf_string(segment, 'irom'),
      'INAM': (SegmentIdMap segment) => _parseLeaf_string(segment, 'INAM'),
      'ICRD': (SegmentIdMap segment) => _parseLeaf_string(segment, 'ICRD'),
      'IENG': (SegmentIdMap segment) => _parseLeaf_string(segment, 'IENG'),
      'IPRD': (SegmentIdMap segment) => _parseLeaf_string(segment, 'IPRD'),
      'ICOP': (SegmentIdMap segment) => _parseLeaf_string(segment, 'ICOP'),
      'ICMT': (SegmentIdMap segment) => _parseLeaf_string(segment, 'ICMT'),
      'ISFT': (SegmentIdMap segment) => _parseLeaf_string(segment, 'ISFT'),
      'phdr': _parseLeaf_phdr,
      'inst': _parseLeaf_inst,
    };
  }

  void cancelInit() {
    _break = true;
  }

  Future<void> init() async {
    _break = false;
    _chunker = FileChunker(filePath: filename);
    List<int> chunk = await _chunker.readData(0, 12);
    if (chunk.isNotEmpty) {
      final riffTag = Utils.stringFromChunkData(chunk, 0, 4);
      if (riffTag != 'RIFF') {
        throw FormatException('Not a RIFF file');
      }

      int fileSize = Utils.intFromChunkData(chunk, 4);

      final sfbkTag = Utils.stringFromChunkData(chunk, 8, 4);
      if (sfbkTag != 'sfbk') {
        throw FormatException('Not a SoundFont file');
      }

      segments = SegmentIdMap(riffTag, sfbkTag, 0, fileSize);

      await parseSegments(2);
    } else {
      throw FileSystemException('Failed to read file');
    }
  }

  Future<void> parseSegments(int maxDepth) async {
    if (segments.segments.isEmpty) {
      await _parseSegmentRecurse(segments, depth: maxDepth);
    }
  }

  // special depth = -1 parse all segments as far as possible
  Future<void> _parseSegmentRecurse(SegmentIdMap segment,
      {int depth = 0}) async {
    if (_break) return;
    await _parseSegment(segment);
    if (depth > 0 || depth == -1) {
      for (final subSegment in segment.segments) {
        await _parseSegmentRecurse(subSegment,
            depth: depth > 0 ? depth - 1 : -1);
      }
    }
  }

  Future<void> _parseSegment(SegmentIdMap segment) async {
    if (_break) return;
    if (segment.parsed == false) {
      String segmentName = segment.name;
      var parent = segment.parent;
      while (parent != null) {
        if (parent.name == "LIST") {
          parent.name = parent.name + '-' + parent.tag;
        }
        segmentName = parent.name + ':' + segmentName;
        parent = parent.parent;
      }
      print("Parsing $segmentName");
      if (await _parseLeafSegment(segment)) {
        return;
      }
      const headSize = 12;
      int startPosition = segment.offset + headSize;
      var segmentHead = await _chunker.readData(startPosition, headSize);

      while (segmentHead.isNotEmpty) {
        final segmentName = Utils.stringFromChunkData(segmentHead, 0, 4);
        final segmentSize = Utils.intFromChunkData(segmentHead, 4);
        final segmentTag = Utils.stringFromChunkData(segmentHead, 8, 4);

        segment.segments.add(SegmentIdMap(
            segmentName, segmentTag, startPosition, segmentSize,
            parent: segment));

        startPosition += segmentSize + 8;
        if (startPosition >= segment.offset + segment.size) {
          break;
        }
        segmentHead = await _chunker.readData(startPosition, headSize);
      }
      segment.parsed = true;
    }
  }

  Future<bool> _parseLeafSegment(SegmentIdMap segment) async {
    if (_break) return false;
    if (leafSegmentParsers.keys.contains(segment.name)) {
      print('parsing leaf ${segment.name}');
      return await leafSegmentParsers[segment.name]!.call(segment);
    }
    return false;
  }

  Future<bool> _parseLeaf_ifil(SegmentIdMap segment) async {
    if (segment.name == 'ifil') {
      final data = await _chunker.readData(segment.offset + 8, segment.size);
      version = Version.fromDataChunk(data);
      segment.parsed = true;
      return true;
    }
    return false;
  }

  Future<bool> _parseLeaf_iver(SegmentIdMap segment) async {
    if (segment.name == 'iver') {
      final data = await _chunker.readData(segment.offset + 8, segment.size);
      romVersion = Version.fromDataChunk(data);
      segment.parsed = true;
      return true;
    }
    return false;
  }

  Future<bool> _parseLeaf_string(SegmentIdMap segment, String keyWord) async {
    if (segment.name == keyWord) {
      final data = await _chunker.readData(segment.offset + 8, segment.size);
      infoStrings[keyWord] = Utils.stringFromChunkData(data, 0, segment.size);
      segment.parsed = true;
      return true;
    }
    return false;
  }

  List<T>? _parseDataWithSfClass<T>(List<int> data, T Function() createNew) {
    final dummy = createNew();
    if (dummy is SFBase) {
      final structSize = dummy.structSize();
      if (data.length % structSize != 0) {
        throw FormatException('Wrong phdr segment data size');
      }
      final structNum = data.length ~/ structSize;
      List<T> res = [];
      for (var i = 0; i < structNum; ++i) {
        if (_break) return null;
        final newStruct = createNew();
        (newStruct as SFBase)
            .initFromData(data.sublist(i * structSize, (i + 1) * structSize));
        res.add(newStruct);
      }
      return res;
    }
    return null;
  }

  Future<bool> _parseLeaf_phdr(SegmentIdMap segment) async {
    if (segment.name == 'phdr') {
      final data = await _chunker.readData(segment.offset + 8, segment.size);
      presetHeaders =
          _parseDataWithSfClass<SFPresetHeader>(data, () => SFPresetHeader());
      segment.parsed = true;
      return true;
    }
    return false;
  }

  Future<bool> _parseLeaf_inst(SegmentIdMap segment) async {
    if (segment.name == 'inst') {
      final data = await _chunker.readData(segment.offset + 8, segment.size);
      instrumentList =
          _parseDataWithSfClass<SFInstrument>(data, () => SFInstrument());
      segment.parsed = true;
      return true;
    }
    return false;
  }
}
