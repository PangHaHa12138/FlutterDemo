import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:ui' as ui show window;
import 'package:better_open_file/better_open_file.dart';
import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:camerawesome/pigeon.dart';
import 'package:fijkplayer/fijkplayer.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:path_provider/path_provider.dart';
import 'package:test001/game/game.dart';
import 'package:test001/ipod/ipod.dart';
import 'package:test001/login/login_screen.dart';
import 'package:test001/netflix/widgets/bottom_navigation_widget.dart';
import 'package:test001/neumorphic/neumorphic1.dart';
import 'package:test001/neumorphic/neumorphic3.dart';
import 'package:test001/o3d/test_3d_page.dart';
import 'package:test001/pages/tiktok_page.dart';
import 'package:test001/pages/video_page.dart';
import 'package:test001/reply/home_page.dart';
import 'package:test001/screens/home.dart';
import 'package:test001/space/screens/splash_screen.dart';
import 'package:test001/tetris/tetris_home_page.dart';
import 'package:test001/vlc/vlc_play.dart';
import 'package:video_player/video_player.dart';
import 'package:web_socket_channel/io.dart';

class TestPage extends StatefulWidget {
  late BuildContext context;

  TestPage(this.context);

  @override
  _TestPageStat createState() => _TestPageStat(context);
}

class _TestPageStat extends State<TestPage> with TickerProviderStateMixin {
  late BuildContext superContext;

  _TestPageStat(this.superContext);

  int _currentIndex = 0;
  final List<Widget> _pages = [
    Page1(),
    Page2(),
    Page3(),
    Page4(),
    Page5(),
  ];

  bool hasShow = false;

  late OverlayEntry _overlayEntry;
  late AnimationController _animationController;
  late VideoPlayerController _videoController;
  Offset currentPosition = const Offset(0, 0);
  bool isDragging = false;
  final bool _isVideoPlaying = false;


  @override
  void initState() {
    super.initState();
    _videoController = VideoPlayerController.network(
        'https://jomin-web.web.app/resource/video/video_iu.mp4');
    _initializeVideoController();
    _videoController.setLooping(true);
    _videoController.addListener(_videoPlayerListener);
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _overlayEntry = OverlayEntry(
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Positioned(
              left: currentPosition.dx,
              top: currentPosition.dy,
              child: GestureDetector(
                onPanStart: (details) {
                  isDragging = true;
                },
                onPanUpdate: (details) {
                  if (isDragging) {
                    setState(() {
                      currentPosition = Offset(
                        currentPosition.dx + details.delta.dx,
                        currentPosition.dy + details.delta.dy,
                      );
                    });
                  }
                },
                onPanEnd: (details) {
                  isDragging = false;
                },
                child: Container(
                  width: 320,
                  height: 180,
                  color: Colors.blue,
                  child: Stack(
                    children: [
                      if (_videoController.value.isInitialized)
                        AspectRatio(
                          aspectRatio: _videoController.value.aspectRatio,
                          child: VideoPlayer(_videoController),
                        ),
                      Align(
                        alignment: Alignment.center,
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                if (_videoController.value.isPlaying) {
                                  _videoController.pause();
                                } else {
                                  _videoController.play();
                                }
                              });
                            },
                            child: AnimatedIcon(
                              icon: AnimatedIcons.play_pause,
                              progress: _animationController,
                              size: 40,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              _overlayEntry.remove();
                              hasShow = false;
                            },
                            child: const Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _initializeVideoController() async {
    await _videoController.initialize();
    setState(() {});
  }

  void _videoPlayerListener() {
    if (_videoController.value.isPlaying) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  @override
  void dispose() {
    _overlayEntry.remove();
    _animationController.dispose();
    _videoController.dispose();
    _videoController.removeListener(_videoPlayerListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.home),
              color: _currentIndex == 0 ? Colors.blue : Colors.grey,
              onPressed: () {
                setState(() {
                  _currentIndex = 0; // 切换到第1个页面
                });
              },
            ),
            IconButton(
              icon: const Icon(Icons.chat),
              color: _currentIndex == 1 ? Colors.blue : Colors.grey,
              onPressed: () {
                setState(() {
                  _currentIndex = 1; // 切换到第2个页面
                });
              },
            ),
            const SizedBox(),
            IconButton(
              icon: const Icon(Icons.business),
              color: _currentIndex == 3 ? Colors.blue : Colors.grey,
              onPressed: () {
                setState(() {
                  _currentIndex = 3; // 切换到第4个页面
                  SystemChrome.setSystemUIOverlayStyle(
                      const SystemUiOverlayStyle(
                    statusBarIconBrightness: Brightness.dark,
                  ));
                });
              },
            ),
            IconButton(
              icon: const Icon(Icons.person),
              color: _currentIndex == 4 ? Colors.blue : Colors.grey,
              onPressed: () {
                setState(() {
                  _currentIndex = 4; // 切换到第5个页面
                  SystemChrome.setSystemUIOverlayStyle(
                      const SystemUiOverlayStyle(
                    statusBarIconBrightness: Brightness.dark,
                  ));
                });
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add_a_photo),
        onPressed: () {
          setState(() {
            _currentIndex = 2; // 切换到中间的页面
          });
          if (!hasShow) {
            showFloatingWindow(context);
            hasShow = true;
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  void showFloatingWindow(BuildContext context) {
    Overlay.of(context)!.insert(_overlayEntry);
  }
}

class TRexGameWrapper extends StatefulWidget {
  @override
  _TRexGameWrapperState createState() => _TRexGameWrapperState();
}

class _TRexGameWrapperState extends State<TRexGameWrapper> {
  bool splashGone = false;
  TRexGame? game;
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    startGame();
  }

  void startGame() {
    Flame.images.loadAll(["sprite.png"]).then(
      (image) => {
        setState(() {
          game = TRexGame(spriteImage: image[0]);
          _focusNode.requestFocus();
        })
      },
    );
  }

  void onRawKeyEvent(RawKeyEvent event) {
    if (event.logicalKey == LogicalKeyboardKey.enter ||
        event.logicalKey == LogicalKeyboardKey.space) {
      game!.onAction();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (game == null) {
      return const Center(
        child: Text("Loading"),
      );
    }
    return Container(
      color: Colors.white,
      constraints: const BoxConstraints.expand(),
      child: RawKeyboardListener(
        focusNode: _focusNode,
        onKey: onRawKeyEvent,
        child: GameWidget(
          game: game!,
        ),
      ),
    );
  }
}

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  @override
  initState() {
    super.initState();
  }

  Future<String> path(CaptureMode captureMode) async {
    final directory = await getApplicationDocumentsDirectory();
    if (captureMode == CaptureMode.photo) {
      return "${directory.path}test_photo.jpg";
    } else {
      return "${directory.path}test_video.mp4";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: CameraAwesomeBuilder.awesome(
          saveConfig: SaveConfig.photoAndVideo(
            photoPathBuilder: () => path(CaptureMode.photo),
            videoPathBuilder: () => path(CaptureMode.video),
            initialCaptureMode: CaptureMode.photo,
          ),
          enablePhysicalButton: true,
          enableAudio: true,
          exifPreferences: ExifPreferences(saveGPSLocation: true),
          filter: AwesomeFilter.None,
          flashMode: FlashMode.auto,
          aspectRatio: CameraAspectRatios.ratio_16_9,
          previewFit: CameraPreviewFit.cover,
          onMediaTap: (mediaCapture) {
            OpenFile.open(mediaCapture.filePath);
          },
        ),
      ),
    );
  }
}

class VideoFullScreenPage extends StatelessWidget {
  final List<String> videoUrls = [
    'https://static.ybhospital.net/test-video-2.mp4',
    'https://static.ybhospital.net/test-video-3.mp4',
    'https://static.ybhospital.net/test-video-4.mp4',
    'https://static.ybhospital.net/test-video-5.mp4',
    'https://static.ybhospital.net/test-video-6.mp4',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          VideoPlayerList(videoUrls: videoUrls),
          Positioned(
            top: 16,
            left: 16,
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.lightBlue,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ],
      ),
    );
  }
}

class VideoPlayerList extends StatefulWidget {
  final List<String> videoUrls;

  VideoPlayerList({required this.videoUrls});

  @override
  _VideoPlayerListState createState() => _VideoPlayerListState();
}

class _VideoPlayerListState extends State<VideoPlayerList> {
  late PageController _pageController;
  int currentPageIndex = 1000; // Set initial index to the middle of the list

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: currentPageIndex);
    _pageController.addListener(_onPageScroll);
  }

  void _onPageScroll() {
    final pageIndex = _pageController.page?.round();
    if (pageIndex != null && pageIndex != currentPageIndex) {
      setState(() {
        currentPageIndex = pageIndex;
      });
    }
  }

  @override
  void dispose() {
    _pageController.removeListener(_onPageScroll);
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      scrollDirection: Axis.vertical,
      itemCount: widget.videoUrls.length * 1000,
      // Make the list virtually infinite
      controller: _pageController,
      itemBuilder: (context, index) {
        final videoIndex = index % widget.videoUrls.length;
        return VideoPlayerPage(
          videoUrl: widget.videoUrls[videoIndex],
          isPlaying: index == currentPageIndex,
        );
      },
    );
  }
}

class VideoPlayerPage extends StatefulWidget {
  final String videoUrl;
  final bool isPlaying;

  VideoPlayerPage({required this.videoUrl, required this.isPlaying});

  @override
  _VideoPlayerPageState createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl);
    _controller.initialize().then((_) {
      _controller.setLooping(true);
      if (widget.isPlaying) {
        _controller.play();
      } else {
        _controller.pause();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: _controller.value.aspectRatio,
      child: VideoPlayer(_controller),
    );
  }
}


class VideoPlayPage3 extends StatefulWidget {
  @override
  _VideoPlayPage3 createState() => _VideoPlayPage3();
}

class _VideoPlayPage3 extends State<VideoPlayPage3> {
  final FijkPlayer ijkPlayer = FijkPlayer();
  late Future<void> _initializeVideoPlayerFuture;
  late VideoPlayerController _videoPlayerController;
  late VlcPlayerController _vlcPlayerController;
  var url = 'https://contents-stg.emb-app-stg.nishikawa1566.com/video/VI_000000431_20230904075842.mp4';
  var header = {"cookie":"CloudFront-Expires=1705721699;CloudFront-Signature=ZTDYfkMQJReDbWWXE0kDH6fF7J36XCfp6xdEPLL~ytETNhMehUOhNcZ8u-oWXca6IP2QDx7BFi3-pBwprN2Yf0Dfk9q4wFMZYfOIowRSoeJCNLX~t171Zb-~bxxU5wH1tjjiibhPSoA8M2mzsnwNL4BIBnoVaUUMI5cQJg0NTZKu50iL2Ix7~HE3ScXVwh6KN1Eki8zkmkGNa3XLZD6NbzBugqCYwhyN0M3ElLV-V2246miM5zA8OvZVu29Bnf5-libHv72um6NpWKsvzdvoA6F8Lz86hna4FfS7FKqm1dyPymfWjKp0CQb1LnkVurKBrMAkZ90WYHn2qkYMhy7liw__;CloudFront-Key-Pair-Id=K3FH1KBMYM2SV3"};
  bool isPlaying = true;
  bool isPlaying2 = true;
  bool isPlaying3 = true;

  @override
  void initState() {
    super.initState();

    initController();
  }


  initController() async {
    //var file = await DefaultCacheManager().getSingleFile(url,headers: header);
    //_videoPlayerController = VideoPlayerController.file(file);

    _videoPlayerController = VideoPlayerController.network(url,httpHeaders: header);

    _initializeVideoPlayerFuture =
        _videoPlayerController.initialize().then((_) {
          _videoPlayerController.setLooping(true);
          _videoPlayerController.play();
          setState(() {});
        });

    ijkPlayer.setDataSource(url, autoPlay: true);

    _vlcPlayerController = VlcPlayerController.network(
      url,
      hwAcc: HwAcc.full,
      autoPlay: true,
      options: VlcPlayerOptions(),
    );
  }


  @override
  void dispose() async {
    super.dispose();
    ijkPlayer.release();
    _videoPlayerController.dispose();
    await _vlcPlayerController.stopRendererScanning();
    await _vlcPlayerController.dispose();

    //await DefaultCacheManager().emptyCache();
  }

  void togglePlayPause() {
    if (isPlaying) {
      ijkPlayer.pause();
    } else {
      ijkPlayer.start();
    }
    setState(() {
      isPlaying = !isPlaying;
    });
  }

  void togglePlayPause2() {
    if (isPlaying2) {
      _videoPlayerController.pause();
    } else {
      _videoPlayerController.play();
    }
    setState(() {
      isPlaying2 = !isPlaying2;
    });
  }

  void togglePlayPause3() {
    if (isPlaying3) {
      _vlcPlayerController.pause();
    } else {
      _vlcPlayerController.play();
    }
    setState(() {
      isPlaying3 = !isPlaying3;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text("VideoPlayer"),
        backgroundColor: Colors.blue,
        elevation: 0,
        systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarIconBrightness: Brightness.dark),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Text('fijkplayer:0.11.0 => IjkPlayer'),
            Container(
              width: screenWidth,
              height: screenWidth * 9 / 16,
              child: FijkView(
                player: ijkPlayer,
              ),
            ),
            const SizedBox(height: 5.0),
            ElevatedButton(
              onPressed: togglePlayPause,
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.grey),
              ),
              child: Text(isPlaying ? '暂停' : '播放'),
            ),
            const SizedBox(height: 5.0),
            const Text('video_player:2.2.15 => ExoPlayer'),
            FutureBuilder(
                future: _initializeVideoPlayerFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return Container(
                      width: screenWidth,
                      height: screenWidth * 9 / 16,
                      child: AspectRatio(
                        aspectRatio: _videoPlayerController.value.aspectRatio,
                        child: VideoPlayer(_videoPlayerController),
                      ),
                    );
                  } else {
                    return Container(
                      color: Colors.black54,
                      width: screenWidth,
                      height: screenWidth * 9 / 16,
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: Colors.blue,
                        ),
                      ),
                    );
                  }
                }),
            const SizedBox(height: 5.0),
            ElevatedButton(
              onPressed: togglePlayPause2,
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.grey),
              ),
              child: Text(isPlaying2 ? '暂停' : '播放'),
            ),
            const SizedBox(height: 5.0),
            const Text('flutter_vlc_player:7.4.1 => LibVLC'),
            Container(
              color: Colors.black54,
              width: screenWidth,
              height: screenWidth * 9 / 16,
              child: VlcPlayer(
                controller: _vlcPlayerController,
                aspectRatio: 16 / 9,
                placeholder: const Center(child: CircularProgressIndicator(color: Colors.blue,)),
              ),
            ),
            const SizedBox(height: 5.0),
            ElevatedButton(
              onPressed: togglePlayPause3,
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.grey),
              ),
              child: Text(isPlaying3 ? '暂停' : '播放'),
            ),
          ],
        ),
      ),
    );
  }
}

class VideoLive extends StatefulWidget {
  @override
  _VideoLiveState createState() => _VideoLiveState();
}

class _VideoLiveState extends State<VideoLive> {
  final FijkPlayer ijkPlayer = FijkPlayer();
  late Future<void> _initializeVideoPlayerFuture;
  late VideoPlayerController _videoPlayerController;
  late VlcPlayerController _vlcPlayerController;
  var url = 'http://220.161.87.62:8800/hls/0/index.m3u8';
  bool isPlaying = true;
  bool isPlaying2 = true;
  bool isPlaying3 = true;

