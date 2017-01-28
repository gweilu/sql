CREATE TABLE mcrsitesitegs_bak AS SELECT * FROM mcrsitesitegs;
CREATE TABLE mcrss_temp (
rssid VARCHAR2(20),
miletype VARCHAR2(20));
ALTER TABLE mcrss_temp ADD(org VARCHAR(5));
SELECT * FROM mcrss_temp rss WHERE rss.org='2' FOR UPDATE;
UPDATE mcrss_temp t SET t.org='2' WHERE t.org IS NULL;
SELECT * FROM Typeentry t WHERE t.typename='BUSSID';
UPDATE mcrsitesitegs rss SET rss.miletypeid=(SELECT t.miletype FROM mcrss_temp t WHERE t.rssid=rss.rsitesiteid) WHERE rss.rsitesiteid IN (SELECT t.rssid FROM mcrss_temp t WHERE t.org='2' AND t.miletype IS NOT NULL);
SELECT * FROM mcrsitesitegs rss  WHERE rss.miletypeid !=24;
