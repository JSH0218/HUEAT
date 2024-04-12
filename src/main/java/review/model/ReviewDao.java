package review.model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import mysql.db.DbConnect;
import notice.model.NoticeDto;

public class ReviewDao {
	
	DbConnect db = new DbConnect();
	
	public void insertReview(ReviewDto dto) {
		
		Connection conn = db.getConnection();
		PreparedStatement pstmt = null;
		
		String sql = "insert into reviewboard values(null,?,?,?,0,now())";
	
		try {
			pstmt = conn.prepareStatement(sql);
			
            pstmt.setString(1, dto.getR_myid());
			pstmt.setString(2, dto.getR_content());
			pstmt.setString(3, dto.getR_image());
			
			pstmt.execute();
			
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally {
			db.dbClose(pstmt, conn);
		}
	}
	
	
	//noticelist 전체 출력
		public List<ReviewDto> getAllReview() {
			List<ReviewDto> list = new ArrayList<ReviewDto>();
			
			Connection conn = db.getConnection();
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			
			String sql = "select * from reviewboard order by r_num desc";
			
			try {
				pstmt = conn.prepareStatement(sql);
				rs = pstmt.executeQuery();
				
				while(rs.next()) {
					
					ReviewDto dto = new ReviewDto();
					
					dto.setR_num(rs.getString("r_num"));
					dto.setR_myid(rs.getString("r_myid"));
					dto.setR_content(rs.getString("r_content"));
					dto.setR_image(rs.getString("r_image"));
					dto.setR_chu(rs.getInt("r_chu"));
					dto.setR_writeday(rs.getTimestamp("r_writeday"));
					
					list.add(dto);
				}
				
				
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}finally {
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
			
			String sql = "select count(*) from reviewboard";
			
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
		public List<ReviewDto> getList(int start, int perPage) {
			List<ReviewDto> list = new ArrayList<ReviewDto>();

			Connection conn = db.getConnection();
			PreparedStatement pstmt = null;
			ResultSet rs = null;

			String sql = "select * from reviewboard order by r_num desc limit ?,?";

			try {
				pstmt = conn.prepareStatement(sql);

				pstmt.setInt(1, start);
				pstmt.setInt(2, perPage);

				rs = pstmt.executeQuery();

				while (rs.next()) {

					ReviewDto dto = new ReviewDto();

					dto.setR_num(rs.getString("r_num"));
					dto.setR_myid(rs.getString("r_myid"));
					dto.setR_content(rs.getString("r_content"));
					dto.setR_image(rs.getString("r_image"));
					dto.setR_chu(rs.getInt("r_chu"));
					dto.setR_writeday(rs.getTimestamp("r_writeday"));

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
		
		
		// update 수정
		public void updateReview(ReviewDto dto) {

			Connection conn = db.getConnection();
			PreparedStatement pstmt = null;

			String sql = "update reviewboard set r_content=?, r_image=? where r_num=?";

			try {
				pstmt = conn.prepareStatement(sql);

				pstmt.setString(1, dto.getR_content());
				pstmt.setString(2, dto.getR_image());
				pstmt.setString(3, dto.getR_num());

				pstmt.execute();
				;

			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} finally {
				db.dbClose(pstmt, conn);
			}

		}
				
		// 삭제하기
		public void deleteReview(String r_num) {

			Connection conn = db.getConnection();
			PreparedStatement pstmt = null;

			String sql = "delete from reviewboard where r_num=?";

			try {
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, r_num);

				pstmt.execute();

			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} finally {
				db.dbClose(pstmt, conn);
			}

		}

		// 추천 클릭 시 추천수 증가 시키기
		public void updateReviewChu(String r_num) {
			Connection conn = db.getConnection();
			PreparedStatement pstmt = null;

			String sql = "update reviewboard set r_chu=r_chu+1 where r_num=?";

			try {
				pstmt = conn.prepareStatement(sql);

				pstmt.setString(1, r_num);
				pstmt.execute();
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} finally {
				db.dbClose(pstmt, conn);
			}
		}
		
		
		//num값 넘겨주기 -> dto 반환!!
		public ReviewDto getDataReview(String r_num) {
			ReviewDto dto = new ReviewDto();

			Connection conn = db.getConnection();
			PreparedStatement pstmt = null;
			ResultSet rs = null;

			String sql = "select * from reviewboard where r_num=?";

			try {
				pstmt = conn.prepareStatement(sql);

				pstmt.setString(1, r_num);
				rs = pstmt.executeQuery();

				while (rs.next()) {


					dto.setR_num(rs.getString("r_num"));
					dto.setR_myid(rs.getString("r_myid"));
					dto.setR_content(rs.getString("r_content"));
					dto.setR_image(rs.getString("r_image"));
					dto.setR_chu(rs.getInt("r_chu"));
					dto.setR_writeday(rs.getTimestamp("r_writeday"));

				}

			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} finally {
				db.dbClose(rs, pstmt, conn);
			}

			return dto;
		}
	}
