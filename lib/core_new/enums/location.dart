enum Location {
  cellular,
  LAN,
  WAN,
  UNKNOWN,
}

extension ParseToString on Location {
  String toShortString() {
    return this.toString().split('.').last;
  }
}
