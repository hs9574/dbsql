khs.v_emp ==> v_emp

SELECT *
FROM khs.v_emp;

CREATE SYNONYM v_emp FOR khs.v_emp;

SELECT *
FROM v_emp;