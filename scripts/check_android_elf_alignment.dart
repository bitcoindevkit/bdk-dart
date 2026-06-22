import 'dart:io';
import 'dart:typed_data';

const _libraryName = 'libbdk_dart_ffi.so';
const _minimumLoadAlignment = 0x4000;
const _ptLoad = 1;

Future<void> main(List<String> args) async {
  if (args.isEmpty) {
    _fail(
      'Usage: dart scripts/check_android_elf_alignment.dart '
      '<apk-aab-or-so> [...]',
    );
  }

  for (final path in args) {
    final input = File(path);
    if (!input.existsSync()) {
      _fail('File not found: ${input.path}');
    }

    if (_isElf(input)) {
      _checkLibrary(input, input.path);
    } else {
      await _checkArchive(input);
    }
  }
}

Future<void> _checkArchive(File archive) async {
  final tempDir = await Directory.systemTemp.createTemp(
    'bdk_dart_elf_alignment_',
  );

  try {
    final entries = await _findNativeLibraryEntries(archive);
    if (entries.isEmpty) {
      _fail('No $_libraryName entries found in ${archive.path}');
    }

    await _extractLibraries(archive, tempDir, entries);

    for (final entry in entries) {
      final library = _extractedEntry(tempDir, entry);
      if (!library.existsSync()) {
        _fail('Extracted library not found: $entry');
      }
      _checkLibrary(library, entry);
    }
  } finally {
    await tempDir.delete(recursive: true);
  }
}

void _checkLibrary(File library, String label) {
  final loadAlignments = _readLoadAlignments(library);
  if (loadAlignments.isEmpty) {
    _fail('No PT_LOAD segments found in $label');
  }

  final invalidAlignments = loadAlignments.where(
    (alignment) =>
        alignment < _minimumLoadAlignment ||
        alignment % _minimumLoadAlignment != 0,
  );

  if (invalidAlignments.isNotEmpty) {
    _fail(
      '$label has invalid PT_LOAD alignment(s): '
      '${invalidAlignments.map(_hex).join(', ')}',
    );
  }

  final minimumAlignment = loadAlignments.reduce((a, b) => a < b ? a : b);
  stdout.writeln('OK $label minLOADalign=${_hex(minimumAlignment)}');
}

Future<List<String>> _findNativeLibraryEntries(File archive) async {
  final result = await Process.run('unzip', ['-Z', '-1', archive.path]);
  if (result.exitCode != 0) {
    _fail(
      'Failed to list $_libraryName entries in ${archive.path}.\n'
      '${result.stderr}',
    );
  }

  final entries =
      (result.stdout as String)
          .split('\n')
          .where(_isTargetLibraryEntry)
          .toList()
        ..sort();
  return entries;
}

bool _isTargetLibraryEntry(String entry) {
  final segments = entry.split('/');
  if (segments.any((segment) => segment.isEmpty || segment == '.')) {
    return false;
  }
  if (segments.any((segment) => segment == '..')) {
    return false;
  }
  if (segments.last != _libraryName) {
    return false;
  }

  final isApkLibrary = segments.length == 3 && segments[0] == 'lib';
  final isAabLibrary = segments.length == 4 && segments[1] == 'lib';
  return isApkLibrary || isAabLibrary;
}

Future<void> _extractLibraries(
  File archive,
  Directory destination,
  List<String> entries,
) async {
  final result = await Process.run('unzip', [
    '-q',
    archive.path,
    ...entries,
    '-d',
    destination.path,
  ]);

  if (result.exitCode != 0) {
    _fail(
      'Failed to extract $_libraryName from ${archive.path}.\n'
      '${result.stderr}',
    );
  }
}

File _extractedEntry(Directory root, String entry) {
  final path = entry
      .split('/')
      .fold(root.path, (parent, child) => _join(parent, child));
  return File(path);
}

bool _isElf(File file) {
  final reader = file.openSync();
  try {
    final magic = reader.readSync(4);
    return magic.length == 4 &&
        magic[0] == 0x7f &&
        magic[1] == 0x45 &&
        magic[2] == 0x4c &&
        magic[3] == 0x46;
  } finally {
    reader.closeSync();
  }
}

List<int> _readLoadAlignments(File elfFile) {
  final bytes = elfFile.readAsBytesSync();
  if (bytes.length < 64 || !_isElf(elfFile)) {
    _fail('${elfFile.path} is not an ELF file');
  }

  final elfClass = bytes[4];
  final endian = switch (bytes[5]) {
    1 => Endian.little,
    2 => Endian.big,
    _ => throw FormatException('Unsupported ELF endianness in ${elfFile.path}'),
  };
  final data = ByteData.sublistView(bytes);

  int uint16(int offset) => data.getUint16(offset, endian);
  int uint32(int offset) => data.getUint32(offset, endian);
  int uint64(int offset) => data.getUint64(offset, endian);

  final (
    programHeaderOffset,
    programHeaderEntrySize,
    programHeaderCount,
  ) = switch (elfClass) {
    1 => (uint32(28), uint16(42), uint16(44)),
    2 => (uint64(32), uint16(54), uint16(56)),
    _ => throw FormatException('Unsupported ELF class in ${elfFile.path}'),
  };

  final alignments = <int>[];
  for (var index = 0; index < programHeaderCount; index++) {
    final headerOffset = programHeaderOffset + index * programHeaderEntrySize;
    if (headerOffset + programHeaderEntrySize > bytes.length) {
      _fail('${elfFile.path} has a truncated ELF program header table');
    }

    final type = uint32(headerOffset);
    if (type != _ptLoad) {
      continue;
    }

    final alignment = switch (elfClass) {
      1 => uint32(headerOffset + 28),
      2 => uint64(headerOffset + 48),
      _ => throw StateError('unreachable'),
    };
    alignments.add(alignment);
  }

  return alignments;
}

String _hex(int value) => '0x${value.toRadixString(16)}';

String _join(String parent, String child) {
  final separator = Platform.pathSeparator;
  return parent.endsWith(separator)
      ? '$parent$child'
      : '$parent$separator$child';
}

Never _fail(String message) {
  stderr.writeln(message);
  exit(1);
}
