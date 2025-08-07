  # SELECT STATEMENT 
 use parks_and_recreation;
 SELECT * # for whole table
 FROM parks_and_recreation.employee_demographics; # here db is selected and then table name 
 
 # for specific columns/column 
 SELECT first_name, 
 last_name, 
 birth_date
 FROM parks_and_recreation.employee_demographics;
 
 -- calculataion on columns 
  SELECT first_name, 
 last_name, 
 birth_date,
 age,
 ( age+10)*10+10
 FROM parks_and_recreation.employee_demographics;
 -- any calculation follows the rule of pemdas paraenthesis, exponent, multiply, divide, add
 
 # distinct 
 SELECT  DISTINCT gender
 FROM parks_and_recreation.employee_demographics;
 
 # for multipe coluns it will consider both combination as a unique value
  SELECT  DISTINCT first_name,gender
 FROM parks_and_recreation.employee_demographics;
 
 # THANK YOU!
 
 
 # WHERE CLAUSE 
 -- use to help filter rows of data where as the select statement is used to have fiter or select actual columns 
 SELECT * 
 FROM parks_and_recreation.employee_salary
 where salary >= 50000
 ;
  SELECT * 
 FROM parks_and_recreation.employee_salary
 where salary <= 50000
 ;
   SELECT * 
 FROM parks_and_recreation.employee_demographics
 where gender != 'female'# here is not operator is being used 
 ;
 
  SELECT * 
 FROM parks_and_recreation.employee_demographics
 where birth_date> '1985-01-01'
 ;
 
 -- logical operators 
   SELECT * 
 FROM parks_and_recreation.employee_demographics
 where birth_date> '1985-01-01'
 and gender = 'male'
 ;
 # LOGICAL OPERATORS 
 -- =, !=, <, >, >=, <=, 
    SELECT * 
 FROM parks_and_recreation.employee_demographics
 where (birth_date> '1985-01-01' and age = 44) or age> 55
 ;
 
 # LIKE STATEMENT 
 -- to look for specific pattern 
 -- any character 
 -- _ specific character 
     SELECT * 
 FROM parks_and_recreation.employee_demographics
 where first_name like '%er%' # anything comes before anything comes after only er should come into it.
 ;
 
 
     SELECT * 
 FROM parks_and_recreation.employee_demographics
 where first_name like 'a%' # name starting with a 
 ;
      SELECT * 
 FROM parks_and_recreation.employee_demographics
 where first_name like 'a__' # name starting with a and then has only two charaters after it 
 ;
 SELECT *
 FROM parks_and_recreation.employee_demographics
 where first_name like 'a___%' # starting with a and then 3 characters and then anything after that
 ;
  SELECT *
 FROM parks_and_recreation.employee_demographics
 where birth_date like '1989' # filtering wrt birthdate 
 ;
 
 
 # GROUP BY AND ORDER BY 
 -- group by, group togather rows that have  the same values in the specified columns that we are grouping on once you group rows togather then  you can run aggregate funtions  on those rows  
  SELECT gender, avg(age) # here we can apply on many columns but select and group by shuold match to work properly and its logical and agg functions can be used here ( avg(age)
  
 FROM parks_and_recreation.employee_demographics
 group by gender
 
 ;
 SELECT gender, avg(age), max(age), min(age), count(age)
 FROM parks_and_recreation.employee_demographics
 group by gender
 ;
 
 -- ORDER BY- sorts the result in ascending or descending order 
 # ASC/DESC
  SELECT *
 FROM parks_and_recreation.employee_demographics
 ORDER BY gender, age desc # here gender is ordered first( place matters) and then age is being order as  default order asc 
 
 ;
 -- using column places - not recommended 
 SELECT *
 FROM parks_and_recreation.employee_demographics
 ORDER BY 5,4 desc # here gender is ordered first( place matters) and then age is being order as  default order asc 
 
 ;
 
 -- HAVING VS WHERE 
 -- WHERE - used to filter 
 SELECT gender,avg(age)
 FROM parks_and_recreation.employee_demographics
 WHERE AVG(age)> 40
 GROUP BY(gender) # when we filter with where then group by hasn't haappend, and having comes into the play, here group by has not happend and where is being used which will cause error, that's why having is being used 
 
 ;
 # HAVING will be right alter group by adn after group by we can filter based on agg functions 
 

