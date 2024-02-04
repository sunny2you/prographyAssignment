import 'package:flutter/material.dart';

// Create a ChangeNotifier class
class LikeStatusNotifier extends ChangeNotifier {
  bool _isLiked = false;

  bool get isLiked => _isLiked;

  void updateLikeStatus(bool newStatus) {
    _isLiked = newStatus;
    notifyListeners(); // Notify listeners about the change
  }
}

class ParentWidget extends StatelessWidget {
  final LikeStatusNotifier likeStatusNotifier = LikeStatusNotifier();

  ParentWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Parent Widget')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ChildWidget(likeStatusNotifier: likeStatusNotifier),
        ],
      ),
    );
  }
}

class ChildWidget extends StatefulWidget {
  final LikeStatusNotifier likeStatusNotifier;

  const ChildWidget({Key? key, required this.likeStatusNotifier})
      : super(key: key);

  @override
  _ChildWidgetState createState() => _ChildWidgetState();
}

class _ChildWidgetState extends State<ChildWidget> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          // Call the function in the parent widget
          widget.likeStatusNotifier.updateLikeStatus(true);
        },
        child: const Text('Like'),
      ),
    );
  }
}

void main() {
  runApp(
    MaterialApp(
      home: ParentWidget(),
    ),
  );
}
