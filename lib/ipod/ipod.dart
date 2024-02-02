import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:test001/ipod/PodcastModel.dart';
import 'package:just_audio/just_audio.dart';
import 'package:volume_controller/volume_controller.dart';

class IpodPage extends StatefulWidget {
  const IpodPage({Key? key}) : super(key: key);

  @override
  State<IpodPage> createState() => _IpodPageState();
}

class _IpodPageState extends State<IpodPage>
    with SingleTickerProviderStateMixin {
  final int _counter = 0;
  double radius = 150;
  double degree = 0;
  double rotationalChange = 0;
  double lastOffset = 0;
  bool isPlay = false;
  bool smaller = false;
  List<Episodes> bunchOfEpisode = [];
  PageController controller = PageController(viewportFraction: 1);
  late AudioPlayer audioPlayer;

  void _panHandler(DragUpdateDetails d) {
    bool panUp = d.delta.dy <= 0.0;
    bool panLeft = d.delta.dx <= 0.0;
    bool panRight = !panLeft;
    bool panDown = !panUp;

    /// Pan location on the wheel
    bool onTop = d.localPosition.dy <= 150; // 150 == radius of circle
    bool onLeftSide = d.localPosition.dx <= 150;
    bool onRightSide = !onLeftSide;
    bool onBottom = !onTop;

    /// Absoulte change on axis
    double yChange = d.delta.dy.abs();
    double xChange = d.delta.dx.abs();

    /// Directional change on wheel
    double vert = (onRightSide && panUp) || (onLeftSide && panDown)
        ? yChange
        : yChange * -1;

    double horz =
        (onTop && panLeft) || (onBottom && panRight) ? xChange : xChange * -1;

    // Total computed change with velocity
    double scrollOffsetChange = (horz + vert) * (d.delta.distance * 0.4);

    // Move the page view scroller
    controller.jumpTo(controller.offset + scrollOffsetChange);
    setState(() {
      degree = controller.offset + scrollOffsetChange;
    });
  }

  void _panEndHandler(DragEndDetails d) {}

  late AnimationController _animationController;

  double _volumeListenerValue = 0;

  double currentProgress = 0.0;
  int maxProgress = 365;
  Duration endDuration = const Duration(seconds: 0);
  Duration startDuration = const Duration(seconds: 0);
  bool isPlaying = false;
  bool isLoading = true;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();
    fetchDataPodcast();
    controller.addListener(() {
      setState(() {
        lastOffset = controller.page ?? 0.0;
      });
    });

    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 450));
    audioPlayer.positionStream.listen((position) {
      final positionNotNull = position;
      setState(() {
        currentProgress = positionNotNull.inSeconds / maxProgress;
        startDuration = positionNotNull;
      });
    });

    audioPlayer.playerStateStream.listen((playState) {
      if (playState.processingState == ProcessingState.ready) {
        print("ready");
      }
      if (playState.processingState == ProcessingState.completed) {
        _animationController.reverse();
        pauseAudio();
        setState(() {
          endDuration = const Duration(seconds: 0);
          startDuration = const Duration(seconds: 0);
          currentProgress = 0.0;
          isPlaying = false;
        });
      }
    });

    VolumeController().listener((volume) {
      setState(() => _volumeListenerValue = volume);
    });

    VolumeController()
        .getVolume()
        .then((volume) => _volumeListenerValue = volume);
  }

  playAudio() async {
    audioPlayer.play();
  }

  pauseAudio() async {
    await audioPlayer.pause();
  }

  void handleOnPressedIcon() {
    setState(() {
      isPlaying = !isPlaying;
      if (isPlaying) {
        _animationController.forward();
        playAudio();
      } else {
        _animationController.reverse();
        pauseAudio();
      }
    });
  }

  Future<void> fetchDataPodcast() async {
    var unixTime = (DateTime.now().millisecondsSinceEpoch / 1000).round();
    String newUnixTime = unixTime.toString();
    var apiKey = "WRHFHWPXFFWSPPR3SRJX";
    var apiSecret = "VMAnxKt7KmW4H3Htxwu5F8LPbP4bLxm8QLgp8Szd";
    var firstChunk = utf8.encode(apiKey);
    var secondChunk = utf8.encode(apiSecret);
    var thirdChunk = utf8.encode(newUnixTime);

    var output = AccumulatorSink<Digest>();
    var input = sha1.startChunkedConversion(output);
    input.add(firstChunk);
    input.add(secondChunk);
    input.add(thirdChunk);
    input.close();
    var digest = output.events.single;

    Dio dio = Dio();
    dio.options.headers['X-Auth-Date'] = newUnixTime;
    dio.options.headers['X-Auth-Key'] = apiKey;
    dio.options.headers['Authorization'] = digest.toString();
    dio.options.headers['User-Agent'] = "SomethingAwesome/1.0.1";
    final response = await dio.get(
        "https://api.podcastindex.org/api/1.0/episodes/random?max=10&lang=id");
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      final result = PodcastModel.fromJson(response.data);

      setState(() {
        bunchOfEpisode = result.episodes ?? [];
        List<AudioSource> bunchOfUrl = bunchOfEpisode
            .map((e) => AudioSource.uri(Uri.parse(e.enclosureUrl ?? "")))
            .toList();
        final playlist = ConcatenatingAudioSource(
          // Start loading next item just before reaching it
          useLazyPreparation: true,
          // Customise the shuffle algorithm
          shuffleOrder: DefaultShuffleOrder(),
          // Specify the playlist items
          children: bunchOfUrl,
        );
        audioPlayer.setAudioSource(playlist,
            initialIndex: 0, initialPosition: Duration.zero);
      });
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  void _onPageChanged(int index) {
    _animationController.reverse();
    pauseAudio();
    setState(() {
      endDuration = const Duration(seconds: 0);
      startDuration = const Duration(seconds: 0);

      currentProgress = 0.0;
      isPlaying = false;
      currentIndex = index;
    });

    audioPlayer.seek(Duration.zero, index: index);
  }

  String currentTitle() {
    if (bunchOfEpisode.asMap().containsKey(currentIndex)) {
      if (bunchOfEpisode[currentIndex].title != null &&
          (bunchOfEpisode[currentIndex].title ?? "").length > 40) {
        return bunchOfEpisode[currentIndex].title!.substring(0, 40) + "...";
      } else {
        return bunchOfEpisode[currentIndex].title ?? "";
      }
    }

    return "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF626262),
      body: SafeArea(
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const SizedBox(height: 16),
                SizedBox(
                  height: 300,
                  child: PageView(
                    pageSnapping: true,
                    scrollDirection: Axis.horizontal,
                    controller: controller,
                    onPageChanged: _onPageChanged,
                    children: List.generate(
                      bunchOfEpisode.length,
                      (index) {
                        double relativePosition = index - lastOffset;
                        return Container(
                          child: Transform(
                            transform: Matrix4.identity() // add perspective
                              ..scale(
                                  (1 - relativePosition.abs()).clamp(0.4, 0.6) +
                                      0.4),
                            alignment: relativePosition >= 0
                                ? Alignment.centerLeft
                                : Alignment.centerRight,
                            child: Container(
                              child: CachedNetworkImage(
                                progressIndicatorBuilder:
                                    (context, url, progress) => Center(
                                  child: CircularProgressIndicator(
                                    value: progress.progress,
                                  ),
                                ),
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover),
                                  ),
                                ),
                                imageUrl: bunchOfEpisode[index].feedImage!,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                LinearProgressIndicator(
                  backgroundColor: Colors.grey[300]?.withOpacity(0.3),
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                  value: currentProgress,
                ),
                const SizedBox(height: 16),
                Text(
                  currentTitle(),
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w600),
                ),
                Expanded(
                  child: Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        GestureDetector(
                          onPanUpdate: _panHandler,
                          onPanEnd: _panEndHandler,
                          child: Container(
                            height: radius * 2,
                            width: radius * 2,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFF171717),
                            ),
                            child: Stack(
                              children: [
                                Container(
                                  alignment: Alignment.topCenter,
                                  margin: const EdgeInsets.only(top: 30),
                                  child: IconButton(
                                    icon: const Icon(Icons.add),
                                    iconSize: 40,
                                    color: Colors.white,
                                    onPressed: () {
                                      double volumeNow =
                                          _volumeListenerValue + 0.1;
                                      VolumeController().setVolume(
                                          volumeNow > 1 ? 1 : volumeNow);
                                    },
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.centerRight,
                                  margin: const EdgeInsets.only(right: 30),
                                  child: IconButton(
                                    icon: const Icon(Icons.fast_forward),
                                    iconSize: 40,
                                    color: Colors.white,
                                    onPressed: () {
                                      controller.nextPage(
                                          duration:
                                              const Duration(milliseconds: 500),
                                          curve: Curves.easeInOut);
                                      // controller.jumpTo(controller.offset + 250);
                                    },
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  margin: const EdgeInsets.only(left: 30),
                                  child: IconButton(
                                    icon: const Icon(Icons.fast_rewind),
                                    iconSize: 40,
                                    color: Colors.white,
                                    onPressed: () {
                                      controller.previousPage(
                                          duration:
                                              const Duration(milliseconds: 500),
                                          curve: Curves.easeInOut);
                                    },
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.bottomCenter,
                                  margin: const EdgeInsets.only(bottom: 30),
                                  child: IconButton(
                                    icon: const Icon(Icons.remove),
                                    iconSize: 40,
                                    color: Colors.white,
                                    onPressed: () {
                                      double volumeNow =
                                          _volumeListenerValue - 0.1;
                                      VolumeController().setVolume(
                                          volumeNow < 0 ? 0 : volumeNow);
                                    },
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Container(
                          height: 100,
                          width: 100,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFF626262),
                          ),
                          child: IconButton(
                            icon: AnimatedIcon(
                              icon: AnimatedIcons.play_pause,
                              color: Colors.white,
                              progress: _animationController,
                            ),
                            iconSize: 40,
                            onPressed: () {
                              handleOnPressedIcon();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