select gender, avg(age) 
from parks_and_recreation.employee_demographics
group by gender
having avg(age)> 40 # now filtering is here
;
-- using both in a go. 
select occupatiaon, avg(salary) 
from parks_and_recreation.employee_salary
 where occupation like '%manager%' # filtering at row level 1
 group by occupation
 having avg(salary)> 75000 # filtering at agg funtions level, this having will only work after the group by works 
 
;

-- LIMITS AND ALIASING 

# limit 
select * 
from parks_and_recreation.employee_demographics
order by age desc
limit 3
;
select * 
from parks_and_recreation.employee_demographics
order by age desc
limit 3, 1 # here 3 is for start and then one count 
;


# aliasing- naking a column 
select gender, avg(age) as avg_age
from parks_and_recreation.employee_demographics
group by gender 
having avg_age > 40
;


-- JOINS 
select * 
from parks_and_recreation.employee_demographics
;

select * 
from parks_and_recreation.employee_salary
;
 -- INNER JOIN - COMMON PART- only common rows will be populated 
select * 
from parks_and_recreation.employee_demographics as dem
inner join parks_and_recreation.employee_salary as sal
on dem.employee_id= sal.employee_id
;
# selecting specific columns 
select dem.employee_id, age, occupation 
from parks_and_recreation.employee_demographics as dem
inner join parks_and_recreation.employee_salary as sal
on dem.employee_id= sal.employee_id
;

-- OUTER JOIN 
# LEFT JOIN / LEFT OUTER JOIN- all left table + match with right table
# RIGHT JOIN/ RIGHT OUTER JOIN- all right table+ match with left table
# left join
select *
from parks_and_recreation.employee_demographics as dem # left table 
left join parks_and_recreation.employee_salary as sal # right table
on dem.employee_id= sal.employee_id
;
# right join 
select *
from parks_and_recreation.employee_demographics as dem # left table 
right join parks_and_recreation.employee_salary as sal # right table
on dem.employee_id= sal.employee_id
;

# self join 
select *
from parks_and_recreation.employee_salary as emp1
join parks_and_recreation.employee_salary as emp2
   on emp1.employee_id +1 = emp2.employee_id
;
-- assigning secret santa case 
select emp1.employee_id as emp_sanata,
emp1.first_name as first_name_santa,
emp1.last_name as last_name_santa,
emp2.first_name as first_name_emp,
emp2.last_name as last_name_emp

from parks_and_recreation.employee_salary as emp1
join parks_and_recreation.employee_salary as emp2
   on emp1.employee_id +1 = emp2.employee_id
;

-- joining multiple table 
# one to other and then another table 
select * 
from parks_and_recreation.employee_demographics as dem
inner join parks_and_recreation.employee_salary as sal
on dem.employee_id= sal.employee_id
inner join parks_and_recreation.parks_departments as pd
 on sal.dept_id = pd.department_id
;


select * 
from parks_and_recreation.parks_departments;

-- UNION - to combine the rows of data from separate table or from the same table 
select age, gender
from parks_and_recreation.employee_demographics
union 
select first_name, last_name
from parks_and_recreation.employee_salary 
;
# but we need to combine same type of data 
select first_name, last_name
from parks_and_recreation.employee_demographics
union # by default its union distinct 
select first_name, last_name
from parks_and_recreation.employee_salary 
;
 # ie
select first_name, last_name
from parks_and_recreation.employee_demographics
union distinct
select first_name, last_name
from parks_and_recreation.employee_salary 
;
# showing all without removing duplicates 
select first_name, last_name
from parks_and_recreation.employee_demographics
union all
select first_name, last_name
from parks_and_recreation.employee_salary 
;

# usecase 
select first_name, last_name, 'old man' as lable # here old is labling 
from parks_and_recreation.employee_demographics
where age> 50 and gender ='male'
union 
select first_name, last_name, 'old lady' as lable # here old is labling 
from parks_and_recreation.employee_demographics
where age> 40 and gender ='female'

union 
select first_name, last_name, 'highly paid employee' as lable
from parks_and_recreation.employee_salary 
where salary > 70000
order by first_name, last_name 
;

