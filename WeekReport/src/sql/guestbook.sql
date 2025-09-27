CREATE TABLE tbl_guestbook (
gno NUMBER(38) PRIMARY KEY
, gname VARCHAR2(50) NOT NULL
, gtitle VARCHAR2(200) NOT NULL
, gcont VARCHAR2(4000) NOT NULL
, gdate DATE NULL
);

COMMIT

SELECT * FROM TBL_GUESTBOOK

create sequence gno_seq
start with 1
increment by 1
nocache
nocycle;
