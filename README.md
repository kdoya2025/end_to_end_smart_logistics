# end_to_end_smart_logistics
I worked on a logistics shipment dataset to improve delayed shipment.
I started by cleaning the tat, first in MySQL by using:
Row number and CTS to remove duplicate
Group by, and Order by 
Aggregation function
Alter table
Subquery
After cleaning the data in MySQL I have exported the data in csv, I moved on python for the Eda and the Machine learning.
Once in python I started verifying the dataset to see if there are some anomalies.
After making the final cleaning, I started the EDA exploratory.
THE EDA SUMMARY
I started by finding which one of the trucks did the most shipment.
truck 8,4,2,10 did the majority of the shipment

shipment distribution by asset

•	truck 8 made 10.9% of the shipment
•	truck 4 made 10.7% of the shipment
•	truck 2 made 10.5% of the shipment
•	truck 10 made 10.5% of the shipment
•	truck 3 made 9.3% of the shipment
•	truck 6 made 10.3% of the shipment
•	truck 7 made 10.2% of the shipment
•	truck 9 made 9.4% of the shipment
•	truck 5 made 9.3% of the shipment
•	truck 1 made 8.9% of the shipment


shipment evolution with months

•	From January to February the shipment dramatically fell from more than 90 shipment in January to less than 77 shipments in February

•	From February to March the shipment jumped from less than 77 shipment in February to more than 92 shipments in march

•	From March to May the shipment fell down from more than 92 shipment in March passing by a small in diminution in April less than 87 to less than 75 shipments in may

•	From May to July the shipment jumped from less than 75 shipment in May by also passing by a small evolution in June more than 77 shipment to more than 85 shipments in July

•	From July to august the shipment jumped from more than 85 shipment in July to less than 77 shipments in august

•	From August to September the shipment jumped from less than 77 shipment in august to more than 82 shipments in September

•	From September to November the shipment was relatively constant around 82 shipments

•	From November to December the shipment jumped from around than 82 shipments in November to more than 87 shipments in December

we can conclude that the minimum shipment was in February, may August and the maximum was in January, March, July and December.

shipment delivery status by asset
•	truck1: 35.96% of the shipment was delivered,33.71% was delayed and 30.34% was in transit
•	truck2: 38.10% of the shipment was delivered,32.38% was delayed and 29.52% was in transit
•	truck3: 33.33% of the shipment was delivered,35.48% was delayed and 31.18% was in transit
•	truck4: 32.71% of the shipment was delivered,38.32% was delayed and 28.97% was in transit
•	truck5: 35.48% of the shipment was delivered,35.48% was delayed and 29.03% was in transit
•	truck6: 31.07% of the shipment was delivered,30.10% was delayed and 38.83% was in transit
•	truck7: 34.31% of the shipment was delivered,35.29% was delayed and 30.39% was in transit
•	truck8: 27.52% of the shipment was delivered,35.78% was delayed and 36.70% was in transit
•	truck9: 38.30% of the shipment was delivered,3511% was delayed and 26.60% was in transit
•	truck10: 32.38% of the shipment was delivered,38.10% was delayed and 29.52% was in transit

global shipment statues overview
	35% of the global shipment was delayed 33.8% was delivered and 31.2% was in transit
	the delayed had the top percentage the problem of the company is shipment delayed

logistics delay reason
globally 28% of the delayed was caused by the weather, 26.67% of the delayed didn't have a reason and 24% caused by the mechanical failure and 21.43% caused by the traffic
Business solution
If the smart logistics company want to reduce the shipment delay they have to:
Before  giving the  delivery date , they have to look at  the weather
Check the truck and fix the mechanical problem before the shipment
And also choose the perfect time to avoid traffic


After the EDA I have tried to predict the delivery reason by considering other columns
first  impression all the numeric number  were not correlated so the Linear model could give a worst prediction.

for the machine learning I started by :
using train test split to split my data, I used  50% of the dataset as the training, 25% for the validation and testing
creating my target and inputs
Imputing nueric columns
scaling numeric columns
encoding the categorical cols
that was the preprocessing.

after finishing to preprocess the data I started by testing model

Logistic regression metrics
log_loss: 1.30
f1_score 0.37
random forest metrics
log_loss: 1.23
f1_score 0.71
Decision tree metrics
log_loss: 1.34
f1_score 0.21

Xgboost metrics
log_loss: 1.28
f1_score 0.47

as we can see here random forest is giving the best metrics for the first view random forest is the best for predicting the delivery status but  when we use it with validation and test it being worst, I test the validation and the test with all of the models but the metrics were being worst to worst so conclude the delivery status prediction was impossible because the data was to small

tool used
MySQL
Python
Pandas
Numpy
Pandas
seaborn
Matplotlib

