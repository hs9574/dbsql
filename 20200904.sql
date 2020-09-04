NULL 비교
NULL값은 =, != 등의 비교연산으로 비교가 불가능
EX : emp 테이블에는 comm컬럼의 값이 NULL인 데이터가 존재
 
comm이 NULL인 데이터를 조회 하기 위해 다음과 같이 실행할 경우 정상적으로 동작하지 않음
SELECT *
FROM emp
WHERE comm = NULL;
 
SELECT *
FROM emp
WHERE comm IS NULL;

comm 컬럼의 값이 NULL이 아닐때
 =, !=, <>
 SELECT *
FROM emp
WHERE comm IS  NOT NULL;

IN <==> NOT IN
사원중 소속 부서가 10번이 아닌 사원
SELECT *
FROM emp
WHERE deptno NOT IN (10);

사원중에 자신의 상급자가 존재하지 않는 사원들만 조회(모든 컬럼 조회)
SELECT *
FROM emp
WHERE mgr IS NULL;

논리 연산 : AND, OR, NOT
AND, OR : 조건을 결합
     AND :  조건1 AND 조건2 : 조건1과, 조건2를 동시에 만족하는 행만 조회가 되도록 제한
     OR  :  조건1 OR 조건2 : 조건1 혹은 조건2를 만족하는 행만 조회 되도록 제한

조건1     조건2     조건1 AND 조건2     조건1 OR 조건2
 T         T             T                  T
 T         F             F                  T
 F         T             F                  T
 F         F             F                  F
 
WHERW 절에 AND 조건을 사용하게 되면 : 보통은 행이 줄어든다.
WHERW 절에 OR 조건을 사용하게 되면 : 보통은 행이 늘어난다.
 
NOT : 부정연산 - 다른 연산자와 함께 사용되며 부정형 표현으로 사용됨
NOT IN (값1, 값2....)
IS NOT NULL
NOT EXISTS : 존재X 나중에 배움

mgr가 7698사번을 갖으면서 급여가 1000보다 큰 사원들을 조회
SELECT *
FROM emp
WHERE mgr = 7698
  AND sal > 1000;
  
mgr가 7698이거나 sal가 1000보다 큰사람
SELECT *
FROM emp
WHERE mgr = 7698
   OR sal > 1000;
   
emp 테이블의 사원중에 mgr가 7698이 아니고, 7839가 아닌 직원
SELECT *
FROM emp
WHERE mgr != 7698
  AND mgr != 7839;
   
SELECT *
FROM emp
WHERE mgr NOT IN (7698, 7839);

IN 연산자는 OR 연산자로 대체가 가능(저번에 배움)
SELECT *
FROM emp
WHERE mgr IN (7698, 7839); --IN 또는 OR ==> mgr = 7698 OR mgr = 7839
WHERE mgr NOT IN (7698, 7839); ==> NOT mgr != 7698 AND mgr != 7839

IN 연산자 사용시 NULL 데이터 유의점
요구사항 : mgr가 7698, 7839, NULL인 사원만 조회
SELECT *
FROM emp
WHERE mgr IN (7698, 7839, NULL); -- NULL이 안나옴
mgr = 7698 OR mgr = 7839 OR mgr = NULL;

SELECT *
FROM emp
WHERE mgr NOT IN (7698, 7839, NULL);
mgr != 7698 AND mgr = != 7839 AND mgr !=NULL; --NOT IN 연산자에서는 NULL값이 있는 데이터를 안나오게함. 왜냐면 오라클에서 그렇게 해서 NULL은 IS를 써야댐

date type 표현
두가지 조건을 논리연산자로 묶는 방법
AND , OR 실습 WHERE7
SELECT *
FROM emp
WHERE job = 'SALESMAN' AND hiredate >= TO_DATE('1981/06/01', 'YYYY/MM/DD');

AND, OR 실습 WHERE8
SELECT *
FROM emp
WHERE deptno != 10 AND hiredate >= TO_DATE('1981/06/01', 'YYYY/MM/DD');
             NOT IN (10)
             
AND, OR 실습 WHERE10
SELECT *
FROM emp
WHERE deptno IN (20, 30) AND hiredate >= TO_DATE('1981/06/01', 'YYYY/MM/DD');

실습 11,12,13,14 과제 및 복습

실습 13
SELECT *
FROM emp
WHERE job = 'SALESMAN'
   OR empno != '78';

연산자 우선순위
조건1 OR 조건2 AND 조건3 -- 조건1이거나 (조건2와조건3)을만족하는거 이거나

정렬
*******매우매우 중요*******
RDBMS는 집합에서 많은 부분을 차용
집합의 특징 : 1.순서가 없다.
             2. 중복을 허용하지 않는다
             (1, 5, 10) == (5, 1, 10 {집합에 순서는 없다.)
             (1, 5, 5, 10) ==> (1, 5, 10) {집합은 중복 허용X}
         
아래 sql의 실행결과, 데이터의 조회 순서는 보장되지 않는다.
지금은 7369, 7499....조회가되지만 내일 동일한 sql을 실행 하더라도 오늘 순서로 나온다는 보장이 없다(바뀔 수 있음)
* 데이터는 보편적으로 데이터를 입력한 순서대로 나온다(근데 이것도 보장은 아님ㅋ)
** table에는 순서가 없다.
SELECT *
FROM emp;

시스템을 만들다 보면 데이터의 정렬이 중요한 경우가 많다
ex)게시판 글 리스트 : 가장 최신글이 가장 위로 와야 한다.

