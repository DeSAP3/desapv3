import 'dart:math';
import 'dart:ui';

import 'package:desapv3/services/permissions_handling.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geodesy/geodesy.dart';
import 'package:logger/logger.dart';

class CircleMapData {

  Geodesy geodesy = Geodesy();
  Logger logger = Logger();

  //Generate Heatmap Circle
  List<LatLng> generateCirclePolygon(LatLng center, int radius,
      {int sides = 36}) {
    List<LatLng> points = [];

    for (int i = 0; i < sides; i++) {
      double angle = (i / sides) * 360;

      LatLng point =
          geodesy.destinationPointByDistanceAndBearing(center, radius, angle);

      points.add(point);
    }

    points.add(points.first);

    return points;
  }

  //Heatmap Overlap Detection
  List<LatLng> findMultiPolygonOverlap(List<List<LatLng>> polygons) {
    if (polygons.isEmpty) {
      logger.d(
          "Cannot compute overlap without defined heatmap area. Add waypoint through add Cup");
      return [];
    }

    // Start with the first polygon as the base overlap area
    List<LatLng> overlapRegion = List.from(polygons.first);

    for (int i = 1; i < polygons.length; i++) {
      List<LatLng> currentPolygon = polygons[i];
      List<LatLng> overlapPointList = [];

      // Keep only the points that are inside all polygons seen so far
      for (LatLng point in overlapRegion) {
        if (geodesy.isGeoPointInPolygon(point, currentPolygon)) {
          overlapPointList.add(point);
        }
      }

      for (LatLng point in currentPolygon) {
        if (geodesy.isGeoPointInPolygon(point, overlapRegion)) {
          overlapPointList.add(point);
        }
      }

      overlapRegion = overlapPointList;

      if (overlapRegion.isEmpty) {
        break;
      }
    }

    return overlapRegion;
  }

  // Check for validity of Circle Overlapping
  bool doCirclesOverlap(LatLng centerA, LatLng centerB, int radius) {
    num distance = geodesy.distanceBetweenTwoGeoPoints(centerA, centerB);
    return distance < (radius * 2); // Overlapping if distance < sum of radii
  }

  // BFS to group circles into clusters
  List<List<LatLng>> findClusters(List<LatLng> centers, int radius) {
    List<List<LatLng>> clusters = [];
    Set<LatLng> visited = {};

    for (LatLng center in centers) {
      if (visited.contains(center)) continue;

      List<LatLng> cluster = [];
      List<LatLng> queue = [center];

      while (queue.isNotEmpty) {
        LatLng current = queue.removeAt(0);
        if (visited.contains(current)) continue;

        visited.add(current);
        cluster.add(current);

        for (LatLng other in centers) {
          if (!visited.contains(other) &&
              doCirclesOverlap(current, other, radius)) {
            queue.add(other);
          }
        }
      }

      if (cluster.isNotEmpty) clusters.add(cluster);
    }

    return clusters;
  }

  // Compute Centroids for Clusters
  List<LatLng> computeCentroids(List<List<LatLng>> clusters) {
    List<LatLng> centroids = [];

    for (List<LatLng> cluster in clusters) {
      double sumLat = 0.0;
      double sumLng = 0.0;

      for (LatLng point in cluster) {
        sumLat += point.latitude;
        sumLng += point.longitude;
      }

      double centroidLat = sumLat / cluster.length;
      double centroidLng = sumLng / cluster.length;

      centroids.add(LatLng(centroidLat, centroidLng));
    }

    return centroids;
  }

  Map<String, dynamic> circleToGeoJson(List<LatLng> points) {
    return {
      "type": "Feature",
      "geometry": {
        "type": "Polygon",
        "coordinates": [
          points.map((p) => [p.longitude, p.latitude]).toList()
        ],
      },
      "properties": {} // Additional properties if needed
    };
  }
}
