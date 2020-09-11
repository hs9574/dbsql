exerd의 밴다이어그램 이용

exerd 밴다이어그램의 부모 테이블은 열쇠 표시가 되어 있고 자식 테이블은 f로 되어있다.

데이터 결합 base_tables.sql 실습 join1
SELECT lprod_gu, lprod_nm, prod_id, prod_name
FROM prod, lprod
WHERE prod.prod_lgu = lprod.lprod_gu;

prod 테이블 건수?
SELECT *
FROM cart;

실습 join2
SELECT buyer_id, buyer_name, prod_id, prod_name
FROM buyer, prod
WHERE prod.prod_buyer = buyer.buyer_id;

실습 join3
SELECT mem_id, mem_name, prod_id, prod_name, cart_qty
FROM member, cart, prod
WHERE member.mem_id = cart.cart_member  AND cart.cart_prod = prod.prod_id;

테이블 JOIN 테이블 ON ()
      JOIN 테이블 ON ()
SELECT mem_id, mem_name, prod_id, prod_name, cart_qty
FROM member JOIN cart ON (member.mem_id = cart.cart_member)
     JOIN prod ON (cart.cart_prod = prod.prod_id);

Docker 관련 수업
docker run -d -p 1523:1521 --name docker_oracle oracleinanutshell/oracle-xe-11g
             hostport:guestport
           -d는 백그라운드에서 실행을 해라.  