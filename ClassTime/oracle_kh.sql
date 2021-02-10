--==============================
--kh계정
--==============================
show user;

--table sample 생성
create table sample(
    id number
);

--현재 계정의 소유 테이블 목록 조회
select * from tab;

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

--표 table entity relation 데이터를 보관하는 객체
--열 column field attribute 세로. 데이터가 담길 형식
--행 row record tuple 가로. 실제 데이터.
--도메인 domain 하나의 컬럼에 취할 수 있는 값의 그룹(범위)

--테이블 명세
--컬럼명    널여부    자료형
describe employee;
desc employee;


--=========================================
--DATA TYPE
--=========================================
--컬럼에 지정해서 값을 제한적으로 허용.
--1. 문자형 varchar2 | char
--2. 숫자형 number
--3. 날짜시간형 date
--4. LOB

-------------------------------------------
--문자형
-------------------------------------------
--고정형 char(byte) 최대 2000byte
--  char(10) 'Korea' 영소문자는 글자당 1byte이므로 실제크기는 5byte이지만 고정형으로 10byte로 저장됨.
--           '안녕' 한글은 글자당 3byte(11g XE)이므로 실제크기 6byte이지만 고정형으로 10byte로 저장됨.
--가변형 varchar2(byte) 최대 4000byte
--   varchar2(10) 'korea' 영소문자는 글자당 1byte이므로 실제크기 5byte. 가변형 5byte로 저장됨.
--           '안녕' 한글은 글자당 3byte(11g XE)이므로 실제크기 6byte로 저장됨.
--고정형, 가변형 모두 지정한 크기 이상의 값은 추가할 수 없다.

--가변형 long : 최대 2GB
--LOB(Large Object)타입중의 CLOB(Character LOB)는 단일컬럼 최대 4GB까지 지원

create table tb_datatype (
--컬럼명 자료형 null여부 기본값
    a char(10),
    b varchar2(10)
);

--테이블 조회
select a,b -- *는 모든 컬럼
from tb_datatype; --테이블명

--데이터추가 : 한행을 추가
insert into tb_datatype
values('hello', 'hello');

insert into tb_datatype
values('안녕', '안녕');

insert into tb_datatype
values('12345', '12345');

insert into tb_datatype
values('에브리바디', '안녕');--ORA-12899: value too large for column "KH"."TB_DATATYPE"."A" (actual: 15, maximum: 10)

--데이터가 변경(insert, update, delete)되는 경우, 메모리상에서 먼저 처리된다.
--commit을 통해 실제 database에 적용해야 한다.
commit;

--lengthb(컬럼명) : number - 저장된 데이터의 실제크기를 리턴
select a, lengthb(a), b, lengthb(b)
from tb_datatype;

-------------------------------------------
--숫자형
-------------------------------------------
--정수, 실수를 구분치 않는다.
--number(p,s)
--p : 표현가능한 전체 자리수
--s : p의 값 중 소수점 이하 자리수
/*
값 1234.567
-------------------------------
number          1234.567
number(7)       1235    --반올림
number(7,1)     1234.6  --반올림
number(7,-2)    1200    --반올림
*/

create table tb_datatype_number(
    a number,
    b number(7),
    c number(7,1),
    d number(7,-2)
);

select * from tb_datatype_number;

insert into tb_datatype_number
values(1234.567, 1234.567, 1234.567, 1234.567);

--지정한 크기보다 큰 숫자는 ORA-01438: value larger than specified precision allowed for this column 유발
insert into tb_datatype_number
values(1234567890.123, 1234567.567, 1234.567, 1234.567);

--커밋은 못지움
commit;
--마지막 commit시점 이후 변경사항은 취소된다.
rollback; --데이터 취소

-------------------------------------------
--날짜시간형
-------------------------------------------
--data 년월일시분초
--timestamp 년월일시분초 밀리초 지역대

create table tb_datatype_date(
    a date,
    b timestamp
);

--to)char 날짜/숫자를 문자열로 표현
select to_char(a, 'yyyy/mm/dd hh24:mi:ss'), b 
from tb_datatype_date;

insert into tb_datatype_date
values (sysdate, systimestamp);

--날짜형 +- 숫자(1 = 하루) = 날짜형
select to_char(a, 'yyyy/mm/dd hh24:mi:ss'), 
       to_char(a - 1, 'yyyy/mm/dd hh24:mi:ss'), 
       b 
from tb_datatype_date;

--날짜형 - 날짜형 = 숫자(1 = 하루)
select sysdate - a --0.008일 차
from tb_datatype_date;

--to_date : 문자열을 날짜형으로 변환 함수
select to_date('2021/01/23')-a
from tb_datatype_date;

--dual 가상테이블
select (sysdate+1)-sysdate
from dual;


--=========================================
--DQL
--=========================================
--Data Query Language 데이터 조회(검색)을 위한 언어
--select문
--쿼리 조회결과를 ResultSet(결과집합)라고 하며, 0행이상을 포함한다.

--from절에 조회하고자 하는 테이블 명시
--where절에 의해 특정행을 filtering 가능.
--select절에 의해 컬럼을 filtering 또는 추가 가능.
--order by절에 의해서 행을 정렬할 수 있다.

/*
구조

select 컬럼명 (5)         필수
from 테이블명 (1)         필수
where 조건절(2)          선택
group by 그룹기준컬럼 (3) 선택
having 그룹조건절 (4)     선택
order by 정렬기준컬럼 (6) 선택

*/
select *
from employee
where dept_code = 'D9' --데이터는 대소문자 구분
order by emp_name asc; --오름차순(desc = 내림차순)

--1. job테이블에서 job_name컬럼정보만 출력
select job_name
from job;
--2. department테이블에서 모든 컬럼을 출력
select *
from department;
--3.employee테이블에서 이름, 이메일, 전화번호, 입사일을 출력
select EMP_NAME, EMAIL, PHONE, HIRE_DATE
from employee;
--4.employee테이블에서 급여가 2,500,000원 이상인 사원의 이름과 급여를 출력
select EMP_NAME, SALARY
from employee
where SALARY >= 2500000;
--5.employee테이블에서 급여가 3,500,000원 이상이면서, 직급코드가 'J3'인 사원을 조회
--(&& || 이 아닌 and or 사용가능)
select *
from employee
where SALARY >= 3500000 and JOB_CODE = 'J3';
--6.employee테이블에서 현재 근무중인 사원을 이름 오름차순으로 정렬해서 출력.
select *
from employee
where quit_yn = 'N'
order by emp_name asc; -- ascending(기본값) | descending


-------------------------------------------
--SELECT
-------------------------------------------
--table의 존재하는 컬럼
--가상컬럼(산술연산)
--임의의 값(literal)
--각 컬럼은 별칭(alias)를 가질 수 있다. as와 "(쌍따음표)는 생략가능
--(별칭에 공백, 특수문자가 있거나 숫자로 시작하는 경우 쌍따옴표 필수.)
select emp_name as "사원명",
       phone "전화번호",
       salary 급여,
       salary * 12 "연 봉",
       123 "123abc",
       '안녕'
from employee;

--실급여 : salary + (salary * bonus)
select emp_name,
       salary,
       bonus,
       salary + (salary * nvl(bonus,0)) 실급여
from employee;

--null값과는 산술연산할 수 없다. 그 결과는 무조건 null이다.
--null % 1 (X) 나머지연산자는 사용불가
select null + 1,
       null - 1,
       null * 1,
       null / 1
from dual; --1행짜리 가상테이블

--nvl(col, null일때 값) null처리 함수
--col의 값이 null이 아니면, col값 리턴
--col의 값이 null이면, (null일때 값)을 리턴
select bonus,
       nvl(bonus, 0) null처리후
from employee;


--distinct 중복제거용 키워드
--select절에 단 한번 사용가능하다.
--직급코드를 중복없이 출력
select distinct job_code
from employee;

--여러 컬럼사용시 컬럼을 묶어서 고유한 값으로 취급한다.
select distinct job_code, dept_code
from employee;

--문자 연결연산자 ||
-- +는 산술연산만 가능하다.
select '안녕' || '하세요' || 123
from dual;

select emp_name || '(' || phone || ')'
from employee;


-------------------------------------------
--WHERE
-------------------------------------------
--테이블의 모든 행 중 결과집합에 포함될 행을 필터링한다.
--특정행에 대해 true(포함) | false(제외) 결과를 리턴한다.
/*
    =               같은가
    != ^= <>        다른가
    > < >= <=
    between .. and ..       범위연산
    like, not like          문자패턴연산
    is null, is not null    null여부
    in, not in              값목록에 포함여부
    
    and
    or
    not             제시한 조건 반전
*/
--부서코드가 D6인 사원 조회
select emp_name, dept_code
from employee
where dept_code = 'D6';

--부서코드가 D6가 아닌 사원 조회
select emp_name, dept_code
from employee
where dept_code != 'D6'; -- != ^= <>

--급여가 2,000,000원보다 많은 사원 조회
select emp_name, salary
from employee
where salary > 2000000;

--날짜형 크기비교 가능
--과거 < 미래
select emp_name, hire_date
from employee
where hire_date < TO_DATE('2000/01/01'); --날짜형식의 문자열은 자동으로 날짜형으로 형변환

--20년이상 근무한 사원 조회
--날짜형 - 날짜형 = 숫자(1=하루)
--날짜형 - 숫자(1=하루) = 날짜형
select emp_name, hire_date, quit_yn
from employee
where sysdate - hire_date >= 20*365 and quit_yn = 'N';
--where to_date('2021/01/22') - hire_date > 365 * 20 and quit_yn = 'N';

--부서코드가 D6이거나 D9인 사원 조회
select emp_name, dept_code
from employee
where dept_code = 'D6' or dept_code = 'D9';

--범위연산
--급여가 200만원이상 400만원 이하인 사원 조회(사원명, 급여)
select emp_name, salary
from employee
where salary >= 2000000 and salary <= 4000000;

select emp_name, salary
from employee
where salary between 2000000 and 4000000; --이상 이하

--1990/01/01 ~ 2000/01/01인 사원조회(사원명, 입사일)
select emp_name, hire_date
from employee
where hire_date >= '1990/01/01' and hire_date <= '2001/01/01'and quit_yn = 'N';

select emp_name, hire_date
from employee
where hire_date between '1990/01/01' and '2001/01/01' and quit_yn = 'N';


--like, not like
--문자열 패턴 비교 연산

--wildcard : 패턴 의미를 가지는 특수문자
-- _ 아무문자 1개
-- % 아무문자 0개이상

select emp_name
from employee
where emp_name like '전%'; --전으로 시작, 0개이상의 문자가 존재하는가
--전, 전차, 전진, 전형돈, 전전전전전(O)
--파전(X)

select emp_name
from employee
where emp_name like '전__';--전으로 시작, 2개의 문자가 존재하는가
--전형동, 전전전(O)
--전, 전진, 파전, 전당포아저씨(X)

--이름에 가운데 글자가 '옹'인 사원 조회. 단, 이름은 3글자이다.
select emp_name
from employee
where emp_name like '_옹_';

--이름에 '이'가 들어가는 사원 조회.
select emp_name
from employee
where emp_name like '%이%';

--email컬럼값의'_'이전 글자가 3글자인 이메일을 조회
select email
from employee
--where email like '___%';--4글자 이후 0개이상의 문자열 뒤따르는가 -> 문자열이 4글자이상인가?
where email like '___\_%'escape'\'; --임의의 escaping문자 등록. 데이터에 존재하지 않을 것.

--in, not in 값목록에 포함여부
--부서코드가 D6 또는 D8인 사원을 조회
select emp_name, dept_code
from employee
where dept_code = 'D6' or dept_code = 'D8';

select emp_name, dept_code
from employee
where dept_code in ('D6', 'D8'); --개수제한 없이 값 나열

--값 제외
select emp_name, dept_code
from employee
where dept_code != 'D6' and dept_code != 'D8';

select emp_name, dept_code
from employee
where dept_code not in ('D6', 'D8');

--is null, is not null : null 비교연산
--인턴사원 조회
--null값은 산술연산, 비교연산 모두 불가능하다.
select emp_name, dept_code
from employee
--where dept_code = null;
--where dept_code is null;
where dept_code is not null;

--D6, D8부서원이 아닌 사원조회(인턴사원 포함)
select emp_name, dept_code
from employee
where dept_code not in ('D6', 'D8') or dept_code is null; 

--nvl 버전
select emp_name, dept_code
from employee
where nvl(dept_code, 'D0') not in ('D6', 'D8');

select emp_name, nvl(dept_code, '인턴')
from employee
where nvl(dept_code, 'D0') not in ('D6', 'D8');


-------------------------------------------
--ORDER BY
-------------------------------------------
--select 구문 중 가장 마지막에 처리.
--지정한 컬럼 기준으로 결과집합을 정렬해서 보여준다.

--number 0 < 10
--string ㄱ < ㅎ, a < z
--date 과거 < 미래
--null값 위치를 결정가능 : nulls first | nulls last
--asc 오름차순(기본값)
--desc 내림차순
--복수개의 컬럼을 차례로 정렬가능

select emp_id, emp_name, dept_code, job_code, salary, hire_date
from employee
order by salary desc;

--alias 사용가능
select emp_id 사번,
       emp_name 사원명
from employee
order by 사원명;

--1부터 시작하는 컬럼순서 사용가능.(비추)
select *
from employee 
order by 9 desc;


--=========================================
--BUILT-IN FUNCTION
--=========================================
--일련의 실행 코드 작성해두고 호출해서 사용함.
--반드시 하나의 리턴값을 가짐.

--1. 단일행 함수 : 각 행마다 반복 호출되어서 호출된 수만큼 결과를 리턴함.
--    a.문자처리함수
--    b.숫자처리함수
--    c.날짜처리함수
--    e.기타함수
--2. 그룹함수 : 여러 행을 그룹핑한 후, 그룹당 하나의 결과를 리턴함.

-------------------------------------------
--단일행 함수
-------------------------------------------

--*****************************************
--a.문자처리함수
--*****************************************

--length(col):number
--문자열의 길이를 리턴
select emp_name, length(emp_name)
from employee;

