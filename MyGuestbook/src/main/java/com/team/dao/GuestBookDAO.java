package com.team.dao;

import java.io.IOException;
import java.io.InputStream;
import java.util.List;

import org.apache.ibatis.io.Resources;
import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.apache.ibatis.session.SqlSessionFactoryBuilder;

import com.team.dto.GuestBookDTO;

public class GuestBookDAO {
    private static SqlSessionFactory sqlSessionFactory;
asdds
    static {
        try {
            String resource = "mybatis-config.xml";
            InputStream inputStream = Resources.getResourceAsStream(resource);
            sqlSessionFactory = new SqlSessionFactoryBuilder().build(inputStream);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    public List<GuestBookDTO> getGuestBookList() {
        
        SqlSession session = sqlSessionFactory.openSession();
        List<GuestBookDTO> list = null;
        try {
            list = session.selectList("com.team.dao.GuestBookDAO.getGuestBookList");
        } finally {
            session.close();
        }
        return list;
    }

    public void addGuestBook(GuestBookDTO dto) {
        SqlSession session = sqlSessionFactory.openSession();
        try {
            session.insert("com.team.dao.GuestBookDAO.addGuestBook", dto);
            session.commit();
        } finally {
            session.close();
        }
    }
    
    public void deleteGuestBook(int no) {
    	try (SqlSession session = sqlSessionFactory.openSession(true)){
    		session.delete("com.team.dao.GuestBookDAO.deleteGuestBook", no);
    	}
    }
    
    public GuestBookDTO getGuestBook(int no) {
        try (SqlSession session = sqlSessionFactory.openSession()) {
            return session.selectOne("com.team.dao.GuestBookDAO.getGuestBook", no);
        }
    }

    public void updateGuestBook(GuestBookDTO dto) {
        try (SqlSession session = sqlSessionFactory.openSession(true)) {
            session.update("com.team.dao.GuestBookDAO.updateGuestBook", dto);
        }
    }
    
}