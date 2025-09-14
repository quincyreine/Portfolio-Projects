
--create a join table
--connect id column to the compensations table
Select * from [Absenteeism_at_work] a
left join compensation b
on a.ID = b.ID

--create a join table
-- connect the reasons table 
Select * from [Absenteeism_at_work] a
left join compensation b
on a.ID = b.ID
left join Reasons r
on a.Reason_for_absence = r.Number;

 --find the healthiest for bonus budget
 --no smoker, no drinker, healthy BMI, below average absenteeism
Select * from [Absenteeism_at_work]
where Social_drinker = 0 and Social_smoker = 0
and Body_mass_index  <25 and 
Absenteeism_time_in_hours < 
	(select AVG(Absenteeism_time_in_hours) from [Absenteeism_at_work])

--compensation rate increase for non-smokers
--HR budget is $983,221
-- they work 2080 hours a year (8hrsx5daysx52weeks)
--686 workers x 2080 employees = 1,426,880 working hours
--$983,221/1,426,880 = 0.68 cents increase per hour
select count(*) as nonsmokers from Absenteeism_at_work
where Social_smoker = 0 

--optimize the query
 Select 
 a.ID, 
 r.Reason
from [Absenteeism_at_work] a
left join compensation b
on a.ID = b.ID
left join Reasons r
on a.Reason_for_absence = r.Number;

--optimize the query more
 Select 
 a.ID, 
 r.Reason,
 CASE WHEN Month_of_absence IN (12,1,2) Then 'Winter'
	  WHEN Month_of_absence IN (3,4,5) Then 'Spring'
	  WHEN Month_of_absence IN (6,7,8) Then 'Summer'
	  WHEN Month_of_absence IN (9,10,11) Then 'Fall'
	  ELSE 'Unknown' END as Season_Names
from [Absenteeism_at_work] a
left join compensation b
on a.ID = b.ID
left join Reasons r
on a.Reason_for_absence = r.Number;

--optimize the query more
 Select 
 a.ID, 
 r.Reason,
 Month_of_absence,
 Body_mass_index,
 CASE WHEN Body_mass_index < 18.5 then 'Underweight'
      WHEN Body_mass_index between 18.5 and 25 then 'Healthy'
	  WHEN Body_mass_index between 25 and 30 then 'Overweight'
	  WHEN Body_mass_index > 30 then 'Obese'
	  ELSE 'Unknown' END as BMI_Category,
 CASE WHEN Month_of_absence IN (12,1,2) Then 'Winter'
	  WHEN Month_of_absence IN (3,4,5) Then 'Spring'
	  WHEN Month_of_absence IN (6,7,8) Then 'Summer'
	  WHEN Month_of_absence IN (9,10,11) Then 'Fall'
	  ELSE 'Unknown' END as Season_Names,
Seasons,
Month_of_absence,
Day_of_the_week,
Transportation_expense,
Education,
Son,
Social_drinker,
Social_smoker,
Pet,
Disciplinary_failure,
Age,
Work_load_Average_day,
Absenteeism_time_in_hours
from [Absenteeism_at_work] a
left join compensation b
on a.ID = b.ID
left join Reasons r
on a.Reason_for_absence = r.Number;