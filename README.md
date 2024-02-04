<프로그라피 AOS 과제>

1. 3가지 Service 소개
   (모두 services/api_service.dart에 포함되어있음)

1) getPhotos(
   int pageNumber, List<PhotoModel> instances)
   소개: 홈화면의 최신 이미지를 가져오는 서비스이다.
   특징: 무한 로딩을 구현하기 위해, 인자 instances 는 기존 홈화면에 표시된 사진 List를 담아온다.

2) getRandomPhotos(int pageNumber)
   소개: 랜덤화면의 랜덤 사진을 가져오는 서비스이다.

3) getLikedPhotos()
   소개 : 홈화면의 북마크 이미지를 가져오는 서비스이다.
   특징 : 로컬 db는 SharedPreferences 플러그인을 사용해 구현했다.

2. 로컬 db 상세 설명

북마크 된 이미지에 대한 세가지 내용을 저장했다.  
이미지의 tag는 가져오는 것을 실패했다. (주어진 api에서 tag를 찾지 못하였다.)

1. 이미지 링크
   sharedPreference 의 data 저장 형태 중 (String, StringList) 형태를 사용했다.
   String 은 'LikedPhotos'로 두고,
   String 리스트에 북마크한 이미지의 링크들을 저장하였다.

2. 이미지 유저네임
   sharedPreference 의 data 저장 형태 중 (String, String) 형태를 사용했다.
   첫번째 String은 '$(이미지링크) + 유저네임'으로 두고,
두번째 String에 '$(유저네임)'을 저장하였다.

3. 이미지 설명
   sharedPreference 의 data 저장 형태 중 (String, String) 형태를 사용했다.
   첫번째 String은 '$(이미지링크) + 설명'으로 두고,
두번째 String에 '$(설명)'을 저장하였다.

3) 랜덤 화면의 스와이핑 애니메이션 구현

dart에서 기본 제공되는 widget인 Stack과, 외부 패키지인 swipe_cards 를 활용하여 구현하였다.
