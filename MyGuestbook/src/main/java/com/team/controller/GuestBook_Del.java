package com.team.controller;

import java.util.Scanner;

import net.daum.dao.GuestBookDAOImpl;
import net.daum.dto.GuestBookDTO;

public class GuestBook_Del {

	public static void main(String[] args) {
		Scanner scan = new Scanner(System.in);
		GuestBookDAOImpl gdao = new GuestBookDAOImpl();

		System.out.println("========== 방명록 삭제 ==========");
		System.out.print("삭제할 방명록 번호 입력 >> ");

		int gno = 0;

		try {
			gno = Integer.parseInt(scan.nextLine());
		} catch (NumberFormatException e) {
			System.out.println("유효하지 않은 번호. 숫자 확인 바람.");
			scan.close();
			return;
		} //try ~ catch

		GuestBookDTO find_no = gdao.getFindNo(gno);

		if (find_no == null) {
			System.out.println("방명록 번호값이 없거나, 일치하지 않음.");
		} else {

			int re = gdao.delGuest(gno);

			if (re == 1) {
				System.out.println("방명록 삭제에 성공했습니다 !");
			} else {
				System.out.println("방명록 삭제에 실패했습니다. (DB 연결/쿼리 확인 필요)");
			}
		} //if~else
		scan.close();
	}//main
}