  @override
  void initState() {
    super.initState();
    ijkPlayer.setDataSource(url, autoPlay: true);
    _videoPlayerController = VideoPlayerController.network(url);
    _initializeVideoPlayerFuture =
        _videoPlayerController.initialize().then((_) {
      _videoPlayerController.setLooping(true);
      _videoPlayerController.play();
      setState(() {});
    });

    _vlcPlayerController = VlcPlayerController.network(
      url,
      hwAcc: HwAcc.full,
      autoPlay: true,
      options: VlcPlayerOptions(),
    );
  }

  @override
  void dispose() async {
    super.dispose();
    ijkPlayer.release();
    _videoPlayerController.dispose();
    await _vlcPlayerController.stopRendererScanning();
    await _vlcPlayerController.dispose();
  }

  void togglePlayPause() {
    if (isPlaying) {
      ijkPlayer.pause();
    } else {
      ijkPlayer.start();
    }
    setState(() {
      isPlaying = !isPlaying;
    });
  }

  void togglePlayPause2() {
    if (isPlaying2) {
      _videoPlayerController.pause();
    } else {
      _videoPlayerController.play();
    }
    setState(() {
      isPlaying2 = !isPlaying2;
    });
  }

  void togglePlayPause3() {
    if (isPlaying3) {
      _vlcPlayerController.pause();
    } else {
      _vlcPlayerController.play();
    }
    setState(() {
      isPlaying3 = !isPlaying3;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text("LiveStream"),
        backgroundColor: Colors.blue,
        elevation: 0,
        systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarIconBrightness: Brightness.dark),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Text('fijkplayer:0.11.0 => IjkPlayer'),
            Container(
              width: screenWidth,
              height: screenWidth * 9 / 16,
              child: FijkView(
                player: ijkPlayer,
              ),
            ),
            const SizedBox(height: 5.0),
            ElevatedButton(
              onPressed: togglePlayPause,
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.grey),
              ),
              child: Text(isPlaying ? '暂停' : '播放'),
            ),
            const SizedBox(height: 5.0),
            const Text('video_player:2.2.15 => ExoPlayer'),
            FutureBuilder(
                future: _initializeVideoPlayerFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return Container(
                      width: screenWidth,
                      height: screenWidth * 9 / 16,
                      child: AspectRatio(
                        aspectRatio: _videoPlayerController.value.aspectRatio,
                        child: VideoPlayer(_videoPlayerController),
                      ),
                    );
                  } else {
                    return Container(
                      color: Colors.black54,
                      width: screenWidth,
                      height: screenWidth * 9 / 16,
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: Colors.blue,
                        ),
                      ),
                    );
                  }
                }),
            const SizedBox(height: 5.0),
            ElevatedButton(
              onPressed: togglePlayPause2,
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.grey),
              ),
              child: Text(isPlaying2 ? '暂停' : '播放'),
            ),
            const SizedBox(height: 5.0),
            const Text('flutter_vlc_player:7.4.1 => LibVLC'),
            Container(
              color: Colors.black54,
              width: screenWidth,
              height: screenWidth * 9 / 16,
              child: VlcPlayer(
                controller: _vlcPlayerController,
                aspectRatio: 16 / 9,
                placeholder: const Center(child: CircularProgressIndicator(color: Colors.blue,)),
              ),
            ),
            const SizedBox(height: 5.0),
            ElevatedButton(
              onPressed: togglePlayPause3,
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.grey),
              ),
              child: Text(isPlaying3 ? '暂停' : '播放'),
            ),
          ],
        ),
      ),
    );
  }
}

class ExampleParallax extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                for (final location in locations)
                  LocationListItem(
                    imageUrl: location.imageUrl,
                    name: location.name,
                    country: location.place,
                  ),
              ],
            ),
          ),
          Positioned(
            top: 16,
            left: 16,
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ],
      ),
    );
  }
}

class LocationListItem extends StatelessWidget {
  LocationListItem({
    required this.imageUrl,
    required this.name,
    required this.country,
  });

