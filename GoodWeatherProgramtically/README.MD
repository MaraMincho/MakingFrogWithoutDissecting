




[Adding UITextField on UIView Programmatically Swift](https://stackoverflow.com/questions/24710041/adding-uitextfield-on-uiview-programmatically-swift)

[iOS Swift 테이블뷰 스와이프 삭제 (TableView swipe delete)](https://gonslab.tistory.com/43)

[Task & TaskGroup](https://velog.io/@wansook0316/Task-TaskGroup)

[How to take action when a property changes - a free Swift for Complete Beginners tutorial](https://www.hackingwithswift.com/quick-start/beginners/how-to-take-action-when-a-property-changes)

### didSet, willset 매서드 정리

```swift
//
//  main.swift
//  TestProject
//
//  Created by MaraMincho on 2023/08/10.
//

import Foundation

struct App {
    var contacts = [String]() {
        willSet {
            print("")
            print("Current value is: \(contacts)")
            print("New value will be: \(newValue)")
        }

        didSet {
            print("There are now \(contacts.count) contacts.")
            print("Old value was \(oldValue)")
        }
    }
}

var app = App()
app.contacts.append("Adrian E")
app.contacts.append("Allen W")
app.contacts.append("Ish S")

============================================================

Current value is: []
New value will be: ["Adrian E"]
There are now 1 contacts.
Old value was []

Current value is: ["Adrian E"]
New value will be: ["Adrian E", "Allen W"]
There are now 2 contacts.
Old value was ["Adrian E"]

Current value is: ["Adrian E", "Allen W"]
New value will be: ["Adrian E", "Allen W", "Ish S"]
There are now 3 contacts.
Old value was ["Adrian E", "Allen W"]
Program ended with exit code: 0
```

### UITextField 매서드 정리

```swift
override func viewDidLoad() {
    super.viewDidLoad()

    let sampleTextField =  UITextField(frame: CGRect(x: 20, y: 100, width: 300, height: 40))
    sampleTextField.placeholder = "Enter text here"
    sampleTextField.font = UIFont.systemFont(ofSize: 15)
    sampleTextField.borderStyle = UITextField.BorderStyle.roundedRect
    sampleTextField.autocorrectionType = UITextAutocorrectionType.no
    sampleTextField.keyboardType = UIKeyboardType.default
    sampleTextField.returnKeyType = UIReturnKeyType.done
    sampleTextField.clearButtonMode = UITextField.ViewMode.whileEditing
    sampleTextField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
    sampleTextField.delegate = self
    self.view.addSubview(sampleTextField)
}
```

```swift
// MARK:- ---> UITextFieldDelegate

extension ViewController: UITextFieldDelegate {

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        // return NO to disallow editing.
        print("TextField should begin editing method called")
        return true
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        // became first responder
        print("TextField did begin editing method called")
    }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        // return YES to allow editing to stop and to resign first responder status. NO to disallow the editing session to end
        print("TextField should snd editing method called")
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        // may be called if forced even if shouldEndEditing returns NO (e.g. view removed from window) or endEditing:YES called
        print("TextField did end editing method called")
    }

    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        // if implemented, called in place of textFieldDidEndEditing:
        print("TextField did end editing with reason method called")
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // return NO to not change text
        print("While entering the characters this method gets called")
        return true
    }

    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        // called when clear button pressed. return NO to ignore (no notifications)
        print("TextField should clear method called")
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // called when 'return' key pressed. return NO to ignore.
        print("TextField should return method called")
        // may be useful: textField.resignFirstResponder()
        return true
    }

}

// MARK: UITextFieldDelegate <---
```

### UITableView Cell을 어떻게 삭제하지??

delegate method가 따로 있음

```swift
func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            dataArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        } else if editingStyle == .insert {
            
        }
    }
```

### 만약 TableView초기 조건( 특정 조건에 따라 이미 선택된 셀을 표시하고 싶음)

tableView가 cell을 dequeue할 때 조건을 설정해주면 된다. 아래의 코드는 현재 `VM`에 어떤  `unitType` 이 있는지 확인한다. 만드는 셀의 `UnitType` 과 VM의 `UnitType` 이 같다면 `cell.accessoryType` 을 변경해 준다.

```swift
func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: SetTemperatureTableViewCell.identifier, for: indexPath) as? SetTemperatureTableViewCell
    else {
        fatalError("it isnt work")
    }
    
    
    let curUnit = userTemperatureVM.userTemperatureUnit!
    if unitViewModel.getUnit(index: indexPath.row) == curUnit {
        cell.accessoryType = .checkmark
    }
    cell.textLabel?.text = unitViewModel.getUnitRawValue(index: indexPath.row)
    return cell
}
```

# ViewController와 View를 나누다 보니 생긴 문제들

### View안의 ViewModel을 수정하기

View의 ViewModel의 데이터 수정과 삭제를 ViewController가 수행한다. 이렇게 됨으로서 자연스레 데이터 흐름이 `ViewController` → `View` → `ViewModel` 로 이루어 지는 코드를 작성하였다. 사실 이는 ViewController의 문제인데, View가 갖고 있는 ViewModel을 ViewController에서 수정하려고 하기 때문이다. 

![image](https://github.com/MaraMincho/MakingFrogWithoutDissecting/assets/103064352/9c49f426-7f89-4a85-b3ce-88cb37a5963c)

### ViewController를 부를 때 View가 lazy하게 업데이트 되는 이슈

[[iOS] loadViewIfNeeded 이거 왜 쓰는거에요?](https://felix-mr.tistory.com/15)

어제 자료를 봤는데, ViewController에서 View는 lazy하다고 하더라 그래서 ViewController 안에 있는 View를 활성화 시키기 위해서 `_ = UIViewController.view`, `nextVC.loadViewIfNeeded()` 를 통해 View를 깨운다고 하더라. `viewDidLoad()`

![image]https://blog.kakaocdn.net/dn/s8n78/btrcXjU50QU/F9QpsnVRKHCOFayLsEPDR0/img.png

![image]https://blog.kakaocdn.net/dn/vSicX/btrc4EKdpfF/kJ75Yb18u3H0MP10cH8tOk/img.png

### 초기화와 데이터 변동 이슈

View의 데이터 설정하는 것을 ViewModel을 통해서 설정을 했다. ViewController의 로직 적인 부분이나, 만약 사용자에 의해 데이터가 수정 또는 삭제가 될 때 껄끄러운 상황이 발생한다. 예를 들어보자

![image](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/4d706b10-eca0-4780-88e1-8fb2500a1516/Untitled.png)

내가 진행한 화면 전환 시나리오 이다. ViewController를 바꾸면서 화면 전환을 하게 된다면, 

- `1번 뷰컨` 에서 `2번 뷰컨` 을 로드한다.
- `2번 뷰컨` 에  `2번 뷰` 를 일단 실행 한다.
- `2번 뷰` 의 `2번 뷰의 뷰모델` 을 `1번 뷰의 뷰모델`을 통해 업데이트 한다

이걸 코드로 나타낸다면 다음과 같다.

```swift
@objc func presentSettingScreen() {
        let nextVC = SetTemperatureUnitViewController()
        nextVC.loadViewIfNeeded()
        
        weatherStatusView.userTemperatureViewModel = UserTemperatureViewModel()
        nextVC.setTempertureUnitView.userTemperatureVM = weatherStatusView.userTemperatureViewModel
        nextVC.setTempertureUnitView.setTemperatrueDelegate = self
        
        present(nextVC, animated: true)
    }
```

보는 것과 같이 view안에 있는 viewModel을 통한 데이터 전달이 일어나는데, 이게 맞는건지 확신이 서지 않는다. 더욱이 struct라 View가 ViewModel을 소유하는 것 처럼 보여진다. 그러면 이 방법이 맞는지 의구심이 든다.

![Untitled](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/6824123b-5128-43e7-bb6a-df77147add0f/Untitled.png)

`ViewModel`을 `ViewController`가 소유 혹은, 참조를 하면서 데이터를 전달하는 방식으로 구현하는 것이 맞을까? 이 방법의 문제는 `View`와 직접연관있는 `ViewModel`을 무조건 `ViewController`를 통해 데이터를 참고해야 한다. 특히 View의 데이터 변화가 일어났을 때 `ViewController`가 `View`의 변화를 `VIewController`에서 해야할 경우가 더러 생긴다. 

### 왜 이렇게 스파게티가 되었을까?

모든 문제는 사실 **소유에서** 파생되었다. **소유**가 아닌 **참조로** 문제를 해결하면 되었지만 **“`싱글톤 패턴`을 이용하고 싶지 않아서 였다.”** 싱글톤 패턴은 대표적인 안티 패턴이다. 

- Although singletons can be helpful, they also have their disadvantages, such as:
    1. **Violation of the single responsibility principle**: Singletons violate the principle that a class should have only one reason to change and be responsible for only one thing. They tend to take on multiple responsibilities, such as creation, management, and sharing of instances.
    2. **Global coupling**: Singletons create global coupling in the code, resulting in hidden dependencies and making the code harder to understand and maintain. Changes to a singleton can have side effects on various parts of the application.
    3. **Testing difficulties**: The global coupling of singletons makes it challenging to perform unit testing since isolating their behavior during testing is challenging, making the testing process more complex and less reliable.
    4. **Concurrency and shared state**: If a singleton is poorly designed and not thread-safe, concurrency and shared state problems can occur. Multiple parts of the code may attempt to access and modify the state of the singleton simultaneously, leading to race conditions and unexpected results.

싱글톤 패턴을 사용하지 않으니, ViewModeld을 자주 갱신하고 이어줘야 했다.

### 하고싶은 말이 뭔데?

- 오늘 공부하다 보니 `[View`가 항상 `ViewController`의 ViewModel을 참고하는 편이 좋아보인다](https://www.notion.so/8-10-3788dfb0e6b64d9596e2e016a0ff8abb?pvs=21). (깔끔해 보이기도 하고) 데이터 방향도 다음이 맞을 것 같다. protocol을 활용해 `ViewController`의 `자원을 공유`하는 것이 괜찮아 보인다.
- 그래서, 어차피 모바일 앱인데, 싱글톤을 활용하는게 좋을까? 아니면 지금처럼 계속해서 `ViewController`를 통해서 `ViewModel`을 이어주는게 좋을까?

# 기능 소개

### 1. 앱을 종료해도 유지되는 데이터 저장

- `[WeatherViewModel]` 의 데이터가 변경 된다면, didSet을 활용하여 데이터를 저장한다. `saveCurrentWeathers` 을 통해 `ViewModel` 의 데이터를 저장한다.
    
    ```swift
    class WeatherListViewModel {
        
        private var weathers: [WeatherViewModel] = [] {
            didSet {
                saveCurrentWeathers()
            }
        }
        
        private func saveCurrentWeathers() {
            let curWeatherResponseList: [WeatherResponse] = weathers.map{$0.weather}
            guard let data = try? JsonHelper.jsonEncoder.encode(curWeatherResponseList) else {return}
            UserDefaults.standard.set(data, forKey: ConstUnit.WeatherResponseKey)
        }
    }
    ```
    

### 2. 종료 했던 앱을 키면, 현재 시간에 맞춰 날씨 데이터를 서버를 통해 업데이트 한다.

- 저장한 날씨 데이터가 있는지 확인한다. 만약 데이터가 있다면 현재 ViewModel의 MetaData를 추가한다.
    
    ```swift
    if let data = UserDefaults.standard.object(forKey: ConstUnit.WeatherResponseKey) as? Data{
        if let prevWeathersResponses = try? JsonHelper.jsonDecoer.decode([WeatherResponse].self, from: data) {
            prevWeathersResponses.forEach{ weathers.append(WeatherViewModel(weather: $0)) }
        }
    }
    ```
    

- 비동기적으로 저장된 메타데이터의 ind 의 city 날씨 데이터들을 업데이트 한다. 그리고 메타데이터 ind에 맞게 데이터들을 넣는다. 작업이 끝나면 count를 상승시킨다.
- 콜백이 3개나 있는데, 이를 효율적으로 처리할 방법이 생각나지 않는다. `DispatchQueue` 는 **await을 허용하지 않아서 어쩔수 없었다...**
    
    ```swift
    var count = 0
    for ind in 0..<self.numOfCitys() {
        DispatchQueue.global().async { [weak self] in
            guard let curViewModel = self?.weatherViewModel(index: ind) else {return}
            
            self?.updateWeathersVM(weatherViewModel: curViewModel) { result in
                switch result {
                case .failure(let error) :
                    print(error)
                case .success(let weatherVM) :
                    self?.weathers[ind] = weatherVM
                }
                count += 1
            }
        }
    }
    
    private func updateWeathersVM(weatherViewModel: WeatherViewModel, completion: @escaping (Result<WeatherViewModel, Error>) -> ()){
        guard let url = ConstUnit.urlByCityTemperatureUnit(city: weatherViewModel.cityName) else {return}
        let resource = Resource<WeatherResponse>(httpRequestType: .get, url: url)
    
        loadInitalWeatherDelegate?.loadWeatherData(resource: resource,completion: { result in
            switch result {
            case .failure(let error) :
                completion(.failure(error))
            case .success(let weatherViewModel):
                completion(.success(weatherViewModel))
            }
        })
    }
    
    func loadWeatherData(resource: Resource<WeatherResponse>, completion: @escaping (Result<WeatherViewModel, Error>) -> ()){
        services.load(resource: resource) { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let weatherResponse) :
                let weatherVM = WeatherViewModel(weather: weatherResponse)
                completion(.success(weatherVM))
            }
            
        }
    }
    
    func load<T:Codable>(resource: Resource<T>, completion: @escaping (Result<T, Error>) -> Void) {
        
        let urlRequest = getCurrentURLRequset(resource: resource)
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            guard error == nil else {
                return completion(.failure(error!))
            }
            guard let curStruct = try? JsonHelper.jsonDecoer.decode(T.self, from: data!) else{
                return completion(.failure(UserError.jsonDecodeError))
            }
            
            return completion(.success(curStruct))
        }.resume()
    }
    ```
    

- EventLoop을 활용하여 작업이 끝난다면 Table을 업데이트 해준다. 그냥 while true해도 되지만, 메모리를 과다하게 쓰는게 싫어서…
    
    ```swift
    DispatchQueue.global().async { [weak self] in
        while true {
            print(count)
            sleep(1)
            if count == self?.weathers.count {
                self?.loadInitalWeatherDelegate?.reloadTableViewData()
                return
            }
        }
    }
    ```
    

### 3. 목표로 하는 City 추가

- 목표로 하는 City 추가시 viweModel을 업데이트 한다.
    
    ```swift
    func updateCurrentViewModel(cityName: String) {
        guard let curURL = ConstUnit.urlByCityTemperatureUnit(city: cityName) else { return }
        
        let resource = Resource<WeatherResponse>(httpRequestType: .get, data: nil, url: curURL)
        services.load(resource: resource) { result in
            switch result {
            case .failure(let error) :
                print (error)
            case .success(let weatherResponse) :
                let weatherVM = WeatherViewModel(weather: weatherResponse)
                self.weatherStatusView.weatherListVM!.addWeatherViewModel(weatherVM)
                self.reloadTableViewData()
            }
        }
    }
    ```
    

### 4. appDelegate 코드

```swift
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UINavigationBar.appearance().backgroundColor = .systemGray4
        UINavigationBar.appearance().barTintColor = .white
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.black, .font : UIFont.systemFont(ofSize: 35, weight: .heavy)]
        UINavigationBar.appearance().prefersLargeTitles = true
        UIBarButtonItem.appearance().tintColor = .black
        
        
        return true
    }
```

### 5. ConstUnit

- constUnit을 통해서 상수값을 안전하게 접근할 수 있었습니다.

```swift
enum ConstUnit {
    static func urlByCityTemperatureUnit(city: String) -> URL?{
        let curTempUnitString = TemperatureUnit.celsius.apiCallString
        return URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=4941418c74d04be14deb3f49b9718d63&units=\(curTempUnitString)")!
    }
    static let temperatureUnitKey = "TemperatureUnitKey"
    static let WeatherResponseKey = "WeatherResponseKey"
}
```