**즉 SELECT 결과 행의 순서를 조정할 수 있어야 한다.
  ==> ORDER BY 구문

문법
SELECT *
FROM 테이블명
[WHERE]
[ORRDER BY 컬럼1, 컬럼2]

SELECT *
FROM emp
ORDER BY job, empno;

오름차순, ASC : 값이 작은 데이터부터 큰 데이터 순으로 나열
내림차순, DESC : 값이 큰 데이터부터 작은 데이터 순으로 나열

ORALCE에서는 기본적으로 오름차순이 기본 값으로 적용됨
내림차순으로 정렬을 원할경우 정렬 기준 컬럼 뒤에 DESC를 붙여 준다.

job컬럼으로 오름차순 정렬하고, 같은 job을 갖는 행끼리는 empno로 내림차순 정렬한다.
SELECT *
FROM emp
ORDER BY job, empno DESC;

참고로만.....중요하진 않음
1.ORDER BY 절에 별칭 사용 가능
SELECT empno eno, ename enm
FROM emp
ORDER BY enm;--별칭
2. ORDER BY 절에 SELECT 절의 컬럼 순서 번호를 기술
SELECT empno, ename
FROM emp
ORDER BY 2; ==>ORDER BY ename
3. expression도 가능
SELECT empno, ename, sal + 500
FROM emp
ORDER BY sal + 500;

실습 orderby1
SELECT *
FROM dept
ORDER BY dname ASC;

SELECT *
FROM dept
ORDER BY dname DESC;

실습 orderby2
SELECT *
FROM emp
WHERE comm IS NOT NULL -- NULL은 비교가 되는게 아니기때문에 안써도 댐
  AND comm != 0
ORDER BY comm DESC, deptno DESC;

실습 orderby3
SELECT *
FROM emp
WHERE mgr IS NOT NULL
ORDER BY job, empno DESC;

실습 orderby4
1.SELECT *
2.FROM emp
3.WHERE deptno IN (10, 30) AND sal >1500
4.ORDER BY ename DESC;
위 sql 해석순서 : 2 - 3 -1 -4

****** 실무에서 매우많이 사용 ******
ROWNUM : 행의 번호를 부여해주는 가상 컬럼
         **조회된 순서대로 번호를 부여
         
1.WHERE 절에 사용하는 것이 가능
    * WHERE ROWNUM = 1  ( = 동등 비교 연산의 경우 1만 가능)
      WHERE ROWNUM BETWEEN 1 AND 5;
      WHERE ROWNUM >= 15;
    ***  ROWNUM은 1번부터 순차적으로 데이터를 읽어 올 때만 사용 가능

SELECT ROWNUM, empno, ename
FROM emp
WHERE ROWNUM = 2; -- 2번부터 시작해서 실행이 안댐

2. ORDER BY 절은 SELECT 이 후에 실행된다
    ** SELECT절에 ROWNUM을 사용하고 ORDER BY절을 적용 하게 되면 원하는 결과를 얻지 못한다. --why? SELECT절이 먼저 실행 되기 때문
    
SELECT ROWNUM, empno, ename
FROM emp
ORDER BY ename;

정령을 먼저 하고, 정렬된 결과에 ROWNUM을 적용
==> INLINE-VIEW
    SELECT 결과를 하나의 테이블 처럼 만들어 준다.

사원정보를 페이징 처리
1페이지에 5명씩 조회
1페이지 = 1~5,    페이지사이즈를 구하는 공식 :(:page-1)*:pageSize+1 ~ :page * :pageSize
2페이지 = 6~10
3페이지 = 11~15

page, pageSize = 5

SELECT *
FROM (SELECT ROWNUM rn, a.*
      FROM
          (SELECT empno, ename --여기서 테이블명을 a라 한이유는 내가 만든 테이블이라서 임의로 붙여준 이름이다.
          FROM emp
          ORDER BY ename) a)
WHERE rn BETWEEN (:page -1) * :pageSize + 1 AND :page * :pageSize; --페이지사이즈를 구하는 공식 : (:page-1)*:pageSize+1 ~ :page * :pageSize  *바인드 변수


SELECT 절에 *를 사용 했는데 ,를 통해 다른 특수 컬럼이나 EXPRESSION을 사용할 경우는 *앞에 해당 데이터가 어떤 테이블에서 왔는지 명시를 해줘야 한다.(한정자)
SELECT ROWNUM, emp.*
FROM emp;

별칭은 테이블에도 적용 가능, 단 컬럼이랑 다르게 AS 옵션이 없다.
SELECT ROWNUM, e.*
FROM emp e;