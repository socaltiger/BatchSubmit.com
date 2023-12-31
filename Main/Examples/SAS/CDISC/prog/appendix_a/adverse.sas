**** define common SAS setings;
%include 'common.sas';

%common

**** INPUT SAMPLE ADVERSE EVENT DATA.;
data source.adverse;
label subject  = "Subject Number"
      bodysys = "Body System of Event"
      prefterm  = "Preferred Term for Event"
      aerel    = "Relatedness: 1=not,2=possibly,3=probably"
      aesev    = "Severity/Intensity:1=mild,2=moderate,3=severe"
      aeaction = "Action taken: 1=drug stopped, 2=dose reduced, 3=dose increased, 4=no dose change, 5=unknown"
      aestart  = "AE Start date"
      aeend    = "AE End date"
      serious  = "Serious AE?"
      aetext   = "Event Verbatim Text"
      uniqueid = "Company Wide Subject ID";
serious = 'N';
input subject aerel aesev aeaction aestart mmddyy10. +1 aeend mmddyy10. bodysys $ 33-63 prefterm $ 65-82 aetext $ 94-130;
uniqueid = 'UNI' || put(subject,3.);
datalines;
101 1 1 1 04/05/2010 04/05/2010 CARDIAC DISORDERS               ATRIAL FLUTTER               RACING HEART BEAT
101 2 1 2 06/05/2010 06/10/2010 GASTROINTESTINAL DISORDERS      CONSTIPATION                 CONSTIPATED
102 2 2 3 02/15/2010 02/15/2010 CARDIAC DISORDERS               CARDIAC FAILURE              CONGESTIVE HEART FAILURE
102 1 1 4 02/15/2010 02/15/2010 PSYCHIATRIC DISORDERS           DELIRIUM                     DISORIENTED AND DELIRIOUS
103 1 1 5 06/05/2010 06/05/2010 CARDIAC DISORDERS               PALPITATIONS                 HEART POUNDING
103 1 2 5 07/05/2010 07/05/2010 CARDIAC DISORDERS               PALPITATIONS                 HEART POUNDING
103 2 2 2 07/05/2010 07/05/2010 CARDIAC DISORDERS               TACHYCARDIA                  ACCELERATED HEARTBEAT
201 3 2 4 07/15/2010 07/25/2010 GASTROINTESTINAL DISORDERS      ABDOMINAL PAIN               STOMACH PAIN
201 3 1 1 10/12/2010 10/12/2010 GASTROINTESTINAL DISORDERS      ANAL ULCER                   ANAL ULCER
205 2 1 4 06/17/2010 06/27/2010 GASTROINTESTINAL DISORDERS      CONSTIPATION                 CONSTIPATED
205 2 2 4 04/13/2010 04/20/2010 GASTROINTESTINAL DISORDERS      DYSPEPSIA                    UPSET STOMACH
301 3 3 4 02/21/2010 .          GASTROINTESTINAL DISORDERS      FLATULENCE                   PASSING GAS
302 1 3 2 09/05/2010 09/05/2010 GASTROINTESTINAL DISORDERS      HIATUS HERNIA                HIATAL HERNIA
302 1 1 1 10/01/2010 10/01/2010 NERVOUS SYSTEM DISORDERS        CONVULSION                   CONVULSIONS
303 2 2 2 02/20/2010 02/20/2010 NERVOUS SYSTEM DISORDERS        DIZZINESS                    DIZZY FEELINGS
303 1 1 3 02/19/2010 .          NERVOUS SYSTEM DISORDERS        ESSENTIAL TREMOR             HAND TREMORS
304 1 3 4 05/20/2010 05/25/2010 PSYCHIATRIC DISORDERS           CONFUSIONAL STATE            FELT LOST
304 1 1 5 05/20/2010 05/25/2010 PSYCHIATRIC DISORDERS           DELIRIUM                     DELIRIOUS
304 2 1 1 05/19/2010 .          PSYCHIATRIC DISORDERS           SLEEP DISORDER               COULD NOT SLEEP
305 1 3 4 10/05/2010 10/05/2010 CARDIAC DISORDERS               PALPITATIONS                 POUNDING HEART
401 2 2 2 09/09/2010 .          GASTROINTESTINAL DISORDERS      HEARTBURN                    UPSET STOMACH
402 1 1 1 01/05/2010 .          GASTROINTESTINAL DISORDERS      TOOTHACHE                    MOUTH PAIN
402 3 3 4 03/03/2010 03/03/2010 INFECTIONS AND INFESTATIONS     NASOPHARYNGITIS              COMMON COLD
402 2 1 3 06/17/2010 06/17/2010 PSYCHIATRIC DISORDERS           ANXIETY                      ANXIETY
403 1 1 5 04/02/2010 04/02/2010 PSYCHIATRIC DISORDERS           INSOMNIA                     INSOMNIA SYMPTOMS
403 1 1 4 06/10/2010 06/10/2010 PSYCHIATRIC DISORDERS           SUICIDAL IDEATION            SUICIDAL
404 2 2 3 05/01/2010 05/01/2010 SURGICAL AND MEDICAL PROCEDURES EAR OPERATION                RIGHT EAR SURGERY
404 2 2 4 06/10/2010 .          GASTROINTESTINAL DISORDERS      FLATULENCE                   PASSING GAS
405 1 1 4 03/03/2010 .          RENAL AND URINARY DISORDERS     URINARY TRACT OBSTRUCTION    URINARY BLOCKAGE SURGERY
405 1 1 4 07/10/2010 07/10/2010 NERVOUS SYSTEM DISORDERS        SEDATION                     FEELING SLEEPY
501 2 2 4 03/01/2010 03/01/2010 NERVOUS SYSTEM DISORDERS        CARPAL TUNNEL SYNDROME       CARPAL TUNNEL IN LEFT HAND
501 3 2 2 05/20/2010 05/20/2010 GASTROINTESTINAL DISORDERS      VOMITING                     THROWING UP
502 3 2 2 08/10/2010 08/10/2010 GASTROINTESTINAL DISORDERS      ABDOMINAL PAIN               ABDOMINAL CRAMPS
502 1 1 4 10/10/2010 .          EYE DISORDERS                   MYOPIA                       NEARSIGHTED
504 1 1 4 06/19/2010 6/19/2010  EAR AND LABYRINTH DISORDERS     EAR PAIN                     LEFT EAR ACHE
505 1 2 4 03/16/2010 03/16/2010 GASTROINTESTINAL DISORDERS      DIARRHOEA                    LOOSE STOOL
505 2 3 1 09/01/2010 09/01/2010 NERVOUS SYSTEM DISORDERS        HEADACHE                     HEADACHE
505 2 2 4 05/10/2010 05/10/2010 EAR AND LABYRINTH DISORDERS     TINNITUS                     RINGING IN EAR
507 1 1 4 05/05/2010 05/05/2010 GASTROINTESTINAL DISORDERS      IRRITABLE BOWEL SYNDROME     IRRITABLE BOWEL SYNDROME
507 1 2 4 07/07/2010 07/07/2010 NERVOUS SYSTEM DISORDERS        AMNESIA                      MILD MEMORY LOSS
;
run;
 
