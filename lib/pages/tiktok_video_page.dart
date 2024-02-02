import 'package:flutter/material.dart';
import 'package:test001/theme/colors.dart';
import 'package:test001/widgets/header_home_page.dart';
import 'package:test001/widgets/column_social_icon.dart';
import 'package:test001/widgets/left_panel.dart';
import 'package:test001/widgets/tik_tok_icons.dart';
import 'package:video_player/video_player.dart';

class TiktokVideoPage extends StatefulWidget {
  const TiktokVideoPage({Key? key}) : super(key: key);

  @override
  State createState() => _TiktokVideoPageState();
}

class _TiktokVideoPageState extends State<TiktokVideoPage> {
  late PageController _pageController;
  int currentPageIndex = 1000;

  @override
  void initState() {
    _pageController = PageController(initialPage: currentPageIndex);
    _pageController.addListener(_onPageScroll);
    super.initState();
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
    return getBody();
  }

  Widget getBody() {
    var size = MediaQuery.of(context).size;
    return PageView.builder(
      scrollDirection: Axis.vertical,
      itemCount: items.length * 1000,
      controller: _pageController,
      itemBuilder: (context, index) {
        final videoIndex = index % items.length;
        return VideoPlayerItem(
          videoUrl: items[videoIndex]['videoUrl'],
          size: size,
          name: items[videoIndex]['name'],
          caption: items[videoIndex]['caption'],
          songName: items[videoIndex]['songName'],
          profileImg: items[videoIndex]['profileImg'],
          likes: items[videoIndex]['likes'],
          comments: items[videoIndex]['comments'],
          shares: items[videoIndex]['shares'],
          albumImg: items[videoIndex]['albumImg'],
        );
      },
    );
  }
}

class VideoPlayerItem extends StatefulWidget {
  final String videoUrl;
  final String name;
  final String caption;
  final String songName;
  final String profileImg;
  final String likes;
  final String comments;
  final String shares;
  final String albumImg;
  const VideoPlayerItem(
      {Key? key,
      required this.size,
      required this.name,
      required this.caption,
      required this.songName,
      required this.profileImg,
      required this.likes,
      required this.comments,
      required this.shares,
      required this.albumImg,
      required this.videoUrl})
      : super(key: key);

  final Size size;

  @override
  State createState() => _VideoPlayerItemState();
}

class _VideoPlayerItemState extends State<VideoPlayerItem> {
  late VideoPlayerController _videoController;
  bool isShowPlaying = false;

  @override
  void initState() {
    _videoController = VideoPlayerController.asset(widget.videoUrl)
      ..initialize().then((value) {
        _videoController.play();
        _videoController.setLooping(true);
        setState(() {
          isShowPlaying = false;
        });
      });
    super.initState();
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  Widget isPlaying() {
    return _videoController.value.isPlaying && !isShowPlaying
        ? Container()
        : Icon(
            Icons.play_arrow,
            size: 80,
            color: white.withOpacity(0.5),
          );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          _videoController.value.isPlaying
              ? _videoController.pause()
              : _videoController.play();
        });
      },
      child: SizedBox(
          height: widget.size.height,
          width: widget.size.width,
          child: Stack(
            children: <Widget>[
              Container(
                height: widget.size.height,
                width: widget.size.width,
                decoration: const BoxDecoration(color: black),
                child: Stack(
                  children: <Widget>[
                    VideoPlayer(_videoController),
                    Center(
                      child: Container(
                        decoration: const BoxDecoration(),
                        child: isPlaying(),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: widget.size.height,
                width: widget.size.width,
                child: Padding(
                  padding: const EdgeInsets.only(left: 15, top: 20, bottom: 10),
                  child: SafeArea(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        const HeaderHomePage(),
                        Expanded(
                            child: Row(
                          children: <Widget>[
                            LeftPanel(
                              size: widget.size,
                              name: widget.name,
                              caption: widget.caption,
                              songName: widget.songName,
                            ),
                            RightPanel(
                              size: widget.size,
                              likes: widget.likes,
                              comments: widget.comments,
                              shares: widget.shares,
                              profileImg: widget.profileImg,
                              albumImg: widget.albumImg,
                            )
                          ],
                        ))
                      ],
                    ),
                  ),
                ),
              )
            ],
          )),
    );
  }
}

