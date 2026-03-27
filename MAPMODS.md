# 지도 옵션 데이터 추출 가이드 (MAPMODS.md)

이 문서는 `assets/data/mapping_completed.json`의 데이터를 구축/갱신하는 과정을 기록합니다.

## 데이터 소스

| 소스 | 용도 |
|------|------|
| [poedb.tw/kr/Maps_uber_tier](https://poedb.tw/kr/Maps_uber_tier) | 맵 옵션 원본 텍스트, affix(prefix/suffix), 부가 수치(IIQ/IIR/PackSize/Scarab/Currency/Map) |
| `assets/data/explicit_kr.json` (출처: https://poe.game.daum.net/api/trade/data/stats) | `explicitCode` 조회 (한글 텍스트 → `explicit.stat_*` ID 매핑) |
| `assets/data/explicit_en.json` (출처: https://www.pathofexile.com/api/trade/data/stats) | `contentEn` 조회 (`explicitCode` → 영문 텍스트 매핑) |

## 추출 과정

### 1단계: poedb에서 원본 데이터 수집

poedb의 맵 옵션 페이지에서 아래 4가지 구분으로 md 파일을 작성합니다.

| 파일명 | 구분 |
|--------|------|
| `assets/data/nomal_prefix.md` | 일반(normal) 접두어(prefix) |
| `assets/data/normal_suffix.md` | 일반(normal) 접미어(suffix) |
| `assets/data/uber_prefix.md` | 악몽(nightmare/uber) 접두어(prefix) |
| `assets/data/uber_suffix.md` | 악몽(nightmare/uber) 접미어(suffix) |

각 라인은 poedb에서 복사한 원본 텍스트입니다. 구조:

```
[가중치 등 내부 숫자]모드 설명 텍스트이 지역에서 발견하는 아이템 수량 N% 증가이 지역에서 발견하는 아이템 희귀도 N% 증가무리 규모 N% 증가[지역에서 발견하는 갑충석/화폐/지도 N% 증폭][태그들]
```

### 2단계: MD 파싱 및 수치 추출

각 라인에서 정규식으로 추출:

| 패턴 | 필드 |
|------|------|
| `아이템 수량 (\d+)% 증가` | `addIiq` |
| `아이템 희귀도 (\d+)% 증가` | `addIir` |
| `무리 규모 (\d+)% 증가` | `addPackSize` |
| `갑충석 (\d+)% 증폭` | `addScarab` |
| `화폐 (\d+)% 증폭` | `addCurrency` |
| `지도 (\d+)% 증폭` | `addMap` |

- `#%`로 표기된 값은 추출 불가 → poedb에서 티어별 상세 페이지 확인하여 수동 입력.
- `이 지역에서` 앞까지가 모드 설명 텍스트.
- 앞의 숫자(가중치)와 뒤의 태그(피해, 물리, 원소 등)는 제거.

### 3단계: 기존 JSON과 매칭

MD에서 추출한 모드 텍스트를 `mapping_completed.json`의 `contentKr`과 비교하여 매칭합니다.

**매칭 방법:**
1. MD 텍스트의 숫자/범위를 `#`으로 치환: `(30—40)` → `#`, `100` → `#`
2. 치환된 텍스트를 기존 JSON의 `contentKr` (동일 `kind`)과 비교
3. 포함 관계 또는 정규화 문자열 일치로 매칭

**주의사항:**
- poedb 텍스트와 `explicit_kr.json` 텍스트가 다를 수 있음
  - 예: poedb `플레이어의 방어력 #% 감폭` vs explicit_kr `플레이어의 방어력 #% 증폭`
  - 예: poedb `몬스터의 주문 명중 시 이동 방해 유발` vs explicit_kr `몬스터의 주문 명중 시 #%의 확률로 이동 방해 유발`
- 이런 경우 `queryKr` 필드에 `explicit_kr.json` 기준 텍스트를 별도 저장

### 4단계: explicitCode 조회

`contentKr` (또는 `queryKr`)을 `explicit_kr.json`에서 검색하여 `explicitCode`를 얻습니다.

- **반드시 `type: "explicit"`만 필터링** (pseudo, fractured, enchant 등 제외)
- 합성 모드(한 옵션에 여러 효과)는 `explicitCode`를 **배열**로 저장
- `contentEn`은 `explicitCode`로 `explicit_en.json`에서 조회

### 5단계: regexKr / regexEn 생성

- 기존 normal 모드에 regex가 있으면 nightmare(uber) 대응 모드에 복사
- 신규 모드는 수동으로 짧은 정규식 작성 (인게임 검색용)

## 최종 스키마

```json
{
  "type": "map",
  "kind": "normal | nightmare",
  "affix": "prefix | suffix",
  "explicitCode": ["explicit.stat_xxx", ...],
  "contentKr": "모드 설명 (한글, #으로 수치 대체)",
  "contentEn": "모드 설명 (영문, explicit_en.json 기준)",
  "queryKr": "explicit_kr.json 매칭용 (contentKr과 다를 때만)",
  "regexKr": "인게임 검색용 짧은 정규식 (한글)",
  "regexEn": "인게임 검색용 짧은 정규식 (영문)",
  "addIiq": 16,
  "addIir": 56,
  "addPackSize": 6,
  "addScarab": 35,
  "addCurrency": 47,
  "addMap": 35
}
```

- `explicitCode`: 항상 배열. 합성 모드는 복수 코드.
- `queryKr`: `contentKr`과 `explicit_kr.json` 텍스트가 일치하면 생략.
- `add*` 필드: 값이 없으면 필드 자체 생략.
