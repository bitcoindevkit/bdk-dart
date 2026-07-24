// Post-generation dartdoc injector for lib/bdk.dart.
//
// Usage:
//   dart run scripts/inject_dartdocs.dart          # inject docs
//   dart run scripts/inject_dartdocs.dart --check  # verify anchors and docs
import 'dart:io';

const _defaultBindingsPath = 'lib/bdk.dart';
const _defaultEntriesPath = 'scripts/dartdoc/entries.yaml';

void main(List<String> args) {
  final checkOnly = args.contains('--check');
  final bindingsPath = _argValue(args, '--bindings') ?? _defaultBindingsPath;
  final entriesPath = _argValue(args, '--entries') ?? _defaultEntriesPath;

  final repoRoot = _findRepoRoot();
  final bindingsFile = File('${repoRoot.path}/$bindingsPath');
  final entriesFile = File('${repoRoot.path}/$entriesPath');

  if (!bindingsFile.existsSync()) {
    stderr.writeln('Bindings file not found: ${bindingsFile.path}');
    exit(1);
  }
  if (!entriesFile.existsSync()) {
    stderr.writeln('Entries file not found: ${entriesFile.path}');
    exit(1);
  }

  final entries = _parseEntries(entriesFile.readAsStringSync());
  final lines = bindingsFile.readAsLinesSync();
  final resolved = _resolveAnchors(lines, entries);

  if (checkOnly) {
    _runCheck(lines, resolved);
    stdout.writeln(
      'All ${entries.length} dartdoc anchors verified in $bindingsPath.',
    );
    return;
  }

  final updated = _injectDocs(lines, resolved);
  bindingsFile.writeAsStringSync('${updated.join('\n')}\n');
  stdout.writeln(
    'Injected dartdoc comments for ${resolved.length} anchors into $bindingsPath.',
  );
}

String? _argValue(List<String> args, String flag) {
  final index = args.indexOf(flag);
  if (index == -1 || index + 1 >= args.length) {
    return null;
  }
  return args[index + 1];
}

Directory _findRepoRoot() {
  var dir = Directory.current;
  while (true) {
    if (File('${dir.path}/pubspec.yaml').existsSync()) {
      return dir;
    }
    final parent = dir.parent;
    if (parent.path == dir.path) {
      return Directory.current;
    }
    dir = parent;
  }
}

class DocEntry {
  DocEntry({
    required this.anchor,
    required this.docs,
    this.scopeAfter,
    this.occurrence = 0,
  });

  final String anchor;
  final String docs;
  final String? scopeAfter;
  final int occurrence;
}

List<DocEntry> _parseEntries(String source) {
  final entries = <DocEntry>[];
  final blocks = source.split(RegExp(r'^---\s*$', multiLine: true));

  for (final block in blocks) {
    final trimmed = block.trim();
    if (trimmed.isEmpty) {
      continue;
    }

    String? anchor;
    String? scopeAfter;
    var occurrence = 0;
    final docLines = <String>[];
    var inDocs = false;

    for (final rawLine in trimmed.split('\n')) {
      final line = rawLine.trimRight();
      if (line.startsWith('anchor:')) {
        anchor = _parseYamlScalar(line.substring('anchor:'.length));
        inDocs = false;
        continue;
      }
      if (line.startsWith('scope_after:')) {
        scopeAfter = _parseYamlScalar(line.substring('scope_after:'.length));
        inDocs = false;
        continue;
      }
      if (line.startsWith('occurrence:')) {
        occurrence = int.parse(line.substring('occurrence:'.length).trim());
        inDocs = false;
        continue;
      }
      if (line == 'docs: |') {
        inDocs = true;
        continue;
      }
      if (inDocs) {
        docLines.add(line);
      }
    }

    if (anchor == null || docLines.isEmpty) {
      stderr.writeln('Invalid entry block (missing anchor or docs):\n$trimmed');
      exit(1);
    }

    while (docLines.isNotEmpty && docLines.last.trim().isEmpty) {
      docLines.removeLast();
    }

    entries.add(
      DocEntry(
        anchor: anchor,
        docs: _normalizeDocLines(docLines).join('\n'),
        scopeAfter: scopeAfter,
        occurrence: occurrence,
      ),
    );
  }

  return entries;
}

