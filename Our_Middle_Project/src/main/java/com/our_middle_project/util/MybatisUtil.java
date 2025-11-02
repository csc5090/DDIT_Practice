package com.our_middle_project.util;

import java.io.IOException;
import java.io.InputStream;

import org.apache.ibatis.io.Resources;
import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.apache.ibatis.session.SqlSessionFactoryBuilder;

public class MybatisUtil {

	private static SqlSessionFactory sqlSessionFactory;

	static {
		String resource = "mybatis-config.xml";
		try {
			InputStream inputStream = Resources.getResourceAsStream(resource);
			
			if (inputStream == null) {
	            throw new IOException("MyBatis 설정 파일 '" + resource + "'을 찾을 수 없습니다. src/main/resources 폴더를 확인하세요.");
	        }

			sqlSessionFactory = new SqlSessionFactoryBuilder().build(inputStream);
		} catch (Exception e) {
			e.printStackTrace();
		}

	}

	public static SqlSession getSqlSession() {
		return sqlSessionFactory.openSession(true); // true: auto-commit
	}

}
