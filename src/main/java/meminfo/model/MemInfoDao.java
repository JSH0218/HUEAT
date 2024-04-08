package meminfo.model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import mysql.db.DbConnect;

public class MemInfoDao {
	DbConnect db=new DbConnect();
	
	//즐겨찾기 시 세션에 로그인 된 아이디를 이용해 MemInfo의 m_num을 얻는 메서드 (hugesodetail.jsp)
			public String getM_num(String m_id)
			{
				String m_num="";
				
				Connection conn=db.getConnection();
				PreparedStatement pstmt=null;
				ResultSet rs=null;
				
				String sql="select num from meminfo where m_id=?";
				
				try {
					pstmt=conn.prepareStatement(sql);
					pstmt.setString(1, m_id);
					rs=pstmt.executeQuery();
					
					if(rs.next())
						m_num=rs.getString("m_num");
				} catch (SQLException e) {
					e.printStackTrace();
				}finally {
					db.dbClose(rs, pstmt, conn);
				}
				
				
				return m_num;
			}
}