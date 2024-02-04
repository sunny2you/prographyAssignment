import 'package:flutter/material.dart';
import 'package:prography/screens/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class DetailScreen extends StatefulWidget {
  final String id, username, description;
  bool isLiked;

  DetailScreen(
      {super.key,
      required this.id,
      required this.username,
      required this.description,
      this.isLiked = false});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late SharedPreferences prefs;

  Future initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    final likedPhotos = prefs.getStringList('likedPhotos');
    if (likedPhotos != null) {
      if (likedPhotos.contains(widget.id) == true) {
        setState(() {
          widget.isLiked = true;
          print(widget.isLiked);
        });
      } else {
        widget.isLiked = false;
      }
    } else {
      widget.isLiked = false;
      await prefs.setStringList('likedPhotos', []);
    }
  }

  @override
  void initState() {
    super.initState();
    initPrefs();
  }

  toggleLike() async {
    final likedPhotos = prefs.getStringList('likedPhotos');
    if (likedPhotos != null) {
      if (widget.isLiked) {
        likedPhotos.remove(widget.id);
      } else {
        likedPhotos.add(widget.id);
        await prefs.setString('${widget.id}_username', widget.username);
        await prefs.setString('${widget.id}_description', widget.description);
      }
      await prefs.setStringList('likedPhotos', likedPhotos);
      setState(() {
        widget.isLiked = !widget.isLiked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent.withOpacity(0.8),
      body: Container(
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
          child: Container(
            margin: const EdgeInsets.symmetric(),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          GestureDetector(
                            child: Image.asset('assets/images/CloseButton.png'),
                            onTap: () {
                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (
                                    context,
                                    animation,
                                    secondaryAnimation,
                                  ) =>
                                      const HomeScreen(),
                                ),
                              );
                            },
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            widget.username,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        const SizedBox(
                          width: 80,
                        ),
                        Image.asset('assets/images/DownloadButton.png'),
                        InkWell(
                          onTap: () {
                            toggleLike();
                          },
                          child: widget.isLiked
                              ? Image.asset(
                                  'assets/images/NavigationButton.png')
                              : Image.asset(
                                  'assets/images/NavigationButton.png',
                                  opacity: const AlwaysStoppedAnimation(.5),
                                ),
                        ),
                      ],
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 0),
                    width: MediaQuery.of(context).size.width - 30,
                    alignment: Alignment.center,
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Image.network(widget.id),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          widget.username,
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 24,
                              fontFamily: 'Pretendard'),
                        ),
                        Text(
                          widget.description,
                          style: const TextStyle(
                              color: Colors.white, fontFamily: 'Pretendard'),
                        ),
                        const Text(
                          '#tag #tag #tag #tag',
                          style: TextStyle(
                              color: Colors.white, fontFamily: 'Pretendard'),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