  final String imageUrl;
  final String name;
  final String country;
  final GlobalKey _backgroundImageKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              _buildParallaxBackground(context),
              _buildGradient(),
              _buildTitleAndSubtitle(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildParallaxBackground(BuildContext context) {
    return Flow(
      delegate: ParallaxFlowDelegate(
        scrollable: Scrollable.of(context) as ScrollableState,
        listItemContext: context,
        backgroundImageKey: _backgroundImageKey,
      ),
      children: [
        Image.network(
          imageUrl,
          key: _backgroundImageKey,
          fit: BoxFit.cover,
        ),
      ],
    );
  }

  Widget _buildGradient() {
    return Positioned.fill(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: const [0.6, 0.95],
          ),
        ),
      ),
    );
  }

  Widget _buildTitleAndSubtitle() {
    return Positioned(
      left: 20,
      bottom: 20,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            country,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

class ParallaxFlowDelegate extends FlowDelegate {
  ParallaxFlowDelegate({
    required this.scrollable,
    required this.listItemContext,
    required this.backgroundImageKey,
  }) : super(repaint: scrollable.position);

  final ScrollableState scrollable;
  final BuildContext listItemContext;
  final GlobalKey backgroundImageKey;

  @override
  BoxConstraints getConstraintsForChild(int i, BoxConstraints constraints) {
    return BoxConstraints.tightFor(
      width: constraints.maxWidth,
    );
  }

  @override
  void paintChildren(FlowPaintingContext context) {
    // Calculate the position of this list item within the viewport.
    final scrollableBox = scrollable.context.findRenderObject() as RenderBox;
    final listItemBox = listItemContext.findRenderObject() as RenderBox;
    final listItemOffset = listItemBox.localToGlobal(
        listItemBox.size.centerLeft(Offset.zero),
        ancestor: scrollableBox);

    // Determine the percent position of this list item within the
    // scrollable area.
    final viewportDimension = scrollable.position.viewportDimension;
    final scrollFraction =
        (listItemOffset.dy / viewportDimension).clamp(0.0, 1.0);

    // Calculate the vertical alignment of the background
    // based on the scroll percent.
    final verticalAlignment = Alignment(0.0, scrollFraction * 2 - 1);

    // Convert the background alignment into a pixel offset for
    // painting purposes.
    final backgroundSize =
        (backgroundImageKey.currentContext!.findRenderObject() as RenderBox)
            .size;
    final listItemSize = context.size;
    final childRect =
        verticalAlignment.inscribe(backgroundSize, Offset.zero & listItemSize);

    // Paint the background.
    context.paintChild(
      0,
      transform:
          Transform.translate(offset: Offset(0.0, childRect.top)).transform,
    );
  }

  @override
  bool shouldRepaint(ParallaxFlowDelegate oldDelegate) {
    return scrollable != oldDelegate.scrollable ||
        listItemContext != oldDelegate.listItemContext ||
        backgroundImageKey != oldDelegate.backgroundImageKey;
  }
}

class Parallax extends SingleChildRenderObjectWidget {
  const Parallax({
    required Widget background,
  }) : super(child: background);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderParallax(
        scrollable: Scrollable.of(context) as ScrollableState);
  }

  @override
  void updateRenderObject(
      BuildContext context, covariant RenderParallax renderObject) {
    renderObject.scrollable = Scrollable.of(context) as ScrollableState;
  }
}

class ParallaxParentData extends ContainerBoxParentData<RenderBox> {}

class RenderParallax extends RenderBox
    with RenderObjectWithChildMixin<RenderBox>, RenderProxyBoxMixin {
  RenderParallax({
    required ScrollableState scrollable,
  }) : _scrollable = scrollable;

  ScrollableState _scrollable;

  ScrollableState get scrollable => _scrollable;

  set scrollable(ScrollableState value) {
    if (value != _scrollable) {
      if (attached) {
        _scrollable.position.removeListener(markNeedsLayout);
      }
      _scrollable = value;
      if (attached) {
        _scrollable.position.addListener(markNeedsLayout);
      }
    }
  }

  @override
  void attach(covariant PipelineOwner owner) {
    super.attach(owner);
    _scrollable.position.addListener(markNeedsLayout);
  }

  @override
  void detach() {
    _scrollable.position.removeListener(markNeedsLayout);
    super.detach();
  }

  @override
  void setupParentData(covariant RenderObject child) {
    if (child.parentData is! ParallaxParentData) {
      child.parentData = ParallaxParentData();
    }
  }

  @override
  void performLayout() {
    size = constraints.biggest;

    // Force the background to take up all available width
    // and then scale its height based on the image's aspect ratio.
    final background = child!;
    final backgroundImageConstraints =
        BoxConstraints.tightFor(width: size.width);
    background.layout(backgroundImageConstraints, parentUsesSize: true);

    // Set the background's local offset, which is zero.
    (background.parentData as ParallaxParentData).offset = Offset.zero;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    // Get the size of the scrollable area.
    final viewportDimension = scrollable.position.viewportDimension;

    // Calculate the global position of this list item.
    final scrollableBox = scrollable.context.findRenderObject() as RenderBox;
    final backgroundOffset =
        localToGlobal(size.centerLeft(Offset.zero), ancestor: scrollableBox);

    // Determine the percent position of this list item within the
    // scrollable area.
    final scrollFraction =
        (backgroundOffset.dy / viewportDimension).clamp(0.0, 1.0);

    // Calculate the vertical alignment of the background
    // based on the scroll percent.
    final verticalAlignment = Alignment(0.0, scrollFraction * 2 - 1);

    // Convert the background alignment into a pixel offset for
    // painting purposes.
    final background = child!;
    final backgroundSize = background.size;
    final listItemSize = size;
    final childRect =
        verticalAlignment.inscribe(backgroundSize, Offset.zero & listItemSize);

    // Paint the background.
    context.paintChild(
        background,
        (background.parentData as ParallaxParentData).offset +
            offset +
            Offset(0.0, childRect.top));
  }
}

class Location {
  const Location({
    required this.name,
    required this.place,
    required this.imageUrl,
  });

  final String name;
  final String place;
  final String imageUrl;
}

const urlPrefix =
    'https://docs.flutter.dev/cookbook/img-files/effects/parallax';
const locations = [
  Location(
    name: 'Mount Rushmore',
    place: 'U.S.A',
    imageUrl: '$urlPrefix/01-mount-rushmore.jpg',
  ),
  Location(
    name: 'Gardens By The Bay',
    place: 'Singapore',
    imageUrl: '$urlPrefix/02-singapore.jpg',
  ),
  Location(
    name: 'Machu Picchu',
    place: 'Peru',
    imageUrl: '$urlPrefix/03-machu-picchu.jpg',
  ),
  Location(
    name: 'Vitznau',
    place: 'Switzerland',
    imageUrl: '$urlPrefix/04-vitznau.jpg',
  ),
  Location(
    name: 'Bali',
    place: 'Indonesia',
    imageUrl: '$urlPrefix/05-bali.jpg',
  ),
  Location(
    name: 'Mexico City',
    place: 'Mexico',
    imageUrl: '$urlPrefix/06-mexico-city.jpg',
  ),
  Location(
    name: 'Cairo',
    place: 'Egypt',
    imageUrl: '$urlPrefix/07-cairo.jpg',
  ),
];

class Moment {
  final String name;
  final String avatarUrl;
  final String text;
  final List<String> imageUrls;
  final String videoUrl;
  final int likeCount;
  final int commentCount;

  Moment({
    required this.name,
    required this.avatarUrl,
    required this.text,
    required this.imageUrls,
    required this.videoUrl,
    required this.likeCount,
    required this.commentCount,
  });
}

class WeChatMomentsPage1 extends StatefulWidget {
  @override
  _WeChatMomentsPage1State createState() => _WeChatMomentsPage1State();
}

class _WeChatMomentsPage1State extends State<WeChatMomentsPage1> {
  final ScrollController _scrollController = ScrollController();
  bool _isAppBarCollapse = false;
  var moments;
  var has_set = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      _isAppBarCollapse = _scrollController.offset >= 244;
      //print('offset:===> ${_scrollController.offset}');
      setState(() {});
    });
    moments = <Moment>[
      Moment(
        name: 'User',
        avatarUrl: 'https://qnm.hunliji.com/o_1gjo5pg1uf9a161f8410i6v2n8n.jpg',
        text: '这是动态的文字内容',
        imageUrls: [
          'https://cdn.pixabay.com/photo/2023/08/20/20/03/planes-8203121_1280.jpg',
          'https://cdn.pixabay.com/photo/2023/03/06/17/02/ship-7833921_1280.jpg',
          'https://cdn.pixabay.com/photo/2023/08/13/14/42/mountain-8187621_1280.jpg'
        ],
        videoUrl: '',
        likeCount: 5,
        commentCount: 3,
      ),
      Moment(
        name: 'User',
        avatarUrl: 'https://qnm.hunliji.com/o_1gjo5pg1uf9a161f8410i6v2n8n.jpg',
        text: '这是动态的文字内容',
        imageUrls: [],
        videoUrl: 'https://jomin-web.web.app/resource/video/video_iu.mp4',
        likeCount: 5,
        commentCount: 3,
      ),
      Moment(
        name: 'User',
        avatarUrl: 'https://qnm.hunliji.com/o_1gjo5pg1uf9a161f8410i6v2n8n.jpg',
        text: '这是动态的文字内容',
        imageUrls: [
          'https://cdn.pixabay.com/photo/2023/08/13/14/42/mountain-8187621_1280.jpg',
          'https://cdn.pixabay.com/photo/2023/08/20/20/03/planes-8203121_1280.jpg',
          'https://cdn.pixabay.com/photo/2023/03/06/17/02/ship-7833921_1280.jpg',
          'https://cdn.pixabay.com/photo/2023/08/13/14/42/mountain-8187621_1280.jpg',
        ],
        videoUrl: '',
        likeCount: 5,
        commentCount: 3,
      ),
      Moment(
        name: 'User',
        avatarUrl: 'https://qnm.hunliji.com/o_1gjo5pg1uf9a161f8410i6v2n8n.jpg',
        text: '这是动态的文字内容',
        imageUrls: [
          'https://cdn.pixabay.com/photo/2023/08/20/20/03/planes-8203121_1280.jpg',
          'https://cdn.pixabay.com/photo/2023/03/06/17/02/ship-7833921_1280.jpg',
          'https://cdn.pixabay.com/photo/2023/08/13/14/42/mountain-8187621_1280.jpg',
          'https://cdn.pixabay.com/photo/2023/08/20/20/03/planes-8203121_1280.jpg',
          'https://cdn.pixabay.com/photo/2023/03/06/17/02/ship-7833921_1280.jpg',
        ],
        videoUrl: '',
        likeCount: 5,
        commentCount: 3,
      ),
      Moment(
        name: 'User',
        avatarUrl: 'https://qnm.hunliji.com/o_1gjo5pg1uf9a161f8410i6v2n8n.jpg',
        text: '这是动态的文字内容',
        imageUrls: [],
        videoUrl: 'https://static.ybhospital.net/test-video-2.mp4',
        likeCount: 5,
        commentCount: 3,
      ),
      Moment(
        name: 'User',
        avatarUrl: 'https://qnm.hunliji.com/o_1gjo5pg1uf9a161f8410i6v2n8n.jpg',
        text: '这是动态的文字内容',
        imageUrls: [
          'https://cdn.pixabay.com/photo/2023/08/20/20/03/planes-8203121_1280.jpg',
          'https://cdn.pixabay.com/photo/2023/03/06/17/02/ship-7833921_1280.jpg',
        ],
        videoUrl: '',
        likeCount: 5,
        commentCount: 3,
      ),
      Moment(
        name: 'User',
        avatarUrl: 'https://qnm.hunliji.com/o_1gjo5pg1uf9a161f8410i6v2n8n.jpg',
        text: '这是动态的文字内容',
        imageUrls: [],
        videoUrl: 'https://static.ybhospital.net/test-video-4.mp4',
        likeCount: 5,
        commentCount: 3,
      ),
      Moment(
        name: 'User',
        avatarUrl: 'https://qnm.hunliji.com/o_1gjo5pg1uf9a161f8410i6v2n8n.jpg',
        text: '这是动态的文字内容',
        imageUrls: [
          'https://cdn.pixabay.com/photo/2023/08/20/20/03/planes-8203121_1280.jpg',
          'https://cdn.pixabay.com/photo/2023/03/06/17/02/ship-7833921_1280.jpg',
          'https://cdn.pixabay.com/photo/2023/08/13/14/42/mountain-8187621_1280.jpg',
          'https://cdn.pixabay.com/photo/2023/08/20/20/03/planes-8203121_1280.jpg',
          'https://cdn.pixabay.com/photo/2023/03/06/17/02/ship-7833921_1280.jpg',
          'https://cdn.pixabay.com/photo/2023/08/13/14/42/mountain-8187621_1280.jpg',
        ],
        videoUrl: '',
        likeCount: 5,
        commentCount: 3,
      ),
      Moment(
        name: 'User',
        avatarUrl: 'https://qnm.hunliji.com/o_1gjo5pg1uf9a161f8410i6v2n8n.jpg',
        text: '这是动态的文字内容',
        imageUrls: [],
        videoUrl: 'https://static.ybhospital.net/test-video-5.mp4',
        likeCount: 5,
        commentCount: 3,
      ),
      Moment(
        name: 'User',
        avatarUrl: 'https://qnm.hunliji.com/o_1gjo5pg1uf9a161f8410i6v2n8n.jpg',
        text: '这是动态的文字内容',
        imageUrls: [
          'https://cdn.pixabay.com/photo/2023/08/20/20/03/planes-8203121_1280.jpg',
          'https://cdn.pixabay.com/photo/2023/03/06/17/02/ship-7833921_1280.jpg',
          'https://cdn.pixabay.com/photo/2023/08/13/14/42/mountain-8187621_1280.jpg',
          'https://cdn.pixabay.com/photo/2023/08/20/20/03/planes-8203121_1280.jpg',
          'https://cdn.pixabay.com/photo/2023/03/06/17/02/ship-7833921_1280.jpg',
          'https://cdn.pixabay.com/photo/2023/08/13/14/42/mountain-8187621_1280.jpg',
          'https://cdn.pixabay.com/photo/2023/08/20/20/03/planes-8203121_1280.jpg',
        ],
        videoUrl: '',
        likeCount: 5,
        commentCount: 3,
      ),
      Moment(
        name: 'User',
        avatarUrl: 'https://qnm.hunliji.com/o_1gjo5pg1uf9a161f8410i6v2n8n.jpg',
        text: '这是动态的文字内容',
        imageUrls: [],
        videoUrl: 'https://static.ybhospital.net/test-video-3.mp4',
        likeCount: 5,
        commentCount: 3,
      ),
      Moment(
        name: 'User',
        avatarUrl: 'https://qnm.hunliji.com/o_1gjo5pg1uf9a161f8410i6v2n8n.jpg',
        text: '这是动态的文字内容',
        imageUrls: [
          'https://cdn.pixabay.com/photo/2023/03/06/17/02/ship-7833921_1280.jpg',
          'https://cdn.pixabay.com/photo/2023/08/13/14/42/mountain-8187621_1280.jpg',
          'https://cdn.pixabay.com/photo/2023/08/20/20/03/planes-8203121_1280.jpg',
          'https://cdn.pixabay.com/photo/2023/03/06/17/02/ship-7833921_1280.jpg',
          'https://cdn.pixabay.com/photo/2023/08/13/14/42/mountain-8187621_1280.jpg',
          'https://cdn.pixabay.com/photo/2023/08/20/20/03/planes-8203121_1280.jpg',
          'https://cdn.pixabay.com/photo/2023/03/06/17/02/ship-7833921_1280.jpg',
          'https://cdn.pixabay.com/photo/2023/08/13/14/42/mountain-8187621_1280.jpg'
        ],
        videoUrl: '',
        likeCount: 5,
        commentCount: 3,
      ),
      Moment(
        name: 'User',
        avatarUrl: 'https://qnm.hunliji.com/o_1gjo5pg1uf9a161f8410i6v2n8n.jpg',
        text: '这是动态的文字内容',
        imageUrls: [],
        videoUrl: 'https://static.ybhospital.net/test-video-6.mp4',
        likeCount: 5,
        commentCount: 3,
      ),
      Moment(
        name: 'User',
        avatarUrl: 'https://qnm.hunliji.com/o_1gjo5pg1uf9a161f8410i6v2n8n.jpg',
        text: '这是动态的文字内容',
        imageUrls: [
          'https://cdn.pixabay.com/photo/2023/03/06/17/02/ship-7833921_1280.jpg',
          'https://cdn.pixabay.com/photo/2023/08/13/14/42/mountain-8187621_1280.jpg',
          'https://cdn.pixabay.com/photo/2023/08/20/20/03/planes-8203121_1280.jpg',
          'https://cdn.pixabay.com/photo/2023/03/06/17/02/ship-7833921_1280.jpg',
          'https://cdn.pixabay.com/photo/2023/08/13/14/42/mountain-8187621_1280.jpg',
          'https://cdn.pixabay.com/photo/2023/08/20/20/03/planes-8203121_1280.jpg',
          'https://cdn.pixabay.com/photo/2023/03/06/17/02/ship-7833921_1280.jpg',
          'https://cdn.pixabay.com/photo/2023/08/13/14/42/mountain-8187621_1280.jpg',
          'https://cdn.pixabay.com/photo/2023/03/06/17/02/ship-7833921_1280.jpg',
        ],
        videoUrl: '',
        likeCount: 5,
        commentCount: 3,
      ),
      Moment(
        name: 'User',
        avatarUrl: 'https://qnm.hunliji.com/o_1gjo5pg1uf9a161f8410i6v2n8n.jpg',
        text: '这是动态的文字内容',
        imageUrls: [],
        videoUrl: 'http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4',
        likeCount: 5,
        commentCount: 3,
      ),
      Moment(
        name: 'User',
        avatarUrl: 'https://qnm.hunliji.com/o_1gjo5pg1uf9a161f8410i6v2n8n.jpg',
        text: '这是动态的文字内容',
        imageUrls: [
          'https://cdn.pixabay.com/photo/2023/03/06/17/02/ship-7833921_1280.jpg',
          'https://cdn.pixabay.com/photo/2023/08/13/14/42/mountain-8187621_1280.jpg',
          'https://cdn.pixabay.com/photo/2023/08/20/20/03/planes-8203121_1280.jpg',
          'https://cdn.pixabay.com/photo/2023/03/06/17/02/ship-7833921_1280.jpg',
          'https://cdn.pixabay.com/photo/2023/08/13/14/42/mountain-8187621_1280.jpg',
          'https://cdn.pixabay.com/photo/2023/08/20/20/03/planes-8203121_1280.jpg',
          'https://cdn.pixabay.com/photo/2023/03/06/17/02/ship-7833921_1280.jpg',
          'https://cdn.pixabay.com/photo/2023/08/13/14/42/mountain-8187621_1280.jpg',
          'https://cdn.pixabay.com/photo/2023/03/06/17/02/ship-7833921_1280.jpg',
        ],
        videoUrl: '',
        likeCount: 5,
        commentCount: 3,
      ),
      Moment(
        name: 'User',
        avatarUrl: 'https://qnm.hunliji.com/o_1gjo5pg1uf9a161f8410i6v2n8n.jpg',
        text: '这是动态的文字内容',
        imageUrls: [],
        videoUrl: 'http://vjs.zencdn.net/v/oceans.mp4',
        likeCount: 5,
        commentCount: 3,
      ),
      Moment(
        name: 'User',
        avatarUrl: 'https://qnm.hunliji.com/o_1gjo5pg1uf9a161f8410i6v2n8n.jpg',
        text: '这是动态的文字内容',
        imageUrls: [
          'https://cdn.pixabay.com/photo/2023/03/06/17/02/ship-7833921_1280.jpg',
          'https://cdn.pixabay.com/photo/2023/08/13/14/42/mountain-8187621_1280.jpg',
          'https://cdn.pixabay.com/photo/2023/08/20/20/03/planes-8203121_1280.jpg',
          'https://cdn.pixabay.com/photo/2023/03/06/17/02/ship-7833921_1280.jpg',
          'https://cdn.pixabay.com/photo/2023/08/13/14/42/mountain-8187621_1280.jpg',
          'https://cdn.pixabay.com/photo/2023/08/20/20/03/planes-8203121_1280.jpg',
          'https://cdn.pixabay.com/photo/2023/03/06/17/02/ship-7833921_1280.jpg',
          'https://cdn.pixabay.com/photo/2023/08/13/14/42/mountain-8187621_1280.jpg',
          'https://cdn.pixabay.com/photo/2023/03/06/17/02/ship-7833921_1280.jpg',
        ],
        videoUrl: '',
        likeCount: 5,
        commentCount: 3,
      ),
      Moment(
        name: 'User',
        avatarUrl: 'https://qnm.hunliji.com/o_1gjo5pg1uf9a161f8410i6v2n8n.jpg',
        text: '这是动态的文字内容',
        imageUrls: [],
        videoUrl: 'https://media.w3.org/2010/05/sintel/trailer.mp4',
        likeCount: 5,
        commentCount: 3,
      ),
      Moment(
        name: 'User',
        avatarUrl: 'https://qnm.hunliji.com/o_1gjo5pg1uf9a161f8410i6v2n8n.jpg',
        text: '这是动态的文字内容',
        imageUrls: [
          'https://cdn.pixabay.com/photo/2023/03/06/17/02/ship-7833921_1280.jpg',
          'https://cdn.pixabay.com/photo/2023/08/13/14/42/mountain-8187621_1280.jpg',
          'https://cdn.pixabay.com/photo/2023/08/20/20/03/planes-8203121_1280.jpg',
          'https://cdn.pixabay.com/photo/2023/03/06/17/02/ship-7833921_1280.jpg',
          'https://cdn.pixabay.com/photo/2023/08/13/14/42/mountain-8187621_1280.jpg',
          'https://cdn.pixabay.com/photo/2023/08/20/20/03/planes-8203121_1280.jpg',
          'https://cdn.pixabay.com/photo/2023/03/06/17/02/ship-7833921_1280.jpg',
          'https://cdn.pixabay.com/photo/2023/08/13/14/42/mountain-8187621_1280.jpg',
          'https://cdn.pixabay.com/photo/2023/03/06/17/02/ship-7833921_1280.jpg',
        ],
        videoUrl: '',
        likeCount: 5,
        commentCount: 3,
      ),
      Moment(
        name: 'User',
        avatarUrl: 'https://qnm.hunliji.com/o_1gjo5pg1uf9a161f8410i6v2n8n.jpg',
        text: '你欠缺的也许并不是能力',
        imageUrls: [],
        videoUrl:
            'https://mov.bn.netease.com/open-movie/nos/mp4/2016/06/22/SBP8G92E3_hd.mp4',
        likeCount: 5,
        commentCount: 3,
      ),
      Moment(
        name: 'User',
        avatarUrl: 'https://qnm.hunliji.com/o_1gjo5pg1uf9a161f8410i6v2n8n.jpg',
        text: '这是动态的文字内容',
        imageUrls: [
          'https://cdn.pixabay.com/photo/2023/03/06/17/02/ship-7833921_1280.jpg',
          'https://cdn.pixabay.com/photo/2023/08/13/14/42/mountain-8187621_1280.jpg',
          'https://cdn.pixabay.com/photo/2023/08/20/20/03/planes-8203121_1280.jpg',
          'https://cdn.pixabay.com/photo/2023/03/06/17/02/ship-7833921_1280.jpg',
          'https://cdn.pixabay.com/photo/2023/08/13/14/42/mountain-8187621_1280.jpg',
          'https://cdn.pixabay.com/photo/2023/08/20/20/03/planes-8203121_1280.jpg',
          'https://cdn.pixabay.com/photo/2023/03/06/17/02/ship-7833921_1280.jpg',
          'https://cdn.pixabay.com/photo/2023/08/13/14/42/mountain-8187621_1280.jpg',
          'https://cdn.pixabay.com/photo/2023/03/06/17/02/ship-7833921_1280.jpg',
        ],
        videoUrl: '',
        likeCount: 5,
        commentCount: 3,
      ),
      Moment(
        name: 'User',
        avatarUrl: 'https://qnm.hunliji.com/o_1gjo5pg1uf9a161f8410i6v2n8n.jpg',
        text: '坚持与放弃',
        imageUrls: [],
        videoUrl:
            'https://mov.bn.netease.com/open-movie/nos/mp4/2015/08/27/SB13F5AGJ_sd.mp4',
        likeCount: 5,
        commentCount: 3,
      ),
      Moment(
        name: 'User',
        avatarUrl: 'https://qnm.hunliji.com/o_1gjo5pg1uf9a161f8410i6v2n8n.jpg',
        text: '这是动态的文字内容',
        imageUrls: [
          'https://cdn.pixabay.com/photo/2023/03/06/17/02/ship-7833921_1280.jpg',
          'https://cdn.pixabay.com/photo/2023/08/13/14/42/mountain-8187621_1280.jpg',
          'https://cdn.pixabay.com/photo/2023/08/20/20/03/planes-8203121_1280.jpg',
          'https://cdn.pixabay.com/photo/2023/03/06/17/02/ship-7833921_1280.jpg',
          'https://cdn.pixabay.com/photo/2023/08/13/14/42/mountain-8187621_1280.jpg',
          'https://cdn.pixabay.com/photo/2023/08/20/20/03/planes-8203121_1280.jpg',
          'https://cdn.pixabay.com/photo/2023/03/06/17/02/ship-7833921_1280.jpg',
          'https://cdn.pixabay.com/photo/2023/08/13/14/42/mountain-8187621_1280.jpg',
          'https://cdn.pixabay.com/photo/2023/03/06/17/02/ship-7833921_1280.jpg',
        ],
        videoUrl: '',
        likeCount: 5,
        commentCount: 3,
      ),
      Moment(
        name: 'User',
        avatarUrl: 'https://qnm.hunliji.com/o_1gjo5pg1uf9a161f8410i6v2n8n.jpg',
        text: '不想从被子里出来',
        imageUrls: [],
        videoUrl:
            'https://mov.bn.netease.com/open-movie/nos/mp4/2018/01/12/SD70VQJ74_sd.mp4',
        likeCount: 5,
        commentCount: 3,
      ),
      Moment(
        name: 'User',
        avatarUrl: 'https://qnm.hunliji.com/o_1gjo5pg1uf9a161f8410i6v2n8n.jpg',
        text: '这是动态的文字内容',
        imageUrls: [
          'https://cdn.pixabay.com/photo/2023/03/06/17/02/ship-7833921_1280.jpg',
          'https://cdn.pixabay.com/photo/2023/08/13/14/42/mountain-8187621_1280.jpg',
          'https://cdn.pixabay.com/photo/2023/08/20/20/03/planes-8203121_1280.jpg',
          'https://cdn.pixabay.com/photo/2023/03/06/17/02/ship-7833921_1280.jpg',
          'https://cdn.pixabay.com/photo/2023/08/13/14/42/mountain-8187621_1280.jpg',
          'https://cdn.pixabay.com/photo/2023/08/20/20/03/planes-8203121_1280.jpg',
          'https://cdn.pixabay.com/photo/2023/03/06/17/02/ship-7833921_1280.jpg',
          'https://cdn.pixabay.com/photo/2023/08/13/14/42/mountain-8187621_1280.jpg',
          'https://cdn.pixabay.com/photo/2023/03/06/17/02/ship-7833921_1280.jpg',
        ],
        videoUrl: '',
        likeCount: 5,
        commentCount: 3,
      ),
      Moment(
        name: 'User',
        avatarUrl: 'https://qnm.hunliji.com/o_1gjo5pg1uf9a161f8410i6v2n8n.jpg',
        text: '不耐烦的中国人?',
        imageUrls: [],
        videoUrl:
            'https://mov.bn.netease.com/open-movie/nos/mp4/2017/05/31/SCKR8V6E9_hd.mp4',
        likeCount: 5,
        commentCount: 3,
      ),
      Moment(
        name: 'User',
        avatarUrl: 'https://qnm.hunliji.com/o_1gjo5pg1uf9a161f8410i6v2n8n.jpg',
        text: '这是动态的文字内容',
        imageUrls: [
          'https://cdn.pixabay.com/photo/2023/03/06/17/02/ship-7833921_1280.jpg',
          'https://cdn.pixabay.com/photo/2023/08/13/14/42/mountain-8187621_1280.jpg',
          'https://cdn.pixabay.com/photo/2023/08/20/20/03/planes-8203121_1280.jpg',
          'https://cdn.pixabay.com/photo/2023/03/06/17/02/ship-7833921_1280.jpg',
          'https://cdn.pixabay.com/photo/2023/08/13/14/42/mountain-8187621_1280.jpg',
          'https://cdn.pixabay.com/photo/2023/08/20/20/03/planes-8203121_1280.jpg',
          'https://cdn.pixabay.com/photo/2023/03/06/17/02/ship-7833921_1280.jpg',
          'https://cdn.pixabay.com/photo/2023/08/13/14/42/mountain-8187621_1280.jpg',
          'https://cdn.pixabay.com/photo/2023/03/06/17/02/ship-7833921_1280.jpg',
        ],
        videoUrl: '',
        likeCount: 5,
        commentCount: 3,
      ),
      Moment(
        name: 'User',
        avatarUrl: 'https://qnm.hunliji.com/o_1gjo5pg1uf9a161f8410i6v2n8n.jpg',
        text: '神奇的珊瑚',
        imageUrls: [],
        videoUrl:
            'https://mov.bn.netease.com/open-movie/nos/mp4/2016/01/11/SBC46Q9DV_hd.mp4',
        likeCount: 5,
        commentCount: 3,
      ),
      Moment(
        name: 'User',
        avatarUrl: 'https://qnm.hunliji.com/o_1gjo5pg1uf9a161f8410i6v2n8n.jpg',
        text: '这是动态的文字内容',
        imageUrls: [
          'https://cdn.pixabay.com/photo/2023/03/06/17/02/ship-7833921_1280.jpg',
          'https://cdn.pixabay.com/photo/2023/08/13/14/42/mountain-8187621_1280.jpg',
          'https://cdn.pixabay.com/photo/2023/08/20/20/03/planes-8203121_1280.jpg',
          'https://cdn.pixabay.com/photo/2023/03/06/17/02/ship-7833921_1280.jpg',
          'https://cdn.pixabay.com/photo/2023/08/13/14/42/mountain-8187621_1280.jpg',
          'https://cdn.pixabay.com/photo/2023/08/20/20/03/planes-8203121_1280.jpg',
          'https://cdn.pixabay.com/photo/2023/03/06/17/02/ship-7833921_1280.jpg',
          'https://cdn.pixabay.com/photo/2023/08/13/14/42/mountain-8187621_1280.jpg',
          'https://cdn.pixabay.com/photo/2023/03/06/17/02/ship-7833921_1280.jpg',
        ],
        videoUrl: '',
        likeCount: 5,
        commentCount: 3,
      ),
      Moment(
        name: 'User',
        avatarUrl: 'https://qnm.hunliji.com/o_1gjo5pg1uf9a161f8410i6v2n8n.jpg',
        text: '怎样经营你的人脉',
        imageUrls: [],
        videoUrl:
            'https://mov.bn.netease.com/open-movie/nos/mp4/2018/04/19/SDEQS1GO6_hd.mp4',
        likeCount: 5,
        commentCount: 3,
      ),
      Moment(
        name: 'User',
        avatarUrl: 'https://qnm.hunliji.com/o_1gjo5pg1uf9a161f8410i6v2n8n.jpg',
        text: '这是动态的文字内容',
        imageUrls: [
          'https://cdn.pixabay.com/photo/2023/03/06/17/02/ship-7833921_1280.jpg',
          'https://cdn.pixabay.com/photo/2023/08/13/14/42/mountain-8187621_1280.jpg',
          'https://cdn.pixabay.com/photo/2023/08/20/20/03/planes-8203121_1280.jpg',
          'https://cdn.pixabay.com/photo/2023/03/06/17/02/ship-7833921_1280.jpg',
          'https://cdn.pixabay.com/photo/2023/08/13/14/42/mountain-8187621_1280.jpg',
          'https://cdn.pixabay.com/photo/2023/08/20/20/03/planes-8203121_1280.jpg',
          'https://cdn.pixabay.com/photo/2023/03/06/17/02/ship-7833921_1280.jpg',
          'https://cdn.pixabay.com/photo/2023/08/13/14/42/mountain-8187621_1280.jpg',
          'https://cdn.pixabay.com/photo/2023/03/06/17/02/ship-7833921_1280.jpg',
        ],
        videoUrl: '',
        likeCount: 5,
        commentCount: 3,
      ),
      Moment(
        name: 'User',
        avatarUrl: 'https://qnm.hunliji.com/o_1gjo5pg1uf9a161f8410i6v2n8n.jpg',
        text: '音乐和艺术如何改变世界',
        imageUrls: [],
        videoUrl:
            'https://mov.bn.netease.com/open-movie/nos/mp4/2017/12/04/SD3SUEFFQ_hd.mp4',
        likeCount: 5,
        commentCount: 3,
      ),
    ];
  }

  @override
  void dispose() {
    _statusBarColor(true);
    _scrollController.dispose();
    super.dispose();
  }

  void _statusBarColor(bool dark) {
    if (dark) {
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark,
      ));
    } else {
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light,
      ));
    }
  }

  void _statusBarHide() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.bottom]);
    setState(() {});
  }

  void _statusBarShow() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        controller: _scrollController,
        slivers: [
          SliverAppBar(
            elevation: 0,
            expandedHeight: 300,
            backgroundColor: Colors.white,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: _isAppBarCollapse ? Colors.black : Colors.white,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            actions: [
              IconButton(
                icon: Icon(
                  Icons.photo_camera,
                  color: _isAppBarCollapse ? Colors.black : Colors.white,
                ),
                onPressed: () {},
              )
            ],
            title: _isAppBarCollapse
                ? const Text(
                    '朋友圈',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  )
                : null,
            centerTitle: true,
            systemOverlayStyle: _isAppBarCollapse
                ? const SystemUiOverlayStyle(
                    statusBarIconBrightness: Brightness.dark)
                : const SystemUiOverlayStyle(
                    statusBarIconBrightness: Brightness.light),
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.pin,
              background: Image.network(
                'https://cdn.pixabay.com/photo/2023/03/06/17/02/ship-7833921_1280.jpg',
                fit: BoxFit.cover,
              ),
            ),
            floating: false,
            snap: false,
            pinned: true,
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return Column(
                  children: [
                    MomentItem(moment: moments[index], itemIndex: index),
                    const Divider(
                      height: 0.5,
                      color: Colors.grey,
                    ),
                  ],
                );
              },
              childCount: moments.length,
            ),
          ),
        ],
      ),
    );
  }
}

