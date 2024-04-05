package meminfo.model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import mysql.db.DbConnect;

public class MemInfoDao {
	DbConnect db=new DbConnect();
	
	
	//회원가입 
	public void insertMember(MemInfoDto dto) {
		Connection conn=db.getConnection();
		PreparedStatement pstmt=null;
		
		String sql="insert into meminfo values(null,?,?,?,?,?,?,?,?,now())";
		
		try {
			pstmt=conn.prepareStatement(sql);
			pstmt.setString(1, dto.getM_name());
			pstmt.setString(2, dto.getM_nick());
			pstmt.setString(3, dto.getM_id());
			pstmt.setString(4, dto.getM_pass());
			pstmt.setString(5, dto.getM_hp1());
			pstmt.setString(6, dto.getM_hp2());
			pstmt.setString(7, dto.getM_birth());
			pstmt.setString(8, dto.getM_email());
			pstmt.execute();
			
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally {
			db.dbClose(pstmt, conn);
		}
	}
	
	//아이디 중복 확인
	public int idcount(String m_id) {
		int isid=0;
		Connection conn=db.getConnection();
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		
		String sql="select count(*) from meminfo where m_id=?";
		
		try {
			pstmt=conn.prepareStatement(sql);
			pstmt.setString(1,m_id);
			rs=pstmt.executeQuery();
			if(rs.next()) {
				isid=rs.getInt(1);
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally {
			db.dbClose(rs, pstmt, conn);
		}
		
		return isid;
	}
	
	//닉네임 중복방지
	public int nickcount(String m_nick) {
		int isnick=0;
		Connection conn=db.getConnection();
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		
		String sql="select count(*) from meminfo where m_nick=?";
		
		try {
			pstmt=conn.prepareStatement(sql);
			pstmt.setString(1, m_nick);
			rs=pstmt.executeQuery();
			if(rs.next()) {
				isnick=rs.getInt(1);
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally {
			db.dbClose(rs, pstmt, conn);
		}
		return isnick;
	}
	
	//로그인시 사용할 메서드(id와 pass가 일치 하는 가)
	public boolean isIdPassMember(String m_id, String m_pass) {
		boolean idpass=false;
		
		Connection conn=db.getConnection();
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		
		String sql="select * from meminfo where m_id=? and m_pass=?";
		
		try {
			pstmt=conn.prepareStatement(sql);
			pstmt.setString(1, m_id);
			pstmt.setString(2, m_pass);
			rs=pstmt.executeQuery();
			if(rs.next()) {
				idpass=true;
			}
			
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally {
			db.dbClose(rs, pstmt, conn);
		}
		
		return idpass;
	}
	
	//이름과 핸드폰 번호로 아이디 찾기
	public String idsearch(String m_name, String m_hp2) {
		String b="";
		Connection conn=db.getConnection();
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		
		String sql="select m_id from meminfo where m_name=? and m_hp2=?";
		
		try {
			pstmt=conn.prepareStatement(sql);
			pstmt.setString(1, m_name);
			pstmt.setString(2, m_hp2);
			rs=pstmt.executeQuery();
			
			if(rs.next()) {
				b=rs.getString("m_id");
			}
			
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally {
			db.dbClose(rs, pstmt, conn);
		}
		
		return b;
	}
	
	//이름과 이메일로 아이디 찾기
	public String idsearch2(String m_name, String m_email) {
		String e="";
		
		Connection conn=db.getConnection();
		PreparedStatement pstmt=null;
		
		return e;
	}
}
