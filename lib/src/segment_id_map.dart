class SegmentIdMap {
  int offset;
  int size;
  String name;
  String tag;
  List<SegmentIdMap> segments = [];
  SegmentIdMap? parent;
  bool parsed = false;
  SegmentIdMap(this.name, this.tag, this.offset, this.size, {this.parent});
}
