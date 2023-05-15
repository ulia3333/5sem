LOAD DATA
INFILE TSQLLOADER.txt
INTO TABLE TSQLLOADER
REPLACE
FIELDS TERMINATED BY ';'
(
    id,
    text "UPPER(:text)",
    date_value DATE 'dd-mm-yyyy'
)