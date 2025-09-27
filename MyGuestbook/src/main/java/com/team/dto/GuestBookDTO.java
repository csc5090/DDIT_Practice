package com.team.dto;

import lombok.Data;

@Data
public class GuestBookDTO {
	
	private int gno;
	private String gname;
	private String gtitle;
	private String gcont;
	private String gdate;
	
	public GuestBookDTO(String gname, String gtitle, String gcont) {
        this.gname = gname;
        this.gtitle = gtitle;
        this.gcont = gcont;
    }
	
	 public GuestBookDTO() {
	        
	    } //기본생성자

}

