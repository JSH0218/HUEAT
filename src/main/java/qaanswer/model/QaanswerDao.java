package qaanswer.model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import mysql.db.DbConnect;

public class QaanswerDao {
	
	DbConnect db = new DbConnect();
	
	//insert
	public void insertQaAnswer(QaanswerDto dto) {
		Connection conn = db.getConnection();
		PreparedStatement pstmt = null;

		//String sql = "insert into qaanswerboard (q_num,qa_content,qa_writeday) values(?,?,now())";
		String sql = "INSERT INTO qaanswerboard (q_num, qa_num, qa_myid, qa_content, qa_writeday) "
	            + "VALUES (?, (SELECT COALESCE(MAX(qa_num), 0) + 1 FROM "
	            + "(SELECT qa_num FROM qaanswerboard WHERE q_num = ?) AS subquery), ?, ?, sysdate())";

		try {
			pstmt = conn.prepareStatement(sql);

			pstmt.setString(1, dto.getQ_num());
			pstmt.setString(2, dto.getQ_num());
			pstmt.setString(3, dto.getQa_myid());
			pstmt.setString(4, dto.getQa_content());

			pstmt.execute();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			db.dbClose(pstmt, conn);
		}
	}
	
	// 댓글출력
	public List<QaanswerDto> getQaAnswerList(String q_num) {
		List<QaanswerDto> list = new ArrayList<QaanswerDto>();

		Connection conn = db.getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		String sql = "select * from qaanswerboard where q_num=? order by qa_num desc";

		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, q_num);
			rs = pstmt.executeQuery();

			while (rs.next()) {
				QaanswerDto dto = new QaanswerDto();

				dto.setQ_num(rs.getString("q_num")); // 게시판 번호
				dto.setQa_num(rs.getString("qa_num")); // 댓글 번호 
				dto.setQa_myid(rs.getString("qa_myid"));
				dto.setQa_content(rs.getString("qa_content")); // 댓글내용 
				dto.setQa_writeday(rs.getTimestamp("qa_writeday"));;
				
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
	
	

	// 수정시 나타낼 데이타
	public QaanswerDto getAnswerData(String q_num, String qa_num) {
		QaanswerDto dto = new QaanswerDto();

		Connection conn = db.getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		String sql = "select * from qaanswerboard where q_num=? and qa_num=?";

		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, q_num);
			pstmt.setString(2, qa_num);
			rs = pstmt.executeQuery();

			while (rs.next()) {

				dto.setQ_num(rs.getString("q_num")); // 게시판 번호
				dto.setQa_num(rs.getString("qa_num")); // 댓글 번호 
				dto.setQa_myid(rs.getString("qa_myid"));
				dto.setQa_content(rs.getString("qa_content")); // 댓글내용 
				dto.setQa_writeday(rs.getTimestamp("qa_writeday"));

			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			db.dbClose(rs, pstmt, conn);
		}

		return dto;
	}

	// 수정
	public void updateQaAnswer(QaanswerDto dto) {
		Connection conn = db.getConnection();
		PreparedStatement pstmt = null;

		String sql = "update qaanswerboard set qa_content=? where q_num=? and qa_num=?";

		try {
			pstmt = conn.prepareStatement(sql);

			
			pstmt.setString(1, dto.getQa_content());
			pstmt.setString(2, dto.getQ_num());
			pstmt.setString(3, dto.getQa_num());
			

			pstmt.execute();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			db.dbClose(pstmt, conn);
		}
	}

	// 삭제
	public void deleteQaAnswer(QaanswerDto dto) {
		Connection conn = db.getConnection();
		PreparedStatement pstmt = null;

		String sql = "delete from qaanswerboard where q_num=? and qa_num=?";

		try {
			pstmt = conn.prepareStatement(sql);

			pstmt.setString(1, dto.getQ_num());
			pstmt.setString(2, dto.getQa_num());

			pstmt.execute();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			db.dbClose(pstmt, conn);
		}
	}
	
	

}
