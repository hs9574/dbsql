데이터 결합 실습 join4
SELECT customer.cid, cnm, pid, day, cnt
FROM customer, cycle
WHERE customer.cid = cycle.cid
  AND cnm In ('brown', 'sally');
  
실습 join5
SELECT cycle.cid, cnm, cycle.pid, pnm, day, cnt
FROM customer, cycle, product
WHERE customer.cid = cycle.cid
  AND product.pid = cycle.pid
  AND cnm IN ('brown', 'sally');

실습6~13까지 과제
a.cid, a.cnm, p.pid, p.pnm, a.cnt
실습 join6
SELECT customer.cid, customer.cnm, cycle.pid, product.pnm, SUM(cycle.cnt) cnt
FROM cycle, customer, product
WHERE customer.cid = cycle.cid
  AND product.pid=cycle.pid
GROUP BY cycle.pid, customer.cnm, customer.cid, product.pnm;

실습 join7
SELECT cycle.pid, product.pnm, SUM(cycle.cnt) cnt
FROM cycle, product
WHERE cycle.pid=product.pid
GROUP BY cycle.pid, product.pnm;

SYSTEM에 접속해
SELECT *
FROM dba_users;

아래 쿼리 실행하면 비번 설정 가능  
CREATE USER khs IDENTIFIED BY 비밀번호;

ALTER USER hr IDENTIFIED BY java ACCOUNT UNLOCK;

JOIN구분
1. 문법에 따른 구분 : ANSI-SQL, ORACLE
2. join의 형태에 따른 구분 : SELF-JOIN, NONEQUI-JOIN, CROSS-JOIN
3. join 성공여부에 따라 데이터 표시여부 
        : INNER JOIN - 조인이 성공했을 때 데이터를 표시
        : OUTER JOIN - 조인이 실패해도 기준으로 정한 테이블의 컬럼 정보는 표시
        
사번, 사원의이름, 관리자사번, 관리자 이름
KING(PRESIDENT)의 경우 MGR 컬럼의 값이 NULL 이기 때문에 조인 실패 ==> 13건 조회
SELECT e.empno, e.ename, e.mgr, m.ename mgr_name 
FROM emp e JOIN emp m ON (e.mgr =m.empno);

ANSI-SQL
SELECT e.ename, e.ename, e.mgr, m.ename mgr_name
FROM emp e LEFT OUTER JOIN emp m ON (e.mgr=m.empno);
--똑같은 값이 나온다
SELECT e.ename, e.ename, e.mgr, m.ename mgr_name
FROM emp m RIGHT OUTER JOIN emp e ON (e.mgr=m.empno);

ORACLE-SQL : 데이터가 없는 쪽의 모든컬럼에 (+) 기호를 붙인다
             ANSI-SQL 기준 테이블 반대편 테이블의 컬럼에 (+)을 붙인다.
             WHERE절 연결 조건에 적용
SELECT e.ename, e.ename, e.mgr, m.ename 
FROM emp e, emp m 
WHERE e.mgr=m.empno(+);

행에 대한 제한 조건 기술 시 WHERE절에 기술 했을 때와 ON 절에 기술 했을 때 결과가 다르다.
사원의 부서가 10번인 사람들만 조회 되도록 부서 번호 조건을 추가
SELECT e.ename, e.ename, e.deptno, e.mgr, m.ename mgr_name, m.deptno
FROM emp e LEFT OUTER JOIN emp m ON (e.mgr=m.empno AND e.deptno = 10);

조건을 WHERE 절에 기술한 경우 ==> OUTER JOIN이 아닌 INNER 조인 결과가 나온다.
SELECT e.ename, e.ename, e.deptno, e.mgr, m.ename mgr_name, m.deptno
FROM emp e LEFT OUTER JOIN emp m ON (e.mgr=m.empno)
WHERE e.deptno = 10;
--NULL값 빼고 똑같음
SELECT e.ename, e.ename, e.deptno, e.mgr, m.ename mgr_name, m.deptno
FROM emp e JOIN emp m ON (e.mgr=m.empno)
WHERE e.deptno = 10;

UNION은 합집합이다.
SELECT e.ename, m.ename
FROM emp e LEFT OUTER JOIN emp m ON (e.mgr=m.empno)
UNION
SELECT e.ename, m.ename
FROM emp e RIGHT OUTER JOIN emp m ON (e.mgr=m.empno)
MINUS
SELECT e.ename, m.ename
FROM emp m FULL OUTER JOIN emp e ON (e.mgr=m.empno);

INTERSECT는 약간 +느낌
SELECT e.ename, m.ename
FROM emp e LEFT OUTER JOIN emp m ON (e.mgr=m.empno)
UNION
SELECT e.ename, m.ename
FROM emp e RIGHT OUTER JOIN emp m ON (e.mgr=m.empno)
INTERSECT
SELECT e.ename, m.ename
FROM emp m FULL OUTER JOIN emp e ON (e.mgr=m.empno);

outer join 실습 outejoin1
SELECT b.buy_date, b.buy_prod, p.prod_id, p.prod_name, b.buy_qty
FROM buyprod b RIGHT OUTER JOIN prod p ON (b.buy_prod=p.prod_id 
 AND buy_date =TO_DATE('05/01/25', 'YY/MM/DD'));

SELECT b.buy_date, b.buy_prod, p.prod_id, p.prod_name, b.buy_qty
FROM buyprod b, prod p
WHERE b.buy_prod(+)=p.prod_id
 AND b.buy_date(+)=TO_DATE('05/01/25', 'YY/MM/DD');
 
 hr
 cid : customer id
cnm : customer name
SELECT *
FROM customer;

product : 제품
SELECT *
FROM product;

cycle : 고객애음주기
day : 1~7(일~토)
cnt : count, 수량
SELECT *
FROM cycle;

실습 join8
SELECT countries.region_id, regions.region_name, countries.country_name
FROM countries, regions
WHERE countries.region_id=regions.region_id
  AND region_name = 'Europe';

실습 join9
SELECT countries.region_id, regions.region_name, countries.country_name, locations.city
FROM countries, regions, locations
WHERE countries.region_id=regions.region_id
  AND countries.country_id=locations.country_id
  AND region_name = 'Europe';
  
실습 join10
SELECT countries.region_id, regions.region_name, countries.country_name, locations.city,
       departments.department_name
FROM countries, regions, locations, departments
WHERE countries.region_id=regions.region_id
  AND countries.country_id=locations.country_id
  AND locations.location_id=departments.location_id
  AND region_name = 'Europe';

실습 join11
SELECT countries.region_id, regions.region_name, countries.country_name, locations.city,
       departments.department_name, CONCAT(employees.first_name, employees.last_name) name 
FROM countries, regions, locations, departments, employees
WHERE countries.region_id=regions.region_id
  AND countries.country_id=locations.country_id
  AND locations.location_id=departments.location_id
  AND departments.department_id=employees.department_id
  AND region_name = 'Europe';
  
실습 join12
SELECT employees.employee_id, CONCAT(employees.first_name, employees.last_name) name,
       employees.job_id, jobs.job_title
FROM employees, jobs
WHERE employees.job_id=jobs.job_id;

실습 join13
SELECT m.employee_id mgr_id, CONCAT(m.first_name, m.last_name) mgr_name, e.employee_id, CONCAT(e.first_name, e.last_name) name,
       jobs.job_id, jobs.job_title
FROM employees e, employees m, jobs
WHERE e.job_id=jobs.job_id
  AND e.manager_id=m.employee_id;