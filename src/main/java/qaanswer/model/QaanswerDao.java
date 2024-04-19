package qaanswer.model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import mysql.db.DbConnect;
import qa.model.QaDto;

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
	
	// 관리자페이지에 가져오는 관리자가 쓴 Q&A 메서드
		public QaanswerDto getAdminAnswerData() {
			QaanswerDto dto = new QaanswerDto();

			Connection conn = db.getConnection();
			PreparedStatement pstmt = null;
			ResultSet rs = null;

			String sql = "select * from qaanswerboard where qa_myid='admin'";

			try {
				pstmt = conn.prepareStatement(sql);
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
		
		// adminqnalist.jsp //페이징리스트/ 전체페이지수 반환하기
		public int getMyPageTotalCount() {
	      
	    int total = 0;
			
			Connection conn = db.getConnection();
			PreparedStatement pstmt = null;
			ResultSet rs = null;
	  
	    String sql = "select count(*) from qaanswerboard where qa_myid='admin'";
			
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
		
		// adminqalist.jsp //페이징리스트/paging list (한 페이지에서 첫번쨰랑 마지막번호 출력 하고 그 이상은 다음 페이지로 넘김)
		public List<QaanswerDto> getmypagelist(int start, int perPage) {
			List<QaanswerDto> mypagelist = new ArrayList<QaanswerDto>();
	  
			Connection conn = db.getConnection();
			PreparedStatement pstmt = null;
			ResultSet rs = null;
	  
			String sql = "select * from qaanswerboard where qa_myid='admin' order by qa_num desc limit ?,?";

			try {
				pstmt = conn.prepareStatement(sql);
				
				pstmt.setInt(1, start);
				pstmt.setInt(2, perPage);
	      
	      rs = pstmt.executeQuery();

				while (rs.next()) {

					QaanswerDto dto = new QaanswerDto();

					dto.setQ_num(rs.getString("q_num"));
					dto.setQa_num(rs.getString("qa_num"));
					dto.setQa_myid(rs.getString("qa_myid"));
					dto.setQa_content(rs.getString("qa_content"));
					dto.setQa_writeday(rs.getTimestamp("qa_writeday"));
	        
					mypagelist.add(dto);
	      }
	      } catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} finally {
				db.dbClose(rs, pstmt, conn);
			}
	    return mypagelist;
		}
		// adminpage에서 삭제하기
		public void deleteQna(String q_num,String qa_num) {

			Connection conn = db.getConnection();
			PreparedStatement pstmt = null;

			String sql = "delete from qaanswerboard where q_num=? and qa_num=?";

			try {
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, q_num);
				pstmt.setString(2, qa_num);

				pstmt.execute();

			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} finally {
				db.dbClose(pstmt, conn);
			}

		}
		//q_num을 통해 문의글 제목 가져오기
		public String getTitle(String q_num) {
			String title="";
			Connection conn = db.getConnection();
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			
			String sql="select q_subject from qaboard where q_num=?";
			
			try {
				pstmt=conn.prepareStatement(sql);
				pstmt.setString(1, q_num);
				rs=pstmt.executeQuery();
				
				if(rs.next()) {
					title=rs.getString("q_subject");
				}
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			return title;
		}
	

}
