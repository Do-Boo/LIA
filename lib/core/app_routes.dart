// File: lib/core/app_routes.dart
// 🧭 앱 라우팅 상수 정의

/// 앱의 모든 라우팅 경로를 관리하는 클래스
///
/// 모든 화면의 라우팅 경로를 중앙에서 관리하여
/// 일관성과 유지보수성을 향상시킵니다.
class AppRoutes {
  // Private constructor to prevent instantiation
  AppRoutes._();

  /// 홈 화면 (메인 대시보드)
  static const String home = '/';

  /// 메인 레이아웃 (하단 네비게이션 포함)
  static const String mainLayout = '/main';

  /// AI 메시지 생성 화면
  static const String aiMessage = '/ai-message';

  /// 코칭 센터 화면
  static const String coachingCenter = '/coaching-center';

  /// 히스토리 화면
  static const String history = '/history';

  /// MY 화면 (프로필 및 설정)
  static const String my = '/my';

  /// 분석된 사람들 화면
  static const String analyzedPeople = '/analyzed-people';

  /// 차트 데모 화면
  static const String chartDemo = '/chart-demo';

  /// 디자인 가이드 화면
  static const String designGuide = '/design-guide';

  /// 가상 채팅 화면
  static const String virtualChat = '/virtual-chat';

  /// 알림 화면
  static const String notification = '/notification';

  /// 모든 라우팅 경로 목록
  static const List<String> all = [
    home,
    mainLayout,
    aiMessage,
    coachingCenter,
    history,
    my,
    analyzedPeople,
    chartDemo,
    designGuide,
    virtualChat,
    notification,
  ];

  /// 라우팅 경로 유효성 검사
  static bool isValidRoute(String route) => all.contains(route);

  /// 라우팅 경로에서 화면 이름 추출
  static String getScreenName(String route) {
    switch (route) {
      case home:
        return '홈';
      case mainLayout:
        return '메인';
      case aiMessage:
        return 'AI 메시지';
      case coachingCenter:
        return '코칭센터';
      case history:
        return '히스토리';
      case my:
        return 'MY';
      case analyzedPeople:
        return '분석된 사람들';
      case chartDemo:
        return '차트 데모';
      case designGuide:
        return '디자인 가이드';
      case virtualChat:
        return '가상 채팅';
      case notification:
        return '알림';
      default:
        return '알 수 없음';
    }
  }
}

/// 네비게이션 탭 인덱스
class NavigationTabs {
  // Private constructor to prevent instantiation
  NavigationTabs._();

  /// 홈 탭
  static const int home = 0;

  /// 코칭센터 탭
  static const int coachingCenter = 1;

  /// AI 메시지 탭 (중앙 버튼)
  static const int aiMessage = 2;

  /// 히스토리 탭
  static const int history = 3;

  /// MY 탭
  static const int my = 4;

  /// 모든 탭 인덱스 목록
  static const List<int> all = [home, coachingCenter, aiMessage, history, my];

  /// 탭 인덱스 유효성 검사
  static bool isValidTabIndex(int index) => all.contains(index);

  /// 탭 인덱스에서 라우팅 경로 가져오기
  static String getRouteFromTabIndex(int index) {
    switch (index) {
      case home:
        return AppRoutes.home;
      case coachingCenter:
        return AppRoutes.coachingCenter;
      case aiMessage:
        return AppRoutes.aiMessage;
      case history:
        return AppRoutes.history;
      case my:
        return AppRoutes.my;
      default:
        return AppRoutes.home;
    }
  }

  /// 라우팅 경로에서 탭 인덱스 가져오기
  static int getTabIndexFromRoute(String route) {
    switch (route) {
      case AppRoutes.home:
        return home;
      case AppRoutes.coachingCenter:
        return coachingCenter;
      case AppRoutes.aiMessage:
        return aiMessage;
      case AppRoutes.history:
        return history;
      case AppRoutes.my:
        return my;
      default:
        return home;
    }
  }
}
