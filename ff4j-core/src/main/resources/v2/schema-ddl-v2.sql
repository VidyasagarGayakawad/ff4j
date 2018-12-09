CREATE TABLE FF4J_ROLE ( 
 NAME 	        VARCHAR(100) NOT NULL,
 DESCRIPTION 	VARCHAR(255),
 PRIMARY KEY (NAME)
);

CREATE TABLE FF4J_ROLE_PERM ( 
 ROLE_NAME 	 VARCHAR(100) NOT NULL,
 PERMISSION  VARCHAR(100) NOT NULL,
 PRIMARY KEY (ROLE_NAME,PERMISSION),
 FOREIGN KEY (ROLE_NAME) REFERENCES FF4J_ROLE(NAME)
);

CREATE TABLE FF4J_USER ( 
 UID 			VARCHAR(100) NOT NULL,
 CREATED 		DATETIME,
 LASTMODIFIED 	DATETIME,
 OWNER 			VARCHAR(100),
 DESCRIPTION 	VARCHAR(255),
 PASSWORD 		VARCHAR(255) NOT NULL,
 LASTNAME 		VARCHAR(100),
 FIRSTNAME 		VARCHAR(100),
 PRIMARY KEY (UID)
);

CREATE TABLE FF4J_USER_PERM ( 
 USER_UID 		VARCHAR(100) NOT NULL,
 PERMISSION 	VARCHAR(100) NOT NULL,
 PRIMARY KEY (USER_UID,PERMISSION),
 FOREIGN KEY (USER_UID) REFERENCES FF4J_USER(UID)
);

CREATE TABLE FF4J_USER_ROLE_A ( 
 REF_USER 	VARCHAR(100) NOT NULL,
 REF_ROLE 	VARCHAR(100) NOT NULL,
 PRIMARY KEY (REF_USER,REF_ROLE),
 FOREIGN KEY (REF_USER) REFERENCES FF4J_USER(UID),
 FOREIGN KEY (REF_ROLE) REFERENCES FF4J_ROLE(NAME)
);

CREATE TABLE FF4J_FEATURE ( 
 UID 			VARCHAR(100) NOT NULL,
 CREATED 		DATETIME,
 LASTMODIFIED 	DATETIME,
 OWNER 			VARCHAR(100),
 DESCRIPTION 	VARCHAR(255),
 ENABLE 		INTEGER NOT NULL,
 GROUPNAME 		VARCHAR(100),
 PRIMARY KEY (UID)
);
CREATE TABLE FF4J_FEATURE_PROP ( 
 UID 	        VARCHAR(100) NOT NULL,
 CLASSNAME 	    VARCHAR(255) NOT NULL,
 CREATED 	    DATETIME,
 LASTMODIFIED 	DATETIME,
 OWNER 	        VARCHAR(100),
 VAL 	        VARCHAR(255) NOT NULL,
 FIXEDVALUES 	VARCHAR(1000),
 FEAT_UID 	VARCHAR(100) NOT NULL,
 PRIMARY KEY (UID,FEAT_UID),
 FOREIGN KEY (FEAT_UID) REFERENCES FF4J_FEATURE(UID)
);
CREATE TABLE FF4J_FEATURE_PERM ( 
 FEAT_UID 		VARCHAR(100) NOT NULL,
 PERMISSION 	VARCHAR(100) NOT NULL,
 USERS 			VARCHAR(1000),
 ROLES 			VARCHAR(1000),
 PRIMARY KEY (FEAT_UID,PERMISSION),
 FOREIGN KEY (FEAT_UID) REFERENCES FF4J_FEATURE(UID)
);
CREATE TABLE FF4J_FEATURE_STRAT ( 
 FEAT_UID 		VARCHAR(100) NOT NULL,
 TOGGLE_CLASS 	VARCHAR(200) NOT NULL,
 PRIMARY KEY (FEAT_UID,TOGGLE_CLASS),
 FOREIGN KEY (FEAT_UID) REFERENCES FF4J_FEATURE(UID)
);
CREATE TABLE FF4J_FEATURE_STRAT_P ( 
 UID 			VARCHAR(100) NOT NULL,
 CLASSNAME 		VARCHAR(255) NOT NULL,
 VAL 			VARCHAR(255) NOT NULL,
 FIXEDVALUES 	VARCHAR(1000),
 STRAT_FEAT_UID VARCHAR(100) NOT NULL,
 STRAT_CLASS 	VARCHAR(200) NOT NULL,
 PRIMARY KEY (UID,STRAT_CLASS,STRAT_FEAT_UID),
 FOREIGN KEY (STRAT_FEAT_UID,STRAT_CLASS) REFERENCES FF4J_FEATURE_STRAT(FEAT_UID,TOGGLE_CLASS)
);
CREATE TABLE FF4J_PROPERTY ( 
 UID 			VARCHAR(100) NOT NULL,
 CREATED 		DATETIME,
 LASTMODIFIED 	DATETIME,
 OWNER 			VARCHAR(100),
 DESCRIPTION 	VARCHAR(255),
 CLASSNAME 		VARCHAR(255) NOT NULL,
 READONLY 		INTEGER NOT NULL,
 VAL 			VARCHAR(255) NOT NULL,
 FIXEDVALUES 	VARCHAR(1000),
 PRIMARY KEY (UID)
);

CREATE TABLE FF4J_AUDIT_TRAIL ( 
 UID 			VARCHAR(100) NOT NULL,
 CREATED 		DATETIME,
 LASTMODIFIED 	DATETIME,
 OWNER 			VARCHAR(100),
 DESCRIPTION 	VARCHAR(255),
 EVT_TIME 		TIMESTAMP NOT NULL,
 EVT_TYPE 		VARCHAR(30) NOT NULL,
 NAME 			VARCHAR(30) NOT NULL,
 ACTION 		VARCHAR(30) NOT NULL,
 HOSTNAME 		VARCHAR(100),
 SOURCE 		VARCHAR(100),
 DURATION 		INTEGER NOT NULL,
 EVT_VALUE 		VARCHAR(100) NOT NULL,
 EVT_KEYS 		VARCHAR(1000) NOT NULL,
 PRIMARY KEY (UID,EVT_TIME)
);
CREATE TABLE FF4J_FEATURE_USAGE ( 
 UID 			VARCHAR(100) NOT NULL,
 CREATED 		DATETIME,
 LASTMODIFIED 	DATETIME,
 OWNER 			VARCHAR(100),
 DESCRIPTION 	VARCHAR(255),
 EVT_TIME 		TIMESTAMP NOT NULL,
 EVT_TYPE 		VARCHAR(30) NOT NULL,
 NAME 			VARCHAR(30) NOT NULL,
 ACTION 		VARCHAR(30) NOT NULL,
 HOSTNAME 		VARCHAR(100),
 SOURCE 		VARCHAR(100),
 DURATION 		INTEGER NOT NULL,
 EVT_VALUE 		VARCHAR(100) NOT NULL,
 EVT_KEYS 		VARCHAR(1000) NOT NULL,
 PRIMARY KEY (UID,EVT_TIME)
);



