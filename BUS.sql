use BUS
/*1.Select Buses with their number Palet are dedicated 5 to orignal route 3 to reserved rout */
select Bus.PNo as[NumberPalet],Town.Rfrom as [From],Town.RTo as [To],Route.lenth,'Orignal' as [Route Type]
from Bus  inner join BusOriginalRoute on BusOriginalRoute.PNo=Bus.PNo
inner join OriginalRoute on BusOriginalRoute.ORId=OriginalRoute.Id
inner join Route on OriginalRoute.Id=Route.Id 
inner join Town on Route.TId=Town.Id
group by Bus.PNo,Town.Rfrom,Town.RTo,Route.lenth
having COUNT(Bus.PNo)<=5
union
select Bus.PNo as[NumberPalet],Town.Rfrom as [From],Town.RTo as [To],Route.lenth,'Reserved' as [Route Type]
from Bus inner join BusResrvedRoute on BusResrvedRoute.PNo=Bus.PNo
inner join ResrvedRoute on BusResrvedRoute.Id=ResrvedRoute.Id
inner join Route on ResrvedRoute.Id=Route.Id
inner join Town on Route.TId=Town.Id
group by Bus.PNo,Town.Rfrom,Town.RTo,Route.lenth
having COUNT(Bus.PNo)<=3


/*2.select monthly in come where fare is supposed average 730AFN and new passanger picked in route */
select Bus.PNo,Ticekt.payment as [Ticekt Pirce] ,Ticekt.payment*Bus.Sets*30 as [Monthly in Come], Town.Rfrom as [From] ,Town.RTo as [To]
from Ticekt inner join Bus on Bus.PNo=Ticekt.PNo
inner join Route on Ticekt.RId=Route.Id 
inner join Town on Route.Id=Town.Id

/*3.Select * Driver name who are not assinged to  resrved rout*/
Select Bus.PNo,Driver.Name,Town.Rfrom as [From] ,Town.RTo
from Driver inner join Drive on Drive.DId=Driver.Id
inner join Bus on Drive.PNo=Bus.PNo
inner join BusOriginalRoute on Bus.PNo=BusOriginalRoute.PNo
inner join Route on BusOriginalRoute.ORId=Route.Id
inner join Town on Route.TId=Town.Id
where Bus.PNo not in(select [dbo].[BusResrvedRoute].PNo from BusResrvedRoute)
order by Driver.Name

/*4. Select the avrage of sallary of * driver who work more then 22 hour reserved route too to each hour for resrved route are supposed to have 30% sallary  */
Select Bus.PNo,Driver.Name,Driver.Salary as [Salary],Driver.Salary+((Driver.Salary*30)/100) as [New Salary] 
from Driver inner join Drive on Drive.DId=Driver.Id
inner join Bus on Drive.PNo=Bus.PNo
where Bus.PNo in(select [dbo].[BusResrvedRoute].PNo from BusResrvedRoute) and Bus.PNo in (
select BusOriginalRoute.PNo from BusOriginalRoute
)
/*Proof*/
select * from BusOriginalRoute
select * from  BusResrvedRoute


/*5.Select * Accident from Orignal and Resrwed route the paid to 13% government from monthy in come to each accidnt*/
select Accident.Accident_Date,Bus.PNo,Bus.Model,Driver.Name,Town.Rfrom as [From], Town.RTo as[To],Accident.Fee,Bus.Sets*730*30 as [Monthly In Come],(Bus.Sets*730*30*13)/100 as [13% Accident Tax],Bus.Sets*730*30 -(((Bus.Sets*730*30*13)/100)+Accident.Fee) as[Remaing Monthly Income]
from Bus  inner join Accident on Accident.PNo=Bus.PNo
inner join Driver on Accident.DId=Driver.Id
inner join Route on Accident.RId=Route.Id
inner join Town on Route.TId=Town.Id

/*6.Select * names of driver who got reward in more then 3 routes with total Salary for reward */
select Driver.Name ,Reward.HourlyTime,Reward.Fee,Town.Rfrom as [From],Town.RTo as[To],Driver.Salary+Reward.Fee as [Total Salary]
from Driver inner join Reward on Reward.DId=Driver.Id
inner join Route on Reward.RId=Route.Id
inner join Town on Route.TId=Town.Id


/*7.Select total number of award and accident withe total charges for each reward and accident with a year respectively*/
select  Driver.Name,Reward.Fee as[Reward Fee],Accident.Fee as [Accident Fee] 
from Driver left join Reward on Reward.DId=Driver.Id
inner join Accident on Driver.Id=Accident.DId

/*8.Select Buses & driver that replaced /sustituted due to accident or other any other reason within one fiscal year corresponding*/

select DriverChange.Change_Date ,Bus.PNo ,Driver.Name as[Old Driver Name],DriverChange.NewDriverName,DriverChange.Reason
from Bus inner join DriverChange on Bus.PNo=DriverChange.PNo
inner join Driver on DriverChange.OdId=Driver.Id

