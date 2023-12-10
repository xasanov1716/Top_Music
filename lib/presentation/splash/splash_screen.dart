import 'package:flutter/material.dart';
import 'package:top_music/presentation/app_routes.dart';
import 'package:top_music/utils/images.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin{
  late AnimationController animationController;
  late Animation animation;

  _init()async{
    await Future.delayed(const Duration(seconds: 3));
    if(context.mounted){
    Navigator.pushReplacementNamed(context, RouteNames.musicList);
    }
    animationController.dispose();
  }

  @override
  void initState() {
    animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 3));
    animation = Tween(begin: 200.w, end: 150.w).animate(animationController);
    animationController.addListener(() {
      setState(() {});
    });
    animationController.repeat(reverse: true);
    _init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(AppImages.logo,width: animation.value,),
            ],
          ),
        ),
      ),
    );
  }
}
