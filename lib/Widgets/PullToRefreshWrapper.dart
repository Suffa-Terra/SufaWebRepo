import 'package:flutter/material.dart';
import 'package:sufaweb/Widgets/RestartWidget.dart';

class PullToRefreshWrapper extends StatelessWidget {
  final Widget child;

  const PullToRefreshWrapper({super.key, required this.child});

  Future<void> _handleRefresh(BuildContext context) async {
    await Future.delayed(const Duration(milliseconds: 500));
    RestartWidget.restartApp(context);
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => _handleRefresh(context),
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height,
            child: child,
          ),
        ],
      ),
    );
  }
}
