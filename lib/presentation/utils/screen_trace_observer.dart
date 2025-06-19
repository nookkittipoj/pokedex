import 'package:flutter/material.dart';
import 'package:firebase_performance/firebase_performance.dart';

final RouteObserver<ModalRoute<void>> routeObserver =
    RouteObserver<ModalRoute<void>>();

class ScreenTraceObserver extends StatefulWidget {
  final String traceName;
  final Widget child;
  final Map<String, int> initialMetrics;

  const ScreenTraceObserver({
    super.key,
    required this.traceName,
    required this.child,
    this.initialMetrics = const {},
  });

  @override
  State<ScreenTraceObserver> createState() => _ScreenTraceObserverState();
}

class _ScreenTraceObserverState extends State<ScreenTraceObserver>
    with RouteAware {
  Trace? _trace;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final modalRoute = ModalRoute.of(context);
    if (modalRoute != null) {
      routeObserver.subscribe(this, modalRoute);
    }
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    _trace?.stop();
    super.dispose();
  }

  @override
  void didPush() => _startTrace();
  @override
  void didPopNext() => _startTrace();
  @override
  void didPushNext() => _stopTrace();
  @override
  void didPop() => _stopTrace();

  Future<void> _startTrace() async {
    _trace = FirebasePerformance.instance.newTrace(widget.traceName);
    await _trace?.start();
    widget.initialMetrics.forEach((key, value) {
      _trace?.setMetric(key, value);
    });
  }

  Future<void> _stopTrace() async {
    await _trace?.stop();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
