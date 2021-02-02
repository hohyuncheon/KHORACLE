--<DQL종합실습문제>KH

--@ 실습 문제

select * from employee;


--문제1
--기술지원부에 속한 사람들의 사람의 이름,부서코드,급여를 출력하시오

--join
select emp_name,
         dept_code,
         salary
from employee e join department d
on e.dept_code = d.dept_id
where d.dept_title = '기술지원부';

--서브쿼리
select emp_name,
         dept_code,
         salary
from employee
where dept_code = (select dept_id
                                from department d
                                where dept_title = '기술지원부' 
                                );

--문제2
--기술지원부에 속한 사람들 중 가장 연봉이 높은 사람의 이름,부서코드,급여를 출력하시오
select *
from(
        select emp_name,
                 dept_code,
                 salary
        from employee
        where dept_code = (select dept_id
                                        from department d
                                        where dept_title = '기술지원부' 
                                        )
        order by 3 desc
        )
where rownum = 1;
            

--문제3
--매니저가 있는 사원중에 월급이 전체사원 평균을 넘고 
--사번,이름,매니저 이름, 월급을 구하시오. 
--	1. JOIN을 이용하시오
--	2. JOIN하지 않고, 스칼라상관쿼리(SELECT)를 이용하기

select emp_id 사번,
         emp_name 이름,
         (select emp_name
         from employee 
         where emp_id = E.manager_id) 매니저이름,
        salary 급여
from employee e
where salary > (select avg(salary)
                     from employee
                     ) 
and manager_id is not null;
                                   
--문제4
--같은 직급의 평균급여보다 같거나 많은 급여를 받는 직원의 이름, 직급코드, 급여, 급여등급 조회

select emp_name,
        job_code,
        sal_level
from employee e
where salary >= (select avg(salary)
                        from employee
                        where job_code = e.job_code
                        );

--문제5
--부서별 평균 급여가 3000000 이상인 부서명, 평균 급여 조회

--단, 평균 급여는 소수점 버림, 부서명이 없는 경우 '인턴'처리
select 부서,
        평균급여,
        부서코드
from (select dept_code 부서,
                 round(avg(salary)) 평균급여,
                  (select dept_title
                    from department
                    where dept_id = e.dept_code
                    ) 부서코드
        from employee e
        group by dept_code
        ) e
where 평균급여 > 3000000;

--windrow 함수 써보기

select DISTINCT dept_code,
        round(부서평균),
        부서코드
from(
        select dept_code,
                 avg(salary) over(partition by dept_code) 부서평균,
                   (select dept_title
                    from department
                    where dept_id = e.dept_code
                    ) 부서코드
        from employee e
        )
where 부서평균 > 3000000;


--문제6
--직급의 연봉 평균보다 적게 받는 여자사원의
--사원명,직급명,부서명,연봉을 이름 오름차순으로 조회하시오
--연봉 계산 => (급여+(급여*보너스))*12    
 
select emp_name,
        (select job_name from job where job_code = e.job_code) 직급명,
        (select dept_title from department where dept_id= e.dept_code) 부서명,
        salary+(salary*   nvl(bonus,0)   )*12 연봉,
        round(직급평균연봉) 직급평균연봉
        
from employee e join (select job_code 직급코드,
                              avg((salary+(salary*   nvl(bonus,0)))*12) 직급평균연봉    
                                from employee
                                group by job_code
                                ) ys on e.job_code = ys.직급코드
where (salary+(salary*   nvl(bonus,0)))*12 < 직급평균연봉 and substr(emp_no,8,1) in ('2','4');


---문제7
--다음 도서목록테이블을 생성하고, 공저인 도서만 출력하세요.
create table tbl_books (
book_title  varchar2(50)
,author     varchar2(50)
,loyalty     number(5)
);

insert into tbl_books values ('반지나라 해리포터', '박나라', 200);
insert into tbl_books values ('대화가 필요해', '선동일', 500);
insert into tbl_books values ('나무', '임시환', 300);
insert into tbl_books values ('별의 하루', '송종기', 200);
insert into tbl_books values ('별의 하루', '윤은해', 400);
insert into tbl_books values ('개미', '장쯔위', 100);
insert into tbl_books values ('아지랑이 피우기', '이오리', 200);
insert into tbl_books values ('아지랑이 피우기', '전지연', 100);
insert into tbl_books values ('삼국지', '노옹철', 200);

select 책이름
from  (
        select book_title 책이름,
                count(*) 공저                
        from tbl_books
        group by book_title
        ) 
where 공저 > 1;

select *
from tbl_books T
where(select count(*)
        from tbl_books 
        where book_title = T.book_title) >= 2;

commit;