
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

abstract class SupplierController extends GetxController {
  next(int index);
}
class SupplierControllerImplement extends SupplierController{

  int selectedIndex = 0;
  @override
  next(index) {
    selectedIndex = index;
    update();

  }


}