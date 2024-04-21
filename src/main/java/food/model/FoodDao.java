package food.model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import mysql.db.DbConnect;

public class FoodDao {

	DbConnect db=new DbConnect();
	
	public void insertFood(FoodDto dto) {
		Connection conn=db.getConnection();
		PreparedStatement pstmt=null;
		
		String sql="insert into food(h_num,f_name,f_photo,f_price) values(?,?,?,?)";
		
		try {
			pstmt=conn.prepareStatement(sql);
			
			pstmt.setString(1, dto.getH_num());
			pstmt.setString(2, dto.getF_name());
			pstmt.setString(3, dto.getF_photo());
			pstmt.setString(4, dto.getF_price());
			
			pstmt.execute();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			db.dbClose(pstmt, conn);
		}
	}
	
	//h_num이 일치하는 음식갯수 출력
	public int getRegisteredTotal(String h_num) {
		int total=0;
		
		Connection conn=db.getConnection();
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		
		String sql="select count(*) from food where h_num=?";
		
		try {
			pstmt=conn.prepareStatement(sql);
			
			pstmt.setString(1, h_num);
			
			rs=pstmt.executeQuery();
			
			if(rs.next()) {
				total=rs.getInt(1);
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			db.dbClose(rs, pstmt, conn);
		}
		
		return total;
	}
	
	//유지)) 휴게소별 메뉴판 구현을 위해서 작성
	public List<FoodDto> getMenu(String h_num){
		List<FoodDto> list=new ArrayList<FoodDto>();
		Connection conn=db.getConnection();
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		
		String sql="select * from food where h_num=?";
    
		try {
			pstmt=conn.prepareStatement(sql);
			pstmt.setString(1, h_num);
			rs=pstmt.executeQuery();
			
			while(rs.next()) {
				FoodDto dto=new FoodDto();
        
				dto.setF_num(rs.getString("f_num"));
				dto.setF_name(rs.getString("f_name"));
				dto.setF_photo(rs.getString("f_photo"));
				dto.setF_price(rs.getString("f_price"));
				dto.setH_num(rs.getString("h_num"));
				
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
	
	//f_num이 일치는 음식정보 출력
	public FoodDto getFoodData(String f_num) {
		FoodDto dto=new FoodDto();
		
		Connection conn=db.getConnection();
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		
		String sql="select * from food where f_num=?";
		
		try {
			pstmt=conn.prepareStatement(sql);
			
			pstmt.setString(1, f_num);
			
			rs=pstmt.executeQuery();
			
			if(rs.next()) {
				dto.setF_num(rs.getString("f_num"));
				dto.setH_num(rs.getString("h_num"));
				dto.setF_name(rs.getString("f_name"));
				dto.setF_photo(rs.getString("f_photo"));
				dto.setF_price(rs.getString("f_price"));
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			db.dbClose(rs, pstmt, conn);
		}
		
		return dto;
	}
	
	//f_num이 일치하는 음식정보 수정
	public void updateFood(FoodDto dto) {
		Connection conn=db.getConnection();
		PreparedStatement pstmt=null;
		
		String sql="update food set f_name=?,f_photo=?,f_price=? where f_num=?";
		
		try {
			pstmt=conn.prepareStatement(sql);
			
			pstmt.setString(1, dto.getF_name());
			pstmt.setString(2, dto.getF_photo());
			pstmt.setString(3, dto.getF_price());
			pstmt.setString(4, dto.getF_num());
			
			pstmt.execute();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			db.dbClose(pstmt, conn);
		}
	}
	
	//특정 f_num 추출
	public String getFoodNum(FoodDto dto) {
		String f_num="없음";
    
    Connection conn=db.getConnection();
		PreparedStatement pstmt=null;
		ResultSet rs=null;
    
    String sql="select f_num from food where h_num=? and f_name=? and f_photo=? and f_price=?";
		
		try {
			pstmt=conn.prepareStatement(sql);
			
			pstmt.setString(1, dto.getH_num());
			pstmt.setString(2, dto.getF_name());
			pstmt.setString(3, dto.getF_photo());
			pstmt.setString(4, dto.getF_price());
      
      rs=pstmt.executeQuery();
			
			if(rs.next()) {
				f_num=rs.getString("f_num");
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			db.dbClose(rs, pstmt, conn);
		}
		
		return f_num;
	}
	
	//특정 휴게소 소속 f_num 추출
	public List<String> getHugesoFoodNum(String h_num){
		List<String> list=new ArrayList<String>();
		
		Connection conn=db.getConnection();
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		
		String sql="select f_num from food where h_num=?";
		
		try {
			pstmt=conn.prepareStatement(sql);
			
			pstmt.setString(1, h_num);
			
			rs=pstmt.executeQuery();
			
			while(rs.next()) {
				list.add(rs.getString("f_num"));
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			db.dbClose(rs, pstmt, conn);
		}
		
		return list;
	}
	
	//f_num을 기준으로 음식정보 삭제
	public void deleteFood(String f_num) {
		Connection conn=db.getConnection();
		PreparedStatement pstmt=null;
		
		String sql="delete from food where f_num=?";
		
		try {
			pstmt=conn.prepareStatement(sql);
			
			pstmt.setString(1, f_num);
			
			pstmt.execute();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			db.dbClose(pstmt, conn);
		}
	}
	
	//h_num을 기준으로 음식정보 삭제
	public void deleteHugesoFood(String h_num) {
		Connection conn=db.getConnection();
		PreparedStatement pstmt=null;
		
		String sql="delete from food where h_num=?";
		
		try {
			pstmt=conn.prepareStatement(sql);
			
			pstmt.setString(1, h_num);
			
			pstmt.execute();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			db.dbClose(pstmt, conn);
		}
	}
	
	
	//h_num을 기준으로 음식정보 출력
	public List<FoodDto> selectFood(String h_num){
		List<FoodDto> list=new ArrayList<FoodDto>();
		
		Connection conn=db.getConnection();
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		
		String sql="select * from food where h_num=?";
		
		try {
			pstmt=conn.prepareStatement(sql);
			
			pstmt.setString(1, h_num);
			
			rs=pstmt.executeQuery();
			
			while(rs.next()) {
				FoodDto dto=new FoodDto();
				
				dto.setF_num(rs.getString("f_num"));
				dto.setF_name(rs.getString("f_name"));
				dto.setF_photo(rs.getString("f_photo"));
				dto.setF_price(rs.getString("f_price"));
				
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
  
  //유지)) f_num을 얻기위해서 h_num과 f_name사용
	public String getF_num(String h_num, String f_name) {
		String f_num="";
    
		Connection conn=db.getConnection();
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		
		String sql="select f_num from food where h_num=? and f_name=?";
		try {
			pstmt=conn.prepareStatement(sql);
			pstmt.setString(1, h_num);
			pstmt.setString(2, f_name);
			rs=pstmt.executeQuery();
			
			if(rs.next()) {
				f_num=rs.getString("f_num");
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally {
			db.dbClose(rs, pstmt, conn);
		}	
		return f_num;
	}
	
	
	// 음식 평균 평점 update (hugesodetail.jsp)
	public void updateF_grade(FoodDto dto) {
	    Connection conn = db.getConnection();
	    PreparedStatement pstmt = null;

	    String sql = "update food set f_grade=? where f_num=? and h_num=?";

	    try {
	        pstmt = conn.prepareStatement(sql);

	        pstmt.setString(1, dto.getF_grade());
	        pstmt.setString(2, dto.getF_num());
	        pstmt.setString(3, dto.getH_num());

	        pstmt.executeUpdate();
	    } catch (SQLException e) {
	        e.printStackTrace();
	    } finally {
	        db.dbClose(pstmt, conn);
	    }
	}

}
