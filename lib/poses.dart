import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:yoga_guru/inference.dart';
import 'package:yoga_guru/yoga_card.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class StatefulWrapper extends StatefulWidget {
  final Function onInit;
  final Widget child;
  const StatefulWrapper({@required this.onInit, @required this.child});
  @override
  _StatefulWrapperState createState() => _StatefulWrapperState();
}

class _StatefulWrapperState extends State<StatefulWrapper> {
  @override
  void initState() {
    if (widget.onInit != null) {
      widget.onInit();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

class Poses extends StatelessWidget {
  final List<CameraDescription> cameras;
  final String title;
  final String model;
  final List<String> asanas;
  final Color color;
  static bool firstRun = false;

  const Poses({this.cameras, this.title, this.model, this.asanas, this.color});

  showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {},
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("My title"),
      content: Text("This is my message."),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    //showAlertDialog(context);
    return StatefulWrapper(
        onInit: () {
          _getThingsOnStartup().then((value) {
            if (firstRun) {
              Alert(
                context: context,
                type: AlertType.success,
                title: "Good Job!",
                desc: "You Have finished \nYoga Exercise!\nLet's do More!",
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
            else{
              firstRun = true;
            }
          });
        },
        child: Container(
          child: Scaffold(
            backgroundColor: Colors.amberAccent[300],
            appBar: AppBar(
              backgroundColor: Colors.amberAccent[300],
              centerTitle: true,
              title: Text(title),
            ),
            body: Center(
              child: Container(
                height: 500,
                child: Swiper(
                  itemCount: asanas.length,
                  loop: false,
                  viewportFraction: 0.8,
                  scale: 0.82,
                  outer: true,
                  pagination: SwiperPagination(
                    alignment: Alignment.bottomCenter,
                    margin: EdgeInsets.all(32.0),
                  ),
                  onTap: (index) => _onSelect(context, asanas[index]),
                  itemBuilder: (BuildContext context, int index) {
                    return Center(
                      child: Container(
                        height: 360,
                        child: YogaCard(
                          asana: asanas[index],
                          color: color,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ));
  }

  void _onSelect(BuildContext context, String customModelName) async {
    firstRun = true;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InferencePage(
          cameras: cameras,
          title: customModelName,
          model: "assets/models/posenet_mv1_075_float_from_checkpoints.tflite",
          customModel: customModelName,
        ),
      ),
    );
  }

  Future _getThingsOnStartup() async {
    await Future.delayed(Duration(seconds: 1));
  }
}
