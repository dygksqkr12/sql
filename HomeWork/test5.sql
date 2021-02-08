--@실습문제 : tb_number테이블에 난수 100개(0  ~ 999)를 저장하는 익명블럭을 생성하세요.
--실행시마다 생성된 모든 난수의 합을 콘솔에 출력할 것.
create table tb_number(
    id number, --pk sequence객체로 부터 채번
    num number, --난수
    reg_date date default sysdate,
    constraints pk_tb_number_id primary key(id)
);
create sequence seq_tb_number
start with 1
increment by 1
nomaxvalue
nominvalue
nocycle
cache 100;

declare
    rd number;
    plus number := 0;
begin
    for n in 0..100 loop
        rd := trunc(dbms_random.value(0, 1000));
        insert into tb_number (id, num)
        values (seq_tb_number.nextval, rd);
        plus := plus + rd;
    end loop;
     dbms_output.put_line(plus);
end;
/