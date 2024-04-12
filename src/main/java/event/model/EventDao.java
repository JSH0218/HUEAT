package event.model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import mysql.db.DbConnect;
import notice.model.NoticeDto;

public class EventDao {
	
	DbConnect db = new DbConnect();
	
	//insert 저장
		public void insertEvent(EventDto dto) {
			
			Connection conn = db.getConnection();
			PreparedStatement pstmt = null;
			
			String sql = "insert into eventboard values(null,?,?,?,0,0,now())";
			
			try {
				pstmt = conn.prepareStatement(sql);
				
				pstmt.setString(1, dto.getE_subject());
				pstmt.setString(2, dto.getE_content());
				pstmt.setString(3, dto.getE_image());
				
				pstmt.execute();
				
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}finally {
				db.dbClose(pstmt, conn);
			}
		}
		
		
		
		//noticelist 전체 출력
		public List<EventDto> getAllEvent() {
			List<EventDto> list = new ArrayList<EventDto>();
			
			Connection conn = db.getConnection();
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			
			String sql = "select * from eventboard order by e_num desc";
			
			try {
				pstmt = conn.prepareStatement(sql);
				rs = pstmt.executeQuery();
				
				while(rs.next()) {
					
					EventDto dto = new EventDto();
					
					dto.setE_num(rs.getString("e_num"));
					dto.setE_subject(rs.getString("e_subject"));
					dto.setE_content(rs.getString("e_content"));
					dto.setE_readcount(rs.getInt("e_readcount"));
					dto.setE_chu(rs.getInt("e_chu"));
					dto.setE_writeday(rs.getTimestamp("e_writeday"));
					
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
			
			String sql = "select count(*) from eventboard";
			
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
			public List<EventDto> getList(int start, int perPage) {
				List<EventDto> list = new ArrayList<EventDto>();

				Connection conn = db.getConnection();
				PreparedStatement pstmt = null;
				ResultSet rs = null;

				String sql = "select * from eventboard order by e_num desc limit ?,?";

				try {
					pstmt = conn.prepareStatement(sql);

					pstmt.setInt(1, start);
					pstmt.setInt(2, perPage);

					rs = pstmt.executeQuery();

					while (rs.next()) {

						EventDto dto = new EventDto();

						dto.setE_num(rs.getString("e_num"));
						dto.setE_subject(rs.getString("e_subject"));
						dto.setE_content(rs.getString("e_content"));
						dto.setE_readcount(rs.getInt("e_readcount"));
						dto.setE_chu(rs.getInt("e_chu"));
						dto.setE_writeday(rs.getTimestamp("e_writeday"));

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
			
			
			//detail페이지 num값 넘겨주기 -> dto 반환!!
			public EventDto getDataEvent(String e_num) {
				EventDto dto = new EventDto();
				
				Connection conn = db.getConnection();
				PreparedStatement pstmt = null;
				ResultSet rs = null;
				
				String sql = "select * from eventboard where e_num=?";
				
				try {
					pstmt = conn.prepareStatement(sql);
					
					pstmt.setString(1, e_num);
					rs = pstmt.executeQuery();
					
					while(rs.next()) {
						
						dto.setE_num(rs.getString("e_num"));
						dto.setE_subject(rs.getString("e_subject"));
						dto.setE_content(rs.getString("e_content"));
						dto.setE_image(rs.getString("e_image"));
						dto.setE_readcount(rs.getInt("e_readcount"));
						dto.setE_chu(rs.getInt("e_chu"));
						dto.setE_writeday(rs.getTimestamp("e_writeday"));
						
					}
					
				} catch (SQLException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}finally {
					db.dbClose(rs, pstmt, conn);
				}
				
				return dto;
			}
			
			// readcount 해주기 / 조회수 및 추천 
			public void updateReadcount(String e_num) {
				Connection conn = db.getConnection();
				PreparedStatement pstmt = null;

				String sql = "update eventboard set e_readcount=e_readcount+1 where e_num=?";

				try {
					pstmt = conn.prepareStatement(sql);
					pstmt.setString(1, e_num);
					pstmt.execute();

				} catch (SQLException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				} finally {
					db.dbClose(pstmt, conn);
				}
			}
			
			//update 수정
			public void updateEvent(EventDto dto) {
				
				Connection conn = db.getConnection();
				PreparedStatement pstmt = null;
				
				String sql = "update eventboard set e_subject=?, e_content=?, e_image=? where e_num=?";
				
				try {
					pstmt = conn.prepareStatement(sql);
					
					pstmt.setString(1, dto.getE_subject());
					pstmt.setString(2, dto.getE_content());
					pstmt.setString(3, dto.getE_image());
					pstmt.setString(4, dto.getE_num());
					
					pstmt.execute();;
					
				} catch (SQLException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}finally {
					db.dbClose(pstmt, conn);
				}
				
			}
			
			//삭제하기
			public void deleteEvent(String e_num) {
				
				Connection conn = db.getConnection();
				PreparedStatement pstmt = null;
				
				String sql = "delete from eventboard where e_num=?";
				
				try {
					pstmt = conn.prepareStatement(sql);
					pstmt.setString(1, e_num);
					
					pstmt.execute();
					
				} catch (SQLException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}finally {
					db.dbClose(pstmt, conn);
				}
				
			}
			
			// 추천 클릭 시 추천수 증가 시키기
			public void updateEventChu(String e_num) {
				Connection conn = db.getConnection();
				PreparedStatement pstmt = null;

				String sql = "update eventboard set e_chu=e_chu+1 where e_num=?";

				try {
					pstmt = conn.prepareStatement(sql);

					pstmt.setString(1, e_num);
					pstmt.execute();
				} catch (SQLException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				} finally {
					db.dbClose(pstmt, conn);
				}
			}

}
