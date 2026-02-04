import '../models/graph_models.dart';
import '../models/safe_models.dart';

class SampleSafes {
  static List<Safe> getFreeSafes() {
    return [
      _createSafe1(),
      _createSafe2(),
      _createSafe3(),
      _createSafe4(),
      _createSafe5(),
      _createSafe6(),
      _createSafe7(),
      _createSafe8(),
      _createSafe9(),
    ];
  }

  static List<Safe> getPremiumSafes() {
    return List.generate(9, (i) => _createPremiumSafe(i + 1));
  }

  static Safe _createSafe1() {
    final nodes = [
      const GraphNode(id: 'start', type: NodeType.start),
      const GraphNode(id: 'n1', type: NodeType.intermediate),
      const GraphNode(id: 'goal', type: NodeType.goal),
      const GraphNode(id: 'trap1', type: NodeType.trap),
    ];

    final edges = [
      const GraphEdge(fromNodeId: 'start', toNodeId: 'n1', deltaMin: 30, deltaMax: 50, direction: 1),
      const GraphEdge(fromNodeId: 'start', toNodeId: 'trap1', deltaMin: 60, deltaMax: 100, direction: 1),
      const GraphEdge(fromNodeId: 'n1', toNodeId: 'goal', deltaMin: 20, deltaMax: 40, direction: -1),
      const GraphEdge(fromNodeId: 'n1', toNodeId: 'trap1', deltaMin: 50, deltaMax: 80, direction: -1),
    ];

    return Safe(
      id: 'free_1',
      name: 'The Beginner',
      category: SafeCategory.free,
      order: 1,
      isUnlocked: true,
      graph: SafeGraph(
        id: 'graph_1',
        name: 'Simple Path',
        nodes: nodes,
        edges: edges,
        startNodeId: 'start',
        par: 2,
      ),
    );
  }

  static Safe _createSafe2() {
    final nodes = [
      const GraphNode(id: 'start', type: NodeType.start),
      const GraphNode(id: 'n1', type: NodeType.intermediate),
      const GraphNode(id: 'n2', type: NodeType.intermediate),
      const GraphNode(id: 'goal', type: NodeType.goal),
      const GraphNode(id: 'trap1', type: NodeType.trap),
      const GraphNode(id: 'trap2', type: NodeType.trap),
    ];

    final edges = [
      const GraphEdge(fromNodeId: 'start', toNodeId: 'n1', deltaMin: 40, deltaMax: 60, direction: 1),
      const GraphEdge(fromNodeId: 'start', toNodeId: 'trap1', deltaMin: 80, deltaMax: 120, direction: 1),
      const GraphEdge(fromNodeId: 'n1', toNodeId: 'n2', deltaMin: 25, deltaMax: 45, direction: -1),
      const GraphEdge(fromNodeId: 'n1', toNodeId: 'trap2', deltaMin: 60, deltaMax: 90, direction: -1),
      const GraphEdge(fromNodeId: 'n2', toNodeId: 'goal', deltaMin: 35, deltaMax: 55, direction: 1),
      const GraphEdge(fromNodeId: 'n2', toNodeId: 'trap1', deltaMin: 70, deltaMax: 100, direction: 1),
    ];

    return Safe(
      id: 'free_2',
      name: 'Three Steps',
      category: SafeCategory.free,
      order: 2,
      isUnlocked: false,
      graph: SafeGraph(
        id: 'graph_2',
        name: 'Triple Move',
        nodes: nodes,
        edges: edges,
        startNodeId: 'start',
        par: 3,
      ),
    );
  }

  static Safe _createSafe3() {
    final nodes = [
      const GraphNode(id: 'start', type: NodeType.start),
      const GraphNode(id: 'n1', type: NodeType.intermediate),
      const GraphNode(id: 'n2', type: NodeType.intermediate),
      const GraphNode(id: 'n3', type: NodeType.intermediate),
      const GraphNode(id: 'goal', type: NodeType.goal),
      const GraphNode(id: 'trap1', type: NodeType.trap),
    ];

    final edges = [
      const GraphEdge(fromNodeId: 'start', toNodeId: 'n1', deltaMin: 20, deltaMax: 35, direction: 1),
      const GraphEdge(fromNodeId: 'start', toNodeId: 'n2', deltaMin: 50, deltaMax: 70, direction: 1),
      const GraphEdge(fromNodeId: 'n1', toNodeId: 'n3', deltaMin: 30, deltaMax: 50, direction: -1),
      const GraphEdge(fromNodeId: 'n2', toNodeId: 'trap1', deltaMin: 20, deltaMax: 40, direction: -1),
      const GraphEdge(fromNodeId: 'n3', toNodeId: 'goal', deltaMin: 40, deltaMax: 60, direction: 1),
    ];

    return Safe(
      id: 'free_3',
      name: 'The Fork',
      category: SafeCategory.free,
      order: 3,
      isUnlocked: false,
      graph: SafeGraph(
        id: 'graph_3',
        name: 'Forked Path',
        nodes: nodes,
        edges: edges,
        startNodeId: 'start',
        par: 3,
      ),
    );
  }

