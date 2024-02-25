import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:maps/custom_info_window.dart';

import '../main.dart';
import 'maps.dart';

class Second extends StatelessWidget {
  final MarkerData markerData;

  const Second({Key? key, required this.markerData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(markerData.title,style: TextStyle(
            color: Colors.white
          ),),
          backgroundColor: Colors.indigoAccent.shade200,
        ),
        body: Container(
                width: mq.width,
                // padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                   Image.asset(
                      'Assets/images/yoga.jpg', // Replace with the path to your local image asset
                      fit: BoxFit.cover, // BoxFit to cover the entire container while maintaining aspect ratio
                      alignment: Alignment.center,
                     height: mq.height*0.25,
                     width: mq.width,// Align the image to the center
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 12,left: 12),
                      child: Text(
                        'Fit India Yoga Center',
                        style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
                      ),
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 16,right: 4),
                          child: Icon(Icons.location_on,size: 16,color: Colors.black38, ),
                        ),
                         Text(
                            'UP Allahabad oposite PVR mall',
                            style: const TextStyle(fontSize: 18,color: Colors.black38, fontWeight: FontWeight.w600),
                          ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0,left: 16),
                      child: Row(
                        children: [
                          Container(color: Colors.blue.shade50,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(child: Text("Yoga",style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.blue,
                              fontSize: 14
                            ),)),
                          ),),
                          SizedBox(width: 10,),
                          Text("4.5",style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.indigoAccent
                          ),),
                          SizedBox(width: 4,),
                          Icon(Icons.star,color: Colors.indigoAccent,size: 18,),
                          SizedBox(width: 4,),
                          Text("147 reviews",style: TextStyle(
                            fontSize: 14,
                            color: Colors.black38
                          ),)
                        ],
                      ),
                    ),
                    const SizedBox(height: 25),
                    Padding(
                      padding: const EdgeInsets.only(top:8.0,left: 8),
                      child: Text(
                        'Description',
                        style: const TextStyle(fontSize: 20,fontWeight: FontWeight.w600),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 14.0,right: 10),
                      child: Text(
                        'Experience the ancient art of yoga at our serene center, Discover inner peace and physical wellness through yoga practices, from gentle asanas like Surya Namaskar, Padmasana  and Bhujangasanas to Sirsasana and Vrksasana. Join us on a journey of self-discovery and holistic well-being.',
                        style: const TextStyle(fontSize: 16,fontWeight: FontWeight.w300),
                      ),
                    ),
                    SizedBox(height: 15,),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Container(width: 50,height: 60, decoration: BoxDecoration(
                            color: Colors.indigoAccent.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(10), // Small corner radius
                          ),
                            child: Icon(Icons.person_sharp,size: 36,color: Colors.indigoAccent,),
                          ),
                          SizedBox(width: 20,),
                          Container(width: 50,height: 60, decoration: BoxDecoration(
                            color: Colors.indigoAccent.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(10), // Small corner radius
                          ),
                            child: Icon(Icons.bookmark_border,size: 34,color: Colors.indigoAccent,),
                          ),
                          SizedBox(width: 20,),
                          Container(width: 50,height: 60, decoration: BoxDecoration(
                            color: Colors.indigoAccent.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(10), // Small corner radius
                          ),
                            child: Icon(Icons.call_sharp,size: 34,color: Colors.indigoAccent,),
                          ),
                          SizedBox(width: 20,),
                          Container(width: 50,height: 60, decoration: BoxDecoration(
                            color: Colors.indigoAccent.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(10), // Small corner radius
                          ),
                            child: Icon(Icons.mail_outline,size: 36,color: Colors.indigoAccent,),
                          ),
                          SizedBox(width: 20,),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 15),
                      child: Container(
                        height: mq.height*0.055,
                        width: mq.width,
                        decoration:  BoxDecoration(
                          color: Colors.indigoAccent.withOpacity(0.85),
                          borderRadius: BorderRadius.circular(10), // Small corner radius
                        ),
                        child: Center(child: Text("Book Now",style: TextStyle(fontSize: 18,color: Colors.white)),
                      ),
                    ),
                    ),
                    const SizedBox(height: 5),
                  ],
                ),
            ),

       );
    }
}
