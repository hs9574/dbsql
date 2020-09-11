많이 쓰이는 함수, 잘 알아두자
(개념 적으로 혼돈하지 말고 잘 정리하자 - SELECT 절에 올 수 있는 컬럼에 대해 잘 정리)

그룹함수 : 여러개의 행을 입력으로 받아 하나의 행으로 결과를 반환하는 함수

오라클 제공 그룹함수
MIN(컬럼|익스프레션) : 그룹중의 최소값을 반환
MAX(컬럼|익스프레션) : 그룹중의 최대값을 반환
AVG(컬럼|익스프레션) : 그룹의 평균값을 반환
SUM(컬럼|익스프레션) : 그룹의 합계값을 반환
COUNT(컬럼 | 익스프레션 | *) : 그룹핑된 행의 갯수

SELECT 행을 묶을 컬럼, 그룹함수
FROM 테이블명
[WHERE]
GROUP BY 행을 묶을 컬럼
[HAVING 그룹함수 체크조건];

SELECT *
FROM emp
ORDER BY deptno;

그룹함수에서 많이 어려워 하는 부분
SELECT 절에 기술할 수 있는 컬럼의 구분 : GROUP BY 절에 나오지 않은 컬럼이 SELECT 절에 나오면 에러

SELECT deptno, COUNT(*), MIN(sal), MAX(sal), SUM(sal), AVG(sal)
FROM emp
GROUP BY deptno;

전체 직원(모든 행을 대상으로))중에 가장 많은 급여를 받는 사람의 값
 : 전체 행을 대상으로 그룹핑 할 경우 GROUP BY 절을 기술하지 않는다.
SELECT deptno, MAX(sal)
FROM emp
GROUP BY deptno;

전체 직원 중에 가장 큰 급여 값을 알수는 있지만 해당 급여를 받는 사람이 누군지는 그룹함수만 이용해서
는 구할 수가 없다.
=emp테이블에서 가장 큰 급여를 받는 사람의 값이 5000인 것은 알지만 해당 사원이 누구인지는 그룹함수만
사용해서는 누군지 식별할 수 없다.
    ==> 추후 진행
SELECT deptno, MAX(sal)
FROM emp;--X


COUNT 함수 * 인자
* : 행의 개수를 반환
컬럼 | 익스프레션 : NULL값이 아닌 행의 개수 반환

SELECT COUNT(*), COUNT(mgr), COUNT(comm)
FROM emp;

그룹함수의 특징 : NULL값을 무시
NULL연산의 특징 : 결과가 항상 NULL이다.

SELECT SUM(comm)
FROM emp;

SELECT SUM(sal+comm), SUM(sal)+SUM(comm)
FROM emp;

그룹함수 특징2 : 그룹화와 관련없는 상수들은 SELECT 절에 기술할 수 있다.
SELECT deptno, SYSDATE, 'TEST', 1, COUNT(*)
FROM emp
GROUP BY deptno;

그룹함수 특징3 :
    SINGLE ROW 함수의 경우 WHERE 절에 기술하는 것이 가능하다.
    ex : SELECT *
         FROM emp
         WHERE ename = UPPER('smith');
         
    그룹함수의 경우 WHERE 절에서 사용하는 것이 불가능하다.
        ==> HAVING 절에서 그룹함수에 대한 조건을 기술하여 행을 제한 할 수 있다.
        
        그룹함수는 WHERE 절에 사용 불가
        SELECT deptno, COUNT(*)
        FROM emp
        WHERE COUNT(*) >=5
        GROUP BY deptno;
        
        그룹함수에 대한 행 제한은 HAVING 절에 기술
        SELECT deptno, COUNT(*)
        FROM emp
        GROUP BY deptno
        HAVING COUNT(*) >= 5;
        
질문]GROUP BY 를 사용하면 WHERE 절을 사용 못하나?
GROUP BY에 대상이 되는 행들을 제한할 때 WHERE 절을 사용

SELECT deptno, COUNT(*)
FROM emp
WHERE sal > 1000
GROUP BY deptno;
        
