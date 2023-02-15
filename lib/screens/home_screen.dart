import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:namma_bengaluru_metro/components/colors.dart';
import 'package:namma_bengaluru_metro/models/marker_model.dart';
import 'package:namma_bengaluru_metro/widgets/custom_textfield.dart';
import 'package:namma_bengaluru_metro/widgets/icon_tile.dart';
import 'package:syncfusion_flutter_maps/maps.dart';
import 'package:namma_bengaluru_metro/auth/secrets.dart';



class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  bool _satellite = false;
  bool _mapDarkMode = false;

  late MarkerModel _markerData;
  final List<Feature> _pointList = [];
  final List<Feature> _lineList = [];
  final List<Feature> _searchList = [];
  final MapTileLayerController _mapTileLayerController = MapTileLayerController();
  late MapZoomPanBehavior _zoomPanBehavior;
  final TextEditingController _searchController = TextEditingController();
  final DraggableScrollableController _draggableScrollableController = DraggableScrollableController();
  bool _loading = false;
  bool _futurePlans = false;

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
      _pointList.sort((a, b) => a.properties.line!.compareTo(b.properties.line!));
    });

    _zoomPanBehavior = MapZoomPanBehavior(
      focalLatLng: const MapLatLng(12.9716, 77.5946),
      enableDoubleTapZooming: true,
      enableMouseWheelZooming: true,
      maxZoomLevel: 20.0,
    );

    setState(() {
      _loading = false;
    });
  }

  double scrollingHeight = 0.6;

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
      ) : Stack(
        children: [
          buildSfMaps(),
          MediaQuery.of(context).size.width > 768 || MediaQuery.of(context).orientation == Orientation.landscape ? SafeArea(
            child: Container(
              width: MediaQuery.of(context).size.width / 3.5,
              margin: const EdgeInsets.fromLTRB(10.0, 10.0, 0.0, 10.0),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  buildCustomTextField(),
                  const SizedBox(height: 15.0,),
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: lineList(_searchController.text.isEmpty ? _pointList : _searchList),
                    ),
                  ),
                ],
              ),
            ),
          ) : Column(
            children: [
              Container(
                color: scrollingHeight == 1 ? AppColors.white : Colors.transparent,
                child: SafeArea(
                  child: buildCustomTextField(),
                ),
              ),
              buildDraggableScrollableSheet(),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildDraggableScrollableSheet() {
    return Expanded(
      child: NotificationListener<DraggableScrollableNotification>(
        onNotification: (notification) {
          setState(() {
            scrollingHeight = notification.extent;
          });
          return true;
        },
        child: DraggableScrollableSheet(
          initialChildSize: 0.4,
          minChildSize: 0.2,
          controller: _draggableScrollableController,
          builder: (BuildContext context, ScrollController scrollController) {
            return AnimatedContainer(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(scrollingHeight == 1 ? 0 : 30), topRight: Radius.circular(scrollingHeight == 1 ? 0 : 30)),
                color: AppColors.white,
              ),
              duration: const Duration(milliseconds: 100),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                controller: scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Visibility(
                      visible: scrollingHeight != 1,
                      child: Center(
                        child: Container(
                          height: 6.0,
                          width: 60.0,
                          margin: const EdgeInsets.only(top: 15.0),
                          decoration: BoxDecoration(
                            color: AppColors.grey,
                            borderRadius: BorderRadius.circular(100.0),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15.0,),
                    lineList(_searchController.text.isEmpty ? _pointList : _searchList),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  CustomTextField buildCustomTextField() {
    return CustomTextField(
      controller: _searchController,
      margin: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 0.0),
      onChanged: (val) {
        _searchList.clear();
        if (val.isEmpty) {
          _draggableScrollableController.animateTo(0.6, duration: const Duration(milliseconds: 300), curve: Curves.linear);
          setState(() {});
          return;
        }

        for (var pointDetails in _pointList) {
          if (pointDetails.properties.name.toLowerCase().contains(val.toLowerCase())) {
            _searchList.add(pointDetails);
          }
          _draggableScrollableController.animateTo(1.0, duration: const Duration(milliseconds: 300), curve: Curves.linear);
        }

        setState(() {});
      },
      prefixIcon: const ImageIcon(
        AssetImage('assets/logo.png'),
        size: 60,
      ),
      prefixIconColor: AppColors.purple,
      textInputAction: TextInputAction.search,
    );
  }

  SfMaps buildSfMaps() {
    return SfMaps(
      layers: [
        MapTileLayer(
          controller: _mapTileLayerController,
          urlTemplate:  _satellite ? 'https://api.tomtom.com/map/1/tile/sat/main/{z}/{x}/{y}.jpg?key=$mapSecretKey'
              : _mapDarkMode ? 'https://api.tomtom.com/map/1/tile/basic/night/{z}/{x}/{y}.png?key=$mapSecretKey'
              : 'https://api.tomtom.com/map/1/tile/basic/main/{z}/{x}/{y}.png?key=$mapSecretKey',
          zoomPanBehavior: _zoomPanBehavior,
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
                child: IconTile(station: _pointList[index]),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget lineList(List<Feature> list) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List<Widget>.generate(list.length, (index) {
        return ListTile(
          leading: IconTile(
            station: list[index],
            height: 30.0,
            width: 30.0,
          ),
          onTap: () {
            FocusScope.of(context).unfocus();
            _zoomPanBehavior.focalLatLng = MapLatLng(
                list[index].geometry.coordinates[1],
                list[index].geometry.coordinates[0]
            );
            _zoomPanBehavior.zoomLevel = 16;
            _draggableScrollableController.animateTo(0.2, duration: const Duration(milliseconds: 300), curve: Curves.linear);
          },
          title: Text(
            list[index].properties.name,
            style: const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w500,
            ),
          ),
        );
      }),
    );
  }

}
