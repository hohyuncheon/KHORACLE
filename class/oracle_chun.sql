--==========================
-- CHUN 계정
--==========================

--1. 춘 기술대학교의 학과 이름과 계열을 표시하시오. 단, 출력 헤더는 "학과 명", "계열" 으로 표시하도록 한다.
select department_name "학과 명",
         category 계열
from tb_department;

--2. 학과의 학과 정원을 다음과 같은 형태로 화면에 출력한다.
select department_name ||'의 정원은 ' ||capacity || '명 입니다' "학과별 정원"
from tb_department;

--3. "국어국문학과" 에 다니는 여학생 중 현재 휴학중인 여학생을 찾아달라는 요청이
--들어왔다. 누구인가? (국문학과의 '학과코드'는 학과 테이블(TB_DEPARTMENT)을 조회해서 찾아 내도록 하자)

select*
from tb_student
where  absence_yn = 'Y' and department_no = '001' and substr(student_ssn,8,1)='2'; 

--4. 도서관에서 대출 도서 장기 연체자 들을 찾아 이름을 게시하고자 한다. 그 대상자들의 학번이 다음과 같을 때 
--대상자들을 찾는 적절한 SQL 구문을 작성하시오.

select student_name
from tb_student
where student_no in ('A513079', 'A513090', 'A513091', 'A513110', 'A513119')
order by student_name desc;

--5. 입학정원이 20 명 이상 30 명 이하인 학과들의 학과 이름과 계열을 출력하시오.

select department_name,
        category
from tb_department
where capacity between 20 and 30;

--6. 춘 기술대학교는 총장을 제외하고 모든 교수들이 소속 학과를 가지고 있다. 그럼 춘기술대학교 총장의 이름을 알아낼 수 있는 SQL 문장을 작성하시오
.
select professor_name
from tb_professor
where department_no is null;

--7. 혹시 정산상의 착오로 학과가 지정되어 있지 않은 학생이 있는지 확인하고자 한다.
--어떠한 SQL 문장을 사용하면 될 것인지 작성하시오.

select*
from tb_student
where coach_professor_no is null;

--8. 수강신청을 하려고 한다. 선수과목 여부를 확인해야 하는데, 선수과목이 존재하는 과목들은 어떤 과목인지 과목번호를 조회해보시오.

select class_no
from tb_class
where preattending_class_no is not null;

--9. 춘 대학에는 어떤 계열(CATEGORY)들이 있는지 조회해보시오.

select distinct category
from tb_department
order by category asc;

--10. 02 학번 젂주 거주자들의 모임을 맊들려고 한다. 휴학한 사람들은 제외한 재학중인 학생들의 학번, 이름, 주민번호를 출력하는 구문을 작성하시오.

select student_no,
        student_name,
        student_ssn
from tb_student
where absence_yn = 'N'
         and substr(student_address, 1,2) = '전주'
         and extract(year from entrance_date) = 2002
order by student_name asc;

--------------------------------------------
--2번째실습


--1. 학과테이블에서 계열별 정원의 평균을 조회(정원 내림차순 정렬)



select category 계열,
        count(*)정원,
        trunc(avg(capacity)) 평균
from tb_department
group by category
order by 3 desc;



--2. 휴학생을 제외하고, 학과별로 학생수를 조회(학과별 인원수 내림차순)

select department_no,
         count(*)
from tb_Student
where absence_yn in ('N')
group by department_no
order by 2 desc;



--3. 과목별 지정된 교수가 2명이상인 과목번호와 교수인원수를 조회

select*
from tb_class_professor;

select class_no "과목 번호",
        count(*) "교육인원수"
from tb_class_professor
group by class_no
having count(*)>=2;

--4. 학과별로 과목을 구분했을때, 과목구분이 "전공선택"에 한하여 
--과목수가 10개 이상인 행의 학과번호, 과목구분(class_type), 과목수를 조회(전공선택만 조회)

select *
from tb_class;

select distinct class_type
from tb_class;

--where절을 having에 써도 무관함.
select department_no 학과번호,
        class_type 과목구분,
        count(*) 과목수
from tb_class
where class_type = '전공선택'
group by department_no, class_type
having count(department_no) >=10
order by 3;


--1. 영어영문학과(학과코드 002) 학생들의 학번과 이름, 입학 년도를 입학 년도가 빠른 순으로 표시하는
--SQL 문장을 작성하시오.( 단, 헤더는 "학번", "이름", "입학년도" 가표시되도록 한다.)


select*
from tb_department
where department_no = 002;

select student_no 학번,
         student_name 이름 ,
        entrance_date 입학년도
from tb_student
where department_no = 002
order by entrance_date asc;

