# How to make a completionHandler much safer

이 글은 [How to make a completionHandler much safer](https://www.swiftwithvincent.com/blog/how-to-make-a-completionhandler-much-safer)을 번역한 것 입니다. 문제시 삭제 예정입니다.


## 이 코드는 어떤 부분이 문제일까요?

![image](https://github.com/MaraMincho/MakingFrogWithoutDissecting/assets/103064352/b7aba288-0d4e-4b78-acb5-8c13805291cb)


예측하셨다 시피 CompletionHandler를 사용하여 비동기 이벤트를 처리합니다. 위험한 부분은 fetchData에서 CompletionHandler가 특정 시점에 꼭 호출되어야 합니다. 그 Completion에는 data혹은 Error을 처리합니다.

하지만, 모든 코드분기에서 CompletionHandler를 부를 것이라는 보장은 절대 없습니다!

만약 우리가 ComletionHandler를 호출하는것을 잊어버렸따면, 코드는 성공적으로 `Build`될 것 입니다. **그리고 성공적으로 빌드가 되는 것은 꽤 문제가 됩니다.**

<img src="https://github.com/MaraMincho/MakingFrogWithoutDissecting/assets/103064352/9cedeaa5-54db-4aed-90ad-310d91986a26" width = "400">




<br/><br/><br/><br/><br/><br/><br/><br/><br/>











## 간단하게 고쳐서 실수를 미연에 방지하기!

첫번쨰로 `let result`로 변수를 선언합니다. <br/>

그 다음 `defer`를 활용하여 CompletionHandler를 호출합니다.


<img src="https://github.com/MaraMincho/MakingFrogWithoutDissecting/assets/103064352/c0e74a96-d136-4aa8-9d6d-c5150d3d3fef" width = "500">






그리고 `defer` 내부의 코드는 함수의 끝에서 실행되기 때문에, 우리는 우리의 `result`를 사용할 수 있습니다. 왜냐하면 그때까지 선언한 `result` 변수는 값을 가질 것이기 때문입니다. (종료 직전에 무조건 `result`에 값이 할당되고, 그것을 넘길 것이기 때문)







<img src="https://github.com/MaraMincho/MakingFrogWithoutDissecting/assets/103064352/2b3c4139-00dd-4f34-9c48-4a86f91d0ddc" width= "500">

<br/><br/><br/>


실제로 컴파일러는 가능한 모든 코드 경로를 생성하도록 값을 할당합니다!

우리가 `result`에 값을 할당 하는 것을 잊으면 컴파일러는 오류를 발생시키고, 코드는 빌드 될수 없습니다.

<img src="https://github.com/MaraMincho/MakingFrogWithoutDissecting/assets/103064352/28c8a991-bd06-4d12-aed1-460c78a49b04" width = "500">

<br/>
<br/><br/><br/><br/><br/>











