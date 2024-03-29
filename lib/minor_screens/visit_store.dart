import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:multi_store_app/minor_screens/edit_store.dart';
import 'package:multi_store_app/models/product_model.dart';
import 'package:multi_store_app/providers/visit_store_controller.dart';
import 'package:multi_store_app/widgets/appbar_widgets.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../on_boarding/color.dart';
import 'package:get/get.dart';
class VisitStore extends StatelessWidget {
final String suppId;

   VisitStore({Key? key, required this.suppId}) : super(key: key);

  bool following = false;

  @override
  Widget build(BuildContext context) {
    Get.put(FollowingControllerImplement());

    final Stream<QuerySnapshot> prodcutsStream = FirebaseFirestore.instance
        .collection('products')
        .where('sid', isEqualTo: suppId)
        .snapshots();
    CollectionReference suppliers =
        FirebaseFirestore.instance.collection('suppliers');

    return FutureBuilder<DocumentSnapshot>(
      future: suppliers.doc(suppId).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return const Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Material(
              child: Center(
            child: CircularProgressIndicator(),
          ));
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return Scaffold(
            backgroundColor: Colors.blueGrey.shade100,
            appBar: AppBar(
              toolbarHeight: 100,
              flexibleSpace: data['coverimage'] == ''
                  ? Image.asset(
                      'images/inapp/coverimage.jpg',
                      fit: BoxFit.cover,
                    )
                  : Image.network(
                      data['coverimage'],
                      fit: BoxFit.cover,
                    ),
              leading: const YellowBackButton(),
              title:
              GetBuilder<FollowingControllerImplement>(
                init: FollowingControllerImplement(),
                builder: (controller)=>  Row(
                  children: [
                    Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                          border: Border.all(
                            width: 4,
                            color: AppColor1.grey,
                          ),
                          borderRadius: BorderRadius.circular(15)),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(11),
                        child: Image.network(
                          data['storelogo'],
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 100,
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  data['storename'].toUpperCase(),
                                  style: const TextStyle(
                                    fontSize: 20,  color: AppColor1.black,),
                                ),
                              ),
                            ],
                          ),
                          data['sid'] == FirebaseAuth.instance.currentUser!.uid
                              ? Container(
                              height: 35,
                              width: MediaQuery.of(context).size.width * 0.3,
                              decoration: BoxDecoration(
                                  color: AppColor1.primaryColor,
                                  border: Border.all(
                                      width: 3, color: Colors.black),
                                  borderRadius: BorderRadius.circular(25)),
                              child: MaterialButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => EditStore(
                                              data: data,
                                            )));
                                  },
                                  child: const Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                    children: [
                                      Text('Edit',style: TextStyle(
                                        color: AppColor1.primaryColor,
                                      ),),
                                      Icon(
                                        Icons.edit,
                                        color: Colors.black,
                                      )
                                    ],
                                  )))
                              : Container(
                              height: 35,
                              width: MediaQuery.of(context).size.width * 0.3,
                              decoration: BoxDecoration(
                                  color: AppColor1.primaryColor,
                                  border: Border.all(
                                      width: 3, color: Colors.black),
                                  borderRadius: BorderRadius.circular(25)),
                              child: MaterialButton(
                                onPressed: () {
                                  // setState(() {
                                  //   following = !following;
                                  // });
                                  controller.follow();

                                },
                                child: controller.following==true
                                    ? const Text('following',style: TextStyle(
                                  color: AppColor1.backgroundColor,
                                ),)
                                    : const Text('FOLLOW',style: TextStyle(
                                  color: AppColor1.backgroundColor,
                                ),),
                              ))
                        ],
                      ),
                    )
                  ],
                ),
              )

            ),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: StreamBuilder<QuerySnapshot>(
                stream: prodcutsStream,
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Something went wrong');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (snapshot.data!.docs.isEmpty) {
                    return const Center(
                        child: Text(
                      'This Store \n\n has no items yet !',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 26,
                          color: Colors.blueGrey,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Acme',
                          letterSpacing: 1.5),
                    ));
                  }

                  return SingleChildScrollView(
                    child: StaggeredGridView.countBuilder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: snapshot.data!.docs.length,
                        crossAxisCount: 2,
                        itemBuilder: (context, index) {
                          return ProductModel(
                            products: snapshot.data!.docs[index],
                          );
                        },
                        staggeredTileBuilder: (context) =>
                            const StaggeredTile.fit(1)),
                  );
                },
              ),
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.green,
              child: const Icon(
                FontAwesomeIcons.whatsapp,
                color: Colors.white,
                size: 40,
              ),
              onPressed: () {},
            ),
          );
        }

        return const Text("loading");
      },
    );
  }
}
