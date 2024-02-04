import 'package:flutter/material.dart';
import 'package:prography/models/photomodel.dart';
import 'package:prography/screens/detail_screen.dart';
import 'package:prography/screens/home_screen.dart';
import 'package:prography/services/api_service.dart';
import 'package:swipe_cards/swipe_cards.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';

class SwipeScreen extends StatefulWidget {
  const SwipeScreen({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<SwipeScreen> {
  final List<SwipeItem> _swipeItems = <SwipeItem>[];
  MatchEngine? _matchEngine;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  int page = 1;

  Future<PhotoModel> random = ApiService.getRandomPhotos(1);

  bool isLiked = false;
  late SharedPreferences prefs;

  Future initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    final likedPhotos = prefs.getStringList('likedPhotos');
    if (likedPhotos != null) {
    } else {
      await prefs.setStringList('likedPhotos', []);
    }
  }

  toggleLike(PhotoModel widget) async {
    final likedPhotos = prefs.getStringList('likedPhotos');
    if (likedPhotos != null) {
      if (isLiked) {
        likedPhotos.remove(widget.id);
      } else {
        likedPhotos.add(widget.id);
        await prefs.setString('${widget.id}_username', widget.username);
        await prefs.setString('${widget.id}_description', widget.description);
      }
      await prefs.setStringList('likedPhotos', likedPhotos);
      setState(() {
        isLiked = !isLiked;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    initPrefs();
    for (int i = 0; i < 100; i++) {
      _swipeItems.add(SwipeItem(
        content: random,
        likeAction: () {
          setState(() async {
            PhotoModel photo = await random;
            toggleLike(photo);
            print('liked');

            random = ApiService.getRandomPhotos(page++);
          });
        },
        nopeAction: () {
          setState(() {
            print('nope');
            page++;
            random = ApiService.getRandomPhotos(page);
          });
        },
        superlikeAction: () {
          setState(() {
            print('liked');
            page++;
            random = ApiService.getRandomPhotos(page);
          });
        },
      ));
    }

    _matchEngine = MatchEngine(swipeItems: _swipeItems);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Container(
          alignment: Alignment.center,
          child: Image.asset('assets/images/logoPNG.png'),
        ),
        shape: Border(
          bottom: BorderSide(
            color: Colors.grey.withOpacity(0.3),
            width: 1,
          ),
        ),
      ),
      body: Stack(children: [
        SizedBox(
          child: SwipeCards(
            matchEngine: _matchEngine!,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                alignment: Alignment.center,
                child: FutureBuilder(
                  future: random,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return PageWidget(
                        image: snapshot.data!.id,
                        username: snapshot.data!.username,
                        description: snapshot.data!.description,
                      );
                    } else {
                      return const CircularProgressIndicator();
                    }
                  },
                ),
              );
            },
            onStackFinished: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("Stack Finished"),
                duration: Duration(milliseconds: 500),
              ));
            },
            upSwipeAllowed: true,
            fillSpace: true,
          ),
        ),
      ]),
      bottomNavigationBar: BottomAppBar(
        height: 70,
        color: const Color(0xff222222),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              child: Image.asset(
                'assets/images/icon_home.png',
                opacity: const AlwaysStoppedAnimation(.5),
              ),
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
            GestureDetector(
              child: Image.asset('assets/images/icon_random.png'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SwipeScreen(),
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

class PageWidget extends StatelessWidget {
  final String image, username, description;

  const PageWidget(
      {Key? key,
      required this.image,
      required this.username,
      required this.description})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 40,
      height: 490,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          const SizedBox(height: 14),
          Container(
            clipBehavior: Clip.hardEdge,
            margin: const EdgeInsets.only(left: 14, right: 14),
            height: 360,
            width: 320,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 40),
              width: 300,
              height: 300,
              child: Image.network(
                image,
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image.asset('assets/images/NotInterestedButton.png'),
              Image.asset('assets/images/BookmarkButton.png'),
              InkWell(
                  onTap: () {
                    showCupertinoModalPopup(
                        context: context,
                        builder: (context) => DetailScreen(
                              id: image,
                              username: username,
                              description: description,
                              isLiked: false,
                            ));
                  },
                  child: Image.asset('assets/images/InformationButton.png')),
            ],
          ),
        ],
      ),
    );
  }
}
