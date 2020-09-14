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