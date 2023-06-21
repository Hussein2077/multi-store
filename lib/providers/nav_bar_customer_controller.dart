
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

abstract class CustomerController extends GetxController {
  next(int index);
}
class CustomerControllerImplement extends CustomerController{

  int selectedIndex = 0;
  @override
  next(index) {
    selectedIndex = index;
    update();

  }


}