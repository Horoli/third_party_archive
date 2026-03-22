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

## 주요 업데이트 요약 (2026-03-21)
1.  **Scarab Price Table 기능 고도화**:
    - **1c↓ (정리) 필터 추가**: 1c 이상의 모든 갑충석을 제외(`!`) 처리하여 인게임 보관함에서 가치가 낮은 잡 갑충석들만 골라낼 수 있는 전용 필터 버튼을 추가했습니다. (버튼 바 가장 우측 배치)
    - **버튼 UI 전면 개편 (Stack Layout)**: 인게임 아이템 슬롯 디자인을 차용하여 좌측 상단에는 카오스 오브 아이콘, 우측 상단에는 조건 라벨, 우측 하단에는 수량을 배치하여 시인성을 극대화했습니다.
    - **이미지 렌더링 최적화**: 카오스 오브 아이콘 크기를 확대(40x40)하고 `FilterQuality.high` 및 안티앨리어싱을 적용하여 자글거림 없는 선명한 화질을 구현했습니다.
    - **규격 표준화**: 모든 상단 버튼의 크기를 100x50으로 고정하고 버튼 간 간격을 동일하게 정렬했습니다.
2.  **지능형 정규식(Regex) 엔진**: 제외 필터(`!`) 로직을 통합하여 `갑충 "!정규식"` 또는 `scarab "!regex"` 형태의 고도화된 검색식을 지원합니다.
3.  **데이터 분류 로직 보강**: `GetScarabTable` 서비스에서 `overOneScarabItems` 및 `underOneScarabItems`를 실시간으로 분류하여 정확한 수량 집계를 보장합니다.
3.  **통합 정보 인터페이스**: 우측 하단 FAB 영역에 언어 전환과 데이터 갱신 정보를 통합하여 접근성을 높였습니다.
4.  **날짜 처리 고도화**: 비표준 로케일 날짜 형식을 정규표현식으로 정제하여 일관된 포맷(`yyyy-MM-dd HH:mm`)을 보장합니다.

## 상세 문서 링크
- [UI 작업 내용 (UI.md)](./UI.md)
- [다국어 및 정규식 로직 (I18N.md)](./I18N.md)

## 빌드 및 실행
```bash
flutter build web --release --no-tree-shake-icons
```
