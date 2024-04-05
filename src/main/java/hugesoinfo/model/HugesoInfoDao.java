package hugesoinfo.model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import mysql.db.DbConnect;

public class HugesoInfoDao {
	DbConnect db=new DbConnect();
	
	public List<HugesoInfoDto> selectHugesoInfo(){
		List<HugesoInfoDto> list=new ArrayList<HugesoInfoDto>();
		
		Connection conn=db.getConnection();
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		
		String sql="select * from hugesoinfo order by h_num";
		
		try {
			pstmt=conn.prepareStatement(sql);
			
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
				dto.setH_lgp(rs.getString("h_lpg"));
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
				dto.setH_lgp(rs.getString("h_lpg"));
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
}
