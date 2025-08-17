import 'package:flutter/material.dart';
import 'package:questly/common/widgets/custom_shaps/curved_edges/curved_edges.dart';

class TCurvedEdgWidget extends StatelessWidget {
  const TCurvedEdgWidget({
    super.key, required this.child,
  });
final Widget child;
  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: TCustomCurvedEdges(),
      child: child
    );
  }
}

