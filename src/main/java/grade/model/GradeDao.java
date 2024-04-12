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
		
		String sql = "insert into grade values (null,?,?,?,now())";
		
		try {
			pstmt = conn.prepareStatement(sql);
			
			pstmt.setString(1, dto.getH_num());
			pstmt.setString(2, dto.getM_num());
			pstmt.setString(3, dto.getG_grade());
			
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
}
