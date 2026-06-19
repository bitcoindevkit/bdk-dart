import 'dart:io';
import 'dart:typed_data';

const _libraryName = 'libbdk_dart_ffi.so';
const _minimumLoadAlignment = 0x4000;
const _ptLoad = 1;

Future<void> main(List<String> args) async {
  if (args.isEmpty) {
    _fail(
      'Usage: dart scripts/check_android_elf_alignment.dart <apk-or-so> [...]',
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
      await _checkApk(input);
    }
  }
}

Future<void> _checkApk(File apk) async {
  final tempDir = await Directory.systemTemp.createTemp(
    'bdk_dart_elf_alignment_',
  );

  try {
    await _extractLibraries(apk, tempDir);
    final libraries =
        tempDir
            .listSync(recursive: true)
            .whereType<File>()
            .where((file) => file.uri.pathSegments.last == _libraryName)
            .toList()
          ..sort((a, b) => a.path.compareTo(b.path));

    if (libraries.isEmpty) {
      _fail('No $_libraryName entries found in ${apk.path}');
    }

    for (final library in libraries) {
      _checkLibrary(library, _relativePath(library, tempDir));
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

Future<void> _extractLibraries(File apk, Directory destination) async {
  final result = await Process.run('unzip', [
    '-q',
    apk.path,
    'lib/*/$_libraryName',
    '-d',
    destination.path,
  ]);

  if (result.exitCode != 0) {
    _fail(
      'Failed to extract $_libraryName from ${apk.path}.\n'
      '${result.stderr}',
    );
  }
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

String _relativePath(File file, Directory root) {
  final prefix = '${root.path}${Platform.pathSeparator}';
  return file.path.startsWith(prefix)
      ? file.path.substring(prefix.length)
      : file.path;
}

String _hex(int value) => '0x${value.toRadixString(16)}';

Never _fail(String message) {
  stderr.writeln(message);
  exit(1);
}
