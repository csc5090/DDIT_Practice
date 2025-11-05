package com.our_middle_project.serviceInterface;

import java.util.List;

import com.our_middle_project.dto.FileImageDTO;
import com.our_middle_project.dto.ReviewDTO;

public interface ReviewService {
	int writeOnly(ReviewDTO dto, List<FileImageDTO> images, Integer starOrNull);
	
}