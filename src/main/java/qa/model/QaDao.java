package qa.model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import mysql.db.DbConnect;

public class QaDao {
	
	DbConnect db = new DbConnect();
	
	public void insertQa(QaDto dto) {
		
		Connection conn = db.getConnection();
		PreparedStatement pstmt = null;
		
		String sql = "insert into qaboard values(null,?,?,?,0,now())";
		
		try {
			pstmt = conn.prepareStatement(sql);
			
			
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
				
	}

}
