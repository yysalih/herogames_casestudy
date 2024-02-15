import 'package:cached_network_image/cached_network_image.dart';
import 'package:casestudy/controllers/main_controller.dart';
import 'package:casestudy/controllers/user_controller.dart';
import 'package:casestudy/models/user_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

import '../utils/contants.dart';
import '../widgets/auth_text_field.dart';
import 'auth_view.dart';

class MainView extends ConsumerWidget {
  const MainView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userWatch = ref.watch(userController.notifier);
    final userState = ref.watch(userController);

    final mainController = MainController();

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;


    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Center(
                child: FutureBuilder<UserModel>(
                  future: userWatch.getCurrentUser(),
                  builder: (context, snapshot) {
                    if(!snapshot.hasData) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: height * .1),
                            child: CachedNetworkImage(imageUrl: Constants.kLogo, width: width * .5),
                          ),
                          const SizedBox(height: 30,),
                          const CircularProgressIndicator(),
                          const SizedBox(height: 30,),
                          const Text("Yükleniyor...", style: TextStyle(
                              fontSize: 20
                          ),)
                        ],
                      );
                    }
                    else {
                      UserModel userModel = snapshot.data!;
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [

                          Padding(
                            padding: EdgeInsets.only(top: height * .1),
                            child: CachedNetworkImage(imageUrl: Constants.kLogo, width: width * .5),
                          ),
                          const SizedBox(height: 30),
                          Card(
                            color: Colors.deepOrange.shade400,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Ad - Soyad:\n${userModel.name}", style: const TextStyle(
                                    color: Colors.white, fontSize: 17.5
                                  ),),
                                  const SizedBox(height: 20,),
                                  Text("Email:\n${userModel.email}", style: const TextStyle(
                                      color: Colors.white, fontSize: 17.5
                                  ),),
                                  const SizedBox(height: 20,),
                                  Text("Doğum Tarihi:\n${userModel.birthdate}", style: const TextStyle(
                                      color: Colors.white, fontSize: 17.5
                                  ),),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),

                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: width * .1),
                            child: CustomTextField(
                              onChanged: (value) {

                              },
                              isObscure: false,
                              isHobby: true,
                              hintText: "Hobi Ekle",
                              prefixIcon: Icons.favorite,
                              isDate: false,
                              controller: userWatch.addHobbyController,
                              validator: null
                            ),
                          ),
                          const SizedBox(height: 30,),
                          userModel.hobbies!.length == 0 ? Container() : const Text("Hobiler", style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20
                          ),),
                          const SizedBox(height: 10,),

                          ConstrainedBox(
                            constraints: BoxConstraints(maxWidth: width,maxHeight: height),
                            child: GridView.builder(
                              padding: const EdgeInsets.all(10),
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(

                                crossAxisCount: 3, crossAxisSpacing: 10,
                                mainAxisSpacing: 10, childAspectRatio: 3,
                              ),
                              itemCount: userModel.hobbies!.length,
                              itemBuilder: (context, index) => Container(
                                  height: 10,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    boxShadow: [BoxShadow(color: Colors.deepOrange.shade100,
                                        blurRadius: .75, spreadRadius: .75)],
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: MaterialButton(
                                      height: 10,
                                      onPressed: () async {
                                        userWatch.getData();
                                        userWatch.removeHobby(userModel.hobbies![index]);
                                      },
                                      child: Text(userModel.hobbies![index], textAlign: TextAlign.center, maxLines: 1),
                                    ),
                                  )
                              ),
                            ),
                          ),

                        ],
                      );
                    }
                  }
                ),
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                child: const Text("Çıkış Yap",),
                onPressed: () async {
                  await userWatch.logout(context);
                  Navigator.pushAndRemoveUntil(context, mainController.routeToGivenScreen(AuthView()), (route) => false);
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
