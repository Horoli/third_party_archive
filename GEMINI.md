# GEMINI.md - Third Party Archive 프로젝트 가이드

이 문서는 `third_party_archive` 프로젝트의 구조, 기술 스택 및 개발 규칙에 대한 최신 개요를 제공합니다.

## 프로젝트 개요
`third_party_archive`는 **Path of Exile (PoE) 1 & 2**를 위한 서드파티 리소스 및 정보 보관소 앱입니다. 시세 확인, 잔돈 계산, 갑충석 필터링 정규식 복사, 지도 옵션 필터링 및 거래소 연동 등 게임 플레이에 최적화된 도구들을 제공합니다.

### 주요 기술 스택
- **Framework:** Flutter (Dart)
- **State Management:** [GetX](https://pub.dev/packages/get) (전역 컨트롤러를 통한 언어 및 데이터 관리)
- **Networking:** [http](https://pub.dev/packages/http) (poe.ninja 연동)
- **Localization:** 실시간 전환 가능한 통합 i18n 시스템 (KO/EN)
- **Local Storage:** [SharedPreferences](https://pub.dev/packages/shared_preferences) (즐겨찾기, 히스토리 캐시)

## 프로젝트 구조 및 아키텍처
Dart의 `library`와 `part` 패턴을 사용하여 소스 코드를 체계적으로 관리합니다.

- `lib/third_party_archive.dart`: 프로젝트 메인 라이브러리 및 모든 모델, 서비스, 위젯 등록소.
- `lib/service/get_dashboard.dart`: **전역 상태 컨트롤러**. 앱 전체의 언어 설정(`isKorean`)을 관리합니다.
- `lib/view/poe_one/home/abstract.dart`: 메인 UI 프레임워크. 전역 FAB와 정보 인터페이스를 정의합니다.
- `lib/widget/ninja_sync_info.dart`: 데이터 동기화 시간을 표준화하여 보여주는 공통 위젯입니다.
- `lib/widget/map_mod_bookmark.dart`: 지도 옵션 필터 즐겨찾기/히스토리 공용 위젯입니다. (`static RxInt`를 활용한 다중 인스턴스 동기화)

## 주요 업데이트 요약 (2026-03-25)
1.  **지도 옵션 필터 (Map Mod Filter) 신규 기능**:
    - `assets/data/mapping_completed.json`에서 맵 옵션 데이터를 로드하여 일반/악몽 옵션으로 분류 표시.
    - **다중 선택** → Regex 추출(255자 한도) → 클립보드 복사 또는 POE 거래소 리다이렉션.
    - **거래소 쿼리 옵션**: 8모드, 허상(Mirage), T16/악몽 토글, 아이템 수량(IIQ), 아이템 희귀도(IIR), 무리 규모(Pack Size) 설정.
    - **즐겨찾기**: 선택 상태 + 쿼리 옵션을 로컬 스토리지에 저장 (최대 10개, 가득 차면 추가 불가). 이름 변경 지원.
    - **히스토리**: 거래소 이동, Regex 복사, 즐겨찾기 저장 시 자동 기록 (최대 10개, 라운드로빈).
    - **공용 위젯 (`WidgetMapModBookmark`)**: 즐겨찾기/히스토리 패널을 재사용 가능한 위젯으로 분리. landscape 우측 패널(잔돈 계산기 하단)과 지도 옵션 필터 좌측 패널에서 공유.
    - **인앱 검색**: 옵션명(한/영)으로 실시간 필터링.
    - **섹션 토글**: 일반/악몽 옵션을 드롭다운으로 접기/펼치기, 가로 2열 배치.
2.  **Scarab Price Table 가격 구간 개편**:
    - 기존 5단계(40/20/10/4/~) → 4단계(40/10/4/4~1/1↓)로 변경.
    - 색상 구간도 4단계로 통일 (40+/10+/4+/1+/~).
3.  **UI 스타일 통합 (2026-03-25)**:
    - **글로벌 토글 버튼 위젯 (`WidgetToggleButton`)**: amber 테마 토글 버튼을 공용 위젯으로 분리하여 앱 전역에서 재사용.
    - 적용 대상: 카테고리 선택, 태그 네비게이션, 시세확인 타입 선택, 잔돈 계산기 구매/판매, 지도 옵션 T16/악몽 토글, 언어 전환(KR/EN).
    - `floatingLabelBehavior: always`를 적용하여 입력값이 있어도 라벨이 항상 표시.
    - **시세확인 목록 (TilePoeItem)**: ListTile → 커스텀 타일로 개편. 아이콘/가격 정렬 통일, 목록 패널 간 VerticalDivider 추가.
    - **써드파티 앱 목록 (TileThirdParty)**: ElevatedButton → 아웃라인 스타일로 변경, i18n 적용.
    - **언어 전환 버튼**: 단일 FAB → KR/EN 토글 버튼 분리, 활성 언어에 amber 강조.
    - **동기화 시간 툴팁**: 오탈자 수정 (`Synced by poe.ninja :` → `poe.ninja 동기화 시간`).
4.  **기존 기능 유지**:
    - 갑충석 시세표, 잔돈 계산기, 통합 정보 인터페이스, 날짜 처리 고도화 등.

## 상세 문서 링크
- [UI 작업 내용 (UI.md)](./UI.md)
- [다국어 및 정규식 로직 (I18N.md)](./I18N.md)

## 빌드 및 실행
```bash
flutter build web --release --no-tree-shake-icons
```
