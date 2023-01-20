/// The "business rule" of the game. Depending on the count of neighbours,
/// the [alive] changes.
class CellState {
  CellState(this.alive);
  final bool alive;

  bool reactToNeighbours(int neighbours) {
    if (neighbours == 3) {
      return true;
    } else if (neighbours != 2) {
      return false;
    }
    return alive;
  }
}

/// A coordinate on the [Grid].
class Point {
  const Point(this.x, this.y);

  final int x;
  final int y;

  operator +(covariant Point other) => Point(x + other.x, y + other.y);

  @override
  int get hashCode => x ^ y;

  @override
  bool operator ==(Object other) {
    if (other is Point) {
      return x == other.x && y == other.y;
    }
    return false;
  }

  @override
  String toString() => '($x, $y)';
}

/// The grid is an endless, two-dimensional [field] of cell [State]s.
class Grid {
  Grid({
    required this.xCount,
    required this.yCount,
    List<Point> alivePoints = const [],
  }) {
    for (var point in alivePoints) {
      field[point] = true;
    }
  }

  final int xCount;
  final int yCount;
  Map<Point, bool> field = {};

  int countLiveNeighbours(Point point) =>
      neighbourPoints.where((offset) => field[point + offset] == true).length;

  void iterate({required void Function(Point) onUpdate}) {
    for (var x = 0; x < xCount; x++) {
      for (var y = 0; y < yCount; y++) {
        onUpdate(Point(x, y));
      }
    }
  }

  /// List of the relative indices of the 8 cells around a cell.
  static List<Point> neighbourPoints = [
    const Point(-1, -1),
    const Point(0, -1),
    const Point(1, -1),
    const Point(-1, 0),
    const Point(1, 0),
    const Point(-1, 1),
    const Point(0, 1),
    const Point(1, 1),
  ];
}

/// The game updates the [grid] in each step using the [CellState].
class Game {
  Game(this.grid);
  final Grid grid;

  void tick() {
    final newField = <Point, bool>{};

    grid.iterate(onUpdate: (point) {
      final cellState = CellState(grid.field[point] ?? false);
      final liveNeighbours = grid.countLiveNeighbours(point);
      newField[point] = cellState.reactToNeighbours(liveNeighbours);
    });

    grid.field = newField;
  }
}

class Patterns {
  static Grid beacon() {
    final alive = [
      const Point(1, 1),
      const Point(1, 2),
      const Point(2, 1),
      const Point(4, 3),
      const Point(3, 4),
      const Point(4, 4),
    ];
    return Grid(xCount: 6, yCount: 6, alivePoints: alive);
  }

  static Grid pulsar() {
    final alive = [
      // top left
      const Point(4, 2),
      const Point(5, 2),
      const Point(6, 2),
      const Point(2, 4),
      const Point(2, 5),
      const Point(2, 6),
      const Point(4, 7),
      const Point(5, 7),
      const Point(6, 7),
      const Point(7, 4),
      const Point(7, 5),
      const Point(7, 6),
      // top right
      const Point(10, 2),
      const Point(11, 2),
      const Point(12, 2),
      const Point(9, 4),
      const Point(9, 5),
      const Point(9, 6),
      const Point(10, 7),
      const Point(11, 7),
      const Point(12, 7),
      const Point(14, 4),
      const Point(14, 5),
      const Point(14, 6),
      // bottom left
      const Point(4, 9),
      const Point(5, 9),
      const Point(6, 9),
      const Point(2, 10),
      const Point(2, 11),
      const Point(2, 12),
      const Point(4, 14),
      const Point(5, 14),
      const Point(6, 14),
      const Point(7, 10),
      const Point(7, 11),
      const Point(7, 12),
      // bottom right
      const Point(10, 9),
      const Point(11, 9),
      const Point(12, 9),
      const Point(9, 10),
      const Point(9, 11),
      const Point(9, 12),
      const Point(10, 14),
      const Point(11, 14),
      const Point(12, 14),
      const Point(14, 10),
      const Point(14, 11),
      const Point(14, 12),
    ];
    return Grid(xCount: 17, yCount: 17, alivePoints: alive);
  }

  static Grid pentaDecathlon() {
    final alive = [
      // top
      const Point(5, 3),
      const Point(4, 4),
      const Point(5, 4),
      const Point(6, 4),
      const Point(3, 5),
      const Point(4, 5),
      const Point(5, 5),
      const Point(6, 5),
      const Point(7, 5),
      // bottom
      const Point(3, 12),
      const Point(4, 12),
      const Point(5, 12),
      const Point(6, 12),
      const Point(7, 12),
      const Point(4, 13),
      const Point(5, 13),
      const Point(6, 13),
      const Point(5, 14),
    ];
    return Grid(xCount: 11, yCount: 18, alivePoints: alive);
  }

  static Grid gosperGliderGun() {
    final alive = [
      const Point(1, 5),
      const Point(2, 5),
      const Point(1, 6),
      const Point(2, 6),
      //
      const Point(11, 5),
      const Point(11, 6),
      const Point(11, 7),
      const Point(12, 4),
      const Point(12, 8),
      const Point(13, 3),
      const Point(13, 9),
      const Point(14, 3),
      const Point(14, 9),
      const Point(15, 6),
      const Point(16, 4),
      const Point(16, 8),
      const Point(17, 5),
      const Point(17, 6),
      const Point(17, 7),
      const Point(18, 6),
      //
      const Point(21, 3),
      const Point(21, 4),
      const Point(21, 5),
      const Point(22, 3),
      const Point(22, 4),
      const Point(22, 5),
      const Point(23, 2),
      const Point(23, 6),
      const Point(25, 1),
      const Point(25, 2),
      const Point(25, 6),
      const Point(25, 7),
      //
      const Point(35, 3),
      const Point(35, 4),
      const Point(36, 3),
      const Point(36, 4),
    ];
    return Grid(xCount: 38, yCount: 12, alivePoints: alive);
  }

  static List<String> names = [
    'gosper glider gun',
    'penta decathlon',
    'pulsar',
    'beacon',
  ];
  static List<Grid> allGrids = [
    gosperGliderGun(),
    pentaDecathlon(),
    pulsar(),
    beacon(),
  ];
}
