package com.our_middle_project.dto;

import java.sql.Date;

import lombok.Data;

@Data
public class RankingDTO {

	    private int level_no;
	    private int score_best;
	    private int score_total;
	    private int score_count;
	    private int score_avg;
	    private int score_last;
	    private String played_last_date;
	    
	    //gameLog
	    private int combo;
	    private int clear_time;
	    
	    //member
	    private String nickname;
	    private String mem_id;
}