  static Safe _createSafe4() {
    final nodes = [
      const GraphNode(id: 'start', type: NodeType.start),
      const GraphNode(id: 'n1', type: NodeType.intermediate),
      const GraphNode(id: 'n2', type: NodeType.intermediate),
      const GraphNode(id: 'goal', type: NodeType.goal),
      const GraphNode(id: 'trap1', type: NodeType.trap),
      const GraphNode(id: 'trap2', type: NodeType.trap),
    ];

    final edges = [
      const GraphEdge(fromNodeId: 'start', toNodeId: 'n1', deltaMin: 55, deltaMax: 75, direction: -1),
      const GraphEdge(fromNodeId: 'start', toNodeId: 'trap1', deltaMin: 30, deltaMax: 50, direction: -1),
      const GraphEdge(fromNodeId: 'n1', toNodeId: 'n2', deltaMin: 45, deltaMax: 65, direction: 1),
      const GraphEdge(fromNodeId: 'n1', toNodeId: 'trap2', deltaMin: 80, deltaMax: 110, direction: 1),
      const GraphEdge(fromNodeId: 'n2', toNodeId: 'goal', deltaMin: 30, deltaMax: 50, direction: -1),
    ];

    return Safe(
      id: 'free_4',
      name: 'Reverse Start',
      category: SafeCategory.free,
      order: 4,
      isUnlocked: false,
      graph: SafeGraph(
        id: 'graph_4',
        name: 'Counter Rotation',
        nodes: nodes,
        edges: edges,
        startNodeId: 'start',
        par: 3,
      ),
    );
  }

  static Safe _createSafe5() {
    final nodes = [
      const GraphNode(id: 'start', type: NodeType.start),
      const GraphNode(id: 'n1', type: NodeType.intermediate),
      const GraphNode(id: 'n2', type: NodeType.intermediate),
      const GraphNode(id: 'n3', type: NodeType.intermediate),
      const GraphNode(id: 'n4', type: NodeType.intermediate),
      const GraphNode(id: 'goal', type: NodeType.goal),
      const GraphNode(id: 'trap1', type: NodeType.trap),
    ];

    final edges = [
      const GraphEdge(fromNodeId: 'start', toNodeId: 'n1', deltaMin: 25, deltaMax: 40, direction: 1),
      const GraphEdge(fromNodeId: 'n1', toNodeId: 'n2', deltaMin: 35, deltaMax: 50, direction: -1),
      const GraphEdge(fromNodeId: 'n2', toNodeId: 'n3', deltaMin: 20, deltaMax: 35, direction: 1),
      const GraphEdge(fromNodeId: 'n3', toNodeId: 'n4', deltaMin: 45, deltaMax: 65, direction: -1),
      const GraphEdge(fromNodeId: 'n4', toNodeId: 'goal', deltaMin: 30, deltaMax: 45, direction: 1),
      const GraphEdge(fromNodeId: 'n2', toNodeId: 'trap1', deltaMin: 60, deltaMax: 90, direction: 1),
    ];

    return Safe(
      id: 'free_5',
      name: 'The Maze',
      category: SafeCategory.free,
      order: 5,
      isUnlocked: false,
      graph: SafeGraph(
        id: 'graph_5',
        name: 'Long Path',
        nodes: nodes,
        edges: edges,
        startNodeId: 'start',
        par: 5,
      ),
    );
  }

