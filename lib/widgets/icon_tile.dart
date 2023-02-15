import 'package:flutter/material.dart';
import 'package:namma_bengaluru_metro/components/colors.dart';
import 'package:namma_bengaluru_metro/models/marker_model.dart';



class IconTile extends StatefulWidget {
  final Feature station;
  final double height;
  final double width;
  const IconTile({
    Key? key,
    required this.station,
    this.height = 40.0,
    this.width = 40.0
  }) : super(key: key);

  @override
  State<IconTile> createState() => _IconTileState();
}

class _IconTileState extends State<IconTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      width: widget.width,
      decoration: widget.station.properties.line == 'junction' ?  BoxDecoration(
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
        color: widget.station.properties.line == 'green' ? AppColors.green
            : widget.station.properties.line == 'purple' ? AppColors.purple
            : widget.station.properties.line == 'blue' ? AppColors.blue
            : widget.station.properties.line == 'yellow' ? AppColors.yellow
            : widget.station.properties.line == 'pink' ? AppColors.pink : Colors.transparent,
        borderRadius: BorderRadius.circular(5.0),
      ),
      alignment: Alignment.center,
      child: const Icon(Icons.train_sharp, color: Colors.white,),
    );
  }
}
