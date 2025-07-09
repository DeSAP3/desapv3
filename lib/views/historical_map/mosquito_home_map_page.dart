import 'package:desapv3/viewmodels/cup_viewmodel.dart';
import 'package:desapv3/viewmodels/ovitrap_viewmodel.dart';
import 'package:desapv3/models/circle_map_data.dart';
import 'package:desapv3/models/cup.dart';
import 'package:desapv3/reuseable_widget/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_heatmap/flutter_heatmap.dart';
import 'package:flutter_map_heatmap/flutter_map_heatmap.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:latlong2/latlong.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:flutter_map_geojson/flutter_map_geojson.dart';

class MosquitoHomePage extends StatefulWidget {
  const MosquitoHomePage({super.key});

  @override
  State<MosquitoHomePage> createState() => _MosquitoHomePageState();
}

class _MosquitoHomePageState extends State<MosquitoHomePage> {
  @override
  void initState() {
    super.initState();
    _fetchCupsFuture =
        Provider.of<CupViewModel>(context, listen: false).fetchCups();
  }

  final MapController _mapControls = MapController();
  final geoJsonParser = GeoJsonParser();
  final mapDataGen = CircleMapData();

  final List<Marker> _markerList = [];

  late Future<void> _fetchCupsFuture;

  String active = "none";
  int heatMapRadius = 0;
  Logger logger = Logger();

  @override
  Widget build(BuildContext context) {
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
                    logger.d(active);
                    setState(() {
                      active = "none";
                    });
                    Future.microtask(() {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text("HeatMap Display"),
                              content: const Text(
                                  "Choose the Heat Map Display Radius"),
                              actions: [
                                TextButton(
                                  child: const Text("200m"),
                                  onPressed: () {
                                    heatMapRadius = 200;
                                    setState(() {
                                      active = "heatMap";
                                    });
                                    Navigator.of(context).pop();
                                  },
                                ),
                                TextButton(
                                  child: const Text("400m"),
                                  onPressed: () {
                                    heatMapRadius = 400;
                                    setState(() {
                                      active = "heatMap";
                                    });
                                    Navigator.of(context).pop();
                                  },
                                ),
                                TextButton(
                                  child: const Text("Cancel"),
                                  onPressed: () {
                                    setState(() {
                                      active = "none";
                                    });
                                    Navigator.of(context).pop();
                                  },
                                )
                              ],
                            );
                          });
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
                      active = active == "breedingSiteCalc"
                          ? "none"
                          : "breedingSiteCalc";
                    });
                  }),
              SpeedDialChild(
                  elevation: 0,
                  child: const Icon(
                    Icons.circle_rounded,
                    color: Colors.blue,
                  ),
                  labelWidget: const Text("Generate Outbreak Prediction"),
                  backgroundColor: Colors.white70,
                  onTap: () {
                    setState(() {
                      active = active == "genOutbreakPredict"
                          ? "none"
                          : "genOutbreakPredict";
                    });
                  }),
            ],
            child: const Icon(Icons.more, color: Colors.white)),
        body: FutureBuilder(
            future: _fetchCupsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('${snapshot.error}'));
              }

              final cupProvider = Provider.of<CupViewModel>(context);

              final cups = cupProvider.cupList
                  .where((cup) => cup.isActive == true)
                  .toList();

              List<LatLng> cupCoordinates = [];

              List<WeightedLatLng> cupLocations = [];

              late List<List<LatLng>> clusters =
                  mapDataGen.findClusters(cupCoordinates, heatMapRadius);
              late List<LatLng> centroids =
                  mapDataGen.computeCentroids(clusters);

              _markerList.clear();
              for (Cup c in cups) {
                _markerList.add(Marker(
                  width: 40,
                  height: 40,
                  point: LatLng(
                    c.gpsX!,
                    c.gpsY!,
                  ),
                  child: const Icon(
                    Icons.location_on,
                    color: Colors.red,
                    size: 25,
                  ),
                ));

                cupCoordinates.add(LatLng(c.gpsX!, c.gpsY!));
                cupLocations.add(WeightedLatLng(LatLng(c.gpsX!, c.gpsY!), 1));
              }

              final LayerHitNotifier<String> hitNotifier = ValueNotifier(null);

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
                        //Active Button, Choose Distance, Then Refresh (Change where condition I think)
                        PolygonLayer(
                          polygons: cupCoordinates
                              .where((center) => active == "heatMap")
                              .map((center) => Polygon(
                                    points: mapDataGen.generateCirclePolygon(
                                        center, heatMapRadius),
                                    color:
                                        const Color.fromARGB(147, 218, 172, 19),
                                  ))
                              .toList(),
                        ),
                        PolygonLayer(
                          polygons: centroids
                              .where(
                                  (cenCentroid) => active == "breedingSiteCalc")
                              .map((cenCentroid) => Polygon(
                                    points: mapDataGen.generateCirclePolygon(
                                        cenCentroid, heatMapRadius),
                                    color:
                                        const Color.fromARGB(190, 219, 33, 33),
                                  ))
                              .toList(),
                        ),
                        GestureDetector(
                          onTap: () {
                            final result = hitNotifier.value;
                            if (result == null || result.hitValues.isEmpty)
                              return;

                            final tappedZone = result.hitValues.first;
                            showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: const Text("Outbreak Prediction Info"),
                                content: Text(
                                    "Latitude: 1.5619\nLongtitude: 103.6363\nDate Creation: 2025-6-25\nHumidity: 74%\nMax Temp: 35 Celsuis\nMin Temp: 26 Celsuis\nPredicted Egg Count: 134\nPredicted Egg Count in next three months: 532"),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                    child: const Text("Close"),
                                  ),
                                ],
                              ),
                            );
                          },
                          child: PolygonLayer<String>(
                            hitNotifier: hitNotifier,
                            polygons: centroids
                                .where((cenCentroid) =>
                                    active == "genOutbreakPredict")
                                .map((cenCentroid) => Polygon(
                                    points: mapDataGen.generateCirclePolygon(
                                        cenCentroid, heatMapRadius),
                                    color:
                                        const Color.fromARGB(190, 219, 33, 33),
                                    hitValue:
                                        "${cenCentroid.latitude},${cenCentroid.longitude}"))
                                .toList(),
                          ),
                        ),
                      ])
                ],
              );
            }));
  }
}
