--직원 정보가 저장된 EMP 테이블에서 각 부서(DEPT)별 급여(SALARY)의 합계들을 구하여, 
--부서 급여합이 9백만을 초과하는 부서와 급여합계를 조회하는 SELECT 문을 작성하시오. (25점)
-- 조회한 컬럼명과 함수식에는 별칭 적용한다. (DEPT 부서명, 함수식 급여합)

select *
from(
        select (select dept_title from department where dept_id = e.dept_code) 부서명,
                 sum(salary) 급여합
        from employee e
        group by dept_code
        ) e
where 급여합 > 9000000;


--3.직원 정보를 저장한 EMP 테이블에서 사원명(ENAME)과 주민번호(ENO)를 함수를 사용하여 
--아래의 요구대로 조회되도록 SELECT 구문을 기술하시오. (25점)
-- 주민번호는 '891224-1******' 의 형식으로 출력되게 하시오

--조회결과에 컬럼명은 별칭 처리하시오. => ENAME 사원명, ENO 주민번호

select emp_name 사원명,
        rpad(substr(emp_no,1,8),14,'*') 주민번호
from employee;


-- 4.	아래의 구문을 CASE 표현식을 사용하는 SELECT 문으로 변경하시오. (40점)
-- MERIT_RATING(인사고가)에 따라 BONUS(성과급)을 조회한다.

--문제 보충설명
--merit_rating이 'A'라면 salary의 20%만큼 보너스를 부여한다.
--merit_rating이 'B'라면 salary의 15%만큼 보너스를 부여한다.
--merit_rating이 'C'라면 salary의 10%만큼 보너스를 부여한다.
--그 외 merit_rating값은 보너스가 없다.
--사원테이블에서 emp_name, merit_rating, salary, 보너스를 조회하세요. 
   --넘버를 차로
   --TOCHAR로 쓸 필요없음 ELSE를 0으로 써도됨.
   
select  emp_name,
          salary,
          merit_rating,
          salary,
          case
              when merit_rating = 'A' then to_char(salary*0.2)
              when merit_rating = 'B' then to_char(salary*0.15)
              when merit_rating = 'C' then to_char(salary*0.1)
              else '없음'
              end 보너스
from employee;





--1. 직원테이블(EMP)이 존재한다.
--직원 테이블에서 사원명,직급코드, 보너스를 받는 사원 수를 조회하여 직급코드 순으로 오름차순 정렬하는 구문을 작성하였다.
--이 때 발생하는 문제점을 [원인](10점)에 기술하고, 이를 해결하기 위한 모든 방법과 구문을 [조치내용](30점)에 기술하시오.


--rollup도전 풀이용

select decode(grouping(job_code), 0, nvl(job_code,'총'), '합계') 사원코드,
        decode(grouping(emp_name), 0, nvl(EMP_NAME,'총'), '합계') 사원명,
        COUNT(*) AS 사원수
from employee
WHERE BONUS is not NULL
group by rollup(job_code,EMP_NAME)
order by job_code asc;

--풀이용답
select job_code 직급코드,
        EMP_NAME 사원명,
        COUNT(*) AS 사원수
from employee
WHERE BONUS is not NULL
group by job_code,EMP_NAME
order by job_code asc;

--제출용 rollup
select decode(grouping(jobcode), 0, nvl(jobcode,'총'), '합계') 사원코드,
        decode(grouping(empname), 0, nvl(EMPNAME,'총'), '합계') 사원명,
        COUNT(*) AS 사원수
from emp
WHERE BONUS is not NULL
group by rollup(jobcode, EMPNAME)
order by jobcode asc;

--제출용 답
select jobcode 직급코드,
        EMPNAME 사원명,
        COUNT(*) AS 사원수
from emp
WHERE BONUS is not NULL
group by jobcode, EMPNAME
order by jobcode asc;

-------
--직원 테이블(EMP)에서 부서 코드별 그룹을 지정하여 부서코드, 그룹별 급여의 합계, 그룹별 급여의 평균(정수처리), 
--인원수를 조회하고 부서코드순으로 나열되어있는 코드 아래와 같이 제시되어있다. 
--아래의 SQL구문을 평균 월급이 2800000초과하는 부서를 조회하도록 수정하려고한다.
--수정해야하는 조건을[원인](30점)에 기술하고, 제시된 코드에 추가하여 [조치내용](30점)에 작성하시오.(60점)

---------풀이
select *
from(
        select  dept_code, 
                    sum(salary) 합계, 
                    floor(avg(salary)) 평균, 
                    count(*) 인원수
        from employee
        group by dept_code
        
        order by dept_code asc
        )
where 평균 > 2800000;

------------------
--문제코드
SELECT  DEPT, 
            SUM(SALARY) 합계, 
            FLOOR(AVG(SALARY)) 평균, 
            COUNT(*) 인원수
FROM EMP

GROUP BY DEPT

ORDER BY DEPT ASC;


