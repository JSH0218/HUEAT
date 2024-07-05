package brand.model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import mysql.db.DbConnect;

public class BrandDao {

	DbConnect db=new DbConnect();
	
	public void insertBrand(BrandDto dto) {
		Connection conn=db.getConnection();
		PreparedStatement pstmt=null;
		
		String sql="insert into brand(h_num,b_name,b_photo,b_addr) values(?,?,?,?)";
		
		try {
			pstmt=conn.prepareStatement(sql);
			
			pstmt.setString(1, dto.getH_num());
			pstmt.setString(2, dto.getB_name());
			pstmt.setString(3, dto.getB_photo());
			pstmt.setString(4, dto.getB_addr());
			
			pstmt.execute();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			db.dbClose(pstmt, conn);
		}
	}
	
	public List<BrandDto> selectBrand(String h_num){
		List<BrandDto> list=new ArrayList<BrandDto>();
		
		Connection conn=db.getConnection();
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		
		String sql="select * from brand where h_num=?";
		
		try {
			pstmt=conn.prepareStatement(sql);
			
			pstmt.setString(1, h_num);
			
			rs=pstmt.executeQuery();
			
			while(rs.next()) {
				BrandDto dto=new BrandDto();
				
				dto.setB_num(rs.getString("b_num"));
				dto.setH_num(rs.getString("h_num"));
				dto.setB_name(rs.getString("b_name"));
				dto.setB_photo(rs.getString("b_photo"));
				dto.setB_addr(rs.getString("b_addr"));
				
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

	//h_num이 일치하는 브랜드갯수 출력
	public int getRegisteredTotal(String h_num) {
		int total=0;
		
		Connection conn=db.getConnection();
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		
		String sql="select count(*) from brand where h_num=?";
		
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
	
	//h_num이 일치하는 브랜드정보 출력
	public List<BrandDto> selectRegisteredBrand(String h_num){
		List<BrandDto> list=new ArrayList<BrandDto>();
		
		Connection conn=db.getConnection();
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		
		String sql="select * from brand where h_num=?";
		
		try {
			pstmt=conn.prepareStatement(sql);
			
			pstmt.setString(1, h_num);
			
			rs=pstmt.executeQuery();
			
			while(rs.next()) {
				BrandDto dto=new BrandDto();
				
				dto.setB_num(rs.getString("b_num"));
				dto.setH_num(rs.getString("h_num"));
				dto.setB_name(rs.getString("b_name"));
				dto.setB_photo(rs.getString("b_photo"));
				dto.setB_addr(rs.getString("b_addr"));
				
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
	
	//b_num이 일치하는 브랜드 출력
	public BrandDto getBrandData(String b_num) {
		BrandDto dto=new BrandDto();
		
		Connection conn=db.getConnection();
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		
		String sql="select * from brand where b_num=?";
		
		try {
			pstmt=conn.prepareStatement(sql);
			
			pstmt.setString(1, b_num);
			
			rs=pstmt.executeQuery();
			
			if(rs.next()) {
				dto.setB_num(rs.getString("b_num"));
				dto.setH_num(rs.getString("h_num"));
				dto.setB_name(rs.getString("b_name"));
				dto.setB_photo(rs.getString("b_photo"));
				dto.setB_addr(rs.getString("b_addr"));
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			db.dbClose(rs, pstmt, conn);
		}
		
		return dto;
	}
	
	//b_num이 일치하는 브랜드 수정
	public void updateBrand(BrandDto dto) {
		Connection conn=db.getConnection();
		PreparedStatement pstmt=null;
		
		String sql="update brand set b_name=?,b_photo=?,b_addr=? where b_num=?";
		
		try {
			pstmt=conn.prepareStatement(sql);
			
			pstmt.setString(1, dto.getB_name());
			pstmt.setString(2, dto.getB_photo());
			pstmt.setString(3, dto.getB_addr());
			pstmt.setString(4, dto.getB_num());
			
			pstmt.execute();
			
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			db.dbClose(pstmt, conn);
		}
	}
	
	//특정 b_num 추출
	public String getBrandNum(BrandDto dto) {
		String b_num="없음";
		
		Connection conn=db.getConnection();
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		
		String sql="select b_num from brand where h_num=? and b_name=? and b_photo=? and b_addr=?";
		
		try {
			pstmt=conn.prepareStatement(sql);
			
			pstmt.setString(1, dto.getH_num());
			pstmt.setString(2, dto.getB_name());
			pstmt.setString(3, dto.getB_photo());
			pstmt.setString(4, dto.getB_addr());
			
			rs=pstmt.executeQuery();
			
			if(rs.next()) {
				b_num=rs.getString("b_num");
			}
			
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			db.dbClose(rs, pstmt, conn);
		}
		
		return b_num;
	}
	
	//특정 휴게소 소속 b_num 추출
	public List<String> getHugesoBrandNum(String h_num){
		List<String> list=new ArrayList<String>();
		
		Connection conn=db.getConnection();
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		
		String sql="select b_num from brand where h_num=?";
		
		try {
			pstmt=conn.prepareStatement(sql);
			
			pstmt.setString(1, h_num);
			
			rs=pstmt.executeQuery();
			
			while(rs.next()) {
				list.add(rs.getString("b_num"));
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			db.dbClose(rs, pstmt, conn);
		}
		
		return list;
	}
	
	//b_num을 기준으로 브랜드 삭제
	public void deleteBrand(String b_num) {
		Connection conn=db.getConnection();
		PreparedStatement pstmt=null;
		
		String sql="delete from brand where b_num=?";
		
		try {
			pstmt=conn.prepareStatement(sql);
			
			pstmt.setString(1, b_num);
			
			pstmt.execute();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			db.dbClose(pstmt, conn);
		}
	}
	
	//h_num을 기준으로 브랜드 삭제
	public void deleteHugesoBrand(String h_num) {
		Connection conn=db.getConnection();
		PreparedStatement pstmt=null;
		
		String sql="delete from brand where h_num=?";
		
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
}
