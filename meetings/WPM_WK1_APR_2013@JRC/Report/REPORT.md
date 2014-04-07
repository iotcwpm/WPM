% REPORT OF THE WORKSHOP ON MANAGEMENT STRATEGY EVALUATION
% Working Party on Methods, Indian Ocean Tuna Commission
% ISPRA, ITALY. 16-19 APRIL 2013

# SUMMARY

This workshop took place in the premises of the European Community Joint Research Centre (EC-JRC) in Ispra, Italy, between the 16 and 19 of April 2013. A number of scientists working on the development of Management Strategy Evaluation (MSE) for IOTC tuna stocks worked together in order to progress along the lines agreed by the 4th session of the Working Party on Methods, and endorsed by the 15th Session of the Scientific Committee [@IOTC-2012-SC15].

Progress was made in developing an Operating Model for Indian Ocean albacore, the initial design of an Operating Model for skipjack tuna, the structure and content of a demonstration session on MSE, and some initial draft management procedures for albacore tuna.


# OBJECTIVES

The general objective of this workshop was to progress on the development of Management Strategy Evaluation (MSE) simulations for IOTC tuna stocks. More specifically, the participants agreed to the following set of objectives:

1. To review factors to be included in the initial set of Operating Models (OM) for Indian Ocean albacore.
2. To assemble a first round of Operating Models for Indian Ocean albacore.
3. To select a number of scenarios to be considered as sensititity runs for those Operating Models.
4. To discuss an initial set of Management Plans, including possible Harvest Control Rules and interim management objectives.
5. To discuss the design of Operating Models for Indian Ocean tropical tuna stocks (skipjack, yellowfin and bigeye tuna).
6. To examine and experiment with the FLR development platform
7. To propose a design for a demonstration platform on MSE to be presented to the IOTC Scientific Committee.
8. Plan future work and subsequent workshops.
9. Provide the chair of the Scientific Commitee with an update on MSE development to be included in the scientific presentation to the IOTC plenary.

# Albacore OPERATING MODELS

The group agreed to the use of one of the stock assessment models presented at the 2012 session of the Working Party on Temperate Tuna [@IOTC-2012-WPTmT] as a basis for the first set of operating models.

Progress was made at developing a base Operating Model for Indian Ocean Albacore, including initial runs of the population model grid. Further refinements to the code will be carried out to improve error handling and legibility.

## Uncertainty considered in the albacore Operating Model

A number of factors were considered by the group to be of priority to be included in the grid of model runs so as to be able to cover as fully as possible the main sources of uncertainty in the estimation of albacore population history and status. These factors are:

- Natural mortality
- Variance in recruitment estimates
- Steepnees of the stock-recruitment relationship
- Variance in the CPOUE series used as index of abundance
- Importance of the catch-at-length data in the final likelihood
- Changes in catchability in the Taiwan, China LL CPUE series
- Shape of the selectivity function for the catches of Taiwan, China LL

Consideration of reasonable hypothesis regarding hese factors lead the group to the choaice of two or three values for associated parameters in the population model related to to each of them, as reflected in Table 1. The combination of all factors and levels in this grid generated a total of 658 model runs.

Factor                                Levels
------                                -----------------
M, natural mortality at age           0.2, 0.3, 0.4
sigmaR, variance in recruitment       0.2, 0.4, 0.6
h, stock-recruit steepness            0.65, 0.8, 0.95
CV(CPUE), CV in LL CPUE series        0.1, 0.2, 0.3
ESS, weight to length data in lkhd    10, 20
TWN LL Q, change in catchability      1.00, 1.0025
TWN LL select, selectivity TWN LL     Logarithmic, Double normal

Table: Albacore OM grid for SS3 runs

Although an initial set of runs was carried out during the workshop, and initial results were inspected by the group, it was considered preferable for the code to be reviewed later on and the results of a final run to be circulated at a later date.

## Current MSE work by ICCAT on Atlantic albacore

