import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

final RouteObserver<ModalRoute> routeObserver = RouteObserver<ModalRoute>();

class VideoFeedPostWidget extends StatefulWidget {
  final String videoUrl;

  const VideoFeedPostWidget({Key? key, required this.videoUrl})
      : super(key: key);

  @override
  _VideoFeedPostWidgetState createState() => _VideoFeedPostWidgetState();
}

class _VideoFeedPostWidgetState extends State<VideoFeedPostWidget>
    with RouteAware {
  late VideoPlayerController? _controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    _controller = VideoPlayerController.network(widget.videoUrl,
        formatHint: VideoFormat.hls);
    _initializeVideoPlayerFuture = _controller!.initialize().then((_) {
      // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
      if (mounted) {
        setState(() {
          _controller?.setVolume(0);
          _controller?.setLooping(true);
          _controller?.play();
        });
      }
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void didPushNext() {
    _controller?.pause();
  }

  @override
  void didPopNext() {
    super.didPopNext();
  }

  void toggleVideoPlaying() {
    setState(() {
      if (_controller!.value.isPlaying) {
        print('PAUSING IT');
        // If the video is playing, pause it.
        _controller!.pause();
      } else {
        // If the video is paused, play it.

        // However, if we've reached the end of the video, we must seek to 0 first
        if ((_controller!.value.duration == _controller!.value.position)) {
          _controller!.seekTo(Duration(seconds: 0));
        }
        _controller!.play();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return _buildVideoPlayerWidget;
  }

  Widget get _buildVideoPlayerWidget {
    return GestureDetector(
      onTap: () {
        toggleVideoPlaying();
      },
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: FutureBuilder<void>(
            future: _initializeVideoPlayerFuture,
            builder: (context, snapshot) {
              if (_controller?.value.hasError ?? true) {
                //TODO: Return a video load failure UI here, which is missing.
              }
              if (snapshot.connectionState != ConnectionState.done) {
                return AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Container(

                      ///Transparent because in carousel the CarouselSlider is already wrapped in Container with color Colors.black45.
                      color: Colors.black87,
                      child: Center(child: CircularProgressIndicator())),
                );
              }
              return AspectRatio(
                  aspectRatio: 16 / 9, child: VideoPlayer(_controller!));
            }),
      ),
    );
  }

  @override
  void dispose() {
    print('disposed video controller');
    if (!mounted) {
      _controller?.dispose();
      _controller = null;
    }
    super.dispose();
  }
}
