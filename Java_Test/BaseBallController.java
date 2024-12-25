package Java_Test;

import java.util.ArrayList;

public class BaseBallController {
    private ArrayList<BaseBall> currentBaseBalls;

    public BaseBallController() {
        currentBaseBalls = new ArrayList<>();
        ArrayList<Integer> myNums = new ArrayList<>();
        while (currentBaseBalls.size() < 3) {
            Integer currentValue = (int)(Math.random() * 10);
            if (myNums.contains(currentValue) == false) {
                myNums.add(currentValue);
                currentBaseBalls.add(new BaseBall(currentValue));
            }
        }
        for (var ball: currentBaseBalls) {
            System.err.println(ball.getNumber());
        }
    }

    public BaseBallResultStatus resume(int[] nums) {
        int strike = 0, ball = 0, out = 0;
        
        // currentBaseBalls를 int[]로 사용
        int[] currentBaseBalls = this.currentBaseBalls.stream().mapToInt(BaseBall::getNumber).toArray();
        
        for (int ind = 0; ind < nums.length; ind++) {
            int num = nums[ind];
            boolean found = false;
            
            for (int i = 0; i < currentBaseBalls.length; i++) {
                if (currentBaseBalls[i] == num) {
                    found = true;
                    if (i == ind) {
                        strike++;
                    } else {
                        ball++;
                    }
                    break; // 첫 번째 일치를 찾은 후 루프 종료
                }
            }
            
            if (!found) {
                out++;
            }
        }
        return new BaseBallResultStatus(strike, ball, out);
    }

    public ArrayList<Integer> result() {
        ArrayList<Integer> answer = new ArrayList<>();
        for (var ball : this.currentBaseBalls) {
            var currentNum = ball.getNumber();
            answer.add(currentNum);
        }
        return answer;
    }
}