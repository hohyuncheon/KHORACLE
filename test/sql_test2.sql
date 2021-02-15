
--1. 각 부서별 최고 급여를 받는 사원을 조회하려고 아래와 같이 SQL구문을 작성하였다.
--출력을 해보니 부서를 배정받고 있지않은 사원은 빠져있는 것을 확인하였다.
--부서가 없는 사원을 찾기위해서 사용할 함수를 [원인](10점)에 기술하고, 해결방법을 적용한
--SQL구문을 [조치내용](30점)에 기술하시오.(40점)

SELECT *
FROM EMPLOYEE;

SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE (DEPT_CODE, SALARY) IN (SELECT DEPT_CODE, MAX(SALARY)
                                                FROM EMPLOYEE
                                                GROUP BY DEPT_CODE)
ORDER BY DEPT_CODE;

SELECT EMP_ID, EMP_NAME, NVL(DEPT_CODE,'부서없음') DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE (NVL(DEPT_CODE,'부서없음'), SALARY) IN (SELECT NVL(DEPT_CODE,'부서없음'), MAX(SALARY)
                                                FROM EMPLOYEE
                                                GROUP BY DEPT_CODE)
ORDER BY DEPT_CODE;

-----------------
--아래의 내용에 따라 사용자에게 권한을 부여하는 명령구문을 [원인](20점)에 기술하고, 아래의 공지사항을 저장할 NOTICE 테이블의 스키마를 참조하여 최근에 등록된 공지글 5개를 조회하는 TOP-N 분석 구문을 RANK() 함수와 ROWNUM을 각각 사용하여 2개의 SELECT 구문을 [조치내용](40점)에 작성하시오. (60점)
--[원인]
--- 사용자에 부여할 권한 : CONNECT,RESOURCE
--- 권한을 부여받을 사용자 : MYMY
--[조치내용]
--1. RANK() 함수를 사용한 TOP-N 분석 구문 작성
--2. ROWNUM 사용한 TOP-N 분석 구문 작성
--- 최근 등록된 공지글 5개 조회
--- 모든 컬럼 조회함
--* NOTICE 테이블 스키마


 CREATE TABLE NOTICE(
       NOTICENO NUMBER NOT NULL,
       NOTICETITLE VARCHAR2(50) NOT NULL,
       NOTICEDATE DATE DEFAULT SYSDATE,
       NOTICEWRITER VARCHAR2(15) NOT NULL,
       NOTICECONTENT VARCHAR2(2000),
       ORIGINAL_FILEPATH VARCHAR2(100),
       RENAME_FILEPATH VARCHAR2(100)
);

--컬럼 주석달기
comment on column NOTICE.NOTICENO is '공지글번호';
comment on column NOTICE.NOTICETITLE is '공지글제목';
comment on column NOTICE.NOTICEDATE is '공지글등록날짜';
comment on column NOTICE.NOTICEWRITER is '공지글작성자아이디';
comment on column NOTICE.NOTICECONTENT is '공지글내용';
comment on column NOTICE.ORIGINAL_FILEPATH is '첨부파일명';
comment on column NOTICE.RENAME_FILEPATH is '변경된첨부파일명';



DROP TABLE NOTICE;
SELECT * FROM NOTICE;
DESC NOTICE;
select * from user_col_comments where table_name = 'NOTICE'; --코멘트 보는법

--임의의 값 넣기

INSERT INTO NOTICE VALUES(1,'제목1',DEFAULT,'abcd','내용1','파일명1','변경된첨부파일명');
INSERT INTO NOTICE VALUES(2,'제목2',DEFAULT,'abcd','내용2','파일명2','변경된첨부파일명');
INSERT INTO NOTICE VALUES(3,'제목3',DEFAULT,'abcd','내용3','파일명3','변경된첨부파일명');
INSERT INTO NOTICE VALUES(4,'제목4',DEFAULT,'abcd','내용4','파일명4','변경된첨부파일명');
INSERT INTO NOTICE VALUES(5,'제목5',DEFAULT,'abcd','내용5','파일명5','변경된첨부파일명');
INSERT INTO NOTICE VALUES(6,'제목6',DEFAULT,'abcd','내용6','파일명6','변경된첨부파일명');


select *
from notice
order by noticedate;

select NOTICENO,
        NOTICETITLE,
        to_char(NOTICEDATE, 'yyyy/mm/dd hh24:mi:ss'),
        NOTICEWRITER,
        NOTICECONTENT,
        ORIGINAL_FILEPATH,
        RENAME_FILEPATH
from NOTICE
order by NOTICEDATE;

--RANK함수를 사용한 TOP-N 분석 구문 작성

select NOTICENO,
        NOTICETITLE,
        to_char(NOTICEDATE, 'yyyy/mm/dd hh24:mi:ss'),
        NOTICEWRITER,
        NOTICECONTENT,
        ORIGINAL_FILEPATH,
        RENAME_FILEPATH,
        RANK () OVER (ORDER BY to_char(NOTICEDATE, 'yyyy/mm/dd hh24:mi:ss')) RANK
from NOTICE
order by NOTICEDATE;

--ROWNUM 사용한 TOP-N분석 작성
--최근 등록된 공지글 5개 조회


--1단계
select NOTICENO,
        NOTICETITLE,
        to_char(NOTICEDATE, 'yyyy/mm/dd hh24:mi:ss'),
        NOTICEWRITER,
        NOTICECONTENT,
        ORIGINAL_FILEPATH,
        RENAME_FILEPATH,
        ROWNUM
from NOTICE
order by NOTICEDATE DESC; --최근부터 조회


--2단계

SELECT ROWNUM,
          NOTICENO,
          NOTICETITLE,
          NOTICEDATE,
          NOTICEWRITER,
          NOTICECONTENT,
          ORIGINAL_FILEPATH,
          RENAME_FILEPATH
FROM (select NOTICENO,
            NOTICETITLE ,
            to_char(NOTICEDATE, 'yyyy/mm/dd hh24:mi:ss') NOTICEDATE,
            NOTICEWRITER,
            NOTICECONTENT,
            ORIGINAL_FILEPATH,
            RENAME_FILEPATH
            from NOTICE
            order by NOTICEDATE DESC)
WHERE ROWNUM  between 1 and 5;
