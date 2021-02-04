--=========================================
--CHUN 계정
--=========================================

--학과테이블
select * from tb_department;

--학생테이블
select * from tb_student;

--과목테이블
select * from tb_class;

--교수테이블
select * from tb_professor;

--교수과목테이블
select * from tb_class_professor;

--성적테이블
select * from tb_grade;


--1. 춘 기술대학교의 학과 이름과 계열을 표시하시오. 단, 출력 헤더는 "학과 명", "계열"
--으로 표시하도록 한다.
select department_name "학과 명",
       category 계열
from tb_department;

--2. 학과의 학과 정원을 다음과 같은 형태로 화면에 출력한다
select department_name ||'의 정원은 ' ||capacity ||'명 입니다.'"학과별 정원"
from tb_department;

--3. "국어국문학과" 에 다니는 여학생 중 현재 휴학중인 여학생을 찾아달라는 요청이
--들어왔다. 누구인가? (국문학과의 '학과코드'는 학과 테이블(TB_DEPARTMENT)을 조회해서
--찾아 내도록 하자)
select student_name
from tb_student
where department_no = 001 and substr(student_ssn, 8, 1) = '2' and absence_yn = 'Y';

--4. 도서관에서 대출 도서 장기 연체자 들을 찾아 이름을 게시하고자 핚다. 그 대상자들의
--학번이 다음과 같을 때 대상자들을 찾는 적젃핚 SQL 구문을 작성하시오.
--A513079, A513090, A513091, A513110, A513119
select student_name
from tb_student
where student_no in ('A513079', 'A513090', 'A513091', 'A513110', 'A513119');

--5. 입학정원이 20 명 이상 30 명 이하인 학과들의 학과 이름과 계열을 출력하시오.
select department_name, category
from tb_department
where capacity between 20 and 30;

--6. 춘 기술대학교는 총장을 제외하고 모든 교수들이 소속 학과를 가지고 있다. 그럼 춘
--기술대학교 총장의 이름을 알아낼 수 있는 SQL 문장을 작성하시오.
select professor_name
from tb_professor
where department_no is null;

--7. 혹시 젂산상의 착오로 학과가 지정되어 있지 않은 학생이 있는지 확인하고자 핚다.
--어떠핚 SQL 문장을 사용하면 될 것인지 작성하시오.
select student_name
from tb_student
where department_no is null;

--8. 수강신청을 하려고 핚다. 선수과목 여부를 확인해야 하는데, 선수과목이 존재하는
--과목들은 어떤 과목인지 과목번호를 조회해보시오.
select *
from tb_class
where preattending_class_no is not null
order by class_no;

--9. 춘 대학에는 어떤 계열(CATEGORY)들이 있는지 조회해보시오
select DISTINCT category
from tb_department
order by category;

--10. 02 학번 젂주 거주자들의 모임을 맊들려고 핚다. 휴학핚 사람들은 제외핚 재학중인
--학생들의 학번, 이름, 주민번호를 출력하는 구문을 작성하시오.
select student_no, 
       student_name, 
       student_ssn
from tb_student
where substr(student_no, 2, 1) = '2' and 
      substr(student_address, 1, 2) = '전주' and
      absence_yn = 'N'
order by student_name;


--2021-01-27
--1. 학과테이블에서 계열별 정원의 평균을 조회(정원 내림차순 정렬)
select category,
       trunc(avg(capacity)) 평균
from tb_department
group by category
order by 2 desc;

--2. 휴학생을 제외하고, 학과별로 학생수를 조회(학과별 인원수 내림차순)
select department_no,
       count(*)
from tb_student
where absence_yn = 'N'
group by department_no
order by 2 desc;

--3. 과목별 지정된 교수가 2명이상이 과목번호와 교수인원수를 조회
select class_no, count(*)
from tb_class_professor
group by class_no
having count(*) >= 2
order by 2 desc;

--4. 학과별로 과목을 구분했을때, 과목구분이 "전공선택"에 한하여 과목수가 10개인 행의 학과번호, 과목구분
select department_no,
       class_type,
       count(*)
from tb_class
group by department_no, class_type
having class_type = '전공선택' and count(*) >= 10
order by 3 desc;



--학번/학생명/담당교수명 조회
--1. 두테이블의 기준컬럼 파악
--2. on조건절에 행된지 않는 데이터파악
select * from tb_student; --coach_professor_no
select * from tb_professor; --professor_no

--담당교수가, 담당학생이 배정되지 않은 학생이나 교수 제외 inner 579
--담당교수가 배정되지 않은 학생 포함 left 588 = 579 + 9
--담당학생이 없는 교수 포함 right 580 = 579 + 1

select count(*)
from tb_student S right join tb_professor P
    on S.coach_professor_no = P.professor_no;

--1. 교수배정을 받지 않은 학생 조회 --9
select count(*)
from tb_student
where coach_professor_no is null;

--2. 담당학생이 한명도 없는 교수 --1
--전체 교수 수 --114
select count(*)
from tb_professor;
--중복 없는 담당교수 수 --113
select count(distinct coach_professor_no)
from tb_student;

--2021.01.28
--1. 학번, 학생명, 학과명 조회
--학과지정이 안된 학생은 존재하지 않는다.
select S.student_no,
        S.student_name,
        D.department_name
from tb_student S
    join tb_department D
        on S.department_no = D.department_no;
        
select count(*)
from tb_student
where department_no is null;

--2. 수업번호, 수업명, 교수번호, 교수명 조회
select C.class_no,
        C.class_name,
        P.professor_no,
        P.professor_name
from tb_class_professor CP
    join tb_class C
        on CP.class_no = C.class_no
    join tb_professor P
        on P.professor_no = CP.professor_no;

--3. 송박선 학생의 모든 학기 과목별 점수를 조회(학기, 학번, 학생명, 수업명, 점수)
select G.term_no,
        student_no,
        S.student_name,
        C.class_name,
        G.point
from tb_grade G
    join tb_student S
        using(student_no)
    join tb_class C
        using(class_no)
where S.student_name = '송박선';

--4. 학생별 전체 평점(소수점이하 첫째자리 버림) 조회 (학번, 학생명, 평점)
--같은 학생이 여러학기에 걸쳐 같은 과목을 이수한 데이터 있으나, 전체 평점으로 계산함.
select student_no,
        student_name,
        trunc(avg(point)) avg
from tb_grade G
    join tb_student S
        using(student_no)
group by student_no, student_name;

--5. 교수번호, 교수명, 담당학생명수 조회
--단, 5명 이상을 담당하는 교수만 출력
select P.professor_no,
        P.professor_name,
        count(*) cnt
from tb_student S
    join tb_professor P
        on S.coach_professor_no = P.professor_no
group by P.professor_no, P.professor_name
having count(*) >= 5
order by cnt desc;









