import 'package:flutter/cupertino.dart';
import 'package:lottie/lottie.dart';

/**
 *@author Robertus Mahardhi Kuncoro
 *@email <robert.kuncoro@pitik.id>
 *@create date 06/07/23
 */

class ProgressLoading extends StatelessWidget {
    const ProgressLoading({super.key, this.height = 124, this.width = 124});
    final double height;
    final double width;
    @override
    Widget build(BuildContext context) {
        return Lottie.asset(
            'images/loading.json',
            width: width,
            height: height,
            fit: BoxFit.cover,
        );
    }
}
