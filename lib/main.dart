import 'dart:io';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app/app.dart';
import 'platform/windows_protocol.dart';

Future<void> main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();

  // ---------------------------------------------------------------
  // WINDOWS STARTUP ARGUMENT DIAGNOSTIC
  // ---------------------------------------------------------------
  try {
    final desktopPath =
        Platform.environment['USERPROFILE'] ?? Platform.environment['TEMP'];

    if (desktopPath != null) {
      final debugFile = File(
        '$desktopPath\\Desktop\\charitask_startup_debug.txt',
      );

      await debugFile.writeAsString(
        'DART STARTUP ARGUMENTS:\n$args\n\n',
        mode: FileMode.append,
      );
    }
  } catch (error) {
    debugPrint('>>> STARTUP DEBUG FILE ERROR: $error');
  }

  // ---------------------------------------------------------------
  // DART STARTUP ARGUMENTS
  // ---------------------------------------------------------------
  debugPrint('>>> DART MAIN ARGUMENTS: $args');

  Uri? startupUri;
  bool launchedFromAuthCallback = false;

  if (args.isNotEmpty) {
    startupUri = Uri.tryParse(args.first);

    if (startupUri != null) {
      debugPrint('>>> STARTUP DEEP LINK: $startupUri');

      launchedFromAuthCallback =
          startupUri.scheme == 'chari-task' &&
          startupUri.host == 'auth-callback';

      if (launchedFromAuthCallback) {
        debugPrint('>>> CHARITASK AUTH CALLBACK DETECTED');
      }
    }
  }

  // ---------------------------------------------------------------
  // SUPABASE
  // ---------------------------------------------------------------
  await Supabase.initialize(
    url: 'https://yymsahuoevgbkobhzigi.supabase.co',
    publishableKey: 'sb_publishable_j5vzG9KtG0NNcaG1y4_aDA_5GL9bLYZ',
  );

  final supabase = Supabase.instance.client;

  // ---------------------------------------------------------------
  // AUTH EVENTS
  // ---------------------------------------------------------------
  supabase.auth.onAuthStateChange.listen(
    (data) {
      debugPrint(
        '>>> AUTH EVENT: ${data.event} | '
        'USER: ${data.session?.user.email}',
      );

      if (data.session != null) {
        debugPrint('>>> AUTHENTICATED USER: ${data.session!.user.email}');
      }
    },
    onError: (error, stackTrace) {
      debugPrint('>>> AUTH ERROR: $error');
    },
  );

  // ---------------------------------------------------------------
  // PROCESS WINDOWS AUTH CALLBACK
  // ---------------------------------------------------------------
  if (launchedFromAuthCallback && startupUri != null) {
    debugPrint('>>> PROCESSING CHARITASK AUTH CALLBACK');

    try {
      final response = await supabase.auth.getSessionFromUrl(startupUri);

      debugPrint('>>> AUTH CALLBACK PROCESSED');

      debugPrint('>>> CALLBACK USER: ${response.session?.user.email}');
    } catch (error, stackTrace) {
      debugPrint('>>> AUTH CALLBACK ERROR: $error');
      debugPrint('$stackTrace');
    }
  }

  // ---------------------------------------------------------------
  // WINDOWS PROTOCOL REGISTRATION
  // ---------------------------------------------------------------
  registerChariTaskProtocol();

  // ---------------------------------------------------------------
  // START CHARITASK
  // ---------------------------------------------------------------
  runApp(ChariTaskApp(launchedFromAuthCallback: launchedFromAuthCallback));
}