--where절에서도 사용가능
select emp_name, email
from employee
where length(email) < 15;

--lengthb(col)
--값의 byte수 리턴
select emp_name, lengthb(emp_name),
       email, lengthb(email)
from employee;

--instr(string, search[, startPosition[, occurence]])
--string에서 search문자가 위치한 index를 반환.
--oracle에서는 1-based index. 1부터 시작.
--startPosition 검색시작위치
--occurence 출현순서
select instr('kh정보교육원 국가정보원', '정보'),--3
       instr('kh정보교육원 국가정보원', '안녕'),--0 값없음
       instr('kh정보교육원 국가정보원', '정보', 5),--11(다섯번째자리부터 찾음)
       instr('kh정보교육원 국가정보원 정보문화사', '정보', 1, 3),--15(처음부터 찾지만 세번째에 나온 걸 찾음)
       instr('kh정보교육원 국가정보원', '정보', -1)--11 startPosition이 음수면 뒤에서부터 검색
from dual;

--email컬럼값중 '@'의 위치는? (이메일, 인덱스)
select email, instr(email, '@')
from employee;


--substr(string, startIndex[, length])
--string에서 startIndex부터 length개수만큼 잘라내어 리턴
--length 생략시에는 문자열 끝까지 반환
select substr('show me the money', 6, 2),--me
       substr('show me the money', 6),--me the money
       substr('show me the money', -5, 3)--mon
from dual;

--@실습문제 : 사원명에서 성(한글자로 가정)만 중복없이 사전순으로 출력
select distinct  substr(emp_name, 1, 1) 성
from employee
order by 성;

--lpad|rpad(string, byte[, padding_char])
--byte수의 공간에 string을 대입하고, 남은 공간은 padding_char를 (왼쪽|오른쪽) 채울것.
--padding char는 생략시 공백문자.
select lpad(email, 20, '#'),
       rpad(email, 20, '#'),
       '[' || lpad(email, 20) || ']',
       '[' || rpad(email, 20) || ']'
from employee;

--@실습문제 : 남자사원만 사번, 사원명, 주민번호, 연봉 조회
--주민번호 뒤 6자리는 ****** 숨김처리할 것.
select emp_id, 
       emp_name, 
       substr(emp_no, 1, 8) || '******' emp_no,
       rpad(substr(emp_no, 1, 8), 14, '*') emp_no,
       (salary + (salary * nvl(bonus,0))) * 12 연봉
from employee
where substr(emp_no, 8, 1) in ('1','3');


--@실습문제

create table tbl_escape_watch(
    watchname   varchar2(40)
    ,description    varchar2(200)
);
--drop table tbl_escape_watch;
insert into tbl_escape_watch values('금시계', '순금 99.99% 함유 고급시계');
insert into tbl_escape_watch values('은시계', '고객 만족도 99.99점를 획득한 고급시계');
commit;

select * from tbl_escape_watch;

--tbl_escape_watch 테이블에서 description 컬럼에 99.99% 라는 글자가 들어있는 행만 추출하세요.
select *
from tbl_escape_watch
where description like '%99.99\%%' escape '\';

--@실습문제
--파일경로를 제외하고 파일명만 아래와 같이 출력하세요.
	
create table tbl_files(
    fileno number(3)
    ,filepath varchar2(500)
);

insert into tbl_files values(1, 'c:\abc\deft\salesinfo.xls');
insert into tbl_files values(2, 'c:\music.mp3');
insert into tbl_files values(3, 'c:\documents\resume.hwp');

commit;

select * 
from tbl_files;

--출력결과 :
----------------------------
--파일번호          파일명
-----------------------------
--1             salesinfo.xls
--2             music.mp3
--3             resume.hwp
-----------------------------