--교수님답
SELECT STUDENT_NO AS 학번,
       STUDENT_NAME AS 이름,
          TO_CHAR(ENTRANCE_DATE, 'RRRR-MM-DD') AS 입학년도
FROM   TB_STUDENT
WHERE  DEPARTMENT_NO='002'
ORDER BY ENTRANCE_DATE;

--2. 춘 기술대학교의 교수 중 이름이 세 글자가 아닌 교수가 한 명 있다고 한다. 그 교수의
--이름과 주민번호를 화면에 출력하는 SQL 문장을 작성해 보자. (* 이때 올바르게 작성한
--SQL 문장의 결과 값이 예상과 다르게 나올 수 있다. 원인이 무엇일지 생각해볼 것)

select *
from tb_professor;

select PROFESSOR_NAME,
        PROFESSOR_SSN
from tb_professor
where length(Professor_Name) !=3;

--교수님답
SELECT PROFESSOR_NAME , 
       PROFESSOR_SSN
FROM   TB_PROFESSOR
WHERE  PROFESSOR_NAME NOT LIKE '___';

--3. 춘 기술대학교의 남자 교수들의 이름과 나이를 출력하는 SQL 문장을 작성하시오. 단
--이때 나이가 적은 사람에서 맋은 사람 순서로 화면에 출력되도록 맊드시오. (단, 교수 중
--2000 년 이후 출생자는 없으며 출력 헤더는 "교수이름", "나이"로 한다. 나이는 ‘만’으로 계산한다.)

select PROFESSOR_NAME 교수이름,
         extract(year from sysdate)-((substr(PROFESSOR_SSN,1,2))+1901) 나이   
from tb_professor
where substr(PROFESSOR_SSN,8,1) =1
order by 2 desc;


--교수님답
SELECT PROFESSOR_NAME AS 교수이름,
       TO_NUMBER(TO_CHAR(SYSDATE, 'YYYY')) - TO_NUMBER('19' || SUBSTR(PROFESSOR_SSN, 1, 2)) AS 나이,
       TRUNC(
        MONTHS_BETWEEN(
            SYSDATE,  
            TO_DATE('19' ||SUBSTR(PROFESSOR_SSN, 1, 6),'RRRRMMDD'))/12
       ) 만나이
FROM   TB_PROFESSOR
WHERE  SUBSTR(PROFESSOR_SSN, 8, 1) = '1'
ORDER BY 2, 1;


--4. 교수들의 이름 중 성을 제외한 이름만 출력하는 SQL 문장을 작성하시오. 출력 헤더는
--‚이름만 이 찍히도록 한다. (성이 2 자인 경우는 교수는 없다고 가정하시오)


select  substr(PROFESSOR_NAME, 2,2) 교수이름
from tb_professor
where length(PROFESSOR_NAME) = 3;



--5. 춘 기술대학교의 재수생 입학자를 구하려고 한다. 어떻게 찾아낼 것인가? 이때, 19 살에 입학하면
--재수를 하지 않은 것으로 간주한다.

select *
from tb_student
where extract(year from ENTRANCE_DATE)-(substr(student_ssn,1,2)+1900) !=19
order by 3 asc;

SELECT  STUDENT_NO,
        STUDENT_NAME
FROM    TB_STUDENT
WHERE   TO_NUMBER(TO_CHAR(ENTRANCE_DATE, 'YYYY'))  - TO_NUMBER(TO_CHAR(TO_DATE(SUBSTR(STUDENT_SSN, 1, 2), 'RR'), 'YYYY')) > 19
ORDER BY 1;


--6. 2020 년 크리스마스는 무슨 요일인가?

select to_char(to_date('2020/12/25'),'day')
from dual;


--7. TO_DATE('99/10/11','YY/MM/DD'), TO_DATE('49/10/11','YY/MM/DD') 은 각각 몇 년 몇월 몇 일을 의미할까?
--또 TO_DATE('99/10/11','RR/MM/DD'), TO_DATE('49/10/11','RR/MM/DD') 은 각각 몇 년 몇 월 몇 일을 의미할까?
yy 현재 세기
rr50년~다음 세기 50년
2099 2049
1999 2049



--8. 춘 기술대학교의 2000 년도 이후 입학자들은 학번이 A 로 시작하게 되어있다. 2000 년도
--이전 학번을 받은 학생들의 학번과 이름을 보여주는 SQL 문장을 작성하시오.
select *
from Tb_student;
--오답
select STUDENT_NAME 이름,
         DEPARTMENT_NO 학번
from Tb_student
where extract(year from ENTRANCE_DATE) <= 2000
order by 2 asc;

SELECT STUDENT_NO,
       STUDENT_NAME
