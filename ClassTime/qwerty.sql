show user;

create table tb_abc (  
  id number
);
--ORA-01031 : insuffucuent privileges

--권한, 롤을 조회
select *
from user_sys_privs; --권한

select *
from user_role_privs; --롤

select *
from role_sys_privs; --부여받은 롤에 포함된 권한

--kh계정이 소유한 tb_coffee테이블 조회
select *
from kh.tb_coffee;


--데이터추가
insert into kh.tb_coffee
values ('프렌치까페', 4000, '남양유업');

--view_emp조회
select * from kh.employee;
select * from kh.view_emp;




