
DATA compliance_data;
  LENGTH Gender $1;
  DO SubjectID = 101 TO 300;
    /* Age: Random integer between 18 and 80 */
    Age = FLOOR(18 + RAND("Uniform")*63);
    /* Gender: 'M' or 'F' with ~50% chance */
    IF RAND("Uniform") < 0.5 THEN Gender = "M";
    ELSE Gender = "F";
    /* EducationLevel: 1 to 4 */
    EducationLevel = CEIL(RAND("Uniform")*4);
    /* PriorTrialExp: 0 or 1 */
    PriorTrialExp = (RAND("Uniform") < 0.5);
    /* DistanceFromSite: 0 to 50 miles (rounded) */
    DistanceFromSite = ROUND(RAND("Uniform")*50,1);
    /* EmploymentStatus: 1 to 4 */
    EmploymentStatus = CEIL(RAND("Uniform")*4);
    /* HealthLiteracyScore: 0 to 100 (rounded) */
    HealthLiteracyScore = ROUND(RAND("Uniform")*100,1);
    /* SocialSupportScore: 0 to 100 (rounded) */
    SocialSupportScore = ROUND(RAND("Uniform")*100,1);
    /* CognitiveTestScore: 0 to 100 (rounded) */
    CognitiveTestScore = ROUND(RAND("Uniform")*100,1);
    /* AnxietyScore: 0 to 30 (rounded) */
    AnxietyScore = ROUND(RAND("Uniform")*30,1);
    /* DepressionScore: 0 to 30 (rounded) */
    DepressionScore = ROUND(RAND("Uniform")*30,1);
    /* ComplianceScore: 0 to 100 (rounded) */
    ComplianceScore = ROUND(RAND("Uniform")*100,1);

    OUTPUT;
  END;
RUN;
