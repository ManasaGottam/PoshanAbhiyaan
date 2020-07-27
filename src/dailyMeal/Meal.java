package dailyMeal;

public class Meal {
	String breakfast;
	String lunch;
	String snack_option;
	String dinner;
	
	public Meal(String breakfast, String lunch, String snack_option, String dinner) {
		super();
		this.breakfast = breakfast;
		this.lunch = lunch;
		this.snack_option = snack_option;
		this.dinner = dinner;
	}
	public String getBreakfast() {
		return breakfast;
	}
	public void setBreakfast(String breakfast) {
		this.breakfast = breakfast;
	}
	public String getLunch() {
		return lunch;
	}
	public void setLunch(String lunch) {
		this.lunch = lunch;
	}
	public String getSnack_option() {
		return snack_option;
	}
	public void setSnack_option(String snack_option) {
		this.snack_option = snack_option;
	}
	public String getDinner() {
		return dinner;
	}
	public void setDinner(String dinner) {
		this.dinner = dinner;
	}
	
}