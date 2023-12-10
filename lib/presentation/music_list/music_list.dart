import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:top_music/presentation/app_routes.dart';
import 'package:top_music/utils/colors.dart';
import 'package:top_music/utils/constants.dart';
import 'package:top_music/utils/extension.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class MusicList extends StatefulWidget {
  const MusicList({super.key});

  @override
  State<MusicList> createState() => _MusicListState();
}

class _MusicListState extends State<MusicList> {
  List<String> musics=appMusics;
  List<String> images=appImages;
  List<String> names=appNames;
  List<String> musicName=appMusicName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.c_091227,
      appBar: AppBar(
        backgroundColor: AppColors.c_091227,
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarColor: AppColors.c_091227),
        title: Text(
          "Music List",
          style: Theme.of(context)
              .textTheme
              .headlineSmall!
              .copyWith(fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 6.w),
        child: Column(
          children: [
            Expanded(
              child: GridView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: musics.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.7,
                ),
                itemBuilder: (context, index) {
                  return ZoomTapAnimation(
                    onTap: () {
                      Navigator.pushNamed(context, RouteNames.musicPlayer,
                          arguments: {
                            "music": musics,
                            "image": images,
                            "name": names,
                            "musicName": musicName,
                            "index":index
                          });
                    },
                    child: Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 6.w, vertical: 10.h),
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10.r),
                            child: Image.asset(
                              images[index],
                              height: 160.h,
                              fit: BoxFit.cover,
                            ),
                          ),
                          12.ph,
                          Text(
                            musicName[index],
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(color: AppColors.c_EAF0FF),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          6.ph,
                          Text(
                            names[index],
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium!
                                .copyWith(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
