## Observation


## Whate is Observation
- @Observation은 프로퍼티의 변화를 추정하는 swift의 신기능입니다.
- @Observable은 Property의 모든 접근을 추적합니다.그리고 이 추적정보를 이용해 특정 인스턴스에서 프로퍼티에 다음 변화가 언제 일어날지를 예측합니다.
- Observable을 통해서 Observation을 추가합니다. 그리고 Observation에서 다음 프로퍼티가 언제 변할지 관찰 할 수 있습니다.


## Swiftui Property Wrappers
- State, Bindable, Enveiorment
- Environment의 Property type에 @Observable을 추가해 Observing합니다.
- Bindalbe
  - ighetweight
  - $를 활용하여 Binding이 필요한 곳에 Binding하면 됩니다. 