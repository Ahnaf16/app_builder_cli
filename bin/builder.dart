import 'dart:io';

import 'package:args/args.dart';

enum Target {
  android,
  ios,
  macos,
  windows;

  static Target fromName(String name) {
    return switch (name) {
      'android' || 'a' => Target.android,
      'ios' || 'i' => Target.ios,
      'macos' || 'm' => Target.macos,
      'windows' || 'w' => Target.windows,
      _ => Target.android
    };
  }

  static String helpText() {
    return '''
Targets :
android | a, ios | i, macos | m, windows | w 
    ''';
  }
}

void printUsage(ArgParser argParser) {
  stdout.writeln('Usage: dart app_builder_cli.dart <flags> [arguments]');
  stdout.writeln(argParser.usage);
}

Future<bool> changeName(String? name, Set<Target> targets) async {
  if (name == null) return false;
  final t = targets.map((e) => e.name).toList().join(',');

  final result = await Process.run(
    'rename',
    ['setAppName', '--value', name, '-t', t],
  );

  stdout.writeln('\x1B[32m${result.stdout}\x1B[0m');
  stdout.writeln('\x1B[31m${result.stderr}\x1B[0m');
  stdout.writeln('\n--- NAME UPDATED : $name ---\n');

  return result.exitCode == 0;
}

Future<bool> changePackage(String? package, Set<Target> targets) async {
  if (package == null) return false;

  final t = targets.map((e) => e.name).toList().join(',');

  final result = await Process.run(
    'rename',
    ['setBundleId', '--value', package, '-t', t],
  );

  stdout.writeln('\x1B[32m${result.stdout}\x1B[0m');
  stdout.writeln('\x1B[31m${result.stderr}\x1B[0m');
  stdout.writeln('\n--- PACKAGE UPDATED : $package ---\n');

  return result.exitCode == 0;
}

Future<bool> updateIcon() async {
  final result =
      await Process.run('fvm', ['dart', 'run', 'flutter_launcher_icons']);

  stdout.writeln('\x1B[32m${result.stdout}\x1B[0m');
  stdout.writeln('\x1B[31m${result.stderr}\x1B[0m');
  stdout.writeln('\n--- ICON UPDATED ---\n');

  return result.exitCode == 0;
}
