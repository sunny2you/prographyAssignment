import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:prography/models/photomodel.dart';

class ApiService {
  static const String homeUrl =
      "https://api.unsplash.com/photos/?client_id=fpWQaUGwgtj-hajRVh_YtGoHrjFKaicc4IXcHOzkvkw";
  // "https://api.unsplash.com/photos/random/?client_id=fpWQaUGwgtj-hajRVh_YtGoHrjFKaicc4IXcHOzkvkw";

  static const String randomUrl =
      "https://api.unsplash.com/photos/random/?client_id=fpWQaUGwgtj-hajRVh_YtGoHrjFKaicc4IXcHOzkvkw";
  // "https://api.unsplash.com/photos/?client_id=fpWQaUGwgtj-hajRVh_YtGoHrjFKaicc4IXcHOzkvkw";

  static Future<List<PhotoModel>> getPhotos(
      int pageNumber, List<PhotoModel> instances) async {
    List<PhotoModel> photoInstances = instances;
    String page = pageNumber.toString();
    final url = Uri.parse('$homeUrl&page=$page');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final photos = jsonDecode(response.body);

      for (var photo in photos) {
        final instance = PhotoModel.fromJson(photo);

        photoInstances.add(instance);
      }
      return photoInstances;
    }
    throw Error();
  }

  static Future<PhotoModel> getRandomPhotos(int pageNumber) async {
    String page = pageNumber.toString();
    final url = Uri.parse('$randomUrl&page=$page');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final photos = jsonDecode(response.body);
      final instance = PhotoModel.fromJson(photos);
      return instance;
    }
    throw Error();
  }

  static Future<List<PhotoModel>> getLikedPhotos() async {
    List<PhotoModel> likedPhotos = [];
    final prefs = await SharedPreferences.getInstance();
    final likedPhotoIds = prefs.getStringList('likedPhotos');
    if (likedPhotoIds == null) {
      print('nolikedApi');
      return likedPhotos;
    } else {
      for (String photoId in likedPhotoIds) {
        final username = prefs.getString('${photoId}_username') ?? 'null';
        final description = prefs.getString('${photoId}_description') ?? 'null';
        print(photoId);
        likedPhotos.add(PhotoModel(
            id: photoId, username: username, description: description));
      }

      return likedPhotos;
    }
  }
}
