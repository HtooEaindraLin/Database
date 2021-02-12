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

--Leave Report
select e.EmpName,l.LeaveName, u.FromDate,u.ToDate,u.UsedLeave,d.id as DeptID,u.EmpID,MONTH(u.FromDate) as Month,
YEAR(u.fromDate) as Year,DATENAME(month,u.FromDate) AS MonthName,u.LeaveID,d.DeptName,e.FingerID
from Leave as l
inner join Used_Leave as u on u.LeaveID=l.ID
inner join Employee as e on e.ID=u.EmpID
inner join Department as d on d.ID=e.DeptID
where u.UsedLeave<>0

--Trip Assign
select e.ID as EmpID,t.TripName,t.FromDate,t.ToDate,t.Description,e.EmpName,d.DeptName,d.ID,e.FingerID,t.IsTrip,e.SubsidiaryID,
e.BranchID,b.Region as AccessPoint,c.ID
from Trip_Assign as t 
inner join Employee as e on e.ID=t.EmpID
inner join Department as d on d.ID=e.DeptID
inner join Branch as b on b.ID=e.BranchID
inner join Corporate as c on c.ID=b.Corporate_id
inner join Region as r on r.ID=b.Region
where t.IsTrip=1

--Activity Assign

select e.id,t.TripName,t.FromDate,t.ToDate,t.IsTrip,e.EmpName,d.ID as DeptID,d.DeptName,e.FingerID,e.SubsidiaryID,e.BranchID
,b.Region as AccessPoint,c.ID as CorporateID
from Trip_Assign as t
inner join Employee as e on e.ID=t.EmpID
inner join Department as d on d.ID=e.DeptID
inner join Branch as b on b.ID=e.BranchID
inner join Corporate as c on c.ID=b.Corporate_id
where IsTrip=0

--Assign for Auto Calculate Attendance
select e.id as EmpID,e.EmpName,d.DeptName,a.IsDeleted,a.IsActive,e.FingerID,d.id as DeptID,jp.ID as PostID,jp.Level
from FP_Assign_AutoCalc_Attendance as a
inner join Employee as e on e.ID=a.EmpID
inner join Department as d on d.ID=e.DeptID
inner join Job_Position as jp on jp.ID=e.PostID

--Attendance Report
select a.DeptID,a.FingerID,a.InDate,a.OutDate,a.EmpID,a.InTime,a.OutTime,a.Late,
DATEDIFF(mi, 0, CONVERT(datetime, a.Late, 108)) as LateMinutes,a.EarlyOut,a.OverTime,a.WorkHours,a.InTime2,a.OutTime2,
a.InTime3,a.OutTime3,a.InTime4,a.OutTime4,a.InTime5,a.OutTime5,a.intime6,a.OutTime6,a.InTime7,a.OutTime7,a.InTime8,a.OutTime8,
a.InTime9,a.OutTime9,a.InTime10,a.OutTime10,a.LatestOutTime,a.ShiftID,a.ShiftDateIn,a.ShiftDateOut,a.isOtherActivity,a.OtherActivity,
s.Name,d.DeptName,a.InTime as ShiftTimeIn,a.OutTime as ShiftTimeOut,e.id,e.EmpName,e.SubsidiaryID,e.BranchID,
b.Region as AccessPoint,c.ID as CorporateID
from FP_Attendance as a
inner join FP_Shift_Management_Setting as s on s.ID=a.ShiftID
inner join Employee as e on e.ID=a.ID
inner join Department as d on d.ID=a.DeptID
inner join Branch as b on b.ID=e.BranchID
inner join Corporate as c on c.ID=b.Corporate_id

--vw_fp_manual_setting
select  e.EmpName,s.Name,e.ID as EmpID,m.ManualInDate,m.ManualOutDate,m.OutTime,m.Late,m.EarlyOut,
m.OverTime,m.WorkHours,d.id as DeptID,d.DeptName,m.InTime,e.FingerID,m.ID,m.AttendanceID,b.Region as AccessPoint,
b.id as BranchID,e.SubsidiaryID  as SubsidiaryID,c.ID as CorporateID
from FP_ManualSetting as m
inner join Employee as e on e.ID=m.EmpID
inner join Department as d on d.ID=e.DeptID
inner join Branch as b on b.ID=e.BranchID
inner join Corporate as c on c.ID=b.Corporate_id
inner join FP_Shift_Management_Setting as s on s.ID=m.ShiftID

--vw_fp_all_log
select e.id,e.FingerID,f.VerifyMode,f.InOut,f.AttendanceDate,f.AttendanceDateTime,e.SubsidiaryID,e.BranchID as BranchID,
d.id as DeptID,b.Region as AcessPoint,d.DeptName,b.Branch as BranchName,s.Branch as Subsidiary,e.EmpName,c.ID as CorporateID
from FP_AllLog as f
inner join Employee as e on e.FingerID=f.FingerID
inner join Branch as b on b.ID=e.BranchID
inner join Branch as s on s.ID=e.SubsidiaryID
inner join  Department as d on d.ID=e.DeptID
inner join Corporate as c on c.ID=b.Corporate_id

--vw_Late_report
select a.DeptID,a.FingerID,a.InDate as AttDate,a.EmpID,a.InTime,a.OutTime,
a.Late,CONVERT(datetime,a.late,108) as LateMinutes,d.DeptName,e.EmpName,sms.Name,sms.ID,sms.OnDutyTime,
sms.OffDutyTime,sms.LateAllow,d.MainDeptID,e.SubsidiaryID,e.BranchID,b.Region as AccessPint,c.ID as CorporateID
from FP_Attendance as a
inner join Employee as e on e.ID=a.EmpID
inner join FP_Shift_Management_Setting as sms on sms.ID=a.ShiftID
inner join Branch as b on b.ID=e.BranchID
inner join Branch as s on s.ID=e.SubsidiaryID
inner join Corporate as c on c.ID=b.Corporate_id
inner join Department as d on d.ID=a.DeptID
WHERE (a.Late <> '00:00:00') AND (CONVERT(DATE, GETDATE()) = CONVERT(DATE, a.ShiftDateIn)) AND (CAST(GETDATE() AS time) > CAST(sms.OnDutyTime AS time)) OR
                         (a.Late <> '00:00:00') AND (CONVERT(DATE, GETDATE()) > CONVERT(DATE, a.ShiftDateIn))




