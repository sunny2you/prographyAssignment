<프로그라피 AOS 과제>

1. 3가지 Service 소개
   (모두 services/api_service.dart에 포함되어있음)

가. getPhotos(
int pageNumber, List<PhotoModel> instances)
소개: 홈화면의 최신 이미지를 가져오는 서비스이다.
특징: 무한 로딩을 구현하기 위해, 인자 instances 는 기존 홈화면에 표시된 사진 List를 담아온다.

나. getRandomPhotos(int pageNumber)
소개: 랜덤화면의 랜덤 사진을 가져오는 서비스이다.

다. getLikedPhotos()
소개 : 홈화면의 북마크 이미지를 가져오는 서비스이다.
특징 : 로컬 db는 SharedPreferences 플러그인을 사용해 구현했다.

2. PhotoModel 및 로컬 db 상세 설명
   PhotoModel은 이미지 링크, 유저네임, 설명. 이렇게 총 4가지 정보를 담는다.(tag는 주어진 api에서 찾지 못하였다.)
   북마크된 이미지의 경우, 이미지에 대한 세 가지의 정보를 각각의 sharedPreferences에 따로따로 저장하였다.

가. 이미지 링크(Photo.id)
sharedPreference 의 data 저장 형태 중 (String, StringList) 형태를 사용했다.
첫번째 String 은 'LikedPhotos'로 두고,
두번째 StrinList에 북마크한 이미지의 링크들을 저장하였다.

나. 이미지 유저네임(Photo.username)
sharedPreference 의 data 저장 형태 중 (String, String) 형태를 사용했다.
첫번째 String은 '$(이미지링크) + 유저네임'으로 두고,
   두번째 String에 '$(유저네임)'을 저장하였다.

다. 이미지 설명(Photo.description)
sharedPreference 의 data 저장 형태 중 (String, String) 형태를 사용했다.
첫번째 String은 '$(이미지링크) + 설명'으로 두고,
   두번째 String에 '$(설명)'을 저장하였다.

설명은 json에서 'alt_description', 'description' 중 null 이 아닌 것을 담고 있다.
그런데 가끔 둘 다 null인 이미지가 있었다.
그럴 경우 'created_at'을 담고 있다.

3.랜덤 화면의 스와이핑 애니메이션 구현(swipescreen.dart)

가. dart에서 기본 제공되는 widget인 Stack과, 외부 패키지인 swipe_cards 를 활용하여 구현
구현하였다.

나.우로 스와이핑 할 경우, initState()의 likeAction()이 실행된다.
이때, 해당 이미지에 대한 북마킹 함수도 실행된다.

다. 좌로 스와이핑 할 경우, initState()의 nopeAction()이 실행된다.
