package shop;

import java.nio.channels.SelectableChannel;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import mysql.db.DbConnect;
import review.model.ReviewDto;

public class ShopDao {
	
	DbConnect db = new DbConnect();
	
	//insert
	public void insertShop(ShopDto dto) {

		Connection conn = db.getConnection();
		PreparedStatement pstmt = null;

		String sql = "insert into shop values(null,?,?,?)";

		try {
			pstmt = conn.prepareStatement(sql);

			pstmt.setString(1, dto.getS_category());
			pstmt.setString(2, dto.getS_site());
			pstmt.setString(3, dto.getS_image());

			pstmt.execute();

		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			db.dbClose(pstmt, conn);
		}

	}
	
	//전체 list 출력
	public List<ShopDto> allShop() {
		
		List<ShopDto> list = new ArrayList<ShopDto>();
		
		Connection conn = db.getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		String sql = "Select * from shop order by s_num desc";
		
		try {
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			
			while(rs.next()) {
				ShopDto dto = new ShopDto();
				
				dto.setS_num(rs.getString("s_num"));
				dto.setS_category(rs.getString("s_category"));
				dto.setS_site(rs.getString("s_site"));
				dto.setS_image(rs.getString("s_image"));
				
				list.add(dto);
				
			}
			
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		return list;
		
	}
	
	//삭제
	public void deleteShop(String s_num) {

		Connection conn = db.getConnection();
		PreparedStatement pstmt = null;

		String sql = "delete from shop where s_num=?";

		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, s_num);

			pstmt.execute();

		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			db.dbClose(pstmt, conn);
		}

	}
	
	
	//num값 넘겨주기 -> dto 반환!!
			public ShopDto getDataShop(String s_num) {
				ShopDto dto = new ShopDto();

				Connection conn = db.getConnection();
				PreparedStatement pstmt = null;
				ResultSet rs = null;

				String sql = "select * from shop where s_num=?";

				try {
					pstmt = conn.prepareStatement(sql);

					pstmt.setString(1, s_num);
					rs = pstmt.executeQuery();

					while (rs.next()) {


						dto.setS_num(rs.getString("s_num"));
						dto.setS_category(rs.getString("s_category"));
						dto.setS_site(rs.getString("s_site"));
						dto.setS_image(rs.getString("s_image"));

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
