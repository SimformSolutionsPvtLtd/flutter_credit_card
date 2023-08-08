// Copyright 2022 Guillaume Cendre. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:flutter_credit_card/floating_card_setup/floating_event.dart';
import 'package:flutter_credit_card/floating_card_setup/floating_interface/floating_native_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

/// The common platform interface for the [Motion] plugin.
abstract class FloatingPlatform extends PlatformInterface {
  /// Constructs a [FloatingPlatform].
  FloatingPlatform() : super(token: _token);

  static final Object _token = Object();

  static FloatingPlatform _instance = FloatingMethodChannel();

  /// The default instance of [FloatingPlatform] to use.
  ///
  /// Defaults to [FloatingMethodChannel].
  static FloatingPlatform get instance => _instance;

  /// Platform-specific plugins should set this with their own platform-specific
  /// class that extends [FloatingPlatform] when they register themselves.
  static set instance(FloatingPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// Platform features declaration

  /// Detects if the platform is Safari Mobile (iOS or iPad).
  bool get isSafariMobile => false;

  /// Indicates whether the gradient is available.
  bool get isGradientOverlayAvailable => !isSafariMobile;

  /// Indicates whether the gyroscope is available.
  bool get isGyroscopeAvailable => false;

  /// Indicates whether a permission is required to access gyroscope data.
  bool get isPermissionRequired => false;

  /// Indicates whether the permission is granted.
  bool get isPermissionGranted => false;

  /// The gyroscope stream, if available.
  Stream<FloatingEvent>? get floatingStream => null;

  Future<void> initialize() async {
    throw UnimplementedError();
  }

  Future<bool> requestPermission() async {
    throw UnimplementedError();
  }
}
