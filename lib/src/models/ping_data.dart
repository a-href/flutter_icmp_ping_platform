import 'package:flutter_icmp_ping_platform/src/models/ping_error.dart';
import 'package:flutter_icmp_ping_platform/src/models/ping_response.dart';
import 'package:flutter_icmp_ping_platform/src/models/ping_summary.dart';


/// Ping response data
class PingData {
  final PingResponse? response;
  final PingSummary? summary;
  final PingError? error;

  PingData({this.response, this.summary, this.error});

  @override
  String toString() =>
      'PingData(response:$response, summary:$summary, error:$error)';
}
