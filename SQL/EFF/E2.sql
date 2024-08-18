---------------------------E2 CIS 昨天------------------------------------
WITH WPH_LIST AS (
	SELECT WFR_QTY,
	CASE
	WHEN LOT_TYPE ='MD' AND EQP_ID IN ('BETET032','BETET034','BETET035','AETET023') THEN 'MD'
	WHEN DEVICE_ID LIKE 'PS5270%' AND STEP_NAME='ET-E2-Si_Etch' THEN 'NEO_TEMP'
	WHEN DEVICE_ID LIKE 'PS5280%' AND STEP_NAME='ET-E2-Si_Etch' THEN 'NEO_TEMP'
	WHEN (DEVICE_ID NOT LIKE 'PS5280%' AND DEVICE_ID NOT LIKE 'PS5270%') AND STEP_NAME='ET-E2-Si_Etch' THEN 'E2_CIS'
    END DEVICE_ID
	FROM CIMDM.DM_MOVE_BT WHERE (STEP_NAME IN ('ET-E2-Si_Etch') AND EQP_ID IN ('BETET032','BETET034','BETET035','AETET023'))
	AND TRACK_OUT_BT BETWEEN TO_DATE(to_char(sysdate-1,'yyyy-mm-dd') || ' 07:30:00','yyy-mm-dd hh24:24:mi:ss')
	AND TO_DATE(to_char(sysdate,'yyyy-mm-dd') || ' 07:30:00','yyy-mm-dd hh24:24:mi:ss')
),
WPH_SUM_TOTAL AS (
	SELECT SUM(WFR_QTY) WFR_QTY FROM WPH_LIST
),
WPH_SUM AS (
	SELECT SUM(WFR_QTY) WFR_QTY,DEVICE_ID FROM WPH_LIST GROUP BY DEVICE_ID
),
WPH_TABLE AS (
	SELECT DEVICE_ID,CASE 
	WHEN DEVICE_ID='MD' THEN 5.0
	WHEN DEVICE_ID='NEO_TEMP' THEN 2.2
    WHEN DEVICE_ID='E2_CIS' THEN 4.4
	END WPHTABLE FROM WPH_TABLE
),
WPH_TABLE_STD AS (
	SELECT MAX(WPHTABLE) MAX_STD FROM WPH_TABLE
),
WPH_TABLE2 AS (
	SELECT A.DEVICE_ID,B.MAX_STD/A.WPHTABLE WPHTABLE FROM WPH_TABLE A , WPH_TABLE_STD B
),
WPH_CALCULATE_F AS (
	SELECT A.DEVICE_ID,A.WFR_QTY*B.WPHTABLE R_RESULT FROM WPH_SUM A JOIN WPH_TABLE2 B ON A.DEVICE_ID=B.DEVICE_ID
),
WPH_CALCULATE_B AS (
	SELECT SUM(R_ESULT) R_ESULT FROM WPH_CALCULATE_F
),
UP_LIST AS (
	SELECT ROUND(AVG(UP),4) UP FROM CIMDM.RPT_KER_SUM WHERE (EQP_ID IN ('BETET032','BETET034','BETET035') AND FAB='FAB2')
	AND (EQP_ID IN ('AETET023') AND FAB='FAB1') AND WIPDATE = TO_DATE(SYSDATE-1,'yyyy-mm-dd')
),
AVL_LIST AS (
	SELECT ROUND(AVG(UP+LOST),4) UP FROM CIMDM.RPT_KER_SUM WHERE (EQP_ID IN ('BETET032','BETET034','BETET035') AND FAB='FAB2')
	AND (EQP_ID IN ('AETET023') AND FAB='FAB1') AND WIPDATE = TO_DATE(SYSDATE-1,'yyyy-mm-dd')
)
SELECT ROUND(A.R_ESULT/((B.UP/100)*C.MAX_STD*8*24),4) EFF , ROUND(A.R_ESULT,2) TTL_TOTAL ,C.MAX_STD,D.WFR_QTY E1_MAIN_MOVE,
((B.UP/100)*C.MAX_STD*8*24) MOVE_TARGET,B.UP,E.UP FROM
WPH_CALCULATE_B A,UP_LIST B,WPH_TABLE_STD C,WPH_SUM_TOTAL D,AVL_LIST E

---------------------------E1 & E2 CIS 現在------------------------------------------------


