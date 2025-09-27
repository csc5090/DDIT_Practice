package com.team.controller;

import java.util.List;
import java.util.Scanner;

import com.team.dao.GuestBookDAOImpl;
import com.team.dto.GuestBookDTO;

public class GuestBookMain {

	private static final Scanner scan = new Scanner(System.in);
	private static final GuestBookDAOImpl gdao = new GuestBookDAOImpl();

	public static void main(String[] args) {

		while (true) {
			System.out.println("============= 메뉴 ============");
			System.out.println("1. 방명록 작성 | 2. 목록 확인 | 3. 방명록 수정 | 4.방명록 삭제 | 5.종료");
			System.out.print("메뉴 번호 입력 >> ");
			String inputStr = scan.nextLine();

			int input = 0;
			try {
				input = Integer.parseInt(inputStr);
			} catch (NumberFormatException e) {
				System.out.println("유효하지 않은 입력입니다. 숫자를 입력해주세요.");
				continue;
			}

			switch (input) {
			case 1:
				insertGuestBook();
				break;
			case 2:

				selectGuestBookList();
				break;
			case 3:
				editGuestBook();
				break;
			case 4:
				deleteGuestBook();
				break;
			case 5:
				System.out.println("프로그램을 종료합니다.");
				scan.close();
				return; // 프로그램 종료
			default:
				System.out.println("잘못된 메뉴 번호입니다. 다시 입력해주세요.");
				break;
			}
		}
	}

	private static void insertGuestBook() {

		System.out.println("\n[1. 방명록 작성]");
		System.out.print("글쓴이 이름 입력 >> ");
		String writer = scan.nextLine();

		System.out.print("제목 입력 >> ");
		String title = scan.nextLine();

		System.out.print("내용 입력 >> ");
		String content = scan.nextLine();

		GuestBookDTO g = new GuestBookDTO(writer, title, content);

		int re = gdao.insertGuest(g);

		if (re == 1) {
			System.out.println("방명록 저장 성공!");
		} else {
			System.out.println("방명록 저장 실패.");
		}

	} // insert

	private static void selectGuestBookList() {

		System.out.println("\n[2. 방명록 목록 보기]");

		List<GuestBookDTO> glist = gdao.getGuestBookList();

		if (glist != null && !glist.isEmpty()) {
			System.out.println("========== 방명록 목록 ==========");
			System.out.println("번호 | 제목 | 글쓴이 | 내용 | 등록날짜");
			System.out.println("------------------------------------");

			for (GuestBookDTO g : glist) {
				System.out.printf("%d | %s | %s | %s | %s\n", g.getGno(), g.getGtitle(), g.getGname(), g.getGcont(),
						g.getGdate());
			}
			System.out.println("------------------------------------");
		} else {
			System.out.println("방명록이 존재하지 않음.");
		}

	} // select(read)

	private static void editGuestBook() {
		System.out.println("\n[3. 방명록 수정]");
		System.out.print("수정할 방명록 번호 입력 >> ");

		int gno = 0;

		try {
			gno = Integer.parseInt(scan.nextLine());
		} catch (NumberFormatException e) {
			System.out.println("숫자 불일치 or 존재하지 않음.");
			return;
		}

		GuestBookDTO find_no = gdao.getFindNo(gno);

		if (find_no == null) {

			System.out.println("방명록이 존재하지 않음.");
		} else {

			System.out.println("기존 제목 : " + find_no.getGtitle());
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
				System.out.println("\n방명록 수정 성공.");
			} else {
				System.out.println("\n방명록 수정 실패.");
			}
		}
	} // edit

	private static void deleteGuestBook() {
		System.out.println("\n[4. 방명록 삭제]");
		System.out.print("삭제할 방명록 번호 입력 >> ");

		int gno = 0;

		try {
			gno = Integer.parseInt(scan.nextLine());
		} catch (NumberFormatException e) {
			System.out.println("숫자 불일치 or 존재하지 않음.");
			return;
		}
		GuestBookDTO find_no = gdao.getFindNo(gno);

		if (find_no == null) {
			System.out.println("방명록이 존재하지 않음.");
		} else {
			int re = gdao.delGuest(gno);

			if (re == 1) {
				System.out.println("방명록 삭제 성공.");
			} else {
				System.out.println("방명록 삭제 실패.");
			}
		}
	} // delete
}
