// Mock 클래스 생성을 위한 파일
// 다음 명령어로 mock 클래스를 생성할 수 있습니다:
// dart run build_runner build

import 'package:flutter/material.dart';
import 'package:lia/services/analysis_data_service.dart';
import 'package:mockito/annotations.dart';

@GenerateNiceMocks([
  MockSpec<AnalysisDataService>(),
  MockSpec<BuildContext>(),
  MockSpec<Navigator>(),
  MockSpec<TextEditingController>(),
  MockSpec<AnimationController>(),
  MockSpec<TabController>(),
])
void main() {}
