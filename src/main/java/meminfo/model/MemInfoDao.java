package meminfo.model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import favorite.model.FavoriteDto;
import mysql.db.DbConnect;

public class MemInfoDao {

	DbConnect db=new DbConnect();
	
	//즐겨찾기 시 세션에 로그인 된 아이디를 이용해 MemInfo의 m_num을 얻는 메서드 (hugesodetail.jsp)
			public String getM_num(String m_id)
			{
				String m_num="";
				
				Connection conn=db.getConnection();
				PreparedStatement pstmt=null;
				ResultSet rs=null;
				
				String sql="select m_num from meminfo where m_id=?";
				
				try {
					pstmt=conn.prepareStatement(sql);
					pstmt.setString(1, m_id);
					rs=pstmt.executeQuery();
					
					if(rs.next())
						m_num=rs.getString("m_num");
				} catch (SQLException e) {
					e.printStackTrace();
				}finally {
					db.dbClose(rs, pstmt, conn);
				}
				
				
				return m_num;
			}

	// 회원가입
	public void insertMember(MemInfoDto dto) {
		Connection conn = db.getConnection();
		PreparedStatement pstmt = null;

		String sql = "insert into meminfo values(null,?,?,?,?,?,?,?,?,now())";

		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, dto.getM_name());
			pstmt.setString(2, dto.getM_nick());
			pstmt.setString(3, dto.getM_id());
			pstmt.setString(4, dto.getM_pass());
			pstmt.setString(5, dto.getM_hp1());
			pstmt.setString(6, dto.getM_hp2());
			pstmt.setString(7, dto.getM_birth());
			pstmt.setString(8, dto.getM_email());
			pstmt.execute();

		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			db.dbClose(pstmt, conn);
		}
	}

	// 아이디 중복 확인
	public int idcount(String m_id) {
		int isid = 0;
		Connection conn = db.getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		String sql = "select count(*) from meminfo where m_id=?";

		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, m_id);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				isid = rs.getInt(1);
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			db.dbClose(rs, pstmt, conn);
		}

		return isid;
	}

	// 닉네임 중복방지
	public int nickcount(String m_nick) {
		int isnick = 0;
		Connection conn = db.getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		String sql = "select count(*) from meminfo where m_nick=?";

		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, m_nick);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				isnick = rs.getInt(1);
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			db.dbClose(rs, pstmt, conn);
		}
		return isnick;
	}

	// 로그인시 사용할 메서드(id와 pass가 일치 하는 가)
	public boolean isIdPassMember(String m_id, String m_pass) {
		boolean idpass = false;

		Connection conn = db.getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		String sql = "select * from meminfo where m_id=? and m_pass=?";

		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, m_id);
			pstmt.setString(2, m_pass);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				idpass = true;
			}

		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			db.dbClose(rs, pstmt, conn);
		}

		return idpass;
	}

	// 이름과 핸드폰 번호로 아이디 찾기11
	public String idsearch(String m_name, String m_hp2) {
		String b = "";
		Connection conn = db.getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		String sql = "select m_id from meminfo where m_name=? and m_hp2=?";

		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, m_name);
			pstmt.setString(2, m_hp2);
			rs = pstmt.executeQuery();

			if (rs.next()) {
				b = rs.getString("m_id");
			}

		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			db.dbClose(rs, pstmt, conn);
		}

		return b;
	}

	// 이름과 이메일로 아이디 찾기22
	public String idsearch2(String m_name, String m_email) {
		String e = "";

		Connection conn = db.getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		String sql = "select m_id from meminfo where m_name=? and m_email=?";

		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, m_name);
			pstmt.setString(2, m_email);
			rs = pstmt.executeQuery();

			if (rs.next()) {
				e = rs.getString("m_id");
			}

		} catch (SQLException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		} finally {
			db.dbClose(rs, pstmt, conn);
		}
		return e;
	}

