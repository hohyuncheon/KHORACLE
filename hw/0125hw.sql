
--실습문제
select*
from employee;
--1. 직원명과 이메일 , 이메일 길이를 출력하시오
--     ex)     홍길동 , hong@kh.or.kr         13

select emp_name 이름,
         email 이메일 ,
        length(email) 이메일길이
from employee;

--2. 직원의 이름과 이메일 주소중 아이디 부분만 출력하시오
--    ex) 노옹철   no_hc
--    ex) 정중하   jung_jh

select emp_name 이름,
         substr(email,1, instr(email,'@')-1) 아이디부분만
from employee;

--3. 60년대에 태어난 직원명과 년생, 보너스 값을 출력하시오 
--그때 보너스 값이 null인 경우에는 0 이라고 출력 되게 만드시오
--        직원명    년생      보너스
--    ex) 선동일   1962    0.3
--    ex) 송은희   1963    0

select emp_name 직원명,
        19 || substr(emp_no,1,2) 년생,
         nvl(bonus, 0) 보너스
from employee
where substr(emp_no,1,1)=6;

--. '010' 핸드폰 번호를 쓰지 않는 사람의 수를 출력하시오 (뒤에 단위는 명을 붙이시오)
--    ex) 3명
select sum(
    case substr(phone,1,3)
    when '010' then 0
    else  1
    end
    ) || '명' as 휴대폰010안쓰는사람수
from employee;

--5. 직원명과 입사년월을 출력하시오 
--    단, 아래와 같이 출력되도록 만들어 보시오
--        직원명       입사년월
--    ex) 전형돈       2012년12월
--   ex) 전지연       1997년 3월

select emp_name 직원명,
        to_char(hire_date,'yy"년"mm"월"') 입사년월
from employee
where substr(emp_name,1,1) = '전';


select emp_id, 
        emp_name, 
        rpad(substr(emp_no,1,8),14,'*'),
        decode(substr(emp_no,8,1), '1','남자','2','여자','3','남자','4','여자') 성별,
        --현재나이구하기
        substr((2021-(to_number(substr(emp_no,1,2)))),3,2)+1 현재나이
from employee;


--7. 직원명, 직급코드, 연봉(원) 조회
--  단, 연봉은 ￦57,000,000 으로 표시되게 함
--     연봉은 보너스포인트가 적용된 1년치 급여임

--보너스 한번으로 계산?
select emp_name, 
        job_code,
        to_char(salary+((salary*12)+nvl(bonus,0)),'fml999,999,999')
from employee;


--8. 부서코드가 D5, D9인 직원들 중에서 2004년도에 입사한 직원중에 조회함.
--   사번 사원명 부서코드 입사일

select emp_id 사번, 
         emp_name 사원명,
         dept_code 부서코드,
         hire_date 입사일
from employee
where dept_code in ('D5','D9') and substr(hire_date,1,2)='04';

--9. 직원명, 입사일, 오늘까지의 근무일수 조회 
--    * 주말도 포함 , 소수점 아래는 버림

select emp_name 사원명,
         hire_date 입사일,
         trunc(sysdate- hire_date) 근무일수
from employee;

--10. 직원명, 부서코드, 생년월일, 만나이 조회
--   단, 생년월일은 주민번호에서 추출해서, 
--   ㅇㅇㅇㅇ년 ㅇㅇ월 ㅇㅇ일로 출력되게 함.
--   나이는 주민번호에서 추출해서 날짜데이터로 변환한 다음, 계산함

select emp_id 사번, 
         dept_code 부서코드,
         
         case substr(emp_no,8,1)
         when '1' then '19' || to_char(to_date(substr(emp_no,1,6)),'yy"년"mm"월"dd"일"')
         when '2' then '19' || to_char(to_date(substr(emp_no,1,6)),'yy"년"mm"월"dd"일"')
         when '3' then '20' || to_char(to_date(substr(emp_no,1,6)),'yy"년"mm"월"dd"일"')
         when '4' then '20' || to_char(to_date(substr(emp_no,1,6)),'yy"년"mm"월"dd"일"')

         end 생년원일,
         substr((2021-(to_number(substr(emp_no,1,2)))),3,2)+1 만나이
from employee;

--11. 직원들의 입사일로 부터 년도만 가지고, 각 년도별 입사인원수를 구하시오.
--  아래의 년도에 입사한 인원수를 조회하시오. 마지막으로 전체직원수도 구하시오
--  => decode, sum 사용

    -------------------------------------------------------------------------
     1998년   1999년   2000년   2001년   2002년   2003년   2004년  전체직원수
    -------------------------------------------------------------------------
    
    select sum (
    decode(substr(hire_date, 1, 2), '98' ,1,0)) "1998년",
    sum (
    decode(substr(hire_date, 1, 2), '99' ,1,0)) "1999년",
    sum (
    decode(substr(hire_date, 1, 2), '00' ,1,0)) "2000년",
    sum (
    decode(substr(hire_date, 1, 2), '01' ,1,0)) "2001년",
    sum (
    decode(substr(hire_date, 1, 2), '02' ,1,0)) "2002년",
    sum (
    decode(substr(hire_date, 1, 2), '03' ,1,0)) "2003년",
    sum (
    decode(substr(hire_date, 1, 2), '04' ,1,0)) "2004년",
             
    
     sum(
            case 
             when quit_date is not null then 1
             end
            ) 퇴사한인원,

       sum(
             case 
             when quit_date is null then 1
             end
            ) 전체인원수
       
    from employee;
      

--      12.  부서코드가 D5이면 총무부, D6이면 기획부, D9이면 영업부로 처리하시오.(case 사용)
--   단, 부서코드가 D5, D6, D9 인 직원의 정보만 조회하고, 부서코드 기준으로 오름차순 정렬함.
      
   select emp_name 이름,
            dept_code 부서코드,
            case
            when dept_code in ('D5') then '총무부'
            when dept_code in ('D6') then '기획부'
            when dept_code in ('D9') then '영업부'
            end 부서
   from employee
   where dept_code in ('D5', 'D6','D9')
   order by dept_code asc;
