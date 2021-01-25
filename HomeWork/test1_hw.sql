--tbl_escape_watch 테이블에서 description 컬럼에 99.99% 라는 글자가 들어있는 행만 추출하세요.
select description
from tbl_escape_watch
where description like '%99.99\%%' ESCAPE '\';

--insert into tbl_files values(1, 'c:\abc\deft\salesinfo.xls');
--	insert into tbl_files values(2, 'c:\music.mp3');
--	insert into tbl_files values(3, 'c:\documents\resume.hwp');
--출력결과 :
----------------------------
--파일번호          파일명
-----------------------------
--1             salesinfo.xls
--2             music.mp3
--3             resume.hwp
-----------------------------
select fileno, substr(filepath, instr(filepath, '\', - 1) + 1)
from tbl_files;