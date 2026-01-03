import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../theme/app_theme.dart';

class MapWidget extends StatelessWidget {
  final LatLng center;
  final double zoom;
  final List<Marker>? markers;
  final List<Polyline>? polylines;
  final double height;
  final bool showControls;

  const MapWidget({
    super.key,
    required this.center,
    this.zoom = 13.0,
    this.markers,
    this.polylines,
    this.height = 300,
    this.showControls = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: FlutterMap(
          options: MapOptions(
            initialCenter: center,
            initialZoom: zoom,
            minZoom: 5,
            maxZoom: 18,
            interactionOptions: const InteractionOptions(
              flags: InteractiveFlag.all,
            ),
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.routeopt.app',
              maxZoom: 19,
              tileBuilder: (context, tileWidget, tile) {
                return ColorFiltered(
                  colorFilter: ColorFilter.mode(
                    Colors.white.withOpacity(0.05),
                    BlendMode.lighten,
                  ),
                  child: tileWidget,
                );
              },
            ),
            if (polylines != null && polylines!.isNotEmpty)
              PolylineLayer(
                polylines: polylines!,
              ),
            if (markers != null && markers!.isNotEmpty)
              MarkerLayer(
                markers: markers!,
              ),
            if (showControls)
              Positioned(
                right: 10,
                top: 10,
                child: Column(
                  children: [
                    _MapButton(
                      icon: Icons.add,
                      onPressed: () {
                        // Zoom in handled by map controls
                      },
                    ),
                    const SizedBox(height: 8),
                    _MapButton(
                      icon: Icons.remove,
                      onPressed: () {
                        // Zoom out handled by map controls
                      },
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _MapButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _MapButton({
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(icon, size: 20, color: AppTheme.primaryOrange),
        onPressed: onPressed,
        padding: const EdgeInsets.all(8),
        constraints: const BoxConstraints(
          minWidth: 36,
          minHeight: 36,
        ),
      ),
    );
  }
}

// Helper function to create route polyline
Polyline createRoutePolyline({
  required List<LatLng> points,
  Color? color,
  double strokeWidth = 4.0,
}) {
  return Polyline(
    points: points,
    color: color ?? AppTheme.primaryOrange,
    strokeWidth: strokeWidth,
    borderStrokeWidth: strokeWidth + 2,
    borderColor: Colors.white,
  );
}

// Helper function to create custom markers
Marker createCustomMarker({
  required LatLng point,
  required Widget child,
  double width = 40,
  double height = 40,
}) {
  return Marker(
    point: point,
    width: width,
    height: height,
    child: child,
  );
}

// Predefined marker widgets
Widget pickupMarker() {
  return Container(
    decoration: BoxDecoration(
      color: AppTheme.ecoGreen,
      shape: BoxShape.circle,
      border: Border.all(color: Colors.white, width: 3),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.2),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: const Icon(
      Icons.trip_origin,
      color: Colors.white,
      size: 20,
    ),
  );
}

Widget dropoffMarker() {
  return Container(
    decoration: BoxDecoration(
      color: AppTheme.error,
      shape: BoxShape.circle,
      border: Border.all(color: Colors.white, width: 3),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.2),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: const Icon(
      Icons.location_on,
      color: Colors.white,
      size: 24,
    ),
  );
}

Widget driverMarker({String? label}) {
  return Stack(
    clipBehavior: Clip.none,
    children: [
      Container(
        decoration: BoxDecoration(
          color: AppTheme.primaryOrange,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 3),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: const Icon(
          Icons.directions_car,
          color: Colors.white,
          size: 20,
        ),
      ),
      if (label != null)
        Positioned(
          top: -25,
          left: -10,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                ),
              ],
            ),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: AppTheme.darkGray,
              ),
            ),
          ),
        ),
    ],
  );
}
