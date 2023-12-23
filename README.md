# 저잣거리
#### 전국 전통시장을 돌아다니며 한국의 정과 지역 특색의 전통시장을 경험하고 기록하는 앱 입니다.
![‎AppStoreImage ‎002](https://github.com/strongyeom/UiKit_Example/assets/101084872/95908401-d935-4c74-a2fe-8cf85e47dd3b)
# Link

[저잣거리 앱스토어 링크](https://apps.apple.com/kr/app/%EC%A0%80%EC%9E%A3%EA%B1%B0%EB%A6%AC/id6470018379)

[블로그: 개발 과정에 따른 자세한 회고](https://yeomir.tistory.com/62)

# 개발 기간 및 인원
- 2023.09.25 ~ 2023.10.31
- 배포 이후 지속적 업데이트 중 (현재 version 1.1.0)
- 최소 버전: iOS 16.0
- 1인 개발

# 사용 기술

------
 
# 기능 구현 
- `CoreLocation`을 이용하여 현재 사용자의 위치를 활용해서 인근 전통시장을 나타내고, `Custom Annotations` 을 클릭시 전통시장에 대해 기록

------

# Trouble Shooting
### A. 네트워크 통신 후 Realm에 저장할때 오래걸리는 속도 개선 - Realm writeAsync 사용

Realm 공식문서를 확인해보니 지원해주는 메서드가 있어 리팩토링 했습니다. writeAsync 입니다.

### B. 현재 디바이스 화면에 보여지는 부분의 영역만 필터링하여 메모리 최적화

### C. Custom Annotations를 클릭하여 정보 및 기록을 할때 연속적으로 누르거나 다른 Annotations을 클릭하면 present가 되지 않는 이슈 해결


### 회고
