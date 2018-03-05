/*************************************************************************************************/
									/* LIBRERIE */
/*************************************************************************************************/

libname output '/sasdatacrms/data2/projects/a063_CRAI_NPL/lev1/output'; 
libname staging '/sasdatacrms/data2/projects/a063_CRAI_NPL/lev1/staging';
libname DM '/sasdatacrms/data2/projects/a063_CRAI_NPL/lev1/output/data_model'; 
libname indart '/sasdatacrms/data2/projects/a063_CRAI_NPL/lev1/input/manual_feeding/Dart'; 
libname indobank '/sasdatacrms/data2/projects/a063_CRAI_NPL/lev1/input/manual_feeding/DoBank'; 
libname loantape '/sasdatacrms/data2/projects/a063_CRAI_NPL/lev1/output/loan_tape';
libname postmerg '/sasdatacrms/data2/projects/a063_CRAI_NPL/lev1/output/data_model/post_merge';
libname large_s '/sasdatacrms/data2/projects/a063_CRAI_NPL/lev1/output/loan_tape/official_delivery_20160909/sas/large_file';
libname legacy_s '/sasdatacrms/data2/projects/a063_CRAI_NPL/lev1/output/loan_tape/official_delivery_20160909/sas/legacy';
libname sec_s '/sasdatacrms/data2/projects/a063_CRAI_NPL/lev1/output/loan_tape/official_delivery_20160909/sas/sme_secured';
libname unsec_s '/sasdatacrms/data2/projects/a063_CRAI_NPL/lev1/output/loan_tape/official_delivery_20160909/sas/sme_unsecured';

libname inptfino base "/sasdatacrms/data2/projects/a063_CRAI_NPL/lev1/staging/FINO_DQ/datainputcopy"; /* Copy-Input Dataset Library */

/*************************************************************************************************/
							/* PREPARO LE TABELLE */
/*************************************************************************************************/

/*************************************************************************************************/

/* PERIMETRO */
data perimetro_sellable;
	set output.Perimetro_ndg_201606_russo_v4
			(keep = ndg flag_management gbv_netto_rad classe_final flag_core_noncore f_esclusioni_final);
	if flag_core_noncore eq 'NON CORE' and f_esclusioni_final = 0 then SELLABLE = 'Y';
	else SELLABLE = 'N';
run;

/*************************************************************************************************/

/* RAPPORTI */
proc sql;
	create table rapporti as
		select a.*, b.flag_management, b.gbv_netto_rad, b.classe_final,
				b.flag_core_noncore, b.f_esclusioni_final, b.SELLABLE
		from perimetro_sellable as b inner join postmerg.rapporti_final as a
										on a.ndg = b.ndg;
quit;

data rapporti;
	set rapporti;
	length SOURCE $20;
	if update_source_final in ('Aggiornato da duplicazione BENI.', 'NEW. Source: DaRT' ,
								'ORIGINAL. Source: DaRT', 'UPDATED. Source: DaRT')
		then SOURCE = 'DaRT';
	else if update_source_final in ('NEW. Source: DoBank' ,	'UPDATED. Source: DoBank')
		then SOURCE = 'DoBank'; 
	else SOURCE = 'UCI';
	gbv_netto_rad = GROSS_BOOK_VALUE_CUTOFF;
run;

data rapporti_UCI;
	set rapporti;
	SOURCE = 'UCI';
run;

proc sql;
	CREATE TABLE rapporti_NDG AS
	SELECT ndg,
			sum(VANTATO_DATA_CUTOFF) as VANTATO_DATA_CUTOFF,
			sum(RADIATO) as RADIATO,
			sum(GROSS_BOOK_VALUE_CUTOFF) as GROSS_BOOK_VALUE_CUTOFF,
			sum(CAPITALE_DATA_CUTOFF) as CAPITALE_DATA_CUTOFF,
			sum(INTERESSI_DATA_CUTOFF) as INTERESSI_DATA_CUTOFF,
			sum(GROSS_BOOK_VALUE_DATA_SOFF) as GROSS_BOOK_VALUE_DATA_SOFF,
			sum(CAPITALE_DATA_SOFFERENZA) as CAPITALE_DATA_SOFFERENZA,
			sum(INTERESSI_DATA_SOFFERENZA) as INTERESSI_DATA_SOFFERENZA
	FROM rapporti_UCI
	WHERE SELLABLE = 'Y'
	GROUP BY ndg;
