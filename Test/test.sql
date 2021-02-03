select  dept_code "DEPT 부서명",
         sum(salary) "함수식 급여합"
from employee 
group by dept_code
having sum(salary) > 9000000;

select emp_name "ENAME 사원명",
        rpad(substr(emp_no, 1, 8), 14, '*') "ENO 주민번호"
from employee;

select 
       case job_code
        when 'J1' then 'A'
        when 'J2' then 'B'
        when 'J3' then 'C'
        end "MERIT_RATING(인사고가)",
        salary * nvl(bonus, 0) "BONUS(성과급)"
from employee;



SELECT emp_name, 
          sal_level,

          salary,

          CASE sal_level

          WHEN 'S1' THEN salary * 0.2

          WHEN 'S4' THEN salary * 0.15

          WHEN 'S5' THEN salary * 0.1

          ELSE 0

          END bonus

FROM employee;

select DISTINCT job_code, bonus
from employee;

SELECT EMPNAME, 
        JOBCODE, 
        COUNT(*) AS 사원수
FROM EMP

WHERE BONUS != 'NULL'

GROUP BY JOBCODE, EMPNAME

ORDER BY JOBCODE;

select emp_name,
        job_code,
        count(*) 사원수
from employee
where bonus is null
group by job_code, emp_name
order by job_code;


SELECT DEPT
, SUM(SALARY) 합계
, FLOOR(AVG(SALARY)) 평균
, COUNT(*) 인원수
FROM
EMP
GROUP BY
DEPT
ORDER BY DEPT ASC;

select dept_code,
        sum(salary) 합계,
        floor(avg(salary)) 평균,
        count(*) 인원수
from employee
group by dept_code
having avg(salary) > 2800000
order by dept_code asc;







