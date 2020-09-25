REPOT GROUP FUCTION
1. ROLLUP 2. GROUPING SETS
3. CUBE(col1, col2....)
    . 컬럼의 순서는 지키되, 가능한 모든 조합을 생성한다.
    
GROUP BY CUBE(job, deptno)  ==> 4개
  job  deptno
   o     o     ==> GROUP BY job, deptno
   o     x     ==> GROUP BY job
   x     o     ==> GROUP BY deptno (ROLLUP에는 없던 서브 그룹)
   x     x     ==> GROUP BY 전체

GROUP BY ROLLUP(job, deptno) ==> 3개


SELECT job, deptno, SUM(sal+ NVL(comm,0)) sal
FROM emp
GROUP BY CUBE(job, deptno);

CUBE의 경우 가능한 모든 조합으로 서브 그룹을 생성하기 때문에 
2의 기술한 컬럼개수 승 만큼의 서브 그룹이 생성된다.
CUBE(col1, col2, col3) : 8가지 경우의 수(2^n개 씩 늘어남)

REPORT GROUP FUNCTION 조합
GROUP BY job, ROLLUP(deptno), CUBE(mgr)
경우의 수 : job은 디폴트 값으로 고정
           job  deptno, mgr / deptno / mgr / 전체
           
SELECT job, deptno, mgr, SUM(sal + NVL(comm,0)) sal
FROM emp
GROUP BY job, ROLLUP(deptno), CUBE(mgr);

상호 연관 서브 쿼리를 이용한 업데이트
1. emp_test 테이블 삭제
2. emp 테이블을 사용하여 emp_test 테이블 생성(모든 컬럼, 모든 데이터)
3. emp_test테이블에는 dname 컬럼을 추가(VARCHAR2(14))
4. 상호 연관 서브쿼리를 이용하여 emp_test테이블의 dname 컬럼을 dept을 이용하여 UPDATE

DROP TABLE emp_test;
CREATE TABLE emp_test AS
SELECT *
FROM emp;

ALTER TABLE emp_test ADD (dname VARCHAR(14));

UPDATE emp_test SET dname = (SELECT dname FROM dept WHERE deptno = emp_test.deptno);

SELECT *
FROM emp_test;
commit;

실습 sub_a1
ALTER TABLE dept_test ADD (empcnt NUMBER(4));
UPDATE dept_test SET empcnt = (SELECT COUNT(*) FROM emp WHERE deptno=dept_test.deptno GROUP BY deptno);
 
SELECT *
FROM dept_test;
commit;

실습 sub_a2
INSERT INTO dept_test (deptno, dname, loc) VALUES (99, 'it1', 'daejeon');
INSERT INTO dept_test (deptno, dname, loc) VALUES (98, 'it2', 'daejeon');
commit;

부서에 속한 직원이 없는 부서를 삭제하는 쿼리 작성
DELETE dept_test
WHERE deptno NOT IN (SELECT deptno FROM emp);

실습 sub_a3 는 과제

달력만들기 : 행을 열로 만들기-레포트 쿼리에서 자주 사용하는 형태
주어진것 : 년원 (수업시간에는 '202009' 문자열을 사용)

'202009' ==> 30
'202010' => 31
SELECT LAST_DAY(TO_DATE('202008', 'YYYYMM'))
FROM dual;

SELECT MIN(DECODE(d, 1, day)) sun,MIN(DECODE(d, 2, day)) mon,MIN(DECODE(d, 3, day)) tue,
       MIN(DECODE(d, 4, day)) wed,MIN(DECODE(d, 5, day)) thu,MIN(DECODE(d, 6, day)) fri,
       MIN(DECODE(d, 7, day)) sat
FROM(SELECT TO_DATE(:YYYYMM, 'YYYYMM')+LEVEL-1 DAY,
            TO_CHAR(TO_DATE(:YYYYMM, 'YYYYMM')+LEVEL-1, 'D') d,
            TO_DATE(:YYYYMM, 'YYYYMM')+(LEVEL-1) - 
            TO_CHAR(TO_DATE(:YYYYMM, 'YYYYMM')+(LEVEL-1), 'D') + 1 f_sun
     FROM dual
     CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(:YYYYMM, 'YYYYMM')), 'DD'))
GROUP BY f_sun
ORDER BY f_sun;

복습 (실습 calendar1)
SELECT NVL(MIN(DECODE(dt, '01',sal)), 0) jan, NVL(MIN(DECODE(dt, '02',sal)), 0) feb, 
       NVL(MIN(DECODE(dt, '03',sal)), 0) mar, NVL(MIN(DECODE(dt, '04',sal)), 0) apr,
       NVL(MIN(DECODE(dt, '05',sal)), 0) may, NVL(MIN(DECODE(dt, '06',sal)), 0) jun
FROM(SELECT TO_CHAR(DT,'MM') dt, SUM(sales) sal
     FROM sales
     GROUP BY TO_CHAR(DT,'MM'));
     
계층쿼리
SELECT deptcd, LPAD(' ', (LEVEL-1)*3) || deptnm deptnm
FROM dept_h
START WITH deptcd = 'dept0'
CONNECT BY PRIOR deptcd = p_deptcd;