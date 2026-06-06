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

	// 유지)즐겨찾기 목록 출력 (mypage/favlist.jsp)
	public List<HashMap<String, String>> selectFavlist(String m_id) {
		List<HashMap<String, String>> list = new ArrayList<HashMap<String, String>>();

		Connection conn = db.getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		String sql = "select f.f_num,h.h_name,h.h_addr,h.h_pyeon, h.h_num,h.h_hp from hugesoinfo h,favorite f,meminfo m where h.h_num=f.h_num and m.m_num=f.m_num and m.m_id=?";

		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, m_id);
			rs = pstmt.executeQuery();

			while (rs.next()) {
				HashMap<String, String> map = new HashMap<String, String>();
				map.put("h_num", rs.getString("h_num"));
				map.put("f_num", rs.getString("f_num"));
				map.put("h_name", rs.getString("h_name"));
				map.put("h_addr", rs.getString("h_addr"));
				map.put("h_pyeon", rs.getString("h_pyeon"));
				map.put("h_hp", rs.getString("h_hp"));

				list.add(map);
			}

		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			db.dbClose(rs, pstmt, conn);
		}
		return list;
	}

	// 유지))즐겨찾기한 휴게소인지 여부 판단하는 거 (count 반환)
	public int isFavorite(String m_num, String h_num) {
		int fav = 0;
		Connection conn = db.getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		String sql = "select count(*) from favorite where m_num=? and h_num=?";

		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, m_num);
			pstmt.setString(2, h_num);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				fav = rs.getInt(1);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			db.dbClose(rs, pstmt, conn);
		}

		return fav;
	}

	// 소유자 범위 즐겨찾기 삭제 (IDOR 방어: 세션 m_num 소유분만 삭제 / mypage/favdelete.jsp)
	// 주의) 소유자 조건 없는 PK-only 삭제는 IDOR 위험으로 두지 않는다.
	//       즐겨찾기 목록 삭제는 반드시 아래 2-인자(f_num, m_num) 메서드만 사용한다.
	public void deleteFavoriteByOwner(String f_num, String m_num) {
		Connection conn = db.getConnection();
		PreparedStatement pstmt = null;

		String sql = "delete from favorite where f_num=? and m_num=?";

		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, f_num);
			pstmt.setString(2, m_num);
			pstmt.execute();
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			db.dbClose(pstmt, conn);
		}
	}
}
