package com.our_middle_project.dto;

import lombok.Data;

@Data
public class RankingDTO {
	
    private int memNo;         // MEM_NO
    private int levelNo;       // LEVEL_NO (1:EAZY, 2:NORMAL, 3:HARD)
    private int scoreBest;     // SCORE_BEST
    private int scoreTotal;    // SCORE_TOTAL
    private int scoreCount;    // SCORE_COUNT
    private double scoreAvg;   // SCORE_AVG
    private int scoreLast;     // SCORE_LAST
    private String playedLastDate; // PLAYED_LAST_DATE

    // MEMBER 테이블 정보
    private String memId;      // MEM_ID
    private String nickname;   // NICKNAME
}
