package event.model;

import java.sql.Timestamp;

public class EventDto {

	
	private String e_num;
    private String e_subject;
    private String e_content;
    private String e_image;
    private int e_readcount;
    private int e_chu;
    private Timestamp e_writeday;
    
    
	public String getE_num() {
		return e_num;
	}
	public void setE_num(String e_num) {
		this.e_num = e_num;
	}
	public String getE_subject() {
		return e_subject;
	}
	public void setE_subject(String e_subject) {
		this.e_subject = e_subject;
	}
	public String getE_content() {
		return e_content;
	}
	public void setE_content(String e_content) {
		this.e_content = e_content;
	}
	public String getE_image() {
		return e_image;
	}
	public void setE_image(String e_image) {
		this.e_image = e_image;
	}
	public int getE_readcount() {
		return e_readcount;
	}
	public void setE_readcount(int e_readcount) {
		this.e_readcount = e_readcount;
	}
	public int getE_chu() {
		return e_chu;
	}
	public void setE_chu(int e_chu) {
		this.e_chu = e_chu;
	}
	public Timestamp getE_writeday() {
		return e_writeday;
	}
	public void setE_writeday(Timestamp e_writeday) {
		this.e_writeday = e_writeday;
	}
    
}