FROM   TB_STUDENT
WHERE  SUBSTR(STUDENT_NO, 1, 1) <> 'A'
ORDER BY 1;


--9. 학번이 A517178 인 한아름 학생의 학점 총 평점을 구하는 SQL 문을 작성하시오. 단,
--이때 출력 화면의 헤더는 "평점" 이라고 찍히게 하고, 점수는 반올림하여 소수점 이하 한자리까만 표시한다.

select *
from Tb_student;

select *
from Tb_grade;


--어렵게 한거
select student_name,
        round(avg(point),1) 평점
from Tb_student s join tb_grade g
on s.Student_no = g.student_no
where s.STUDENT_NO = 'A517178'
group by student_name;

--쉽게 한거

select round(avg(point),1) 평점
from tb_grade
where STUDENT_NO = 'A517178';

--10. 학과별 학생수를 구하여 "학과번호", "학생수(명)" 의 형태로 헤더를 만들어 결과값이 출력되도록 하시오.

select DEPARTMENT_NO 학과번호,
        count(*) "학생수(명)"
from tb_student
group by DEPARTMENT_NO;

--11. 지도 교수를 배정받지 못한 학생의 수는 몇 명 정도 되는 알아내는 SQL 문을 작성하시오.

select count(student_name) "배정못받은 학생"
from tb_student
where COACH_PROFESSOR_NO is null;


--12. 학번이 A112113 인 김고운 학생의 년도 별 평점을 구하는 SQL 문을 작성하시오. 단,
--이때 출력 화면의 헤더는 "년도", "년도 별 평점" 이라고 찍히게 하고, 점수는 반올림하여 소수점 이하 한 자리까지맊 표시한다.
select TERM_NO 년도,
        avg(point) "년도별 평점"
from tb_grade
where student_no ='A112113'
group by TERM_NO
order by 1 asc;

select *
from tb_grade;

--13. 학과 별 휴학생 수를 파악하고자 한다. 학과 번호와 휴학생 수를 표시하는 SQL 문장을 작성하시오.

select *
from tb_student;

--학생수가 없으면 표시안되는 코드.
select DEPARTMENT_NO,
count(student_name)
from tb_student
where absence_yn = 'Y'
group by DEPARTMENT_NO
order by 1;

--002학과코드까지 표시되는 코드

select DEPARTMENT_NO 학과, 
        sum(decode(absence_yn,'Y','1','N','0')) 학생수
from tb_student
group by department_no
order by 1;

--14. 춘 대학교에 다니는 동명이인(同名異人) 학생들의 이름을 찾고자 한다. 어떤 SQL 문장을 사용하면 가능하겠는가?

select Student_name "이름",
        count(*) "동명이인 수"
from tb_student
group by Student_name
having count(*) > 1;


--15. 학번이 A112113 인 김고운 학생의 년도, 학기 별 평점과 년도 별 누적 평점 ,총평점 을 구하는 SQL 문을 작성하시오. (단, 평점은 소수점 1 자리까지맊 반올림하여
--표시한다.)
select*
from tb_grade;

select decode(grouping(substr(TERM_NO,1,4)),0, substr(TERM_NO,1,4), '　') 년도,
         decode(grouping(substr(TERM_NO,5,2)),0, substr(TERM_NO,5,2), '　') 학기,
         round(avg(point),1) 평점
from tb_grade
where STUDENT_NO = 'A112113'
group by rollup(substr(TERM_NO,1,4), 
             substr(TERM_NO,5,2))
order by 1,2;   



--교수님답
--grouping : 실제 데이터 0, 집계데이터 1
select decode(grouping(substr(term_no, 1, 4)), 0, substr(term_no, 1, 4), ' ') 년도,
       decode(grouping(substr(term_no, 5, 2)), 0, substr(term_no, 5, 2), ' ') 학기,
       round(avg(point), 1) 평점
from tb_grade
where  student_no = 'A112113'
group by rollup(substr(term_no, 1, 4), substr(term_no, 5, 2));
​
--DECODE이용
SELECT DECODE(GROUPING(SUBSTR(TERM_NO, 1, 4)),0,SUBSTR(TERM_NO, 1, 4),1,'총평점') AS 년도,
        DECODE(GROUPING(SUBSTR(TERM_NO, 5, 2)),0,SUBSTR(TERM_NO, 5, 2),1,'연별누적평점') AS 학기,
        ROUND(AVG(POINT), 1) AS 평점