quit;

proc sql;
	create table rapporti_NDG as
	select a.*, b.flag_management, b.classe_final, b.flag_core_noncore, b.f_esclusioni_final, b.SELLABLE
	from rapporti_NDG as a inner join
	perimetro_sellable as b
	on a.ndg = b.ndg;
quit;

data rapporti_NDG;
	set rapporti_NDG;
	length SOURCE $20;
	SOURCE = 'UCI';
run;

proc sql;
	CREATE TABLE rapporti_classe AS
	SELECT classe_final,
			sum(VANTATO_DATA_CUTOFF) as VANTATO_DATA_CUTOFF,
			sum(RADIATO) as RADIATO,
			sum(GROSS_BOOK_VALUE_CUTOFF) as GROSS_BOOK_VALUE_CUTOFF,
			sum(CAPITALE_DATA_CUTOFF) as CAPITALE_DATA_CUTOFF,
			sum(INTERESSI_DATA_CUTOFF) as INTERESSI_DATA_CUTOFF,
			sum(GROSS_BOOK_VALUE_DATA_SOFF) as GROSS_BOOK_VALUE_DATA_SOFF,
			sum(CAPITALE_DATA_SOFFERENZA) as CAPITALE_DATA_SOFFERENZA,
			sum(INTERESSI_DATA_SOFFERENZA) as INTERESSI_DATA_SOFFERENZA
	FROM rapporti_NDG
	WHERE SELLABLE = 'Y'
	GROUP BY classe_final;
quit;

/*************************************************************************************************/

/* GARANZIE */
proc sql;
	create table garanzie as
	select a.*, 
           b.gbv_netto_rad, 
           b.classe_final, 
           b.flag_core_noncore, 
           b.f_esclusioni_final, 
           b.SELLABLE
	from perimetro_sellable as b inner join
	postmerg.garanzie_final as a
	on a.ndg = b.ndg;
quit;

data garanzie;
	set garanzie;
	length SOURCE $20;
	if update_source_final in ('Aggiornato da duplicazione BENI.', 'NEW. Source: DaRT' ,
								'ORIGINAL. Source: DaRT','UPDATED. Source: DaRT')
		then SOURCE = 'DaRT';
	else if update_source_final in ('NEW. Source: DoBank' ,	'UPDATED. Source: DoBank')
		then SOURCE = 'DoBank'; 
	else if update_source_final in ('DELETED. Source: DoBank')
		then delete;
	else SOURCE = 'UCI';
run;

data garanzie_UCIDOB;
	set garanzie;
	if SOURCE eq 'DaRT' then SOURCE = 'UCI';
run;

data garanzie_UCI;
	set garanzie;
	SOURCE = 'UCI';
run;

data inptfino.garanzie;
	set garanzie;
	where SELLABLE = 'Y';
run;

/*************************************************************************************************/

/* PROCEDURE */
proc sql;
	create table procedure as
	select a.*, 
           b.gbv_netto_rad, 
           b.classe_final, 
           b.flag_core_noncore, 
           b.f_esclusioni_final, 
           b.SELLABLE
	from perimetro_sellable as b inner join
	postmerg.procedure_final as a
	on a.ndg = b.ndg;
quit;

data procedure;
	set procedure;
	length SOURCE $20;
	if update_source_final in ('Aggiornato da duplicazione BENI.', 'NEW. Source: DaRT' ,
								'ORIGINAL. Source: DaRT','UPDATED. Source: DaRT')
		then SOURCE = 'DaRT';
	else if update_source_final in ('NEW. Source: DoBank' ,	'UPDATED. Source: DoBank')
		then SOURCE = 'DoBank'; 
	else if update_source_final eq ''
		then SOURCE = 'UCI';
	else delete;
run;

data inptfino.tabella_procedura_tribunale;
	set procedure;
	where SELLABLE = 'Y';
	format dt_accordo_stragiudiz DT_INIZIO_PIANO_RIENTRO dt_fine_piano_rientro ddmmyy10.;