group function 실습 grp1
SELECT MAX(sal) max_sal, MIN(sal) min_sal, ROUND(AVG(sal),2) avg_sal,
       SUM(sal) sum_sal, COUNT(sal) count_sal, COUNT(mgr) count_mgr, COUNT(*) count_all
FROM emp;

실습 grp2
SELECT deptno, MAX(sal) max_sal, MIN(sal) min_sal, ROUND(AVG(sal),2) avg_sal,
       SUM(sal) sum_sal, COUNT(sal) count_sal, COUNT(mgr) count_mgr, COUNT(*) count_all
FROM emp
GROUP BY deptno;

**GROUP BY 절에 기술한 컬럼이 SELECT 절에 오지 않아도 실행에는 문제는 없다.

실습 grp3
SELECT DECODE(deptno, 10, 'ACCOUNTING',
                      20, 'RESEARCH',
                      30, 'SALES',
                      40, 'OPERATIONS',
                      'DDIT') dname,
       MAX(sal) max_sal, MIN(sal) min_sal, ROUND(AVG(sal),2) avg_sal,
       SUM(sal) sum_sal, COUNT(sal) count_sal, COUNT(mgr) count_mgr, COUNT(*) count_all
FROM emp
GROUP BY deptno
ORDER BY dname;

실습 grp4
SELECT TO_CHAR(hiredate, 'YYYYMM') hire_yyyymm, COUNT(hiredate) cnt
FROM emp
GROUP BY TO_CHAR(hiredate, 'YYYYMM');

실습 grp5
SELECT TO_CHAR(hiredate, 'YYYY') hire_yyyymm, COUNT(hiredate) cnt
FROM emp
GROUP BY TO_CHAR(hiredate, 'YYYY');

실습 grp6
SELECT COUNT(*) cnt
FROM dept;

실습 grp7
SELECT COUNT(COUNT(deptno)) cnt
FROM emp
GROUP BY deptno;

SELECT COUNT(*)
FROM (SELECT deptno
      FROM emp
      GROUP BY deptno) a;

******WHERE + JOIN SELECT SQL의 모든것******
JOIN : 다른 테이블과 연결하여 데이터를 확장하는 문법
        . 컬럼을 확장
**행을 확장 - 집합연산자(UNION, INTERSECT, MINUS) -- 나중에 배움

JOIN 문법 구분
    1. ANSI - SQL
        : RDBMS에서 사용하는 SQL 표준 문법
          (표준을 잘 지킨 모든 RDBMS-MYSQL, MSSQL, POSTGRESQL... 에서 실행가능)
    2. ORACLE - SQL
        : ORACLE사 만의 고유 문법
        
회사에서 요구하는 형태로 따라가자.

NATURAL JOIN : 조인하고자 하는 테이블의 컬럼명이 같은 컬럼끼리 연결
               컬럼의 값이 같은 행들끼리 연결
    ANSI-SQL
    
    SELECT 컬럼
    FROM 테이블명 NATURAL JOIN 테이블명;
    
조인 컬럼에 테이블 한정자를 붙이면 NATURAL JOIN 에서는 에러로 취급
emp.deptno ==> deptno
컬럼이 한쪽 테이블에만 존재할 경우 굳이 한정자 안붙여도 됨
emp.empno (o), empno (o)

SELECT emp.empno, deptno
FROM dept NATURAL JOIN emp;

NATURAL JOIN 을 ORACLE 문법으로
1. FROM 절에 조인할 테이블을 나열한다(,)
2. WHERE 절에 테이블 조인 조건을 기술한다.

SELECT *
FROM emp, dept
WHERE emp.deptno = dept.deptno;

ORA-00918: column ambiguously defined
컬럼이 여러개의 테이블에 동시에 존재하는 상황에서 테이블 한정자를 붙이지 않아서 오라클
입장에서는 해당 컬럼이 어떤 테이블의 컬럼인지 알 수가 없을 때 발생.
deptno 컬럼은 emp, dept 테이블 양쪽 모두에 존재.
SELECT *
FROM emp, dept
WHERE deptno = deptno;

인라인뷰 별칭처럼, 테이블 별칭을 부여하는게 가능
컬럼과 다르게 AS 키워드는 붙이지 않는다.
SELECT *
FROM emp e, dept d
WHERE e.deptno = d.deptno;


