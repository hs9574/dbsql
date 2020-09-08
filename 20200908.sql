날짜 데이터 : emp.hiredate
             SYSDATE

TO_CHAR(날짜타입, '변경할 문자열 포맷')
TO_DATE('날자문자열', '첫번째 인자의 날짜 포맷')
TO_CHAR, TO_DATE 첫번째 인자 값을 넣을 때 문자열인지, 날짜인지 구분!!!

현재 설정된 NLS DATE FORMAT : YYYY/MM/DD HH24:MI:SS

SELECT SYSDATE, TO_CHAR(SYSDATE, 'DD-MM-YYYY'),
       TO_CHAR(SYSDATE, 'D'), TO_CHAR(SYSDATE, 'IW')
FROM dual;

SELECT ename, 
       --SUBSTR('20200908', 1, 4) || '/' || SUBSTR('20200908', 5, 2) || '/' ||SUBSTR('20200908', 7, 2),
       hiredate, TO_CHAR(hiredate, 'yyyy/mm/dd hh24:mi:ss') h1,
       TO_CHAR(hiredate + 1, 'yyyy/mm/dd hh24:mi:ss') h2,
       TO_CHAR(hiredate + 1/24, 'yyyy/mm/dd hh24:mi:ss') h3,
       TO_CHAR(TO_DATE('20200908', 'YYYYMMDD'), 'YYYY/MM/DD') h4
FROM emp;

날짜 : 일자 + 시분초
2020년 9월 8일 14시 10분 5초 ==> '20200908' ==> 2020년 9월 8일 00시 0분 0초
SELECT TO_DATE(TO_CHAR(SYSDATE, 'YYYYMMDD')) --시분초 날려버릴려고 이렇게 함
FROM DUAL;

DATE 실습 fn2
SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DD') DT_DASH,
       TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS') DT_DASH_WITH_TIME,
       TO_CHAR(SYSDATE, 'DD-MM-YYYY') DT_DD_MM_YYYY
FROM dual;

날짜 조작 함수
..MONTHS_BETWEEN(date1, date2) : 두 날짜 사이의 개월수를 반환
                               두 날짜의 일정보가 틀리면 소수점이 나오기 때문에 잘 사용X
*** ADD_MONTHS(DATE, NUMBER) : 주어진 날짜에 개월수를 더하거나 뺀 날짜를 반환
                           한달이라는 기간이 월마다 다름 - 직접 구현이 힘듬
ADD_MONTHS(SYSDATE, 5) : 오늘 날짜로부터 5개월 뒤의 날짜는 몇일인가

** NEXT_DAY(DATE, NUMBER(주간요일: 1~7) ) : DATE이후에 등장하는 첫번째 주간 요일을 갖는 날짜
NEXT_DAY(SYSDATE, 6) : SYSDATE이후에 등장하는 첫번째 금요일에 해당하는 날짜

***** LAST_DAY(DATE) : 주어진 날짜가 속한 월의 마지막 일자를 날짜로 반환
LAST_DAY(SYSDATE) : SYSDATE(2020/09/08)가 속한 9월의 마지막 날짜 : 2020/09/30
                    월마다 마지막 일자가 다르기 때문에 해당 함수를 통해서 편하게 마지막 일자를 구할 수 있다.
해당월의 가장 첫 날짜를 반환하는 함수는 없다 ==> 모든 월의 첫 날짜는 1일이기 때문에

SELECT MONTHS_BETWEEN(TO_DATE('20200915', 'YYYYMMDD'), TO_DATE('20200808', 'YYYYMMDD')) WW,
       ADD_MONTHS(SYSDATE, 5),
       NEXT_DAY(SYSDATE, 6),
       LAST_DAY(SYSDATE),
       TO_DATE('01', 'DD'),
       ADD_MONTHS(LAST_DAY(SYSDATE), -1) + 1,
       SYSDATE - TO_CHAR(SYSDATE, 'DD') + 1
FROM dual;

