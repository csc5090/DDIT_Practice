/*
SYS 계정의 워크시트에서 중간프로젝트용 계정을 생성한다.
계정명은 (임시)MP101으로 한다. 
*/
CREATE USER C##MP101 IDENTIFIED BY card;
GRANT CONNECT, RESOURCE, DBA TO C##MP101;

/*
*새 접속
*NAME: MP101
*사용자 이름: C##MP101
*비밀번호: card (비밀번호 저장 체크박스: 체크)
*롤: 기본값
*/