-- CASE STATEMENTS 
-- STRING FUNCTIONS - built in funtions in sql that can be used on string differently
select length('skyfall'); # tells length 

 select first_name, length(first_name)
 from parks_and_recreation.employee_demographics
 order by 2
 ;
 
# UPPER,LOWER, TRIM(removing white spaces),LTRIM, RTRIM 
select upper ('sky');
select lower('SKY');
select trim('             sky             ');
select
rtrim('hello       ');

# SUBSTRING 
select first_name, left(first_name, 4)# here 4 tells how many charaters from left hand side do we want to select
from parks_and_recreation.employee_demographics 

;


select first_name,
 left(first_name, 4),
 right(first_name,4),
 substring(first_name,3,2),# here first num is starting and last is ending position
 birth_date,
 substring(birth_date, 6,2) as birth_month
from parks_and_recreation.employee_demographics 
;

# REPLACE _ it will replace the charater 
select first_name, replace(first_name, 'a', 'z')
from parks_and_recreation.employee_demographics
;

# LOCATE- tells the postion of the the character 
select locate('n', ' first_name')
from parks_and_recreation.employee_demographics
;
# CONCATINATION ( ADDING  OF DIFFERENT COLUMNS)

select first_name, last_name,
concat(first_name, ' ',last_name) as full_name# here ' ' is used for spacing 
from parks_and_recreation.employee_demographics
;




 -- CASE STAEMENT IN SQL- it allows you to add logic in your select statement
 select first_name, 
 last_name, 
 age,
 case 
      when age <=30 then'YOUNG'
      when age between 31 and 50 then 'old'
      when age>= 50 then "on death's door"
 end as age_bracket
 from parks_and_recreation.employee_demographics
 ;
 # we can add multiple when statement here in between the case statement 
 
 -- pay increase and bonus 
 -- < 50000 = 5%
 -- > 50000 = 7%
 -- finance = 10 % bonus 
 select first_name, last_name, salary,
 case 
    when salary < 50000 then salary + (salary*0.05)
    when salary > 50000 then salary *1.07
    
 end as new_salary,
  case 
      when dept_id = 6 then salary * 1.06 # go and check for the id or use queries to find that finance department id which links to this table
  end as bonus
 from parks_and_recreation.employee_salary 
 ;







-- SUB QUERIES- a query inside  a query 
select * 
from parks_and_recreation.employee_demographics
where employee_id in
                    ( select employee_id # here all things within bracket is operand and it sould contain only one column
                    
                    from parks_and_recreation.employee_salary
                    where dept_id= 1)
;
 
 
 # SUBQUERY IN SELECT STATEMENT 
 -- trying to print avg salary of entire column regardless of group by 
 select first_name, salary, avg(salary)
 from parks_and_recreation.employee_salary 
 group by first_name, salary 
 ;
 # but it wont worked so 
   select first_name,
   salary,
   ( 
   select  avg(salary) # here we applied avg on salary column and printed as a column 
   from parks_and_recreation.employee_salary
   ) as "avg salary"
 from parks_and_recreation.employee_salary 
 ;
 
 
 
 -- using subquery in the from statement 
 select gender, avg(age), max(age), min(age), count(age)
 from parks_and_recreation.employee_demographics 
 group by gender 
 ;
# what if we want avg of oldest or smallest, then 
select gender, avg(`max(age)`)# use backtick or write as below 
from 
( select gender, avg(age), max(age), min(age), count(age)
 from parks_and_recreation.employee_demographics 
 group by gender ) as agg_table
 group by gender ;
 
 -- here 
 select gender, avg(max_age) 
from 
( select gender, 
avg(age) as avg_age, 
max(age) as max_age,
 min(age) as min_age, 
 count(age)
 from parks_and_recreation.employee_demographics 
 group by gender ) as agg_table
  ;


-- WINDOW FUNCTIONS- it is somewhat like a group by they don't role everything in a one row when grouping window unctions allow us to partion or group while they each keep uniwue rows by their output 
  
select gender, avg(salary) as avg_salary
from parks_and_recreation.employee_demographics  as dem
join parks_and_recreation.employee_salary as sal
  on dem.employee_id = sal.employee_id
  group by gender 
;

# using window functions/without group bye
select gender, avg(salary) over()
from parks_and_recreation.employee_demographics  as dem
join parks_and_recreation.employee_salary as sal
  on dem.employee_id = sal.employee_id
;