class WeChatMomentsPage2 extends StatefulWidget {
  @override
  _WeChatMomentsPage2State createState() => _WeChatMomentsPage2State();
}

class _WeChatMomentsPage2State extends State<WeChatMomentsPage2> {
  final ScrollController _scrollController = ScrollController();
  final double _imgNormalHeight = 300;
  double _imgExtraHeight = 0;
  double _imgChangeHeight = 0;
  double _scrollMinOffSet = 0;
  double _navH = 0;
  double _appbarOpacity = 0.0;
  bool _isAppBarCollapse = false;

  var moments = <Moment>[
    Moment(
      name: 'User',
      avatarUrl: 'https://qnm.hunliji.com/o_1gjo5pg1uf9a161f8410i6v2n8n.jpg',
      text: '这是动态的文字内容',
      imageUrls: [
        'https://cdn.pixabay.com/photo/2023/08/20/20/03/planes-8203121_1280.jpg',
        'https://cdn.pixabay.com/photo/2023/03/06/17/02/ship-7833921_1280.jpg',
        'https://cdn.pixabay.com/photo/2023/08/13/14/42/mountain-8187621_1280.jpg'
      ],
      videoUrl: '',
      likeCount: 5,
      commentCount: 3,
    ),
    Moment(
      name: 'User',
      avatarUrl: 'https://qnm.hunliji.com/o_1gjo5pg1uf9a161f8410i6v2n8n.jpg',
      text: '这是动态的文字内容',
      imageUrls: [],
      videoUrl: 'https://jomin-web.web.app/resource/video/video_iu.mp4',
      likeCount: 5,
      commentCount: 3,
    ),
    Moment(
      name: 'User',
      avatarUrl: 'https://qnm.hunliji.com/o_1gjo5pg1uf9a161f8410i6v2n8n.jpg',
      text: '这是动态的文字内容',
      imageUrls: [
        'https://cdn.pixabay.com/photo/2023/08/13/14/42/mountain-8187621_1280.jpg',
        'https://cdn.pixabay.com/photo/2023/08/20/20/03/planes-8203121_1280.jpg',
        'https://cdn.pixabay.com/photo/2023/03/06/17/02/ship-7833921_1280.jpg',
        'https://cdn.pixabay.com/photo/2023/08/13/14/42/mountain-8187621_1280.jpg',
      ],
      videoUrl: '',
      likeCount: 5,
      commentCount: 3,
    ),
    Moment(
      name: 'User',
      avatarUrl: 'https://qnm.hunliji.com/o_1gjo5pg1uf9a161f8410i6v2n8n.jpg',
      text: '这是动态的文字内容',
      imageUrls: [
        'https://cdn.pixabay.com/photo/2023/08/20/20/03/planes-8203121_1280.jpg',
        'https://cdn.pixabay.com/photo/2023/03/06/17/02/ship-7833921_1280.jpg',
        'https://cdn.pixabay.com/photo/2023/08/13/14/42/mountain-8187621_1280.jpg',
        'https://cdn.pixabay.com/photo/2023/08/20/20/03/planes-8203121_1280.jpg',
        'https://cdn.pixabay.com/photo/2023/03/06/17/02/ship-7833921_1280.jpg',
      ],
      videoUrl: '',
      likeCount: 5,
      commentCount: 3,
    ),
    Moment(
      name: 'User',
      avatarUrl: 'https://qnm.hunliji.com/o_1gjo5pg1uf9a161f8410i6v2n8n.jpg',
      text: '这是动态的文字内容',
      imageUrls: [],
      videoUrl: 'https://static.ybhospital.net/test-video-2.mp4',
      likeCount: 5,
      commentCount: 3,
    ),
    Moment(
      name: 'User',
      avatarUrl: 'https://qnm.hunliji.com/o_1gjo5pg1uf9a161f8410i6v2n8n.jpg',
      text: '这是动态的文字内容',
      imageUrls: [
        'https://cdn.pixabay.com/photo/2023/08/20/20/03/planes-8203121_1280.jpg',
        'https://cdn.pixabay.com/photo/2023/03/06/17/02/ship-7833921_1280.jpg',
      ],
      videoUrl: '',
      likeCount: 5,
      commentCount: 3,
    ),
    Moment(
      name: 'User',
      avatarUrl: 'https://qnm.hunliji.com/o_1gjo5pg1uf9a161f8410i6v2n8n.jpg',
      text: '这是动态的文字内容',
      imageUrls: [],
      videoUrl: 'https://static.ybhospital.net/test-video-4.mp4',
      likeCount: 5,
      commentCount: 3,
    ),
    Moment(
      name: 'User',
      avatarUrl: 'https://qnm.hunliji.com/o_1gjo5pg1uf9a161f8410i6v2n8n.jpg',
      text: '这是动态的文字内容',
      imageUrls: [
        'https://cdn.pixabay.com/photo/2023/08/20/20/03/planes-8203121_1280.jpg',
        'https://cdn.pixabay.com/photo/2023/03/06/17/02/ship-7833921_1280.jpg',
        'https://cdn.pixabay.com/photo/2023/08/13/14/42/mountain-8187621_1280.jpg',
        'https://cdn.pixabay.com/photo/2023/08/20/20/03/planes-8203121_1280.jpg',
        'https://cdn.pixabay.com/photo/2023/03/06/17/02/ship-7833921_1280.jpg',
        'https://cdn.pixabay.com/photo/2023/08/13/14/42/mountain-8187621_1280.jpg',
      ],
      videoUrl: '',
      likeCount: 5,
      commentCount: 3,
    ),
    Moment(
      name: 'User',
      avatarUrl: 'https://qnm.hunliji.com/o_1gjo5pg1uf9a161f8410i6v2n8n.jpg',
      text: '这是动态的文字内容',
      imageUrls: [],
      videoUrl: 'https://static.ybhospital.net/test-video-5.mp4',
      likeCount: 5,
      commentCount: 3,
    ),
    Moment(
      name: 'User',
      avatarUrl: 'https://qnm.hunliji.com/o_1gjo5pg1uf9a161f8410i6v2n8n.jpg',
      text: '这是动态的文字内容',
      imageUrls: [
        'https://cdn.pixabay.com/photo/2023/08/20/20/03/planes-8203121_1280.jpg',
        'https://cdn.pixabay.com/photo/2023/03/06/17/02/ship-7833921_1280.jpg',
        'https://cdn.pixabay.com/photo/2023/08/13/14/42/mountain-8187621_1280.jpg',
        'https://cdn.pixabay.com/photo/2023/08/20/20/03/planes-8203121_1280.jpg',
        'https://cdn.pixabay.com/photo/2023/03/06/17/02/ship-7833921_1280.jpg',
        'https://cdn.pixabay.com/photo/2023/08/13/14/42/mountain-8187621_1280.jpg',
        'https://cdn.pixabay.com/photo/2023/08/20/20/03/planes-8203121_1280.jpg',
      ],
      videoUrl: '',
      likeCount: 5,
      commentCount: 3,
    ),
    Moment(
      name: 'User',
      avatarUrl: 'https://qnm.hunliji.com/o_1gjo5pg1uf9a161f8410i6v2n8n.jpg',
      text: '这是动态的文字内容',
      imageUrls: [],
      videoUrl: 'https://static.ybhospital.net/test-video-3.mp4',
      likeCount: 5,
      commentCount: 3,
    ),
    Moment(
      name: 'User',
      avatarUrl: 'https://qnm.hunliji.com/o_1gjo5pg1uf9a161f8410i6v2n8n.jpg',
      text: '这是动态的文字内容',
      imageUrls: [
        'https://cdn.pixabay.com/photo/2023/03/06/17/02/ship-7833921_1280.jpg',
        'https://cdn.pixabay.com/photo/2023/08/13/14/42/mountain-8187621_1280.jpg',
        'https://cdn.pixabay.com/photo/2023/08/20/20/03/planes-8203121_1280.jpg',
        'https://cdn.pixabay.com/photo/2023/03/06/17/02/ship-7833921_1280.jpg',
        'https://cdn.pixabay.com/photo/2023/08/13/14/42/mountain-8187621_1280.jpg',
        'https://cdn.pixabay.com/photo/2023/08/20/20/03/planes-8203121_1280.jpg',
        'https://cdn.pixabay.com/photo/2023/03/06/17/02/ship-7833921_1280.jpg',
        'https://cdn.pixabay.com/photo/2023/08/13/14/42/mountain-8187621_1280.jpg'
      ],
      videoUrl: '',
      likeCount: 5,
      commentCount: 3,
    ),
    Moment(
      name: 'User',
      avatarUrl: 'https://qnm.hunliji.com/o_1gjo5pg1uf9a161f8410i6v2n8n.jpg',
      text: '这是动态的文字内容',
      imageUrls: [],
      videoUrl: 'https://static.ybhospital.net/test-video-6.mp4',
      likeCount: 5,
      commentCount: 3,
    ),
    Moment(
      name: 'User',
      avatarUrl: 'https://qnm.hunliji.com/o_1gjo5pg1uf9a161f8410i6v2n8n.jpg',
      text: '这是动态的文字内容',
      imageUrls: [
        'https://cdn.pixabay.com/photo/2023/03/06/17/02/ship-7833921_1280.jpg',
        'https://cdn.pixabay.com/photo/2023/08/13/14/42/mountain-8187621_1280.jpg',
        'https://cdn.pixabay.com/photo/2023/08/20/20/03/planes-8203121_1280.jpg',
        'https://cdn.pixabay.com/photo/2023/03/06/17/02/ship-7833921_1280.jpg',
        'https://cdn.pixabay.com/photo/2023/08/13/14/42/mountain-8187621_1280.jpg',
        'https://cdn.pixabay.com/photo/2023/08/20/20/03/planes-8203121_1280.jpg',
        'https://cdn.pixabay.com/photo/2023/03/06/17/02/ship-7833921_1280.jpg',
        'https://cdn.pixabay.com/photo/2023/08/13/14/42/mountain-8187621_1280.jpg',
        'https://cdn.pixabay.com/photo/2023/03/06/17/02/ship-7833921_1280.jpg',
      ],
      videoUrl: '',
      likeCount: 5,
      commentCount: 3,
    ),
    Moment(
      name: 'User',
      avatarUrl: 'https://qnm.hunliji.com/o_1gjo5pg1uf9a161f8410i6v2n8n.jpg',
      text: '这是动态的文字内容',
      imageUrls: [],
      videoUrl: 'http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4',
      likeCount: 5,
      commentCount: 3,
    ),
    Moment(
      name: 'User',
      avatarUrl: 'https://qnm.hunliji.com/o_1gjo5pg1uf9a161f8410i6v2n8n.jpg',
      text: '这是动态的文字内容',
      imageUrls: [
        'https://cdn.pixabay.com/photo/2023/03/06/17/02/ship-7833921_1280.jpg',
        'https://cdn.pixabay.com/photo/2023/08/13/14/42/mountain-8187621_1280.jpg',
        'https://cdn.pixabay.com/photo/2023/08/20/20/03/planes-8203121_1280.jpg',
        'https://cdn.pixabay.com/photo/2023/03/06/17/02/ship-7833921_1280.jpg',
        'https://cdn.pixabay.com/photo/2023/08/13/14/42/mountain-8187621_1280.jpg',
        'https://cdn.pixabay.com/photo/2023/08/20/20/03/planes-8203121_1280.jpg',
        'https://cdn.pixabay.com/photo/2023/03/06/17/02/ship-7833921_1280.jpg',
        'https://cdn.pixabay.com/photo/2023/08/13/14/42/mountain-8187621_1280.jpg',
        'https://cdn.pixabay.com/photo/2023/03/06/17/02/ship-7833921_1280.jpg',
      ],
      videoUrl: '',
      likeCount: 5,
      commentCount: 3,
    ),
    Moment(
      name: 'User',
      avatarUrl: 'https://qnm.hunliji.com/o_1gjo5pg1uf9a161f8410i6v2n8n.jpg',
      text: '这是动态的文字内容',
      imageUrls: [],
      videoUrl: 'http://vjs.zencdn.net/v/oceans.mp4',
      likeCount: 5,
      commentCount: 3,
    ),
    Moment(
      name: 'User',
      avatarUrl: 'https://qnm.hunliji.com/o_1gjo5pg1uf9a161f8410i6v2n8n.jpg',
      text: '这是动态的文字内容',
      imageUrls: [
        'https://cdn.pixabay.com/photo/2023/03/06/17/02/ship-7833921_1280.jpg',
        'https://cdn.pixabay.com/photo/2023/08/13/14/42/mountain-8187621_1280.jpg',
        'https://cdn.pixabay.com/photo/2023/08/20/20/03/planes-8203121_1280.jpg',
        'https://cdn.pixabay.com/photo/2023/03/06/17/02/ship-7833921_1280.jpg',
        'https://cdn.pixabay.com/photo/2023/08/13/14/42/mountain-8187621_1280.jpg',
        'https://cdn.pixabay.com/photo/2023/08/20/20/03/planes-8203121_1280.jpg',
        'https://cdn.pixabay.com/photo/2023/03/06/17/02/ship-7833921_1280.jpg',
        'https://cdn.pixabay.com/photo/2023/08/13/14/42/mountain-8187621_1280.jpg',
        'https://cdn.pixabay.com/photo/2023/03/06/17/02/ship-7833921_1280.jpg',
      ],
      videoUrl: '',
      likeCount: 5,
      commentCount: 3,
    ),
    Moment(
      name: 'User',
      avatarUrl: 'https://qnm.hunliji.com/o_1gjo5pg1uf9a161f8410i6v2n8n.jpg',
      text: '这是动态的文字内容',
      imageUrls: [],
      videoUrl: 'https://media.w3.org/2010/05/sintel/trailer.mp4',
      likeCount: 5,
      commentCount: 3,
    ),
    Moment(
      name: 'User',
      avatarUrl: 'https://qnm.hunliji.com/o_1gjo5pg1uf9a161f8410i6v2n8n.jpg',
      text: '这是动态的文字内容',
      imageUrls: [
        'https://cdn.pixabay.com/photo/2023/03/06/17/02/ship-7833921_1280.jpg',
        'https://cdn.pixabay.com/photo/2023/08/13/14/42/mountain-8187621_1280.jpg',
        'https://cdn.pixabay.com/photo/2023/08/20/20/03/planes-8203121_1280.jpg',
        'https://cdn.pixabay.com/photo/2023/03/06/17/02/ship-7833921_1280.jpg',
        'https://cdn.pixabay.com/photo/2023/08/13/14/42/mountain-8187621_1280.jpg',
        'https://cdn.pixabay.com/photo/2023/08/20/20/03/planes-8203121_1280.jpg',
        'https://cdn.pixabay.com/photo/2023/03/06/17/02/ship-7833921_1280.jpg',
        'https://cdn.pixabay.com/photo/2023/08/13/14/42/mountain-8187621_1280.jpg',
        'https://cdn.pixabay.com/photo/2023/03/06/17/02/ship-7833921_1280.jpg',
      ],
      videoUrl: '',
      likeCount: 5,
      commentCount: 3,
    ),
    Moment(
      name: 'User',
      avatarUrl: 'https://qnm.hunliji.com/o_1gjo5pg1uf9a161f8410i6v2n8n.jpg',
      text: '你欠缺的也许并不是能力',
      imageUrls: [],
      videoUrl:
          'https://mov.bn.netease.com/open-movie/nos/mp4/2016/06/22/SBP8G92E3_hd.mp4',
      likeCount: 5,
      commentCount: 3,
    ),
    Moment(
      name: 'User',
      avatarUrl: 'https://qnm.hunliji.com/o_1gjo5pg1uf9a161f8410i6v2n8n.jpg',
      text: '这是动态的文字内容',
      imageUrls: [
        'https://cdn.pixabay.com/photo/2023/03/06/17/02/ship-7833921_1280.jpg',
        'https://cdn.pixabay.com/photo/2023/08/13/14/42/mountain-8187621_1280.jpg',
        'https://cdn.pixabay.com/photo/2023/08/20/20/03/planes-8203121_1280.jpg',
        'https://cdn.pixabay.com/photo/2023/03/06/17/02/ship-7833921_1280.jpg',
        'https://cdn.pixabay.com/photo/2023/08/13/14/42/mountain-8187621_1280.jpg',
        'https://cdn.pixabay.com/photo/2023/08/20/20/03/planes-8203121_1280.jpg',
        'https://cdn.pixabay.com/photo/2023/03/06/17/02/ship-7833921_1280.jpg',
        'https://cdn.pixabay.com/photo/2023/08/13/14/42/mountain-8187621_1280.jpg',
        'https://cdn.pixabay.com/photo/2023/03/06/17/02/ship-7833921_1280.jpg',
      ],
      videoUrl: '',
      likeCount: 5,
      commentCount: 3,
    ),
    Moment(
      name: 'User',
      avatarUrl: 'https://qnm.hunliji.com/o_1gjo5pg1uf9a161f8410i6v2n8n.jpg',
      text: '坚持与放弃',
      imageUrls: [],
      videoUrl:
          'https://mov.bn.netease.com/open-movie/nos/mp4/2015/08/27/SB13F5AGJ_sd.mp4',
      likeCount: 5,
      commentCount: 3,
    ),
    Moment(
      name: 'User',
      avatarUrl: 'https://qnm.hunliji.com/o_1gjo5pg1uf9a161f8410i6v2n8n.jpg',
      text: '这是动态的文字内容',
      imageUrls: [
        'https://cdn.pixabay.com/photo/2023/03/06/17/02/ship-7833921_1280.jpg',
        'https://cdn.pixabay.com/photo/2023/08/13/14/42/mountain-8187621_1280.jpg',
        'https://cdn.pixabay.com/photo/2023/08/20/20/03/planes-8203121_1280.jpg',
        'https://cdn.pixabay.com/photo/2023/03/06/17/02/ship-7833921_1280.jpg',
        'https://cdn.pixabay.com/photo/2023/08/13/14/42/mountain-8187621_1280.jpg',
        'https://cdn.pixabay.com/photo/2023/08/20/20/03/planes-8203121_1280.jpg',
        'https://cdn.pixabay.com/photo/2023/03/06/17/02/ship-7833921_1280.jpg',
        'https://cdn.pixabay.com/photo/2023/08/13/14/42/mountain-8187621_1280.jpg',
        'https://cdn.pixabay.com/photo/2023/03/06/17/02/ship-7833921_1280.jpg',
      ],
      videoUrl: '',
      likeCount: 5,
      commentCount: 3,
    ),
    Moment(
      name: 'User',
      avatarUrl: 'https://qnm.hunliji.com/o_1gjo5pg1uf9a161f8410i6v2n8n.jpg',
      text: '不想从被子里出来',
      imageUrls: [],
      videoUrl:
          'https://mov.bn.netease.com/open-movie/nos/mp4/2018/01/12/SD70VQJ74_sd.mp4',
      likeCount: 5,
      commentCount: 3,
    ),
    Moment(
      name: 'User',
      avatarUrl: 'https://qnm.hunliji.com/o_1gjo5pg1uf9a161f8410i6v2n8n.jpg',
      text: '这是动态的文字内容',
      imageUrls: [
        'https://cdn.pixabay.com/photo/2023/03/06/17/02/ship-7833921_1280.jpg',
        'https://cdn.pixabay.com/photo/2023/08/13/14/42/mountain-8187621_1280.jpg',
        'https://cdn.pixabay.com/photo/2023/08/20/20/03/planes-8203121_1280.jpg',
        'https://cdn.pixabay.com/photo/2023/03/06/17/02/ship-7833921_1280.jpg',
        'https://cdn.pixabay.com/photo/2023/08/13/14/42/mountain-8187621_1280.jpg',
        'https://cdn.pixabay.com/photo/2023/08/20/20/03/planes-8203121_1280.jpg',
        'https://cdn.pixabay.com/photo/2023/03/06/17/02/ship-7833921_1280.jpg',
        'https://cdn.pixabay.com/photo/2023/08/13/14/42/mountain-8187621_1280.jpg',
        'https://cdn.pixabay.com/photo/2023/03/06/17/02/ship-7833921_1280.jpg',
      ],
      videoUrl: '',
      likeCount: 5,
      commentCount: 3,
    ),
    Moment(
      name: 'User',
      avatarUrl: 'https://qnm.hunliji.com/o_1gjo5pg1uf9a161f8410i6v2n8n.jpg',
      text: '不耐烦的中国人?',
      imageUrls: [],
      videoUrl:
          'https://mov.bn.netease.com/open-movie/nos/mp4/2017/05/31/SCKR8V6E9_hd.mp4',
      likeCount: 5,
      commentCount: 3,
    ),
    Moment(
      name: 'User',
      avatarUrl: 'https://qnm.hunliji.com/o_1gjo5pg1uf9a161f8410i6v2n8n.jpg',
      text: '这是动态的文字内容',
      imageUrls: [
        'https://cdn.pixabay.com/photo/2023/03/06/17/02/ship-7833921_1280.jpg',
        'https://cdn.pixabay.com/photo/2023/08/13/14/42/mountain-8187621_1280.jpg',
        'https://cdn.pixabay.com/photo/2023/08/20/20/03/planes-8203121_1280.jpg',
        'https://cdn.pixabay.com/photo/2023/03/06/17/02/ship-7833921_1280.jpg',
        'https://cdn.pixabay.com/photo/2023/08/13/14/42/mountain-8187621_1280.jpg',
        'https://cdn.pixabay.com/photo/2023/08/20/20/03/planes-8203121_1280.jpg',
        'https://cdn.pixabay.com/photo/2023/03/06/17/02/ship-7833921_1280.jpg',
        'https://cdn.pixabay.com/photo/2023/08/13/14/42/mountain-8187621_1280.jpg',
        'https://cdn.pixabay.com/photo/2023/03/06/17/02/ship-7833921_1280.jpg',
      ],
      videoUrl: '',
      likeCount: 5,
      commentCount: 3,
    ),
    Moment(
      name: 'User',
      avatarUrl: 'https://qnm.hunliji.com/o_1gjo5pg1uf9a161f8410i6v2n8n.jpg',
      text: '神奇的珊瑚',
      imageUrls: [],
      videoUrl:
          'https://mov.bn.netease.com/open-movie/nos/mp4/2016/01/11/SBC46Q9DV_hd.mp4',
      likeCount: 5,
      commentCount: 3,
    ),
    Moment(
      name: 'User',
      avatarUrl: 'https://qnm.hunliji.com/o_1gjo5pg1uf9a161f8410i6v2n8n.jpg',
      text: '这是动态的文字内容',
      imageUrls: [
        'https://cdn.pixabay.com/photo/2023/03/06/17/02/ship-7833921_1280.jpg',
        'https://cdn.pixabay.com/photo/2023/08/13/14/42/mountain-8187621_1280.jpg',
        'https://cdn.pixabay.com/photo/2023/08/20/20/03/planes-8203121_1280.jpg',
        'https://cdn.pixabay.com/photo/2023/03/06/17/02/ship-7833921_1280.jpg',
        'https://cdn.pixabay.com/photo/2023/08/13/14/42/mountain-8187621_1280.jpg',
        'https://cdn.pixabay.com/photo/2023/08/20/20/03/planes-8203121_1280.jpg',
        'https://cdn.pixabay.com/photo/2023/03/06/17/02/ship-7833921_1280.jpg',
        'https://cdn.pixabay.com/photo/2023/08/13/14/42/mountain-8187621_1280.jpg',
        'https://cdn.pixabay.com/photo/2023/03/06/17/02/ship-7833921_1280.jpg',
      ],
      videoUrl: '',
      likeCount: 5,
      commentCount: 3,
    ),
    Moment(
      name: 'User',
      avatarUrl: 'https://qnm.hunliji.com/o_1gjo5pg1uf9a161f8410i6v2n8n.jpg',
      text: '怎样经营你的人脉',
      imageUrls: [],
      videoUrl:
          'https://mov.bn.netease.com/open-movie/nos/mp4/2018/04/19/SDEQS1GO6_hd.mp4',
      likeCount: 5,
      commentCount: 3,
    ),
    Moment(
      name: 'User',
      avatarUrl: 'https://qnm.hunliji.com/o_1gjo5pg1uf9a161f8410i6v2n8n.jpg',
      text: '这是动态的文字内容',
      imageUrls: [
        'https://cdn.pixabay.com/photo/2023/03/06/17/02/ship-7833921_1280.jpg',
        'https://cdn.pixabay.com/photo/2023/08/13/14/42/mountain-8187621_1280.jpg',
        'https://cdn.pixabay.com/photo/2023/08/20/20/03/planes-8203121_1280.jpg',
        'https://cdn.pixabay.com/photo/2023/03/06/17/02/ship-7833921_1280.jpg',
        'https://cdn.pixabay.com/photo/2023/08/13/14/42/mountain-8187621_1280.jpg',
        'https://cdn.pixabay.com/photo/2023/08/20/20/03/planes-8203121_1280.jpg',
        'https://cdn.pixabay.com/photo/2023/03/06/17/02/ship-7833921_1280.jpg',
        'https://cdn.pixabay.com/photo/2023/08/13/14/42/mountain-8187621_1280.jpg',
        'https://cdn.pixabay.com/photo/2023/03/06/17/02/ship-7833921_1280.jpg',
      ],
      videoUrl: '',
      likeCount: 5,
      commentCount: 3,
    ),
    Moment(
      name: 'User',
      avatarUrl: 'https://qnm.hunliji.com/o_1gjo5pg1uf9a161f8410i6v2n8n.jpg',
      text: '音乐和艺术如何改变世界',
      imageUrls: [],
      videoUrl:
          'https://mov.bn.netease.com/open-movie/nos/mp4/2017/12/04/SD3SUEFFQ_hd.mp4',
      likeCount: 5,
      commentCount: 3,
    ),
  ];

