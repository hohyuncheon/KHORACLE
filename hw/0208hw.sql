--@실습문제 : tb_number테이블에 난수 100개(0 ~ 999)를 저장하는 익명블럭을 생성하세요.
--실행시마다 생성된 모든 난수의 합을 콘솔에 출력할 것.
create table tb_number(
    id number, --pk sequence객체로 부터 채번
    num number, --난수
    reg_date date default sysdate,
    constraints pk_tb_number_id primary key(id)
);

select *
from tb_number;


drop table tb_number;

declare
    rudnum number;
    hap number := 0;
      
begin
     for n in 1..100 loop
         rudnum := trunc(dbms_random.value(1, 1000));
    
         insert into tb_number(id, num, reg_date)
         values(seq_tb_number_hw.nextval , rudnum , default);

          hap := hap + rudnum;

         dbms_output.put_line('합계 = ' || hap );
         end loop;
         
end;
/

create sequence seq_tb_number_hw
start with 1
increment by 1
nomaxvalue
nominvalue
nocycle
cache 20;
