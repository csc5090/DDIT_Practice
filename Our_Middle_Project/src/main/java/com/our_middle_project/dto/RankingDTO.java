package com.our_middle_project.dto;

import lombok.Data;

@Data
public class RankingDTO {

		private int mem_no;
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
	    
	    private int rank;  // 몇 등
	    
	    //member
	    private String nickname;
	    private String mem_id;
}