# if nothing is written in the () then it will be considerd as everything 
-- use case of partition by 
select gender, avg(salary) over( partition by gender)
from parks_and_recreation.employee_demographics  as dem
join parks_and_recreation.employee_salary as sal
  on dem.employee_id = sal.employee_id
;
# we use window function to add additional info as 
select dem.first_name, dem.last_name, gender, avg(salary) over( partition by gender)
from parks_and_recreation.employee_demographics  as dem
join parks_and_recreation.employee_salary as sal
  on dem.employee_id = sal.employee_id
;

# ie some more examples


select dem.first_name, 
dem.last_name,
 gender,
 salary,
 sum(salary) over( partition by gender order by dem.employee_id) as rolling_total
from parks_and_recreation.employee_demographics  as dem
join parks_and_recreation.employee_salary as sal
  on dem.employee_id = sal.employee_id
; # here rolling total is being applied 

# special use 

# ROW NUMBER- tells row's number all the way to the bottom just like employee id unique value 
select dem.employee_id,
dem.first_name, 
dem.last_name,
 gender,
 salary,
 row_number() over()
from parks_and_recreation.employee_demographics  as dem
join parks_and_recreation.employee_salary as sal
  on dem.employee_id = sal.employee_id
;
# now on use of partition it  can repeat as per group elements from top to bottom 

select dem.employee_id,
dem.first_name, 
dem.last_name,
 gender,
 salary,
 row_number() over( partition by gender)
from parks_and_recreation.employee_demographics  as dem
join parks_and_recreation.employee_salary as sal
  on dem.employee_id = sal.employee_id
  
;
# now if we have to rank the salary then we can use order by 
select dem.employee_id,
dem.first_name, 
dem.last_name,
 gender,
 salary,
 row_number() over( partition by gender order by salary )
from parks_and_recreation.employee_demographics  as dem
join parks_and_recreation.employee_salary as sal
  on dem.employee_id = sal.employee_id
  
;
# for rank 
select dem.employee_id,
dem.first_name, 
dem.last_name,
 gender,
 salary,
 row_number() over( partition by gender order by salary desc) as row_num ,
 rank() over( partition by gender order by salary desc) as rank_num
from parks_and_recreation.employee_demographics  as dem
join parks_and_recreation.employee_salary as sal
  on dem.employee_id = sal.employee_id
;
# partition by is not gonna have duplicate rows in partition number 
# rank can create duplicate on the behalf of of the order by 
# rank decides next number positionly not numerically 

# dense_rank- when it gets down to duplicate still gonna duplicate them but it gonna next number numerically not positionally 
select dem.employee_id,
dem.first_name, 
dem.last_name,
 gender,
 salary,
 row_number() over( partition by gender order by salary desc) as row_num ,
 rank() over( partition by gender order by salary desc) as rank_num,
  dense_rank() over( partition by gender order by salary desc) as rank_dense
from parks_and_recreation.employee_demographics  as dem
join parks_and_recreation.employee_salary as sal
  on dem.employee_id = sal.employee_id
;

-- CTE- comman table expression- to define a subquerry block that you can then reference with in the main querry
# it can be used only after it has been created  
# used for advanced calcualtions which cant be done in a single querry
# another use is readability
# ctes are lot better over subquerries 

 
 with cte_example  as 
(
 select gender, 
 avg(age) as avg_sal,
 max(age) as max_sal , 
 min(age)as min_sal, 
 count(age) as count_sal
 from parks_and_recreation.employee_demographics as dem  
 join parks_and_recreation.employee_salary as sal
     on dem.employee_id = sal.employee_id
 group by gender 
 )
 select avg(avg_sal)
 from cte_example
 ;