SYSDATE가 속한 월의 첫날짜 구하기
       (2020년 9월 8일 ==> 2020년 9월 1일의 날짜 타입으로 어떻게든 구하기)
       1. TO_DATE(TO_CHAR(SYSDATE, 'YYYYMM') || '01', 'YYYYMMDD') 
       2. --원래 이건데 TO_DATE('01', 'DD')이게 됨 제일 간편
       3. ADD_MONTHS(LAST_DAY(SYSDATE), -1) + 1
       4. SYSDATE -TO_CHAR(SYSDATE, 'DD') + 1,
       
date 종합 실습 fn3
SELECT TO_CHAR(TO_DATE( :YYYYMM, 'YYYYMM'), 'YYYYMM') PARAM,
       TO_CHAR(LAST_DAY(TO_DATE( :YYYYMM, 'YYYYMM')), 'DD')  DT
FROM dual;

형변환
명시적 형변환
    TO_CHAR, TO_DATE, TO_NUMBER
묵시적 형변환
    ..... ORACLE DBMS가 상황에 맞게 알아서 해주는 것
    JAVA시간에 8가지 원시 타입(primitive type) 간 형변환
    1가지 타입이 다른 7가지 타입으로 변환될 수 있는지

두가지 가능한 경우
1. empno(숫자)를 문자로 묵시적 형변환
2. '7369'(문자)를 숫자로 묵시적 형변환
SELECT *
FROM emp
WHERE empno = '7369';

알면 매우 좋다. 몰라도 수업 진행하는데 문제 없고, 추후 취업해서도 큰 지장은 없다만 고급 개발자와 일반 개발자
를 구분하는 차이점이 됨.

실행계획 : 오라클에서 요청받은 SQL을 처리하기 위한 절차를 수립한 것
실행계획 보는 방법
1.EXPLAIN PLAN FOR
  실행계획을 분석할 SQL;
2.SELECT *
  FROM TABLE(dbms_xplan.display);
  
실행계획의 operation을 해석하는 방법
1. 위에서 아래로
2. 단 자식노드(들여쓰기가 된 노드)있을 경우 자식부터 실행하고 본인 노드를 실행
  
EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE empno = '7369';

TABLE 함수 : PL/SQL의 테이블 타입 자료형을 테이블로 변환
SELECT *
FROM TABLE(dbms_xplan.display);   --TO_CHAR()와 비슷한 것. JAVA의 패키지명.클래스명(java.lang.String
실행계획 순서 : 1 > 0
   1 - filter("EMPNO"=7369) --자동적으로 형변환이 됨

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE TO_CHAR(empno) = '7369';

SELECT *
FROM TABLE(dbms_xplan.display);

숫자를 문자로 포맷팅 : DB보다는 국제화(i18n)에서 더 많이 활용
                        I nternationalizatio n
SELECT empno, ename, sal, TO_CHAR(sal, '009,999L')
FROM emp;

이제까지 배운거

함수
    문자열
    날짜
    숫자
    null과 관련된 함수 : 4가지 (다 못외워도 괜춘, 한가지를 주로 사용)
    오라클의 NVL 함수와 동일한 역할을 하는 MS-SQL SERVER의 함수이름?
    
NULL의 의미? 아직 모르는 값, 할당되지 않은 값
            0과, ' ' 문자와는 다르다
NULL의 특징 : null을 포함한 연산의 결과는 항상 NULL이다.

sal 컬럼에는 null이 없지만. comm에는 4개의 행을 제외하고 10개의 행이 null값을 갖는다.
SELECT ename, sal, comm, sal+comm
FROM emp;

NULL과 관련된 함수
1. NVL(컬럼 || 익스프레션, 컬럼 || 익스프레션)
   NVL(expr1, expr2)
   
   java
   if(expr1 == null)
    System.out.println(expr2);
   else
    System.out.println(expr1);
    
SELECT empno, comm, sal+comm, sal+NVL(comm, 0)
FROM emp;