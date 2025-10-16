package com.our_middle_project.action;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class ActionForward {
	
	private String path; //이동할 View 페이지의 경로
	
	private boolean isRedirect; //이동방식 : true라면 redirect로, false라면 forward로
	

}
