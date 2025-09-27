package net.daum.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import net.daum.dto.GuestBookDTO;

public class GuestBookDAOImpl {

	String driver = "oracle.jdbc.driver.OracleDriver";
	String url = "jdbc:oracle:thin:@127.0.0.1:1521:xe";
	String user = "week";
	String pwd = "week";

	Connection con = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	String sql = null;

	public GuestBookDAOImpl() {

		try {
			Class.forName(driver);
			System.out.println("드라이버 로딩 완료.");
		} catch (ClassNotFoundException e) {
			System.out.println("드라이버를 찾을 수 없음.");
			e.printStackTrace();
		}
	} // GuestBookDAOImpl 기본생성자(드라이버 연결)

	private Connection getConnection() throws SQLException {
		return DriverManager.getConnection(url, user, pwd);
	} // Connection

	public int insertGuest(GuestBookDTO g) {
		int re = -1;
		String sql = "INSERT INTO tbl_guestbook (gno, gname, gtitle, gcont, gdate) "
				+ "VALUES (gno_seq.nextval, ?, ?, ?, sysdate)";

		try (Connection con = getConnection(); PreparedStatement pstmt = con.prepareStatement(sql)) {

			// 롬복이 생성한 Getter를 사용
			pstmt.setString(1, g.getGname());
			pstmt.setString(2, g.getGtitle());
			pstmt.setString(3, g.getGcont());

			re = pstmt.executeUpdate();

		} catch (SQLException e) {
			e.printStackTrace();
		}
		return re;
	}// insert

	public List<GuestBookDTO> getGuestBookList() {

		List<GuestBookDTO> list = new ArrayList<>();

		String sql = "SELECT gno, gname, gtitle, gcont, gdate FROM tbl_guestbook ORDER BY gno DESC";

		try (Connection con = DriverManager.getConnection(url, user, pwd);
				PreparedStatement pstmt = con.prepareStatement(sql);
				ResultSet rs = pstmt.executeQuery()) {

			while (rs.next()) {
				GuestBookDTO dto = new GuestBookDTO();
				dto.setGno(rs.getInt("gno"));
				dto.setGname(rs.getString("gname"));
				dto.setGtitle(rs.getString("gtitle"));
				dto.setGcont(rs.getString("gcont"));
				dto.setGdate(rs.getString("gdate"));

				list.add(dto);
			}
		} catch (SQLException e) {
			System.err.println("방명록 목록 조회 중 SQL 오류: " + e.getMessage());
			e.printStackTrace();
		}
		return list;
	}// read

	public GuestBookDTO getFindNo(int gno) {
		GuestBookDTO dto = null;
		String sql = "SELECT * FROM tbl_guestbook WHERE gno = ?";

		try (Connection con = DriverManager.getConnection(url, user, pwd);
				PreparedStatement pstmt = con.prepareStatement(sql)) {

			pstmt.setInt(1, gno);

			try (ResultSet rs = pstmt.executeQuery()) {
				if (rs.next()) {
					dto = new GuestBookDTO();
					dto.setGno(rs.getInt("gno"));
					dto.setGname(rs.getString("gname"));
					dto.setGtitle(rs.getString("gtitle"));
					dto.setGcont(rs.getString("gcont"));
					dto.setGdate(rs.getString("gdate"));
				}
			}
		} catch (SQLException e) {
			System.err.println("방명록 번호 검색 중 SQL 오류: " + e.getMessage());
			e.printStackTrace();
		}
		return dto;
	} // search

	public int editGuestBook(GuestBookDTO gb) {
		int re = -1;
		String sql = "UPDATE tbl_guestbook SET gname=?, gtitle=?, gcont=? WHERE gno=?";

		try (Connection con = DriverManager.getConnection(url, user, pwd);
				PreparedStatement pstmt = con.prepareStatement(sql)) {

			pstmt.setString(1, gb.getGname());
			pstmt.setString(2, gb.getGtitle());
			pstmt.setString(3, gb.getGcont());
			pstmt.setInt(4, gb.getGno());

			re = pstmt.executeUpdate();

		} catch (SQLException e) {
			System.err.println("오류: " + e.getMessage());
			e.printStackTrace();
		}
		return re;
	} // edit

	public int delGuest(int gno) {
		int re = -1;
		String sql = "DELETE FROM tbl_guestbook WHERE gno = ?";

		try (Connection con = DriverManager.getConnection(url, user, pwd);
				PreparedStatement pstmt = con.prepareStatement(sql)) {

			pstmt.setInt(1, gno);

			re = pstmt.executeUpdate();

		} catch (SQLException e) {
			System.err.println("오류: " + e.getMessage());
			e.printStackTrace();
		}
		return re;
	} //delete
}
