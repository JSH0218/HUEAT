package foodcart;

import java.sql.Timestamp;

public class FoodCartDto {
	private String cart_idx;
	private String h_num;
	private String f_num;
	private String m_num;
	private int cart_cnt;
	private Timestamp cartday;
	
	public String getH_num() {
		return h_num;
	}
	public void setH_num(String h_num) {
		this.h_num = h_num;
	}
	
	public String getCart_idx() {
		return cart_idx;
	}
	public void setCart_idx(String cart_idx) {
		this.cart_idx = cart_idx;
	}
	public String getF_num() {
		return f_num;
	}
	public void setF_num(String f_num) {
		this.f_num = f_num;
	}
	public String getM_num() {
		return m_num;
	}
	public void setM_num(String m_num) {
		this.m_num = m_num;
	}
	public int getCart_cnt() {
		return cart_cnt;
	}
	public void setCart_cnt(int cart_cnt) {
		this.cart_cnt = cart_cnt;
	}
	public Timestamp getCartday() {
		return cartday;
	}
	public void setCartday(Timestamp cartday) {
		this.cartday = cartday;
	}
	
	
}
