set client_encoding=UTF8;

/*module: 用戶
  field: 語言名稱
 */
CREATE OR REPLACE FUNCTION public.L1110_USLSNAME(F0301) RETURNS VARCHAR AS $$
DECLARE
	r VARCHAR;
BEGIN
	SELECT lsname INTO r FROM F1010 WHERE LSID=$1.USLSID;
   	RETURN r;
END;
$$LANGUAGE plpgsql;

/*module: 文章
  field: 摘要
 */
CREATE OR REPLACE FUNCTION public.L1110_ATBRF(F1110) RETURNS INT AS $$
DECLARE
	r VARCHAR;
    l INT;
    sen_tmp F1120;
BEGIN
	r:='';
	SELECT COUNT(*) INTO l FROM F1120 WHERE ASATID=$1.ATID;
   	FOR i IN 0..l-1 LOOP
		SELECT * INTO sen_tmp FROM F1120 WHERE ASATID=$1.ATID ORDER BY ASATID ASC,ASSI ASC LIMIT 1 OFFSET i;
        r:=r||sen_tmp.ASCONT;
        IF length(r)>96 THEN
        	EXIT;
        END IF;
    END LOOP;
	r:=substr(r,0,96);
    RETURN r;
END;
$$LANGUAGE plpgsql;

/*module: 文章
  field: A類
 */
CREATE OR REPLACE FUNCTION public.L1110_ATCSA(F1110) RETURNS INT AS $$
DECLARE
	r INT;
BEGIN
	SELECT COUNT(*) INTO r FROM F1120 WHERE ASATID=$1.ATID AND ASST=0 AND NOT EXISTS(SELECT * FROM F1130 WHERE TRASID=ASID) AND NOT EXISTS(SELECT * FROM F1131 WHERE TAASID=ASID AND TAST=1);
	RETURN r;
END;
$$LANGUAGE plpgsql;

/*module: 文章
  field: B類
 */
CREATE OR REPLACE FUNCTION public.L1110_ATCSB(F1110) RETURNS INT AS $$
DECLARE
	r INT;
BEGIN
	SELECT COUNT(*) INTO r FROM F1120 WHERE ASATID=$1.ATID AND ASST=0 AND NOT EXISTS(SELECT * FROM F1130 WHERE TRASID=ASID) AND EXISTS(SELECT * FROM F1131 WHERE TAASID=ASID AND TAST=1);
	RETURN r;
END;
$$LANGUAGE plpgsql;

/*module: 文章
  field: C類
 */
CREATE OR REPLACE FUNCTION public.L1110_ATCSC(F1110) RETURNS INT AS $$
DECLARE
	r INT;
BEGIN
	SELECT COUNT(*) INTO r FROM F1120 WHERE ASATID=$1.ATID AND ASST=0 AND EXISTS(SELECT * FROM F1130 WHERE TRASID=ASID AND TRST=-1) AND NOT EXISTS(SELECT * FROM F1131 WHERE TAASID=ASID AND TAST=1);
	RETURN r;
END;
$$LANGUAGE plpgsql;

/*module: 文章
  field: D類
 */
CREATE OR REPLACE FUNCTION public.L1110_ATCSD(F1110) RETURNS INT AS $$
DECLARE
	r INT;
BEGIN
	SELECT COUNT(*) INTO r FROM F1120 WHERE ASATID=$1.ATID AND ASST=0 AND EXISTS(SELECT * FROM F1130 WHERE TRASID=ASID AND TRST=-1) AND EXISTS(SELECT * FROM F1131 WHERE TAASID=ASID AND TAST=1);
	RETURN r;
END;
$$LANGUAGE plpgsql;

/*module: 文章
  field: E類
 */
CREATE OR REPLACE FUNCTION public.L1110_ATCSE(F1110) RETURNS INT AS $$
DECLARE
	r INT;
BEGIN
	SELECT COUNT(*) INTO r FROM F1120 WHERE ASATID=$1.ATID AND ASST=0 AND EXISTS(SELECT * FROM F1130 WHERE TRASID=ASID AND TRST=1) AND NOT EXISTS(SELECT * FROM F1131 WHERE TAASID=ASID AND TAST=1);
	RETURN r;
END;
$$LANGUAGE plpgsql;

/*module: 文章
  field: F類
 */
CREATE OR REPLACE FUNCTION public.L1110_ATCSF(F1110) RETURNS INT AS $$
DECLARE
	r INT;
BEGIN
	SELECT COUNT(*) INTO r FROM F1120 WHERE ASATID=$1.ATID AND ASST=0 AND EXISTS(SELECT * FROM F1130 WHERE TRASID=ASID AND TRST=1) AND EXISTS(SELECT * FROM F1131 WHERE TAASID=ASID AND TAST=1);
	RETURN r;
END;
$$LANGUAGE plpgsql;

/*module: 文句
  field: 類
 */
CREATE OR REPLACE FUNCTION public.L1120_ASCS(F1120) RETURNS INT AS $$
DECLARE
	r VARCHAR;
	seg_all_cnt INT;
    seg_act_cnt INT;
    sef_act_cnt INT;
BEGIN
	SELECT COUNT(*) INTO seg_all_cnt FROM F1130 WHERE TRASID=$1.ASID;
   	SELECT COUNT(*) INTO seg_act_cnt FROM F1130 WHERE TRASID=$1.ASID AND TRST=0;
    SELECT COUNT(*) INTO sef_act_cnt FROM F1131 WHERE TAASID=$1.ASID AND TAST=1;
    IF $1.ASST=0 AND seg_all_cnt=0 AND sef_act_cnt=0 THEN
    	r:='A';
    ELSEIF $1.ASST=0 AND seg_all_cnt=0 AND sef_act_cnt>0 THEN
    	r:='B';
    ELSEIF $1.ASST=0 AND seg_all_cnt-seg_act_cnt>0 AND sef_act_cnt=0 THEN
    	r:='C';
    ELSEIF $1.ASST=0 AND seg_all_cnt-seg_act_cnt>0 AND sef_act_cnt>0 THEN
    	r:='D';
    ELSEIF $1.ASST=0 AND seg_act_cnt>0 AND sef_act_cnt=0 THEN
    	r:='E';
    ELSEIF $1.ASST=0 AND seg_act_cnt>0 AND sef_act_cnt>0 THEN
    	r:='F';
    ELSE
    	r:='0';
    END IF;
	RETURN r;
END;
$$LANGUAGE plpgsql;

/*module: 證書
  field: 語言名稱
 */
CREATE OR REPLACE FUNCTION public.L1110_CRLSNAME(F0331) RETURNS VARCHAR AS $$
DECLARE
	r VARCHAR;
BEGIN
	SELECT lsname INTO r FROM F1010 WHERE LSID=$1.CRLSID;
   	RETURN r;
END;
$$LANGUAGE plpgsql;

/*module: 證書
  field: 學術名
 */
CREATE OR REPLACE FUNCTION public.L1110_CRLSLOC(F0331) RETURNS VARCHAR AS $$
DECLARE
	r VARCHAR;
BEGIN
	SELECT lsloc INTO r FROM F1010 WHERE LSID=$1.CRLSID;
   	RETURN r;
END;
$$LANGUAGE plpgsql;