# we can use columns names like this after overwritiing alias
with cte_example (gender,avg_salary, max_salary, min_salary, count_sal) as 
(
 select gender, 
 avg(age) as avg_sal,
 max(age) as max_sal , 
 min(age)as min_sal, 
 count(age) as count_sal
 from parks_and_recreation.employee_demographics as dem  
 join parks_and_recreation.employee_salary as sal
     on dem.employee_id = sal.employee_id
 group by gender 
 )
 select *
 from cte_example
 ;
 
 

 
 -- additionla functinality 
 with cte_example as 
 (
 select employee_id,
 gender,
 birth_date
 from parks_and_recreation.employee_demographics as dem  
 where birth_date> '1985-01-01'
 
 ),
 cte_example2 as 
 (
 select * 
 from parks_and_recreation.employee_salary 
 where salary> 50000
 )
 select *
 from cte_example
 join cte_example2
   on cte_example.employee_id = cte_example2.employee_id
 ;
 # here join properties can be used 
 
  with cte_example  as 
 (
 select employee_id,
 gender,
 birth_date
 from parks_and_recreation.employee_demographics as dem  
 where birth_date> '1985-01-01'
 
 ),
 cte_example2 as 
 (
 select * 
 from parks_and_recreation.employee_salary 
 where salary> 50000
 )
 select *
 from cte_example
 join cte_example2
   on cte_example.employee_id = cte_example2.employee_id
 ;
 use parks_and_recreation;
 
 
 
 # TEMPORARY TABLES/ TEMP TABLES- table that are only visible to the session they are created in 
 # restoring intermediate results in complex querries 
   
   create temporary table temp_table
   (first_name varchar(50), 
   last_name varchar(50),
   favourite_movie varchar(100)
   );
 
   select * 
   from temp_table;
   insert into temp_table
   values('pradeep', 'kumar', 'mahabharat')
   ;
   select * 
   from temp_table;
   
   # importing data from other table
   create temporary table salary_over_50k
   select * 
   from employee_salary 
   where salary> 50000;
   select * 
   from salary_over_50k;
   
   # it will remain only in this session 
   
   -- STORED PROCEDURES- way to save our sql code and reuse over and over again
   
   
   -- creating procedure 
   create procedure large_salaries()
   select * 
   from parks_and_recreation.employee_salary
   where salary>= 50000
   ;
   
   
   # calling procedure 
   call large_salaries();
   
   # storing multiple querry, now to store in a single procedure we need to use delimitter 
   
   delimiter $$ 
   create procedure large_salaries3()
   begin 
   select * 
   from parks_and_recreation.employee_salary
   where salary>= 50000;
   select * 
   from parks_and_recreation.employee_salary
   where salary>= 10000;
   end $$
   delimiter ;
   # keep proper spacing here 
   call large_salaries3();
   
   -- PARAMETERS- parameters are variables that applies as a input into a stored procedure and it allows the stored procedure to accept and input value and place in to your code   
   
   
   # here employee_id is known, now i have to pull up their salary,  when we are calling it pass the id value in the (), now create a parameter in procedure names (), name it as per coninience and define data data as int   
   # where condition right side shold match with name you put in first line 
   DELIMITER $$
drop procedure if exists large_salaries5;
CREATE PROCEDURE large_salaries5(IN emp_id INT)
BEGIN
    SELECT salary
    FROM parks_and_recreation.employee_salary
    WHERE employee_id = emp_id;
END $$

DELIMITER ;

CALL large_salaries5(1);

-- TRIGGERS AND EVENTS 
# TRIGGER- a trigger is a block of code that execute automatically when a event takes place on a specific table 

# to add ron swanson from one table to another 
 DELIMITER $$

CREATE TRIGGER employee_insert 
AFTER INSERT ON employee_salary 
FOR EACH ROW 
BEGIN 
    INSERT INTO employee_demographics(employee_id, first_name, last_name)
    VALUES (NEW.employee_id, NEW.first_name, NEW.last_name);
END $$

DELIMITER ;

--  Now run your insert query AFTER exiting trigger block
INSERT INTO employee_salary (employee_id, first_name, last_name, occupation, salary, dept_id)
VALUES (13, 'jean-rolphio', 'saperstein', 'entertainment 720 ceo', 1000000, NULL);


# EVENTS - a trigger happens when a event takes place where as a event takes place when its scheduled
# it is kind of a schduled automator 
# pulling data,build report and export a file on a schedule 
# super helpful in automation in general 

select * 
from employee_demographics;

DELIMITER $$
create event delete_retirees
on schedule every 30 second    # we can use months,year, or a time period
do 
begin
     delete 
     from employee_demographics
     where age >= 60;
end $$
DELIMITER ;

select * 
from employee_demographics;

# if you couldn't create event 
show variables like 'event%'; # if its 'on' then its working
 #  if still not working then . edit -> preferences-> sql editor-> uncheck safe update 
