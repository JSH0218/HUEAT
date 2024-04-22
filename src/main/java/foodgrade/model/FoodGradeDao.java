package foodgrade.model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import grade.model.GradeDto;
import mysql.db.DbConnect;

public class FoodGradeDao {
	
DbConnect db = new DbConnect();
	
	//해당 휴게소에 있는 음식에 대한 평점 등록
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
	
	//음식에 대한 평균 평점 출력
	public String avgFoodGrade(String fg_foodnum) {
		String avgFoodGrade = null;
	    Connection conn = db.getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		String sql = "select avg(fg_grade) as avgFoodGrade from foodgrade where fg_foodnum = ?";
		 
		try {
	        pstmt = conn.prepareStatement(sql);
	        pstmt.setString(1, fg_foodnum);
	        rs = pstmt.executeQuery();

	        if (rs.next()) {
	            double averageFoodGrade = rs.getDouble("avgFoodGrade");
	            avgFoodGrade = String.format("%.1f", averageFoodGrade); // 평균 등급을 소수점 첫 번째 자리까지 형식화
	        }
	    } catch (SQLException e) {
	        e.printStackTrace();
	    } finally {
	        db.dbClose(rs, pstmt, conn);
	    }

	    return avgFoodGrade;
	}
			
	
}
