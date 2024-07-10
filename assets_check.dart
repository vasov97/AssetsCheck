import 'dart:io';

void main() {
  final assetDir = Directory('assets/');
  if (!assetDir.existsSync()) {
    print('assets directory not found');
    exit(1);
  }

  final assetFiles = assetDir
      .listSync(recursive: true)
      .where((entity) => entity is File)
      .map((file) => file.path)
      .toList();

  final projectDir = Directory.current;
  if (!projectDir.existsSync()) {
    print('Project directory not found');
    exit(1);
  }

  final usedAssets = <String>{};

  for (var file in projectDir.listSync(recursive: true)) {
    if (file is File &&
        (file.path.endsWith('.dart') ||
            file.path.endsWith('.yaml') ||
            file.path.endsWith('.html'))) {
      final content = file.readAsStringSync();
      for (var asset in assetFiles) {
        if (content.contains(asset.replaceAll('assets/', ''))) {
          usedAssets.add(asset);
        }
      }
    }
  }

  final unusedAssets =
      assetFiles.where((asset) => !usedAssets.contains(asset)).toList();

  if (unusedAssets.isEmpty) {
    print('No unused assets found!');
  } else {
    print('Unused assets:');
    for (var asset in unusedAssets) {
      print(asset);
    }
  }
}
