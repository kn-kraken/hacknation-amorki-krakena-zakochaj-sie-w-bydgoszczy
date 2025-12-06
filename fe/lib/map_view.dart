import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show json;

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();

  // Center of Bydgoszcz
  final LatLng _center = LatLng(53.1235, 18.0084);

  // Store route points
  List<LatLng> _routePoints = [];
  bool _isLoadingRoute = true;

  // Define waypoints with coordinates (rearranged for better route flow)
  final List<Map<String, dynamic>> _waypoints = [
    {
      'name': 'Old Market Square',
      'location': LatLng(53.1236, 18.0067),
      'imageUrl': 'https://picsum.photos/200/200?random=1',
    },
    {
      'name': 'Cathedral',
      'location': LatLng(53.1215, 18.0125),
      'imageUrl': 'https://picsum.photos/200/200?random=4',
    },
    {
      'name': 'Mill Island',
      'location': LatLng(53.1267, 18.0089),
      'imageUrl': 'https://picsum.photos/200/200?random=2',
    },
    {
      'name': 'Opera Nova',
      'location': LatLng(53.1198, 18.0053),
      'imageUrl': 'https://picsum.photos/200/200?random=3',
    },
  ];

  @override
  void initState() {
    super.initState();
    _fetchRoute();
  }

  Future<void> _fetchRoute() async {
    setState(() {
      _isLoadingRoute = true;
    });

    try {
      List<LatLng> allRoutePoints = [];

      // Get routes between consecutive waypoints
      for (int i = 0; i < _waypoints.length - 1; i++) {
        final start = _waypoints[i]['location'] as LatLng;
        final end = _waypoints[i + 1]['location'] as LatLng;

        // Using OSRM (Open Source Routing Machine) - no API key needed
        final url = Uri.parse(
          'https://router.project-osrm.org/route/v1/walking/'
          '${start.longitude},${start.latitude};'
          '${end.longitude},${end.latitude}'
          '?overview=full&geometries=geojson',
        );

        final response = await http.get(url);

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          final List<dynamic> coords =
              data['routes'][0]['geometry']['coordinates'];

          // Add points from this segment
          final segmentPoints = coords
              .map((coord) => LatLng(coord[1] as double, coord[0] as double))
              .toList();

          allRoutePoints.addAll(segmentPoints);
        } else {
          print('Failed to fetch route segment $i');
        }

        // Small delay to avoid rate limiting
        await Future.delayed(const Duration(milliseconds: 200));
      }

      if (allRoutePoints.isNotEmpty) {
        setState(() {
          _routePoints = allRoutePoints;
          _isLoadingRoute = false;
        });
      } else {
        _useStraightLines();
      }
    } catch (e) {
      print('Error fetching route: $e');
      _useStraightLines();
    }
  }

  void _useStraightLines() {
    setState(() {
      _routePoints = _waypoints.map((wp) => wp['location'] as LatLng).toList();
      _isLoadingRoute = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Use route points if available, otherwise use straight lines
    final List<LatLng> pathPoints = _routePoints.isNotEmpty
        ? _routePoints
        : _waypoints.map((wp) => wp['location'] as LatLng).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bydgoszcz Points of Interest'),
        elevation: 2,
      ),
      body: GestureDetector(
        onScaleStart: (_) {},
        onScaleUpdate: (_) {},
        onScaleEnd: (_) {},
        child: FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            initialCenter: _center,
            initialZoom: 14.0,
            minZoom: 10.0,
            maxZoom: 18.0,
            interactionOptions: const InteractionOptions(
              flags: InteractiveFlag.all,
              enableMultiFingerGestureRace: true,
            ),
          ),
          children: [
            // Tile layer (map tiles)
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.app',
            ),

            // Polyline layer (path between waypoints)
            PolylineLayer(
              polylines: [
                Polyline(
                  points: pathPoints,
                  strokeWidth: 4.0,
                  color: _isLoadingRoute
                      ? Colors.grey.withOpacity(0.5)
                      : Colors.blue.withOpacity(0.7),
                  borderStrokeWidth: 1.5,
                  borderColor: Colors.white,
                  pattern: StrokePattern.dotted(),
                ),
              ],
            ),

            // Marker layer (custom markers with images)
            MarkerLayer(
              markers: _waypoints.asMap().entries.map((entry) {
                int idx = entry.key;
                Map<String, dynamic> wp = entry.value;

                return Marker(
                  point: wp['location'] as LatLng,
                  width: 50,
                  height: 70,
                  alignment: Alignment.topCenter,
                  child: GestureDetector(
                    onTap: () {
                      _showPlaceDialog(context, wp);
                    },
                    child: Stack(
                      alignment: Alignment.topCenter,
                      clipBehavior: Clip.none,
                      children: [
                        // Pin icon as background
                        const Positioned(
                          top: 0,
                          child: Icon(
                            Icons.location_on,
                            size: 50,
                            color: Colors.blue,
                            shadows: [
                              Shadow(
                                color: Colors.black26,
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                        ),
                        // Number in the middle of pin
                        Positioned(
                          top: 8,
                          child: Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 3,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                '${idx + 1}',
                                style: const TextStyle(
                                  color: Colors.blue,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Zoom In Button
          FloatingActionButton(
            heroTag: 'zoom_in',
            mini: true,
            onPressed: () {
              final currentZoom = _mapController.camera.zoom;
              _mapController.move(
                _mapController.camera.center,
                currentZoom + 1,
              );
            },
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 8),

          // Zoom Out Button
          FloatingActionButton(
            heroTag: 'zoom_out',
            mini: true,
            onPressed: () {
              final currentZoom = _mapController.camera.zoom;
              _mapController.move(
                _mapController.camera.center,
                currentZoom - 1,
              );
            },
            child: const Icon(Icons.remove),
          ),
          const SizedBox(height: 8),

          // Recenter Button
          FloatingActionButton(
            heroTag: 'recenter',
            onPressed: () {
              _mapController.move(_center, 14.0);
            },
            child: const Icon(Icons.my_location),
          ),
        ],
      ),
    );
  }

  void _showPlaceDialog(BuildContext context, Map<String, dynamic> place) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(place['name'] as String),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                place['imageUrl'] as String,
                height: 200,
                width: 200,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 200,
                    width: 200,
                    color: Colors.grey[300],
                    child: const Icon(Icons.image, size: 50),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Location: ${(place['location'] as LatLng).latitude.toStringAsFixed(4)}, '
              '${(place['location'] as LatLng).longitude.toStringAsFixed(4)}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
