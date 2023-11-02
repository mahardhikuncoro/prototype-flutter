/*
  @author DICKY <dicky.maulana@pitik.id>
 */

import 'package:get/get.dart';

class ExpandableController extends GetxController {

    String tag;
    ExpandableController({required this.tag});

    var expanded = false.obs;

    void expand() => expanded.value = true;
    void collapse() => expanded.value = false;
}

class ExpandableBinding extends Bindings {
    @override
    void dependencies() {
        Get.lazyPut<ExpandableController>(() => ExpandableController(tag: ""));
    }
}