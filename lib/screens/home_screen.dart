import 'package:flutter/material.dart';
import 'package:prography/models/photomodel.dart';
import 'package:prography/screens/swipescreen.dart';
import 'package:prography/services/api_service.dart';
import 'package:prography/widgets/photo_widget.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int page = 1;
  Future<List<PhotoModel>> latestPhotos = ApiService.getPhotos(1, []);
  Future<List<PhotoModel>> likedPhotos = ApiService.getLikedPhotos();

  final scrollVertical = ScrollController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    scrollVertical.addListener(_scrollListener);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      backgroundColor: Colors.white,
      body: CustomScrollView(
        controller: scrollVertical,
        slivers: [
          FutureBuilder(
            future: likedPhotos,
            builder: (context, likedSnapshot) {
              if (likedSnapshot.connectionState == ConnectionState.waiting) {
                return const SliverToBoxAdapter(
                  child: Center(
                    child: CircularProgressIndicator(
                      color: Colors.black45,
                    ),
                  ),
                );
              } else {
                List<PhotoModel> likedPhotosList =
                    likedSnapshot.data as List<PhotoModel>;
                return likedPhotosList.isNotEmpty
                    ? SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 20),
                              const Text(
                                '북마크',
                                style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w800,
                                    fontFamily: 'Pretendard'),
                              ),
                              const SizedBox(height: 20),
                              SizedBox(
                                height: 120,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: likedPhotosList.length,
                                  itemBuilder: (context, index) {
                                    var likedPhoto = likedPhotosList[index];
                                    return Padding(
                                      padding: const EdgeInsets.only(right: 10),
                                      child: Container(
                                        child: Photo(
                                          id: likedPhoto.id,
                                          username: likedPhoto.username,
                                          description: likedPhoto.description,
                                          onLikedStatusChanged: (bool isLiked) {
                                            if (mounted) {
                                              // Update the HomeScreen when the liked status changes
                                              setState(() {});
                                            }
                                          },
                                          isLiked: true,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : const SliverToBoxAdapter();
              }
            },
          ),
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(left: 10, top: 20, bottom: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '최신 이미지',
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        fontFamily: 'Pretendard'),
                  ),
                ],
              ),
            ),
          ),
          FutureBuilder(
            future: latestPhotos,
            builder: (context, latestSnapshot) {
              if (latestSnapshot.hasData) {
                List<PhotoModel> latestPhotosList =
                    latestSnapshot.data as List<PhotoModel>;
                return SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  sliver: SliverMasonryGrid.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    childCount: latestPhotosList.length,
                    itemBuilder: (context, index) {
                      var photo = latestPhotosList[index];
                      return Photo(
                        id: photo.id,
                        username: photo.username,
                        description: photo.description,
                        onLikedStatusChanged: (bool isLiked) {
                          if (mounted) {
                            // Update the HomeScreen when the liked status changes
                            setState(() {});
                          }
                        },
                        isLiked: false,
                      );
                    },
                  ),
                );
              } else {
                return const SliverToBoxAdapter(
                  child: ColoredBox(color: Colors.red),
                );
              }
            },
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        height: 70,
        color: const Color(0xff222222),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              child: Image.asset('assets/images/icon_home.png'),
            ),
            GestureDetector(
              child: Image.asset('assets/images/icon_random.png',
                  opacity: const AlwaysStoppedAnimation(.5)),
              onTap: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: ((context, animation, secondaryAnimation) =>
                        const MyHomePage()),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _scrollListener() async {
    if (scrollVertical.position.pixels ==
        scrollVertical.position.maxScrollExtent) {
      page = page + 1;
      print(page);
      isLoading = true;

      List<PhotoModel> instances = await latestPhotos;
      latestPhotos = ApiService.getPhotos(page, instances);
      setState(() {});
      isLoading = false;
      print('Scroll Listener called');
    } else {
      print('don\'t call');
    }
  }
}
