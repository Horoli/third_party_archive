# GEMINI.md - Third Party Archive 프로젝트 가이드

이 문서는 `third_party_archive` 프로젝트의 구조, 기술 스택 및 개발 규칙에 대한 최신 개요를 제공합니다.

## 프로젝트 개요
`third_party_archive`는 **Path of Exile (PoE) 1 & 2**를 위한 서드파티 리소스 및 정보 보관소 앱입니다. 시세 확인, 잔돈 계산, 갑충석 필터링 정규식 복사 등 게임 플레이에 최적화된 도구들을 제공합니다.

### 주요 기술 스택
- **Framework:** Flutter (Dart)
- **State Management:** [GetX](https://pub.dev/packages/get) (전역 컨트롤러를 통한 언어 및 데이터 관리)
- **Networking:** [http](https://pub.dev/packages/http) (poe.ninja 연동)
- **Localization:** 실시간 전환 가능한 통합 i18n 시스템 (KO/EN)

## 프로젝트 구조 및 아키텍처
Dart의 `library`와 `part` 패턴을 사용하여 소스 코드를 체계적으로 관리합니다.

- `lib/third_party_archive.dart`: 프로젝트 메인 라이브러리 및 모든 모델, 서비스, 위젯 등록소.
- `lib/service/get_dashboard.dart`: **전역 상태 컨트롤러**. 앱 전체의 언어 설정(`isKorean`)을 관리합니다.
- `lib/view/poe_one/home/abstract.dart`: 메인 UI 프레임워크. 전역 FAB와 정보 인터페이스를 정의합니다.
- `lib/widget/ninja_sync_info.dart`: 데이터 동기화 시간을 표준화하여 보여주는 공통 위젯입니다.

## 주요 업데이트 요약 (2026-03-18)
1.  **Scarab Price Table 전면 개편**:
    - **UI/UX 개선**: 네버싱크(NeverSink) 필터 스타일의 5단계 티어 색상을 적용했습니다. 인게임 검색창의 **255자 제한**을 준수하기 위해 1c 미만 아이템들을 35개 단위로 자동 분할(Chunking)하여 여러 개의 복사 버튼(`1c↓ #1`, `#2` 등)을 생성하도록 구현했으며, 상단 버튼 바에 가로 스크롤을 적용했습니다.
    - **스마트 포맷팅**: 1c 미만은 소수점 노출, 4c 이상은 반올림 정수 표시 로직을 통해 시각적 가독성과 정보의 정확성을 모두 확보했습니다.
    - **성능 최적화**: O(N+M) 연산 도입 및 300개 이상의 개별 리스너 통합(Lifted Obx)으로 초기 로딩 지연을 제거했습니다.
2.  **지능형 정규식(Regex) 엔진**: `i18n.dart`와 Fallback 알고리즘을 결합하여 영문/국문 최적화 검색식을 생성합니다.
3.  **통합 정보 인터페이스**: 우측 하단 FAB 영역에 언어 전환과 데이터 갱신 정보를 통합하여 접근성을 높였습니다.
4.  **날짜 처리 고도화**: 비표준 로케일 날짜 형식을 정규표현식으로 정제하여 일관된 포맷(`yyyy-MM-dd HH:mm`)을 보장합니다.

## 상세 문서 링크
- [UI 작업 내용 (UI.md)](./UI.md)
- [다국어 및 정규식 로직 (I18N.md)](./I18N.md)

## 빌드 및 실행
```bash
flutter build web --release --no-tree-shake-icons
```