  @override
  void initState() {
    super.initState();
    MediaQueryData mediaQuery = MediaQueryData.fromWindow(ui.window);
    _navH = kToolbarHeight + mediaQuery.padding.top;
    _imgChangeHeight = _imgNormalHeight + _imgExtraHeight;
    _scrollMinOffSet = _imgNormalHeight;
    _appbarOpacity = _scrollMinOffSet - _navH - 75;
    _addListener();
  }

  // 滚动监听
  void _addListener() {
    _scrollController.addListener(() {
      double y = _scrollController.offset;
      if (y < _scrollMinOffSet) {
        _imgExtraHeight = -y;
        setState(() {
          _imgChangeHeight = _imgNormalHeight + _imgExtraHeight;
        });
      } else {
        setState(() {
          _imgChangeHeight = 0;
        });
      }
      // appbar 透明度
      //double appBarOpacity = y / _navH;

      setState(() {
        _isAppBarCollapse = y >= _appbarOpacity;
      });
    });
  }

  void _statusBarColor(bool dark) {
    if (dark) {
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark,
      ));
    } else {
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light,
      ));
    }
  }

  @override
  void dispose() {
    super.dispose();
    _statusBarColor(true);
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        ListView.builder(
          controller: _scrollController,
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          itemCount: moments.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
              return SizedBox(width: double.infinity, height: _imgNormalHeight);
            }
            return MomentItem(
              moment: moments[index - 1],
              itemIndex: index - 1,
            );
          },
        ),
        Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: _imgChangeHeight,
            child: _header()),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: AppBar(
            elevation: 0,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: _isAppBarCollapse ? Colors.black : Colors.white,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            actions: [
              IconButton(
                icon: Icon(
                  Icons.photo_camera,
                  color: _isAppBarCollapse ? Colors.black : Colors.white,
                ),
                onPressed: () {},
              )
            ],
            title: _isAppBarCollapse
                ? const Text(
                    '朋友圈',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  )
                : null,
            centerTitle: true,
            backgroundColor:
                _isAppBarCollapse ? Colors.white : Colors.transparent,
            systemOverlayStyle: _isAppBarCollapse
                ? const SystemUiOverlayStyle(
                    statusBarIconBrightness: Brightness.dark)
                : const SystemUiOverlayStyle(
                    statusBarIconBrightness: Brightness.light),
          ),
        ),
      ],
    ));
  }

  Widget _header() {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 20),
          child: Image.network(
            'https://cdn.pixabay.com/photo/2023/03/06/17/02/ship-7833921_1280.jpg',
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          right: 20,
          bottom: 0,
          child: Row(
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                child: const Text(
                  'panghaha',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500),
                ),
              ),
              const SizedBox(width: 20),
              InkWell(
                child: Container(
                  height: 75,
                  width: 75,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: const DecorationImage(
                      fit: BoxFit.fitHeight,
                      image: NetworkImage(
                          'https://qnm.hunliji.com/o_1gjo5pg1uf9a161f8410i6v2n8n.jpg'),
                    ),
                  ),
                ),
                onTap: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class MomentItem extends StatelessWidget {
  final Moment moment;
  final int itemIndex;

  MomentItem({required this.moment, required this.itemIndex});

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40,
          height: 40,
          margin: const EdgeInsets.all(15),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(moment.avatarUrl),
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(0, 13, 15, 0),
                child: Text(moment.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Colors.black,
                    )),
              ),
              Container(
                  margin: const EdgeInsets.fromLTRB(0, 5, 15, 5),
                  child: Text(
                    moment.text,
                    style: const TextStyle(fontSize: 13),
                  )),
              if (moment.imageUrls.length > 0)
                GridView.builder(
                  padding: const EdgeInsets.only(right: 15),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                  ),
                  itemCount: moment.imageUrls.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => FullScreenImagePage(
                              imageUrl: moment.imageUrls[index],
                              tag:
                                  'image_${moment.imageUrls[index]}:index:$index:itemIndex:$itemIndex',
                            ),
                          ),
                        );
                      },
                      child: Hero(
                        tag:
                            'image_${moment.imageUrls[index]}:index:$index:itemIndex:$itemIndex',
                        child: Padding(
                          padding: const EdgeInsets.all(2),
                          child: AspectRatio(
                            aspectRatio: 1,
                            child: Image.network(
                              moment.imageUrls[index],
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                ),
              if (moment.videoUrl.isNotEmpty)
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => FullScreenVideoPage(
                          videoUrl: moment.videoUrl,
                        ),
                      ),
                    );
                  },
                  child: VideoPlayerWidget(videoUrl: moment.videoUrl),
                ),
              Container(
                margin: const EdgeInsets.fromLTRB(0, 15, 15, 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '6分钟前',
                      style: const TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Icon(Icons.thumb_up),
                        const SizedBox(width: 5),
                        Text('${moment.likeCount} 赞'),
                        const SizedBox(width: 10),
                        const Icon(Icons.comment),
                        const SizedBox(width: 5),
                        Text('${moment.commentCount} 评论'),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    ));
  }
}

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;

  VideoPlayerWidget({required this.videoUrl});

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl);
    _initializeVideoPlayerFuture = _controller.initialize().then((_) {
      setState(() {});
      _controller.setLooping(true);
      _controller.play();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initializeVideoPlayerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Container(
              width: 220,
              child: AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.blue,
              ),
            );
          }
        });
  }
}

