package qaanswer.model;

import java.sql.Timestamp;

public class QaanswerDto {
	
	private String q_num;
	private String qa_num;
	private String qa_myid;
	private String qa_content;
	private Timestamp qa_writeday;
	public String getQ_num() {
		return q_num;
	}
	public void setQ_num(String q_num) {
		this.q_num = q_num;
	}
	public String getQa_num() {
		return qa_num;
	}
	public void setQa_num(String qa_num) {
		this.qa_num = qa_num;
	}
	public String getQa_myid() {
		return qa_myid;
	}
	public void setQa_myid(String qa_myid) {
		this.qa_myid = qa_myid;
	}
	public String getQa_content() {
		return qa_content;
	}
	public void setQa_content(String qa_content) {
		this.qa_content = qa_content;
	}
	public Timestamp getQa_writeday() {
		return qa_writeday;
	}
	public void setQa_writeday(Timestamp qa_writeday) {
		this.qa_writeday = qa_writeday;
	}
	

	
}
