import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:namma_bengaluru_metro/components/colors.dart';
import 'package:namma_bengaluru_metro/models/marker_model.dart';
import 'package:syncfusion_flutter_maps/maps.dart';
import 'package:namma_bengaluru_metro/auth/secrets.dart';



class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final String apiKey = "3Ar8m6IHX2ZIYSxIzCA64KUBB1kGfKmn";
  bool _satellite = false;
  bool _mapDarkMode = false;

  late MarkerModel _markerData;
  final List<Feature> _pointList = [];
  final List<Feature> _lineList = [];
  final MapTileLayerController _mapTileLayerController = MapTileLayerController();
  bool _loading = false;

  Future<void> readJson() async {
    setState(() {
      _loading = true;
    });
    final String response = await rootBundle.loadString('assets/namma_metro.json');
    final data = await json.decode(response);
    setState(() {
      _markerData = MarkerModel.fromJson(data);

      for(Feature point in _markerData.features) {
        if(point.geometry.type.name == 'point') {
          _pointList.add(point);
        } else if (point.geometry.type.name == 'lineString') {
          _lineList.add(point);
        }
      }
    });

    setState(() {
      _loading = false;
    });
  }

  @override
  void initState() {
    readJson();
    super.initState();
  }

  @override
  void dispose() {
    _mapTileLayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _loading ? const Center(
        child: CircularProgressIndicator(),
      ) : SfMaps(
        layers: [
          MapTileLayer(
            controller: _mapTileLayerController,
            urlTemplate:  _satellite ? 'https://api.tomtom.com/map/1/tile/sat/main/{z}/{x}/{y}.jpg?key=$mapSecretKey'
                : _mapDarkMode ? 'https://api.tomtom.com/map/1/tile/basic/night/{z}/{x}/{y}.png?key=$mapSecretKey'
                : 'https://api.tomtom.com/map/1/tile/basic/main/{z}/{x}/{y}.png?key=$mapSecretKey',
            zoomPanBehavior: MapZoomPanBehavior(
              enableDoubleTapZooming: true,
              enableMouseWheelZooming: true,
            ),
            initialZoomLevel: 13,
            initialFocalLatLng: const MapLatLng(12.9716, 77.5946),
            initialMarkersCount: _pointList.length,
            sublayers: [
              MapPolylineLayer(
                color: AppColors.purple,
                width: 5.0,
                polylines: {
                  MapPolyline(
                    points: List<MapLatLng>.generate(_lineList[0].geometry.coordinates.length, (int ind) {
                      return MapLatLng(_lineList[0].geometry.coordinates[ind][1], _lineList[0].geometry.coordinates[ind][0]);
                    }),
                  ),
                },
              ),
              MapPolylineLayer(
                color: AppColors.purple,
                width: 5.0,
                polylines: {
                  MapPolyline(
                    points: List<MapLatLng>.generate(_lineList[2].geometry.coordinates.length, (int ind) {
                      return MapLatLng(_lineList[2].geometry.coordinates[ind][1], _lineList[2].geometry.coordinates[ind][0]);
                    }),
                  ),
                },
              ),
              MapPolylineLayer(
                color: AppColors.purple,
                width: 5.0,
                polylines: {
                  MapPolyline(
                    points: List<MapLatLng>.generate(_lineList[3].geometry.coordinates.length, (int ind) {
                      return MapLatLng(_lineList[3].geometry.coordinates[ind][1], _lineList[3].geometry.coordinates[ind][0]);
                    }),
                  ),
                },
              ),
              MapPolylineLayer(
                color: AppColors.green,
                width: 5.0,
                polylines: {
                  MapPolyline(
                    points: List<MapLatLng>.generate(_lineList[1].geometry.coordinates.length, (int ind) {
                      return MapLatLng(_lineList[1].geometry.coordinates[ind][1], _lineList[1].geometry.coordinates[ind][0]);
                    }),
                  ),
                },
              ),
              MapPolylineLayer(
                color: AppColors.green,
                width: 5.0,
                polylines: {
                  MapPolyline(
                    points: List<MapLatLng>.generate(_lineList[4].geometry.coordinates.length, (int ind) {
                      return MapLatLng(_lineList[4].geometry.coordinates[ind][1], _lineList[4].geometry.coordinates[ind][0]);
                    }),
                  ),
                },
              ),
              MapPolylineLayer(
                color: AppColors.green,
                width: 5.0,
                polylines: {
                  MapPolyline(
                    points: List<MapLatLng>.generate(_lineList[5].geometry.coordinates.length, (int ind) {
                      return MapLatLng(_lineList[5].geometry.coordinates[ind][1], _lineList[5].geometry.coordinates[ind][0]);
                    }),
                  ),
                },
              ),
              MapPolylineLayer(
                color: AppColors.yellow,
                width: 5.0,
                polylines: {
                  MapPolyline(
                    points: List<MapLatLng>.generate(_lineList[6].geometry.coordinates.length, (int ind) {
                      return MapLatLng(_lineList[6].geometry.coordinates[ind][1], _lineList[6].geometry.coordinates[ind][0]);
                    }),
                  ),
                },
              ),
              MapPolylineLayer(
                color: AppColors.pink,
                width: 5.0,
                polylines: {
                  MapPolyline(
                    points: List<MapLatLng>.generate(_lineList[7].geometry.coordinates.length, (int ind) {
                      return MapLatLng(_lineList[7].geometry.coordinates[ind][1], _lineList[7].geometry.coordinates[ind][0]);
                    }),
                  ),
                },
              ),
              MapPolylineLayer(
                color: AppColors.blue,
                width: 5.0,
                polylines: {
                  MapPolyline(
                    points: List<MapLatLng>.generate(_lineList[8].geometry.coordinates.length, (int ind) {
                      return MapLatLng(_lineList[8].geometry.coordinates[ind][1], _lineList[8].geometry.coordinates[ind][0]);
                    }),
                  ),
                },
              ),
              MapPolylineLayer(
                color: AppColors.blue,
                width: 5.0,
                polylines: {
                  MapPolyline(
                    points: List<MapLatLng>.generate(_lineList[9].geometry.coordinates.length, (int ind) {
                      return MapLatLng(_lineList[9].geometry.coordinates[ind][1], _lineList[9].geometry.coordinates[ind][0]);
                    }),
                  ),
                },
              ),
            ],
            markerBuilder: (BuildContext context, int index) {
              return MapMarker(
                latitude: _pointList[index].geometry.coordinates[1],
                longitude: _pointList[index].geometry.coordinates[0],
                size: const Size(30, 30),
                child: Tooltip(
                  message: _pointList[index].properties.name,
                  triggerMode: TooltipTriggerMode.tap,
                  child: Container(
                    height: 40.0,
                    width: 40.0,
                    decoration: _pointList[index].properties.line == 'junction' ?  BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.green,
                          AppColors.purple,
                        ],
                        begin: const FractionalOffset(0.0, 0.0),
                        end: const FractionalOffset(1.0, 0.0),
                        stops: const [0.0, 1.0],
                        tileMode: TileMode.clamp,
                      ),
                      borderRadius: BorderRadius.circular(5.0),
                    ) : BoxDecoration(
                      color: _pointList[index].properties.line == 'green' ? AppColors.green
                          : _pointList[index].properties.line == 'purple' ? AppColors.purple
                          :_pointList[index].properties.line == 'blue' ? AppColors.blue
                          : _pointList[index].properties.line == 'yellow' ? AppColors.yellow
                          : _pointList[index].properties.line == 'pink' ? AppColors.pink : Colors.transparent,
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    alignment: Alignment.center,
                    child: const Icon(Icons.train_sharp, color: Colors.white,),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
