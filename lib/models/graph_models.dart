enum NodeType {
  start,
  intermediate,
  goal,
  trap,
}

class GraphNode {
  final String id;
  final NodeType type;
  final String? hint;

  const GraphNode({
    required this.id,
    required this.type,
    this.hint,
  });

  bool get isGoal => type == NodeType.goal;
  bool get isTrap => type == NodeType.trap;
  bool get isStart => type == NodeType.start;
}

class GraphEdge {
  final String fromNodeId;
  final String toNodeId;
  final int deltaMin;
  final int deltaMax;
  final int direction;

  const GraphEdge({
    required this.fromNodeId,
    required this.toNodeId,
    required this.deltaMin,
    required this.deltaMax,
    required this.direction,
  });

  bool matchesDelta(int delta) {
    if (direction > 0 && delta < 0) return false;
    if (direction < 0 && delta > 0) return false;
    final absDelta = delta.abs();
    return absDelta >= deltaMin && absDelta <= deltaMax;
  }
}

class SafeGraph {
  final String id;
  final String name;
  final List<GraphNode> nodes;
  final List<GraphEdge> edges;
  final String startNodeId;
  final int par;

  const SafeGraph({
    required this.id,
    required this.name,
    required this.nodes,
    required this.edges,
    required this.startNodeId,
    required this.par,
  });

  GraphNode? getNode(String nodeId) {
    try {
      return nodes.firstWhere((n) => n.id == nodeId);
    } catch (_) {
      return null;
    }
  }

  GraphNode get startNode => getNode(startNodeId)!;

  List<GraphEdge> getOutgoingEdges(String nodeId) {
    return edges.where((e) => e.fromNodeId == nodeId).toList();
  }

  GraphEdge? findMatchingEdge(String currentNodeId, int delta) {
    final outgoing = getOutgoingEdges(currentNodeId);
    for (final edge in outgoing) {
      if (edge.matchesDelta(delta)) {
        return edge;
      }
    }
    return null;
  }
}
