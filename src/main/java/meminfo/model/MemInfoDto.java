package meminfo.model;

import java.sql.Timestamp;

public class MemInfoDto {
	
	private String m_num;
	private String m_name;
	private String m_id;
	private String m_pass;
	private String m_nick;
	private String m_email;
	private String m_hp1;
	private String m_hp2;
	private String m_birth;
	private Timestamp m_gaipday;
	
	public String getM_num() {
		return m_num;
	}
	public void setM_num(String m_num) {
		this.m_num = m_num;
	}
	public String getM_name() {
		return m_name;
	}
	public void setM_name(String m_name) {
		this.m_name = m_name;
	}
	public String getM_id() {
		return m_id;
	}
	public void setM_id(String m_id) {
		this.m_id = m_id;
	}
	public String getM_pass() {
		return m_pass;
	}
	public void setM_pass(String m_pass) {
		this.m_pass = m_pass;
	}
	public String getM_nick() {
		return m_nick;
	}
	public void setM_nick(String m_nick) {
		this.m_nick = m_nick;
	}
	public String getM_email() {
		return m_email;
	}
	public void setM_email(String m_email) {
		this.m_email = m_email;
	}
	public String getM_hp1() {
		return m_hp1;
	}
	public void setM_hp1(String m_hp1) {
		this.m_hp1 = m_hp1;
	}
	public String getM_hp2() {
		return m_hp2;
	}
	public void setM_hp2(String m_hp2) {
		this.m_hp2 = m_hp2;
	}
	public String getM_birth() {
		return m_birth;
	}
	public void setM_birth(String m_birth) {
		this.m_birth = m_birth;
	}
	public Timestamp getM_gaipday() {
		return m_gaipday;
	}
	public void setM_gaipday(Timestamp m_gaipday) {
		this.m_gaipday = m_gaipday;
	}
	
}