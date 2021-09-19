


import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:joke/pages/model/artist.dart';
import 'package:joke/utils/ai_utils.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:collection/collection.dart';


class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<MyRadio> radios;
  late MyRadio _selectedRadio= radios[0];
  final sColor=AIColors.primaryColor2;
  late Color _selectedColor=sColor;
  bool _isPlaying=false;
 late int s;
final AudioPlayer _audioPlayer=AudioPlayer();
@override
  void initState() {
   
    super.initState();
  
    fetchradios();
    _audioPlayer.onPlayerStateChanged.listen((event) {
      if(event==PlayerState.PLAYING){
      _isPlaying=true;}
      else{
        _isPlaying=false;
      }
setState(() {});
    });
  }


fetchradios() async{
  final radiojson = await rootBundle.loadString("radio.json");
  radios = MyRadioList.fromJson(radiojson).radios;
  
  
  setState(() {
      
    });
}
 _playmusic(String url){
   _audioPlayer.play(url);
   // ignore: unrelated_type_equality_checks
   _selectedRadio= radios.firstWhereOrNull((element) => element==url)!;
 
   setState(() {});
 }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
 
body: Stack(
  children: [
Container(
  width: context.screenWidth,
  height: context.screenHeight,
  decoration: BoxDecoration(
    gradient: LinearGradient(colors: [
      AIColors.primaryColor1,
     _selectedColor,
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,)
  ),
),
AppBar(
title: "Comedians House".text.bold.white.make().shimmer(
  primaryColor: Vx.black, secondaryColor: Vx.white,
).p1(),
centerTitle: true,
backgroundColor: Colors.transparent,
elevation: 0.0,
).h(100.0).p16(),


// ignore: unnecessary_null_comparison
radios!=null?VxSwiper.builder(
  itemCount: radios.length,
  aspectRatio: 1.0,
  autoPlay: true,
  onPageChanged: (index) {
    final color=radios[index].color;
      _selectedRadio=radios[index];
      _selectedColor=Color(int.tryParse(color)!);
    },
  itemBuilder: (context, index) {
  
final rad=radios[index];

      

      return VxBox(
        child: ZStack([
        Align(
          alignment: Alignment.bottomCenter,
          child: VStack([
            
             rad.name.text.uppercase.white.bold.make().centered(),
                
            5.heightBox,
          ]),
        ),
        Align(
          alignment: Alignment.center,
          child: [ Icon(
            CupertinoIcons.play_circle,
          color: Colors.white,
          ),
          10.heightBox,
          "Tap to Play".text.blueGray300.make(),
      
           ].vStack()
           )
       ]))
      .bgImage(DecorationImage(image: NetworkImage(rad.image),
      
      fit: BoxFit.cover,
      colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.4), BlendMode.darken)
      ))
      .withRounded(value:2000.0)
      .border(color: Colors.black, width: 5.0)
      .make()
      .onInkTap(() {
           _selectedRadio=rad;
        _playmusic(rad.url);
         print(_selectedRadio.name);
           
       
      })
      .p16();
    },
    ).centered():Center(
    child: CircularProgressIndicator(backgroundColor:Vx.white)
  
  ),

     Align(
            alignment: Alignment.bottomCenter,
            child: [
              if (_isPlaying)
                "Playing Now - ${_selectedRadio.name.toUpperCase()} Comedy"
                    .text
                    .white
                    .makeCentered(),
              Icon(
                _isPlaying
                    ? CupertinoIcons.stop_circle
                    : CupertinoIcons.play_circle,
                color: Colors.white,
                size: 50.0,
              ).onInkTap(() {
                if (_isPlaying) {
                  print(_selectedRadio);
                  _audioPlayer.stop();
                } else {/*  */
                 _playmusic(_selectedRadio.url);
                 print(_selectedRadio);
                }
              })
            ].vStack(),
  ).pOnly(bottom: context.percentHeight*12)
 
],
fit: StackFit.expand,
    )

    );
  }
}