WITH WPH_LIST AS (
	SELECT WFR_QTY,
	CASE
	WHEN LOT_TYPE ='MD' AND EQP_ID IN ('BETET032','BETET034','BETET035','AETET023') THEN 'MD'
	WHEN DEVICE_ID LIKE 'PS5270%' AND STEP_NAME='ET-E2-Si_Etch' THEN 'NEO_TEMP'
	WHEN DEVICE_ID LIKE 'PS5280%' AND STEP_NAME='ET-E2-Si_Etch' THEN 'NEO_TEMP'
	WHEN (DEVICE_ID NOT LIKE 'PS5280%' AND DEVICE_ID NOT LIKE 'PS5270%') AND STEP_NAME='ET-E2-Si_Etch' THEN 'E2_CIS'
    END DEVICE_ID
	FROM CIMDM.DM_MOVE_BT WHERE (STEP_NAME IN ('ET-E2-Si_Etch') AND EQP_ID IN ('BETET032','BETET034','BETET035','AETET023'))
	AND TRACK_OUT_BT BETWEEN TO_DATE(to_char(sysdate,'yyyy-mm-dd') || ' 07:30:00','yyy-mm-dd hh24:24:mi:ss')
	AND TO_DATE(to_char(sysdate+1,'yyyy-mm-dd') || ' 07:30:00','yyy-mm-dd hh24:24:mi:ss')
),
WPH_SUM_TOTAL AS (
	SELECT SUM(WFR_QTY) WFR_QTY FROM WPH_LIST
),
WPH_SUM AS (
	SELECT SUM(WFR_QTY) WFR_QTY,DEVICE_ID FROM WPH_LIST GROUP BY DEVICE_ID
),
WPH_TABLE AS (
	SELECT DEVICE_ID,CASE 
	WHEN DEVICE_ID='MD' THEN 5.0
	WHEN DEVICE_ID='NEO_TEMP' THEN 2.2
    WHEN DEVICE_ID='E2_CIS' THEN 4.4
	END WPHTABLE FROM WPH_TABLE
),
WPH_TABLE_STD AS (
	SELECT MAX(WPHTABLE) MAX_STD FROM WPH_TABLE
),
WPH_TABLE2 AS (
	SELECT A.DEVICE_ID,B.MAX_STD/A.WPHTABLE WPHTABLE FROM WPH_TABLE A , WPH_TABLE_STD B
),
WPH_CALCULATE_F AS (
	SELECT A.DEVICE_ID,A.WFR_QTY*B.WPHTABLE R_RESULT FROM WPH_SUM A JOIN WPH_TABLE2 B ON A.DEVICE_ID=B.DEVICE_ID
),
WPH_CALCULATE_B AS (
	SELECT SUM(R_ESULT) R_ESULT FROM WPH_CALCULATE_F
),
UP_LIST AS (
	SELECT ROUND(AVG(UP),4) UP FROM CIMDM.RPT_KER_SUM WHERE (EQP_ID IN ('BETET032','BETET034','BETET035','BETET036') AND FAB='FAB2')
	AND (EQP_ID IN ('AETET023') AND FAB='FAB1') AND WIPDATE = TO_DATE(SYSDATE,'yyyy-mm-dd')
),
AVL_LIST AS (
	SELECT ROUND(AVG(UP+LOST),4) UP FROM CIMDM.RPT_KER_SUM WHERE (EQP_ID IN ('BETET032','BETET034','BETET035','BETET036') AND FAB='FAB2')
	AND (EQP_ID IN ('AETET023') AND FAB='FAB1') AND WIPDATE = TO_DATE(SYSDATE,'yyyy-mm-dd')
)
SELECT ROUND(A.R_ESULT/((B.UP/100)*C.MAX_STD*8*ROUND((SYSDATE - TO_DATE(TO_CHAR(SYSDATE, 'YYYY-MM-DD') || ' 07:30:00', 'YYYY-MM-DD HH24:MI:SS')) * 24, 4)),4) EFF , ROUND(A.R_ESULT,2) TTL_TOTAL ,C.MAX_STD,D.WFR_QTY E1_MAIN_MOVE,
((B.UP/100)*C.MAX_STD*8*ROUND((SYSDATE - TO_DATE(TO_CHAR(SYSDATE, 'YYYY-MM-DD') || ' 07:30:00', 'YYYY-MM-DD HH24:MI:SS')) * 24, 4)) MOVE_TARGET,
B.UP,E.UP FROM
WPH_CALCULATE_B A,UP_LIST B,WPH_TABLE_STD C,WPH_SUM_TOTAL D,AVL_LIST E