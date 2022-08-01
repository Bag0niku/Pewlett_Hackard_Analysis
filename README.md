# Pewlett_Hackard_Analysis

## Project Overview
Pwelett Hackard is a large company with thousands of employees. As the older generation begins retiring at a rapid rate, management needs to look to the future of the company and minimize the potential damage from the "silver tsunami". 

## Resources:
  -  Data: 6 csv's (departments, employees, dept_emp, dept_managers, titles, salaries), other csv's are created from my queries.
  -  Software: PostgresSQL 13,
      -  SQL files for reference of my queries


## Summary 
The data includes: 
  - Past and current employee names, birthdates, hire dates, their salaries, titles, and departments worked in. 
  - Employees born in 1952 to 1955 are anticipated to be retiring this year or next year.
#### Count of Employees retiring and the impact across the company
<img src='Queries/total_retiring_by_department.png' style='float:left;margin:0px 50px'> 

![](/Queries/total_retiring_by_position.png)
  - Oldest employee was born in 1952 and the youngest 1965. Assuming if the 'employees.csv' is a complete list of employess, then the entire workforce will be retired in 15 years of less and the company is facing a much larger problem than anticipated.
  
#### In the next 15 years there will be 3 "Silver" Tsunami's
   <img style="float:left;margin:0px 50px" src='Queries/multiple_silver_tsunami_waves.png'></td>
   <p>
   <ul> 
   <li> "now" is the current wave of retires</li>
   <li> "n5" is the wave that starts in 5 years</li>
   <li> "n10" is the wave that starts in 10 years</li>
  </ul> </p>
  
  -  Minimizing these tsunami impacts will be important for the company's survival.
  -  Instead of having all of the retiries leave at once, take the best, most experienced and successful employees about to retire and have them mentor new hires part time. Initially those eligable to be mentors are born in 1965. 
  - It will take time to get this program going, which is why those from this current wave of retires were not chosen to be eligible. 



