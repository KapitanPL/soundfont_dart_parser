# Soundfont parser

This package is aimed to add support for sf2 (soundfont) binary files. Those files are used as databanks for sound applications such as musical instruments, for games... 

Originally this package was meant only to be able to provide list of instruments/presets stored in file to be accessed by other packages. 

If there is a need for adding more parsing capabilities, just contact me at kapitanpaplod@gmail.com

## Features

So far is the package meant only as passive parser. To parse soundFont file to access some informations.

## Getting started

Add as dependency to your pubspec.yaml

```yaml
dependencies:
    soundfont_dart_parser: ^latest
```

and import using

```dart
import 'package:soundfont_dart_parser/soundfont_dart_parser.dart';
```

## Usage

```dart
FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
        final soundFontParser = SoundFontParser(result.files.first.path!);
        await soundFontParser.init(); // actually parses the font. Async function so it is possible to load in background
    }
```

and then just access the information:
```dart
for(final instrument in soundfontParser.instrumentList)
{
    <do something interesting>
}
```

## Additional information

I hope I will slowly add more functionality. On the other hand I created this package just because I needed a list of instruments in a sf2 file.
