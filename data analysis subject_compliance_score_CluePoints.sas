
/* Explore data distribution */
PROC UNIVARIATE DATA=compliance_data;
VAR Age DistanceFromSite HealthLiteracyScore SocialSupportScore
CognitiveTestScore AnxietyScore DepressionScore ComplianceScore;
RUN;

/* Correlation analysis */
PROC CORR DATA=compliance_data;
VAR Age EducationLevel PriorTrialExp DistanceFromSite HealthLiteracyScore
SocialSupportScore CognitiveTestScore AnxietyScore DepressionScore;
WITH ComplianceScore;
RUN;

/* Develop predictive model using multiple regression */
PROC REG DATA=compliance_data;
MODEL ComplianceScore = Age /*Gender*/ EducationLevel PriorTrialExp DistanceFromSite
EmploymentStatus HealthLiteracyScore SocialSupportScore
CognitiveTestScore AnxietyScore DepressionScore
/*/ SELECTION=STEPWISE VIF*/ ;
OUTPUT OUT=predicted_values PREDICTED=PredictedCompliance;
RUN;

/* Create a scoring algorithm */
PROC STANDARD DATA=compliance_data MEAN=0 STD=1 OUT=standardized;
VAR Age EducationLevel DistanceFromSite HealthLiteracyScore SocialSupportScore
CognitiveTestScore AnxietyScore DepressionScore;
RUN;

/* Factor analysis to identify latent variables */
PROC FACTOR DATA=compliance_data ROTATE=VARIMAX;
VAR HealthLiteracyScore SocialSupportScore CognitiveTestScore
AnxietyScore DepressionScore;
RUN;

/* Create compliance risk categories */
DATA compliance_scoring;
merge  compliance_data predicted_values;
by SubjectID ; 
length ComplianceRisk $30 ;

/* Calculate risk score (example weights - to adjust based on the model results ) */
RiskScore =
(-0.1 * Age) +
(0.5 * EducationLevel) +
(-0.2 * DistanceFromSite) +
(0.3 * PriorTrialExp) +
(0.4 * HealthLiteracyScore) +
(0.3 * SocialSupportScore) +
(0.2 * CognitiveTestScore) +
(-0.4 * AnxietyScore) +
(-0.3 * DepressionScore);

/* Categorize subjects */
IF RiskScore > 1 THEN ComplianceRisk = 'Low Risk';
ELSE IF RiskScore > -1 THEN ComplianceRisk = 'Medium Risk';
ELSE ComplianceRisk = 'High Risk';

LABEL
RiskScore = 'Compliance Risk Score'
ComplianceRisk = 'Predicted Compliance Risk Category';
RUN;

/* Validate the scoring system */
PROC FREQ DATA=compliance_scoring;
TABLES ComplianceRisk;
RUN;

PROC MEANS DATA=compliance_scoring MEAN STD MIN MAX;
CLASS ComplianceRisk;
VAR ComplianceScore;
RUN;

/* Output scoring algorithm for operational use */
PROC PRINT DATA=compliance_scoring (OBS=10);
VAR SubjectID RiskScore ComplianceRisk;
RUN;

/* Output subjects with high risk */
PROC PRINT DATA=compliance_scoring (where=(ComplianceRisk = 'High Risk'));
RUN;

 
/* Risk Monitoring: Example SAS code for ongoing KRI monitoring */
PROC SQL;
CREATE TABLE compliance_monitoring AS
SELECT /*SiteID,*/
MEAN(PredictedCompliance) AS AvgComplianceScore,
COUNT(CASE WHEN ComplianceRisk = 'High Risk' THEN 1 END) AS HighRiskSubjects,
COUNT(*) AS TotalSubjects
FROM compliance_scoring
/*GROUP BY SiteID*/
ORDER BY AvgComplianceScore;
QUIT;

/* During Study: Example trigger for risk mitigation */
DATA compliance_triggers;
SET compliance_scoring;
WHERE ComplianceRisk = 'High Risk';

IF HealthLiteracyScore < 70 THEN Mitigation = 'Enhanced consent process';
ELSE IF DistanceFromSite > 50 THEN Mitigation = 'Travel support options';
ELSE IF AnxietyScore > 20 THEN Mitigation = 'Additional patient support';
RUN;

/* Enhanced SAS Code for RBQM Integration */

/* Comprehensive RBQM KRI Monitoring Dashboard */
/* Protocol Compliance KRI Dashboard using PROC REPORT */
proc report data=compliance_scoring nowd;
  column ComplianceRisk 
         n 
         RiskScore 
         ComplianceScore;

  define ComplianceRisk / group 'Risk Category';
  define n / 'Count' format=8.0;
  define RiskScore / analysis mean 'Average Risk Score' format=8.1;
  define ComplianceScore / analysis mean 'Average Compliance Score' format=8.1;

  title 'Protocol Compliance KRI Dashboard';
run;

/* Eventually Trend analysis over time */
PROC SGPLOT DATA=compliance_scoring;
SERIES X=VisitNumber Y=ComplianceScore / GROUP=SiteID MARKERS;
LOESS X=VisitNumber Y=ComplianceScore / CLM;
XAXIS LABEL='Visit Number';
YAXIS LABEL='Compliance Score';
RUN;
