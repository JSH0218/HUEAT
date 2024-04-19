package foodgrade.model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import mysql.db.DbConnect;

public class FoodGradeDao {
	
DbConnect db = new DbConnect();
	
	//해당 휴게소 음식에 대한 평점 등록
	public void insertFoodGrade(FoodGradeDto dto) {
		
		Connection conn = db.getConnection();
		PreparedStatement pstmt = null;
		
		String sql = "insert into foodgrade values (null,?,?,?,?)";
		
		try {
			pstmt = conn.prepareStatement(sql);
			
			pstmt.setString(1, dto.getFg_foodnum());
			pstmt.setString(2, dto.getFg_hugesonum());
			pstmt.setString(3, dto.getFg_myid());
			pstmt.setString(4, dto.getFg_grade());
			
			pstmt.execute();
			
		} catch (SQLException e) {
		
			e.printStackTrace();
		}finally {
			db.dbClose(pstmt, conn);
		}
		
	}
}
