# Coordinator 트러블 슈팅 (NavigationController를 오래 들여다보면, 그 또한 너도 들여다본다.)

<br/><br/>

## 개요 
`UINvagationController가` `TabBarViewController를` RootViewController로 가진 구조에서  RootViewController(TabBarViewController)를 새로만들때 `TabBarViewController` 의 `ContentViewController가` 메모리에서 해제되지 않는 문제가 발생했습니다. 그러니까 쓰던 기존에 있던 TabBarViewController를 쓰지 않고, 새로운 TabBarViewController를 갈아끼면서 내부 사라져야 할 NavigationController와 ViewController는 사라지지 않았습니다.

### NvaigationViewController 구조

![image](https://github.com/MaraMincho/MakingFrogWithoutDissecting/assets/103064352/ee039523-696a-4ae2-95f9-b29c7fbc3f00)

### Coordinator를 포함한 구조
코디네이터의 경우 화살표가 거꾸로 되어있습니다. Child와 Parent로 구현했기 떄문입니다.
![image](https://github.com/MaraMincho/MakingFrogWithoutDissecting/assets/103064352/4a5f5a7e-22f3-4e13-8705-3ccfd005bc81)



### Delegate를 연결한 Shared모듈

![image](https://github.com/MaraMincho/MakingFrogWithoutDissecting/assets/103064352/3fd3a14f-2142-44bb-a458-ccd4129c3774)


<br/><br/>


## 코디네이터의 순환 참조 문제

코디네이터의 순환참조 문제가 발생했는데요, Common 발생 원인은 다음과 같습니다.

<br/>

1. ParentCoordinator 를 Weak 으로 선언하지 않음
2. ViewController와 ViewModel사이의 순환참조로 인해 NavigationController가 죽지 않음


저는 Common Error사항에 해당되지 않았습니다. 제가 마딱뜨린 에러상황은 NavigationController를 Coordinator가 NavigationController를 강한참조를 통해서  

![image](https://github.com/MaraMincho/MakingFrogWithoutDissecting/assets/103064352/0fc52dda-b61d-48c1-90b0-3bf3bbbfa05e)