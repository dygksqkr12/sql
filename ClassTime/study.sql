--20년 이상 근무한 사원조회, 퇴사 X인 사람
select emp_name, quit_yn, hire_date
from employee
where quit_yn = 'N' and (sysdate - hire_date) >= 365*20;

--급여가 200만원 이상 400만원 이하인 사원 조회
select salary
from employee
where salary BETWEEN 2000000 AND 4000000;

--select emp_name, hire_date
--from employee
--where hire_date >= '1990/01/01' and hire_date <= '2001/01/01';를 비트윈으로
select emp_name, hire_date
from employee
where hire_date BETWEEN TO_DATE('1990/01/01') and TO_DATE('2001/01/01')
order by hire_date;

--이름에 '이'가 들어가는 사원 조회;
select emp_name
from employee
where emp_name like '%이%';

--bonus에서 null값만 출력
select bonus
from employee
where bonus is null;
--bonus에서 null이 아닌 값만 출력
select bonus
from employee
where bonus is not null;

--email 컬럼값중 '@'의 위치는? (이메일, 인덱스) 빠른 자리에 있는 순서대로 정렬하고 같을 경우 이메일 오름차순
select email, instr(email, '@')골뱅이
from employee
order by 골뱅이, email;

--사원명에서 성(1글자로 가정)만 중복없이 사전순으로 출력
select DISTINCT substr(emp_name, 1, 1)성
from employee
order by 성;

select email
from employee
where email like '___\_%' escape '\';
