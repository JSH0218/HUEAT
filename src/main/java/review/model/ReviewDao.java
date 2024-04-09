package review.model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import mysql.db.DbConnect;

public class ReviewDao {

	DbConnect db=new DbConnect();
	
	// r_content를 통해 특정 휴게소에 대한 r_chu의 합 반환(hugesodetail.jsp) ---> h_grade
	public String getHugeGrade(String h_name) {
		String sum_chu = "";
	    Connection conn = db.getConnection();
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;

	    String sql = "select sum(r.r_chu) as sum_chu from reviewboard r where r.r_content like ?";
	    
	    try {
	        pstmt = conn.prepareStatement(sql);
	        pstmt.setString(1, "%" + h_name + "%");
	        rs = pstmt.executeQuery();
	        
	        if (rs.next())
	        	sum_chu = rs.getString("r_chu");
	    } catch (SQLException e) {
	        e.printStackTrace();
	    } finally {
	        db.dbClose(rs, pstmt, conn);
	    }
	    
	    return sum_chu;
	}
	
	// r_content를 통해 특정 휴게소에 대한 추천 수의 개수 반환 (hugesodetail.jsp) ---> h_gradecount
	public int getHugeChuCount(String h_name) {
	    int count_chu = 0;
	    Connection conn = db.getConnection();
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;

	    String sql = "select count(r.r_chu) as count_chu from reviewboard r where r.r_content like ?";
	    
	    try {
	        pstmt = conn.prepareStatement(sql);
	        pstmt.setString(1, "%" + h_name + "%");
	        rs = pstmt.executeQuery();
	        
	        if (rs.next())
	            count_chu = rs.getInt("count_chu");
	    } catch (SQLException e) {
	        e.printStackTrace();
	    } finally {
	        db.dbClose(rs, pstmt, conn);
	    }
	    
	    return count_chu;
	}


}