  static Safe _createSafe6() {
    final nodes = [
      const GraphNode(id: 'start', type: NodeType.start),
      const GraphNode(id: 'n1', type: NodeType.intermediate),
      const GraphNode(id: 'n2', type: NodeType.intermediate),
      const GraphNode(id: 'goal', type: NodeType.goal),
      const GraphNode(id: 'trap1', type: NodeType.trap),
      const GraphNode(id: 'trap2', type: NodeType.trap),
      const GraphNode(id: 'trap3', type: NodeType.trap),
    ];

    final edges = [
      const GraphEdge(fromNodeId: 'start', toNodeId: 'n1', deltaMin: 15, deltaMax: 25, direction: 1),
      const GraphEdge(fromNodeId: 'start', toNodeId: 'trap1', deltaMin: 30, deltaMax: 50, direction: 1),
      const GraphEdge(fromNodeId: 'start', toNodeId: 'trap2', deltaMin: 15, deltaMax: 30, direction: -1),
      const GraphEdge(fromNodeId: 'n1', toNodeId: 'n2', deltaMin: 40, deltaMax: 55, direction: -1),
      const GraphEdge(fromNodeId: 'n1', toNodeId: 'trap3', deltaMin: 20, deltaMax: 35, direction: -1),
      const GraphEdge(fromNodeId: 'n2', toNodeId: 'goal', deltaMin: 25, deltaMax: 40, direction: 1),
    ];

    return Safe(
      id: 'free_6',
      name: 'Narrow Window',
      category: SafeCategory.free,
      order: 6,
      isUnlocked: false,
      graph: SafeGraph(
        id: 'graph_6',
        name: 'Precision Required',
        nodes: nodes,
        edges: edges,
        startNodeId: 'start',
        par: 3,
      ),
    );
  }

  static Safe _createSafe7() {
    final nodes = [
      const GraphNode(id: 'start', type: NodeType.start),
      const GraphNode(id: 'n1', type: NodeType.intermediate),
      const GraphNode(id: 'n2', type: NodeType.intermediate),
      const GraphNode(id: 'n3', type: NodeType.intermediate),
      const GraphNode(id: 'goal', type: NodeType.goal),
      const GraphNode(id: 'trap1', type: NodeType.trap),
      const GraphNode(id: 'trap2', type: NodeType.trap),
    ];

    final edges = [
      const GraphEdge(fromNodeId: 'start', toNodeId: 'n1', deltaMin: 60, deltaMax: 80, direction: 1),
      const GraphEdge(fromNodeId: 'start', toNodeId: 'trap1', deltaMin: 90, deltaMax: 120, direction: 1),
      const GraphEdge(fromNodeId: 'n1', toNodeId: 'n2', deltaMin: 50, deltaMax: 70, direction: -1),
      const GraphEdge(fromNodeId: 'n2', toNodeId: 'n3', deltaMin: 70, deltaMax: 90, direction: 1),
      const GraphEdge(fromNodeId: 'n2', toNodeId: 'trap2', deltaMin: 100, deltaMax: 130, direction: 1),
      const GraphEdge(fromNodeId: 'n3', toNodeId: 'goal', deltaMin: 40, deltaMax: 60, direction: -1),
    ];

    return Safe(
      id: 'free_7',
      name: 'Big Swings',
      category: SafeCategory.free,
      order: 7,
      isUnlocked: false,
      graph: SafeGraph(
        id: 'graph_7',
        name: 'Wide Rotations',
        nodes: nodes,
        edges: edges,
        startNodeId: 'start',
        par: 4,
      ),
    );
  }

  static Safe _createSafe8() {
    final nodes = [
      const GraphNode(id: 'start', type: NodeType.start),
      const GraphNode(id: 'n1', type: NodeType.intermediate),
      const GraphNode(id: 'n2', type: NodeType.intermediate),
      const GraphNode(id: 'n3', type: NodeType.intermediate),
      const GraphNode(id: 'goal', type: NodeType.goal),
      const GraphNode(id: 'trap1', type: NodeType.trap),
      const GraphNode(id: 'trap2', type: NodeType.trap),
      const GraphNode(id: 'trap3', type: NodeType.trap),
    ];

    final edges = [
      const GraphEdge(fromNodeId: 'start', toNodeId: 'n1', deltaMin: 35, deltaMax: 50, direction: -1),
      const GraphEdge(fromNodeId: 'start', toNodeId: 'trap1', deltaMin: 55, deltaMax: 80, direction: -1),
      const GraphEdge(fromNodeId: 'n1', toNodeId: 'n2', deltaMin: 25, deltaMax: 40, direction: 1),
      const GraphEdge(fromNodeId: 'n1', toNodeId: 'trap2', deltaMin: 45, deltaMax: 70, direction: 1),
      const GraphEdge(fromNodeId: 'n2', toNodeId: 'n3', deltaMin: 55, deltaMax: 75, direction: -1),
      const GraphEdge(fromNodeId: 'n3', toNodeId: 'goal', deltaMin: 30, deltaMax: 45, direction: 1),
      const GraphEdge(fromNodeId: 'n3', toNodeId: 'trap3', deltaMin: 50, deltaMax: 70, direction: 1),
    ];

    return Safe(
      id: 'free_8',
      name: 'The Gauntlet',
      category: SafeCategory.free,
      order: 8,
      isUnlocked: false,
      graph: SafeGraph(
        id: 'graph_8',
        name: 'Many Traps',
        nodes: nodes,
        edges: edges,
        startNodeId: 'start',
        par: 4,
      ),
    );
  }

