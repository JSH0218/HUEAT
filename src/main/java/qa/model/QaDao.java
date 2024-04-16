package qa.model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import mysql.db.DbConnect;
import notice.model.NoticeDto;
import review.model.ReviewDto;

public class QaDao {
	
	DbConnect db = new DbConnect();
	
	
	//insert
	public void insertQa(QaDto dto) {
		
		Connection conn = db.getConnection();
		PreparedStatement pstmt = null;
		
		String sql = "insert into qaboard values(null,?,?,?,?,0,now())";
		
		try {
			pstmt = conn.prepareStatement(sql);
			
			pstmt.setString(1, dto.getQ_myid());
			pstmt.setString(2, dto.getQ_category());
			pstmt.setString(3, dto.getQ_subject());
			pstmt.setString(4, dto.getQ_content());
			
			pstmt.execute();
			
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally {
			db.dbClose(pstmt, conn);
		}
				
	}
	
	//전체 리스트 출력
	public List<QaDto> getAllQa() {
		List<QaDto> list = new ArrayList<QaDto>();

		Connection conn = db.getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		String sql = "select * from qaboard order by q_num desc";

		try {
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();

			while (rs.next()) {

				QaDto dto = new QaDto();

				dto.setQ_num(rs.getString("q_num"));
				dto.setQ_myid(rs.getString("q_myid"));
				dto.setQ_category(rs.getString("q_category"));
				dto.setQ_subject(rs.getString("q_subject"));
				dto.setQ_content(rs.getString("q_content"));
				dto.setQ_readcount(rs.getInt("q_readcount"));
				dto.setQ_writeday(rs.getTimestamp("q_writeday"));

				list.add(dto);
			}

		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			db.dbClose(rs, pstmt, conn);
		}

		return list;

	}
	
	//전체 페이지수 dto 반환하기
	public int getTotalCount() {
		
		int total = 0;
		
		Connection conn = db.getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		String sql = "select count(*) from qaboard";
		
		try {
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				total = rs.getInt(1);
			}
			
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally {
			db.dbClose(rs, pstmt, conn);
		}
		
		return total;
		
	}
	
	// paging list (한 페이지에서 첫번쨰랑 마지막번호 출력 하고 그 이상은 다음 페이지로 넘김)
	public List<QaDto> getList(int start, int perPage) {
		List<QaDto> list = new ArrayList<QaDto>();

		Connection conn = db.getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;

//		String sql = "select * from qaboard order by q_num desc limit ?,?";
		
		String sql = "select a.q_num, a.q_myid,a.q_category,a.q_subject,a.q_content,a.q_readcount,a.q_writeday"
				+ "       ,(select count(1) from qaanswerboard as b where b.q_num = a.q_num) AS qa_cnt"
				+ " from qaboard as a order by q_num desc limit ?,?";

			
		

		try {
			pstmt = conn.prepareStatement(sql);

			pstmt.setInt(1, start);
			pstmt.setInt(2, perPage);

			rs = pstmt.executeQuery();

			while (rs.next()) {

				QaDto dto = new QaDto();

				dto.setQ_num(rs.getString("q_num"));
				dto.setQ_myid(rs.getString("q_myid"));
				dto.setQ_category(rs.getString("q_category"));
				dto.setQ_subject(rs.getString("q_subject"));
				dto.setQ_content(rs.getString("q_content"));
				dto.setQ_readcount(rs.getInt("q_readcount"));
				dto.setQ_writeday(rs.getTimestamp("q_writeday"));
				//dto.setQa_cnt(rs.getInt("qa_cnt"));

				list.add(dto);
			}

		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			db.dbClose(rs, pstmt, conn);
		}

		return list;
	}
	
	// detail페이지 num값 넘겨주기 -> dto 반환!!
	public QaDto getDataQa(String q_num) {
		QaDto dto = new QaDto();

		Connection conn = db.getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		String sql = "select * from qaboard where q_num=?";

		try {
			pstmt = conn.prepareStatement(sql);

			pstmt.setString(1, q_num);
			rs = pstmt.executeQuery();

			while (rs.next()) {

				dto.setQ_num(rs.getString("q_num"));
				dto.setQ_myid(rs.getString("q_myid"));
				dto.setQ_category(rs.getString("q_category"));
				dto.setQ_subject(rs.getString("q_subject"));
				dto.setQ_content(rs.getString("q_content"));
				dto.setQ_readcount(rs.getInt("q_readcount"));
				dto.setQ_writeday(rs.getTimestamp("q_writeday"));

			}

		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			db.dbClose(rs, pstmt, conn);
		}

		return dto;
	}
	
	
	
	// readcount 해주기 / 조회수 및 추천
	public void updateReadcount(String q_num) {
		Connection conn = db.getConnection();
		PreparedStatement pstmt = null;

		String sql = "update qaboard set q_readcount=q_readcount+1 where q_num=?";

		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, q_num);
			pstmt.execute();

		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			db.dbClose(pstmt, conn);
		}
	}
	

	// update 수정
	public void updateQa(QaDto dto) {

		Connection conn = db.getConnection();
		PreparedStatement pstmt = null;

		String sql = "update qaboard set q_category=?, q_subject=?, q_content=? where q_num=?";

		try {
			pstmt = conn.prepareStatement(sql);

			pstmt.setString(1, dto.getQ_category());
			pstmt.setString(2, dto.getQ_subject());
			pstmt.setString(3, dto.getQ_content());
			pstmt.setString(4, dto.getQ_num());

			pstmt.execute();
			

		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			db.dbClose(pstmt, conn);
		}

	}

	// 삭제하기
	public void deleteQa(String q_num) {

		Connection conn = db.getConnection();
		PreparedStatement pstmt = null;

		String sql = "delete from qaboard where q_num=?";

		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, q_num);

			pstmt.execute();

		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			db.dbClose(pstmt, conn);
		}

	}

}
