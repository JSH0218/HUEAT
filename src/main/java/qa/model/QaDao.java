package qa.model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import mysql.db.DbConnect;
import review.model.ReviewDto;

public class QaDao {
	
	DbConnect db = new DbConnect();
	
	public void insertQa(QaDto dto) {
		
		Connection conn = db.getConnection();
		PreparedStatement pstmt = null;
		
		String sql = "insert into qaboard values(null,?,?,?,0,now())";
		
		try {
			pstmt = conn.prepareStatement(sql);
			
			
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
				
	}
	
	// myqalist.jsp //페이징리스트/ 전체페이지수 반환하기
	public int getMyPageTotalCount(String myid) {
		
		int total = 0;
		
		Connection conn = db.getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		String sql = "select count(*) from qaboard where q_myid=?";
		
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, myid);
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
	
	// myqalist.jsp //페이징리스트/paging list (한 페이지에서 첫번쨰랑 마지막번호 출력 하고 그 이상은 다음 페이지로 넘김)
	public List<QaDto> getmypagelist(int start, int perPage, String myid) {
		List<QaDto> mypagelist = new ArrayList<QaDto>();

		Connection conn = db.getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		String sql = "select * from qaboard where q_myid=? order by q_num desc limit ?,?";

		try {
			pstmt = conn.prepareStatement(sql);
			
			pstmt.setString(1, myid);
			pstmt.setInt(2, start);
			pstmt.setInt(3, perPage);

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
	
			// 삭제하기
			public void deleteQna(String q_num) {

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
