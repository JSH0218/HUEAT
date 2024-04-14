package hugesoinfo.model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Vector;

import favorite.model.FavoriteDto;
import mysql.db.DbConnect;


public class HugesoInfoDao {
	
	DbConnect db=new DbConnect();
	
	
	//전체데이터 List에 담아서 리턴하는 메서드
		public List<HugesoInfoDto> getAllDatas(){
			List<HugesoInfoDto> list = new Vector<HugesoInfoDto>();
			
			Connection conn = db.getConnection();
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			
			String sql ="select * from hugesoinfo order by h_num";
			
			try {
				pstmt = conn.prepareStatement(sql);
				rs=pstmt.executeQuery();
				
				while(rs.next()) {
					HugesoInfoDto dto = new HugesoInfoDto();
					
					dto.setH_num(rs.getString("h_num"));
					dto.setH_name(rs.getString("h_name"));
					dto.setH_xvalue(rs.getString("h_xvalue"));
					dto.setH_yvalue(rs.getString("h_yvalue"));
					dto.setH_photo(rs.getString("h_photo"));
					dto.setH_hp(rs.getString("h_hp"));
					dto.setH_addr(rs.getString("h_addr"));
					dto.setH_pyeon(rs.getString("h_pyeon"));
					dto.setH_brand(rs.getString("h_brand"));
					dto.setH_sangname(rs.getString("h_sangname"));
					dto.setH_sangphoto(rs.getString("h_sangphoto"));
					dto.setH_sangprice(rs.getString("h_sangprice"));
					dto.setH_gasolin(rs.getString("h_gasolin"));
					dto.setH_disel(rs.getString("h_disel"));
					dto.setH_lpg(rs.getString("h_lpg"));
					dto.setH_grade(rs.getString("h_grade"));
					dto.setH_gradecount(rs.getString("h_gradecount"));
					
					
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
		
		//페이징..1.전체갯수반환   2.부분조회(startnum부터 perpage갯수만큼 반환)
				//1.전체갯수반환  
				
				public int getTotalCount()
				{
					
					int total=0;
					Connection conn=db.getConnection();
					PreparedStatement pstmt=null;
					ResultSet rs=null;
					
					String sql="select count(*) from hugesoinfo";
					
					try {
						pstmt=conn.prepareStatement(sql);
						rs=pstmt.executeQuery();
						
						if(rs.next())
							total=rs.getInt(1);
					} catch (SQLException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}finally {
						db.dbClose(rs, pstmt, conn);
					}
					
					
					return total;
				}
				
				//2.부분조회(startnum부터 perpage갯수만큼 반환)
				public List<HugesoInfoDto> getPagingList(int startNum,int perPage)
				{
					List<HugesoInfoDto> list=new ArrayList<HugesoInfoDto>();
					
					Connection conn=db.getConnection();
					PreparedStatement pstmt=null;
					ResultSet rs=null;
					
					String sql="select * from hugesoinfo order by h_num limit ?,?";
					
					try {
						pstmt=conn.prepareStatement(sql);
						
						pstmt.setInt(1, startNum);
						pstmt.setInt(2, perPage);
						
						rs=pstmt.executeQuery();
						
						while(rs.next())
						{
							HugesoInfoDto dto=new HugesoInfoDto();
							
							dto.setH_num(rs.getString("h_num"));
							dto.setH_name(rs.getString("h_name"));
							dto.setH_xvalue(rs.getString("h_xvalue"));
							dto.setH_yvalue(rs.getString("h_yvalue"));
							dto.setH_photo(rs.getString("h_photo"));
							dto.setH_hp(rs.getString("h_hp"));
							dto.setH_addr(rs.getString("h_addr"));
							dto.setH_pyeon(rs.getString("h_pyeon"));
							dto.setH_brand(rs.getString("h_brand"));
							dto.setH_sangname(rs.getString("h_sangname"));
							dto.setH_sangphoto(rs.getString("h_sangphoto"));
							dto.setH_sangprice(rs.getString("h_sangprice"));
							dto.setH_gasolin(rs.getString("h_gasolin"));
							dto.setH_disel(rs.getString("h_disel"));
							dto.setH_lpg(rs.getString("h_lpg"));
							dto.setH_grade(rs.getString("h_grade"));
							dto.setH_gradecount(rs.getString("h_gradecount"));
							
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
				
				
				//h_num에 해당하는 휴게소 데이터 리턴 (hugesodetail.jsp)
				public HugesoInfoDto getData(String h_num) {
					HugesoInfoDto dto = new HugesoInfoDto();
					
					Connection conn = db.getConnection();
					PreparedStatement pstmt=null;
					ResultSet rs = null;
					
					String sql ="select * from hugesoinfo where h_num=?";
					
					try {
						pstmt=conn.prepareStatement(sql);
						pstmt.setString(1, h_num);
						rs=pstmt.executeQuery();
						
						if(rs.next()) {
							dto.setH_num(rs.getString("h_num"));
							dto.setH_name(rs.getString("h_name"));
							dto.setH_xvalue(rs.getString("h_xvalue"));
							dto.setH_yvalue(rs.getString("h_yvalue"));
							dto.setH_photo(rs.getString("h_photo"));
							dto.setH_hp(rs.getString("h_hp"));
							dto.setH_addr(rs.getString("h_addr"));
							dto.setH_pyeon(rs.getString("h_pyeon"));
							dto.setH_brand(rs.getString("h_brand"));
							dto.setH_sangname(rs.getString("h_sangname"));
							dto.setH_sangphoto(rs.getString("h_sangphoto"));
							dto.setH_sangprice(rs.getString("h_sangprice"));
							dto.setH_gasolin(rs.getString("h_gasolin"));
							dto.setH_disel(rs.getString("h_disel"));
							dto.setH_lpg(rs.getString("h_lpg"));
							dto.setH_grade(rs.getString("h_grade"));
							dto.setH_gradecount(rs.getString("h_gradecount"));
						}
					} catch (SQLException e) {
						e.printStackTrace();
					}finally {
						db.dbClose(rs, pstmt, conn);
					}
					
					return dto;
				}
				
				
				//휴게소 즐겨찾기 (hugesodetail.jsp)
				public void favorite(FavoriteDto dto)
				{
					Connection conn=db.getConnection();
					PreparedStatement pstmt=null;
					
					String sql="insert into favorite values(null,?,?)";
					
					try {
						pstmt=conn.prepareStatement(sql);
						
						pstmt.setString(1, dto.getM_num());
						pstmt.setString(2, dto.getH_num());
						
						pstmt.execute();
					} catch (SQLException e) {
						e.printStackTrace();
					}finally {
						db.dbClose(pstmt, conn);
					}
					
				}
				
				
				//휴게소 즐겨찾기 해제 (hugesodetail.jsp)
				//유지))f_num을 구해도 바로 반영이 되지 않아서 결국 m_num과 h_num이 일치할때 삭제되게끔 수정함
				public void deleteFavorite(String m_num,String h_num)
				{
					Connection conn=db.getConnection();
					PreparedStatement pstmt=null;
					
					String sql="delete from favorite where m_num=? and h_num=?";
					
					try {
						pstmt=conn.prepareStatement(sql);
						pstmt.setString(1, m_num);
						pstmt.setString(2, h_num);
						pstmt.execute();
						
					} catch (SQLException e) {
						e.printStackTrace();
					}finally {
						db.dbClose(pstmt, conn);
					}
					
				}
	
	public List<HugesoInfoDto> searchHugesoinfo(String h_name){
		List<HugesoInfoDto> list=new ArrayList<HugesoInfoDto>();
		
		Connection conn=db.getConnection();
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		
		String sql="select * from hugesoinfo where h_name like ?";
		
		try {
			pstmt=conn.prepareStatement(sql);
			
			pstmt.setString(1, "%"+h_name+"%");
			
			rs=pstmt.executeQuery();
			
			while(rs.next()) {
				HugesoInfoDto dto=new HugesoInfoDto();
				
				dto.setH_num(rs.getString("h_num"));
				dto.setH_name(rs.getString("h_name"));
				dto.setH_xvalue(rs.getString("h_xvalue"));
				dto.setH_yvalue(rs.getString("h_yvalue"));
				dto.setH_photo(rs.getString("h_photo"));
				dto.setH_hp(rs.getString("h_hp"));
				dto.setH_addr(rs.getString("h_addr"));
				dto.setH_pyeon(rs.getString("h_pyeon"));
				dto.setH_brand(rs.getString("h_brand"));
				dto.setH_sangname(rs.getString("h_sangname"));
				dto.setH_sangphoto(rs.getString("h_sangphoto"));
				dto.setH_sangprice(rs.getString("h_sangprice"));
				dto.setH_gasolin(rs.getString("h_gasolin"));
				dto.setH_disel(rs.getString("h_disel"));
				dto.setH_lpg(rs.getString("h_lpg"));
				dto.setH_grade(rs.getString("h_grade"));
				dto.setH_gradecount(rs.getString("h_gradecount"));
				
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
	
	//평균 평점(h_grade),평점 갯수(h_gradecount) hugesoinfo에 update
		public void updateH_grade(HugesoInfoDto dto) {
			Connection conn=db.getConnection();
			PreparedStatement pstmt=null;
			
			String sql="update hugesoinfo set h_grade=?, h_gradecount=? where h_num=?";
			
			try {
				pstmt=conn.prepareStatement(sql);
				
				pstmt.setString(1, dto.getH_grade());
				pstmt.setString(2, dto.getH_gradecount());
				pstmt.setString(3, dto.getH_num());
				
				pstmt.execute();
			    } catch (SQLException e) {
			        e.printStackTrace();
			    }finally {
				db.dbClose(pstmt, conn);
			}
			
		}
	
}
