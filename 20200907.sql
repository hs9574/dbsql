ROWNUM : 1부터 읽어야 한다.
	        SELECT 절이 ORDER BY 절보다 먼저 실행된다.
		⇒ ROWNUM을 이용하여 순서를 부여하려면 정렬부터 해야한다.
			⇒ 인라인 뷰 ( ORDER BY - ROWNUM을 분리)

가상컬럼 ROWNUM실습 row_1

SELECT ROWNUM rn, empno, ename
FROM emp 
WHERE ROWNUM BETWEEN 1 AND 10; 

실습 row_2
SELECT *
FROM (SELECT ROWNUM rn, empno, ename
      FROM emp)
WHERE rn BETWEEN 11 AND 20;

실습 row_3
SELECT *
FROM (SELECT ROWNUM rn, a.*
      FROM (SELECT empno, ename
            FROM emp
            ORDER BY ename)a)
WHERE rn BETWEEN 11 AND 20;


ORALCE함수 분류
*** 1. SINGLE ROW FUNCTION : 단일 행을 작업의 기준, 결과도 한건 반환
2. MULTI ROW FUNCTION : 여러 행을 작업의 기준, 하나의 행을 결과로 반환

dual 테이블
    1. sys 계정에 존재하는 누구나 사용할 수 있는 테이블
    2. 테이블에는 하나의 컬럼, dummy 존재, 값은 x
    3. 하나의 행만 존재
        ***** SIGNLE 
SELECT empno, ename,LENGTH(ename), LENGTH('hello')
FROM emp;

SELECT LENGTH('hello')
FROM dual;

SELECT ename, LOWER(ename)
FROM emp
WHERE LOWER(ename) = 'smith';
                                    --둘다 출력되는 값은 똑같지만 위에 꺼로 쓰면 ename은 실행시마다 달라진다. 그러므로 여러번 실행해줘야 함
SQL 칠거지악
1. 좌변을 가공하지 말아라 (테이블 컬럼에 함수를 사용하지 말것)
    . 함수 실행 횟수 최대한 적게
    . 인덱스 사용관련(추후에) 
SELECT ename, LOWER(ename)
FROM emp
WHERE ename = UPPER('smith');       -- 그냥 대문자로 'SMITH' 이게 제일 간결하고 편함

문자열 관련함수
SELECT CONCAT('Hello', ', World') concat,
       SUBSTR('Hello, World', 1, 5) substr,
       SUBSTR('Hello, World', 1) substr2,
       LENGTH('Hello, World') length,
       INSTR('Hello, World', 'o') instr,
       INSTR('Hello, World', 'o', 6) instr2, --6번째 자리 이후의 o를 찾는다.
       INSTR('Hello, World', 'o', INSTR('Hello, World', 'o') + 1) instr3, --이렇게 써도 됨
       LPAD('Hello, World', 15, '*') lpad,
       LPAD('Hello, World', 15) lpad2,
       RPAD('Hello, World', 15, '*') rpad,
       REPLACE('Hello, World', 'Hello', 'Hell') replace,
       TRIM('     Hello, World      ') trim, --공백 없이 나오는 함수
       TRIM('H' FROM 'Hello, World') trim2 --이렇게 쓰면 H를 제거하는 거로도 쓰임
FROM dual;

숫자 관련 함수
ROUND : 반올림 함수
TRUNC : 버림 함수
    ==> 몇번째 자리에서 반올림, 버림을 할지?
        ROUND(숫자, 반올림 결과 자리수)

SELECT ROUND(105.54, 1) round,
       ROUND(105.55, 1) round2,
       ROUND(105.55, 0) round3,
       ROUND(105.55, -1) round4
FROM dual;

SELECT TRUNC(105.54, 1) trunc,
       TRUNC(105.55, 1) trunc2,
       TRUNC(105.55, 0) trunc3,
       TRUNC(105.55, -1) trunc4
FROM dual;

MOD : 나머지를 구하는 함수
피제수 - 나눔을 당하는 수, 제수 - 나누는 수 --a/b는 a가 피제수 b가 제수

10을 3으로 나눴을 때의 몫을 구하기
SELECT MOD(10, 3), TRUNC(10/3, 0)
FROM dual; 

날짜 관련함수
문자열 ==> 날짜 타입 TO_DATE
SYSDATE : 오라클 서버의 현재 날짜, 시간을 돌려주는 특수함수
          함수의 인자가 없다.
          (java
          public void test(){
          }
          test();
          
          sql
          length('hello, world')
          SYSDATE;)
          
SELECT SYSDATE       /*sysdate()이렇게 안써줘도 된다는게 인자가 없다는 뜻*/
FROM dual;

날짜 타입 +- 정수(일자) : 날짜에서 정수만큼 더한(뺀) 날짜
하루 = 24H
1H = 1/24일
1/24일/60 = 1m
1/24일/60/60 = 1s    -- 일/시/분/초

SELECT SYSDATE, SYSDATE +5, SYSDATE -5,
       SYSDATE + 1/24, SYSDATE + 1/24/60
FROM dual;

DATE 실습 fn1
SELECT TO_DATE('2019/12/31', 'YYYY/MM/DD') LASTDAY, TO_DATE('2019/12/31', 'YYYY/MM/DD') -5 LASTDAY_BEFORE5, SYSDATE NOW, SYSDATE -3 NOW_BEFORE
FROM dual;

날짜를 어떻게 표현할까?
java : java.utill.Date
sql : nsl 포맷에 설정된 문자열 형식을 따르거나
      ==> 툴 때문일 수도 있음 예측하기 힘듬.
      TO_DATE 함수를 이용하여 명확하게 명시
SELECT TO_DATE('2019/12/31', 'YYYY/MM/DD') LASTDAY
FROM dual;