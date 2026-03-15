import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class MovieInfoPage extends StatefulWidget {
  dynamic docs;
  MovieInfoPage({super.key, this.docs});

  @override
  State<MovieInfoPage> createState() => _MovieInfoPageState();
}

class _MovieInfoPageState extends State<MovieInfoPage> {
  late FlickManager flickManager;

  @override
  void initState() {
    flickManager = FlickManager(
      videoPlayerController: VideoPlayerController.networkUrl(
        Uri.parse(widget.docs['url']),
      ),
    );
    super.initState();
  }

  @override
  void dispose() {
    flickManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.docs['name'])),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color.fromARGB(156, 27, 12, 34),
              const Color.fromARGB(156, 39, 18, 48),
              const Color.fromARGB(218, 106, 57, 170),
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FlickVideoPlayer(flickManager: flickManager),
              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
              Text(widget.docs['name'], style: TextStyle(fontSize: 20)),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              ElevatedButton(
                onPressed: () {},
                child: Text("Смотреть"),
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(
                    const Color.fromRGBO(223, 213, 235, 100),
                  ),
                  foregroundColor: WidgetStatePropertyAll(
                    Color.fromARGB(209, 27, 12, 34),
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Column(
                        children: [
                          IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.bookmark, size: 35),
                          ),
                          Text("В Избранное", style: TextStyle(fontSize: 10)),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.05),
                  Column(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.remove_red_eye),
                      ),
                      Text("Просмотрено", style: TextStyle(fontSize: 10)),
                    ],
                  ),
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
              Container(
                width: double.infinity,
                height: double.infinity,
                child: Text(widget.docs['description'], maxLines: 5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
