package qa.model;

import java.sql.Timestamp;

public class QaDto {
	
	private String q_num;
	private String q_myid;
	private String q_category;
	private String q_content;
	private int q_redacount;
	private int q_chu;
	private Timestamp q_writeday;
	
	
	public String getQ_num() {
		return q_num;
	}
	public void setQ_num(String q_num) {
		this.q_num = q_num;
	}
	public String getQ_myid() {
		return q_myid;
	}
	public void setQ_myid(String q_myid) {
		this.q_myid = q_myid;
	}
	public String getQ_category() {
		return q_category;
	}
	public void setQ_category(String q_category) {
		this.q_category = q_category;
	}
	public String getQ_content() {
		return q_content;
	}
	public void setQ_content(String q_content) {
		this.q_content = q_content;
	}
	public int getQ_redacount() {
		return q_redacount;
	}
	public void setQ_redacount(int q_redacount) {
		this.q_redacount = q_redacount;
	}
	public int getQ_chu() {
		return q_chu;
	}
	public void setQ_chu(int q_chu) {
		this.q_chu = q_chu;
	}
	public Timestamp getQ_writeday() {
		return q_writeday;
	}
	public void setQ_writeday(Timestamp q_writeday) {
		this.q_writeday = q_writeday;
	}
	
	
	
	
	

}