A presentation on current work on development of MSE for Atlantic albacore as carried out in ICCAT was made to the group by Gorka MERINO. A number of similarities exist between both stocks and fisheries, although ICCAT has a longer history of carrying out age-structured assessments for one of its stocks, and so might be better placed to start using it as a basis for an Operating Model. Further collaboration with ICCAT was considered useful and relevant scientists eill be contacted to see if they could present this work in more details at the next MSE workshop.

# Albacore MANAGEMENT PROCEDURES

Initial discussion took place of a possible range of initial management procedures to be tested for alabcore tuna. The group agreed to start work on at least two types of harvest control rules: model-based and model-free. An initial model-based rule will be based on a simple stock assessment (i.e. biomaass dynamics) and would set a Total Allowable Catch (TAC) so as to bring in a short period of time the stock back to the required levels. These will be set by the interim reference points that IOTC that recently adopted.

A model-free rule will have to be dependent on trends in the CPUE series, although other sources of information could be introduced as well in the simulations, for example tagging.

- Group to DEVELOP initial HCRs once albacore OM is ready.

# Skipjack OPERATING MODELS

Initial discussions took place on a draft design for an Operating Model for Indian Ocean Skipjack. A design document was submitted to the workshop by the consultant, N. Bentley, working for the Maldivian government to work together with WPM on the development of MSE models for skipjack. The group submitted its feedback to the consultant and looks forward to a more detailed presentation during the second MSE Workshop in October

- WPM chair and vice-chair to CONTACT N. Bentley to provide the group feedback on initial skipjck ONM design.

# DESIGN OF MSE DEMONSTRATION

The chair and vice-chair of WPM have been requested by the chair of IOTC Scientific Committee and the Secretariat to plan and prepare a demonstrative session on MSE for the next meeting of the SC, to be held in December 2013. An initial discussion of the possible structure and contents of this session took place during the Workshop, and s number of members agreed to work during the next few months at developing the necessary material, and along this structure:

- 2-3 half hour sessions to be carried out during or inmediately after SC plenary.
- Balance of presentation and practical demonstration:

	1. Introduction to MSE and basic concepts of simulation
	2. Example simplified MSE to show difference in probabilistic outcomes and trade-offs.
- Link as much as possible all explanations to current setting at IOTC.

A repository will be created to help development of this material and keep it open to the public for review and future reuse. The repository can be found at [IOTC WPM's github page](https://github.com/iotcwpm/MSE-Training).

- Group to WORK on developing the MSE demonstration material.


# OTHER ISSUES

## MSE progress at SC chair presentation to COM

The group put together a list of issues to be reported to the chair of the SC for this presentation on scientific work to the plenary of IOTC.

- WPM chair and vice-chair to contact SC chair with points of progress on MSE.


# WORKPLAN

A very tentative workplan for the next few months was put together, but all participants indicated that other commitments will have a significant impact on how much time and effort that can devote in the short term to WPM MSE work. It is hoped that researchers will be able to increase their availability for this work over the next year.

## ANALYSIS

- ALB set of OMs: write and document code (IM)
- Code ALB MPs (IM, AL, RH, FS)
- Start work on TROP OMs (AL, NB, IM, RH, RS, MS)

## DOCUMENTS

- Presentation to COM17 (IM, TK)
- WPTT document on progress in TROP Oms (IM, TK)
- WPTmT document on progress in ALB OMs and MPs (IM, TK)
- Presentation & demo for SC15 (all)

## CODING

- Extend FLR methods to seasonal dynamics (FS, IM)

- Make a4a work on biomass CPUE (CM, IM)

- Build MSE demo platform (IM, FS, CO)

## MEETING

- 28 OCT 2013, AZTI Tecnalia, Pasaia, Spain

# PARTICIPANTS

- Richard HILLARY, CSIRO, Australia.
- Toshihide KITAKADO, TUMST, Japan.
- Adam LANGLEY, IOTC Secretariat.
- Gorka MERINO, AZTI, European Union.
- Colin MILLAR, EC JRC, European Union.
- Iago MOSQUEIRA, EC JRC, European Union.
- Finlay SCOTT, EC JRC, European Union.
- Rishi SHARMA, IOTC Secretariat.
- Maria SOTO, IEO, European Union.

# BIBLIOGRAPHY
