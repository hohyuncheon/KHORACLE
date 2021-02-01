--@실습문제 : INNER JOIN & OUTER JOIN
--CHUN문제 서브쿼리로 풀어보기.

--1. 학번, 학생명, 학과명을 출력

select s.Student_no,
        s.student_name,
        c.class_name
from tb_student s join  (
                                select department_no,
                                        CLASS_NAME
                                 from tb_class
                                  )c
using (department_no);

--2. 학번, 학생명, 담당교수명을 출력하세요.
--담당교수가 없는 학생은 '없음'으로 표시

select * from tb_student;
select * from tb_class;
select * from tb_professor;

select t.STUDENT_NO 학번,
        t.STUDENT_NAME 학생명,
        nvl(g.PROFESSOR_NAME,'없음') 교수이름
        
from tb_student t left join (select department_no,
                                        professor_name
                                  from tb_professor
                                  ) g
using(department_no);

--3. 학과별 교수명과 인원수를 모두 표시하세요.

select d.department_name,
        nvl(p.PROFESSOR_NAME,'총'||count(*)||'명')
from tb_department d join (select DEPARTMENT_NO,
                                            PROFESSOR_NAME
                                            from tb_professor) p
using(department_no)
group by rollup(d.department_name, p.professor_name)
order by 1;




-- 4. 이름이 [~람]인 학생의 평균학점을 구해서 학생명과 평균학점(반올림해서 소수점둘째자리까지)과 같이 출력.
-- (동명이인일 경우에 대비해서 student_name만으로 group by 할 수 없다.)

select s.STUDENT_NAME,
         평균
from tb_student s join( select student_no,
                                    round(avg(point),2) 평균
                                from tb_grade
                                group by Student_no) g
using (student_no)
where s.student_name like '%람'
group by s.STUDENT_NAME, 평균;




select *
from tb_student;

--5. 학생별 다음정보를 구하라.
/*
--------------------------------------------
학생명  학기     과목명    학점

--------------------------------------------
감현제	200401	전기생리학 	4.5
            .
            .
--------------------------------------------

*/
--값이 많이나옴
select s.student_name,
        학기,
        과목명,
        점수  
from tb_student s join (select c.class_name 과목명,
                                department_no,
                                g.point 점수,
                                g.term_no 학기
                                from tb_class c join (select class_no,
                                                             point,
                                                             TERM_NO
                                                             from tb_grade) g
                                using (class_no)) c
using (department_no)
order by 1,2;

--join 답5000개결과정도.
select student_name, term_no, class_name, point
from tb_student s 
    join tb_grade using(student_no)
    join tb_class using(class_no)
order by 1;