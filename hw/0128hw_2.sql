--@실습문제 : INNER JOIN & OUTER JOIN


--1. 학번, 학생명, 학과명을 출력
select student_no 학번,
         student_name 학생명,
        class_name 학과명
from tb_student s join tb_class c
on s.department_no = c.department_no;


select *
from tb_class;

--2. 학번, 학생명, 담당교수명을 출력하세요.
--담당교수가 없는 학생은 '없음'으로 표시


select s.student_no 학번 ,
    s.student_name 학생명 ,
    nvl(p.professor_name,'없음') 담당교수명
from tb_student s left join tb_professor p
on s.department_no = p.department_no;

select *
from tb_department ;

select *
from tb_professor;
--3. 학과별 교수명과 인원수를 모두 표시하세요.

select d.department_name 학 , 
         nvl(p.professor_name,' 총'||count(*)||'명') 인원
from tb_department d join tb_professor p
using(department_no)
group by rollup(d.department_name, p.professor_name)
order by 1;


select 
        d.department_name 학과명,
       nvl2(p.professor_name,p.professor_name,count(*)) 교수명
from tb_department d 
            join tb_professor p 
            on d.department_no = p.department_no
group by rollup(d.department_name, p.professor_name)
order by 1;


-- 4. 이름이 [~람]인 학생의 평균학점을 구해서 학생명과 평균학점(반올림해서 소수점둘째자리까지)과 같이 출력.
-- (동명이인일 경우에 대비해서 student_name만으로 group by 할 수 없다.)

select s.student_name,
         s.student_no,
         round(avg(g.point),2)
from tb_student s join tb_grade g
on s.student_no = g.student_no
where student_name like '%람'
group by s.student_name, s.student_no;


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
select s.student_name,
g.term_no,
c.class_name,
trunc(avg(point),1) 학점
from  tb_grade G join tb_student S
        on G.student_no = S.student_no
        join tb_class C
        on G.class_no = C.class_no
group by s.student_name, g.term_no, c.class_name
order by 1,2;
