import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:top_music/utils/colors.dart';
import 'package:top_music/utils/extension.dart';
import 'package:top_music/utils/icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class MusicPlayerScreen extends StatefulWidget {
  const MusicPlayerScreen(
      {super.key,
      required this.musicName,
      required this.name,
      required this.music,
      required this.image,
      required this.index});

  final List<String> musicName;
  final List<String> name;
  final List<String> music;
  final List<String> image;
  final int index;

  @override
  State<MusicPlayerScreen> createState() => _MusicPlayerScreenState();
}

class _MusicPlayerScreenState extends State<MusicPlayerScreen> {
  bool isPlaying = false;
  bool isVolumeOn = true;
  bool isRepeat = true;
  late int index;
  late AudioPlayer player;

  Duration duration = Duration.zero;
  Duration currentDuration = Duration.zero;
  late String songUrl;

  _init() async {
    isPlaying = false;
    player = AudioPlayer();
    duration = Duration.zero;
    currentDuration = Duration.zero;
    songUrl = widget.music[index];
    if (songUrl.isNotEmpty) await player.setSourceAsset(songUrl);
    player.onDurationChanged.listen((Duration d) {
      setState(() {
        duration = d;
      });
    });
    player.onPositionChanged.listen((Duration d) {
      currentDuration = d;
      setState(() {});
      // print("DURATION: ${d.inSeconds}");
    });
  }

  _completed()async{
    player.onPlayerComplete.listen((event) {
      if(isRepeat){
        setState(() {
          isPlaying = true;
          player.play(AssetSource(songUrl));
          currentDuration = Duration.zero;
        });
      }else{
        setState(() {
          index+=1;
          _init();
          isPlaying=true;
          player.play(AssetSource(songUrl));
        });
      }
      // print("SONG COMPLETED");
    });
  }

  @override
  void initState() {
    index = widget.index;
    _init();
    _completed();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
            onPressed: () {
              player.dispose();
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back)),
        title: Text(
          "Playing Now",
          style: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
      ),
      body: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              50.ph,
              ClipRRect(
                borderRadius: BorderRadius.circular(10.r),
                child: Image.asset(
                  widget.image[index],
                  width: 261.w,
                  height: 261.h,
                  fit: BoxFit.cover,
                ),
              ),
              28.ph,
              Text(
                widget.musicName[index],
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              6.ph,
              Text(
                widget.name[index],
                style: TextStyle(fontWeight: FontWeight.w500,
                    color: AppColors.passiveTextColor,
                    fontSize: 18.sp,fontFamily: "Gilroy"),
              ),
              36.ph,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 6.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 24.w,
                      height: 24.w,
                      child: ZoomTapAnimation(
                        onTap: () {
                          setState(() {
                            isVolumeOn = !isVolumeOn;
                            if(isVolumeOn){
                              player.setVolume(1);
                            }else{
                              player.setVolume(0);
                            }
                          });
                        },
                        child: isVolumeOn
                            ? SvgPicture.asset(AppIcons.volume)
                            : Icon(
                                Icons.volume_off_outlined,
                                size: 24.sp,
                                color: AppColors.c_8996B8,
                              ),
                      ),
                    ),
                    ZoomTapAnimation(
                      onTap: () {
                        setState(() {
                          isRepeat = !isRepeat;
                        });
                      },
                      child: SvgPicture.asset(
                          isRepeat ? AppIcons.repeat : AppIcons.outline),
                    ),
                  ],
                ),
              ),
              60.ph,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${currentDuration.inSeconds ~/ 60}:${currentDuration.inSeconds % 60}",
                    style: TextStyle(fontSize: 14.sp,fontWeight: FontWeight.w400,
                        color: AppColors.passiveTextColor,fontFamily: "Gilroy"),
                  ),
                  Text(
                    "${duration.inSeconds ~/ 60}:${duration.inSeconds % 60}",
                    style: TextStyle(fontSize: 14.sp,fontWeight: FontWeight.w400,
                        color: AppColors.passiveTextColor,fontFamily: "Gilroy"),
                  )
                ],
              ),
              20.ph,
              Slider(
                activeColor: AppColors.white,
                inactiveColor: AppColors.passive,
                value: currentDuration.inSeconds.toDouble(),
                max: duration.inSeconds.toDouble(),
                // max: duration.inSeconds.toDouble(),
                // divisions: 100,
                //label: _currentSliderValue.round().toString(),
                onChanged: (double value) async {
                  // print(value);
                  await player.seek(Duration(seconds: value.toInt()));
                  setState(() {});
                },
              ),
              18.ph,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ZoomTapAnimation(
                      onTap: () {
                        setState(() {
                          if (index != 0) {
                            index -= 1;
                            player.stop();
                            _init();
                          }
                        });
                      },
                      child: SvgPicture.asset(AppIcons.back)),
                  36.pw,
                  SizedBox(
                    width: 38.w,
                    child: ZoomTapAnimation(
                        onTap: () {
                          setState(() {
                            if (!isPlaying) {
                              player.play(AssetSource(songUrl));
                            } else {
                              player.pause();
                            }
                            isPlaying = !isPlaying;
                          });
                        },
                        child: isPlaying
                            ? SvgPicture.asset(AppIcons.pause)
                            : Icon(
                                Icons.play_arrow,
                                size: 44.sp,
                                color: AppColors.white,
                              )),
                  ),
                  36.pw,
                  ZoomTapAnimation(
                      onTap: () {
                        setState(() {
                          if (index < widget.music.length - 1) {
                            index += 1;
                            player.stop();
                            _init();
                          }
                        });
                      },
                      child: SvgPicture.asset(AppIcons.next)),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