class FullScreenImagePage extends StatelessWidget {
  final String imageUrl;
  final String tag;

  FullScreenImagePage({required this.imageUrl, required this.tag});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Hero(
            tag: tag,
            child: Image.network(
              imageUrl,
            ),
          ),
        ),
      ),
    );
  }
}

class FullScreenVideoPage extends StatefulWidget {
  final String videoUrl;

  FullScreenVideoPage({required this.videoUrl});

  @override
  _FullScreenVideoPageState createState() => _FullScreenVideoPageState();
}

class _FullScreenVideoPageState extends State<FullScreenVideoPage> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl);
    _initializeVideoPlayerFuture = _controller.initialize().then((_) {
      setState(() {});
      _controller.setLooping(true);
      _controller.play();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: FutureBuilder(
          future: _initializeVideoPlayerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              final screenWidth = MediaQuery.of(context).size.width;
              return Center(
                child: Container(
                  width: screenWidth,
                  child: AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  ),
                ),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.blue,
                ),
              );
            }
          }),
    );
  }
}

class Page1 extends StatefulWidget {
  @override
  _Page1State createState() => _Page1State();
}

class _Page1State extends State with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List tabs = ["推荐", "想法", "热榜"];

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      appBar: AppBar(
        bottom: TabBar(
          unselectedLabelColor: Colors.black38,
          unselectedLabelStyle:
              const TextStyle(fontWeight: FontWeight.normal, fontSize: 17),
          //未选中
          controller: _tabController,
          labelColor: Colors.black,
          labelStyle:
              const TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
          //选中
          indicatorColor: Colors.blue,
          indicatorSize: TabBarIndicatorSize.label,
          indicatorWeight: 3,
          tabs: tabs.map((e) => Tab(text: e)).toList(),
        ),
        elevation: 0.5,
        backgroundColor: Colors.white,
        leading: Builder(builder: (context) {
          return IconButton(
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            icon: const Icon(Icons.list_sharp),
            color: Colors.black,
          );
        }),
        title: const Text('News',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.share,
                color: Colors.black,
              ))
        ],
      ),
      body: TabBarView(
          //构建
          controller: _tabController,
          children: [
            TestList(),
            TestList(),
            TestList2(),
          ]),
    );
  }
}

class TestList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: 10,
        itemBuilder: (BuildContext, index) {
          return ListTile(
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const _Scale()));
            },
            title: Text('未来出行方式的引领者 $index'),
            subtitle: const Text('北京汽车集团有限公司控股的高科技上市公司和绿色智慧出行一体化解决方案提供商.'),
            leading: Image.network(
                'https://www.baicgroup.com.cn/assets/theme/jthink/images/icon-67.png'),
          );
        });
  }
}

class TestList2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: 10,
        itemBuilder: (BuildContext, index) {
          return ListTile(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const _GestureRecognizer()));
            },
            title: Text('NO$index 热门🔥🔥🔥！！！'),
            subtitle: const Text('热河哈哈哈哈哈哈哈哈哈哈哈哈啦啦啦啦啦.'),
            leading: const Icon(Icons.equalizer_sharp),
          );
        });
  }
}

class Page2 extends StatelessWidget {
  final _tabs = <String>[
    "Tab1",
    "Tab2",
    "Tab3",
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 0),
      child: DefaultTabController(
        length: _tabs.length,
        child: NestedScrollView(
          physics: const BouncingScrollPhysics(),
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverOverlapAbsorber(
                handle:
                    NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                sliver: SliverAppBar(
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {},
                  ),
                  title: const Text('标题'),
                  centerTitle: true,
                  pinned: false,
                  floating: false,
                  snap: false,
                  backgroundColor: Colors.lightBlue,
                  expandedHeight: 300,
                  elevation: 4,
                  forceElevated: innerBoxIsScrolled,
                  actions: <Widget>[
                    IconButton(
                      icon: const Icon(Icons.more_horiz),
                      onPressed: () {
                        print("更多");
                      },
                    ),
                  ],
                  flexibleSpace: FlexibleSpaceBar(
                    collapseMode: CollapseMode.pin,
                    background: Image.network(
                        'https://img.win3000.com/m00/55/8b/6bf1b0e0f4a0f47c7660e80a28363460_c_345_458.jpg',
                        fit: BoxFit.cover),
                  ),
                  bottom: TabBar(
                    tabs: _tabs.map((String name) => Tab(text: name)).toList(),
                    unselectedLabelStyle: const TextStyle(
                        fontWeight: FontWeight.normal, fontSize: 17),
                    labelStyle: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 25),
                    indicatorColor: Colors.lightBlue,
                    indicatorSize: TabBarIndicatorSize.label,
                    indicatorWeight: 3,
                  ),
                ),
              ),
            ];
          },
          body: TabBarView(
            children: _tabs.map((String name) {
              return SafeArea(
                top: false,
                bottom: false,
                child: Builder(
                  builder: (BuildContext context) {
                    return CustomScrollView(
                      key: PageStorageKey<String>(name),
                      slivers: <Widget>[
                        SliverOverlapInjector(
                          handle:
                              NestedScrollView.sliverOverlapAbsorberHandleFor(
                                  context),
                        ),
                        SliverPadding(
                          padding: const EdgeInsets.all(10.0),
                          sliver: SliverFixedExtentList(
                            itemExtent: 50.0,
                            delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index) {
                                return ListTile(
                                    title: Text('Item ===> $index'),
                                    onTap: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  ColorPage()));
                                    });
                              },
                              childCount: 30,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

class ColorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            pinned: true,
            title: const Text('Find', style: TextStyle(color: Colors.black)),
            expandedHeight: 300,
            backgroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                'https://img.win3000.com/m00/55/8b/6bf1b0e0f4a0f47c7660e80a28363460_c_345_458.jpg',
                fit: BoxFit.cover,
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(8),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 4),
              delegate:
                  SliverChildBuilderDelegate((BuildContext context, int index) {
                //创建子widget
                return ListTile(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const ScaleAnimationRoute1()));
                  },
                  title: Text('grid item $index'),
                  tileColor: Colors.cyan[100 * (index % 9)],
                );
              }, childCount: 15),
            ),
          ),
          SliverFixedExtentList(
            itemExtent: 50.0,
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                //创建列表项
                return ListTile(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => AnimatedSwitcherCounterRoute()));
                  },
                  title: Text('list item $index'),
                  tileColor: Colors.cyan[100 * (index % 9)],
                );
              },
              childCount: 15,
            ),
          ),
        ],
      ),
    );
  }
}

class ScaleAnimationRoute1 extends StatefulWidget {
  const ScaleAnimationRoute1({Key? key}) : super(key: key);

  @override
  _ScaleAnimationRouteState createState() => _ScaleAnimationRouteState();
}

class _ScaleAnimationRouteState extends State<ScaleAnimationRoute1>
    with SingleTickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController controller;

  @override
  initState() {
    super.initState();
    controller =
        AnimationController(duration: const Duration(seconds: 2), vsync: this);
    animation = Tween(begin: 0.0, end: 300.0).animate(controller);
    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        //动画执行结束时反向执行动画
        controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        //动画恢复到初始状态时执行动画（正向）
        controller.forward();
      }
    });
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
      ),
      body: AnimatedBuilder(
        animation: animation,
        child: Image.network(
            'https://www.baicgroup.com.cn/assets/theme/jthink/images/icon-67.png'),
        builder: (BuildContext ctx, child) {
          return Center(
            child: SizedBox(
              height: animation.value,
              width: animation.value,
              child: child,
            ),
          );
        },
      ),
    );
  }

  @override
  dispose() {
    //路由销毁时需要释放动画资源
    controller.dispose();
    super.dispose();
  }
}