class RightPanel extends StatelessWidget {
  final String likes;
  final String comments;
  final String shares;
  final String profileImg;
  final String albumImg;
  const RightPanel({
    Key? key,
    required this.size,
    required this.likes,
    required this.comments,
    required this.shares,
    required this.profileImg,
    required this.albumImg,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SizedBox(
        height: size.height,
        child: Column(
          children: <Widget>[
            Container(
              height: size.height * 0.3,
            ),
            Expanded(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                getProfile(profileImg),
                getIcons(TikTokIcons.heart, likes, 35.0),
                getIcons(TikTokIcons.chat_bubble, comments, 35.0),
                getIcons(TikTokIcons.reply, shares, 25.0),
                getAlbum(albumImg)
              ],
            ))
          ],
        ),
      ),
    );
  }
}

class VideoData {
  final String type; //视频加 精
  final String videoUrl; //视频地址
  final String videoWidth; //视频宽
  final String videoHeight; //视频高
  final String albumImg; //视频第一帧封面
  final String userName; //发布者名
  final String userAvatarUrl; //发布者头像
  final String description; //视频描述
  final String title; //视频标题
  final String likes; //视频点赞数
  final String comments; //视频评论数
  final String shares; //视频分享数
  final String watchers; //视频观看数
  final String time; //视频发布时间
  final List<VideoTag> videoTags; //视频关联话题

  VideoData({
    required this.type,
    required this.videoUrl,
    required this.videoWidth,
    required this.videoHeight,
    required this.albumImg,
    required this.userName,
    required this.userAvatarUrl,
    required this.description,
    required this.title,
    required this.likes,
    required this.comments,
    required this.shares,
    required this.watchers,
    required this.time,
    required this.videoTags,
  });
}

class VideoTag {
  final String tagId; //视频关联话题id
  final String tagName; //视频关联话题名
  VideoTag({
    required this.tagId,
    required this.tagName,
  });
}

/// 测试数据

