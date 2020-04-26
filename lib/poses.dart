import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:quarantineyoga/inference.dart';
import 'package:quarantineyoga/yoga_card.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class Poses extends StatefulWidget {
  final List<CameraDescription> cameras;
  final String title;
  final String model;
  final List<String> asanas;
  final Color color;

  const Poses({this.cameras, this.title, this.model, this.asanas, this.color});

  @override
  _PosesState createState() => _PosesState();
}

class _PosesState extends State<Poses> {
  static bool firstRun = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (true) {
        Alert(
          context: context,
          type: AlertType.success,
          title: "Good Job!",
          desc: "Are you ready for \nYoga Exercises?\nLet's do it!",
          buttons: [
            DialogButton(
              child: Text(
                "Okay!",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () => Navigator.pop(context),
              width: 120,
            )
          ],
        ).show();
      }

      firstRun = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    //showAlertDialog(context);
    return Scaffold(
      backgroundColor: Colors.amberAccent[300],
      appBar: AppBar(
        backgroundColor: Colors.amberAccent[300],
        centerTitle: true,
        title: Text(widget.title),
      ),
      body: Center(
        child: Container(
          height: 500,
          child: Swiper(
            itemCount: widget.asanas.length,
            loop: false,
            viewportFraction: 0.8,
            scale: 0.82,
            outer: true,
            pagination: SwiperPagination(
              alignment: Alignment.bottomCenter,
              margin: EdgeInsets.all(32.0),
            ),
            onTap: (index) => _onSelect(context, widget.asanas[index]),
            itemBuilder: (BuildContext context, int index) {
              return Center(
                child: Container(
                  height: 360,
                  child: YogaCard(
                    asana: widget.asanas[index],
                    color: widget.color,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _onSelect(BuildContext context, String customModelName) async {
    firstRun = true;
    setState(() {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => InferencePage(
            cameras: widget.cameras,
            title: customModelName,
            model:
                "assets/models/posenet_mv1_075_float_from_checkpoints.tflite",
            customModel: customModelName,
          ),
        ),
      );
    });
  }


}
