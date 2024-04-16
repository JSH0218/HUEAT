package qa.model;

import java.sql.Timestamp;

public class QaDto {
	
	private String q_num;
	private String q_myid;
	private String q_category;
	private String q_subject;
	private String q_content;
	private int q_readcount;
	private Timestamp q_writeday;
	private int qa_cnt;
	
	public int getQa_cnt() {
		return qa_cnt;
	}
	public void setQa_cnt(int qa_cnt) {
		this.qa_cnt = qa_cnt;
	}
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
	public String getQ_subject() {
		return q_subject;
	}
	public void setQ_subject(String q_subject) {
		this.q_subject = q_subject;
	}
	public String getQ_content() {
		return q_content;
	}
	public void setQ_content(String q_content) {
		this.q_content = q_content;
	}
	public int getQ_readcount() {
		return q_readcount;
	}
	public void setQ_readcount(int q_readcount) {
		this.q_readcount = q_readcount;
	}
	public Timestamp getQ_writeday() {
		return q_writeday;
	}
	public void setQ_writeday(Timestamp q_writeday) {
		this.q_writeday = q_writeday;
	}
	
	


}
