package net.daum.controller;

import java.util.Scanner;

import net.daum.dao.GuestBookDAOImpl;
import net.daum.dto.GuestBookDTO;

public class GuestBook_Edit {

	public static void main(String[] args) {
		Scanner scan = new Scanner(System.in);
		GuestBookDAOImpl gdao = new GuestBookDAOImpl();

		System.out.println("========== 방명록 수정 ==========");
		System.out.print("수정할 방명록 번호 입력 >> ");

		int gno = Integer.parseInt(scan.nextLine());

		GuestBookDTO find_no = gdao.getFindNo(gno);

		if (find_no == null) {
			System.out.println("방명록 번호값 불일치 or 존재하지 않음.");
		} else {
			System.out.println("기존 제목: " + find_no.getGtitle());
			System.out.print("수정할 글쓴이 입력 >> ");
			String newWriter = scan.nextLine();
			System.out.print("수정할 제목 입력 >> ");
			String newTitle = scan.nextLine();
			System.out.print("수정할 내용 입력 >> ");
			String newContent = scan.nextLine();

			GuestBookDTO editDto = new GuestBookDTO();
			editDto.setGno(gno);
			editDto.setGname(newWriter);
			editDto.setGtitle(newTitle);
			editDto.setGcont(newContent);

			int re = gdao.editGuestBook(editDto);

			if (re == 1) {
				System.out.println("\n방명록 수정에 성공했습니다 !");
			} else {
				System.out.println("\n방명록 수정에 실패했습니다.");
			}
		}
		scan.close();
	}
}