//이름,아이디,핸드폰번호로 비밀번호 찾기
	public String passSearch(String m_name, String m_id, String m_hp2) {
		String p = "";
		Connection conn = db.getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		String sql = "select m_pass from meminfo where m_name=? and m_id=? and m_hp2=?";
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, m_name);
			pstmt.setString(2, m_id);
			pstmt.setString(3, m_hp2);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				p = rs.getString("m_pass");
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			db.dbClose(rs, pstmt, conn);
		}

		return p;

	}

	// 아이디를 넣고 getAlldatas 저장된 값 받아오기
	public MemInfoDto getAlldatas(String m_id) {
		MemInfoDto dto = new MemInfoDto();

		Connection conn = db.getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		String sql = "select * from meminfo where m_id=?";

		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, m_id);
			rs = pstmt.executeQuery();

			if (rs.next()) {
				dto.setM_num(rs.getString("m_num"));
				dto.setM_name(rs.getString("m_name"));
				dto.setM_nick(rs.getString("m_nick"));
				dto.setM_id(rs.getString("m_id"));
				dto.setM_pass(rs.getString("m_pass"));
				dto.setM_hp1(rs.getString("m_hp1"));
				dto.setM_hp2(rs.getString("m_hp2"));
				dto.setM_birth(rs.getString("m_birth"));
				dto.setM_email(rs.getString("m_email"));
				dto.setM_gaipday(rs.getTimestamp("M_gaipday"));
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			db.dbClose(rs, pstmt, conn);
		}
		return dto;

	}

	// num과 pass를 넣고 값이 있는지 확인하기
	public int numPassCheck(String m_num, String m_nick) {
		int count = 0;
		Connection conn = db.getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		String sql = "select count(*) from meminfo where m_num=? and m_nick=?";

		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, m_num);
			pstmt.setString(2, m_nick);
			rs = pstmt.executeQuery();

			if (rs.next()) {
				count = rs.getInt(1);
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			db.dbClose(rs, pstmt, conn);
		}
		return count;
	}

	// num을 넣고 현재 닉네임 받아오기
	public String getNick(String m_num) {
		String m_nick = "";

		Connection conn = db.getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		String sql = "select * from meminfo where m_num=?";

		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, m_num);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				m_nick = rs.getString("m_nick");
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			db.dbClose(rs, pstmt, conn);
		}
		return m_nick;
	}

	// 수정
	public void updateMember(MemInfoDto dto) {
		Connection conn = db.getConnection();
		PreparedStatement pstmt = null;

		String sql = "update meminfo set m_pass=?,m_name=?,m_nick=?, m_email=?, m_hp1=?, m_hp2=?, m_birth=? where m_num=?";

		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, dto.getM_pass());
			pstmt.setString(2, dto.getM_name());
			pstmt.setString(3, dto.getM_nick());
			pstmt.setString(4, dto.getM_email());
			pstmt.setString(5, dto.getM_hp1());
			pstmt.setString(6, dto.getM_hp2());
			pstmt.setString(7, dto.getM_birth());
			pstmt.setString(8, dto.getM_num());
			pstmt.execute();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			db.dbClose(pstmt, conn);
		}
	}	
		
		//닉네임을 넣고 현재 닉네임 받아오기
		public String inputIDGetNick(String m_id)
		{
			String m_nick="";
					
			Connection conn=db.getConnection();
			PreparedStatement pstmt=null;
			ResultSet rs=null;
					
			String sql="select * from meminfo where m_num=?";
					
			try {
				pstmt=conn.prepareStatement(sql);
				pstmt.setString(1, m_id);
				rs=pstmt.executeQuery();
				if(rs.next()) {
					m_nick=rs.getString("m_nick");
				}
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} finally {
				db.dbClose(rs, pstmt, conn);
			}
			return m_nick;
		}
	

		//삭제 delete메서드
		public void deleteMember(String m_num)
		{
			Connection conn=db.getConnection();
			PreparedStatement pstmt=null;
			
			String sql="delete from meminfo where m_num=?";
			
			try {
				pstmt=conn.prepareStatement(sql);
				pstmt.setString(1, m_num);
				pstmt.execute();
        
      } catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} finally {
				db.dbClose(pstmt, conn);
			}
		}

	//즐겨찾기 목록 출력

	public List<HashMap<String, String>> getFavlist(String m_num){
		List<HashMap<String, String>> list=new ArrayList<HashMap<String,String>>();
		
		Connection conn=db.getConnection();
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		
		String sql="select f.f_num,h.h_name,h.h_addr,h.h_pyeon,h.h_brand from hugesoinfo h,favorite f,meminfo m where h.h_num=f.h_num and m.m_num=f.m_num and m.m_num=?";
		
		try {
			pstmt=conn.prepareStatement(sql);
			pstmt.setString(1, m_num);
			rs=pstmt.executeQuery();
			
			while(rs.next()) {
				HashMap<String, String> map=new HashMap<String, String>();
				map.put("f_num", rs.getString("f_num"));
				map.put("h_name", rs.getString("h_name"));
				map.put("h_addr", rs.getString("h_addr"));
				map.put("h_pyeon", rs.getString("h_pyeon"));
				map.put("h_brand", rs.getString("h_brand"));
				list.add(map);
			}
			
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally {
			db.dbClose(rs, pstmt, conn);
		}
		return list;
		
	}
	
	//유지))m_num과 h_num이 일치할때의 f_num을 구하는 메서드
	public String f_numData(String m_num,String h_num) {
		String fnum="";
		Connection conn=db.getConnection();
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		String sql="select f_num from favorite where m_num=? and h_num=?";
		
		try {
			pstmt=conn.prepareStatement(sql);
			pstmt.setString(1, m_num);
			pstmt.setString(2, h_num);
			rs=pstmt.executeQuery();
			
			if(rs.next()) {
				fnum=rs.getString("f_num");
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		return fnum;
	}
	
	//유지))즐겨찾기한 휴게소인지 여부 판단하는 거
	public int isFavorite(String m_num, String h_num) {
		int fav=0;
		Connection conn=db.getConnection();
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		
		String sql="select count(*) from favorite where m_num=? and h_num=?";
		
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, m_num);
			pstmt.setString(2, h_num);
			rs=pstmt.executeQuery();
			if(rs.next()) {
				fav=rs.getInt(1);
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally {
			db.dbClose(rs, pstmt, conn);
		}
		
		return fav;
	}

	
	public List<FavoriteDto> getFavData(String m_num){
		List<FavoriteDto> list=new ArrayList<FavoriteDto>();
		Connection conn=db.getConnection();
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		
		String sql="select * from favorite where m_num=?";
		try {
			pstmt=conn.prepareStatement(sql);
			pstmt.setString(1, m_num);
			rs=pstmt.executeQuery();
			
			while(rs.next()) {
				FavoriteDto dto=new FavoriteDto();
				dto.setF_num(rs.getString("f_num"));
				dto.setH_num(rs.getString("h_num"));
				dto.setM_num(rs.getString("m_num"));
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
	
	// 닉네임, 아이디불러오기 (리뷰에 연동)
		public String getId(String m_id) {
			String m_nick = "";

			Connection conn = db.getConnection();
			PreparedStatement pstmt = null;
			ResultSet rs = null;

			String sql = "select * from meminfo where m_id=?";

			try {
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, m_id);
				rs = pstmt.executeQuery();
				if (rs.next()) {
					m_nick = rs.getString("m_nick");
				}
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} finally {
				db.dbClose(rs, pstmt, conn);
			}
			return m_nick;
		}
}

	

