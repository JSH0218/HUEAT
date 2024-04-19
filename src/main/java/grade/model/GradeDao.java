package grade.model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

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
	
	//평점 전체 목록(최신순)
	public List<GradeDto> getGradeLatest(String g_hunum){
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
	
	//해당 휴게소 평점 내용 중에 가장 많이 선택된 내용 출력
	public GradeDto bestContent(String h_num) {
	    GradeDto dto = new GradeDto();
	    
	    Connection conn = db.getConnection();
	    PreparedStatement pstmt=null;
	    ResultSet rs = null;
	    
	    String sql ="select g_content from grade where h_num = ? group by g_content order by count(*) desc limit 1";
	    
	    try {
	        pstmt=conn.prepareStatement(sql);
	        pstmt.setString(1, h_num);
	        rs=pstmt.executeQuery();
	        
	        if(rs.next()) {
	            dto.setH_num(h_num);
	            dto.setG_content(rs.getString("g_content")); 
	        }
	    } catch (SQLException e) {
	        e.printStackTrace();
	    }finally {
	        db.dbClose(rs, pstmt, conn);
	    }    
	    return dto;
	}
	
	//평점 전체 목록(평점높은순)
	public List<GradeDto> getGradeHigh(String g_hunum){
		List<GradeDto> list = new ArrayList<GradeDto>();
		
		Connection conn = db.getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		String sql = "select * from grade where h_num =? order by g_grade desc";
		
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
	
	//평점 전체 목록(평점낮은순)
		public List<GradeDto> getGradeLow(String g_hunum){
			List<GradeDto> list = new ArrayList<GradeDto>();
			
			Connection conn = db.getConnection();
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			
			String sql = "select * from grade where h_num =? order by g_grade asc";
			
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
		

		// 각 휴게소에서 평점 매긴 사용자의 각각의 평점내용을 가져오기
		public String get_Content(String h_num) {
		    String get_Content = null;
		    Connection conn = db.getConnection();
		    PreparedStatement pstmt = null;
		    ResultSet rs = null;

		    String sql = "SELECT g_content, COUNT(g_content) AS g_content_count FROM grade WHERE h_num = ? GROUP BY g_content";

		    try {
		        pstmt = conn.prepareStatement(sql);
		        pstmt.setString(1, h_num);
		        rs = pstmt.executeQuery();

		        StringBuilder result = new StringBuilder(); // 결과를 저장할 StringBuilder 생성

		        while (rs.next()) {
		            // 각 등급별 등장 횟수를 가져와서 StringBuilder에 추가
		            result.append(rs.getString("g_content")).append(" : ").append(rs.getString("g_content_count")).append(", ");
		        }

		        // 마지막 쉼표 제거
		        if (result.length() > 0) {
		            result.delete(result.length() - 2, result.length());
		        }

		        // 최종 결과 문자열 저장
		        get_Content = result.toString();
		    } catch (SQLException e) {
		        e.printStackTrace();
		    } finally {
		        db.dbClose(rs, pstmt, conn);
		    }

		    return get_Content;
		}




}
