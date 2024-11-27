import 'dart:io';

import 'package:args/args.dart';

import 'builder.dart';

const _helpArg = 'help';
const _nameArg = 'name';
const _packageArg = 'package';
const _iconGenArg = 'icon-gen';
const _targetArg = 'targets';

ArgParser buildParser() {
  final p = ArgParser();
  p.addFlag(_helpArg, abbr: 'h', help: 'Print usage');
  p.addFlag(_iconGenArg, abbr: 'i', help: 'Generate app icon');
  p.addMultiOption(_targetArg, abbr: 't', help: Target.helpText());
  p.addOption(_nameArg, abbr: 'n', help: 'Name of the app');
  p.addOption(_packageArg, abbr: 'p', help: 'Package name of the app');

  return p;
}

void main(List<String> arguments) {
  if (arguments.isEmpty) {
    stdout.writeln('No arguments provided');
    exit(0);
  }
  final parser = buildParser();
  try {
    final results = parser.parse(arguments);

    if (results.wasParsed(_helpArg)) {
      printUsage(parser);
      exit(0);
    }
    Set<Target> targets = {};

    if (results.wasParsed(_targetArg)) {
      final tList = results.multiOption(_targetArg);

      for (var t in tList) {
        targets.add(Target.fromName(t));
      }
    }

    if (targets.isEmpty) targets.add(Target.android);

    if (results.wasParsed(_iconGenArg)) updateIcon();
    if (results.wasParsed(_nameArg)) {
      changeName(results.option(_nameArg), targets);
    }
    if (results.wasParsed(_packageArg)) {
      changePackage(results.option(_packageArg), targets);
    }
  } on FormatException catch (e) {
    print(e.message);
    print('');
    printUsage(parser);
  }
}
