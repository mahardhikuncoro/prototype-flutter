import 'package:eksternal_app/engine/util/global_var.dart';
import 'package:flutter/cupertino.dart';

/**
 *@author Robertus Mahardhi Kuncoro
 *@email <robert.kuncoro@pitik.id>
 *@create date 07/07/23
 */


class FloorStatus extends StatelessWidget{
    const FloorStatus({super.key, required this.floorStatus});

    final String? floorStatus;

    @override
    Widget build(BuildContext context) {
        return Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            decoration: BoxDecoration(
                color: floorStatus == null ? GlobalVar.gray :
                floorStatus == "active" ? Color(0xFFCEFCD8) :
                Color(0xFFF0F0F0),
                borderRadius: BorderRadius.circular(6)
            ),
            child: Center(
                child: Text(
                    floorStatus == null ? "Non-Aktif" :
                    floorStatus == "active" ? "Aktif" :
                    "Non-Aktif",
                    style: floorStatus == null ? GlobalVar.blackTextStyle :
                    floorStatus == "active" ? TextStyle(color: Color(0xFF14CB82)) :
                    TextStyle(color: Color(0xFF2C2B2B))
                )
            ),
        );
    }
}