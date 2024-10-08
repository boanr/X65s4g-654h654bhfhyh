---------------------------TSV PEGASUS 昨天------------------------------------
WITH WPH_LIST AS (
	SELECT WFR_QTY,
	CASE
	WHEN ((EQP_ID='BETET031' AND CHAMBER='C') OR (EQP_ID='BETET033' AND CHAMBER='C')) AND LOT_TYPE='MD' THEN 'MD'
	WHEN STEP_NAME='ET-Trch-Si_Etch' THEN 'Trch'
	WHEN STEP_NAME='ET-RET-Si_Etch' THEN 'RET'
	END DEVICE_ID
	FROM CIMDM.DM_MOVE_BT WHERE (STEP_NAME ='ET-Trch-Si_Etch' OR STEP_NAME ='ET-RET-Si_Etch' OR LOT_TYPE='MD')  AND ((EQP_ID='BETET031' AND CHAMBER='C') OR (EQP_ID='BETET033' AND CHAMBER='C'))
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
	WHEN DEVICE_ID='Trch' THEN 3.09
	WHEN DEVICE_ID='RET' THEN  6.78
    WHEN DEVICE_ID='MD' THEN 3.0
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
	SELECT ROUND(AVG(UP),4) UP FROM CIMDM.RPT_KER_SUM WHERE (EQP_ID IN ('BETET031','BETET033') AND FAB='FAB2')
    AND WIPDATE = TO_DATE(SYSDATE-1,'yyyy-mm-dd')
),
AVL_LIST AS (
	SELECT ROUND(AVG(UP+LOST),4) UP FROM CIMDM.RPT_KER_SUM WHERE (EQP_ID IN ('BETET031','BETET033') AND FAB='FAB2')
	AND WIPDATE = TO_DATE(SYSDATE-1,'yyyy-mm-dd')
)
SELECT ROUND(A.R_ESULT/((B.UP/100)*C.MAX_STD*2*24),4) EFF , ROUND(A.R_ESULT,2) TTL_TOTAL ,C.MAX_STD,D.WFR_QTY E1_MAIN_MOVE,
((B.UP/100)*C.MAX_STD*2*24) MOVE_TARGET,B.UP,E.UP FROM
WPH_CALCULATE_B A,UP_LIST B,WPH_TABLE_STD C,WPH_SUM_TOTAL D,AVL_LIST E

---------------------------TSV PEGASUS 現在------------------------------------------------


WITH WPH_LIST AS (
	SELECT WFR_QTY,
	CASE
	WHEN ((EQP_ID='BETET031' AND CHAMBER='C') OR (EQP_ID='BETET033' AND CHAMBER='C')) AND LOT_TYPE='MD' THEN 'MD'
	WHEN STEP_NAME='ET-Trch-Si_Etch' THEN 'Trch'
	WHEN STEP_NAME='ET-RET-Si_Etch' THEN 'RET'
	END DEVICE_ID
	FROM CIMDM.DM_MOVE_BT WHERE (STEP_NAME ='ET-Trch-Si_Etch' OR STEP_NAME ='ET-RET-Si_Etch' OR LOT_TYPE='MD')  AND ((EQP_ID='BETET031' AND CHAMBER='C') OR (EQP_ID='BETET033' AND CHAMBER='C'))
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
	WHEN DEVICE_ID='Trch' THEN 3.09
	WHEN DEVICE_ID='RET' THEN  6.78
    WHEN DEVICE_ID='MD' THEN 3.0
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
	SELECT ROUND(AVG(UP),4) UP FROM CIMDM.RPT_KER_SUM WHERE (EQP_ID IN ('BETET031','BETET033') AND FAB='FAB2')
    AND WIPDATE = TO_DATE(SYSDATE,'yyyy-mm-dd')
),
AVL_LIST AS (
	SELECT ROUND(AVG(UP+LOST),4) UP FROM CIMDM.RPT_KER_SUM WHERE (EQP_ID IN ('BETET031','BETET033') AND FAB='FAB2')
	AND WIPDATE = TO_DATE(SYSDATE,'yyyy-mm-dd')
)
SELECT ROUND(A.R_ESULT/((B.UP/100)*C.MAX_STD*2*ROUND((SYSDATE - TO_DATE(TO_CHAR(SYSDATE, 'YYYY-MM-DD') || ' 07:30:00', 'YYYY-MM-DD HH24:MI:SS')) * 24, 4)),4) EFF , ROUND(A.R_ESULT,2) TTL_TOTAL ,C.MAX_STD,D.WFR_QTY E1_MAIN_MOVE,
((B.UP/100)*C.MAX_STD*2*ROUND((SYSDATE - TO_DATE(TO_CHAR(SYSDATE, 'YYYY-MM-DD') || ' 07:30:00', 'YYYY-MM-DD HH24:MI:SS')) * 24, 4)) MOVE_TARGET,
B.UP,E.UP FROM
WPH_CALCULATE_B A,UP_LIST B,WPH_TABLE_STD C,WPH_SUM_TOTAL D,AVL_LIST E