import 'package:flutter/material.dart';
import 'package:prography/screens/detail_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';

class Photo extends StatefulWidget {
  final String id, username, description;
  bool isLiked;
  final Function(bool isLiked) onLikedStatusChanged; // Callback function

  Photo({
    Key? key,
    required this.id,
    required this.username,
    required this.description,
    required this.onLikedStatusChanged,
    required this.isLiked,
  }) : super(key: key);

  @override
  State<Photo> createState() => _PhotoState();
}

class _PhotoState extends State<Photo> {
  late SharedPreferences prefs;

  Future initPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  initState() {
    super.initState();
    initPrefs();
    updateLikeStatus();
  }

  updateLikeStatus() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? likedPhotoIds = prefs.getStringList('likedPhotos');
    if (mounted) {
      // Check if the widget is still mounted
      if (likedPhotoIds != null && likedPhotoIds.contains(widget.id)) {
        widget.isLiked = true;
      } else {
        widget.isLiked = false;
      }

      setState(() {});
    }
  }

  Future<void> toggleLike() async {
    final prefs = await SharedPreferences.getInstance();
    var likedPhotos = prefs.getStringList('likedPhotos');
    if (likedPhotos != null) {
      if (widget.isLiked) {
        likedPhotos.remove(widget.id);
      } else {
        likedPhotos.add(widget.id);
        await prefs.setString('${widget.id}_username', widget.username);
        await prefs.setString('${widget.id}_description', widget.description);
      }
    } else {
      likedPhotos = [];
      likedPhotos.add(widget.id);
      await prefs.setString('${widget.id}_username', widget.username);
      await prefs.setString('${widget.id}_description', widget.description);
    }
    await prefs.setStringList('likedPhotos', likedPhotos);

    widget.isLiked = !widget.isLiked;
    print(widget.isLiked);

    widget.onLikedStatusChanged(widget.isLiked);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showCupertinoModalPopup(
          context: context,
          builder: (context) => DetailScreen(
            id: widget.id,
            username: widget.username,
            description: widget.description,
            isLiked: widget.isLiked,
          ),
        );
      },
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        child: Stack(
          children: [
            Image.network(widget.id),
            Positioned(
              left: 8,
              bottom: 8,
              child: widget.isLiked
                  ? const Text('')
                  : Text(
                      widget.username,
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Pretendard'),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
