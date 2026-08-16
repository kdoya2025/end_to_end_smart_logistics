select *
from smart_logistics_dataset
limit 10;

create table staging_smart_logistics like 
smart_logistics_dataset;
insert into staging_smart_logistics 
select *
from smart_logistics_dataset;

-- 1 removing duplicates

select *, row_number() over (partition by Timestamp,Asset_ID,Inventory_Level,Shipment_Status,
Traffic_Status,User_Transaction_Amount) as row_num
from staging_smart_logistics;

with cts_staging as  (select *, row_number() over (partition by Timestamp,Asset_ID,Inventory_Level,Shipment_Status,
Traffic_Status,User_Transaction_Amount) as row_num
from staging_smart_logistics)
select *
from cts_staging
where row_num >1;
-- by using row_number and over partition by we constated that there was  no duplicates.

-- 2 handling null values

select *
from staging_smart_logistics
where Inventory_Level is null or  Inventory_Level='' or
Shipment_Status is null or Shipment_Status=''
or Traffic_Status is null or Traffic_Status=''
or Waiting_Time is null or Waiting_Time=''
or User_Transaction_Amount is null or User_Transaction_Amount=''
or User_Purchase_Frequency is null or User_Purchase_Frequency=''
or Logistics_Delay_Reason is null or Logistics_Delay_Reason=''
or Humidity is null or Humidity=''
or Temperature is null or Temperature=''
or Asset_ID is null or Asset_ID=''
or Timestamp is null or Timestamp='';

-- there was no null value because after verifying every columns any columns showed a null value or empty values

-- 3 standardization
select*
from staging_smart_logistics
limit 10;
select substring_index(Timestamp,' ',1)
from smart_logistics_dataset;
 alter table staging_smart_logistics
 add column Date text;
 -- spliting the date time, to remove only the date
 update staging_smart_logistics set
 Date=substring_index(Timestamp,' ',1);
 -- transforming date to date