run;

/*************************************************************************************************/

/* PERIZIE */
proc sql;
	create table perizie as
	select a.*, 
           b.gbv_netto_rad, 
           b.classe_final, 
           b.flag_core_noncore, 
           b.f_esclusioni_final, 
           b.SELLABLE
	from garanzie as b inner join
	postmerg.perizie_final as a
	on a.ndg = b.ndg and a.codice_garanzia = b.nm_garanzia_sisba;
quit;

data perizie;
	set perizie;
	length SOURCE $20;
	if update_source_final in ('Aggiornato da duplicazione BENI.', 'NEW. Source: DaRT' ,
								'ORIGINAL. Source: DaRT','UPDATED. Source: DaRT')
		then SOURCE = 'DaRT';
	else if update_source_final in ('NEW. Source: DoBank' ,	'UPDATED. Source: DoBank')
		then SOURCE = 'DoBank'; 
	else if update_source_final eq ''
		then SOURCE = 'UCI';
	else delete;
run;

data inptfino.perizie;
	set perizie;
	where SELLABLE = 'Y';
	format DATA_ULTIMA_PERIZIA ddmmyy10.;
run;

/*************************************************************************************************/

/* BENI */
proc sql;
	create table beni as
	select a.*, 
           b.gbv_netto_rad, 
           b.classe_final, 
           b.flag_core_noncore, 
           b.f_esclusioni_final, 
           b.SELLABLE
	from garanzie as b inner join
	postmerg.beni_immobili_final as a
	on a.ndg = b.ndg and a.codice_garanzia = b.nm_garanzia_sisba;
quit;

data beni;
	set beni;
	length SOURCE $20;
	if update_source_final in ('Aggiornato da duplicazione BENI.', 'NEW. Source: DaRT' , 
								'ORIGINAL. Source: DaRT','UPDATED. Source: DaRT') 
		then SOURCE = 'DaRT';
	else if update_source_final in ('NEW. Source: DoBank' ,	'UPDATED. Source: DoBank') 
		then SOURCE = 'DoBank'; 
	else if update_source_final eq '' 
		then SOURCE = 'UCI';
	else delete;
	if ( not (NUMERO_ASTE in (., 0) ) or not (DATA_ULTIMA_ASTA in (., 0) ) or 
			not (PREZZO_BASE_ULTIMA_ASTA in (., 0) ) or not (ESITO_ULTIMA_ASTA in ('N/A', '') ) or 
			not (IMPORTO_AGGIUDICAZIONE in (., 0) ) or not (DATA_AGGIUDICAZIONE in (., 0) )
		) 
		then IS_ASTA = 'Y';
	else IS_ASTA = 'N';

run;

data inptfino.beni_immobili;
	set beni;
	where SELLABLE = 'Y';
	format DATA_ULTIMA_ASTA DATA_AGGIUDICAZIONE ddmmyy10.;
run;


/*************************************************************************************************/

/* ANAGRAFE DEBITORI */

data egadeb;
	set large_s.anagrafe_debitori (keep = ndg) large_s.anagrafe_debitori_addendum (keep = ndg)
	    legacy_s.anagrafe_debitori (keep = ndg) legacy_s.anagrafe_debitori_addendum (keep = ndg)
		sec_s.anagrafe_debitori (keep = ndg) sec_s.anagrafe_debitori_addendum (keep = ndg)
		unsec_s.anagrafe_debitori (keep = ndg) unsec_s.anagrafe_debitori_addendum (keep = ndg);
run;

proc sort data = egadeb nodupkey; 
	by ndg; 
run;

data anagrafe_debitori_t;
	merge dm.anagrafe_debitori (in = in1) egadeb (in = in2);
	by ndg;
	length SOURCE $20;
	SOURCE = 'UCI';
	if classe_final in ('', ' ', 'INDIV_UNS', 'Other', 'RESID') then classe_final = 'COSIGN';
	if in2 then SELLABLE = 'Y'; else SELLABLE = 'N';
	if in1 then output;
run;

