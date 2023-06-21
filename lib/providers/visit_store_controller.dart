
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

abstract class FollowingController extends GetxController {
  follow();
}
class FollowingControllerImplement extends FollowingController{
  bool following = false;

  @override
  follow() {
    following = !following;
    update();

  }


}