// shuttle_route.dart

class ShuttleRoute {
  final String routeName;
  final String startPoint;
  final String endPoint;
  final List<String> schedule;

  ShuttleRoute({
    required this.routeName,
    required this.startPoint,
    required this.endPoint,
    required this.schedule,
  });
}
