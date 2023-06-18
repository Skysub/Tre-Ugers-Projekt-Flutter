import 'package:cached_network_image/cached_network_image.dart';
import 'package:climb_it/gyms/tags.dart';
import 'package:climb_it/main_app_bar.dart';
import 'package:customizable_counter/customizable_counter.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_switch/flutter_switch.dart';

import 'climbing_route.dart';
import 'hint.dart';

typedef CompletedCallback = void Function(ClimbingRoute, bool);

class RoutePage extends StatefulWidget {
  const RoutePage({super.key, required this.route, required this.callback});

  final ClimbingRoute route;
  final CompletedCallback callback;

  @override
  State<RoutePage> createState() => _RoutePageState();
}

class _RoutePageState extends State<RoutePage> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;
  double attemptCounter = 0;

  @override
  void initState() {
    // TODO Choose video from hint if available
    _controller = VideoPlayerController.network(
        "https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4");
    _initializeVideoPlayerFuture = _controller.initialize();
    _controller.setLooping(true);
    _controller.setVolume(1.0);
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
                              widget.callback(widget.route, val);
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
                    CustomizableCounter(
                      buttonText: "Click to add attempt",
                      borderRadius: 100,
                      borderColor: Colors.pink,
                      incrementIcon: const Icon(Icons.arrow_upward_outlined, color: Colors.green,),
                      decrementIcon: const Icon(Icons.arrow_downward_outlined, color: Colors.red,),
                      textSize: 14,

                      minCount: 0,
                      maxCount: double.infinity,
                      step: 1,
                      count: attemptCounter, //TODO needs to be saved

                      //TODO only able to increment the counter when the route is not completed. Same for decrement
                      /* onIncrement: (count){
                        if(ClimbingRoute.isCompleted == false) {
                          attemptCounter++;
                        }
                      }, */

                    )
                  ],
                ),
              ),
              // TODO Move video player
              // FutureBuilder(
              //     future: _initializeVideoPlayerFuture,
              //     builder: (context, snapshot) {
              //       if (snapshot.connectionState == ConnectionState.done) {
              //         return Center(
              //           child: AspectRatio(
              //               aspectRatio: _controller.value.aspectRatio,
              //               child: VideoPlayer(_controller)),
              //         );
              //       } else {
              //         return const Center(
              //           child: CircularProgressIndicator(),
              //         );
              //       }
              //     }),
              // FloatingActionButton(
              //   onPressed: () {
              //     setState(() {
              //       if (_controller.value.isPlaying) {
              //         _controller.pause();
              //       } else {
              //         _controller.play();
              //       }
              //     });
              //   },
              // ),
            ],
          ),
        ),
      ),
    );
  }

  showHintSelector() {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
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
                              showHint(widget.route.hints[i]);
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

  showHint(Hint hint) async {
    switch (hint.type) {
      case HintType.text:
        showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
                    title: Text(hint.name),
                    content: Text(hint.data),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.pop(context, 'OK'),
                        child: const Text('OK'),
                      ),
                    ]));
        break;
      case HintType.image:
        showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
                    title: Text(hint.name),
                    content: CachedNetworkImage(
                        imageUrl: hint.data,
                        placeholder: (context, url) =>
                            const Center(child: CircularProgressIndicator())),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.pop(context, 'OK'),
                        child: const Text('OK'),
                      ),
                    ]));
        break;
      case HintType.video:
        // TODO Handle video hint
        break;
    }
  }
}
