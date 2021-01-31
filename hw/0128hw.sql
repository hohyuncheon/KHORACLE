--@실습문제


--사원테이블
select * from employee;
--부서테이블
select * from department;
--직급테이블
select * from job;
--지역테이블
select * from location;
--국가테이블
select * from nation;
--급여등급테이블
select * from sal_grade;


--1. 2020년 12월 25일이 무슨 요일인지 조회하시오.
select to_char(to_date('2020/12/25'),'Day')
from dual;


--2. 주민번호가 70년대 생이면서 성별이 여자이고, 성이 전씨인 직원들의 
--사원명, 주민번호, 부서명, 직급명을 조회하시오.

select emp_name 사원명,
         emp_no 주민번호,
         d.dept_title 부서명,
         j.job_name 직급명
from employee E join department D
                      on E.dept_code = D.dept_id
                      join job J 
                      on J.job_code= e.job_code
where (substr(emp_no,1,2) between '70' and '79' ) and substr(emp_no,8,1) in('2','4')
and emp_name like ('전__');


--3. 가장 나이가 적은 직원의 사번, 사원명, 나이, 부서명, 직급명을 조회하시오.
select  emp_name,
        substr(emp_no,1,2)+to_number(decode(substr(emp_no,8,1),'1','1900','2','1900','2000'))
from employee E 
        join department D
        on E.dept_code = D.dept_id
         join job J 
        on J.job_code= e.job_code;



select emp_id 사번,
        emp_name,
        d.dept_title,
        j.job_name
from employee E 
        join department D
        on E.dept_code = D.dept_id
        join job J 
        on J.job_code= e.job_code
where extract(year from sysdate) -
        extract(year from (
        to_date(decode(substr(E.emp_no, instr(E.emp_no, '-')+1, 1), '1', 19, '2', 19, 20) || substr(E.emp_no, 1, 6))))+1
        =
        (select min
        (
        extract(year from sysdate) -
        extract(year from (
        to_date(decode(substr(emp_no, instr(E.emp_no, '-')+1, 1), '1', 19, '2', 19, 20) || substr(emp_no, 1, 6))))+1
        ) 
        from employee);



select *
from employee E 
where to_number(substr(e.emp_no,1,2)) > 99;

select 
E.emp_id 사번, E.emp_name 사원명,
        extract(year from sysdate) -
        extract(year from (
        to_date(decode(substr(E.emp_no, instr(E.emp_no, '-')+1, 1), '1', 19, '2', 19, 20) || substr(E.emp_no, 1, 6))))+1 나이,
        D.dept_title 부서명, J.job_name 직급명
from employee E 
        join department D   on E.dept_code = D.dept_id
        join job J          using(job_code)
where extract(year from sysdate) -
        extract(year from (
        to_date(decode(substr(E.emp_no, instr(E.emp_no, '-')+1, 1), '1', 19, '2', 19, 20) || substr(E.emp_no, 1, 6))))+1
        =
        (select min
        (
        extract(year from sysdate) -
        extract(year from (
        to_date(decode(substr(emp_no, instr(E.emp_no, '-')+1, 1), '1', 19, '2', 19, 20) || substr(emp_no, 1, 6))))+1
        ) 
        from employee);


select*
from employee;


--4. 이름에 '형'자가 들어가는 직원들의 사번, 사원명, 부서명을 조회하시오.
select emp_id 사번,
        emp_name 사원명,
        d.dept_title 부서명
from employee e join department d
on e.dept_code = d.dept_id
where e.emp_name like '%형%';



--5. 해외영업팀에 근무하는 사원명, 직급명, 부서코드, 부서명을 조회하시오.

select emp_name,
        dept_code,
        j.job_name,
        d.DEPT_TITLE
from employee e join department d
on e.dept_code = d.dept_id
join job j
on e.job_code = j.job_code
where substr(dept_title,1,2) like ('해외%')
order by 2 asc;

--6. 보너스포인트를 받는 직원들의 사원명, 보너스포인트, 부서명, 근무지역명을 조회하시오.

select emp_name,
        bonus,
        dept_title,
        local_name
from employee e join department d
on e.dept_code = d.dept_id 
                        join location l
on d.LOCATION_ID = l.LOCAL_CODE
where bonus is not null;



--7. 부서코드가 D2인 직원들의 사원명, 직급명, 부서명, 근무지역명을 조회하시오.

select EMP_NAME,
        j.job_name,
        d.dept_title,
        l.local_name
from employee e join department d
on e.dept_code = d.dept_id
join location l
on d.LOCATION_ID = l.LOCAL_CODE
join job j
on e.job_code = j.job_code
where dept_code = 'D2';

--8. 급여등급테이블의 등급별 최대급여(MAX_SAL)보다 많이 받는 직원들의 사원명, 직급명, 급여, 연봉을 조회하시오.
--(사원테이블과 급여등급테이블을 SAL_LEVEL컬럼기준으로 동등 조인할 것)
select emp_name,
        j.job_name,
        to_char(e.salary,'fml999,999,999') 급여,
        to_char(e.salary*12,'fml999,999,999') 연봉,
         to_char(max_sal,'fml999,999,999') 맥스
from employee e join sal_grade s
on e.sal_level = s.SAL_LEVEL
join job j
on e.job_code = j.job_code
where salary > s.MAX_SAL;


--join department d
--on e.dept_code = d.dept_id;

--9. 한국(KO)과 일본(JP)에 근무하는 직원들의 
--사원명, 부서명, 지역명, 국가명을 조회하시오.

select E.EMP_NAME 직원명,
        D.DEPT_TITLE 부서명,
        L.LOCAL_NAL 지역명,
        N.NATIONAL_CODE 국가
from nation n join location l
on n.NATIONAL_CODE = l.NATIONAL_CODE
join department d
on l.local_code = d.location_id
join employee e
on d.dept_id = e.dept_code
where n.NATIONAL_CODE in ('KO','JP');

--10. 같은 부서에 근무하는 직원들의 사원명, 부서코드, 동료이름을 조회하시오.
--self join 사용

select  e1.emp_name 사원명,
        d.dept_title 부서코드,
        e2.emp_name 동료이름
from employee e1 join employee e2
on E1.dept_code  = E2.dept_code
join department d
on e1.dept_code = d.dept_id
order by 1;

--11. 보너스포인트가 없는 직원들 중에서 직급이 차장과 사원인 직원들의 사원명, 직급명, 급여를 조회하시오.

select emp_name,
        salary,
        j.job_name
from employee e join job j
on e.job_code = j.job_code
where bonus is null and j.job_name ='차장'
order by 2;

--12. 재직중인 직원과 퇴사한 직원의 수를 조회하시오.

select decode(quit_yn,'Y','퇴사자','재직인원'),
        count(*)
from employee
group by decode(quit_yn,'Y','퇴사자','재직인원');

