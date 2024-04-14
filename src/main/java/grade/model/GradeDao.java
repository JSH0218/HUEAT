package grade.model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import favorite.model.FavoriteDto;
import hugesoinfo.model.HugesoInfoDto;
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
			pstmt.setString(2, dto.getM_num());
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
	public List<GradeDto> getGradeList(String h_num){
		List<GradeDto> list = new ArrayList<GradeDto>();
		
		Connection conn = db.getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		String sql = "select * from grade where h_num=? order by g_num desc";
		
		try {
			pstmt=conn.prepareStatement(sql);
			pstmt.setString(1, h_num);
			rs=pstmt.executeQuery();
			
			while(rs.next()) {
				GradeDto dto = new GradeDto();
				
				dto.setG_num(rs.getString("g_num"));
				dto.setM_num(rs.getString("h_num"));
				dto.setH_num(rs.getString("m_num"));
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
	
	// grade의 m_num을 통해 meminfo의 m_id 가져오기
	public String getM_id(String m_num) {
	    String m_id = null;
	    Connection conn = db.getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		String sql = "select m.m_id from grade g join meminfo m on g.m_num = m.m_num where g.m_num = ?";
		
	    try {
	        pstmt = conn.prepareStatement(sql);
	        pstmt.setString(1, m_num);
	        rs = pstmt.executeQuery();

	        if (rs.next()) {
	          m_id = rs.getString("m_id");
	        }
	    } catch (SQLException e) {
	        e.printStackTrace();
	    } finally {
	        db.dbClose(rs, pstmt, conn);
	    }

	    return m_id;
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
	

}
