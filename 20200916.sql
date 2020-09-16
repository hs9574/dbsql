문제를 풀때
1.정답 조회 하는 쿼리 작성
2. SQL에 불필요한 부분이 없는지 점검

 본인이 속한 부서의 급여 평균보다 높은 급여를 받는 사람들을 조회
 SELECT *
 FROM emp e
 WHERE sal > (SELECT AVG(sal)
              FROM emp
              WHERE deptno = e.deptno);
              
실습 sub4
테스트용 데이터 추가
DESC dept;
INSERT INTO dept VALUES (99, 'ddit', 'daejeon');

SELECT *
FROM dept
WHERE deptno NOT IN (SELECT deptno  
                     FROM emp);
                     
실습 sub5
SELECT pid, pnm
FROM product
WHERE pid NOT IN (SELECT pid
                  FROM cycle
                  WHERE cid = 1)
GROUP BY pid, pnm;

실습 sub6
SELECT *
FROM cycle
WHERE pid IN (SELECT pid
              FROM cycle
              WHERE cid=2)
  AND cid = 1;
    
과제실습 sub7
SELECT c.cid, s.cnm, c.pid, p.pnm, day, cnt
FROM cycle c, customer s, product p
WHERE c.cid=s.cid
  AND c.pid=p.pid
  AND c.pid IN (SELECT pid
              FROM cycle
              WHERE cid= 2)
  AND c.cid =1;

EXISTS 연산자 : 조건을 만족하는 서브 쿼리의 행이 존재하면 TRUE

매니저가 존재하는 사원 정보 조회
SELECT *
FROM emp e
WHERE EXISTS (SELECT 'x'
              FROM emp m
              WHERE e.mgr = m.empno);
              
EXISTS 연산자 실습 sub8
SELECT *
FROM emp a
WHERE EXISTS (SELECT 'X'
              FROM emp b
              WHERE b.empno = a.mgr);
              
SELECT a.*
FROM emp a, emp b
WHERE b.empno = a.mgr;

실습 sub9
SELECT p.pid, pnm
FROM product p
WHERE EXISTS (SELECT 'x'
              FROM cycle 
              WHERE p.pid=pid
                AND cid=1);

실습 sub10
SELECT p.pid, pnm
FROM product p
WHERE NOT EXISTS (SELECT *
                  FROM cycle 
                  WHERE p.pid=p id
                    AND cid =1);
                    
집합연산자 : 알아두자
수학의 집합 연산
A = ( 1, 3, 5}
B = { 1, 4, 5}
합집합 : A U B = {1, 3, 4, 5}  교환법칙 성립
교집합 : A ^ B = {1, 5}        교환법칙 성립
차집합 : A - B = {3}           교환법칙 성립X 

SQL에서의 집합 연산자
합집합 : UNION : 수학적 합집합과 개념이 동일(중복을 허용하지 않음)
                중복을 체크 ==> 두 집합에서 중복된 값을 확인 ==> 연산이 느림
        UNION ALL : 수학적 합집합 개념을 떠나 두개의 집합을 단순히 합친다(중복 데이터 존재가능)
                    중복 체크 없음 ==> 두 집합에서 중복된 값 확인 없음 ==> 연산이 빠름
                    ** 개발자가 두개의 집합에 중복되는 데이터가 없다는 것을 알 수 있는
                    상황이라면 UNION 연산자를 사용하는 것보다 UNION ALL 을 사용하여 
                    (오라클이 하는)연산을 절약할 수 있다.
        INTERSECT : 수학적 교집합 개념과 동일
        MINUS : 수학적 차집합 개념과 동일

위아래 집합이 7369번사번은 중복이기 때문에 3행이 나옴
SELECT empno, ename
FROM emp
WHERE empno IN (7369, 7566)
UNION
SELECT empno, ename
FROM emp
WHERE empno IN (7369, 7782);

UNION ALL 연산자는 중복제거 단계가 없다. 총 데이터 4개의 행
SELECT empno, ename
FROM emp
WHERE empno IN (7369, 7566)
UNION ALL
SELECT empno, ename
FROM emp
WHERE empno IN (7369, 7782);

두집합의 공통된 부분은 7369행 밖에 없음 : 총 데이터 1행
SELECT empno, ename
FROM emp
WHERE empno IN (7369, 7566)
INTERSECT
SELECT empno, ename
FROM emp
WHERE empno IN (7369, 7782);

윗쪽 집합에서 아래쪽 집합의 행을 제거하고 남은 행 : 1개의 행(7566)
SELECT empno, ename
FROM emp
WHERE empno IN (7369, 7566)
MINUS
SELECT empno, ename
FROM emp
WHERE empno IN (7369, 7782);

집합연산자 사용시 특징
1. 컬럼명은 첫번째 집합의 컬럼명에 따라간다
2. order by 절은 마지막 집합에 적용 한다
    마지막 sql이 아닌 SQL에서 정렬을 사용하고 싶은 경우 INLINE-VIEW를 활용
    UNOIN ALL의 경우 위, 아래 집합을 이어 주기 때문에 집합의 순서를 그대로 유지
    하기 때문에 요구사항에 따라 정렬된 데이터 집합이 필요하다면 해당 방법을 고려
SELECT empno e, ename
FROM emp
WHERE empno IN (7369, 7566)
--ORDER BY ename
UNION ALL
SELECT empno, ename
FROM emp
WHERE empno IN (7369, 7782)
ORDER BY ename;