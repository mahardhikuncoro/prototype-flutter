import 'base_model.dart';

/**
 *@author Robertus Mahardhi Kuncoro
 *@email <robert.kuncoro@pitik.id>
 *@create date 10/08/23
 */


@SetupModel
class GraphLine {

    int order;
    double? current;
    String? label;
    double? benchmarkMin;
    double? benchmarkMax;

    GraphLine({this.order = 0, this.current, this.label, this.benchmarkMin, this.benchmarkMax});

    static GraphLine toResponseModel(Map<String, dynamic> map) {

        if(map['order'] == null) {
            map['order'] = 0;
        }
        if(map['current'] is int) {
            map['current'] = map['current'].toDouble();
        }
        if(map['benchmarkMin'] is int) {
            map['benchmarkMin'] = map['benchmarkMin'].toDouble();
        }
        if(map['benchmarkMax'] is int) {
            map['benchmarkMax'] = map['benchmarkMax'].toDouble();
        }

        return GraphLine(
            order: map['order'],
            current: map['current'],
            label: map['label'],
            benchmarkMin: map['benchmarkMin'],
            benchmarkMax: map['benchmarkMax']
        );
    }
}