import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import '../main.dart';
import 'marker_info.dart';

class MarkerData {
  final String title;
  final String number;
  final String email;

  MarkerData({
    required this.title,
    required this.number,
    required this.email,
  });
}

class Map_search extends StatefulWidget {
  const Map_search({Key? key}) : super(key: key);

  @override
  State<Map_search> createState() => _Map_searchState();
}

class _Map_searchState extends State<Map_search> {

  bool _issearching = false;

  final Completer<GoogleMapController> _controller = Completer();
  LatLng? currentLocation;
  CameraPosition _kGooglePlex = const CameraPosition(
    target: LatLng(28.6289206, 77.2065322),
    zoom: 14.4746,
  );
  final List<Marker> _markers = [];
  final List<LatLng> _markerLatLngs = [
    const LatLng(25.4290, 81.7713),
    const LatLng(25.4370, 81.7589),
    const LatLng(25.4251, 81.7749),
    const LatLng(25.4363, 81.7623)
  ];

  final List<MarkerData> _markerData = [
    MarkerData(
        title: 'Swimming pool', number: '123456789', email: 'example1@example.com'),
    MarkerData(
        title: 'Fit India Yoga Center', number: '987654321', email: 'example2@example.com'),
    MarkerData(
        title: 'Sports Academy', number: '977654321', email: 'example3@example.com'),
    MarkerData(
        title: 'Dance', number: '967654321', email: 'example4@example.com'),
  ];

  Future<void> getCurrentLocation() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    locationData = await location.getLocation();

    setState(() {
      currentLocation = LatLng(locationData.latitude!, locationData.longitude!);
    });

    _kGooglePlex = CameraPosition(
      target: currentLocation!,
      zoom: 14.4746,
    );

    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kGooglePlex));
  }

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
    loadData();
  }

  void loadData() {
    for (int i = 0; i < _markerLatLngs.length; i++) {
      final markerData = _markerData[i];
      _markers.add(
        Marker(
          markerId: MarkerId(i.toString()),
          position: _markerLatLngs[i],
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Second(markerData: markerData)),
            );
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
      AppBar(
        backgroundColor: Colors.indigoAccent.shade200,
        automaticallyImplyLeading: false,
        flexibleSpace: SafeArea(child: InkWell(
            onTap: (){},
            child: Container(
                height: 100,
                width: mq.width,
                color: Colors.indigoAccent.shade200,
                child: Row(
                    children: [
                      SizedBox(width: mq.width*0.04,),
                      SvgPicture.asset("Assets/images/icon.svg",width: 35,height: 35,),
                      SizedBox(width: mq.width*0.05,),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Container(
                          width: _issearching == true ? mq.width * 0.7 : mq.width*0.6 ,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          child:TextField(
                            textAlignVertical: TextAlignVertical.center,
                            onTap: (){
                              setState(() {
                                if(_issearching){
                                  FocusScope.of(context).unfocus();
                                }
                                _issearching = !_issearching;
                              });
                            },
                            cursorColor: Colors.indigoAccent,
                            decoration: InputDecoration(
                              hintText: 'Search',
                              suffixIcon: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: CircleAvatar(
                                  backgroundColor: _issearching ? Colors.black : Colors.grey.shade300,
                                  radius: 20, // Adjust the radius as needed
                                  child: Icon(
                                    Icons.search,
                                    color: _issearching == true ?Colors.white : Colors.black54,
                                    size: 20,
                                  ),
                                ),
                              ),
                              contentPadding: EdgeInsets.only(left: 16.0), // Adjust the padding as needed
                              hintStyle: TextStyle(
                                  color: Colors.indigoAccent
                              ),
                              border: InputBorder.none,
                              // icon: Icon(Icons.search_rounded, color: Colors.indigoAccent),
                            ),
                          ) ,
                        ),
                      ),
                    ]))
        )),
      ),
      // AppBar(
      //   title: const Text('Welcome to Atadu ',style: TextStyle(color: Colors.white,fontWeight: FontWeight.normal),),
      //   backgroundColor: Colors.indigoAccent,
      // ),
      body: GestureDetector(
            onTap:  () => FocusScope.of(context).unfocus(),
        child: WillPopScope(
          onWillPop:(){
            if(_issearching){
              setState(() {
                _issearching = false;
              });
              return Future.value(false);
            }else{
              return Future.value(true);
            }
          },
          child: Stack(
            children: [
              GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition: _kGooglePlex,
                markers: Set<Marker>.of(_markers),
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
                myLocationButtonEnabled: true,
                myLocationEnabled: true,
              ),
              // Positioned(
              //   top: 16.0,
              //   left: 16.0,
              //   right: 16.0,
              //   child: Container(
              //     decoration: BoxDecoration(
              //       border: Border.all(),
              //       color: Colors.white,
              //       borderRadius: BorderRadius.circular(8.0),
              //     ),
              //     child: Padding(
              //       padding: EdgeInsets.symmetric(horizontal: 16.0),
              //       child: TextField(
              //         onTap: (){
              //           setState(() {
              //             _issearching = !_issearching;
              //           });
              //         },
              //         cursorColor: Colors.indigoAccent,
              //         decoration: InputDecoration(
              //           hintText: 'Search...',
              //           hintStyle: TextStyle(
              //             color: Colors.indigoAccent
              //           ),
              //           border: InputBorder.none,
              //           icon: Icon(Icons.search_rounded, color: Colors.indigoAccent),
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

// Widget _appbar(bool _issearching){
//
//   return InkWell(
//     onTap: (){},
//     child: Container(
//       height: 100,
//       width: mq.width,
//       color: Colors.indigoAccent.shade200,
//       child: Row(
//         children: [
//           SizedBox(width: mq.width*0.04,),
//           SvgPicture.asset("Assets/images/icon.svg",width: 35,height: 35,),
//           // ClipRRect(
//           //   borderRadius: BorderRadius.circular(8),
//           //   child: CachedNetworkImage(
//           //     width: mq.height*0.05,
//           //     height: mq.height*0.05,
//           //     imageUrl: widget.user.image!,
//           //     // placeholder: (context, url) => CircularProgressIndicator(),
//           //     errorWidget: (context, url, error) =>  const CircleAvatar(
//           //       backgroundColor: Colors.teal,
//           //       child: Icon(CupertinoIcons.person,color: Colors.white,),
//           //     ),
//           //   ),
//           // ),
//           SizedBox(width: mq.width*0.05,),
//        Padding(
//          padding: const EdgeInsets.all(4.0),
//          child: Container(
//           width: mq.width * 0.6,
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(25.0),
//           ),
//            child:TextField(
//              onTap: (){
//                setState(() {
//                  _issearching = !_issearching;
//                });
//              },
//              cursorColor: Colors.indigoAccent,
//              decoration: InputDecoration(
//                hintText: 'Search...',
//                hintStyle: TextStyle(
//                    color: Colors.indigoAccent
//                ),
//                border: InputBorder.none,
//                icon: Icon(Icons.search_rounded, color: Colors.indigoAccent),
//              ),
//            ) ,
//       ),
//        ),
//     ]))
//   );
// }

void main() {
  runApp(const MaterialApp(
    home: Map_search(),
  ));
}