class AnimatedSwitcherCounterRoute extends StatefulWidget {
  @override
  _AnimatedSwitcherCounterRouteState createState() =>
      _AnimatedSwitcherCounterRouteState();
}

class _AnimatedSwitcherCounterRouteState
    extends State<AnimatedSwitcherCounterRoute> {
  int _count = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return SlideTransitionX(
                  direction: AxisDirection.down,
                  position: animation,
                  child: child,
                );
              },
              child: Text(
                '$_count',
                key: ValueKey<int>(_count),
                style: Theme.of(context).textTheme.headline4,
              ),
            ),
            ElevatedButton(
              child: const Text(
                '+1',
              ),
              onPressed: () {
                setState(() {
                  _count += 1;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}

class SlideTransitionX extends AnimatedWidget {
  SlideTransitionX({
    Key? key,
    required Animation<double> position,
    this.transformHitTests = true,
    this.direction = AxisDirection.down,
    required this.child,
  }) : super(key: key, listenable: position) {
    switch (direction) {
      case AxisDirection.up:
        _tween = Tween(begin: const Offset(0, 1), end: const Offset(0, 0));
        break;
      case AxisDirection.right:
        _tween = Tween(begin: const Offset(-1, 0), end: const Offset(0, 0));
        break;
      case AxisDirection.down:
        _tween = Tween(begin: const Offset(0, -1), end: const Offset(0, 0));
        break;
      case AxisDirection.left:
        _tween = Tween(begin: const Offset(1, 0), end: const Offset(0, 0));
        break;
    }
  }

  final bool transformHitTests;

  final Widget child;

  final AxisDirection direction;

  late final Tween<Offset> _tween;

  @override
  Widget build(BuildContext context) {
    final position = listenable as Animation<double>;
    Offset offset = _tween.evaluate(position);
    if (position.status == AnimationStatus.reverse) {
      switch (direction) {
        case AxisDirection.up:
          offset = Offset(offset.dx, -offset.dy);
          break;
        case AxisDirection.right:
          offset = Offset(-offset.dx, offset.dy);
          break;
        case AxisDirection.down:
          offset = Offset(offset.dx, -offset.dy);
          break;
        case AxisDirection.left:
          offset = Offset(-offset.dx, offset.dy);
          break;
      }
    }
    return FractionalTranslation(
      translation: offset,
      transformHitTests: transformHitTests,
      child: child,
    );
  }
}

class Page3 extends StatefulWidget {
  @override
  _Page3State createState() => _Page3State();
}

class _Page3State extends State<Page3> {
  var _themeColor = Colors.teal; //当前路由主题色

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return Theme(
      data: ThemeData(
        primarySwatch: _themeColor,
        iconTheme: IconThemeData(color: _themeColor),
      ),
      child: Scaffold(
        appBar: AppBar(title: const Text("主题测试")),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            //第一行Icon使用主题中的iconTheme
            const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.favorite),
                  Icon(Icons.airport_shuttle),
                  Text("  颜色跟随主题")
                ]),
            //为第二行Icon自定义颜色（固定为黑色)
            Theme(
              data: themeData.copyWith(
                iconTheme: themeData.iconTheme.copyWith(color: Colors.black),
              ),
              child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.favorite),
                    Icon(Icons.airport_shuttle),
                    Text("  颜色固定黑色"),
                  ]),
            ),
            const SizedBox(height: 10),
            const CircularProgressIndicator(),
            const SizedBox(height: 10),
            const LinearProgressIndicator(
              value: 0.7,
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: () => //切换主题
                setState(() => _themeColor =
                    _themeColor == Colors.teal ? Colors.blue : Colors.teal),
            child: const Icon(Icons.palette)),
      ),
    );
  }
}

class Page4 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 25, left: 10, right: 10),
      child: Wrap(
        spacing: 8.0, // 主轴(水平)方向间距
        runSpacing: 4.0, // 纵轴（垂直）方向间距
        alignment: WrapAlignment.center, //沿主轴方向居中

        children: <Widget>[
          ElevatedButton(
            child: const Text("对话框1"),
            onPressed: () async {
              bool? delete = await showDeleteConfirmDialog1(context);
              if (delete == null) {
                print("取消删除");
              } else {
                print("已确认删除");
              }
            },
          ),
          ElevatedButton(
            child: const Text("对话框2"),
            onPressed: () async {
              int? i = await showDialog2(context);
              print(i);
            },
          ),
          ElevatedButton(
            child: const Text("对话框3"),
            onPressed: () async {
              await showListDialog(context);
            },
          ),
          ElevatedButton(
            child: const Text("日历1"),
            onPressed: () async {
              var date = await _showDatePicker1(context);
            },
          ),
          ElevatedButton(
            child: const Text("日历2"),
            onPressed: () async {
              var date = await _showDatePicker2(context);
            },
          ),
          ElevatedButton(
            child: const Text("日历3"),
            onPressed: () async {
              var time = await _showTimePicker3(context);
            },
          ),
          ElevatedButton(
            child: const Text("仿抖音"),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => VideoFullScreenPage()));
            },
          ),
          ElevatedButton(
            child: const Text("仿抖音2"),
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const TikTokPage()));
            },
          ),
          ElevatedButton(
            child: const Text("仿抖音3"),
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const VideoPage()));
            },
          ),
          ElevatedButton(
            child: const Text("视频播放"),
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => VideoPlayPage3()));
            },
          ),
          ElevatedButton(
            child: const Text("VLC 视频播放"),
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => VlcPlayPage()));
            },
          ),
          ElevatedButton(
            child: const Text("LiveStream 直播"),
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => VideoLive()));
            },
          ),
          ElevatedButton(
            child: const Text("动画背景"),
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const HomeScreen()));
            },
          ),
          ElevatedButton(
            child: const Text("朋友圈1"),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => WeChatMomentsPage1()));
            },
          ),
          ElevatedButton(
            child: const Text("朋友圈2"),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => WeChatMomentsPage2()));
            },
          ),
          ElevatedButton(
            child: const Text("滚动视差效果"),
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => ExampleParallax()));
            },
          ),
          ElevatedButton(
            child: const Text("WebSocket"),
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => WebSocketRoute()));
            },
          ),
          ElevatedButton(
            child: const Text("Socket I/O"),
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => SocketRoute()));
            },
          ),
          ElevatedButton(
            child: const Text("拟物化UI 1"),
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => Neumorphic1()));
            },
          ),
          // ElevatedButton(
          //   child: const Text("拟物化UI 夜间模式"),
          //   onPressed: () {
          //     Navigator.of(context)
          //         .push(MaterialPageRoute(builder: (context) => Neumorphic2()));
          //   },
          // ),
          ElevatedButton(
            child: const Text("拟物化UI 2"),
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => Neumorphic3()));
            },
          ),
          ElevatedButton(
            child: const Text("awesome camera 拍照和录像"),
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const CameraPage()));
            },
          ),
          ElevatedButton(
            child: const Text("reply"),
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const HomePage()));
            },
          ),
          ElevatedButton(
            child: const Text("flame game dino"),
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => TRexGameWrapper()));
            },
          ),

          ElevatedButton(
            child: const Text("Tetris game start"),
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => TetrisHomePage()));
            },
          ),

          ElevatedButton(
            child: const Text("netflix ui"),
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => BottomNavigationWidget()));
            },
          ),
          ElevatedButton(
            child: const Text("Login"),
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const LoginScreen()));
            },
          ),

          ElevatedButton(
            child: const Text("Space"),
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const SplashScreen()));
            },
          ),

          ElevatedButton(
            child: const Text("3D 推土机"),
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const Test3DPage(path: 'assets/glb/bulldozers.glb')));
            },
          ),
          ElevatedButton(
            child: const Text("3D 龙猫"),
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const Test3DPage(path: 'assets/glb/Totoro.glb')));
            },
          ),
          ElevatedButton(
            child: const Text("3D 人物"),
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const Test3DPage(path: 'assets/glb/jeff_johansen_idle.glb')));
            },
          ),
          ElevatedButton(
            child: const Text("3D 宇航服"),
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const Test3DPage(path: 'assets/glb/Astronaut.glb')));
            },
          ),
          ElevatedButton(
            child: const Text("3D 机枪"),
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const Test3DPage(path: 'assets/glb/machine_gun.glb')));
            },
          ),

          ElevatedButton(
            child: const Text("ipod"),
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const IpodPage()));
            },
          ),

        ],
      ),
    );
  }

  Future<DateTime?> _showDatePicker2(BuildContext context) {
    var date = DateTime.now();
    return showCupertinoModalPopup(
      context: context,
      builder: (ctx) {
        return SizedBox(
          height: 200,
          child: CupertinoDatePicker(
            backgroundColor: Colors.white,
            mode: CupertinoDatePickerMode.dateAndTime,
            minimumDate: date,
            maximumDate: date.add(
              const Duration(days: 30),
            ),
            maximumYear: date.year + 1,
            onDateTimeChanged: (DateTime value) {
              print(value);
            },
          ),
        );
      },
    );
  }

  Future<DateTime?> _showDatePicker1(BuildContext context) {
    var date = DateTime.now();
    return showDatePicker(
      context: context,
      initialDate: date,
      firstDate: DateTime(1970),
      lastDate: DateTime(2077),
    );
  }

  Future<TimeOfDay?> _showTimePicker3(BuildContext context) {
    var date = TimeOfDay.now();
    return showTimePicker(
      context: context,
      initialTime: date,
    );
  }

  Future<T?> showCustomDialog<T>({
    required BuildContext context,
    bool barrierDismissible = true,
    required WidgetBuilder builder,
    ThemeData? theme,
  }) {
    final ThemeData theme = Theme.of(context);
    return showGeneralDialog(
      context: context,
      pageBuilder: (BuildContext buildContext, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        final Widget pageChild = Builder(builder: builder);
        return SafeArea(
          child: Builder(builder: (BuildContext context) {
            return theme != null
                ? Theme(data: theme, child: pageChild)
                : pageChild;
          }),
        );
      },
      barrierDismissible: barrierDismissible,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black87,
      // 自定义遮罩颜色
      transitionDuration: const Duration(milliseconds: 150),
      transitionBuilder: _buildMaterialDialogTransitions,
    );
  }

  Widget _buildMaterialDialogTransitions(
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) {
    // 使用缩放动画
    return ScaleTransition(
      scale: CurvedAnimation(
        parent: animation,
        curve: Curves.easeOut,
      ),
      child: child,
    );
  }

  Future<void> showListDialog(BuildContext context) async {
    int? index = await showDialog<int>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        var child = Column(
          children: <Widget>[
            const ListTile(title: Text("请选择")),
            Expanded(
                child: ListView.builder(
              itemCount: 30,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text("$index"),
                  onTap: () => Navigator.of(context).pop(index),
                );
              },
            )),
          ],
        );
        return Dialog(child: child);
      },
    );
    if (index != null) {
      print("点击了：$index");
    }
  }

  Future<int?> showDialog2(BuildContext context) {
    return showDialog<int>(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return SimpleDialog(title: const Text("请选择"), children: <Widget>[
            SimpleDialogOption(
              onPressed: () {
                // 返回1
                Navigator.pop(context, 1);
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 6),
                child: Text('中文简体'),
              ),
            ),
            SimpleDialogOption(
              onPressed: () {
                // 返回1
                Navigator.pop(context, 2);
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 6),
                child: Text('英文'),
              ),
            ),
            SimpleDialogOption(
              onPressed: () {
                // 返回1
                Navigator.pop(context, 3);
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 6),
                child: Text('日文'),
              ),
            ),
          ]);
        });
  }

  Future<bool?> showDeleteConfirmDialog1(BuildContext context) {
    bool _withTree = false;
    return showCustomDialog<bool>(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
              title: const Text("提示"),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Text("您确定要删除当前文件吗?"),
                  Row(
                    children: <Widget>[
                      const Text("同时删除子目录？"),
                      Builder(
                        builder: (BuildContext context) {
                          return Checkbox(
                            value: _withTree,
                            onChanged: (boolValue) {
                              (context as Element).markNeedsBuild();
                              _withTree = !_withTree;
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text("取消")),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                    child: const Text("删除")),
              ]);
        });
  }
}

class DialogCheckbox extends StatefulWidget {
  DialogCheckbox({
    Key? key,
    this.value,
    required this.onChanged,
  });

  final ValueChanged<bool?> onChanged;
  final bool? value;

  @override
  _DialogCheckboxState createState() => _DialogCheckboxState();
}

class _DialogCheckboxState extends State<DialogCheckbox> {
  bool? value;

  @override
  void initState() {
    value = widget.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Checkbox(
      value: value,
      onChanged: (v) {
        //将选中状态通过事件的形式抛出
        widget.onChanged(v);
        setState(() {
          //更新自身选中状态
          value = v;
        });
      },
    );
  }
}

class CustomPaintRoute extends StatelessWidget {
  const CustomPaintRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: RepaintBoundary(
      child: CustomPaint(
        size: const Size(350, 350), //指定画布大小
        painter: MyPainter(),
      ),
    ));
  }
}

class MyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    print('paint');
    var rect = Offset.zero & size;
    //画棋盘
    drawChessboard(canvas, rect);
    //画棋子
    drawPieces(canvas, rect);
  }

  // 返回false, 后面介绍
  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

void drawChessboard(Canvas canvas, Rect rect) {
  //棋盘背景
  var paint = Paint()
    ..isAntiAlias = true
    ..style = PaintingStyle.fill //填充
    ..color = const Color(0xFFDCC48C);
  canvas.drawRect(rect, paint);

  //画棋盘网格
  paint
    ..style = PaintingStyle.stroke //线
    ..color = Colors.black38
    ..strokeWidth = 1.0;

  //画横线
  for (int i = 0; i <= 15; ++i) {
    double dy = rect.top + rect.height / 15 * i;
    canvas.drawLine(Offset(rect.left, dy), Offset(rect.right, dy), paint);
  }

  for (int i = 0; i <= 15; ++i) {
    double dx = rect.left + rect.width / 15 * i;
    canvas.drawLine(Offset(dx, rect.top), Offset(dx, rect.bottom), paint);
  }
}

//画棋子
void drawPieces(Canvas canvas, Rect rect) {
  double eWidth = rect.width / 15;
  double eHeight = rect.height / 15;
  //画一个黑子
  var paint = Paint()
    ..style = PaintingStyle.fill
    ..color = Colors.black;
  //画一个黑子
  canvas.drawCircle(
    Offset(rect.center.dx - eWidth / 2, rect.center.dy - eHeight / 2),
    min(eWidth / 2, eHeight / 2) - 2,
    paint,
  );
  //画一个白子
  paint.color = Colors.white;
  canvas.drawCircle(
    Offset(rect.center.dx - eWidth / 2, rect.center.dy - eHeight / 2 + eHeight),
    min(eWidth / 2, eHeight / 2) - 2,
    paint,
  );
  //再画一个白子
  paint.color = Colors.white;
  canvas.drawCircle(
    Offset(rect.center.dx + eWidth / 2, rect.center.dy - eHeight / 2),
    min(eWidth / 2, eHeight / 2) - 2,
    paint,
  );
  //再画一个黑子
  paint.color = Colors.black;
  canvas.drawCircle(
    Offset(rect.center.dx + eWidth / 2, rect.center.dy - eHeight / 2 + eHeight),
    min(eWidth / 2, eHeight / 2) - 2,
    paint,
  );
}


