복습
PRIMARY KEY : PK_테이블명
FOREIGN KEY : FK_소스테이블명_참조테이블명

제약조건 삭제
ALTER TABLE 테이블명 DROP CONSTRAINT 제약조건명;

1. 부서 테이블에 PRIMARY KEY 제약조건 추가
2. 사원 테이블에 PRIMARY KEY 제약조건 추가
3. 사원 테이블-부서 테이블간 FOREIGN KEY 제약조건 추가

제약조건 삭제시는 데이터 입력과 반대로 자식부터 먼저 삭제
3 -(1, 2) 순으로 삭제 1, 2번은 순서 상관 없음

ALTER TABLE 테이블명 DROP CONSTRAINT 제약조건명;
ALTER TABLE emp_test DROP CONSTRAINT FK_emp_test_dept_test;
ALTER TABLE dept_test DROP CONSTRAINT PK_dept_test;
ALTER TABLE emp_test DROP CONSTRAINT PK_emp_test;

SELECT *
FROM user_constraints;

SELECT *
FROM user_constraints
WHERE table_name IN ('EMP_TEST', 'DEPT_TEST');

제약조건 생성
1. dept_test 테이블의 deptno컬럼에 PRIMARY KEY 제약조건 추가
ALTER TABLE dept_test ADD CONSTRAINT PK_dept_test PRIMARY KEY (deptno);
2. emp_test 테이블의 empno컬럼에 PRIMARY KEY 제약조건 추가
ALTER TABLE emp_test ADD CONSTRAINT PK_emp_test PRIMARY KEY (deptno);
3. emp_test 테이블의 deptno컬럼이 dept_test 컬럼의 deptno컬럼을 참조하는
   FOREIGN KEY 제약 조건 추가
ALTER TABLE emp_test ADD CONSTRAINT FK_emp_test_dept_test FOREIGN KEY (deptno)
REFERENCES dept_test (deptno);

오늘
제약조건 활성화-비활성화 테스트
테스트 데이터 준비 : 부모-자식 관계가 있는 테이블에서는 부모 테이블에 데이터를 먼저입력
dept-test --> emp_test
INSERT INTO dept_test VALUES (10, 'ddit', 'deajeon');

INSERT INTO emp_test VALUES (9999, 'brown', 10);
20번 부서가 dept_test 테이블에 존재x 그래서 에러가 난다.
INSERT INTO emp_test VALUES (9998, 'sally', 20);

FK를 비활성화 후 다시 입력
ALTER TABLE emp_test DISABLE CONSTRAINT FK_emp_test_dept_test;
상태가 DISABLE 되어있음.
SELECT *
FROM user_constraints
WHERE table_name IN ('EMP_TEST', 'DEPT_TEST');

FK가 비활성화가 되었기 때문에 정상적으로 실행이 된다.
INSERT INTO emp_test VALUES (9998, 'sally', 20);
COMMIT;

FK 제약조건의 재활성화
ALTER TABLE emp_test ENABLE CONSTRAINT FK_emp_test_dept_test;
WHY? 자식테이블에 20번대 부서번호가 있기때문에 참조가 안댐
INSERT INTO emp_test VALUES (9998, 'sally', 20); ==> 10, NULL, 삭제를 해야 참조가 됨.

테이블, 컬럼 주석(comments) 생성가능
테이블 주석 정보확인
user_tables, user_constraints, user_tab_comments
SELECT *
FROM user_tab_comments;

테이블 주석 작성 방법
COMMENT ON TABLE 테이블명 IS '주석';

EMP 테이블에 주석(사원) 생성하기 
COMMENT ON TABLE emp IS '사원';

컬럼 주석 확인
SELECT *
FROM user_col_comments
WHERE TABLE_NAME = 'EMP';

컬럼 주석 작성 방법
COMMENT ON COLUMN 테이블명.컬럼명 IS '주석';

COMMENT ON COLUMN emp.EMPNO IS '사번';
COMMENT ON COLUMN emp.ENAME IS '사원이름';
COMMENT ON COLUMN emp.JOB IS '담당역할';
COMMENT ON COLUMN emp.MGR IS '매니저 사번';
COMMENT ON COLUMN emp.HIREDATE IS '입사일자';
COMMENT ON COLUMN emp.SAL IS '급여';
COMMENT ON COLUMN emp.COMM IS '성과급';    
COMMENT ON COLUMN emp.DEPTNO IS '소속부서번호';

comments 실습 comment1
SELECT a.table_name, a.table_type, a.comments tab_comment, b.column_name, b.comments col_comment
FROM user_tab_comments a, user_col_comments b
WHERE a.table_name=b.table_name
  AND a.table_name IN ('CUSTOMER', 'PRODUCT', 'CYCLE', 'DAILY');

SELECT *
FROM user_constraints
WHERE table_name IN ('EMP', 'DEPT');

과제
ALTER TABLE emp ADD CONSTRAINT PK_emp PRIMARY KEY (empno);
ALTER TABLE dept ADD CONSTRAINT PK_dept PRIMARY KEY (deptno);
ALTER TABLE emp ADD CONSTRAINT FK_emp_dept FOREIGN KEY (deptno) REFERENCES dept (deptno);
ALTER TABLE emp ADD CONSTRAINT FK_emp_emp FOREIGN KEY (empno) REFERENCES emp (empno);

VIEW : VIEW는 쿼리이다 (VIEW 테이블은 잘못된 표현)
       물리적인 데이터를 갖고 있지 않고, 논리적인 데이터 정의 집합이다(SELECT 쿼리)
       VIEW가 사용하고 있는 테이블의 데이터가 바뀌면 VIEW 조회 결과도 같이 바뀐다.
문법
CREATE OR REPLACE VIEW 뷰이름 AS 
SELECT 쿼리;

emp테이블에서 sal, comm, 컬럼 두개를 제외한 나머지 6개 컬럼으로 v_emp이름으로 view 생성
CREATE OR REPLACE VIEW v_emp AS
SELECT empno, ename, job, mgr, hiredate, deptno
FROM emp;

SELECT *
FROM v_emp;

GRANT CONNECT, RESOURCE TO 계정명; --권한 설정
VIEW에 대한 생성권한은 RESOURCE에 포함되지 않는다.

***SYSTEM 계정으로 접속해서
KHS 계정에게 VIEW 객체를 생성할 수 있는 권한을 부여
GRANT CREATE VIEW TO KHS;

DELETE emp
WHERE deptno = 10;
emp 테이블에서 10번 부서에 속하는 3명을 지웠기 때문에 아래 view의 조회결과도 3명이 지워진 11명만 나온다.
SELECT *
FROM v_emp;

ROLLBACK;

KHS 계정에 있는 v_emp 뷰를 HR계정에게 조회할 수 있도록 권한 부여
GRANT SELECT ON v_emp TO HR;