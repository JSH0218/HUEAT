package notice.model;

import java.sql.Timestamp;

public class noticeDto {

	
	private String n_num;
    private String n_subject;
    private String n_content;
    private String n_image;
    private int n_readcount;
    private int n_chu;
    private Timestamp n_writeday;
    
	public String getN_num() {
		return n_num;
	}
	public void setN_num(String n_num) {
		this.n_num = n_num;
	}
	public String getN_subject() {
		return n_subject;
	}
	public void setN_subject(String n_subject) {
		this.n_subject = n_subject;
	}
	public String getN_content() {
		return n_content;
	}
	public void setN_content(String n_content) {
		this.n_content = n_content;
	}
	public String getN_image() {
		return n_image;
	}
	public void setN_image(String n_image) {
		this.n_image = n_image;
	}
	public int getN_readcount() {
		return n_readcount;
	}
	public void setN_readcount(int n_readcount) {
		this.n_readcount = n_readcount;
	}
	public int getN_chu() {
		return n_chu;
	}
	public void setN_chu(int n_chu) {
		this.n_chu = n_chu;
	}
	public Timestamp getN_writeday() {
		return n_writeday;
	}
	public void setN_writeday(Timestamp n_writeday) {
		this.n_writeday = n_writeday;
	}
    
    
	
}
