package review.model;

import java.sql.Timestamp;

import javax.management.loading.PrivateClassLoader;

public class ReviewDto {
	
	private String r_num;
	private String r_myid;
	private String r_category;
	private String r_content;
	private String r_image;
	private int r_chu;
	private Timestamp r_writeday;
	
	public String getR_num() {
		return r_num;
	}
	public void setR_num(String r_num) {
		this.r_num = r_num;
	}
	public String getR_myid() {
		return r_myid;
	}
	public void setR_myid(String r_myid) {
		this.r_myid = r_myid;
	}
	public String getR_category() {
		return r_category;
	}
	public void setR_category(String r_category) {
		this.r_category = r_category;
	}
	public String getR_content() {
		return r_content;
	}
	public void setR_content(String r_content) {
		this.r_content = r_content;
	}
	public String getR_image() {
		return r_image;
	}
	public void setR_image(String r_image) {
		this.r_image = r_image;
	}
	public int getR_chu() {
		return r_chu;
	}
	public void setR_chu(int r_chu) {
		this.r_chu = r_chu;
	}
	public Timestamp getR_writeday() {
		return r_writeday;
	}
	public void setR_writeday(Timestamp r_writeday) {
		this.r_writeday = r_writeday;
	}
	
	
	
}
