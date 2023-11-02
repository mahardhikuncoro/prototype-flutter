import 'package:eksternal_app/engine/model/device_model.dart';
import 'package:eksternal_app/engine/util/global_var.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';

/**
 *@author Robertus Mahardhi Kuncoro
 *@email <robert.kuncoro@pitik.id>
 *@create date 14/07/23
 */

class CardListSmartCamera extends StatelessWidget{
    const CardListSmartCamera({super.key, required this.device, required this.imagesPath, required this.onTap, });

    final Device? device;
    final String? imagesPath;
    final Function() onTap;

    @override
    Widget build(BuildContext context) {
        return GestureDetector(onTap: onTap,
        child:
        Container(
            margin: EdgeInsets.only(top: 16 ),
            padding: EdgeInsets.all(12),
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
                                Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                        color:GlobalVar.iconHomeBg,
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(4),
                                            topRight: Radius.circular(4),
                                            bottomRight: Radius.circular(4),
                                            bottomLeft: Radius.circular(4))),
                                    child: Center(
                                        child: SvgPicture.asset(imagesPath!),
                                    ),
                                ),
                                Expanded(
                                    child: Container(
                                        margin: EdgeInsets.only(left: 12),
                                        child:  Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                                Text(
                                                    "${device!.deviceName!}",
                                                    style: GlobalVar.blackTextStyle
                                                        .copyWith(fontWeight: GlobalVar.medium, fontSize: 17, overflow: TextOverflow.clip),
                                                ),
                                                Container(
                                                    margin: EdgeInsets.only(top: 6),
                                                    child:
                                                    Row(
                                                        children: [
                                                            Text(
                                                                "Total Kamera : ",
                                                                style: GlobalVar.greyTextStyle.copyWith(fontWeight: GlobalVar.medium, fontSize: 10),),
                                                            Text(
                                                                "${device!.sensorCount!}",
                                                                style: GlobalVar.blackTextStyle.copyWith(fontWeight: GlobalVar.medium, fontSize: 10),)


                                                        ],)
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