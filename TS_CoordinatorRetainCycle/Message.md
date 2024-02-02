<br/><br/>

## 단방향 의존관계에서 상위 Coordinator에게 메시지를 전달하는 방법
단방향 코디네이터에서 가장 상위뷰 코디네이터에게 메시지를 전달하고 싶습니다. 어떻게 해결해야 할까요? 이부분에 대해서 많은 고민을 했습니다. 

<br/>

### NotificationCenter
Coordinator에게 NotificationCenter를 통해서 메시지를 전달하는 방법이 있었습니다. Notification을 호출하여 가장 상위뷰에서 Coordinator Reset작업을 실행하는 방법을 고안했습니다.

![image](https://github.com/MaraMincho/MakingFrogWithoutDissecting/assets/103064352/6ee1dde5-53bc-46bd-a854-9c460b619afd)


### Delegate
NotificatonCenter를 활용하지 않는 방식인 Delegate를 활용할 수도 있습니다. 상위 RootCoordinator에서 Shared 모듈에 Delegate를 구현함으로서 여태 생성했던 child Router를 완전하게 버리고 새로운 Router를 만듭니다. 여기서 하위 Coordinator는 상위 Coordinator를 모릅니다. **참조관계에 따라서 알면 안됩니다.** 이를 통해서 Shared Delegate로 Reset을 수행하게 합니다. 

![image](https://github.com/MaraMincho/MakingFrogWithoutDissecting/assets/103064352/f477062a-e42d-499b-b509-260f2e394af9)

<br/><br/>