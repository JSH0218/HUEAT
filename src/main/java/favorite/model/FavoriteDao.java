package favorite.model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import mysql.db.DbConnect;

// 즐겨찾기 도메인 DAO (기존 HugesoInfoDao·MemInfoDao에 분산돼 있던 즐겨찾기 로직을 응집)
public class FavoriteDao {

	private DbConnect db = new DbConnect();

	// 휴게소 즐겨찾기 등록 (hugesodetail.jsp)
	public void insertFavorite(FavoriteDto dto) {
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
		} finally {
			db.dbClose(pstmt, conn);
		}
	}

	// 휴게소 즐겨찾기 해제 (hugesodetail.jsp 하트 토글)
	// 유지))f_num을 구해도 바로 반영이 되지 않아서 결국 m_num과 h_num이 일치할때 삭제되게끔 수정함
	public void deleteFavorite(String m_num,String h_num) {
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
		} finally {
			db.dbClose(pstmt, conn);
		}
	}
}
