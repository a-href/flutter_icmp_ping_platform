import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:async/async.dart';
import 'package:flutter_icmp_ping/src/base_ping_stream.dart';
import 'package:flutter_icmp_ping/src/models/ping_data.dart';
import 'package:flutter_icmp_ping/src/models/ping_error.dart';
import 'package:flutter_icmp_ping/src/models/ping_response.dart';
import 'package:flutter_icmp_ping/src/models/ping_summary.dart';

class PingOhos extends BasePing {
  PingOhos(String host, int? count, double? interval, double? timeout, bool? ipv6, int? ttl) : super(host, count, interval, timeout, ipv6, ttl);

  int _received = 0;
  int _sent = 0;
  List<Duration> _times = [];

  @override
  void onListen() {
    _startPinging();
  }

  void _startPinging() async {
    final args = <String>[
      if (count != null) '-c $count',
      if (timeout != null) '-W ${timeout!.toInt()}',
      if (interval != null) '-i ${interval!.toStringAsFixed(1)}',
      if (ttl != null) '-t $ttl',
      if (ipv6 == true) '-6',
      host,
    ];

    try {
      final process = await Process.start('ping', args);

      subscription = StreamGroup.merge([process.stdout, process.stderr]).transform(utf8.decoder).transform(const LineSplitter()).transform<PingData>(_createOhosTransformer()).listen((pingData) {
        controller.add(pingData);
        _sent++;
        if (pingData.response != null) {
          _received++;
          if (pingData.response!.time != null) {
            _times.add(pingData.response!.time!);
          }
        }
      }, onError: (error) {
        controller.addError(error);
      }, onDone: () {
        _generateSummary();
        stop();
      });
    } catch (e) {
      controller.addError('Failed to start ping process: $e');
      stop();
    }
  }

  StreamTransformer<String, PingData> _createOhosTransformer() {
    return StreamTransformer.fromHandlers(
      handleData: (data, sink) {
        final pingData = _parsePingOutput(data);
        if (pingData != null) {
          sink.add(pingData);
        }
      },
    );
  }

  PingData? _parsePingOutput(String line) {
    if (line.contains('time=')) {
      final timeMatch = RegExp(r'time=([\d.]+)').firstMatch(line);
      final seqMatch = RegExp(r'icmp_seq=(\d+)').firstMatch(line);
      final ttlMatch = RegExp(r'ttl=(\d+)').firstMatch(line);

      return PingData(
        response: PingResponse(
          ip: host,
          seq: seqMatch != null ? int.tryParse(seqMatch.group(1) ?? '') : null,
          ttl: ttlMatch != null ? int.tryParse(ttlMatch.group(1) ?? '') : null,
          time: timeMatch != null ? Duration(milliseconds: (double.tryParse(timeMatch.group(1) ?? '0') ?? 0).round()) : null,
        ),
      );
    } else if (line.contains('Destination Host Unreachable') || line.contains('Request timed out')) {
      return PingData(
        error: PingError.requestTimedOut,
      );
    }
    return PingData(
      error: PingError.unknownHost,
    );
  }

  void _generateSummary() {
    final summary = PingSummary(
      transmitted: _sent,
      received: _received,
      time: _times.isNotEmpty ? _times.reduce((a, b) => a + b) : Duration.zero,
    );

    controller.add(
      PingData(
        summary: summary,
      ),
    );
  }

  @override
  void stop() {
    super.stop();
    _received = 0;
    _sent = 0;
    _times.clear();
  }
}