ANSI-SQL : JOIN WITH USING
    조인 하려는 테이블간 같은 이름의 컬럼이 2개 이상일 때 하나의 컬럼으로만 조인을 하고 싶을 때 사용
SELECT *
FROM emp JOIN dept USING (deptno);

ORACLE 문법
SELECT *
FROM emp, dept
WHERE emp.deptno = dept.deptno;

ANSI-SQL : JOIN WITH ON - 조인 조건을 '개발자가 직접' 기술
           NATURAL JOIN, JOIN WITH USING 절을 JOIN WITH ON 절을 통해 표현 가능

SELECT *
FROM emp JOIN dept ON (emp.deptno = dept.deptno);
WHERE emp.deptno IN (20, 30);

ORACLE 문법
SELECT *
FROM emp, dept
WHERE emp.deptno = dept.deptno
  AND dept.deptno IN (20, 30);
  
논리적인 형태에 따른 조인 구분
1. SELF JOIN : 조인하는 테이블이 서로 같은 경우

SELECT e.empno,e.ename, e.mgr, m.ename
FROM emp e JOIN emp m ON (e.mgr = m.empno);

ORACLE 문법
SELECT e.empno, e.ename, e.mgr, m.ename
FORM emp e, emp m 
WHERE e.mgr = m.empno;
KING의 경우 mgr 컬럼의 값이 NULL이기 때문에 e.mgr = m.empno 조건을 충족 시키지 못함
그래서 조인 실패해서 14건 중 13건의 데이터만 조회

2. NONEQUI JOIN : 조인 조건이 =이 아닌 조인
SELECT *
FROM emp, dept
WHERE emp.empno=7369
  AND emp.deptno != dept.deptno;

sal를 이용하여 등급을 구하기
SELECT empno, ename, sal, grade
FROM emp, salgrade
WHERE losal <= sal
  AND hisal >= sal;
  
SELECT empno, ename, sal, grade
FROM emp, salgrade
WHERE sal BETWEEN losal AND hisal;

위의 SQL을 ANSI-SQL로 변경
SELECT empno, ename, sal, grade
FROM emp JOIN salgrade ON (sal BETWEEN losal AND hisal);

데이터결합 실습 JOIN0~0_4 과제 추가
실습 join0
SELECT empno, ename, e.deptno, dname
FROM emp e, dept d
WHERE e.deptno = d.deptno
ORDER BY deptno;

실습 join0_1
SELECT e.empno, e.ename, e.deptno,d.dname
FROM emp e, dept d
WHERE e.deptno = d.deptno
  AND d.deptno IN (10, 30)
ORDER BY empno;

SELECT empno, ename, emp.deptno, dname
FROM emp JOIN dept ON (emp.deptno = dept.deptno
  AND emp.deptno IN (10, 30))
ORDER BY empno;

실습 join0_2
SELECT empno, ename, sal, d.deptno, dname
FROM emp e, dept d
WHERE e.deptno = d.deptno
  AND sal > 2500
ORDER BY sal DESC;

SELECT empno, ename, sal, d.deptno, dname
FROM emp e JOIN dept d ON (e.deptno = d.deptno
 AND sal > 2500)
ORDER BY sal DESC;

실습 join0_3
SELECT empno, ename, sal, d.deptno, dname
FROM emp e, dept d
WHERE e.deptno = d.deptno
  AND sal > 2500
  AND empno > 7600
ORDER BY sal DESC;

SELECT empno, ename, sal, d.deptno, dname
FROM emp e JOIN dept d ON (e.deptno = d.deptno
  AND sal > 2500
  AND empno > 7600)
ORDER BY sal DESC;

실습 join0_4
SELECT empno, ename, sal, d.deptno, dname
FROM emp e, dept d
WHERE e.deptno = d.deptno
  AND sal > 2500
  AND e.empno > 7600
  AND dname = 'RESEARCH'
ORDER BY ename;

SELECT empno, ename, sal, d.deptno, dname
FROM emp e JOIN dept d ON (e.deptno = d.deptno
  AND sal > 2500
  AND e.empno > 7600
  AND dname = 'RESEARCH')
ORDER BY ename ;