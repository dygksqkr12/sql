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
group by dept_code; --일반컬럼 | 가공컬림이 가능

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

select dept_title --총부무
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
--1. ANSI 표준문법 : 모든 DBMS 공통문법
--2. Vendor별 문법 : DBMS별로 지원하는 문법. 오라클전용문법


--equi-join 종류
/*
1. inner join

2. outer join

3. cross join

4. self join

5.multiple join

*/





