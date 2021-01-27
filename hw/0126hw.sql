
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

--2. 춘 기술대학교의 교수 중 이름이 세 글자가 아닌 교수가 한 명 있다고 한다. 그 교수의
--이름과 주민번호를 화면에 출력하는 SQL 문장을 작성해 보자. (* 이때 올바르게 작성한
--SQL 문장의 결과 값이 예상과 다르게 나올 수 있다. 원인이 무엇일지 생각해볼 것)

select *
from tb_professor;

select PROFESSOR_NAME,
        PROFESSOR_SSN
from tb_professor
where length(Professor_Name) !=3;


--3. 춘 기술대학교의 남자 교수들의 이름과 나이를 출력하는 SQL 문장을 작성하시오. 단
--이때 나이가 적은 사람에서 맋은 사람 순서로 화면에 출력되도록 맊드시오. (단, 교수 중
--2000 년 이후 출생자는 없으며 출력 헤더는 "교수이름", "나이"로 한다. 나이는 ‘만’으로 계산한다.)
desc tb_professor;


만나이로 바꿔야함.
select PROFESSOR_NAME 교수이름,
         extract(year from sysdate)-((substr(PROFESSOR_SSN,1,2))+1901) 나이
         
         --만나이
         
from tb_professor
where substr(PROFESSOR_SSN,8,1) =1
order by 2 desc;


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

select STUDENT_NAME 이름,
         DEPARTMENT_NO 학번
from Tb_student
where extract(year from ENTRANCE_DATE) <= 2000
order by 2 asc;


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
