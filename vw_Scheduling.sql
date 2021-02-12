--shift management setting
select * from FP_Shift_Management_Setting
select * from FP_Scheduling

--Schedule
select s.ID,e.ID,sch.FromDate,(case when sch.ToDate=CAST('9998-12-31' AS DATE) then 'No End Date'  else  CONVERT(varchar,
                        sch.ToDate, 103) end) as TDate,s.Name,e.EmpName,d.ID as DeptID,d.DeptName,e.FingerID,sch.ToDate,
						sch.IsEndDate,(case when sch.Monday=0 then 'On Duty' else '-' end) As Monday,
						(case when sch.Tuesday=0 then 'On Duty' else '-' end) As Tuesday,
						(case when sch.Wednesday=0 then 'On Duty' else '-' end) As Wednesday,
						(case when sch.Thursday=0 then 'On Duty' else '-' end) As Thursday,
						(case when sch.Friday=0 then 'On Duty' else '-' end) As Friday,
						(case when sch.Saturday=0 then 'On Duty' else '-' end) As Saturday,
						(case when sch.Sunday=0 then 'On Duty' else '-' end) As Sunday,e.SubsidiaryID,e.BranchID,
						b.Region as AccessPoint,b.Corporate_id as Corporate_ID ,sch.IsDeleted
from FP_Scheduling as sch
inner join FP_Shift_Management_Setting as s on s.ID=sch.ShiftID
inner join Employee as e on e.ID=sch.EmpID
inner join Department as d on d.ID=e.DeptID
inner join Branch as b on b.ID=e.BranchID
inner join Corporate as c on c.ID=b.Corporate_id
where e.IsActive=1 and sch.IsDeleted=0

--Leave Request List
select e.EmpName,e.ID as EmpId,d.ID as DepID,jp.ID as PostID,jp.PostName,d.DeptName,lr.LeaveReason,lr.FromDate,lr.ToDate,lr.RequireDays,e.FingerID,lr.ID
from Leave_Request as lr
inner join Employee as e on e.ID=lr.EmpID
inner join Department as d on d.ID=e.DeptID
inner join Job_Position as jp on jp.ID=e.PostID

--Trip Assign
select e.ID as EmpID,t.TripName,t.FromDate,t.ToDate,t.Description,e.EmpName,d.DeptName,d.ID,e.FingerID,t.IsTrip,e.SubsidiaryID,
e.BranchID,b.Region as AccessPoint,c.ID
from Trip_Assign as t 
inner join Employee as e on e.ID=t.EmpID
inner join Department as d on d.ID=e.DeptID
inner join Branch as b on b.ID=e.BranchID
inner join Corporate as c on c.ID=b.Corporate_id
inner join Region as r on r.ID=b.Region