FROM   TB_GRADE
WHERE  STUDENT_NO = 'A112113'
GROUP BY ROLLUP(SUBSTR(TERM_NO, 1, 4),SUBSTR(TERM_NO, 5, 2));
​
--CASE이용
SELECT DECODE(GROUPING(SUBSTR(TERM_NO, 1, 4)),0,SUBSTR(TERM_NO, 1, 4),1,'총평점') AS 년도,
        CASE WHEN GROUPING(SUBSTR(TERM_NO, 1, 4)) = 1 AND GROUPING(SUBSTR(TERM_NO, 5, 2))=1 THEN ' '
              WHEN GROUPING(SUBSTR(TERM_NO, 5, 2)) = 1 THEN '연별누적평점'
              ELSE SUBSTR(TERM_NO, 5, 2) END AS 구분,
        ROUND(AVG(POINT), 1) AS 평점
FROM   TB_GRADE
WHERE  STUDENT_NO = 'A112113'
GROUP BY ROLLUP(SUBSTR(TERM_NO, 1, 4),SUBSTR(TERM_NO, 5, 2));


select *
from tb_student;

select *
from tb_professor;



select student_name,
        s.coach_professor_no
from tb_student s right join tb_professor p
on s.COACH_PROFESSOR_NO = p.PROFESSOR_NO;





--학번/학생명/담당교수명 조회
--1. 두테이블의 기준컬럼 파악
--2. on조건절에 해당되지 않는 데이터파악


select * from tb_student; -- coach_professor_no 
select * from tb_professor; -- professor_no

--담당교수, 담당학생이 배정되지 않은 학생이나 교수 제외 inner 579
--담당교수가 배정되지 않은 학생 포함 left 588 = 579 + 9
--담당학생이 없는 교수 포함 right 580 = 579 + 1

select count(*)
from tb_student S right join tb_professor P
    on S.coach_professor_no = P.professor_no;

--1. 교수배정을 받지 않은 학생 조회 -- 9
select count(*)
from tb_student
where coach_professor_no is null;

--2. 담당학생이 한명도 없는 교수 조회 --1
--전체 교수 수
select count(*) --114
from tb_professor;

--중복 없는 담당교수 수
select count(distinct coach_professor_no) --113
from tb_student;

----------------------------------------------------------------------------
--3번째실습

--1. 학번, 학생명, 학과명 조회
-- 학과 지정이 안된 학생은 존재하지 않는다.

select * from tb_department;
select * from tb_student;
select * from tb_class;

select student_no 학번,
         student_name,
         c.class_name 학과명
         
from tb_student s inner join tb_class c
on s.department_no = c.department_no
order by 2;

select s.student_no,
           s.student_name,
           d.department_name
from tb_student s join tb_department d on s.department_no = d.department_no;



--2. 수업번호, 수업명, 교수번호, 교수명 조회
select * from tb_class;
select * from tb_class_professor;


select *
from tb_class t join tb_professor p
on t.department_no = p.department_no;

select class_no 수업번호,
    class_name 수업명,
    PROFESSOR_NO 교수번호,
    PROFESSOR_NAME 교수명
from tb_class t join tb_professor p
on t.department_no = p.department_no;

--3. 송박선 학생의 모든 학기 과목별 점수를 조회(학기, 학번, 학생명, 수업명, 점수)
select *
from tb_student;
select *
from tb_grade;
select *
from tb_class;

select  
        g.TERM_NO 학기,
        s.student_no 학번,
        s.student_name 학생명,
        c.class_name 수업명,
        g.point 점수
from tb_student s join tb_class c
on s.department_no=c.department_no
join tb_grade g
on c.CLASS_NO = g.CLASS_NO
where s.student_name = '송박선'
order by 1,4,5;

--강사님답
select G.term_no,
            student_no,
            S.student_name,
            C.class_name,
            G.point
from tb_grade G
    join tb_student S
        using(student_no)
    join tb_class C
        using(class_no)
where S.student_name = '송박선';

--4. 학생별 전체 평점(소수점이하 첫째자리 버림) 조회 (학번, 학생명, 평점)
--같은 학생이 여러학기에 걸쳐 같은 과목을 이수한 데이터 있으나, 전체 평점으로 계산함.

select *
from tb_student;
select *
from tb_class; 
select *
from tb_grade;


select s.student_no,
        s.student_name,
        g.point
from tb_student s join tb_grade G
on tb_grade g
on c.CLASS_NO = g.CLASS_NO;

--강사님답
select student_no, 
            student_name,
            trunc(avg(point), 1) avg
from tb_grade G
    join tb_student S
        using(student_no)
group by student_no, student_name;


--5. 교수번호, 교수명, 담당학생명수 조회
-- 단, 5명 이상을 


select P.professor_no,
            P.professor_name,
            count(*) cnt
from tb_student S
    join tb_professor P
        on S.coach_professor_no = P.professor_no
group by P.professor_no, P.professor_name
having count(*) >= 5
order by cnt desc;


