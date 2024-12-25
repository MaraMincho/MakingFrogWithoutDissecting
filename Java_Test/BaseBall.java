package Java_Test;

public class BaseBall {
    private int number;

    public BaseBall(int number) {
        this.number = number;
    }

    public boolean isEqual(int number) {
        return this.number == number;
    }
    public Integer getNumber() {
        return this.number;
    }
}