class Page5 extends StatefulWidget {
  @override
  _Page5State createState() => _Page5State();
}

class _Page5State extends State<Page5> with SingleTickerProviderStateMixin {
  double _top = 0.0; //距顶部的偏移
  double _left = 0.0; //距左边的偏移

  PointerEvent? _event;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        const CustomPaintRoute(),
        Positioned(
          top: _top,
          left: _left,
          child: GestureDetector(
            child: const SizedBox(
              width: 100,
              height: 100,
              child: CircleAvatar(child: Text("Drag")),
            ),
            //手指按下时会触发此回调
            onPanDown: (DragDownDetails e) {
              //打印手指按下的位置(相对于屏幕)
              print("用户手指按下：${e.globalPosition}");
            },
            //手指滑动时会触发此回调
            onPanUpdate: (DragUpdateDetails e) {
              //用户手指滑动时，更新偏移，重新构建
              setState(() {
                _left += e.delta.dx;
                _top += e.delta.dy;
              });
            },
            onPanEnd: (DragEndDetails e) {
              //打印滑动结束时在x、y轴上的速度
              print(e.velocity);
            },
          ),
        )
      ],
    );
  }
}

class MyDrawer extends StatelessWidget {
  MyDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: MediaQuery.removeViewPadding(
          context: context,
          removeTop: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(padding: EdgeInsets.only(top: 30)),
              const Row(
                children: [
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Icon(
                        Icons.android,
                        size: 80,
                      )),
                  Text(
                    'Jack Chen',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )
                ],
              ),
              Expanded(
                  child: ListView(
                children: [
                  ListTile(
                    leading: const Icon(Icons.add),
                    title: const Text('Add account'),
                    subtitle: const Text('add a account for login'),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: const Icon(Icons.settings),
                    title: const Text('Manage account'),
                    subtitle: const Text('set you account'),
                    onTap: () {},
                  )
                ],
              ))
            ],
          )),
    );
  }
}

class _Scale extends StatefulWidget {
  const _Scale({Key? key}) : super(key: key);

  @override
  _ScaleState createState() => _ScaleState();
}

class _ScaleState extends State<_Scale> {
  double _width = 200.0; //通过修改图片宽度来达到缩放效果

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
          ),
        ),
        body: Center(
          child: GestureDetector(
            //指定宽度，高度自适应
            child: Image.network(
                'https://www.baicgroup.com.cn/assets/theme/jthink/images/icon-67.png',
                width: _width),
            onScaleUpdate: (ScaleUpdateDetails details) {
              setState(() {
                //缩放倍数在0.8到10倍之间
                _width = 200 * details.scale.clamp(.8, 10.0);
              });
            },
          ),
        ));
  }
}

class _GestureRecognizer extends StatefulWidget {
  const _GestureRecognizer({Key? key}) : super(key: key);

  @override
  _GestureRecognizerState createState() => _GestureRecognizerState();
}

class _GestureRecognizerState extends State<_GestureRecognizer> {
  final TapGestureRecognizer _tapGestureRecognizer = TapGestureRecognizer();
  bool _toggle = false; //变色开关

  @override
  void dispose() {
    //用到GestureRecognizer的话一定要调用其dispose方法释放资源
    _tapGestureRecognizer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
      ),
      body: Center(
        child: Text.rich(
          TextSpan(
            children: [
              const TextSpan(text: "你好世界"),
              TextSpan(
                text: "点我变色",
                style: TextStyle(
                  fontSize: 30.0,
                  color: _toggle ? Colors.blue : Colors.red,
                ),
                recognizer: _tapGestureRecognizer
                  ..onTap = () {
                    setState(() {
                      _toggle = !_toggle;
                    });
                  },
              ),
              const TextSpan(text: "你好世界"),
            ],
          ),
        ),
      ),
    );
  }
}

class GradientCircularProgressRoute extends StatefulWidget {
  const GradientCircularProgressRoute({Key? key}) : super(key: key);

  @override
  GradientCircularProgressRouteState createState() {
    return GradientCircularProgressRouteState();
  }
}

class GradientCircularProgressRouteState
    extends State<GradientCircularProgressRoute> with TickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    bool isForward = true;
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.forward) {
        isForward = true;
      } else if (status == AnimationStatus.completed ||
          status == AnimationStatus.dismissed) {
        if (isForward) {
          _animationController.reverse();
        } else {
          _animationController.forward();
        }
      } else if (status == AnimationStatus.reverse) {
        isForward = false;
      }
    });
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            AnimatedBuilder(
              animation: _animationController,
              builder: (BuildContext context, child) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Column(
                    children: <Widget>[
                      Wrap(
                        spacing: 10.0,
                        runSpacing: 16.0,
                        children: <Widget>[
                          GradientCircularProgressIndicator(
                            // No gradient
                            colors: const [Colors.blue, Colors.blue],
                            radius: 50.0,
                            strokeWidth: 3.0,
                            value: _animationController.value,
                            stops: const [],
                          ),
                          GradientCircularProgressIndicator(
                            colors: const [Colors.red, Colors.orange],
                            radius: 50.0,
                            strokeWidth: 3.0,
                            value: _animationController.value,
                            stops: const [],
                          ),
                          GradientCircularProgressIndicator(
                            colors: const [
                              Colors.red,
                              Colors.orange,
                              Colors.red
                            ],
                            radius: 50.0,
                            strokeWidth: 5.0,
                            value: _animationController.value,
                            stops: const [],
                          ),
                          GradientCircularProgressIndicator(
                            colors: const [Colors.teal, Colors.cyan],
                            radius: 50.0,
                            strokeWidth: 5.0,
                            strokeCapRound: true,
                            value: CurvedAnimation(
                              parent: _animationController,
                              curve: Curves.decelerate,
                            ).value,
                            stops: const [],
                          ),
                          TurnBox(
                            turns: 1 / 8,
                            child: GradientCircularProgressIndicator(
                              colors: const [
                                Colors.red,
                                Colors.orange,
                                Colors.red
                              ],
                              radius: 50.0,
                              strokeWidth: 5.0,
                              strokeCapRound: true,
                              backgroundColor: Colors.red.shade50,
                              totalAngle: 1.5 * pi,
                              value: CurvedAnimation(
                                parent: _animationController,
                                curve: Curves.ease,
                              ).value,
                              stops: const [],
                            ),
                          ),
                          RotatedBox(
                            quarterTurns: 1,
                            child: GradientCircularProgressIndicator(
                              colors: [
                                Colors.blue.shade700,
                                Colors.blue.shade200
                              ],
                              radius: 50.0,
                              strokeWidth: 3.0,
                              strokeCapRound: true,
                              backgroundColor: Colors.transparent,
                              value: _animationController.value,
                              stops: const [],
                            ),
                          ),
                          GradientCircularProgressIndicator(
                            colors: [
                              Colors.red,
                              Colors.amber,
                              Colors.cyan,
                              Colors.green.shade200,
                              Colors.blue,
                              Colors.red
                            ],
                            radius: 50.0,
                            strokeWidth: 5.0,
                            strokeCapRound: true,
                            value: _animationController.value,
                            stops: const [],
                          ),
                        ],
                      ),
                      GradientCircularProgressIndicator(
                        colors: [Colors.blue.shade700, Colors.blue.shade200],
                        radius: 100.0,
                        strokeWidth: 20.0,
                        value: _animationController.value,
                        stops: const [],
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: GradientCircularProgressIndicator(
                          colors: [Colors.blue.shade700, Colors.blue.shade300],
                          radius: 100.0,
                          strokeWidth: 20.0,
                          value: _animationController.value,
                          strokeCapRound: true,
                          stops: const [],
                        ),
                      ),
                      //剪裁半圆
                      ClipRect(
                        child: Align(
                          alignment: Alignment.topCenter,
                          heightFactor: .5,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: SizedBox(
                              //width: 100.0,
                              child: TurnBox(
                                turns: .75,
                                child: GradientCircularProgressIndicator(
                                  colors: [Colors.teal, Colors.cyan.shade500],
                                  radius: 100.0,
                                  strokeWidth: 8.0,
                                  value: _animationController.value,
                                  totalAngle: pi,
                                  strokeCapRound: true,
                                  stops: const [],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 104.0,
                        width: 200.0,
                        child: Stack(
                          alignment: Alignment.center,
                          children: <Widget>[
                            Positioned(
                              height: 200.0,
                              top: .0,
                              child: TurnBox(
                                turns: .75,
                                child: GradientCircularProgressIndicator(
                                  colors: [Colors.teal, Colors.cyan.shade500],
                                  radius: 100.0,
                                  strokeWidth: 8.0,
                                  value: _animationController.value,
                                  totalAngle: pi,
                                  strokeCapRound: true,
                                  stops: const [],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Text(
                                "${(_animationController.value * 100).toInt()}%",
                                style: const TextStyle(
                                  fontSize: 25.0,
                                  color: Colors.blueGrey,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class TurnBox extends StatefulWidget {
  const TurnBox({
    Key? key,
    this.turns = 0.0,
    this.duration = const Duration(milliseconds: 200),
    required this.child,
  }) : super(key: key);

  final double turns;
  final Duration duration;
  final Widget child;

  @override
  _TurnBoxState createState() => _TurnBoxState();
}

class _TurnBoxState extends State<TurnBox> with SingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: Tween(begin: 0.0, end: widget.turns).animate(
        CurvedAnimation(
          parent: controller,
          curve: Curves.ease,
        ),
      ),
      child: widget.child,
    );
  }
}

class GradientCircularProgressIndicator extends StatelessWidget {
  const GradientCircularProgressIndicator({
    Key? key,
    required this.strokeWidth,
    required this.radius,
    required this.colors,
    required this.stops,
    this.strokeCapRound = false,
    this.backgroundColor = const Color(0xFFEEEEEE),
    this.totalAngle = 2 * pi,
    required this.value,
  }) : super(key: key);

  ///粗细
  final double strokeWidth;

  /// 圆的半径
  final double radius;

  ///两端是否为圆角
  final bool strokeCapRound;

  /// 当前进度，取值范围 [0.0-1.0]
  final double value;

  /// 进度条背景色
  final Color backgroundColor;

  /// 进度条的总弧度，2*PI为整圆，小于2*PI则不是整圆
  final double totalAngle;

  /// 渐变色数组
  final List<Color> colors;

  /// 渐变色的终止点，对应colors属性
  final List<double> stops;

  @override
  Widget build(BuildContext context) {
    double _offset = .0;
    // 如果两端为圆角，则需要对起始位置进行调整，否则圆角部分会偏离起始位置
    // 下面调整的角度的计算公式是通过数学几何知识得出，读者有兴趣可以研究一下为什么是这样
    if (strokeCapRound) {
      _offset = asin(strokeWidth / (radius * 2 - strokeWidth));
    }
    var _colors = colors;
    if (_colors == null) {
      Color color = Theme.of(context).colorScheme.secondary;
      _colors = [color, color];
    }
    return Transform.rotate(
      angle: -pi / 2.0 - _offset,
      child: CustomPaint(
          size: Size.fromRadius(radius),
          painter: _GradientCircularProgressPainter(
            strokeWidth: strokeWidth,
            strokeCapRound: strokeCapRound,
            backgroundColor: backgroundColor,
            value: value,
            total: totalAngle,
            radius: radius,
            colors: _colors,
            stops: [],
          )),
    );
  }
}

//实现画笔
class _GradientCircularProgressPainter extends CustomPainter {
  _GradientCircularProgressPainter(
      {this.strokeWidth = 10.0,
      this.strokeCapRound = false,
      this.backgroundColor = const Color(0xFFEEEEEE),
      required this.radius,
      this.total = 2 * pi,
      required this.colors,
      required this.stops,
      required this.value});

  final double strokeWidth;
  final bool strokeCapRound;
  final double value;
  final Color backgroundColor;
  final List<Color> colors;
  final double total;
  final double radius;
  final List<double> stops;

  @override
  void paint(Canvas canvas, Size size) {
    if (radius != null) {
      size = Size.fromRadius(radius);
    }
    double _offset = strokeWidth / 2.0;
    double _value = (value);
    _value = _value.clamp(.0, 1.0) * total;
    double _start = .0;

    if (strokeCapRound) {
      _start = asin(strokeWidth / (size.width - strokeWidth));
    }

    Rect rect = Offset(_offset, _offset) &
        Size(size.width - strokeWidth, size.height - strokeWidth);

    var paint = Paint()
      ..strokeCap = strokeCapRound ? StrokeCap.round : StrokeCap.butt
      ..style = PaintingStyle.stroke
      ..isAntiAlias = true
      ..strokeWidth = strokeWidth;

    // 先画背景
    if (backgroundColor != Colors.transparent) {
      paint.color = backgroundColor;
      canvas.drawArc(rect, _start, total, false, paint);
    }

    // 再画前景，应用渐变
    if (_value > 0) {
      paint.shader = SweepGradient(
        startAngle: 0.0,
        endAngle: _value,
        colors: colors,
        stops: stops,
      ).createShader(rect);

      canvas.drawArc(rect, _start, _value, false, paint);
    }
  }

  //简单返回true，实践中应该根据画笔属性是否变化来确定返回true还是false
  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class SocketRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _request(),
      builder: (context, snapShot) {
        return Text(snapShot.data.toString());
      },
    );
  }

  _request() async {
    //建立连接
    var socket = await Socket.connect("baidu.com", 80);
    //根据http协议，发起 Get请求头
    socket.writeln("GET / HTTP/1.1");
    socket.writeln("Host:baidu.com");
    socket.writeln("Connection:close");
    socket.writeln();
    await socket.flush(); //发送
    //读取返回内容，按照utf8解码为字符串
    String _response = await utf8.decoder.bind(socket).join();
    await socket.close();
    return _response;
  }
}

class WebSocketRoute extends StatefulWidget {
  @override
  _WebSocketRouteState createState() => _WebSocketRouteState();
}

class _WebSocketRouteState extends State<WebSocketRoute> {
  TextEditingController _controller = TextEditingController();
  late IOWebSocketChannel channel;
  String _text = "";

  @override
  void initState() {
    //创建websocket连接
    channel = IOWebSocketChannel.connect('wss://echo.websocket.events');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("WebSocket(内容回显)"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Form(
              child: TextFormField(
                controller: _controller,
                decoration: const InputDecoration(labelText: 'Send a message'),
              ),
            ),
            StreamBuilder(
              stream: channel.stream,
              builder: (context, snapshot) {
                //网络不通会走到这
                if (snapshot.hasError) {
                  _text = "网络不通...";
                } else if (snapshot.hasData) {
                  _text = "echo: ${snapshot.data}";
                }
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24.0),
                  child: Text(_text),
                );
              },
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _sendMessage,
        tooltip: 'Send message',
        child: const Icon(Icons.send),
      ),
    );
  }

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      channel.sink.add(_controller.text);
    }
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }
}

class KeepAliveWrapper extends StatefulWidget {
  const KeepAliveWrapper({
    Key? key,
    this.keepAlive = true,
    required this.child,
  }) : super(key: key);
  final bool keepAlive;
  final Widget child;

  @override
  _KeepAliveWrapperState createState() => _KeepAliveWrapperState();
}

class _KeepAliveWrapperState extends State<KeepAliveWrapper>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }

  @override
  void didUpdateWidget(covariant KeepAliveWrapper oldWidget) {
    if (oldWidget.keepAlive != widget.keepAlive) {
      // keepAlive 状态需要更新，实现在 AutomaticKeepAliveClientMixin 中
      updateKeepAlive();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  bool get wantKeepAlive => widget.keepAlive;
}
