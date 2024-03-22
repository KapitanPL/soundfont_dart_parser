enum SFSampleLink {
  monoSample,
  rightSample,
  leftSample,
  linkedSample,
  romMonoSample,
  romRightSample,
  romLeftSample,
  romLinkedSample;

  int get value {
    switch (this) {
      case SFSampleLink.monoSample:
        return 1;
      case SFSampleLink.rightSample:
        return 2;
      case SFSampleLink.leftSample:
        return 4;
      case SFSampleLink.linkedSample:
        return 8;
      case SFSampleLink.romMonoSample:
        return 0x8001;
      case SFSampleLink.romRightSample:
        return 0x8002;
      case SFSampleLink.romLeftSample:
        return 0x8004;
      case SFSampleLink.romLinkedSample:
        return 0x8008;
      default:
        return 0;
    }
  }

  static SFSampleLink fromValue(int val) {
    switch (val) {
      case 1:
        return SFSampleLink.monoSample;
      case 2:
        return SFSampleLink.rightSample;
      case 4:
        return SFSampleLink.leftSample;
      case 8:
        return SFSampleLink.linkedSample;
      case 0x8001:
        return SFSampleLink.romMonoSample;
      case 0x8002:
        return SFSampleLink.romRightSample;
      case 0x8004:
        return SFSampleLink.romLeftSample;
      case 0x8008:
        return SFSampleLink.romLinkedSample;
      default:
        throw ArgumentError('Invalid value for SFSampleLink: $val');
    }
  }
}
