package com.our_middle_project.dto;

import java.sql.Date;

import lombok.Data;

@Data
public class RankingDTO {
	
	  	private int memNo;
	    private String nickname;
	    private String memId;
	    private int levelNo;
	    private int scoreBest;
	    private int scoreTotal;
	    private int scoreCount;
	    private int scoreAvg;
	    private int scoreLast;
	    private Date playedLastDate;
	    private int combo;
	    private int clearTime;
}

