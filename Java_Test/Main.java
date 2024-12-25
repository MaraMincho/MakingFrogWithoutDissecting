package Java_Test;

import java.util.Arrays;

public class Main{
	public static void main(String[] args) {
		BaseBall currentBaseBall = new BaseBall(3);
		System.out.println(currentBaseBall.isEqual(3));
		var controller = new BaseBallController();
		BaseBallResultStatus status = new BaseBallResultStatus(-1, -1, -1);
		while (status.strike() != 3) {
			String currentInput = System.console().readLine();
			String[] numStrings = currentInput.split(" ");
			int[] nums = Arrays.stream(numStrings)
							.mapToInt(Integer::parseInt)
							.toArray();
			status = controller.resume(nums);
			System.out.println(status);
		}
		System.out.println(controller.result());
	}
}

