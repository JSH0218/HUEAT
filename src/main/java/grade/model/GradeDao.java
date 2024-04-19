package grade.model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import mysql.db.DbConnect;

public class GradeDao {
	
	DbConnect db = new DbConnect();
	
	//평점 등록
	public void insertGrade(GradeDto dto) {
		
		Connection conn = db.getConnection();
		PreparedStatement pstmt = null;
		
		String sql = "insert into grade values (null,?,?,?,?,now())";
		
		try {
			pstmt = conn.prepareStatement(sql);
			
			pstmt.setString(1, dto.getH_num());
			pstmt.setString(2, dto.getG_myid());
			pstmt.setString(3, dto.getG_content());
			pstmt.setString(4, dto.getG_grade());
			
			pstmt.execute();
			
		} catch (SQLException e) {
		
			e.printStackTrace();
		}finally {
			db.dbClose(pstmt, conn);
		}
		
	}
	
	//평점 전체 목록
	public List<GradeDto> getGradeList(String g_hunum){
		List<GradeDto> list = new ArrayList<GradeDto>();
		
		Connection conn = db.getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		String sql = "select * from grade where h_num =? order by g_num desc";
		
		try {
			pstmt=conn.prepareStatement(sql);
			pstmt.setString(1, g_hunum);
			rs=pstmt.executeQuery();
			
			while(rs.next()) {
				GradeDto dto = new GradeDto();
				
				dto.setG_num(rs.getString("g_num"));
				dto.setH_num(rs.getString("h_num"));
				dto.setG_myid(rs.getString("g_myid"));
				dto.setG_content(rs.getString("g_content"));
				dto.setG_grade(rs.getString("g_grade"));
				dto.setG_writeday(rs.getTimestamp("g_writeday"));
				
				list.add(dto);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}finally {
			db.dbClose(rs, pstmt, conn);
		}
		
		return list;
	}
	
	// 각 휴게소의 평점에 대한 평균
	public String avgGrade(String h_num) {
		String avgGrade = null;
	    Connection conn = db.getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		String sql = "select avg(g_grade) as avgGrade from grade where h_num = ?";
		 
		try {
	        pstmt = conn.prepareStatement(sql);
	        pstmt.setString(1, h_num);
	        rs = pstmt.executeQuery();

	        if (rs.next()) {
	            double averageGrade = rs.getDouble("avgGrade");
	            avgGrade = String.format("%.1f", averageGrade); // 평균 등급을 소수점 첫 번째 자리까지 형식화
	        }
	    } catch (SQLException e) {
	        e.printStackTrace();
	    } finally {
	        db.dbClose(rs, pstmt, conn);
	    }

	    return avgGrade;
	}
	
	//특정 휴게소 번호에 대해 평점을 등록한 회원의 아이디 목록 출력
	public List<String> getG_myid(String h_num) {
		List<String> G_myids = new ArrayList<>();
	    Connection conn = db.getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		String sql = "select g_myid from grade where h_num = ?";
		
	    try {
	        pstmt = conn.prepareStatement(sql);
	        pstmt.setString(1, h_num);
	        rs = pstmt.executeQuery();

	        while (rs.next()) {
	            String g_myid = rs.getString("g_myid");
	            G_myids.add(g_myid);
	        }
	    } catch (SQLException e) {
	        e.printStackTrace();
	    } finally {
	        db.dbClose(rs, pstmt, conn);
	    }

	    return  G_myids;
	}

}
