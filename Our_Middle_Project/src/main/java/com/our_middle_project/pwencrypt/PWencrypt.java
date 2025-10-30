package com.our_middle_project.pwencrypt;

import java.security.MessageDigest;
import java.security.SecureRandom;
import java.util.Base64;

public class PWencrypt {

    // 랜덤 Salt 생성
    public static String generateSalt() {
        SecureRandom random = new SecureRandom();
        byte[] salt = new byte[16]; // 16바이트 = 128비트
        random.nextBytes(salt);
        return Base64.getEncoder().encodeToString(salt); // 문자열로 변환
    }

    // SHA-256 + Salt 암호화
    public static String hashPassword(String password, String salt) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");

            // salt + password 합치기
            String saltedPassword = salt + password;

            byte[] hashedBytes = md.digest(saltedPassword.getBytes("UTF-8"));

            // 16진수 문자열로 변환
            StringBuilder sb = new StringBuilder();
            for (byte b : hashedBytes) {
                sb.append(String.format("%02x", b));
            }
            return sb.toString();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

}