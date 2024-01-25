
<br/>

# 시연 동영상
|iPhone Pro|iPhone SE|
|:-:|:-:|
|<img src="https://github.com/MaraMincho/MakingFrogWithoutDissecting/assets/103064352/48f58058-a8de-4ae3-bbab-3ecc6605bc19" width=250 height=580>|<img src="https://github.com/MaraMincho/MakingFrogWithoutDissecting/assets/103064352/46905af8-908f-4237-8b4b-9dcad53a38b1" width=250 height=580>|

<br/><br/>

# API키 설정 방법
### XCConfig를 통해서 API키 설정

```swift
프로젝트를 받은 폴더에서
$ vim Config.xcconfig

APIKey=<에이피아이키>
```

### 직접 API키 설정
`Data/Repositories/ExchangingRateRepository.swift` 에서 `let access_key = Bundle.main.infoDictionary?["APIKey"] as? String`을 상기 환율 정보를 받아올 사이트의 API키를 넣으면 됩니다.
- ex) `let access_key = iamAPIKey`

<br/><br/>

## 목차
- [시연 동영상](#시연-동영상)
- [API키 설정 방법](#api키-설정-방법)
    - [XCConfig를 통해서 API키 설정](#xcconfig를-통해서-api키-설정)
    - [직접 API키 설정](#직접-api키-설정)
  - [목차](#목차)
- [작성 코드 설명](#작성-코드-설명)
  - [CleanArchitecture 사용](#cleanarchitecture-사용)
    - [API를 통한 데이터 흐름](#api를-통한-데이터-흐름)
  - [ViewModel과 View의 데이터 흐름](#viewmodel과-view의-데이터-흐름)
    - [Input, Output패턴을 활용하여 그런데 Combine을 곁들인](#input-output패턴을-활용하여-그런데-combine을-곁들인)
    - [간단한 예제를 통해서 설명 (만약 **나라를 선택하는 Picker가 클릭된다면?**)](#간단한-예제를-통해서-설명-만약-나라를-선택하는-picker가-클릭된다면)
  - [비동기 데이터 흐름](#비동기-데이터-흐름)
    - [Picker를 선택하고 업데이트](#picker를-선택하고-업데이트)
    - [데이터를 받고 나서 Picker를 통해 다른 나라로 변경](#데이터를-받고-나서-picker를-통해-다른-나라로-변경)
    - [Fetching중에 Fetching하지 않게 하기](#fetching중에-fetching하지-않게-하기)
    - [하나의 유즈케이스에서 모든 데이터를 처리](#하나의-유즈케이스에서-모든-데이터를-처리)
    - [유즈케이스를 분리하여, Fetching과 Convert를 분리하여 처리하기\<변경 후\>](#유즈케이스를-분리하여-fetching과-convert를-분리하여-처리하기변경-후)



<br/><br/>

# 작성 코드 설명

## CleanArchitecture 사용
클린 아키텍쳐를 고려했던 이유는 단 한가지 였습니다. **테스트작성의 수월함** 이었습니다. 클린아키텍쳐를 통해서, 의존성 역전 원칙을 각 Layer마다 적용하였습니다. 이를 통해서 Test를 작성함에 있어서 **Mock객체를** 통한 테스트가 쉬워졌습니다.데이터 흐름은 API를 통해서 DataLayer -> DomainLayer -> PresenationLayer로 이루어졌습니다. <br/> 또한 파일을 나누어 최대한 **인터페이스 분리 원칙**과  **단일 책임 원칙**를 적용하려고 노력했습니다. 이를 통해서 로직의 수정이나 요구사항 변경에 유연한 대처를 할 수 있게 되었습니다. 

![image](https://github.com/MaraMincho/MakingFrogWithoutDissecting/assets/103064352/c42ce4aa-079b-45b1-bf6f-bb0b2ed8dac2)


<br/>

### API를 통한 데이터 흐름
![image](https://github.com/MaraMincho/MakingFrogWithoutDissecting/assets/103064352/87b00bd9-10a1-4ad1-a535-bb79562fa6a0)


<br/><br/>
## ViewModel과 View의 데이터 흐름
### Input, Output패턴을 활용하여 그런데 Combine을 곁들인
- ViewModel과 View의 단방향 데이터 흐름에 대해서 고민했습니다.
- Interaction과 State는, View and ViewModel에 Input And Output패턴을 활용하여 구현했습니다.
<br/>

- View와ViewModel에 관한 데이터 흐름을 간략하게 하면 다음과 같습니다
  
![image](https://github.com/MaraMincho/MakingFrogWithoutDissecting/assets/103064352/33b1138b-96e3-4547-9f02-f36c6d81f59a)



  ```swift
    struct ExchangingRateViewModelInput {
        let didSelectIndexPublisher: AnyPublisher<Int, Never>
        let textFieldTextPublisher: AnyPublisher<String?, Never>
        let fetchLiveDataPublisher: AnyPublisher<Void, Never>
    }

    enum ExchangingRateViewControllerState {
        case updateCountry(value: ExchangingRateViewUpdatableProperty)
        case idle
        case emptyTextField
        case wrongTextFieldText
        case updateExchangeConvertedText(value: String)
        case updateTimeStamp(time: String)
        case fetch(FetchState)
    }

    enum FetchState {
        case running
        case done
    }

    typealias ExchangingRateViewModelOutput = AnyPublisher<ExchangingRateViewControllerState, Never>
  ```
<br/>

### 간단한 예제를 통해서 설명 (만약 **나라를 선택하는 Picker가 클릭된다면?**)
1. 현재 선택된 Picker의 row가 아닌 다른 row를 선택 
2. ViewController는 Picker가 바뀌었다는 사실을 Publisher에게 전달
3. Publisher를 subscribed했던 **ViewModel** 은 이 값에 따른 **적절한 ViewState을 생성 후 다시 전달(적절하게 transform)** 
4. 이 State를 View가 받고 View는 적절한 상태로 업데이트
 
![image](https://github.com/MaraMincho/MakingFrogWithoutDissecting/assets/103064352/c16a4dfc-b7bc-425b-b205-35dac0a6bd7d)


<br/><br/>

## 비동기 데이터 흐름
앱에서는 복잡한 데이터 흐름이 존재했습니다. 네트워크 통신을 기준으로 다양한 상태가 있을 것으로 생각했습니다. 네트워크에서 데이터를 가져오는 Main흐름과, 첫번째 데이터를 받고 난 후, Picker를 선택했을 때 보여줘야 할 상황 등 정말 많은 상황이 있었습니다. 이를 도식화하여 정리하고 테스트코드로 정리했습니다. 

### Picker를 선택하고 업데이트
기본적인 상황 입니다. 데이터를 받은 후 TextField를 통해서 데이터를 입력하는 흐름입니다.
![image](https://github.com/MaraMincho/MakingFrogWithoutDissecting/assets/103064352/0e25dd8d-db43-494a-85ea-69245f3b65cd)

### 데이터를 받고 나서 Picker를 통해 다른 나라로 변경
처음 데이터를 받고 Picker를 통해 나라를 변경 하면, 새로운 데이터를 Fetching합니다.Fetching할 때 두가지 상황이 존재했습니다.
   1. 사용자에게 현재 Fetching중이니 기다려라
   2. 이전 데이터를 활용하여 환율 정보를 보여주고, Network통신이 완료되자 마자 새로운 데이터를 활용하여 환율 정보를 보여준다.

저는 두가지 선택지 중에서 **2**선택지를 골랐습니다.
![image](https://github.com/MaraMincho/MakingFrogWithoutDissecting/assets/103064352/70f8649f-e6a9-4501-b026-6844a2d7ad8b)


<br/>

### Fetching중에 Fetching하지 않게 하기
현재 Fetching중인지 확인하는 로직을 넣어서 API를 중복 호출하지 않게 막았습니다. 
- API를 중복 통신하는 시나리오
![image](https://github.com/MaraMincho/MakingFrogWithoutDissecting/assets/103064352/531ee7b6-e8a1-47fa-92fd-0129ccd0c430)





### 하나의 유즈케이스에서 모든 데이터를 처리
UseCase에서 ViewModel에 관한 모든 정보를 처리했습니다.(Picker가 가져야 할 데이터 갯수, title 정보 등등...) 이렇게 하나의 모든 비지니스 로직을 처리한 이유는 UseCase에서 이미 안 정보를 Network을 통해 업데이트 해야했기 때문입니다. 그 예시는 다음과 같습니다. 
- 한국의 환율 계산 요청을 보내기 전에 **우리는 한국의 Unit(KRW)에 대해 이미 알고 있다.
- 데이터 요청을 보내기 전 어떤 나라들이 View에 표시될 지 알고 있다.

<br/> 
위와 같은 이유로 하나의 UseCase에서 Network과 Bussiness로직을 처리했습니다. 아래는 데이터 흐름에 대한 그림입니다.

```Swift
  // TextField값이 전달 된다면, UseCase를 통해서 적절한 값을 전달하는 Pubilsher입니다
    let textfieldOutput: ExchangingRateViewModelOutput = input
      .textFieldTextPublisher
      .map { [weak self] text in
        guard
          let self,
          let text,
          let result = try? useCase.applyQuote(text: text, row: currentIndex)
        else {
          return ExchangingRateViewControllerState.idle
        }
        switch result {
        case let .success(string):
          let unit = useCase.countryUnit(index: currentIndex) ?? ""
          return ExchangingRateViewControllerState.updateExchangeConvertedText(value: string + unit)
        case .emptyInput:
          return ExchangingRateViewControllerState.emptyTextField
        case .invalidInput:
          return ExchangingRateViewControllerState.wrongTextFieldText
        case .nowFetching:
          return ExchangingRateViewControllerState.fetch(.running)
        case .error:
          return ExchangingRateViewControllerState.wrongTextFieldText
        }
      }
      .eraseToAnyPublisher()

```
![image](https://github.com/MaraMincho/MakingFrogWithoutDissecting/assets/103064352/f29046de-6f44-4c4d-81d5-2bfe86e1db57)



### 유즈케이스를 분리하여, Fetching과 Convert를 분리하여 처리하기<변경 후>
코드 작성 후 UseCase에서 모든 비지니스 로직을 처리하는 것 보다 두개의 UseCase에서 처리하는 것은 어떨까에 대한 생각을 해봤습니다. 그래서 작성된 코드를 리팩토링 했습니다.
하나의 UseCase에서 두가지 일을 하는 것에 대해서 의문이 들었습니다. 또한 UseCase에서 통화를 변경할 **Country**를 직접 **가지고 있는 것이 과연 옳은가에 대해서** 고민했습니다.
   1. ViewModel에서 가져야 할 현재 `liveData`가 과연 UseCase에서 관리되는게 맞을까? (이전 코드에서는 Picker의 Count나 title을 얻으려면 UseCsae에서 얻어야 했음)
   2. 하나의 UseCase에서 Quote와 fetch를 하는 것이 맞을까?

<br/>
위의 두 가지 이유 때문에 리팩토링을 했습니다. 리팩토링 후에는 각각 UseCase로 하나의 Bussiness로직을 수행합니다. 각각의 UseCase는 서로를 모르는 모듈처럼 행동합니다.

- ConvertedUseCsae
- FetchUseCase

아래는 리팩토링 이후 변경된 데이터 흐름입니다.
![image](https://github.com/MaraMincho/MakingFrogWithoutDissecting/assets/103064352/deef2fd4-7cca-4852-9bac-d2e4fe080f7c)


<br/><br/>