select fileno,
--            instr(filepath, '\', -1),
            substr(filepath, instr(filepath, '\', -1) + 1) filename
from tbl_files;


--*****************************************
-- b. 숫자처리함수
--*****************************************

--mod(피젯수, 젯수) 
--나머지 함수, 나머지연산자 %가 없다.
select mod(10, 2),
            mod(10, 3),
            mod(10, 4)
from dual;

--입사년도가 짝수인 사원 조회
select emp_name, 
            extract(year from hire_date) year --날짜함수 : 년도추출
from employee
--where mod(year, 2) = 0 -- ORA-00904: "YEAR": invalid identifier
where mod(extract(year from hire_date), 2) = 0
order by year;

--ceil(number)
--소수점기준으로 올림.
select ceil(123.456),
            ceil(123.456 * 100) / 100 --부동소수점 방식으로 처리
from dual;

--floor(number)
--소수점기준으로 버림
select floor(456.789),
            floor(456.789 * 10) / 10
from dual;

--round(number[, position])
--position기준(기본값 0, 소수점기준)으로 반올림처리
select round(234.567),
            round(234.567, 2),
            round(235.567, -1)
from dual;


--trunc(number[, position])
--버림
select trunc(123.567) 버려,
            trunc(123.567, 2)버려
from dual;

--*****************************************
--c.날짜처리함수
--*****************************************
--날짜형 + 숫자 = 날짜형
--날짜형 - 날짜형 = 숫자


--add_months(date, number)
--date 기준으로 몇달(number) 전후의 날짜형을 리턴
select sysdate,
       sysdate + 5,
       add_months(sysdate, 1),
       add_months(sysdate, -1),
       add_months(sysdate + 5, 1)
from dual;

--months_between(미래, 과거)
--두 날짜형의 개월 수 차이를 리턴한다.

select sysdate,
       to_date('2021/07/08'),--날짜형 변환 함수
       trunc(months_between(to_date('2021/07/08'),sysdate), 1) diff
from dual;

--이름, 입사일, 근무개월수(n개월), 근무개월수(n년 m개월) 조회
select emp_name,
       hire_date,
       TRUNC(months_between(sysdate, hire_date))||'개월'근무개월수,
       trunc(months_between(sysdate, hire_date)/12)||'년'||
       trunc(mod(months_between(sysdate, hire_date),12))||'개월'근무개월수
from employee;


--extract(year|month|day|hour|minute|second from date):number
--날짜형 데이터에서 특정필드만 숫자형으로 리턴.
select EXTRACT(year from sysdate) yyyy,
       EXTRACT(month from sysdate) mm,--1~12월
       EXTRACT(day from sysdate) dd,
       extract(hour from cast(sysdate as timestamp)) hh,
       extract(minute from cast(sysdate as TIMESTAMP)) mi,
       extract(second from cast(sysdate as TIMESTAMP)) ss
from dual;


--trunc(date)
--시분초 정보를 제외한 년월일 정보만 리턴
select to_char(sysdate, 'yyyy/mm/dd hh24:mi:ss')date1,
       to_char(trunc(sysdate), 'yyyy/mm/dd hh24:mi:ss')date2
from dual;


--*****************************************
--d.형변환함수
--*****************************************
/*

        ------->    -------->
    number      string      date
        <------      <-------
        to_number     to_char
        
*/

--to_char(date|number[,fromat])

select to_char(sysdate, 'yyyy/mm/dd(day) hh24:mi:ss am')now, --yyyy/mm/dd(dy) hh12:mi:ss
       to_char(sysdate, 'fmyyyy/mm/dd(day) hh24:mi:ss am')now, --fm은 형식문자로 인한 앞글자 0을 제거
       to_char(sysdate, 'yyyy"년" mm"월" dd"일"')now
from dual;

select to_char(1234567, 'fmL9,999,999,999')won, --L은 지역화폐
       to_char(1234567, 'fmL9,999')won, --자릿수가 모자라 오류
       to_char(123.4, 'fm999.99'), --소수점이상의 빈자리는 공란, 소수점이하 빈자리는 0처리
       to_char(123.4, 'fm0000.00') --빈자리는 0처리
from dual;

--이름, 급여(3자리 콤마), 입사일(1990-9-3(화))을 조회
select emp_name, 
       to_char(salary, 'fmL9,999,999,999,999'), 
       to_char(hire_date, 'fmyyyy"-"mm"-"dd(dy)')
from employee;


--to_number(string, format)
select to_number('1,234,567', '9,999,999') + 100,
       to_number('￦3,000', 'L9,999') + 100
--       '1,234,567' + 100
from dual;

--자동형변환 지원
select '1000' + 100,
       '99' + '1',
       '99' || '1'
from dual;


--to_date(string, format)
--string이 작성된 형식문자 format으로 전달
select to_date('2020/09/09', 'yyyy/mm/dd') + 1
from dual;

--'2021/07/08 21:50:00'를 2시간후의 날짜 정보를 yyyy/mm/dd hh24:mi:ss형식으로 출력
select to_char(
        to_date('2021/07/08 21:50:00', 'yyyy/mm/dd hh24:mi:ss') + (2 / 24),
        'yyyy/mm/dd hh24:mi:ss'
        )result
from dual;

--현재시각 기준 1일 2시간 3분 4초후의 날짜 정보를 yyyy/mm/dd hh24:mi:ss형식으로 출력
--1시간 : 1 / 24
--1분 : 1 / (24 * 60)
--1초 : 1 / (24 * 60 * 60)
select to_char(
       sysdate + 1 + (2 / 24) + (3 / (24 *60)) + (4 / (24 * 60 * 60)),
       'yyyy/mm/dd hh24:mi:ss'
       ) result
from dual;

--기간타입
--interval year to month : 년월 기간
--interval date to second : 일시분초 기간

--1년 2개월 3일 4시간 5분 6초후 조회
select to_char(
       add_months(sysdate, 14) + 3 + (4/24) + (5/24/60) + (6/24/60/60), 
       'yyyy/mm/dd hh24:mi:ss'
       )result 
from dual;

select to_char(
       sysdate + to_yminterval('01-02') + to_dsinterval('3 04:05:06'),
       'yyyy/mm/dd hh24:mi:ss'
       )result
from dual;

--numtodisinterval(diff, unit)
--numtoyminterval(diff, unit)
--diff : 날짜차이
--unit : year|month|day|hour|minute|second
select extract( day from
        numtodsinterval(
        to_date('20210708', 'yyyymmdd') - sysdate,
        'day'
        ))diff
from dual;

--*****************************************
--e.기타함수
--*****************************************

--null처리 함수
--nvl(col, nullvalue)
--nvl2(col, notnullvalue, nullvalue)
--col값이 null이 아니면 두번째인자를 리턴, null이면 세번째인자를 리턴

select emp_name,
       bonus,
       nvl(bonus, 0) nvl1,
       nvl2(bonus, '있음', '없음') nvl2
from employee;


--선택함수1
--decode(expr, 값1, 결과값1, 값2, 결과값2, .....[, 기본값])
select emp_name,
       emp_no,
       decode(substr(emp_no, 8, 1), '1', '남', '2', '여', '3', '남', '4', '여') gender,
       decode(substr(emp_no, 8, 1), '1', '남', '3', '남', '여') gender
from employee;

--직급코드에 따라서 J1-대표, J2/J3-임원, 나머지는 평사원으로 출력(사원명, 직급코드, 직위)
select emp_name,
       job_code,
       decode(job_code, 'J1', '대표', 'J2', '임원', 'J3', '임원', '평사원') 직위
from employee;

--where절에도 사용가능
--여사원만 조회
select emp_name,
       emp_no,
       decode(substr(emp_no, 8, 1), '1', '남', '3', '남', '여') gender
from employee
where decode(substr(emp_no, 8, 1), '1', '남', '3', '남', '여') = '여';


--선택함수2
--case
/*
type1(decode와 유사)

case표현식
    when 값1 then 결과1
    when 값2 then 결과2
    ....
    [else 기본값]
    end
   
type2

case
    when 조건식1 then 결과1
    when 조건식2 then 결과2
    ....
    [else 기본값]
    end
    
*/
--type1
select emp_no,
       case substr(emp_no, 8, 1)
        when '1' then '남'
        when '3' then '남'
        else '여'
        end gender
from employee;

--직급코드에 따라서 J1-대표, J2/J3-임원, 나머지는 평사원으로 출력(사원명, 직급코드, 직위)
select emp_name,
       job_code,
       case job_code
        when 'J1' then '대표'
        when 'J2' then '임원'
        when 'J3' then '임원'
        else '평사원'
        end job
from employee;

--type2
select emp_no,
       case
        when substr(emp_no, 8, 1) in ('1', '3') then '남'
--        when substr(emp_no, 8, 1) = '1' then '남'
--        when substr(emp_no, 8, 1) = '3' then '남'
        else '여'
        end gender
from employee;

--직급코드에 따라서 J1-대표, J2/J3-임원, 나머지는 평사원으로 출력(사원명, 직급코드, 직위)
select emp_name,
       job_code,
       case 
        when job_code = 'J1' then '대표'
        when job_code in ('J2', 'J3') then '임원'
        else '평사원'
        end job
from employee;


-------------------------------------------
--GROUP FUNCTION
-------------------------------------------
--여러행을 그룹핑하고, 그룹당 하나의 결과를 리턴하는 함수
--모든 행을 하나의 그룹, 또는 group by를 통해서 세부그룹지정이 가능하다.

--sum(col)
select sum(salary),
       sum(bonus),--null인 컬럼은 제외하고 누계처리
       sum(salary + (salary * nvl(bonus, 0))) sum--가공된 컬럼도 그룹함수 가능
from employee;

--select emp_name, sum(salary) --ORA-00937: not a single-group group function
--from employee;
--그룹함수의 결과와 일반컬럼을 동시에 조회할 수 없다.


--avg(col)
--평균
select round(avg(salary), 1) avg,
       to_char(round(avg(salary), 1), 'fml9,999,999,999') avg
from employee;

--부서코드가 D5인 부서원의 평균급여 조회
select to_char(round(avg(salary), 1), 'fml9,999,999,999') avg
from employee
where dept_code = 'D5';

--남자사원의 평균급여 조회
select to_char(round(avg(salary), 1), 'fml9,999,999,999') avg
from employee
where substr(emp_no, 8, 1) in ('1', '3');


--count(col)
--null이 아닌 컬럼의 개수
-- * : 모든 컬럼, 즉 하나의 행을 의미
select count(*),
       count(bonus),--9 bonus컬럼이 null이 아닌 행의 수
       count(dept_code)
from employee;

--보너스를 받는 사원수 조회
select count(*)
from employee
where bonus is not null;

--가상컬럼의 합을 구해서 처리
select sum(
       case
        when bonus is not null then 1
--        when bonus is null then 0--어차피 null은 sum에 포함이 안되기때문에 안써도됨
        end
       )bonusman
from employee;

--사원이 속한 부서 총수(중복없음)
select count(DISTINCT dept_code)
from employee;

--max(col)|min(col)
--숫자, 날짜(과거 -> 미래), 문자(ㄱ -> ㅎ)
select max(salary), min(salary),
       max(hire_date), min(hire_date),
       max(emp_name), min(emp_name)
from employee;


--나이 추출시 주의점
--현재년도 - 탄생년도 + 1 => 한국식 나이
select emp_name,
       emp_no,
       substr(emp_no, 1, 2),
--       extract(year from to_date(substr(emp_no, 1, 2), 'yy')),
--       extract(year from sysdate) - extract(year from to_date(substr(emp_no, 1, 2), 'yy')) + 1
--       extract(year from to_date(substr(emp_no, 1, 2), 'rr')),
--       extract(year from sysdate) - extract(year from to_date(substr(emp_no, 1, 2), 'rr')) + 1
       extract(year from sysdate) -
       (decode(substr(emp_no, 8, 1), '1', 1900, '2', 1900, 2000) + substr(emp_no, 1, 2)) + 1 age
from employee;

--yy는 현재년도 기준으로 현재세기(2000~2099)범위에서 추측한다.
--rr는 현재년도 2021 기준으로 (1950~2049) 범위에서 추측한다.

--=========================================
--DQL2
--=========================================
-------------------------------------------
--GROUP BY
-------------------------------------------
--지정컬럼기준으로 세부적인 그룹핑이 가능하다.
--group by 구문 없이는 전체를 하나의 그룹으로 취급한다.
--group by 절에 명시한 컬럼만 select절에 사용가능하다.
select dept_code,
--       emp_name, --ORA-00979: not a GROUP BY expression
       sum(salary)
from employee
group by dept_code; --일반컬럼 | 가공컬럼이 가능

select job_code,
       trunc(avg(salary),1)
from employee
group by job_code
order by job_code;

--부서코드별 사원수 조회
select nvl(dept_code, 'intern'),
       count(*)
from employee
group by dept_code
order by dept_code;

--부서코드별 사원수, 급여평균, 급여합계 조회
select nvl(dept_code, 'intern'),
       count(*),
       to_char(trunc(avg(salary),1), 'fml9,999,999,999.0') avg,
       to_char(sum(salary), 'fml9,999,999,999') sum
from employee
group by dept_code
order by dept_code;

--성별 인원수, 평균급여 조회
select decode(substr(emp_no, 8, 1), '1', '남', '3', '남', '여') gender,
       count(*) count,
       to_char(trunc(avg(salary), 1), 'fml9,999,999,999.0') avg
from employee
group by decode(substr(emp_no, 8, 1), '1', '남', '3', '남', '여');

--직급코드 J1을 제외하고, 입사년도 별 인원수를 조회
select extract(year from hire_date) yyyy,
       count(*)
from employee
where job_code != 'J1'
group by extract(year from hire_date)
order by yyyy;

--두개 이상의 컬럼으로 그룹핑 가능
select nvl(dept_code, '인턴') dept_code,
       job_code,
       count(*)
from employee
group by dept_code, job_code
order by 1, 2;

--부서별 성별 인원수 조회
select dept_code,
       decode(substr(emp_no, 8, 1), '1', '남', '3', '남', '여') 성별,
       count(*)
from employee
group by dept_code,decode(substr(emp_no, 8, 1), '1', '남', '3', '남', '여')
order by 1, 2;


-------------------------------------------
--HAVING
-------------------------------------------
--group by 이후 조건절

--부서별 평균 급여가 3,000,000원 이상인 부서만 조회
select dept_code,
       trunc(avg(salary)) avg
from employee
--where avg(salary) >= 3000000 --where에는 그룹함수 사용 불가
group by dept_code
having avg(salary) >= 3000000
order by 1;

--직급별 인원수가 3명이상인 직급과 인원수 조회
select job_code, count(*)
from employee
group by job_code
having count(*) >= 3
order by job_code;

--관리하는 사원이 2명이상인 manager의 아이디와 관리하는 사원수 조회
select manager_id,
       count(*)
from employee
where manager_id is not null
group by manager_id
having count(*) >= 2
order by 1;

select manager_id,
       count(*)
from employee
group by manager_id
having count(manger_id) >= 2
order by 1;

--rollup | cube(col1, col2...)
--group by절에 사용하는 함수
--그룹핑 결과에 대해 소계를 제공

--rollup 지정컬럼에 대해 단방향 소계 제공
--cube 지정컬럼에 대해 양방향 소계 제공
--지정컬럼이 하나인 경우, rollup/cube의 결과는 같다.
select dept_code,
       count(*)
from employee
group by rollup(dept_code);

select dept_code,
       count(*)
from employee
group by cube(dept_code)
order by 1;

--grouping()
--실제데이터(0) | 집계데이터(1) 컬럼을 구분하는 함수
--select nvl(dept_code, '인턴'),
--       count(*)
--from employee
--group by rollup(dept_code)
--order by 1;

select decode(grouping(dept_code), 0, nvl(dept_code, '인턴'), 1, '합계') dept_code,
--       grouping(dept_code),
       count(*)
from employee
group by rollup(dept_code)
order by 1;

--두개이상의 컬럼을 rollup | cube에 전달하는 경우
select decode(grouping(dept_code), 0, nvl(dept_code, '인턴'), '합계') dept_code,
       decode(grouping(job_code), 0, job_code, '소계') job_code,
       count(*)
from employee
group by rollup(dept_code, job_code)
order by 1,2;

select decode(grouping(dept_code), 0, nvl(dept_code, '인턴'), '소계') dept_code,
       decode(grouping(Job_code), 0, job_code, '소계') job_code,
       count(*)
from employee
group by cube(dept_code, job_code)
order by 1,2;

/*

select (5)
from (1)
where (2)
group by (3)
having (4)
order by (6)

*/


--relation 만들기
--가로방향 합치기 JOIN 행 + 행
--세로방향 합치기 UNION 열 + 열
--=========================================
--JOIN
--=========================================
--두개 이상의 테이블을 연결해서 하나의 가상테이블(relation)을 생성
--기준컬럼을 가지고 행을 연결한다.

--송종기 사원의 부서명을 조회
select dept_code -- D9
from employee
where emp_name = '송종기';

select dept_title --총무부
from department
where dept_id = 'D9';

--join
select D.dept_title
from employee E join department D
    on E.dept_code = D.dept_id
where E.emp_name = '송종기';
    
select * from employee;
select * from department;

--join 종류
--1. EQUL-JOIN 동등비교조건(=)에 의한 조인
--2. NON-EQUL JOIN 동등비교조건이 아닌(between and, in, not in, !=)조인

--join 문법
--1. ANSI 표준문법 : 모든 DBMS 공통문법. join키워드
--2. Vendor별 문법 : DBMS별로 지원하는 문법. 오라클전용문법 ,(컴마) 사용


--테이블 별칭
select emp_name,
--        job_code, --ORA-00918: column ambiguously defined
        employee.job_code,
        job_name
from employee join job
    on employee.job_code = job.job_code;
    
select E.emp_name,
        J.job_code,
        J.job_name
from employee E join job J
    on E.job_code = J.job_code;
    
--기준컬럼명이 좌우테이블에서 동일하다면, on 대신 using 사용가능
--using을 사용한 경우는 해당컬럼에 별칭을 사용할 수 없다.
select E.emp_name,
--        E.job_code --ORA-25154: column part of USING clause cannot have qualifier
        job_code, --별칭을 사용할 수 없다
        J.job_name
from employee E join job J
    using(job_code);
    
select * from employee;
select * from job;


--equi-join 종류
/*
1. inner join 교집합

2. outer join 합집합
    -left outer join 좌측테이블 기준 합집합
    -right outer join 우측테이블 기준 합집합
    -full outer join 양테이블 기준 합집합

3. cross join
    두 테이블 간의 조인할 수 있는 최대경우의 수를 표현

4. self join
    같은 테이블의 조인

5. multiple join
    3개이상의 테이블을 조인

*/

-------------------------------------------
--INNER JOIN
-------------------------------------------
--A (inner) join B
--교집합
--1. 기준컬럼값이 null인 경우, 결과집합에서 제외.
--2. 기준컬럼값이 상대테이블에 존재하지 않는 경우, 결과집합에서 제외.

--1. employee에서 dept_code가 null인 행 제외
--2. department에서 dept_id가 D3, D4, D7인 행은 제외
select *
from employee E join department D
    on E.dept_code = D.dept_id;
--22

--(oracle)
select *
from employee E, department D
where E.dept_code = D.dept_id and E.dept_code = 'D5';


select *
from employee E join job J
    on E.job_code = J.job_code;
--(oracle)
select *
from employee E, job J
where E.job_code = J.job_code;
    
    
-------------------------------------------
--OUTER JOIN
-------------------------------------------
--1. left (outer) join
--좌측테이블 기준
--좌측테이블 모든 행이 포함, 우측테이블에는 on조건절에 만족하는 행만 포함.
--24 = 22 + 2(left)
select *
from employee E left outer join department D
    on E.dept_code = D.dept_id;
    
--(oracle)
--기준테이블의 반대편 컬럼에 (+)를 추가
select *
from employee E, department D
where E.dept_code = D.dept_id(+);
    
--2. right (outer) join
--우측테이블 기준
--우측테이블 모든 행이 포함, 좌측테이블에는 on조건절에 만족하는 행만 포함.
--25 = 22 + 3(right)
select *
from employee E right join department D
    on E.dept_code = D.dept_id;
    
--(oracle)
select *
from employee E, department D
where E.dept_code(+) = D.dept_id;
    
--3. full (outer) join
--완전 조인.
--좌우 테이블 모두 포함
--27 = 22 + 2(left) + 3(right)
select *
from employee E full join department D
    on E.dept_code = D.dept_id;
    
--(oracle)에서는 full outer join을 지원하지 않는다.
    
--사원명/부서명 조회시
--부서지정이 안된 사원은 제외 : inner join
--부서지정이 안된 사원도 포함 : left join
--사원배정이 안된 부서도 포함 : right join


-------------------------------------------
--CROSS JOIN
-------------------------------------------
--상호조인.
--on조건절 없이, 좌측테이블 행과 우측테이블의 행이 연결될 수 있는 모든 경우의 수를 포함한 결과집합.
--Cartesian's Product
--216 = 24 * 9
select *
from employee E cross join department D;

--(oracle)
select *
from employee E, department D;

--일반 컬럼, 그룹함수결과를 함께 조회.
select trunc(avg(salary))
from employee;

select emp_name, 
        salary, 
        avg, 
        salary - avg diff
from employee E cross join (select trunc(avg(salary)) avg
                            from employee) A;
                            
                            
-------------------------------------------
--SELF JOIN
-------------------------------------------
--조인시 같은 테이블을 좌/우측 테이블로 사용.

-- 사번, 사원명, 관리자사번, 관리자명 조회
select E1.emp_id,
        E1.emp_name,
        E1.manager_id,
        E2.emp_id,
        E2.emp_name
from employee E1 join employee E2
    on E1.manager_id = E2.emp_id;
    
--(oracle)
select E1.emp_id,
        E1.emp_name,
        E1.manager_id,
        E2.emp_name
from employee E1, employee E2
where E1.manager_id = E2.emp_id;


-------------------------------------------
--MULTIPLE JOIN
-------------------------------------------
--한번에 좌우 두 테이블씩 조인하여 3개이상의 테이블을 연결함.

--사원명, 부서명, 지역명, 직급명
select * from employee; --E.dept_code
select * from department; --D.dept_id, D.location_id
select * from location; --L.local_code

select E.emp_name,
        D.dept_title,
        L.local_name,
        J.job_name
from employee E
    join job J
        on E.job_code = J.job_code
    join department D
        on E.dept_code = D.dept_id
    join location L
        on D.location_id = L.local_code;

select E.emp_name,
        D.dept_title,
        L.local_name,
        J.job_name
from employee E
   left join job J
        on E.job_code = J.job_code
   left join department D
        on E.dept_code = D.dept_id
   left join location L
        on D.location_id = L.local_code;
--where E.emp_name = '송종기';

--조인하는 순서를 잘 고려할 것.
--left join으로 시작했으면, 끝까지 유지해줘야 데이터가 누락되지 않는 경우가 있다.

--(oracle)
select *
from employee E, department D, location L, job J
where E.dept_code = D.dept_id
    and D.location_id = L.local_code
    and E.job_code = J.job_code;
    
select *
from employee E, department D, location L, job J
where E.dept_code = D.dept_id(+)
    and D.location_id = L.local_code(+)
    and E.job_code = J.job_code;

--직급이 대리, 과장이면서 ASIA지역에서 근무하는 사원 조회
--사번, 이름, 직급명, 부서명, 급여, 근무지역, 국가
select E.emp_id,
        E.emp_name,
        J.job_name,
        D.dept_title,
        E.salary,
        L.local_name,
        N.national_name
from employee E
    join job J
        on E.job_code = J.job_code
    join department D
        on E.dept_code = D.dept_id
    join location L
        on D.location_id = L.local_code
    join nation N
        on L.national_code = N.national_code
where J.job_name in ('대리', '과장')
    and L.local_name like 'ASIA%';
    
--(oracle)
select *
from employee E, job J, department D, location L, nation N
where E.job_code = J.job_code
    and E.dept_code = D.dept_id
    and D.location_id = L.local_code
    and L.national_code = N.national_code
    and J.job_name in ('대리', '과장')
    and L.local_name like 'ASIA%';


-------------------------------------------
--NON-EQUI JOIN
-------------------------------------------
--employee, sal_grade테이블을 조인
--employee테이블의 sal_level컬럼이 없다고 가정.
--employee.salary컬럼과 sal_grade.min_sal|sal_grade.max_sal을 비교해서 join

select * from employee;
select * from sal_grade;

select *
from employee E
    join sal_grade S
        on E.salary between S.min_sal and S.max_sal;
    
--조인조건절에 따라 1행에 여러행이 연결된 결과를 얻을 수 있다.    
select *
from employee E
    join department D
        on E.dept_code != D.dept_id
order by E.emp_id, D.dept_id;



--=========================================
--SET OPERATOR
--=========================================
--집합 연산자. entity를 컬럼수가 동일하는 조건하에 상하로 연결한 것.

--select절의 컬럼수가 동일.
--컬럼별 자료형이 상호호환 가능해야 한다. 문자형(char, varchar2)끼리 OK, 날짜형 + 문자열 ERROR
--컬럼명이 다른 경우, 첫번째 entity의 컬럼명을 결과집합에 반영
--order by는 마지막 entity에서 딱 한번만 사용가능

--union 합집합
--union all 합집합
--intersect 교집합
--minus 차집합

/*
A = {1,3,2,5}
B = {2,4,6}

A union B       => {1,2,3,4,5,6} 중복제거, 첫번째 컬럼 기준 오름차순 정렬
A union all B   => {1,3,2,5,2,4,6}
A intersect B   => {2}
A minus B       => {1,3,5}
*/

-------------------------------------------
--UNION | UNION ALL
-------------------------------------------
--A D5 부서원의 사번, 사원명, 부서코드, 급여
select emp_id, emp_name, dept_code, salary
from employee
where dept_code = 'D5';

--B : 급여가 300만이 넘는 사원조회(사번, 사원명, 부서코드, 급여)
select emp_id, emp_name, dept_code, salary
from employee
where salary > 3000000;

--A UNION B
select emp_id, emp_name, dept_code, salary
from employee
where dept_code = 'D5'
--order by는 마지막 entity에서만 사용가능
union
select emp_id, emp_name, dept_code, salary
from employee
where salary > 3000000
order by dept_code;

--A UNION ALL B
select emp_id, emp_name, dept_code, salary
from employee
where dept_code = 'D5'
union all
select emp_id, emp_name, dept_code, salary
from employee
where salary > 3000000;

-------------------------------------------
--INTERSECT | MINUS
-------------------------------------------
--A INTERSECT B
select emp_id, emp_name, dept_code, salary
from employee
where dept_code = 'D5'
intersect
select emp_id, emp_name, dept_code, salary
from employee
where salary > 3000000;

--A MINUS B
select emp_id, emp_name, dept_code, salary
from employee
where dept_code = 'D5'
minus
select emp_id, emp_name, dept_code, salary
from employee
where salary > 3000000;

select emp_id, emp_name, dept_code, salary
from employee
where salary > 3000000
minus
select emp_id, emp_name, dept_code, salary
from employee
where dept_code = 'D5';


--=========================================
--SUB QUERY
--=========================================
--하나의 sql문(main-query)안에 종속된 또다른 sql문(sub-query)
--존재하지 않는 값, 조건에 근거한 검색등을 실행할 때.

--반드시 소괄호로 묶어서 처리할 것.
--sub-query내에는 order by문법지원 안함.
--연산자 오른쪽에서 사용할 것. where col = ()

--노옹철사원의 관리자 이름을 조회
select E1.emp_id,
       E1.emp_name,
       E1.manager_id,
       E2.emp_name
from employee E1
    join employee E2
        on E1.manager_id = E2.emp_id
where E1.emp_name = '노옹철';

--1. 노옹철사원행의 manager_id 조회
--2. emp_id가 조회한 manager_id와 동일한 행의 emp_name을 조회
select manager_id
from employee
where emp_name = '노옹철';

select emp_name
from employee
where emp_id = '201';

select emp_name
from employee
where emp_id = (select manager_id
                from employee
                where emp_name = '노옹철');
                
/*
리턴값의 개수에 따른 분류
1.단일행 단일컬럼 서브쿼리
2.다중행 단일컬럼 서브쿼리
3.다중열 서브쿼리(단일행/다중행)

4.상관서브쿼리 <-----> 일반서브쿼리
5.스칼라 서브쿼리 (select절에 사용한다)

6.inline-view
*/
-------------------------------------------
--단일행 단일컬럼 서브쿼리
-------------------------------------------
--서브쿼리 조회결과가 1행1열인 경우

--(전체평균급여)보다 많은 급여를 받는 사원 조회
select emp_name, 
       salary,
       trunc((select avg(salary)
                from employee)) avg
from employee
where salary > (select avg(salary)
                from employee);

--윤은해 사원과 같은 급여를 받는 사원 조회(사번, 이름, 급여)
select emp_id, emp_name, salary
from employee
where salary = (
                select salary
                from employee
                where emp_name = '윤은해'
            )
    and emp_name != '윤은해';
    
--D1, D2부서원 중에 D5부서의 평균급여보다 많은 급여를 받는 사원 조회(부서코드, 사번, 사원명, 급여)
select dept_code, emp_id, emp_name, salary
from employee
where dept_code in ('D1', 'D2')
    and salary > (
                select avg(salary)
                from employee
                where dept_code = 'D5'
            );
            
            
-------------------------------------------
--다중행 단일컬럼 서브쿼리
-------------------------------------------
--연산자 in|not in|any|all|exists 와 함께 사용가능한 서브쿼리

--송중기, 하이유 사원이 속한 부서원 조회
select emp_name, dept_code
from employee
where dept_code in (
                    select dept_code
                    from employee
                    where emp_name in ('송종기', '하이유')
                );
                
--차태연, 전지연사원의 급여등급(sal_level)과 같은 사원 조회(사원명, 직급명, 급여등급 조회)
select emp_name, job_name, sal_level
from employee
    join job
        using(job_code)
where sal_level in (
                    select sal_level
                    from employee
                    where emp_name in ('차태연', '전지연')
                )
    and emp_name not in ('차태연', '전지연');
    
--직급명(job.job_name)이 대표, 부사장이 아닌 사원조회(사번, 사원명, 직급코드)
select emp_id, emp_name, job_code
from employee E
where e.job_code not in (
                         select job_code
                         from job
                         where job_name in ('대표', '부사장')
                    );
                
--ASIA1지역에 근무하는 사원 조회(사원명, 부서코드)
--location.local_name : ASIA1
--department.location_id --- location.local_code
--employee.dept_code --- department.dept_id
select local_code
from location
where local_name = 'ASIA1';
                
select dept_id
from department
where location_id = 'L1';

select *
from employee
where dept_code in ('D1', 'D2', 'D3', 'D4', 'D9');

select emp_name, dept_code
from employee
where dept_code in (
                    select dept_id
                    from department
                    where location_id = (
                                         select local_code
                                         from location
                                         where local_name = 'ASIA1'
                                    )
                );
                

-------------------------------------------
--다중열 서브쿼리
-------------------------------------------
--서브쿼리의 리턴된 컬럼이 여러개인 경우.

--퇴사한 사원과 같은 부서, 같은 직급의 사원 조회(사번, 부서코드, 직급코드)
select dept_code, job_code
from employee
where quit_yn = 'Y';

select emp_name, dept_code, job_code
from employee
where dept_code = 'D8'
    and job_code = 'J6';
    
select emp_name, dept_code, job_code
from employee
where dept_code = (
                    select dept_code
                    from employee
                    where quit_yn = 'Y'
                )
    and job_code = (
                    select job_code
                    from employee
                    where quit_yn = 'Y'
                );

select emp_name, dept_code, job_code
from employee
where (dept_code, job_code) = (
                                select dept_code, job_code
                                from employee
                                where quit_yn = 'Y'
                            );
                        
--manager가 존재하지 않는 사원과 같은 부서코드, 직급코드를 가진 사원 조회
--in 연산자는 다중행 다중컬럼 처리 가능
select emp_name, dept_code, job_code
from employee
where (nvl(dept_code, 'D0'), job_code) in (
                                select nvl(dept_code, 'D0'), job_code
                                from employee
                                where manager_id is null
                            );
                            
--부서별 최대급여를 받는 사원 조회(사원명, 부서코드, 급여)
select emp_name, nvl(dept_code, '인턴'), salary
from employee
where (nvl(dept_code, 'D0'), salary) in (
                                select nvl(dept_code, 'D0'), max(salary)
                                from employee
                                group by dept_code
                            )
order by dept_code;

-------------------------------------------
--상관 서브쿼리
-------------------------------------------
--상호연관 서브쿼리.
--메인쿼리의 값을 서브쿼리에 전달하고, 서브쿼리 수행후 결과를 다시 메인쿼리에 반환.

--직급별 평균급여보다 많은 급여를 받는 사원 조회
--join으로 처리
select emp_name, salary
from employee E 
    join(
         select job_code, avg(salary) avg
         from employee
         group by job_code
    ) EA
    using(job_code)
where E.salary > EA.avg
order by job_code;

--상관서브쿼리로 처리
select emp_name, job_code, salary
from employee E --메인쿼리 테이블 별칭이 반드시 필요
where salary > (
                select avg(salary)
                from employee
                where job_code = E.job_code
            );
            
--부서별 평균급여보다 적은 급여를 받는 사원 조회(인턴포함)
select emp_name, dept_code, salary
from employee E
where E.salary < (
                  select avg(salary)
                  from employee
                  where nvl(dept_code, 'D0') = nvl(E.dept_code, 'D0')
            );
                  
--exists 연산자
--exists(sub-query) sub-query에 행이 존재하면 참, 행이 존재하지 않으면 거짓
select *
from employee
where 1 = 1; --true 결과행이 존재한다.

select *
from employee
where 1 = 0; --false 결과행이 존재하지 않는다.

--행이 존재하는 subquery
select *
from employee
where exists(
             select *
             from employee
             where 1 = 1
        );
        
--행이 존재하지 않는 subquery : exists false
select *
from employee
where exists(
             select *
             from employee
             where 1 = 0
        );

--관리하는 직원이 한명이라도 존재하는 관리자사원 조회!
--내 emp_id값이 누군가의 manager_id로 사용된다면, 나는 관리자!
--내 emp_id값이 누군가의 manager_id로 사용되지 않는다면, 나는 관리자가 아님!
select emp_id, emp_name
from employee E
where exists(
             select *
             from employee
             where manager_id = E.emp_id
         );

select *
from employee E;

select *
from employee
where manager_id = '203';

--부서테이블에서 실제 사원이 존재하는 부서만 조회(부서코드, 부서명)
select dept_id, 
       dept_title
from department D
where exists (
              select 1
              from employee
              where D.dept_id = dept_code
            );

select * from department D;

select 1
from employee
where dept_code = 'D3';

--부서테이블에서 실제 사원이 존재하는 부서만 조회(부서코드, 부서명)
--not exists(sub-query) : 
--sub-query의 결과행이 존재하지 않으면 true,sub-query의 결과행이 존재하면 false
select dept_id, 
       dept_title
from department D
where not exists (
              select 1
              from employee
              where D.dept_id = dept_code
            );
            
--최대/최소값 구하기(not exists)
--가장 많은 급여를 받는 사원을 조회
--가장 많은 급여를 받는다 -> 본인보다 많은 급여를 받는 사원이 존재하지 않는다.
select emp_name, salary
from employee E
where not exists (
                  select *
                  from employee
                  where salary > E.salary
                );


-------------------------------------------
--SCALA SUBQUERY
-------------------------------------------
--서브쿼리의 실행결과가 1(단일행 단일컬럼)인 select절에 사용된 상관서브쿼리

--관리자이름 조회
select emp_name,
       (
        select emp_name
        from employee
        where emp_id = E.manager_id
       ) manager_name
from employee E;

--사원명, 부서명, 직급명 조회
select emp_name,
       nvl((
        select dept_title
        from department
        where dept_id = E.dept_code
       ), '인턴') 부서명,
       (
        select job_name
        from job
        where E.job_code = job_code
       ) 직급명
from employee E;


-------------------------------------------
--INLINE VIEW
-------------------------------------------
--from절에 사용된 subquery. 가상테이블.

--여사원의 사번, 사원명, 성별 조회
select emp_id,
       emp_name,
       decode(substr(emp_no, 8, 1), '1', '남', '3', '남', '여') gender
from employee
where decode(substr(emp_no, 8, 1), '1', '남', '3', '남', '여') = '여';

select * --emp_id, emp_name, gender
from(
     select emp_id,
            emp_name,
            decode(substr(emp_no, 8, 1), '1', '남', '3', '남', '여') gender
     from employee
    )
where gender = '여';

--30~50세 사이의 여사원 조회(사번, 이름, 부서명, 나이, 성별)
--inline-view 나이, 성별
select *
from (
        select emp_id,
               emp_name,
               (select dept_title
                from department
                where dept_id = E.dept_code
               ) 부서명,
               extract(year from sysdate) -
               (decode(substr(emp_no, 8, 1), '1', '1900', '2', '1900', '2000') + 
               substr(emp_no, 1, 2)) + 1 나이,
               decode(substr(emp_no, 8, 1), '1', '남', '3', '남', '여') 성별
        from employee E
    )
where age between 30 and 50
    and gender = '여';

select *
from (
            select emp_id, 
                        emp_name,
                        nvl((select dept_title from department where dept_id = E.dept_code), '인턴') dept_title,
                        extract(year from sysdate) -
                        (decode(substr(emp_no, 8, 1), '1', 1900, '2', 1900, 2000) + substr(emp_no, 1, 2)) + 1 age,
                        decode(substr(emp_no, 8, 1), '1', '남', '3', '남', '여') gender
            from employee E
        ) 
where age between 30 and 50 
    and gender = '여';
    


--=========================================
--고급쿼리
--=========================================

-------------------------------------------
--TOP-N 분석
-------------------------------------------
--급여를 많이 받는 Top-5, 입사일이 가장 최근인 Top_10조회등
select emp_name, salary
from employee
order by salary desc;

--rownum | rowid
--rownum : 테이블에 레코드 추가시 1부터 1씩 증가하면서 부여된 일련번호. 부여된 번호는 변경불가.
--          inlineview생성시, where절 사용시 rownum은 새로 부여된다.
--rowid : 테이블 특정 레코드에 접근하기 위한 논리적 주소값
select rownum,
       rowid,
       E.*
from employee E
order by salary desc;

--where절 사용시 rownum 새로 부여
select rownum, E.*
from employee E
where dept_code = 'D5';

select rownum, E.*
from (
        select 
        --       rownum old,
               emp_name, 
               salary
        from employee
        order by salary desc
    ) E
where rownum between 1 and 5;

--입사일이 빠른 10명 조회
select rownum, E.*
from (
        select emp_name,
               hire_date
        from employee
        order by hire_date
    ) E
where rownum between 1 and 10;

--입사일이 빠른 순서로 6번째에서 10번째 사원 조회
--rownum은 where절이 시작하면서 부여되고, where절이 끝나면 모든행에 대해 부여가 끝난다.
--offset이 있다면, 정상적으로 가져올 수 없다.
--inlineview를 한계층 더 사용해야 한다.
select E.*
from (
        select rownum rnum, E.*
        from (
                select emp_name,
                       hire_date
                from employee
                order by hire_date
            ) E
    ) E
where rnum between 6 and 10;

--직급이 대리인 사원중에 연봉 Top-3 조회(순위, 이름, 연봉)
select rownum, 
            E.*
from (
        select emp_name,
                    (salary + (salary * nvl(bonus, 0))) * 12 annual_salary
        from employee
        where job_code = (  
                            select job_code
                            from job
                            where job_name = '대리'
                                        )
        order by annual_salary desc
        ) E
where rownum between 1 and 3;

select E.*
from (
        select rownum rnum, 
                    E.*
        from (
                select emp_name,
                            (salary + (salary * nvl(bonus, 0))) * 12 annual_salary
                from employee
                where job_code = (  
                                    select job_code
                                    from job
                                    where job_name = '대리'
                                                )
                order by annual_salary desc
                ) E
        ) E
where rnum between 4 and 6;

--부서별 평균급여 Top-3 조회(순위, 부서명, 평균급여)
select rownum, E.*
from (
        select dept_code,
                    trunc(avg(salary)) avg
        from employee
        group by dept_code
        order by avg desc
        ) E
where rownum between 1 and 3;

select E.*
from (
        select rownum rnum, E.*
        from (
                select --nvl(dept_code, '인턴') dept_code,
                            nvl((
                                    select dept_title 
                                    from department D 
                                    where dept_id = E.dept_code
                                  ), '인턴') dept_title, 
                            trunc(avg(salary)) avg
                from employee E
                group by dept_code
                order by avg desc
                ) E
         ) E
where rnum between 4 and 6;

/*
select E.*
from (
        select rownum rnum, e.*
        from (
                <<정렬된 ResultSet>>
            ) E
        )E
where rnum between 시작 and 끝;
*/

--with구문
--inlineview서브쿼리에 별칭을 지정해서 재사용하게 함.
with emp_hire_date_asc
as
(
select emp_name,
       hire_date
from employee
order by hire_date asc
)
select E.*
from (
        select rownum rnum, E.*
        from emp_hire_date_asc E
    ) E        
where rnum between 6 and 10;


-------------------------------------------
--WINDOW FUNCTION
-------------------------------------------
--행과 행간의 관계를 쉽게 정의하기 위한 표준함수
--1. 순위함수
--2. 집계함수
--3. 분석함수

/*
window_function(args) over([partition by절][order by절][windowing절])

1. args 윈도우함수 인자 0 ~ n개 지정
2. partition by절 : 그룹핑 기준 컬럼
3. order by절 : 정렬기준 컬럼
4. windowing절 : 처리할 행의 범위를 지정.
*/

--rank() over() : 순위를 지정
--dense_rank() over() : 빠진 숫자 없이 순위를 지정
select emp_name,
        salary,
        rank() over(order by salary desc) rank,
        dense_rank() over(order by salary desc) rank
from employee;

--그룹핑에  따른 순위 지정
select E.*
from (
        select emp_name,
                dept_code,
                salary,
                rank() over(partition by dept_code order by salary desc) rank_by_dept
        from employee
    )E
where rank_by_dept between 1 and 3;

--sum() over()
--일반 컬럼과 같이 사용할 수 있다.
select emp_name,
        salary,
        dept_code,
--        (select sum(salary) from employee) sum,
--        sum(salary)
        sum(salary) over() "전체사원급여합계",
        sum(salary) over(partition by dept_code) "부서별 급여합계",
        sum(salary) over(partition by dept_code order by salary) "부서별 급여누계_급여"
from employee;

--avg() over()
select emp_name,
        dept_code,
        salary,
        trunc(avg(salary) over(partition by dept_code)) "부서별 평균 급여"
from employee;

--count() over()
select emp_name,
        dept_code,
        count(*) over(partition by dept_code) cnt_by_dept
from employee;



--=========================================
--DML
--=========================================
--Data Manipulation Language 데이터 조작어
--CRUD Create Retreive Update Delete 테이블 행에 대한 명령어
--insert 행추가
--update 행수정
--delete 행삭제
--select (DQL)


-------------------------------------------
--INSERT
-------------------------------------------
--1. insert into 테이블 values(컬럼1값, 컬럼2값, ...); 모든 컬럼을 빠짐없이 순서대로 작성해야 함.
-- 모든 컬럼을 빠짐없이 순서대로 작성해야 함.
--2. insert into 테이블(컬럼1, 컬럼2, ...) values(컬럼1값, 컬럼2값, ...)
-- 컬럼을 생략가능
-- not null컬럼이면서, 기본값이 없다면 생략이 불가하다.

create table dml_sample(
    id number,
    nick_name varchar2(100) default '홍길동',
    name varchar2(100) not null,
    enroll_date date default sysdate not null
);

select * from dml_sample;

--타입1
insert into dml_sample
values (100,default, '신사임당', default);

insert into dml_sample
values (100,default, '신사임당'); --SQL 오류: ORA-00947: not enough values

insert into dml_sample
values (100, default, '신사임당', default, 'ㅋㅋ'); --QL 오류: ORA-00913: too many values

--타입2
insert into dml_sample (id, nick_name, name, enroll_date)
values(200, '제임스', '이황', sysdate);

insert into dml_sample (name, enroll_date)
values('세종', sysdate); --nullable한 컬럼은 생략가능하다. 기본값이 있다면, 기본값이 적용된다.

--not null이면서 기본값이 지정안된 경우 생략할 수 없다.
insert into dml_sample (id, enroll_date)
values(300, sysdate); --ORA-01400: cannot insert NULL into ("KH"."DML_SAMPLE"."NAME")

insert into dml_sample (name)
values('윤봉길');

--서브쿼리를 이용한 insert

create table emp_copy
as
select * 
from employee
where 1 = 2; --테이블 구조만 복사해서 테이블을 생성

select * from emp_copy;

insert into emp_copy (
    select *
    from employee
);
rollback;

insert into emp_copy(emp_id, emp_name, emp_no, job_code, sal_level)(
    select emp_id, emp_name, emp_no, job_code, sal_level
    from employee
);


--emp_copy데이터 추가
select * from emp_copy;

--기본값 확인 data_default
select *
from user_tab_cols
where table_name = 'EMP_COPY';

--기본값 추가
alter table emp_copy
modify quit_yn default 'N'
modify hire_date default sysdate;

--insert all을 이용한 여러테이블에 동시에 데이터 추가
--서브쿼리를 이용해서 2개이상 테이블에 데이터를 추가. 조건부 추가도 가능
--입사일 관리 테이블
create table emp_hire_date
as
select emp_id, emp_name, hire_date
from employee
where 1 = 2;

--매니저 관리 테이블
create table emp_manager
as
select emp_id, 
        emp_name, 
        manager_id, 
        emp_name manager_name
from employee
where 1 = 2;

select * from emp_hire_date;
select * from emp_manager;

--manager_name을 null로 변경
alter table emp_manager
modify manager_name null;

--from테이블과 to테이블의 컬럼명이 같아야한다.
insert all
into emp_hire_date values(emp_id, emp_name, hire_date)
into emp_manager values(emp_id, emp_name, manager_id, manager_name)
select E.*,
        (select emp_name from employee where emp_id = E.manager_id) manager_name
from employee E;


--insert all을 이용한 여러행 한번에 추가하기
--오라클에서 다음 문법은 지원하지 않는다.
--insert into dml_smaple 
--values(1, '치킨', '홍길동'),(2, '고구마', '장발장'),(3, '베베', '유관순');
insert all 
into dml_sample values(1, '치킨', '홍길동', default)
into dml_sample values(2, '고구마', '장발장', default)
into dml_sample values(3, '베베', '유관순', default)
select * from dual; --더미 쿼리


-------------------------------------------
--UPDATE
-------------------------------------------
--update실행후에 행의 수에는 변화가 없다.
--0행, 1행이상을 동시에 수정한다.
--dml은 처리된 행의 수를 반환.
drop table emp_copy;

create table emp_copy 
as
select * 
from employee;

select * from emp_copy;

update emp_copy
set dept_code = 'D8'
where emp_id = '202';

update emp_copy
set dept_code = 'D7', job_code = 'J3'
where emp_id = '202';

commit; --메모리상 변경내역을 실제파일에 저장
rollback; --마지막커밋시점을 돌리기

update emp_copy
set salary = salary + 500000 -- += 복합대입연산자 사용불가
where dept_code = 'D5';

--서브쿼리를 이용한 update
--방명수 사원의 급여를 유재식사원과 동일하게 수정

update emp_copy
set salary = (select salary from emp_copy where emp_name = '유재식')
where emp_name = '방명수';

--임시환 사원의 직급을 과장, 부서를 해외 영업3부로 수정하세요.
--emp_copy

update emp_copy
set job_code = (select job_code from job where job_name = '과장'),
    dept_code = (select dept_id from department where dept_title = '해외영업3부')
where emp_name = '임시환';

commit;
rollback;

update emp_copy
set emp_name = '홍길동';

select * from emp_copy;


-------------------------------------------
--DELETE
-------------------------------------------
select * from emp_copy;

--delete from emp_copy
--where emp_id = '211';

--delete from emp_copy;
rollback;

-------------------------------------------
--TRUNCATE
-------------------------------------------
--테이블의 행을 자르는 명령어. 
--DDL 명령어(create, alter, drop, truncate). 자동커밋.
--before image생성 작업이 없으므로, 실행속도가 빠름.
--오늘의 교훈 : DML과 섞어쓰지말자!!

truncate table emp_copy;

select * from emp_copy;

insert into emp_copy
(select * from employee);



--=========================================
--DDL
--=========================================
--Data Definition Language 데이터 정의어
--데이터베이스 객체를 생성/수정/삭제할 수 있는 명령어
--create
--alter
--drop
--truncate

--객체 종류
--table, view, sequence, index, package, procedure, function, trigger, synonym, scheduler, user...

--주석 comment
--테이블, 컬럼에 대한 주석을 달 수 있다.(필수)
select *
from user_tab_comments;

select *
from user_col_comments
where table_name = 'TBL_FILES';

dsec tbl_files;

--테이블 주석
comment on table tbl_files is '파일경로테이블';

--컬럼 주석
comment on column tbl_files.fileno is '파일 고유번호';
comment on column tbl_files.filepath is ''; -- '' : null과 동일

--수정/삭제 명령은 없다.
--.... is ''; --삭제

--=========================================
--제약조건 CONSTRAINT
--=========================================
--테이블 생성 수정시 컬럼값에 대한 제약조건 성정할 수 있다.
--데이터에 대한 무결성 integrity을 보장하기 위한 것.
--무결성은 데이터를 정확하고, 일관되게 유지하는 것

/*
1. not null : null을 허용하지 않음. 필수값
2. unique : 중복값을 허용하지 않음.
3. primary key : not null + unique 레코드 식별자로써, 테이블당 1개 허용
4. foreign key : 데이터 참조무결성 보장. 부모테이블의 데이터만 허용.
5. check : 저장가능한 값의 범위/조건을 제한

일절 허용하지 않음.
*/

--제약 조건 확인
--user_constraints(컬럼명이 없음)
--user_cons_columns
select *
from user_constraints
where table_name = 'EMPLOYEE';

--C check | not null
--U unique
--P primary key
--R foreign key
select *
from user_cons_columns
where table_name = 'EMPLOYEE';

--제약조건 검색
select constraint_name,
        uc.table_name,
        ucc.column_name,
        uc.constraint_type,
        uc.search_condition
from user_constraints uc
    join user_cons_columns ucc
        using(constraint_name)
where uc.table_name = 'EMPLOYEE';

-------------------------------------------
--NOT NULL
-------------------------------------------
--필수입력 컬럼에 not null 제약조건을 지정한다.
--default값 다음에 컬럼레벨에 작성한다.
--보통 제약조건명을 지정하지 않는다.
create table tb_cons_nn (
    id varchar2(20) not null, --컬럼레벨
    name varchar2(100)
    --테이블레벨
);
insert into tb_cons_nn values (null, '홍길동'); --ORA-01400: cannot insert NULL into ("KH"."TB_CONS_NN"."ID")
insert into tb_cons_nn values ('honggd', '홍길동');

select * from tb_cons_nn;
update tb_cons_nn
set id = ''
where id = 'honggd'; --ORA-01407: cannot update ("KH"."TB_CONS_NN"."ID") to NULL


-------------------------------------------
--UNIQUE
-------------------------------------------
--이메일, 주민번호, 닉네임
--전화번호는 UQ사용하지 말것.
--중복 허용하지 않음
create table tb_cons_uq (
    no number not null,
    email varchar2(50),
    --테이블레벨
    constraint uq_email unique(email)
);

insert into tb_cons_uq values(1, 'abc@naver.com');
insert into tb_cons_uq values(2, '가나다@naver.com');
insert into tb_cons_uq values(3, 'abc@naver.com'); --ORA-00001: unique constraint (KH.UQ_EMAIL) violated
insert into tb_cons_uq values(4, null); --null 허용

select * from tb_cons_uq;


-------------------------------------------
--PRIMARY KEY
-------------------------------------------
--레코드(행) 식별자
--not null + unique기능을 가지고 있으며, 테이블당 한개만 설정 가능

create table tb_cons_pk (
    id varchar2(50),
    name varchar2(100) not null,
    email varchar2(200),
    constraint pk_id primary key(id),
    constraint uq_email2 unique(email)
);

insert into tb_cons_pk
values('honggd', '홍길동', 'hgd@google.com');

insert into tb_cons_pk
values(null, '홍길동', 'hgd@google.com'); --ORA-01400: cannot insert NULL into ("KH"."TB_CONS_PK"."ID")

select constraint_name,
        uc.table_name,
        ucc.column_name,
        uc.constraint_type,
        uc.search_condition
from user_constraints uc
    join user_cons_columns ucc
        using(constraint_name)
where uc.table_name = 'TB_CONS_PK';

--복합 기본키(주키 | primary key | pk)
--여러컬럼을 조합해서 하나의 PK로 사용.
--사용된 컬럼 하나라도 null이어서는 안된다.
create table tb_order_pk (
    user_id varchar2(50),
    order_date date,
    amount number default 1 not null,
    constraint pk_order_user_id_order_date primary key(user_id, order_date)
);

insert into tb_order_pk
values('honggd', sysdate, 3);

insert into tb_order_pk
values(null, sysdate, 3); --ORA-01400: cannot insert NULL into ("KH"."TB_ORDER_PK"."USER_ID")

select user_id,
        to_char(order_date, 'yyyy/mm/dd hh24:mi:ss') order_date,
        amount
from tb_order_pk;


-------------------------------------------
--FOREIGN KEY
-------------------------------------------
--참조 무결성을 유지하기 위한 조건
--참조하고 있는 부모테이블의 지정 컬럼값 중에서만 값을 취할 수 있게 하는 것
--참조하고 있는 부모테이블의 지정 컬럼은 PK, UQ제약조건이 걸려있어야 한다.
--department.dept_id(부모테이블)  <------ employee.dept_code(자식테이블)
--자식테이블의 컬럼에 외래키(foreign key) 제약조건을 지정

create table shop_member (
    member_id varchar2(20),
    member_name varchar2(30) not null,
    constraint pk_shop_member_id primary key(member_id)
);

insert into shop_member values('honggd', '홍길동');
insert into shop_member values('sinsa', '신사임당');
insert into shop_member values('sejong', '세종대왕');

select * from shop_member;

--drop table shop_buy;
create table shop_buy (
    buy_no number,
    member_id varchar2(20),
    product_id varchar2(50),
    buy_date date default sysdate,
    constraints pk_shop_buy_no primary key(buy_no),
    constraints fk_shop_buy_member_id foreign key(member_id)
                                      references shop_member(member_id)
                                      on delete cascade
);

insert into shop_buy
values(1, 'honggd', 'soccer_shoes', default);

insert into shop_buy
values(2, 'sinsa', 'basketball_shoes', default);

insert into shop_buy
values(3, 'k12345', 'football_shoes', default); 
--ORA-02291: integrity constraint (KH.FK_SHOP_BUY_MEMBER_ID) violated - parent key not found

select * from shop_buy;

--fk기준 join -> relation
--구매번호 회원아이디 회원이름 구매물품아이디 구매시각
select B.buy_no,
        member_id,
        M.member_name,
        B.product_id,
        B.buy_date
from shop_member M
    join shop_buy B
        using(member_id);
        
--정규화 Normalization
--이상현상 방지(anormaly)
select *
from employee;

select *
from department;

--삭제 옵션
--on delete restricted : 기본값. 참조하는 자식행이 있는 경우, 부모행 삭제불가
--                      자식행을 먼저 삭제후, 부모행을 삭제
--on delete set null : 부모행 삭제시 자식컬럼은 null로 변경
--on delete cascade : 부모행 삭제시 자식행 삭제
--delete from shop_buy
--where member_id = 'honggd';

delete from shop_member
where member_id = 'honggd';
--ORA-02292: integrity constraint (KH.FK_SHOP_BUY_MEMBER_ID) violated - child record found

select * from shop_member;
select * from shop_buy;

--식별관계 | 비식별관계
--비식별관계 : 참조하고 있는 부모컬럼값을 PK로 사용하지 않는 경우. 여러행에서 참조가 가능(중복) 1:N관계
--식별관계 : 참조하고 있는 부모컬럼을 PK로 사용하는 경우. 부모행 - 자식행 사이에 1:1관계

create table shop_nickname (
    member_id varchar2(20),
    nickname varchar2(100),
    constraints fk_member_id foreign key(member_id) references shop_member(member_id),
    constraints pk_member_id primary key(member_id)
);

insert into shop_nickname
values('sinsa', '신솨112');

select *
from shop_nickname;

-------------------------------------------
--CHECK
-------------------------------------------
--해당 컬럼의 값의 범위를 지정.
--null 입력 가능
--drop table tb_cons_ck;
create table tb_cons_ck (
    gender char(1),
    num number,
    constraints ck_gender check(gender in ('M', 'F')),
    constraints ck_num check(num between 0 and 100)
);

insert into tb_cons_ck
values('M', 50);
insert into tb_cons_ck
values('F', 100);
insert into tb_cons_ck
values('m', 50); --ORA-02290: check constraint (KH.CK_GENDER) violated
insert into tb_cons_ck
values('M', 1000); --ORA-02290: check constraint (KH.CK_NUM) violated


-------------------------------------------
--CREATE
-------------------------------------------
--subquery를 이용한 create는 not null제약조건을 재외한 모든 제약조건, 기본값등을  제거한다.

create table emp_bck
as
select * from employee;

select * from emp_bck;

--제약조건 검색
select constraint_name,
        uc.table_name,
        ucc.column_name,
        uc.constraint_type,
        uc.search_condition
from user_constraints uc
    join user_cons_columns ucc
        using(constraint_name)
where uc.table_name = 'EMP_BCK';

--기본값 확인
select *
from user_tab_cols
where table_name = 'EMP_BCK';


-------------------------------------------
--ALTER
-------------------------------------------
--table관련 alter문은  컬럼, 제약조건에 대해 수정이 가능
/*
서브명령어
-add 컬럼, 제약조건 추가
-modify 컬럼 (자료형, 기본값) 변경(제약조건 변경불가)
-rename 컬럼명, 제약조건명 변경
-drop 컬럼, 제약조건 삭제
*/

create table tb_alter (
    no number
);

--add 컬럼
--맨 마지막 컬럼으로 추가
alter  table tb_alter 
add name varchar2(100) not null;

desc tb_alter;

--add 제약조건
--not null제약조건은 추가가 아닌 수정(modify)으로 처리
alter table tb_alter
add constraints pk_tb_alter_no primary key(no);

--제약조건 검색
select constraint_name,
        uc.table_name,
        ucc.column_name,
        uc.constraint_type,
        uc.search_condition
from user_constraints uc
    join user_cons_columns ucc
        using(constraint_name)
where uc.table_name = 'TB_ALTER';

--modify 컬럼
--자료형, 기본값, null여부 변경가능
--문자열에서 호환가능타입으로 변경가능(char --- varchar2)

alter table tb_alter
modify name varchar2(500) default '홍길동' null;

desc tb_alter;

--행이 있다면, 변경하는데 제한이 있다.
--존재하는 값보다는 작은 크기로 변경불가.
--null값이 있는 컬럼은 not null로 변경불가.

--modify 제약조건은 불가능.
--제약조건은 이름 변경외에 변경불가
--해당 제약조건 삭제후 재생성할 것.

--rename 컬럼
alter  table tb_alter
rename column no to num;

desc tb_alter;

--rename 제약조건
--제약조건 검색
select constraint_name,
        uc.table_name,
        ucc.column_name,
        uc.constraint_type,
        uc.search_condition
from user_constraints uc
    join user_cons_columns ucc
        using(constraint_name)
where uc.table_name = 'TB_ALTER';

alter table tb_alter
rename constraint PK_TB_ALTER_NO to pk_tb_alter_num;

--drop 컬럼
desc tb_alter;

alter table tb_alter
drop column name;

--drop 제약조건
alter table tb_alter
drop constraint pk_tb_alter_num;

--테이블 이름 변경
alter table tb_alter
rename to tb_alter_new;

rename tb_alter_new to tb_alter_all_new;

select * from tb_alter_all_new;


-------------------------------------------
--DROP
-------------------------------------------
--데이터베이스 객체(tablem user, view 등) 삭제
drop table tb_alter_all_new;



--=========================================
--DCL
--=========================================
--Data Control Language
--권한 부여/회수 관련 명령어 : grant / revoke
--TCL Transaction  Control Language를 포함한다. - commit / rollback / savepoint

--system 관리자계정 시작!

--qwerty계정 생성 
create user qwerty
identified by qwerty
default tablespace users;

--접속 권한 부여
--create session권한 또는 connect롤
grant connect to qwerty;
grant create session to qwerty;

--객체 생성권한 부여
--create table, create index.... 권한을 일일이 부여
--resource롤
grant resource to qwerty;

--system관리자계정 끝!

--권한, 롤을 조회
select *
from user_sys_privs; --권한

select *
from user_role_privs; --롤

select *
from role_sys_privs; --부여받은 롤에 포함된 권한

--커피테이블 생성
create table tb_coffee (
    cname varchar2(100),
    price number,
    brand varchar2(100),
    constraint pk_tb_coffee_cname primary key(cname)
);

insert into tb_coffee
values('maxim', 2000, '동서식품');
insert into tb_coffee
values('kanu', 3000, '동서식품');
insert into tb_coffee
values('nescafe', 2500, '네슬레');

select * from tb_coffee;
commit;

--qwerty계정에게 열람 권한 부여
grant select on tb_coffee to qwerty;

--수정권한 부여
grant insert, update, delete on tb_coffee to qwerty;

--수정권한 회수
revoke insert, update, delete on tb_coffee from qwerty;
revoke select on tb_coffee from qwerty;



--=========================================
--DATABASE OBJECT 1
--=========================================
--DB를 효율적으로 관리하고, 작동하게 하는 단위
select distinct object_type
from all_objects;

-------------------------------------------
--DATA DICTIONARY
-------------------------------------------
--일반사용자 관리자로부터 열람권한을 얻어 사용하는 정보조회테이블
--읽기전용.
--객체 관련 작업을 하면 자동으로 그 내용이 반영.

--1. user_xxx : 사용자가 소유한 객체에 대한 정보
--2. all_xxx : user_xxx를 포함. 다른 사용자로부터 사용권한을 부여받은 객체에 대한 정보
--3. dba_xxx : 관리자전용. 모든 사용자의 모든 객체에 대한 정보


--이용가능한 모든 dd조회
select * from dict; --dictionary

--*****************************************
--user_xxx
--*****************************************
--xxx는 객체이름 복수형을 사용한다.

--user_tables
select * from user_tables;
select * from tabs; --동의어(synonym)

--user_sys_privs : 권한
--user_role_privs : 롤(권한묶음)
--role_sys_privs : 사용자가 가진 롤에 포함된 모든 권한
select * from user_sys_privs;
select * from user_role_privs;
select * from role_sys_privs;

--user_sequence
select * from user_sequences;
--user_views
select * from user_views;
--user_indexes
select * from user_indexes;
--user_constraints
select * from user_constraints;

--*****************************************
--all_xxx
--*****************************************
--현재계정이 소유하거나 사용권한을 부여받은 객체 조회

--all_tables
select * from all_tables;

--all_indexes
select * from all_indexes;

--*****************************************
--dba_xxx
--*****************************************
select * from dba_tables; --ORA-00942: table or view does not exist 일반사용자 접근 금지

--특정사용자의 테이블 조회
select * 
from dba_tables
where owner in ('KH', 'QWERTY');

--특정사용자의 권한 조회
select *
from dba_sys_privs
where grantee = 'KH';

select *
from dba_role_privs
where grantee = 'KH';

--테이블 관련 권한 확인
select *
from dba_tab_privs
where owner = 'KH';

--관리자가 kh.tb_coffee 읽기 권한을 qwerty에게 부여
grant select, insert, update, delete on kh.tb_coffee to qwerty;


-------------------------------------------
--STORED VIEW
-------------------------------------------
--저장뷰.
--inlineview는 일회성이었지만, 이를 객체로 저장해서 재사용이 가능.
--가상테이블처럼 사용하지만, 실제로 데이터를 가지고 있는 것은 아니다.
--실제 테이블과 링크개념.

--뷰객체를 이용해서 제한적인 데이터만 다른 사용자에게 제공하는 것이 가능하다.
--create view 권한을 부여 받아야한다.
create view view_emp
as
select emp_id,
        emp_name,
        substr(emp_no, 1, 8) || '******' emp_no,
        email,
        phone
from employee;

--테이블처럼 사용
select * from view_emp;

select * 
from (
	select emp_id,
        emp_name,
        substr(emp_no, 1, 8) || '******' emp_no,
        email,
        phone
    from employee
);

--dd에서 조회
select * from user_views;

--타사용자에게 선별적인 데이터를 제공
grant select on kh.view_emp to qwerty;

--view특징
--1. 실제 컬럼뿐 아니라 가공된 컬럼 사용가능
--2. join을 사용하는 view가능
--3. or replace 옵션 사용가능
--4. with read only 옵션

create or replace view view_emp
as
select emp_id,
        emp_name,
        substr(emp_no, 1, 8) || '******' emp_no,
        email,
        phone,
        nvl(dept_title, '인턴') dept_title
from employee E
    left join department D
        on E.dept_code = D.dept_id
with read only;

--성별, 나이등 복잡한 연산이 필요한 컬럼을 미리 view지정해두면 편리하다.
create or replace view view_employee_all
as
select E.*,
        decode(substr(emp_no, 8, 1), '1', '남', '3', '남', '여') gender
from employee E;

select *
from view_employee_all
where gender = '여';


-------------------------------------------
--SEQUENCE
-------------------------------------------
--정수값을 순차적으로 자동생성하는 객체. 채번기
/*

create sequence 시퀀스명

start with 시작값 ----------------기본값 1
increment by 증가값 --------------기본값 1 감소도 가능
maxvalue 최대값 | nomaxvalue -----기본값은 nomaxvalue. 
                                 최대값에 도달하면, 다시 시작값(cycle) 혹은 에러유발(nocycle)
minbalue 최소값 | nominvalue -----기본값은 nominvalue
                                 최소값에 도달하면, 다시 시작값(cycle) 혹은 에러유발(nocycle)
cycle | nocycle -----------------순환여부. 기본값 nocycle
cache 캐싱개수 | nocache ----------기본값 cache 20. 시퀀스객체로 부터 20개씩 가져와서 메모리에서 채번
                                 오류가 발생하여, 숫자를 건너뛸수도 있다.

*/

create table tb_names (
    no number,
    name varchar2(100) not null,
    constraints pk_tb_names_no primary key(no)
);

create sequence seq_tb_names_no
start with 1000
increment by 1
nomaxvalue
nominvalue
nocycle
cache 20;

insert into tb_names
values (seq_tb_names_no.nextval, '홍길동');

select * from tb_names;

select seq_tb_names_no.nextval,
        seq_tb_names_no.currval
from dual;

--DD에서 조회
select * from user_sequences;

--복합문자열에 시퀀스 사용하기
--주문번호 kh-20210205-1001
create table tb_order(
    order_id varchar2(50),
    cnt number,
    constraints pk_tb_order_id primary key(order_id)
);

create sequence seq_order_id;

insert into tb_order
values('kh-' || to_char(sysdate, 'yyyymmdd') || '-' || to_char(seq_order_id.nextval, 'fm0000'), 100);

select * from tb_order;

--alter문을 통해 시작값 start with값은 절대 변경할 수 없다. 
--그때 스퀀스객체 삭제후 재생성할 것.
alter sequence seq_order_id increment by 10;


-------------------------------------------
--INDEX
-------------------------------------------
--색인.
--sql문 처리 속도 향상을 위해 컬럼에 대해 생성하는 객체
--key : 컬럼값, value : 레코드논리적주소값 rowid
--저장하는 데이터에 대한 별도의 공간이 필요함.

--장점 :
--검색속도가 빨라지고, 시스템 부하를 줄여서 성능향상

--단점 :
--인덱스를 위한 추가저장공간이 필요.
--인덱스를 생성/수정하는 데 별도의 시간이 소요됨.

--단순조회 업무보다 변경작업(insert/update/delete)가 많다면 index생성을 주의해야 한다.

--인덱스로 사용하면 좋은 컬럼

--1. 선택도selectivity가 좋은 컬럼. 중복데이터가 적은 컬럼.
--id | 주민번호 | email | 전화번호 > 이름 > 부서코드 >>>>>>>>>>>>> 성별
--pk | uq 제약조건이 사용된 컬럼은 자동으로 인덱스를 생성함 --삭제하려면 제약조건을 삭제해야 함.

--2. where절에 자주 사용되어지는 경우, 조인기준컬럼인 경우
--3. 입력된 데이터의 변경이 적은 컬럼.
select * 
from user_indexes
where table_name = 'EMPLOYEE';

--job_code 인덱스가 없는 컬럼
select *
from employee
where job_code = 'J5'; --table full scan

--emp_id 인덱스가 있는 컬럼
select *
from employee
where emp_id = '201'; --unique scan -> by index rowid

--emp_name 조회
select *
from employee
where emp_name = '송종기';

--emp_name컬럼으로 인덱스 생성
create index idx_employee_emp_name
on employee(emp_name);



--=========================================
--PL/SQL
--=========================================
--Procedural Language/SQL
--SQL의 한계를 보완해서 SQL문 안에서 변수정의/조건처리/반복처리등의 문법을 지원

--유형
--1. 익명블럭(Anonymous Block) : PL/SQL 실행 가능한 1회용 블럭
--2. Procedure : 특정구문ㅇ르 모아둔 서브프로그램. DB서버에 저장하고, 클라이언트에 의해 호출/실행.
--3. Function : 반드시 하나의 값을 리턴하는 서브프로그램. DB서버에 저장하고, 클라이언트에 의해 호출/실행.

--4. trigger
--5. scheduler

/*
declare     --1. 변수선언부(선택)

begin       --2. 실행부(필수)
            --조건문, 반복문, 출력문

exception   --3. 예외처리부(선택)
    
end;        --4. 블럭종료선언(필수)
/
--종료 /에 라인주석 달지 말것.
*/

--세션별로 설정
--서버콘솔 출력모드 지정 ON
set serveroutput on;

begin
    --dbms_output패키지의 put_line프로시져 : 출력문
    dbms_output.put_line('Hello PL/SQL');
end;
/

--사원 조회
declare
    v_id number;
begin
    select emp_id
    into v_id
    from employee
    where emp_name = '&사원명';
    
    dbms_output.put_line('사번 = ' || v_id);
exception
    when no_data_found then dbms_output.put_line('해당 이름을 가진 사원이 없습니다.');
end;
/

-------------------------------------------
-- 변수선언/대입
-------------------------------------------
--변수명[constant] 자료형[not null] [:= 초기값];

declare
    num constant number := 100;
    name varchar2(100) not null := '홍길동';  --not null은 초기값 지정 필수
    result number;
begin
    dbms_output.put_line('num = ' || num);
--    num := 200; --값변경 불가
--    dbms_output.put_line('num = ' || num);
    name := '&이름';
    dbms_output.put_line('이름 : ' || name);
end;
/

--PL/SQL 자료형
--1. 기본자료형
--      문자형 : varchar2, char, clob
--      숫자형 : number
--      날짜형 : date
--      논리형 : boolean (true | false | null)
--2. 복합자료형
--      레코드
--      커서
--      컬렉션

--참조형은 다른 테이블의 자료형을 차용해서 쓸수 있다.
--1. %type
--2. %rowtype
--3. record

declare
--    v_emp_name varchar2(100);
--    v_emp_no varchar2(100);
    --테이블해당컬럼 타입 지정
    v_emp_name employee.emp_name%type;
    v_emp_no employee.emp_no%type;
begin
    select emp_name, emp_no
    into v_emp_name, v_emp_no
    from employee
    where emp_id = '&사번';
    
    dbms_output.put_line('이름 : ' || v_emp_name);
    dbms_output.put_line('주민번호 : ' || v_emp_no);
end;
/

--%rowtype : 테이블 한행을 타입으로 지정
declare
    v_emp employee%rowtype;
begin
    select *
    into v_emp
    from employee
    where emp_id = '&사번';
    
    dbms_output.put_line('사원명 : ' || v_emp.emp_name);
    dbms_output.put_line('부서코드 : ' || v_emp.dept_code);
end;
/

--record
--사번, 사원명, 부서명등 존재하지 않는  컬럼조합을 타입으로 선언
declare
    type my_emp_rec is record(
        emp_id employee.emp_id%type,
        emp_name employee.emp_name%type,
        dept_title department.dept_title%type
    );
    
    my_row my_emp_rec;
begin
    select E.emp_id,
            E.emp_name,
            D.dept_title
    into my_row
    from employee E
        left join department D
            on E.dept_code = D.dept_id
    where emp_id = '&사번';
    
    --출력
    dbms_output.put_line('사번 : ' || my_row.emp_id);
    dbms_output.put_line('사원명 : ' || my_row.emp_name);
    dbms_output.put_line('부서명 : ' || my_row.dept_title);
end;
/

--사원명을 입력받고, 사번, 사원명, 직급명, 부서명을 참조형 변수를 통해 출력하세요.
declare
    type my_rec_type is record(
        emp_id employee.emp_id%type,
        emp_name employee.emp_name%type,
        job_name job.job_name%type,
        dept_title department.dept_title%type
    );
    
    my_row my_rec_type;
    v_emp_name employee.emp_name%type;
begin
    v_emp_name := '&사원명';
    
    select E.emp_id, E.emp_name, J.job_name, D.dept_title
    into my_row
    from employee E
        left join department D
            on E.dept_code = D.dept_id
        left join job J
            using(job_code)
    where E.emp_name = v_emp_name;
    
    dbms_output.put_line('사번 : ' || my_row.emp_id);
    dbms_output.put_line('사원명 : ' || my_row.emp_name);
    dbms_output.put_line('직급명 : ' || my_row.job_name);
    dbms_output.put_line('부서명 : ' || my_row.dept_title);
end;
/


-------------------------------------------
--PL/SQL 안의 DML
-------------------------------------------
--이 안에서 commit/rollback 트랜잭션(더 쪼갤 수 없는 작업단위) 처리까지 해줄것.

create table member(
    id varchar2(30),
    pwd varchar2(50) not null,
    name varchar2(100) not null,
    constraint member_id_pk primary key(id)
);

desc member;

begin
--    insert into member
--    values('honggd', '1234', '홍길동');

    update member set pwd = 'abcd'
    where id = 'honggd';
    
    --트랜잭션 처리
    commit;
end;
/

select * from member;

--사용자 입력값을 받아서 id, pwd, name을 새로운 행으로 추가하는 익명블럭을 작성하세요.
begin
    insert into member 
    values('&id', '&pwd', '&name');
                
    commit;

end;
/

--emp_copy에 사번마지막번호에 + 1 처리한 사번으로
--이름, 주민번호, 전화번호, 직급코드, 급여등급을 등록하는 PL/SQL 익명블럭 작성하기
select * from emp_copy;

declare
    last_num number;
begin
    --1. 사번 마지막 번호 구하기
    select max(emp_id)
    into last_num
    from emp_copy;
    dbms_output.put_line('last_num = ' || last_num);
    
    --2. 사용자입력값으로 insert문 실행
    insert into emp_copy (emp_id, emp_name, emp_no, phone, job_code, sal_level)
    values(last_num + 1, '&emp_name', '&emp_no', '&phone', '&job_code', '&sal_level');
    
    --3. trandaction처리
    commit;
end;
/


-------------------------------------------
--조건문
-------------------------------------------
--1. if 조건식 then .... end if;
--2. if 조건식 then .... else .... end if;
--3. if 조건식1  then .... elsif 조건식2 then .... end if;
declare
    name varchar2(100) := '&이름';
begin
    if name = '홍길동' then
        dbms_output.put_line('반갑습니다, 홍길동님');
    else
        dbms_output.put_line('누구냐 넌?');
    end if;
    dbms_output.put_line('------------끝--------------');
end;
/

declare
    num number := &숫자;
begin
    if mod(num, 3) = 0 then
        dbms_output.put_line('3의 배수를 입력하셨습니다.');
    elsif mod(num, 3) = 1 then
        dbms_output.put_line('3으로 나눈 나머지가 1입니다.');
    elsif mod(num, 3) = 2 then
        dbms_output.put_line('3으로 나눈 나머지가 2입니다.');
    end if;
    
end;
/

--사번을 입력받고, 해당 사원의 직급이 J1이면 '대표' 출력
--J2라면, '임원'
--그 외는 '평사원'이라고 출력하세요
declare
    v_emp_id employee.emp_id%type := '&사번';
    v_job_code employee.job_code%type;
begin
    select job_code
    into v_job_code
    from employee
    where emp_id = v_emp_id;
    
    if v_job_code = 'J1' then
        dbms_output.put_line('대표');
    elsif v_job_code = 'J2' then
        dbms_output.put_line('임원');
    else
        dbms_output.put_line('평사원');
    end if;
end;
/


-------------------------------------------
--반복문
-------------------------------------------
--1. 기본 loop - 무한반복(탈출조건식)
--2. while loop - 조건에 따른 반복
--3. for loop - 지정횟수만큼 반복실행

declare
    n number := 1;
begin
    loop
        dbms_output.put_line(n);
        n := n + 1;
        
        --exit구문 필수
--        if n > 100 then
--            exit;
--        end if;
        exit  when n > 50;
    end loop;
end;
/

--난수 출력
--1부터 10까지의 난수를 10개 출력하기
declare
    rnd number;
    rd number := 1;
begin
    
    loop
        --start 이상, end 미만의 난수
        rnd := trunc(dbms_random.value(1, 11));
        dbms_output.put_line(rd || ':' || rnd);
        
        rd := rd + 1;
        exit when rd > 10;
    end loop;
end;
/

--while loop
declare
    n number := 0;
begin
    while n < 10 loop
        if mod(n, 2) = 0 then
            dbms_output.put_line(n);
        end if;
        n := n + 1;
    end loop;
end;
/

--사용자로부터 단수(2~9단)을 입력받아 해당단순의 구구단을 출력하기
--2~9외의 숫자를 입력하면, 잘못입력하셨습니다. 출력 후 종료
declare
    n number := 1;
    dan number := '&단';
begin
    if dan > 9 or dan < 2 then
        dbms_output.put_line('잘못입력하셨습니다');
    else
        while n < 10 loop
            dbms_output.put_line(dan || ' * ' || n || ' = ' || dan * n);
            n := n + 1;
        end loop;
    end if;
end;
/

declare 
    dan number := &단;
    n number := 1;
begin
    
    if dan between 2 and 9 then
        while n < 10 loop
            dbms_output.put_line(dan || ' * ' || n || ' = ' || (dan * n) );
            n := n +1;
        end loop;
    else 
        dbms_output.put_line('단수를 잘못 입력하셨습니다.');
    end if;

end;
/

--for in ... loop
--증감변수를 별도로 선언하지 않아도 좋다.
--자동 증가처리
--reverse 1씩 감소

begin
    --n을 선언없이 바로 사용가능
    --시작값..종료값(시작값 < 종료값)
    for n in 1..5 loop
--    for n in reverse 1..5 loop --뒤부터 출력하려면 reverse사용
        dbms_output.put_line(n);
    end loop;

end;
/

--210 ~ 220번 사이의 사원을 조회(사번, 이름, 전화번호)
declare
    e employee%rowtype;
begin
    for n in 210..220 loop
        select *
        into e
        from employee
        where emp_id = n;
        
        dbms_output.put_line('사번 : ' || e.emp_id);
        dbms_output.put_line('이름 : ' || e.emp_name);
        dbms_output.put_line('전화번호 : ' || e.phone);
        dbms_output.put_line(' ');
    end loop;
end;
/

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



--=========================================
--DATABASE OBJECT2
--=========================================
--PL/SQL문법을 사용하는 객체


-------------------------------------------
--FUNCTION
-------------------------------------------
--문자열 앞뒤에 d...b 헤드폰 씌우기 함수
--매개변수, 리턴선언시 자료형 크기지정하지 말것.
--drop function db_func;
create or replace function db_func (p_str varchar2)
return  varchar2
is
    --사용할 지역변수 선언
    result varchar2(32767);
begin
    --실행로직
    result := 'd' || p_str || 'b';
    return result;
end;
/

--실행
--1. 일반 sql문
select db_func (emp_name)
from employee;

--2. 익명블럭/다른 pl/sql객체에서 호출가능
set serveroutput on;
begin
    dbms_output.put_line(db_func('&이름'));
end;
/

--3. exec | execute 프로시져/함수 호출하는 명령
var text varchar2;
exec :text := db_func('신사임당');
print text;

--Datad Dictionary에서 확인
select * from user_procedures
where object_type = 'FUNCTION';

--성별구하기 함수
create or replace function fn_get_gender(
    p_emp_no employee.emp_no%type
    )
return varchar2
is
    gender varchar2(3);
begin
--    if substr(p_emp_no, 8, 1) in ('1', '3') then
--        gender := '남';
--    else
--        gender := '여';
--    end if;
    
    --type1 : when 조건식을 여러개 나열
--    case
--        when substr(p_emp_no, 8, 1) in '1' then
--            gender := '남';
--        when substr(p_emp_no, 8, 1) in '3' then
--            gender := '남';
--        else
--            gender := '여';
--    end case;

    --type2 : decode와 비슷. 단하나의 계산식만 제공.
    case substr(p_emp_no, 8, 1)
        when '1' then gender := '남';
        when '3' then gender := '남';
        else gender := '여';
    end case;
    return gender;
end;
/

select emp_name, 
        fn_get_gender(emp_no) gender
from employee;

--주민번호를 입력받아 나이를 리턴하는 함수 fn_get_age를 작성하고,
--사번, 사원명, 주민번호, 성별, 나이 조회(일반 sql문)
create or replace function fn_get_age(p_emp_no employee.emp_no%type)
return number
is
    v_birth_year number;
    v_age number;
begin
    case
        when substr(p_emp_no, 8 ,1) in ('1', '2') then v_birth_year := 1900;
        when substr(p_emp_no, 8 ,1) in ('3', '4') then v_birth_year := 2000;
    end case;
    v_birth_year := v_birth_year + substr(p_emp_no, 1, 2); --출생년도
    
    v_age := extract(year from sysdate) - v_birth_year + 1;
    return v_age;
end;
/

select emp_id,
        emp_name,
        emp_no,
        fn_get_gender(emp_no) gender,
        fn_get_age(emp_no) age
from employee;


-------------------------------------------
--PROCEDURE
-------------------------------------------
--일련의 작업절차를 작성해 객체로 저장해둔것.
--함수와 달리 리턴값이 없다.
--OUT매개변수를 사용하면 호출부쪽으로 결과를 전달가능. 여러개의 값을 리턴하는 효과연출.

--1. 매개변수 없는 프로시져
select * from member;

create or replace procedure proc_del_member
is
    --지역변수 선언
begin
    --실행구문
    delete from member;
    commit;
end;
/

--1. 익명블럭 | 타 프로시져객체에서 호출 가능
begin
    proc_del_member;
end;
/
--2. execute 명령
execute proc_del_member;

--DD에서 확인
select *
from user_procedures
where object_type = 'PROCEDURE';

select *
from user_source
where name = 'PROC_DEL_MEMBER';

--2. 매개변수 있는 프로시져
--매개변수  mode 기본값 in
create or replace procedure proc_del_emp_by_id(
    p_emp_id emp_copy.emp_id%type
)
is
begin
    delete from emp_copy
    where emp_id = p_emp_id;
    commit;
    dbms_output.put_line(p_emp_id || '번 사원을 삭제했습니다.');
end;
/

select * from emp_copy;

begin
    proc_del_emp_by_id('&삭제할_사번');
end;
/

--out매개변수 사용하기
--사번을 전달해서 사원명, 전화번호를 리턴(out매개변수)받을수 있는 프로시져
--drop procedure proc_select_emp_by_id;
create or replace procedure proc_select_emp_by_id(
    p_emp_id in emp_copy.emp_id%type,
    p_emp_name out emp_copy.emp_name%type,
    p_phone out emp_copy.phone%type
)
is
begin
    select emp_name, phone
    into p_emp_name, p_phone
    from emp_copy
    where emp_id =p_emp_id;
end;
/

--익명블럭 호출(client)
declare
    v_emp_name emp_copy.emp_name%type;
    v_phone emp_copy.phone%type;
begin
    proc_select_emp_by_id('&사번', v_emp_name, v_phone);
    dbms_output.put_line('v_emp_name : ' || v_emp_name);
    dbms_output.put_line('v_phone : ' || v_phone);
end;
/

--upsert 예제 : insert + update
create table job_copy
as
select * from job;

select * from job_copy;

--pk 제약조건추가
alter table job_copy
add constraints pk_job_copy primary key(job_code)
modify job_name not null;

--직급정보를 추가하는 프로시져
create or replace procedure proc_man_job_copy(
    p_job_code in job_copy.job_code%type,
    p_job_name in job_copy.job_name%type
)
is
    v_cnt number := 0;
begin
    --1. 존재여부 확인
    select count(*)
    into v_cnt
    from job_copy
    where job_code = p_job_code;
    
    dbms_output.put_line('v_cnt = ' || v_cnt);

    --2. 분기처리
    if (v_cnt = 0) then
        -- 존재하지 않으면 insert
        insert into job_copy
        values(p_job_code, p_job_name);
    else
        -- 존재하면 update
        update job_copy
        set job_name = p_job_name
        where job_code = p_job_code;
    end if;
    
    --3. 트랙잭션 처리
    commit;
end;
/

--익명블럭에서 호출
begin
    proc_man_job_copy('J8', '수습사원');
end;
/

select * from job_copy;

delete from job_copy
where job_code = 'J8';
commit;

declare
    bool boolean;
begin
    bool := 1 < 2;
    if bool then
        dbms_output.put_line('참');
    else
        dbms_output.put_line('거짓');
    end if;
end;
/


-------------------------------------------
--CURSOR
-------------------------------------------
--SQL의 처리결과 ResultSet을 가르키고 있는 포인터객체
--하나이상의 row에 순차적으로 접근가능

--1. 암묵적 커서 : 모든 sql실행시 암묵적커서가 만들어져 처리됨.
--2. 명시적 커서 : 변수로 선언후, open~fetch~close과정에 따라 행에 접근할 수 있다.
declare
    v_emp emp_copy%rowtype;
    
    cursor my_cursor
    is
    select * from emp_copy;
begin
    open my_cursor;
    loop
        fetch my_cursor into v_emp;
        exit when my_cursor%notfound;
        dbms_output.put_line('사번 : ' || v_emp.emp_id);
        dbms_output.put_line('사원명 : ' || v_emp.emp_name);
    end loop;
    close my_cursor;

end;
/

--파라미터 있는 커서
declare
    v_emp emp_copy%rowtype;
    
    cursor my_cursor(p_dept_code emp_copy.dept_code%type)
    is
    select * 
    from emp_copy
    where dept_code = p_dept_code
    order by emp_id;
begin
    open my_cursor('&부서코드');
    loop
        fetch my_cursor into v_emp;
        exit when my_cursor%notfound;
        dbms_output.put_line('사번 : ' || v_emp.emp_id);
        dbms_output.put_line('사원명 : ' || v_emp.emp_name);
        dbms_output.put_line('부서코드 : ' || v_emp.dept_code);
        dbms_output.put_line(' ');
    end loop;
    close my_cursor;
end;
/

--for..in문을 통해 처리
--1. open-fetch-close작업 자동
--2. 행변수는 자동으로 선언
declare
    cursor my_cursor
    is
    select * from employee;
begin
    for my_row in my_cursor loop
        dbms_output.put_line(my_row.emp_id || ':' || my_row.emp_name);
    end loop;
end;
/

declare
    cursor my_cursor(p_job_code emp_copy.job_code%type)
    is
    select emp_id, emp_name, job_code 
    from emp_copy
    where job_code = p_job_code;
begin
    for my_row in my_cursor('&직급코드') loop
        dbms_output.put_line(my_row.emp_id || ':' || my_row.emp_name);
    end loop;
end;
/


-------------------------------------------
--TRIGGER
-------------------------------------------
--방아쇠, 연쇄반응
--특정이벤트(DDL, DML, LOGON)가 발생했을때,
--실행될 코드를 모아둔 데이터베이스 객체.

--종류
--1. DDL Trigger
--2. DML Trigger
--3. LOGON/LOGOFF Trigger

--게시판테이블의 게시물삭제
--1. 삭제여부컬럼 : del_flag 'N' -> 'Y'
--2. 삭제테이블 : 삭제된 행 데이터를 삭제테이블에 insert

/*
create or replace trigger 트리거명
    before | after                      --원 DML문 실행 전 |실행후에 trigger 실행
    insert | update | delete on 테이블명
    [for each row]                      --행 level 트리거, 생략하면 문장 level 트리거
begin
    --실행코드
end;
/

-행레벨 트리거 : 원DML문(10행)이 처리되는 행마다 trigger실행(10번)
-문장레벨 트리거 : 원DML문이 실행시 trigger 한번 실행

의사 pseudo 레코드 (행레벨트리거에서만 유효)
- :old 원DML문 실행전 데이터
- :new 원DML문 실행후 데이터

insert
    :old null
    :new 추가된 데이터
update
    :old 변경전 데이터
    :new 변경후 데이터
    
delete
    :old 삭제전 데이터
    :new null
    
**트리거내부에서는 transaction처리 하지 않는다. 원DML문의 트랜잭션에 자동포함된다.
*/

create or replace trigger trig_emp_salary
    before
    insert or update of salary on emp_copy
    for each row
begin
    dbms_output.put_line('변경전 salary : ' ||:old.salary);
    dbms_output.put_line('변경후 salary : ' ||:new.salary);
    
    insert into emp_copy_salary_log(emp_id, before_salary, after_salary)
    values(:new.emp_id, :old.salary, :new.salary);
    --commit과 같은 트랜잭션처리를 하지 않는다.
end;
/
--재컴파일 명령어
alter trigger trig_emp_salary compile;

update emp_copy
set salary = salary + 1000000
where dept_code = 'D5';

rollback; --trigger에서 실행된 dml문도 함께 rollback된다.

--PK 추가
alter table emp_copy
add constraints pk_emp_copy_emp_id primary key(emp_id);

--급여변경 로그테이블
create table emp_copy_salary_log (
    emp_id varchar2(3),
    before_salary number,
    after_salary number,
    log_date date default sysdate,
    constraint fk_emp_id foreign key(emp_id) references emp_copy(emp_id)
);

select * from emp_copy;
select * from emp_copy_salary_log;

--@실습문제 :
--emp_copy에서 사원을 삭제할 경우, emp_copy_del 테이블로 데이터를 이전시키는 trigger를 생성하세요.
--quit_date에 현재날짜를 기록할 것.
create table emp_copy_del
as
select E.*
from emp_copy E
where 1 = 2;

--ORA-04091: table KH.EMP_COPY is mutating, trigger/function may not see it
--트리거 안에서는 원DML문의 대상테이블에 접근할 수 없다.
create or replace trigger trig_emp_quit
    before delete on emp_copy
    for each row
begin
    insert into emp_copy_del
    (emp_id, emp_name, emp_no, email, phone, dept_code, job_code, sal_level, 
    salary, bonus, manager_id, hire_date, quit_date, quit_yn)
    values 
    (:old.emp_id, :old.emp_name, :old.emp_no, :old.email, :old.phone, 
    :old.dept_code, :old.job_code, :old.sal_level, :old.salary, :old.bonus, 
    :old.manager_id, :old.hire_date, sysdate, 'Y');
    
    dbms_output.put_line(:old.emp_id||'사원이 퇴사자 테이블로 이동했음');
end;
/

select * from emp_copy;
select * from emp_copy_del;

delete from emp_copy
where quit_yn = 'Y';

--상품 재고 관리
create table product (
    pcode number,
    pname varchar2(100),
    price number,
    stock_cnt  number default 0,
    constraint pk_product_pcode primary key(pcode)
);

create table product_io (
    iocode number,
    pcode  number,
    amount number,
    status char(1),
    io_date date  default  sysdate,
    constraint pk_produck_io_code primary key(iocode),
    constraint fk_product_io_pcode foreign key(pcode)
                                    references product(pcode)
);

alter table product_io
add constraints ck_product_io_status check(status in ('I', 'O'));

create sequence seq_product_pcode;
create sequence seq_product_io_iocode
start with 1000;
--drop sequence seq_product_io_iocode;

insert into product
values (seq_product_pcode.nextval, '아이폰12',  1500000, 0);

insert into product
values (seq_product_pcode.nextval, '갤럭시21',  990000, 0);

select *  from product;
select *  from product_io;

--입출고데이터가 insert되면, 해당상품의 재고수량을  변경하는 트리거
create or  replace trigger trg_product
    before
    insert on product_io
    for each row
begin
    --입고
    if :new.status = 'I' then
        update product
        set stock_cnt = stock_cnt + :new.amount
        where pcode = :new.pcode;
    --출고
    else
        update product
        set stock_cnt = stock_cnt - :new.amount
        where pcode = :new.pcode;    
    end if;
end;
/

--입출고  내역
insert into product_io
values(seq_product_io_iocode.nextval, 1, 5, 'I', sysdate);
insert into product_io
values(seq_product_io_iocode.nextval, 1, 100, 'I', sysdate);
insert into product_io
values(seq_product_io_iocode.nextval, 1, 30, 'O', sysdate);

select *  from product;
select *  from product_io;

commit;

--1. 원DML문의 대상테이블에 접근할 수 없다.
--2. 트리거 안에서는 원DML문을 제어할 수 없다.




 