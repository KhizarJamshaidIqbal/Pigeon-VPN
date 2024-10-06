import 'dart:async';
import 'package:openvpn_flutter/openvpn_flutter.dart';

class VpnStatusManager {
  static final VpnStatusManager _instance = VpnStatusManager._internal();
  factory VpnStatusManager() => _instance;

  VpnStatusManager._internal();

  // Stream controller for broadcasting VPN status updates
  final StreamController<VpnStatus?> _statusController =
      StreamController<VpnStatus?>.broadcast();
  Stream<VpnStatus?> get statusStream => _statusController.stream;

  // Holds the current VPN status
  VpnStatus? _currentStatus;

  // Call this method to update the VPN status
  void updateStatus(VpnStatus? status) {
    _currentStatus = status;
    _statusController.sink.add(status);
  }

  // Get the latest VPN status
  VpnStatus? get currentStatus => _currentStatus;

  // Dispose of the stream controller when done
  void dispose() {
    _statusController.close();
  }
}