List videoList = <VideoData>[
  VideoData(
      type: "精",
      videoUrl: "https://static.ybhospital.net/test-video-2.mp4",
      videoWidth: "720",
      videoHeight: "1280",
      albumImg: "https://images.unsplash.com/photo-1502982899975-893c9cf39028?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=800&q=60",
      userName: "发布人名称",
      userAvatarUrl: "https://p16-tiktokcdn-com.akamaized.net/aweme/720x720/tiktok-obj/1663771856684033.jpeg",
      description: "春日的暖阳，花开进度80%，准备和爱车路过全世界，感受独具魅力的岭南文化!",
      title: "视频标题",
      likes: "1300",
      comments: "1865",
      shares: "1356",
      watchers: "3280",
      time: "2023年12月16日",
      videoTags: [
        VideoTag(tagId: "1111", tagName: "今天去哪玩"),
        VideoTag(tagId: "1111", tagName: "南京车友圈"),
        VideoTag(tagId: "1111", tagName: "活动名称"),
      ]),
  VideoData(
      type: "精",
      videoUrl: "https://static.ybhospital.net/test-video-3.mp4",
      videoWidth: "720",
      videoHeight: "1280",
      albumImg: "https://images.unsplash.com/photo-1502982899975-893c9cf39028?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=800&q=60",
      userName: "发布人名称",
      userAvatarUrl: "https://p16-tiktokcdn-com.akamaized.net/aweme/720x720/tiktok-obj/1663771856684033.jpeg",
      description: "春日的暖阳，花开进度80%，准备和爱车路过全世界，感受独具魅力的岭南文化!",
      title: "视频标题",
      likes: "1300",
      comments: "1865",
      shares: "1356",
      watchers: "3280",
      time: "2023年12月16日",
      videoTags: [
        VideoTag(tagId: "1111", tagName: "今天去哪玩"),
        VideoTag(tagId: "1111", tagName: "南京车友圈"),
        VideoTag(tagId: "1111", tagName: "活动名称"),
      ]),
  VideoData(
      type: "精",
      videoUrl: "https://static.ybhospital.net/test-video-4.mp4",
      videoWidth: "720",
      videoHeight: "1280",
      albumImg: "https://images.unsplash.com/photo-1502982899975-893c9cf39028?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=800&q=60",
      userName: "发布人名称",
      userAvatarUrl: "https://p16-tiktokcdn-com.akamaized.net/aweme/720x720/tiktok-obj/1663771856684033.jpeg",
      description: "春日的暖阳，花开进度80%，准备和爱车路过全世界，感受独具魅力的岭南文化!",
      title: "视频标题",
      likes: "1300",
      comments: "1865",
      shares: "1356",
      watchers: "3280",
      time: "2023年12月16日",
      videoTags: [
        VideoTag(tagId: "1111", tagName: "今天去哪玩"),
        VideoTag(tagId: "1111", tagName: "南京车友圈"),
        VideoTag(tagId: "1111", tagName: "活动名称"),
      ]),
  VideoData(
      type: "精",
      videoUrl: "https://static.ybhospital.net/test-video-5.mp4",
      videoWidth: "720",
      videoHeight: "1280",
      albumImg: "https://images.unsplash.com/photo-1502982899975-893c9cf39028?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=800&q=60",
      userName: "发布人名称",
      userAvatarUrl: "https://p16-tiktokcdn-com.akamaized.net/aweme/720x720/tiktok-obj/1663771856684033.jpeg",
      description: "春日的暖阳，花开进度80%，准备和爱车路过全世界，感受独具魅力的岭南文化!",
      title: "视频标题",
      likes: "1300",
      comments: "1865",
      shares: "1356",
      watchers: "3280",
      time: "2023年12月16日",
      videoTags: [
        VideoTag(tagId: "1111", tagName: "今天去哪玩"),
        VideoTag(tagId: "1111", tagName: "南京车友圈"),
        VideoTag(tagId: "1111", tagName: "活动名称"),
      ]),
  VideoData(
      type: "精",
      videoUrl: "https://static.ybhospital.net/test-video-6.mp4",
      videoWidth: "720",
      videoHeight: "1280",
      albumImg: "https://images.unsplash.com/photo-1502982899975-893c9cf39028?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=800&q=60",
      userName: "发布人名称",
      userAvatarUrl: "https://p16-tiktokcdn-com.akamaized.net/aweme/720x720/tiktok-obj/1663771856684033.jpeg",
      description: "春日的暖阳，花开进度80%，准备和爱车路过全世界，感受独具魅力的岭南文化!",
      title: "视频标题",
      likes: "1300",
      comments: "1865",
      shares: "1356",
      watchers: "3280",
      time: "2023年12月16日",
      videoTags: [
        VideoTag(tagId: "1111", tagName: "今天去哪玩"),
        VideoTag(tagId: "1111", tagName: "南京车友圈"),
        VideoTag(tagId: "1111", tagName: "活动名称"),
      ]),
];

List items = [
  {
    "videoUrl": "assets/videos/video_1.mp4",
    "name": "Vannak Niza🦋",
    "caption": "Morning, everyone!!",
    "songName": "original sound - Łÿ Pîkâ Ćhûû",
    "profileImg":
        "https://p16-tiktokcdn-com.akamaized.net/aweme/720x720/tiktok-obj/1663771856684033.jpeg",
    "likes": "1.5M",
    "comments": "18.9K",
    "shares": "80K",
    "albumImg":
        "https://images.unsplash.com/photo-1502982899975-893c9cf39028?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=800&q=60"
  },
  {
    "videoUrl": "assets/videos/video_2.mp4",
    "name": "Dara Chamroeun",
    "caption": "Oops 🙊 #fyp #cambodiatiktok",
    "songName": "original sound - 💛💛Khantana 🌟",
    "profileImg":
        "https://p16-tiktokcdn-com.akamaized.net/aweme/720x720/tiktok-obj/ba13e655825553a46b1913705e3a8617.jpeg",
    "likes": "4.4K",
    "comments": "5.2K",
    "shares": "100",
    "albumImg":
        "https://images.unsplash.com/photo-1462804512123-465343c607ee?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=668&q=80"
  },
  {
    "videoUrl": "assets/videos/video_3.mp4",
    "name": "9999womenfashion",
    "caption": "#블루모드",
    "songName": "original sound - 🖤Khün MÄk🇰🇭",
    "profileImg":
        "https://p16-tiktokcdn-com.akamaized.net/aweme/720x720/tiktok-obj/1664576339652610.jpeg",
    "likes": "100K",
    "comments": "10K",
    "shares": "8.5K",
    "albumImg":
        "https://images.unsplash.com/photo-1457732815361-daa98277e9c8?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1650&q=80"
  },
];
