// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: avoid_print

import 'package:google_identity_services_web/id.dart' as id;
// #docregion use-loader
import 'package:google_identity_services_web/loader.dart' as gis;
// #enddocregion use-loader
import 'package:js/js.dart' show allowInterop;
import 'package:jwt_decoder/jwt_decoder.dart' as jwt;

// #docregion use-loader
void main() async {
  await gis.loadWebSdk(); // Load the GIS SDK
  // The rest of your code...
// #enddocregion use-loader
  id.setLogLevel('debug');

  final id.IdConfiguration config = id.IdConfiguration(
    client_id: 'your-client_id.apps.googleusercontent.com',
    ux_mode: id.UxMode.popup,
    callback: allowInterop(onCredentialResponse),
  );

  id.initialize(config);
  id.prompt(allowInterop(onPromptMoment));
// #docregion use-loader
}
// #enddocregion use-loader

/// Handles the ID token returned from the One Tap prompt.
/// See: https://developers.google.com/identity/gsi/web/reference/js-reference#callback
void onCredentialResponse(id.CredentialResponse o) {
  final Map<String, dynamic>? payload = jwt.JwtDecoder.tryDecode(o.credential);
  if (payload != null) {
    print('Hello, ${payload["name"]}');
    print(o.select_by);
    print(payload);
  } else {
    print('Could not decode ${o.credential}');
  }
}

/// Handles Prompt UI status notifications.
/// See: https://developers.google.com/identity/gsi/web/reference/js-reference#google.accounts.id.prompt
void onPromptMoment(id.PromptMomentNotification o) {
  final id.MomentType type = o.getMomentType();
  print(type.runtimeType);
  print(type);
  print(type.index);
  print(o.getDismissedReason());
  print(o.getNotDisplayedReason());
  print(o.getSkippedReason());
}
