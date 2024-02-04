// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class LikeButtonWidget extends StatefulWidget {
//   final String photoId;
//   final String username;
//   final String description;

//   final Function(bool) onLikeStatusChanged; // Add this callback

//   const LikeButtonWidget({
//     Key? key,
//     required this.photoId,
//     required this.username,
//     required this.description,
//     required this.onLikeStatusChanged,
//   }) : super(key: key);

//   @override
//   _LikeButtonWidgetState createState() => _LikeButtonWidgetState();
// }

// class _LikeButtonWidgetState extends State<LikeButtonWidget> {
//   bool isLiked = false;

//   @override
//   void initState() {
//     super.initState();
//     checkIfLiked();
//   }

//   Future<void> checkIfLiked() async {
//     final prefs = await SharedPreferences.getInstance();
//     setState(() {
//       isLiked = prefs.getBool(widget.photoId) ?? false;
//     });
//   }

//   Future<void> toggleLike() async {
//     final prefs = await SharedPreferences.getInstance();
//     final likedPhotos = prefs.getStringList('likedPhotos');
//     if (likedPhotos != null) {
//       if (isLiked) {
//         // If already liked, remove the like
//         likedPhotos.remove(widget.photoId);
//       } else {
//         // If not liked, save the like
//         likedPhotos.add(widget.photoId);
//         await prefs.setString('${widget.photoId}_username', widget.username);
//         await prefs.setString(
//             '${widget.photoId}_description', widget.description);
//       }
//     }

//     setState(() {
//       isLiked = !isLiked;
//       print(isLiked);
//     });

//     widget.onLikeStatusChanged(isLiked);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: toggleLike,
//       child: isLiked
//           ? Image.asset('assets/images/NavigationButton.png')
//           : Image.asset(
//               'assets/images/NavigationButton.png',
//               opacity: const AlwaysStoppedAnimation(.5),
//             ),
//     );
//   }
// }
