package com.our_middle_project.util;

import java.util.Properties;

import jakarta.mail.Message;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;

public class SendMail {

	public static void sendMail(String to, String subject, String content) {

        final String fromEmail = "shworkemail093@gmail.com"; // 보내는 사람 이메일
        final String password = "andzlsnfgswekepu"; // 구글 앱 비밀번호 (계정 비밀번호 아님)

        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");

        Session session = Session.getInstance(props, new jakarta.mail.Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(fromEmail, password);
            }
        });

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(fromEmail, "Twin Cards Game"));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to));
            message.setSubject(subject);
            message.setText(content);

            Transport.send(message);
            System.out.println("메일 발송 성공!");

        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("메일 발송 실패...");
        }
    }
	
}