update staging_smart_logistics set
 Date=str_to_date(Date,'%Y-%m-%d');
 
 select distinct Traffic_Status,trim(Traffic_Status)
 from staging_smart_logistics;
 
   select distinct Shipment_Status,trim(Shipment_Status)
 from staging_smart_logistics;
 
 select distinct Logistics_Delay_Reason,trim(Logistics_Delay_Reason)
 from staging_smart_logistics;
 -- triming text
 update staging_smart_logistics
 set Traffic_Status=trim(Traffic_Status),
 Shipment_Status=trim(Shipment_Status),
 Logistics_Delay_Reason=trim(Logistics_Delay_Reason);
 
 -- after finishing the the data cleaning let move to the analysis
 
 select *
 from staging_smart_logistics
 limit 10;
 
 select Asset_ID, count(Asset_ID) as total_shipment,round(count(Asset_ID) /sum(count(Asset_ID) ) over()*100,2) as percentage
 from staging_smart_logistics
 group by Asset_ID
 order by total_shipment desc;
 
 select Asset_ID,Shipment_Status, count(Shipment_Status) as total_shipment,round(count(Shipment_Status) /sum(count(Shipment_Status) ) over(partition by Asset_ID)*100,2) as percentage
 from staging_smart_logistics
 group by Asset_ID,Shipment_Status
 order by Asset_ID,total_shipment desc;
 
 -- truck1: 35.96% of the shipment was delivered,33.71% was  delayed and 30.34% was in transit
 -- truck2: 38.10% of the shipment was delivered,32.38% was  delayed and 29.52% was in transit
 -- truck3: 33.33% of the shipment was delivered,35.48% was  delayed and 31.18% was in transit
 -- truck4: 32.71% of the shipment was delivered,38.32% was  delayed and 28.97% was in transit
 -- truck5: 35.48% of the shipment was delivered,35.48% was  delayed and 29.03% was in transit
 -- truck6: 31.07% of the shipment was delivered,30.10% was  delayed and 38.83% was in transit
 -- truck7: 34.31% of the shipment was delivered,35.29% was  delayed and 30.39% was in transit
 -- truck8: 27.52% of the shipment was delivered,35.78% was  delayed and 36.70% was in transit
 -- truck9: 38.30% of the shipment was delivered,35.11% was  delayed and 26.60% was in transit
 -- truck10: 32.38% of the shipment was delivered,38.10% was  delayed and 29.52% was in transit

 select Asset_ID,Logistics_Delay_Reason,Shipment_Status, count(Shipment_Status) as total_shipment,round(count(Shipment_Status) /sum(count(Shipment_Status) ) over(partition by Asset_ID)*100,2) as percentage
 from staging_smart_logistics
 where Shipment_Status='Delayed'
 group by Asset_ID,Shipment_Status,Logistics_Delay_Reason
 order by Asset_ID,total_shipment desc;
 -- truck1 : 33.33% dealyead didn't have a reason, 26.67% was caused by the mechanical failure
 -- ,16.67% was caused by the traffic 23.33% was caused by the weather
 
  -- truck2 : 23.53% dealyed didn't have a reason, 17.65% was couse by the mechanical failure 
  -- ,20.59% was caused by the traffic and 38.24% was caused by the weather
  
   -- truck3 : 27.27% dealyed didn't have a reason, 21.21% was caused by the mechanical failure 
  -- ,33.33% was caused by the traffic and 18.18% was caused by the weather
  
  -- truck4 : 17.07% dealyed didn't have a reason, 26.83% was caused by the mechanical failure 
  -- ,29.27% was caused by the traffic and 26.83% was caused by the weather
 
 -- truck5 : 24.24% dealyed didn't have a reason, 18.18% was caused by the mechanical failure 
  -- ,27.27% was caused by the traffic and 30.30% was caused by the weather
  
  -- truck6 : 38.71% dealyed didn't have a reason, 3.23% was caused by the mechanical failure 
  -- ,16.13% was caused by the traffic and 41.94% was caused by the weather
 
 -- truck7 : 36.11% dealyed didn't have a reason, 27.78% was caused by the mechanical failure 
  -- ,16.67% was caused by the traffic and 19.44% was caused by the weather
  
  -- truck8 : 17.95% dealyed didn't have a reason, 35.90% was caused by the mechanical failure 
  -- ,15.38% was caused by the traffic and 30.77% was caused by the weather
  
  -- truck9 : 30.30% dealyed didn't have a reason, 33.33% was caused by the mechanical failure 
  -- ,12.12% was caused by the traffic and 24.24% was caused by the weather
  
  -- truck10 : 22.50% dealyed didn't have a reason, 25% was caused by the mechanical failure 
  -- ,25% was caused by the traffic and 27.50% was caused by the weather
  
   select Logistics_Delay_Reason,Shipment_Status, count(Shipment_Status) as total_shipment,round(count(Shipment_Status) /sum(count(Shipment_Status) ) over()*100,2) as percentage
 from staging_smart_logistics
 where Shipment_Status='Delayed'
 group by Shipment_Status,Logistics_Delay_Reason
 order by total_shipment desc;
 
 
 -- globaly 28% of the dealyed was coused by the weather, 26.67% of the delayed didn't have a reason 
 -- and 24% caused by the mechanical failure and 21.43% caused by the traffic
 
 -- to fix delayed problem the company should ensure the truck don't have a mechanical problem before going 
 -- also look at  the weather before giving delivery day and choose  a good timesheet to avoid traffic problem
 
  select *
 from staging_smart_logistics
 limit 10;
 -- numeic statistic description 
 
  select min(Temperature)as min_temp,
  round(max(Temperature),2) AS max_temp,
  round(avg(Temperature),2) as average_temp,
  round(std(Temperature),2) as std_temp
  from(
  select Temperature
 from staging_smart_logistics
 group by Temperature) as tempera
 ;
 
 
 select min(Inventory_Level)as min_inv,
  round(max(Inventory_Level),2) AS max_inv,
  round(avg(Inventory_Level),2) as average_inv,
  round(std(Inventory_Level),2) as std_inv
  from(
  select Inventory_Level
 from staging_smart_logistics
 group by Inventory_Level) as inv
 ;
 
  select min(User_Transaction_Amount)as min_tr_amount,
  round(max(User_Transaction_Amount),2) AS max_tr_amount,
  round(avg(User_Transaction_Amount),2) as average_tr_amount,
  round(std(User_Transaction_Amount),2) as std_tr_amount
  from(
  select User_Transaction_Amount
 from staging_smart_logistics
 group by User_Transaction_Amount) as tr_amount
 ;
 
   select min(Demand_Forecast)as min_forecast,
  round(max(Demand_Forecast),2) AS max_forecast,
  round(avg(Demand_Forecast),2) as average_forecast,
  round(std(Demand_Forecast),2) as std_forecast
  from(
  select Demand_Forecast
 from staging_smart_logistics
 group by Demand_Forecast) as forecast
 ;
 
    select min(User_Purchase_Frequency)as min_pur_frequency,
  round(max(User_Purchase_Frequency),2) AS max_pur_frequency,
  round(avg(User_Purchase_Frequency),2) as average_pur_frequency,
  round(std(User_Purchase_Frequency),2) as std_pur_frequency
  from(
  select User_Purchase_Frequency
 from staging_smart_logistics
 group by User_Purchase_Frequency) as pur_frequency
 ;
 
    select min(Asset_Utilization)as min_asset_utilization,
  round(max(Asset_Utilization),2) AS max_asset_utilization,
  round(avg(Asset_Utilization),2) as average_asset_utilization,
  round(std(Asset_Utilization),2) as std_asset_utilization
  from(
  select Asset_Utilization
 from staging_smart_logistics
 group by Asset_Utilization) as asset_utilization
 ;
 
  select min(Latitude)as min_Latitude,
  round(max(Latitude),2) AS max_Latitude,
  round(avg(Latitude),2) as average_Latitude,
  round(std(Latitude),2) as std_Latitude
  from(
  select Latitude
 from staging_smart_logistics
 group by Latitude) as Latitude
 ;
 
   select min(Longitude)as min_Longitude,
  round(max(Longitude),2) AS max_Longitude,
  round(avg(Longitude),2) as average_Longitude,
  round(std(Longitude),2) as std_Longitude
  from(
  select Longitude
 from staging_smart_logistics
 group by Longitude) as Longitude
 ;
 
  select min(Waiting_Time)as min_wait,
  round(max(Waiting_Time),2) AS max_wait,
  round(avg(Waiting_Time),2) as average_wait,
  round(std(Waiting_Time),2) as std_wait
  from(
  select Waiting_Time
 from staging_smart_logistics
 group by Waiting_Time) as wait
 ;
 
 select min(Humidity)as min_temp,
  round(max(Humidity),2) AS max_hum,
  round(avg(Humidity),2) as average_hum,
  round(std(Humidity),2) as std_hum
  from(
  select Humidity
 from staging_smart_logistics
 group by Humidity) as hum
 ;
select*, case 
when Inventory_Level/Demand_Forecast <1  then  'Stocckout risk'
when Inventory_Level/ Demand_Forecast between 1 and 1.5  then  'Low Stock'
when Inventory_Level/ Demand_Forecast between 1.5 and 3 then 'Healthy'
Else 'Overstock'
end as  stock_rating
from staging_smart_logistics;
 
 
DELIMITER //
create  procedure SHIPMENT_DELAYED()
BEGIN
select*
from staging_smart_logistics
 where Shipment_Status='Delayed';
END //
DELIMITER ;

call SHIPMENT_DELAYED;

DELIMITER //
create procedure shipment_in_transit()
BEGIN
select*
from staging_smart_logistics
 where Shipment_Status='In Transit';
 END //
 
DELIMITER 

CALL shipment_in_transit();


 






