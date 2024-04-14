package grade.model;

import java.sql.Timestamp;

public class GradeDto {
	private String g_num;
	private String h_num;
	private String m_num;
	private String g_content;
	private String g_grade;
	private Timestamp g_writeday;
	
	public String getG_num() {
		return g_num;
	}
	public void setG_num(String g_num) {
		this.g_num = g_num;
	}
	public String getH_num() {
		return h_num;
	}
	public void setH_num(String h_num) {
		this.h_num = h_num;
	}
	public String getM_num() {
		return m_num;
	}
	public void setM_num(String m_num) {
		this.m_num = m_num;
	}
	public String getG_content() {
		return g_content;
	}
	public void setG_content(String g_content) {
		this.g_content = g_content;
	}
	public String getG_grade() {
		return g_grade;
	}
	public void setG_grade(String g_grade) {
		this.g_grade = g_grade;
	}
	public Timestamp getG_writeday() {
		return g_writeday;
	}
	public void setG_writeday(Timestamp g_writeday) {
		this.g_writeday = g_writeday;
	}
	
	
	
	
}
