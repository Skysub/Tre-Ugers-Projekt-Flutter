import 'package:cached_network_image/cached_network_image.dart';
import 'package:climb_it/gyms/tags.dart';
import 'package:climb_it/main_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_switch/flutter_switch.dart';

import 'climbing_route.dart';
import 'hint.dart';

typedef CompletedCallback = void Function(ClimbingRoute);

class RoutePage extends StatefulWidget {
  const RoutePage({super.key, required this.route, required this.callback});

  final ClimbingRoute route;
  final CompletedCallback callback;

  @override
  State<RoutePage> createState() => _RoutePageState();
}

class _RoutePageState extends State<RoutePage> {
  Map<String, Future<void>> initVideoPlayerFutures = {};
  late Map<String, VideoPlayerController> videoHintControllers;

  @override
  void initState() {
    //We start by preloading all the hint videos for this route if applicable
    var videoHints =
        widget.route.hints.where((e) => e.type == HintType.video).toList();

    //Controllers for the hints are created and put in this map
    videoHintControllers = Map<String, VideoPlayerController>.fromEntries(
        Iterable<MapEntry<String, VideoPlayerController>>.generate(
            videoHints.length,
            //Genererer ud fra videohint arrayet
            (i) => MapEntry<String, VideoPlayerController>(videoHints[i].data,
                VideoPlayerController.network(videoHints[i].data))));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(barTitle: widget.route.name),
      body: Scrollbar(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: CachedNetworkImage(
                    imageUrl: widget.route.imageUrl,
                    placeholder: (context, url) =>
                        const Center(child: CircularProgressIndicator()),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 10,
                  right: 10,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        FlutterSwitch(
                          width: 180,
                          inactiveText: "Not Completed",
                          activeText: "Completed!",
                          padding: 8,
                          activeColor: Colors.green,
                          inactiveColor: Colors.red,
                          activeTextColor: Colors.white,
                          inactiveTextColor: Colors.white,
                          activeTextFontWeight: FontWeight.bold,
                          inactiveTextFontWeight: FontWeight.bold,
                          toggleColor: Colors.white,
                          value: widget.route.isCompleted,
                          showOnOff: true,
                          onToggle: (val) {
                            setState(() {
                              widget.route.isCompleted = val;
                              widget.callback(widget.route);
                            });
                          },
                        ),
                      ],
                    ),
                    Tags(
                      tags: widget.route.tags,
                      color: widget.route.color,
                    ),
                    if (widget.route.hints.isNotEmpty)
                      Center(
                        child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.red,
                              side: const BorderSide(
                                color: Colors.red,
                              ),
                            ),
                            onPressed: () => {showHintSelector()},
                            child: const Text("Need A Hint?")),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //Shows a dialog where you can choose a hint to see
  showHintSelector() {
    //Autoselects the only hint, if there is only 1
    if (widget.route.hints.length == 1) {
      showDialog(
              traversalEdgeBehavior: TraversalEdgeBehavior.closedLoop,
              context: context,
              builder: (BuildContext context) => AlertDialog(
                      title: Text(widget.route.hints[0].name),
                      //Gets the hint widget
                      content: getHintContentWidget(widget.route.hints[0]),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.pop(context, 'OK'),
                          child: const Text('OK'),
                        ),
                      ]))
          //Stops all hint video currently playing, when the hint dialog is dismissed
          .whenComplete(() => videoHintControllers.forEach((key, value) {
                if (value.value.isPlaying) {
                  value.pause();
                }
              }));
      return;
    }
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
                scrollable: true,
                title: const Text("Choose a hint"),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: List<ElevatedButton>.generate(
                      widget.route.hints.length,
                      (i) => ElevatedButton(
                            child: Text(widget.route.hints[i].name),
                            onPressed: () {
                              Navigator.pop(context);
                              //Shows the hint dialog
                              showDialog(
                                  traversalEdgeBehavior:
                                      TraversalEdgeBehavior.closedLoop,
                                  context: context,
                                  builder: (BuildContext context) =>
                                      AlertDialog(
                                          title:
                                              Text(widget.route.hints[i].name),
                                          //Gets the hint widget
                                          content: getHintContentWidget(
                                              widget.route.hints[i]),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context, 'OK'),
                                              child: const Text('OK'),
                                            ),
                                            //Stops alle currently playing hint videos when the dialog is dismissed
                                          ])).whenComplete(() =>
                                  videoHintControllers.forEach((key, value) {
                                    if (value.value.isPlaying) {
                                      value.pause();
                                    }
                                  }));
                            },
                          )),
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'OK'),
                    child: const Text('OK'),
                  ),
                ]));
  }

  Widget getHintContentWidget(Hint hint) {
    //Selects the correct type of widget to interpret the data field in the hint class
    switch (hint.type) {
      case HintType.text:
        return Text(hint.data);

      case HintType.image:
        return CachedNetworkImage(
            imageUrl: hint.data,
            placeholder: (context, url) =>
                const Center(child: CircularProgressIndicator()));

      case HintType.video:
        //Insurance
        if (videoHintControllers[hint.data] == null) {
          return const Text("Video error");
        }
        //Initializes the video and creates a future, for the future builder
        VideoPlayerController hintVid = videoHintControllers[hint.data]!;
        initVideoPlayerFutures.putIfAbsent(
            hint.data, () => hintVid.initialize());
        hintVid.setLooping(false);
        hintVid.setVolume(1.0);

        return StatefulBuilder(
          builder: (context, setState) =>
              Column(mainAxisSize: MainAxisSize.min, children: [
            FutureBuilder(
                future: initVideoPlayerFutures[hint.data],
                builder: (context, snapshot) {
                  //Only shows the videoplayer if the video has been initialized
                  if (snapshot.connectionState == ConnectionState.done) {
                    return Center(
                        child: AspectRatio(
                            aspectRatio: videoHintControllers[hint.data]!
                                .value
                                .aspectRatio,
                            child:
                                //Shows the videoplayer
                                VideoPlayer(videoHintControllers[hint.data]!)));
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                }),
            Padding(
                padding: const EdgeInsets.only(top: 5),
                child: FloatingActionButton(
                  backgroundColor: Colors.pink,
                  child: Icon(
                      videoHintControllers[hint.data]!.value.isPlaying
                          ? Icons.pause
                          : Icons.play_arrow_sharp,
                      color: Colors.white,
                      size: 40),
                  onPressed: () {
                    setState(() {
                      //toggles playing the video
                      if (videoHintControllers[hint.data]!.value.isPlaying) {
                        videoHintControllers[hint.data]!.pause();
                      } else {
                        videoHintControllers[hint.data]!.play();
                      }
                    });
                  },
                ))
          ]),
        );
    }
  }
}
