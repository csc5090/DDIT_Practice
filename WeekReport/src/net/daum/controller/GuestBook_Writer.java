package net.daum.controller;

import java.util.Scanner;

import net.daum.dao.GuestBookDAOImpl;
import net.daum.dto.GuestBookDTO;

public class GuestBook_Writer {

	public static void main(String[] args) {

		Scanner scan = new Scanner(System.in);

		System.out.println("========== 방명록 작성 ==========");

		System.out.print("글쓴이 이름 입력 >> ");
		String writer = scan.nextLine();

		System.out.print("제목 입력 >> ");
		String title = scan.nextLine();

		System.out.print("내용 입력 >> ");
		String content = scan.nextLine();

		GuestBookDTO g = new GuestBookDTO(writer, title, content);

		GuestBookDAOImpl gdao = new GuestBookDAOImpl();

		int re = gdao.insertGuest(g);

		if (re == 1) {
			System.out.println("\n방명록 저장에 성공.");
		} else {
			System.out.println("\n방명록 저장에 실패.");
		}
		scan.close();
	}
}