data anagrafe_debitori_t2 (keep = NDG);
	set perimetro_sellable (keep = ndg SELLABLE);
	where SELLABLE = 'Y';
run;

data anagrafe_debitori;
	merge anagrafe_debitori_t (in = in1) anagrafe_debitori_t2 (in = in2);
	by ndg;
	if in2 then EXCL_COINT = 'Y'; else EXCL_COINT = 'N';
	if in1 then output;
run;

proc sql;
	create table anagrafe_debitori as
		select a.*, b.flag_management, b.gbv_netto_rad
		from anagrafe_debitori as a left join perimetro_sellable as b
									on a.ndg = b.ndg;
quit;

/*************************************************************************************************/

/* ANAGRAFE GARANTI */
data egagar;
	set large_s.anagrafe_garante (keep = ndg) large_s.anagrafe_garante_addendum (keep = ndg)
	    legacy_s.anagrafe_garante (keep = ndg) legacy_s.anagrafe_garante_addendum (keep = ndg)
		sec_s.anagrafe_garante (keep = ndg) sec_s.anagrafe_garante_addendum (keep = ndg)
		unsec_s.anagrafe_garante (keep = ndg) unsec_s.anagrafe_garante_addendum (keep = ndg);
run;

proc sort data = egagar nodupkey; 
	by ndg; 
run;

data anagrafe_garante_t;
	merge dm.anagrafe_garante (in = in1) egagar (in = in2);
	by ndg;
	length SOURCE $20;
	SOURCE = 'UCI';
	if in2 then SELLABLE = 'Y'; else SELLABLE = 'N';
	if in1 then output;
run;

proc sql;
	create table anagrafe_garante_t2 as
		select a.*, b.flag_management, b.gbv_netto_rad, b.classe_final
		from anagrafe_garante_t as a left join perimetro_sellable as b
										on a.ndg = b.ndg;
quit;

data anagrafe_garante_t3;
	set anagrafe_garante_t2;
	if classe_final in ('', ' ', 'INDIV_UNS', 'Other', 'RESID')
		then classe_final = 'COSIGN';
run;

data inptfino.anagrafe_garante;
	set anagrafe_garante_t3;
	where SELLABLE = 'Y';
run;

/*************************************************************************************************/

/* INCASSI */

data incassi_mensili_t;
	set large_s.incassi
	    legacy_s.incassi
		sec_s.incassi
		unsec_s.incassi;
	length SOURCE $20;
	SOURCE = 'UCI';
	SELLABLE = 'Y';
run;

proc sql;
	create table incassi as
		select a.*, b.flag_management, b.gbv_netto_rad, b.classe_final
		from incassi_mensili_t as a left join perimetro_sellable as b
									on a.ndg = b.ndg;
quit;

proc sql;
	CREATE TABLE incassi_classe AS
		SELECT classe_final,
				sum(im_moviment) as im_moviment,
				sum(im_moviment_service) as im_moviment_service
		FROM incassi
		WHERE SELLABLE = 'Y'
		GROUP BY classe_final
		;
quit;

data inptfino.incassi;
	set incassi;
	where SELLABLE = 'Y';
run;

/*************************************************************************************************/


proc delete data=perimetro_sellable;
run;
proc delete data=rapporti;
run;
proc delete data=rapporti_UCI;
run;
proc delete data=rapporti_NDG;
run;
proc delete data=rapporti_classe;
run;
proc delete data=garanzie;
run;
proc delete data=garanzie_UCIDOB;
run;
proc delete data=garanzie_UCI;
run;
proc delete data=procedure;
run;
proc delete data=perizie;
run;
proc delete data=beni;
run;
proc delete data=egadeb;
run;
proc delete data=anagrafe_debitori_t;
run;
proc delete data=anagrafe_debitori_t2;
run;
proc delete data=anagrafe_debitori;
run;
proc delete data=egagar;
run;
proc delete data=anagrafe_garante_t;
run;
proc delete data=anagrafe_garante_t2;
run;
proc delete data=anagrafe_garante_t3;
run;
proc delete data=incassi_mensili_t;
run;
proc delete data=incassi;
run;
proc delete data=incassi_classe;
run;
