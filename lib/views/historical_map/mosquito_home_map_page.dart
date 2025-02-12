import 'package:desapv3/controllers/data_controller.dart';
import 'package:desapv3/models/circle_map_data.dart';
import 'package:desapv3/models/cup.dart';
import 'package:desapv3/reuseable_widget/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_heatmap/flutter_heatmap.dart';
import 'package:flutter_map_heatmap/flutter_map_heatmap.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:flutter_map_geojson/flutter_map_geojson.dart';

class MosquitoHomePage extends StatefulWidget {
  const MosquitoHomePage({super.key});

  @override
  State<MosquitoHomePage> createState() => _MosquitoHomePageState();
}

class _MosquitoHomePageState extends State<MosquitoHomePage> {
  final MapController _mapControls = MapController();
  final geoJsonParser = GeoJsonParser();
  final mapDataGen = CircleMapData();

  final List<Marker> _markerList = [];

  // geoJsonParser.parseGeoJson(geoJsonData);

  String active = "none";
  int heatMapRadius = 200;

  @override
  Widget build(BuildContext context) {
    final dataProvider = Provider.of<DataController>(context, listen: false);

    Widget radius200AreaButton = TextButton(
      child: const Text("200m"),
      onPressed: () {
        heatMapRadius = 200;
        Navigator.of(context).pop();
      },
    );

    Widget radius400AreaButton = TextButton(
      child: const Text("400m"),
      onPressed: () {
        heatMapRadius = 400;
        Navigator.of(context).pop();
      },
    );

    Widget cancelButton = TextButton(
      child: const Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    AlertDialog radiusSelection = AlertDialog(
      title: const Text("HeatMap Display"),
      content: const Text("Choose the Heat Map Display Radius"),
      actions: [cancelButton, radius200AreaButton, radius400AreaButton],
    );

    return Scaffold(
        drawer: const AppDrawer(),
        appBar: AppBar(
          title: const Text("Historical Mosquito Home Map"),
        ),
        floatingActionButton: SpeedDial(
            activeIcon: Icons.close,
            iconTheme: const IconThemeData(color: Colors.white),
            buttonSize: const Size(50, 50),
            curve: Curves.bounceIn,
            children: [
              SpeedDialChild(
                  elevation: 0,
                  child: const Icon(
                    Icons.edit,
                    color: Colors.blue,
                  ),
                  labelWidget: const Text("Display HeatMap"),
                  backgroundColor: Colors.white70,
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return radiusSelection;
                        });
                    setState(() {
                      active = active == "heatMap" ? "none" : "heatMap";
                    });
                  }),
              SpeedDialChild(
                  elevation: 0,
                  child: const Icon(
                    Icons.circle_outlined,
                    color: Colors.blue,
                  ),
                  labelWidget: const Text("Display Cryptic Breeding Site"),
                  backgroundColor: Colors.white70,
                  onTap: () {
                    setState(() {
                      active = active == "breedingSiteCalc" ? "none" : "breedingSiteCalc";
                    });
                  }),
            ],
            child: const Icon(Icons.more, color: Colors.white)),
        body: FutureBuilder(
            future: dataProvider.fetchCups(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('${snapshot.error}'));
              }

              final cups = dataProvider.cupList
                  .where((cup) => cup.isActive == true)
                  .toList();

              List<LatLng> cupCoordinates = [];

              List<WeightedLatLng> cupLocations = [];

              late List<List<LatLng>> clusters =
                  mapDataGen.findClusters(cupCoordinates, heatMapRadius);
              late List<LatLng> centroids =
                  mapDataGen.computeCentroids(clusters);

              for (Cup c in cups) {
                _markerList.add(Marker(
                  width: 40,
                  height: 40,
                  point: LatLng(
                    c.gpsX!,
                    c.gpsY!,
                  ),
                  // child: IconButton(
                  //     onPressed: () {
                  //       // showDialog(
                  //       //     context: context,
                  //       //     builder: (context) => const AlertDialog());
                  //     },
                  //     icon: const Icon(
                  //       Icons.location_pin,
                  //       size: 30,
                  //       color: Colors.red,
                  //     )),
                  child: const Icon(
                    Icons.location_on,
                    color: Colors.red,
                    size: 25,
                  ),
                ));

                cupCoordinates.add(LatLng(c.gpsX!, c.gpsY!));
                cupLocations.add(WeightedLatLng(LatLng(c.gpsX!, c.gpsY!), 1));
              }

              return Stack(
                children: [
                  FlutterMap(
                      mapController: _mapControls,
                      options: const MapOptions(
                          initialCenter:
                              LatLng(1.5594066540402671, 103.6376308186403),
                          initialZoom: 16,
                          interactionOptions: InteractionOptions()),
                      children: [
                        TileLayer(
                            urlTemplate:
                                "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                            userAgentPackageName: 'com.example.app'),
                        MarkerLayer(markers: _markerList),
                        // CircleLayer(
                        //   circles:
                        //       _generateCircles(cupCoordinates, 200), //add 400m
                        // ),
                        // PolygonLayer(polygons: geoJsonParser.polygons),
                        PolygonLayer(
                          polygons: cupCoordinates
                              .where((center) =>
                                  active == "heatMap")
                              .map((center) => Polygon(
                                    points: mapDataGen.generateCirclePolygon(
                                        center, heatMapRadius),
                                    color:
                                        const Color.fromARGB(148, 218, 108, 19),
                                  ))
                              .toList(),
                        ),
                        PolygonLayer(
                          polygons: centroids
                              .where((cenCentroid) =>
                                  active == "breedingSiteCalc")
                              .map((cenCentroid) => Polygon(
                                    points: mapDataGen.generateCirclePolygon(
                                        cenCentroid, heatMapRadius),
                                    color:
                                        const Color.fromARGB(190, 219, 33, 33),
                                  ))
                              .toList(),
                        ),
                      ])
                ],
              );
            }));
  }

  // Polygon displayHeatCircle(String mode, LatLng cupCenterPoint, int radius) {
  //   if (mode == "heatMap") {
  //     return Polygon(
  //       points: mapDataGen.generateCirclePolygon(cupCenterPoint, heatMapRadius),
  //       color: const Color.fromARGB(150, 240, 243, 33),
  //     );
  //   }

  //   return Polygon(points: []);
  // }

  // List<CircleMarker> _generateCircles(
  //     List<LatLng> cupCoordinates, double radius) {
  //   return cupCoordinates.map((coordinates) {
  //     return CircleMarker(
  //         point: coordinates,
  //         radius: radius,
  //         color: const Color.fromARGB(100, 244, 10, 10));
  //   }).toList();
  // }
}
