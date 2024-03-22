class Word {
  int _value = 0;

  Word(int value) {
    this.value = value; // Use the setter to enforce the range on initialization
  }

  int get value => _value;

  set value(int newValue) {
    if (newValue < 0 || newValue > 0xFFFF) {
      throw ArgumentError('Value must be between 0 and 65535.');
    }
    _value = newValue;
  }
}

class DWord {
  int _value = 0;

  DWord(int value) {
    this.value = value; // Use the setter to enforce the range on initialization
  }

  int get value => _value;

  set value(int newValue) {
    if (newValue < 0 || newValue > 0xFFFFFFFF) {
      throw ArgumentError('Value must be between 0 and 4294967295.');
    }
    _value = newValue;
  }
}

class Byte {
  int _value = 0;

  Byte(int value) {
    this.value = value; // Use the setter to enforce the range on initialization
  }

  int get value => _value;

  set value(int newValue) {
    if (newValue < 0 || newValue > 0xFF) {
      throw ArgumentError('Value must be between 0 and 255.');
    }
    _value = newValue;
  }
}

class Char {
  int _value = 0;

  Char(int value) {
    this.value = value;
  }

  int get value => _value;

  set value(int newValue) {
    if (newValue < -128 || newValue > 127) {
      throw ArgumentError('Value must be between -128 and 127.');
    }
    _value = newValue;
  }
}

class Short {
  int _value = 0;

  Short(int value) {
    this.value = value;
  }

  int get value => _value;

  set value(int newValue) {
    if (newValue < -32768 || newValue > 32767) {
      throw ArgumentError('Value must be between -32768 and 32767.');
    }
    _value = newValue;
  }
}

extension CTypes on int {
  Word toWord() {
    return Word(this);
  }

  DWord toDWord() {
    return DWord(this);
  }

  Byte toByte() {
    return Byte(this);
  }

  Char toChar() {
    return Char(this);
  }

  Short toShort() {
    return Short(this);
  }
}
