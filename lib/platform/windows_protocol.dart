import 'dart:io';

import 'package:win32_registry/win32_registry.dart';

void registerChariTaskProtocol() {
  print('>>> registerChariTaskProtocol() CALLED');

  if (!Platform.isWindows) return;

  try {
    final protocolKey = CURRENT_USER.create(r'Software\Classes\chari-task');

    print('>>> Protocol registry key created');

    // Windows requires a VALUE named "URL Protocol"
    // whose value is an empty string.
    protocolKey.setValue('URL Protocol', const RegistryValue.string(''));

    print('>>> URL Protocol value written');

    final commandKey = protocolKey.create(r'shell\open\command');

    print('>>> Command registry key created');

    commandKey.setValue(
      '',
      RegistryValue.string('"${Platform.resolvedExecutable}" "%1"'),
    );

    print('>>> Command value written');

    commandKey.close();
    protocolKey.close();

    print('>>> ChariTask protocol registration COMPLETE');
  } catch (e, stackTrace) {
    print('!!! REGISTRY ERROR: $e');
    print(stackTrace);
  }
}