List<String> _normalizeDocLines(List<String> docLines) {
  final nonEmpty = docLines.where((line) => line.trim().isNotEmpty).toList();
  if (nonEmpty.isEmpty) {
    return docLines;
  }

  final minIndent = nonEmpty
      .map((line) => line.length - line.trimLeft().length)
      .reduce((a, b) => a < b ? a : b);

  return docLines
      .map(
        (line) => line.length >= minIndent ? line.substring(minIndent) : line,
      )
      .toList();
}

String _parseYamlScalar(String raw) {
  final value = raw.trim();
  if ((value.startsWith('"') && value.endsWith('"')) ||
      (value.startsWith("'") && value.endsWith("'"))) {
    return value.substring(1, value.length - 1);
  }
  return value;
}

class ResolvedEntry {
  ResolvedEntry({
    required this.entry,
    required this.lineIndex,
  });

  final DocEntry entry;
  final int lineIndex;
}

List<ResolvedEntry> _resolveAnchors(List<String> lines, List<DocEntry> entries) {
  final resolved = <ResolvedEntry>[];
  final errors = <String>[];

  for (final entry in entries) {
    final matches = _findAnchorMatches(lines, entry);
    if (matches.isEmpty) {
      errors.add('Missing anchor: "${entry.anchor}"'
          '${entry.scopeAfter == null ? '' : ' (scope_after: "${entry.scopeAfter}")'}');
      continue;
    }
    if (matches.length <= entry.occurrence) {
      errors.add(
        'Anchor "${entry.anchor}" has ${matches.length} match(es) in scope, '
        'but occurrence ${entry.occurrence} was requested.',
      );
      continue;
    }
    resolved.add(
      ResolvedEntry(entry: entry, lineIndex: matches[entry.occurrence]),
    );
  }

  if (errors.isNotEmpty) {
    stderr.writeln('Dartdoc anchor validation failed:');
    for (final error in errors) {
      stderr.writeln('  - $error');
    }
    exit(1);
  }

  return resolved;
}

List<int> _findAnchorMatches(List<String> lines, DocEntry entry) {
  var start = 0;
  var end = lines.length;

  if (entry.scopeAfter != null) {
    final scopeStart = lines.indexWhere((line) => line.trim() == entry.scopeAfter);
    if (scopeStart == -1) {
      return const [];
    }
    start = scopeStart;
    end = _scopeEnd(lines, start + 1);
  }

  final matches = <int>[];
  for (var i = start; i < end; i++) {
    if (lines[i].trim() == entry.anchor) {
      matches.add(i);
    }
  }
  return matches;
}

int _scopeEnd(List<String> lines, int start) {
  for (var i = start; i < lines.length; i++) {
    final line = lines[i];
    if (line.startsWith('class ') || line.startsWith('abstract class ')) {
      return i;
    }
  }
  return lines.length;
}

void _runCheck(List<String> lines, List<ResolvedEntry> resolved) {
  final errors = <String>[];

  for (final item in resolved) {
    final index = item.lineIndex;
    if (index == 0 || !_hasDocCommentAbove(lines, index)) {
      errors.add(
        'Missing dartdoc above anchor "${item.entry.anchor}" at line ${index + 1}',
      );
    }
  }

  if (errors.isNotEmpty) {
    stderr.writeln('Dartdoc verification failed:');
    for (final error in errors) {
      stderr.writeln('  - $error');
    }
    exit(1);
  }
}

bool _hasDocCommentAbove(List<String> lines, int anchorIndex) {
  var index = anchorIndex - 1;
  while (index >= 0 && lines[index].trim().isEmpty) {
    index--;
  }
  if (index < 0) {
    return false;
  }
  return lines[index].trimLeft().startsWith('///');
}

List<String> _injectDocs(List<String> lines, List<ResolvedEntry> resolved) {
  final sorted = [...resolved]..sort((a, b) => b.lineIndex.compareTo(a.lineIndex));
  final updated = [...lines];

  for (final item in sorted) {
    final index = item.lineIndex;
    if (_hasDocCommentAbove(updated, index)) {
      continue;
    }

    final docLines = item.entry.docs.split('\n').map((line) {
      if (line.trim().isEmpty) {
        return line;
      }

      final anchorLine = updated[index];
      final anchorIndent = anchorLine.length - anchorLine.trimLeft().length;
      if (line.length >= anchorIndent &&
          line.substring(0, anchorIndent).trim().isEmpty) {
        return line;
      }

      return '${' ' * anchorIndent}$line';
    }).toList();
    updated.insertAll(index, docLines);
  }

  return updated;
}
