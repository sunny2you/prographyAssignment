import 'package:flutter/material.dart';
import 'package:prography/models/photomodel.dart';
import 'package:prography/screens/home_screen.dart';
import 'package:prography/services/api_service.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({Key? key}) : super(key: key);

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  int page = 1;
  late Future<PhotoModel> randoms;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.8);
    randoms = ApiService.getRandomPhotos(page);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 1,
        backgroundColor: Colors.white,
        title: Container(
          alignment: Alignment.center,
          child: Image.asset('assets/images/logoPNG.png'),
        ),
      ),
      backgroundColor: Colors.white,
      body: FutureBuilder(
        future: randoms,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              return PageView.builder(
                controller: _pageController,
                scrollDirection: Axis.horizontal,
                itemCount: 2, // Display only two cards at a time
                onPageChanged: (index) {
                  if (index == 0) {
                    // When the first card is shown, load the next image
                    _loadNextImage();
                  }
                },
                itemBuilder: (context, index) {
                  return PageWidget(image: snapshot.data!.id);
                },
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.black45,
                ),
              );
            }
          } else {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.black45,
              ),
            );
          }
        },
      ),
      bottomNavigationBar: BottomAppBar(
        height: 70,
        color: const Color(0xff222222),
        child: Row(
          children: [
            const SizedBox(width: 100),
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
            const SizedBox(width: 100),
            GestureDetector(
              child: Image.asset('assets/images/icon_random.png'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TestScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _loadNextImage() {
    page++; // Increment page to load the next image
    setState(() {
      randoms = ApiService.getRandomPhotos(page);
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}

class PageWidget extends StatelessWidget {
  final String image;

  const PageWidget({
    Key? key,
    required this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 40,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 50),
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
            height: 400,
            width: 300,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(10),
            ),
            child: SizedBox(
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/BookmarkButton.png'),
            ],
          ),
        ],
      ),
    );
  }
}
