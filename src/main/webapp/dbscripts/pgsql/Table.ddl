## (C) Copyright IBM Corporation 2019.
##
## Licensed under the Apache License, Version 2.0 (the "License");
## you may not use this file except in compliance with the License.
## You may obtain a copy of the License at
##
## http://www.apache.org/licenses/LICENSE-2.0
##
## Unless required by applicable law or agreed to in writing, software
## distributed under the License is distributed on an "AS IS" BASIS,
## WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
## See the License for the specific language governing permissions and
## limitations under the License.

DROP TABLE HOLDINGEJB;
DROP TABLE ACCOUNTPROFILEEJB;
DROP TABLE QUOTEEJB;
DROP TABLE KEYGENEJB;
DROP TABLE ACCOUNTEJB;
DROP TABLE ORDEREJB;

CREATE TABLE HOLDINGEJB (
  PURCHASEPRICE DECIMAL(14, 2),
  HOLDINGID INTEGER NOT NULL,
  QUANTITY DOUBLE PRECISION NOT NULL,
  PURCHASEDATE TIMESTAMP,
  ACCOUNT_ACCOUNTID INTEGER,
  QUOTE_SYMBOL VARCHAR(250));
CREATE INDEX HOLDING_TS on HOLDINGEJB (QUOTE_SYMBOL);
ALTER TABLE HOLDINGEJB
  ADD CONSTRAINT PK_HOLDINGEJB PRIMARY KEY (HOLDINGID);

CREATE TABLE ACCOUNTPROFILEEJB
  (ADDRESS VARCHAR(250),
   PASSWD VARCHAR(250),
   USERID VARCHAR(250) NOT NULL,
   EMAIL VARCHAR(250),
   CREDITCARD VARCHAR(250),
   FULLNAME VARCHAR(250));
CREATE INDEX ACCOUNTP_TS on ACCOUNTPROFILEEJB (FULLNAME);
ALTER TABLE ACCOUNTPROFILEEJB
  ADD CONSTRAINT PK_ACCOUNTPROFILE2 PRIMARY KEY (USERID);

CREATE TABLE QUOTEEJB
  (LOW DECIMAL(14, 2),
   OPEN1 DECIMAL(14, 2),
   VOLUME DOUBLE PRECISION NOT NULL,
   PRICE DECIMAL(14, 2),
   HIGH DECIMAL(14, 2),
   COMPANYNAME VARCHAR(250),
   SYMBOL VARCHAR(250) NOT NULL,
   CHANGE1 DOUBLE PRECISION NOT NULL);
CREATE UNIQUE INDEX QUOTE_SYM ON QUOTEEJB(SYMBOL);
ALTER TABLE QUOTEEJB
  ADD CONSTRAINT PK_QUOTEEJB PRIMARY KEY (SYMBOL);

CREATE TABLE KEYGENEJB
  (KEYVAL INTEGER NOT NULL,
   KEYNAME VARCHAR(250) NOT NULL PRIMARY KEY);
CREATE INDEX KEYGENE_TS ON KEYGENEJB (KEYNAME);

INSERT INTO KEYGENEJB (KEYNAME,KEYVAL) VALUES ('account', 0);
INSERT INTO KEYGENEJB (KEYNAME,KEYVAL) VALUES ('holding', 0);
INSERT INTO KEYGENEJB (KEYNAME,KEYVAL) VALUES ('order', 0);

CREATE TABLE ACCOUNTEJB
  (CREATIONDATE TIMESTAMP,
   OPENBALANCE DECIMAL(14, 2),
   LOGOUTCOUNT INTEGER NOT NULL,
   BALANCE DECIMAL(14, 2),
   ACCOUNTID INTEGER NOT NULL,
   LASTLOGIN TIMESTAMP,
   LOGINCOUNT INTEGER NOT NULL,
   PROFILE_USERID VARCHAR(250));
CREATE INDEX ACCOUNTE_TS ON ACCOUNTEJB (PROFILE_USERID);
ALTER TABLE ACCOUNTEJB
  ADD CONSTRAINT PK_ACCOUNTEJB PRIMARY KEY (ACCOUNTID);

CREATE TABLE ORDEREJB
  (ORDERFEE DECIMAL(14, 2),
   COMPLETIONDATE TIMESTAMP,
   ORDERTYPE VARCHAR(250),
   ORDERSTATUS VARCHAR(250),
   PRICE DECIMAL(14, 2),
   QUANTITY DOUBLE PRECISION NOT NULL,
   OPENDATE TIMESTAMP,
   ORDERID INTEGER NOT NULL,
   ACCOUNT_ACCOUNTID INTEGER,
   QUOTE_SYMBOL VARCHAR(250),
   HOLDING_HOLDINGID INTEGER);
CREATE INDEX ORDER_TS ON ORDEREJB (HOLDING_HOLDINGID);
ALTER TABLE ORDEREJB
  ADD CONSTRAINT PK_ORDEREJB PRIMARY KEY (ORDERID);

CREATE INDEX ACCOUNT_USERID ON ACCOUNTEJB(PROFILE_USERID);
CREATE INDEX HOLDING_ACCOUNTID ON HOLDINGEJB(ACCOUNT_ACCOUNTID);
CREATE INDEX ORDER_ACCOUNTID ON ORDEREJB(ACCOUNT_ACCOUNTID);
CREATE INDEX ORDER_HOLDINGID ON ORDEREJB(HOLDING_HOLDINGID);
CREATE INDEX CLOSED_ORDERS ON ORDEREJB(ACCOUNT_ACCOUNTID,ORDERSTATUS);
