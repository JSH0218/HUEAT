package foodcart;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import mysql.db.DbConnect;

public class FoodCartDao {
	DbConnect db=new DbConnect();
	
	//음식 카트에 추가
	public void insertFoodCart(FoodCartDto dto) {
		Connection conn=db.getConnection();
		PreparedStatement pstmt=null;
		
		String sql="insert into foodcart values(null,?,?,?,?,now())";
		try {
			pstmt=conn.prepareStatement(sql);
			pstmt.setString(1, dto.getH_num());
			pstmt.setString(2, dto.getF_num());
			pstmt.setString(3, dto.getM_num());
			pstmt.setInt(4, dto.getCart_cnt());
			pstmt.execute();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally {
			db.dbClose(pstmt, conn);
		}
	}
	
	//유지))장바구니에 중복된 메뉴가 들어있는지 확인
	public boolean getCartCnt(String f_num, String m_num) {
		boolean c=false;
		Connection conn=db.getConnection();
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		
		String sql="select * from foodcart where f_num=? and m_num=?";
		try {
			pstmt=conn.prepareStatement(sql);
			pstmt.setString(1, f_num);
			pstmt.setString(2, m_num);
			rs=pstmt.executeQuery();
			if(rs.next()) {
				c=true;
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally {
			db.dbClose(rs, pstmt, conn);
		}
		
		return c;
	}
	
	//유지))장바구니에 중복된 수량이 들어있다면 수량 +1할 메서드
	public void updateCnt(FoodCartDto dto) {
		Connection conn=db.getConnection();
		PreparedStatement pstmt=null;
		
		String sql="update foodcart set cart_cnt=cart_cnt+1 where f_num=? and m_num=?";
		
		try {
			pstmt=conn.prepareStatement(sql);
			pstmt.setString(1, dto.getF_num());
			pstmt.setString(2, dto.getM_num());
			pstmt.execute();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally {
			db.dbClose(pstmt, conn);
		}
	}
	
	//유지))아이디로 주문목록 출력
	public List<HashMap<String, String>> getCartMenu(String m_num,String h_num){
		List<HashMap<String, String>> list=new ArrayList<HashMap<String,String>>();
		Connection conn=db.getConnection();
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		String sql="select f.f_name, c.cart_cnt, f.f_price,c.cartday,c.cart_idx,c.f_num from food f,foodcart c where f.f_num=c.f_num and f.h_num=c.h_num and c.m_num=? and f.h_num=?";
		try {
			pstmt=conn.prepareStatement(sql);
			pstmt.setString(1, m_num);
			pstmt.setString(2,h_num);
			rs=pstmt.executeQuery();
			while(rs.next()) {
				HashMap<String, String> map=new HashMap<String, String>();
				map.put("cart_idx", rs.getString("cart_idx"));
				map.put("cartday", rs.getString("cartday"));
				map.put("f_name", rs.getString("f_name"));
				map.put("cart_cnt", rs.getString("cart_cnt"));
				map.put("f_price",rs.getString("f_price"));
				map.put("f_num", rs.getString("f_num"));
				list.add(map);
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally {
			db.dbClose(rs, pstmt, conn);
		}
		return list;
	}
	
	//유지))카트 개별 삭제
	public void deleteCart(String cart_idx) {
		Connection conn=db.getConnection();
		PreparedStatement pstmt=null;
		String sql="delete from foodcart where cart_idx=?";
		try {
			pstmt=conn.prepareStatement(sql);
			pstmt.setString(1, cart_idx);
			pstmt.execute();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally {
			db.dbClose(pstmt, conn);
		}
	}
	
	//유지))부분취소를 위한 idx를 구하기
	public FoodCartDto getIdx(String f_num, String m_num) {
		FoodCartDto dto=new FoodCartDto();
		Connection conn=db.getConnection();
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		String sql="select cart_idx from foodcart where f_num=? and m_num=?";
		try {
			pstmt=conn.prepareStatement(sql);
			pstmt.setString(1, f_num);
			pstmt.setString(2, m_num);
			rs=pstmt.executeQuery();
			if(rs.next()) {
				dto.setCart_idx(rs.getString("cart_idx"));
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally {
			db.dbClose(rs, pstmt, conn);
		}
		
		return dto;
	}
	
	//유지))결제완료 후에는 모든 cart를 비워야한다. m_num을 기준으로 비워보자, 카트 전체삭제
	public void deleteAllCart(String m_num) {
		Connection conn=db.getConnection();
		PreparedStatement pstmt=null;
		String sql="delete from foodcart where m_num=?";
		try {
			pstmt=conn.prepareStatement(sql);
			pstmt.setString(1, m_num);
			pstmt.execute();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally {
			db.dbClose(pstmt, conn);
		}
	}
	
}
