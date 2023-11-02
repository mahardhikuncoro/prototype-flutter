import 'package:eksternal_app/engine/model/record_model.dart';
import 'package:eksternal_app/engine/util/global_var.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';

/**
 *@author Robertus Mahardhi Kuncoro
 *@email <robert.kuncoro@pitik.id>
 *@create date 18/08/23
 */

class ItemDetailSmartCamera extends StatelessWidget{
    const ItemDetailSmartCamera({super.key, required this.camera, required this.onTap, this.indeksCamera = 0 });

    final RecordCamera? camera;
    final Function() onTap;
    final int? indeksCamera ;

    @override
    Widget build(BuildContext context) {
        return GestureDetector(onTap: onTap,
        child:
        Container(
            margin: EdgeInsets.only(top: 16 ),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
                border: Border.all(width: 1, color: GlobalVar.outlineColor),
                borderRadius: BorderRadius.circular(8)),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    Expanded(
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                                Expanded(
                                    child: Container(
                                        child:  Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                                Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                        Text("Kamera ${indeksCamera!+1}",
                                                            style: GlobalVar.blackTextStyle
                                                                .copyWith(fontWeight: GlobalVar.medium, fontSize: 16, overflow: TextOverflow.clip),
                                                        ),
                                                        SvgPicture.asset("images/arrow_right_enable_icon.svg", fit: BoxFit.cover, width: 24, height: 24),

                                                    ],
                                                ),
                                                Text("${camera!.sensor!.room!.building!.name!} - ${camera!.sensor!.room!.roomType!.name!}",
                                                    style: GlobalVar.greyTextStyle.copyWith(fontWeight: GlobalVar.medium, fontSize: 12),),
                                                SizedBox(height: 16,),
                                                Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                        Expanded(
                                                          child: Text(
                                                              "Lantai",
                                                              style: GlobalVar.greyTextStyle.copyWith(fontWeight: GlobalVar.medium, fontSize: 12, overflow: TextOverflow.clip,),),
                                                        ),
                                                        Expanded(
                                                          child: Text(
                                                              camera!.sensor!.room!.roomType!.name!,
                                                              textAlign: TextAlign.end,
                                                              style: GlobalVar.blackTextStyle.copyWith(fontWeight: GlobalVar.medium, fontSize: 12, overflow: TextOverflow.clip),),
                                                        )
                                                    ],
                                                ),
                                                SizedBox(height: 8,),
                                                Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                        Expanded(
                                                            child: Text(
                                                                "Total Gambar",
                                                                style: GlobalVar.greyTextStyle.copyWith(fontWeight: GlobalVar.medium, fontSize: 12, overflow: TextOverflow.clip,),),
                                                        ),
                                                        Expanded(
                                                            child: Text("${camera!.recordCount}",
                                                                textAlign: TextAlign.end,
                                                                style: GlobalVar.blackTextStyle.copyWith(fontWeight: GlobalVar.medium, fontSize: 12, overflow: TextOverflow.clip),),
                                                        )
                                                    ],
                                                )
                                            ],
                                        )
                                    )
                                )
                            ],
                        ))
                ],
            ),
        )
        );



    }
}