  static Safe _createSafe9() {
    final nodes = [
      const GraphNode(id: 'start', type: NodeType.start),
      const GraphNode(id: 'n1', type: NodeType.intermediate),
      const GraphNode(id: 'n2', type: NodeType.intermediate),
      const GraphNode(id: 'n3', type: NodeType.intermediate),
      const GraphNode(id: 'n4', type: NodeType.intermediate),
      const GraphNode(id: 'n5', type: NodeType.intermediate),
      const GraphNode(id: 'goal', type: NodeType.goal),
      const GraphNode(id: 'trap1', type: NodeType.trap),
      const GraphNode(id: 'trap2', type: NodeType.trap),
      const GraphNode(id: 'trap3', type: NodeType.trap),
    ];

    final edges = [
      const GraphEdge(fromNodeId: 'start', toNodeId: 'n1', deltaMin: 20, deltaMax: 30, direction: 1),
      const GraphEdge(fromNodeId: 'start', toNodeId: 'trap1', deltaMin: 35, deltaMax: 55, direction: 1),
      const GraphEdge(fromNodeId: 'n1', toNodeId: 'n2', deltaMin: 45, deltaMax: 60, direction: -1),
      const GraphEdge(fromNodeId: 'n2', toNodeId: 'n3', deltaMin: 15, deltaMax: 25, direction: 1),
      const GraphEdge(fromNodeId: 'n2', toNodeId: 'trap2', deltaMin: 30, deltaMax: 50, direction: 1),
      const GraphEdge(fromNodeId: 'n3', toNodeId: 'n4', deltaMin: 55, deltaMax: 75, direction: -1),
      const GraphEdge(fromNodeId: 'n4', toNodeId: 'n5', deltaMin: 35, deltaMax: 50, direction: 1),
      const GraphEdge(fromNodeId: 'n4', toNodeId: 'trap3', deltaMin: 55, deltaMax: 80, direction: 1),
      const GraphEdge(fromNodeId: 'n5', toNodeId: 'goal', deltaMin: 25, deltaMax: 40, direction: -1),
    ];

    return Safe(
      id: 'free_9',
      name: 'The Master',
      category: SafeCategory.free,
      order: 9,
      isUnlocked: false,
      graph: SafeGraph(
        id: 'graph_9',
        name: 'Ultimate Challenge',
        nodes: nodes,
        edges: edges,
        startNodeId: 'start',
        par: 6,
      ),
    );
  }

  static Safe _createPremiumSafe(int index) {
    final complexity = index + 2;
    final nodes = <GraphNode>[
      const GraphNode(id: 'start', type: NodeType.start),
    ];
    
    for (int i = 1; i <= complexity; i++) {
      nodes.add(GraphNode(id: 'n$i', type: NodeType.intermediate));
    }
    nodes.add(const GraphNode(id: 'goal', type: NodeType.goal));
    
    for (int i = 1; i <= (complexity ~/ 2) + 1; i++) {
      nodes.add(GraphNode(id: 'trap$i', type: NodeType.trap));
    }

    final edges = <GraphEdge>[];
    String prevNode = 'start';
    
    for (int i = 1; i <= complexity; i++) {
      final direction = i % 2 == 1 ? 1 : -1;
      edges.add(GraphEdge(
        fromNodeId: prevNode,
        toNodeId: 'n$i',
        deltaMin: 30 + (i * 5),
        deltaMax: 50 + (i * 5),
        direction: direction,
      ));
      
      if (i % 2 == 0) {
        edges.add(GraphEdge(
          fromNodeId: prevNode,
          toNodeId: 'trap${(i ~/ 2)}',
          deltaMin: 60 + (i * 5),
          deltaMax: 90 + (i * 5),
          direction: direction,
        ));
      }
      prevNode = 'n$i';
    }
    
    edges.add(GraphEdge(
      fromNodeId: prevNode,
      toNodeId: 'goal',
      deltaMin: 35,
      deltaMax: 55,
      direction: complexity % 2 == 1 ? -1 : 1,
    ));

    return Safe(
      id: 'premium_$index',
      name: 'Premium Safe $index',
      category: SafeCategory.premium,
      order: index,
      isUnlocked: false,
      graph: SafeGraph(
        id: 'graph_premium_$index',
        name: 'Premium Level $index',
        nodes: nodes,
        edges: edges,
        startNodeId: 'start',
        par: complexity + 1,
      ),
    );
  }
}
