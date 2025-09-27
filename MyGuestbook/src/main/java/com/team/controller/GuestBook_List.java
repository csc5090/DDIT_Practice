package com.team.controller;

import java.util.List;

import net.daum.dao.GuestBookDAOImpl;
import net.daum.dto.GuestBookDTO;

public class GuestBook_List {

	public static void main(String[] args) {
		
		GuestBookDAOImpl gdao = new GuestBookDAOImpl();
		List<GuestBookDTO> glist = gdao.getGuestBookList();
		
		if(glist != null && !glist.isEmpty()) {
			System.out.println("============ 방명록 목록 =============");
			System.out.println("번호 | 제목 | 글쓴이 | 내용 | 등록날짜");
			System.out.println("------------------------------------");
			for(GuestBookDTO g : glist) {
				System.out.printf("%d | %s | %s | %s | %s\n", g.getGno(), g.getGtitle(), g.getGname(), g.getGcont(), g.getGdate());
			}
			System.out.println("------------------------------------");
		} else {
			System.out.println("방명록이 존재하지 않음.");
		}

	}

}
