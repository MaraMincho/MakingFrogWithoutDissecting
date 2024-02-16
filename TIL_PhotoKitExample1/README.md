 ### What is Photo Picker


 ### What is PHPicker?
 사진과 비디오를 시템에서 선택할 수 있게 제공되는 것 입니다. 이제 사진 앱과 마찬가지로 검색을 위한 내장 지원이 제공됩니다. 그리드에서 유체 줌을 지원합니다. 그리고 매우 자주 요청되는 기능인 타사 앱을 위한 다중 선택 기능으로, 하나에서 선택 내용을 검토할 수도 있습니다. PHPicker는 앱이 사진의 사진 및 비디오 데이터에 액세스하는 가장 좋은 방법입니다. 그렇지만, PHPicker는 앱 안에서 실행되는 것처럼 보이지만 별로 실행됩니다. 그것은 실제로 그 위에 렌더링된 호스트 앱과 별개의 프로세스에서 실행됩니다. 그러나 앱은 피커에 직접 액세스할 수 없고 피커 콘텐츠의 스크린샷도 촬영하지 않습니다. (실제로 별도의 앱이기 때문에 권한이 없어서)
 

 ### New Feature API 

 현재 API의 데이터 흐름도 입니다.

 ![image](https://github.com/MaraMincho/MakingFrogWithoutDissecting/assets/103064352/4b9c7fa6-992d-45a4-85b8-d4625ceca407)
 

 ### configruation이 하는 역할
 
```swift
import PhotosUI

var configuration = PHPickerConfiguration()

// “unlimited” selection by specifying 0, default is 1
configuration.selectionLimit = 0

// Only show images (including Live Photos)
configuration.filter = .images
// Uncomment next line for other example: Only show videos or Live Photos (for their video complement), but no images
// configuration.filter = .any(of: [.videos, .livePhotos])

```

![image](https://github.com/MaraMincho/MakingFrogWithoutDissecting/assets/103064352/28ebd77a-79c6-4740-bc1b-65ce519cb5c8)
