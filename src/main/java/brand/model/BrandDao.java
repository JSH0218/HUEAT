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
		}
		
		return list;
	}
}
