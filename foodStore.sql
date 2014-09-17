
CREATE TABLE TBL_REPLY
(
	replyKey             INTEGER NOT NULL ,
	replyCont            VARCHAR2(20) NULL ,
	userkey              VARCHAR2(20) NULL ,
	userID               INTEGER NULL ,
	updatetime           DATE NULL ,
	star                 INTEGER NULL ,
	storeKey             INTEGER NOT NULL ,
	storeName            CHAR(18) NULL 
);



CREATE UNIQUE INDEX XPKµ¡±Û ON TBL_REPLY
(replyKey   ASC,storeKey   ASC);



ALTER TABLE TBL_REPLY
	ADD CONSTRAINT  XPKµ¡±Û PRIMARY KEY (replyKey,storeKey);



CREATE TABLE TBL_STORE
(
	storeKey             INTEGER NOT NULL ,
	storeName            VARCHAR2(20) NULL ,
	storeLat             INTEGER NULL ,
	storeLng             INTEGER NULL ,
	storedetail          VARCHAR2(20) NULL ,
	category             INTEGER NULL ,
	updatetime           DATE NULL ,
	categoryKey          INTEGER NOT NULL 
);



CREATE UNIQUE INDEX XPK¸ÀÁý ON TBL_STORE
(storeKey   ASC);



ALTER TABLE TBL_STORE
	ADD CONSTRAINT  XPK¸ÀÁý PRIMARY KEY (storeKey);



CREATE TABLE TBL_STORE_CATEGORY
(
	categoryKey          INTEGER NOT NULL ,
	category             VARCHAR2(20) NULL ,
	updatetime           DATE NULL 
);



CREATE UNIQUE INDEX XPK¸ÀÁýºÐ·ù ON TBL_STORE_CATEGORY
(categoryKey   ASC);



ALTER TABLE TBL_STORE_CATEGORY
	ADD CONSTRAINT  XPK¸ÀÁýºÐ·ù PRIMARY KEY (categoryKey);



CREATE TABLE TBL_STORE_MENU
(
	menuKey              INTEGER NOT NULL ,
	updatetime           DATE NULL ,
	menuName             VARCHAR2(20) NULL ,
	storeKey             INTEGER NOT NULL 
);



CREATE UNIQUE INDEX XPK¸ÀÁý¸Þ´º ON TBL_STORE_MENU
(menuKey   ASC,storeKey   ASC);



ALTER TABLE TBL_STORE_MENU
	ADD CONSTRAINT  XPK¸ÀÁý¸Þ´º PRIMARY KEY (menuKey,storeKey);



CREATE TABLE TBL_USER
(
	userKey              INTEGER NOT NULL ,
	userID               VARCHAR2(20) NULL ,
	userName             VARCHAR2(20) NULL ,
	birthDate            VARCHAR2(20) NULL ,
	sex                  VARCHAR2(20) NULL ,
	joindate             DATE NULL ,
	replyKey             INTEGER NOT NULL ,
	storeKey             INTEGER NOT NULL 
);



CREATE UNIQUE INDEX XPKÀ¯Àú ON TBL_USER
(userKey   ASC,replyKey   ASC,storeKey   ASC);



ALTER TABLE TBL_USER
	ADD CONSTRAINT  XPKÀ¯Àú PRIMARY KEY (userKey,replyKey,storeKey);



CREATE  VIEW VIEW_STORE_INFO ( category,storeName,menuName,star_avg,storeLat,storeLng,storedetail,userID,updatetime,replyCont ) 
	 AS  SELECT TBL_STORE.category,TBL_STORE.storeName,TBL_STORE_MENU.menuName,TBL_REPLY.star,TBL_STORE.storeLat,TBL_STORE.storeLng,TBL_STORE.storedetail,TBL_REPLY.userID,TBL_REPLY.updatetime,TBL_REPLY.replyCont
		FROM TBL_STORE,TBL_REPLY,TBL_STORE_MENU;



ALTER TABLE TBL_REPLY
	ADD (CONSTRAINT R_12 FOREIGN KEY (storeKey) REFERENCES TBL_STORE (storeKey));



ALTER TABLE TBL_STORE
	ADD (CONSTRAINT R_4 FOREIGN KEY (categoryKey) REFERENCES TBL_STORE_CATEGORY (categoryKey));



ALTER TABLE TBL_STORE_MENU
	ADD (CONSTRAINT R_7 FOREIGN KEY (storeKey) REFERENCES TBL_STORE (storeKey));



ALTER TABLE TBL_USER
	ADD (CONSTRAINT R_15 FOREIGN KEY (replyKey, storeKey) REFERENCES TBL_REPLY (replyKey, storeKey));



CREATE  TRIGGER tI_TBL_REPLY BEFORE INSERT ON TBL_REPLY for each row
-- ERwin Builtin Trigger
-- INSERT trigger on TBL_REPLY 
DECLARE NUMROWS INTEGER;
BEGIN
    /* ERwin Builtin Trigger */
    /* TBL_STORE  TBL_REPLY on child insert restrict */
    /* ERWIN_RELATION:CHECKSUM="0000f3ea", PARENT_OWNER="", PARENT_TABLE="TBL_STORE"
    CHILD_OWNER="", CHILD_TABLE="TBL_REPLY"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_12", FK_COLUMNS="storeKey" */
    SELECT count(*) INTO NUMROWS
      FROM TBL_STORE
      WHERE
        /* %JoinFKPK(:%New,TBL_STORE," = "," AND") */
        :new.storeKey = TBL_STORE.storeKey;
    IF (
      /* %NotnullFK(:%New," IS NOT NULL AND") */
      
      NUMROWS = 0
    )
    THEN
      raise_application_error(
        -20002,
        'Cannot insert TBL_REPLY because TBL_STORE does not exist.'
      );
    END IF;


-- ERwin Builtin Trigger
END;
/

CREATE  TRIGGER  tD_TBL_REPLY AFTER DELETE ON TBL_REPLY for each row
-- ERwin Builtin Trigger
-- DELETE trigger on TBL_REPLY 
DECLARE NUMROWS INTEGER;
BEGIN
    /* ERwin Builtin Trigger */
    /* TBL_REPLY  TBL_USER on parent delete restrict */
    /* ERWIN_RELATION:CHECKSUM="0000e712", PARENT_OWNER="", PARENT_TABLE="TBL_REPLY"
    CHILD_OWNER="", CHILD_TABLE="TBL_USER"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_15", FK_COLUMNS="replyKey""storeKey" */
    SELECT count(*) INTO NUMROWS
      FROM TBL_USER
      WHERE
        /*  %JoinFKPK(TBL_USER,:%Old," = "," AND") */
        TBL_USER.replyKey = :old.replyKey AND
        TBL_USER.storeKey = :old.storeKey;
    IF (NUMROWS > 0)
    THEN
      raise_application_error(
        -20001,
        'Cannot delete TBL_REPLY because TBL_USER exists.'
      );
    END IF;


-- ERwin Builtin Trigger
END;
/

CREATE  TRIGGER tU_TBL_REPLY AFTER UPDATE ON TBL_REPLY for each row
-- ERwin Builtin Trigger
-- UPDATE trigger on TBL_REPLY 
DECLARE NUMROWS INTEGER;
BEGIN
  /* ERwin Builtin Trigger */
  /* TBL_REPLY  TBL_USER on parent update restrict */
  /* ERWIN_RELATION:CHECKSUM="00022d7d", PARENT_OWNER="", PARENT_TABLE="TBL_REPLY"
    CHILD_OWNER="", CHILD_TABLE="TBL_USER"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_15", FK_COLUMNS="replyKey""storeKey" */
  IF
    /* %JoinPKPK(:%Old,:%New," <> "," OR ") */
    :old.replyKey <> :new.replyKey OR 
    :old.storeKey <> :new.storeKey
  THEN
    SELECT count(*) INTO NUMROWS
      FROM TBL_USER
      WHERE
        /*  %JoinFKPK(TBL_USER,:%Old," = "," AND") */
        TBL_USER.replyKey = :old.replyKey AND
        TBL_USER.storeKey = :old.storeKey;
    IF (NUMROWS > 0)
    THEN 
      raise_application_error(
        -20005,
        'Cannot update TBL_REPLY because TBL_USER exists.'
      );
    END IF;
  END IF;

  /* ERwin Builtin Trigger */
  /* TBL_STORE  TBL_REPLY on child update restrict */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="TBL_STORE"
    CHILD_OWNER="", CHILD_TABLE="TBL_REPLY"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_12", FK_COLUMNS="storeKey" */
  SELECT count(*) INTO NUMROWS
    FROM TBL_STORE
    WHERE
      /* %JoinFKPK(:%New,TBL_STORE," = "," AND") */
      :new.storeKey = TBL_STORE.storeKey;
  IF (
    /* %NotnullFK(:%New," IS NOT NULL AND") */
    
    NUMROWS = 0
  )
  THEN
    raise_application_error(
      -20007,
      'Cannot update TBL_REPLY because TBL_STORE does not exist.'
    );
  END IF;


-- ERwin Builtin Trigger
END;
/


CREATE  TRIGGER tI_TBL_STORE BEFORE INSERT ON TBL_STORE for each row
-- ERwin Builtin Trigger
-- INSERT trigger on TBL_STORE 
DECLARE NUMROWS INTEGER;
BEGIN
    /* ERwin Builtin Trigger */
    /* TBL_STORE_CATEGORY  TBL_STORE on child insert restrict */
    /* ERWIN_RELATION:CHECKSUM="000107eb", PARENT_OWNER="", PARENT_TABLE="TBL_STORE_CATEGORY"
    CHILD_OWNER="", CHILD_TABLE="TBL_STORE"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_4", FK_COLUMNS="categoryKey" */
    SELECT count(*) INTO NUMROWS
      FROM TBL_STORE_CATEGORY
      WHERE
        /* %JoinFKPK(:%New,TBL_STORE_CATEGORY," = "," AND") */
        :new.categoryKey = TBL_STORE_CATEGORY.categoryKey;
    IF (
      /* %NotnullFK(:%New," IS NOT NULL AND") */
      
      NUMROWS = 0
    )
    THEN
      raise_application_error(
        -20002,
        'Cannot insert TBL_STORE because TBL_STORE_CATEGORY does not exist.'
      );
    END IF;


-- ERwin Builtin Trigger
END;
/

CREATE  TRIGGER  tD_TBL_STORE AFTER DELETE ON TBL_STORE for each row
-- ERwin Builtin Trigger
-- DELETE trigger on TBL_STORE 
DECLARE NUMROWS INTEGER;
BEGIN
    /* ERwin Builtin Trigger */
    /* TBL_STORE  TBL_STORE_MENU on parent delete restrict */
    /* ERWIN_RELATION:CHECKSUM="0001da75", PARENT_OWNER="", PARENT_TABLE="TBL_STORE"
    CHILD_OWNER="", CHILD_TABLE="TBL_STORE_MENU"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_7", FK_COLUMNS="storeKey" */
    SELECT count(*) INTO NUMROWS
      FROM TBL_STORE_MENU
      WHERE
        /*  %JoinFKPK(TBL_STORE_MENU,:%Old," = "," AND") */
        TBL_STORE_MENU.storeKey = :old.storeKey;
    IF (NUMROWS > 0)
    THEN
      raise_application_error(
        -20001,
        'Cannot delete TBL_STORE because TBL_STORE_MENU exists.'
      );
    END IF;

    /* ERwin Builtin Trigger */
    /* TBL_STORE  TBL_REPLY on parent delete restrict */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="TBL_STORE"
    CHILD_OWNER="", CHILD_TABLE="TBL_REPLY"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_12", FK_COLUMNS="storeKey" */
    SELECT count(*) INTO NUMROWS
      FROM TBL_REPLY
      WHERE
        /*  %JoinFKPK(TBL_REPLY,:%Old," = "," AND") */
        TBL_REPLY.storeKey = :old.storeKey;
    IF (NUMROWS > 0)
    THEN
      raise_application_error(
        -20001,
        'Cannot delete TBL_STORE because TBL_REPLY exists.'
      );
    END IF;


-- ERwin Builtin Trigger
END;
/

CREATE  TRIGGER tU_TBL_STORE AFTER UPDATE ON TBL_STORE for each row
-- ERwin Builtin Trigger
-- UPDATE trigger on TBL_STORE 
DECLARE NUMROWS INTEGER;
BEGIN
  /* ERwin Builtin Trigger */
  /* TBL_STORE  TBL_STORE_MENU on parent update restrict */
  /* ERWIN_RELATION:CHECKSUM="000347dc", PARENT_OWNER="", PARENT_TABLE="TBL_STORE"
    CHILD_OWNER="", CHILD_TABLE="TBL_STORE_MENU"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_7", FK_COLUMNS="storeKey" */
  IF
    /* %JoinPKPK(:%Old,:%New," <> "," OR ") */
    :old.storeKey <> :new.storeKey
  THEN
    SELECT count(*) INTO NUMROWS
      FROM TBL_STORE_MENU
      WHERE
        /*  %JoinFKPK(TBL_STORE_MENU,:%Old," = "," AND") */
        TBL_STORE_MENU.storeKey = :old.storeKey;
    IF (NUMROWS > 0)
    THEN 
      raise_application_error(
        -20005,
        'Cannot update TBL_STORE because TBL_STORE_MENU exists.'
      );
    END IF;
  END IF;

  /* ERwin Builtin Trigger */
  /* TBL_STORE  TBL_REPLY on parent update restrict */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="TBL_STORE"
    CHILD_OWNER="", CHILD_TABLE="TBL_REPLY"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_12", FK_COLUMNS="storeKey" */
  IF
    /* %JoinPKPK(:%Old,:%New," <> "," OR ") */
    :old.storeKey <> :new.storeKey
  THEN
    SELECT count(*) INTO NUMROWS
      FROM TBL_REPLY
      WHERE
        /*  %JoinFKPK(TBL_REPLY,:%Old," = "," AND") */
        TBL_REPLY.storeKey = :old.storeKey;
    IF (NUMROWS > 0)
    THEN 
      raise_application_error(
        -20005,
        'Cannot update TBL_STORE because TBL_REPLY exists.'
      );
    END IF;
  END IF;

  /* ERwin Builtin Trigger */
  /* TBL_STORE_CATEGORY  TBL_STORE on child update restrict */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="TBL_STORE_CATEGORY"
    CHILD_OWNER="", CHILD_TABLE="TBL_STORE"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_4", FK_COLUMNS="categoryKey" */
  SELECT count(*) INTO NUMROWS
    FROM TBL_STORE_CATEGORY
    WHERE
      /* %JoinFKPK(:%New,TBL_STORE_CATEGORY," = "," AND") */
      :new.categoryKey = TBL_STORE_CATEGORY.categoryKey;
  IF (
    /* %NotnullFK(:%New," IS NOT NULL AND") */
    
    NUMROWS = 0
  )
  THEN
    raise_application_error(
      -20007,
      'Cannot update TBL_STORE because TBL_STORE_CATEGORY does not exist.'
    );
  END IF;


-- ERwin Builtin Trigger
END;
/


CREATE  TRIGGER  tD_TBL_STORE_CATEGORY AFTER DELETE ON TBL_STORE_CATEGORY for each row
-- ERwin Builtin Trigger
-- DELETE trigger on TBL_STORE_CATEGORY 
DECLARE NUMROWS INTEGER;
BEGIN
    /* ERwin Builtin Trigger */
    /* TBL_STORE_CATEGORY  TBL_STORE on parent delete restrict */
    /* ERWIN_RELATION:CHECKSUM="0000eab1", PARENT_OWNER="", PARENT_TABLE="TBL_STORE_CATEGORY"
    CHILD_OWNER="", CHILD_TABLE="TBL_STORE"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_4", FK_COLUMNS="categoryKey" */
    SELECT count(*) INTO NUMROWS
      FROM TBL_STORE
      WHERE
        /*  %JoinFKPK(TBL_STORE,:%Old," = "," AND") */
        TBL_STORE.categoryKey = :old.categoryKey;
    IF (NUMROWS > 0)
    THEN
      raise_application_error(
        -20001,
        'Cannot delete TBL_STORE_CATEGORY because TBL_STORE exists.'
      );
    END IF;


-- ERwin Builtin Trigger
END;
/

CREATE  TRIGGER tU_TBL_STORE_CATEGORY AFTER UPDATE ON TBL_STORE_CATEGORY for each row
-- ERwin Builtin Trigger
-- UPDATE trigger on TBL_STORE_CATEGORY 
DECLARE NUMROWS INTEGER;
BEGIN
  /* ERwin Builtin Trigger */
  /* TBL_STORE_CATEGORY  TBL_STORE on parent update restrict */
  /* ERWIN_RELATION:CHECKSUM="00010dfe", PARENT_OWNER="", PARENT_TABLE="TBL_STORE_CATEGORY"
    CHILD_OWNER="", CHILD_TABLE="TBL_STORE"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_4", FK_COLUMNS="categoryKey" */
  IF
    /* %JoinPKPK(:%Old,:%New," <> "," OR ") */
    :old.categoryKey <> :new.categoryKey
  THEN
    SELECT count(*) INTO NUMROWS
      FROM TBL_STORE
      WHERE
        /*  %JoinFKPK(TBL_STORE,:%Old," = "," AND") */
        TBL_STORE.categoryKey = :old.categoryKey;
    IF (NUMROWS > 0)
    THEN 
      raise_application_error(
        -20005,
        'Cannot update TBL_STORE_CATEGORY because TBL_STORE exists.'
      );
    END IF;
  END IF;


-- ERwin Builtin Trigger
END;
/


CREATE  TRIGGER tI_TBL_STORE_MENU BEFORE INSERT ON TBL_STORE_MENU for each row
-- ERwin Builtin Trigger
-- INSERT trigger on TBL_STORE_MENU 
DECLARE NUMROWS INTEGER;
BEGIN
    /* ERwin Builtin Trigger */
    /* TBL_STORE  TBL_STORE_MENU on child insert restrict */
    /* ERWIN_RELATION:CHECKSUM="0000f6cb", PARENT_OWNER="", PARENT_TABLE="TBL_STORE"
    CHILD_OWNER="", CHILD_TABLE="TBL_STORE_MENU"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_7", FK_COLUMNS="storeKey" */
    SELECT count(*) INTO NUMROWS
      FROM TBL_STORE
      WHERE
        /* %JoinFKPK(:%New,TBL_STORE," = "," AND") */
        :new.storeKey = TBL_STORE.storeKey;
    IF (
      /* %NotnullFK(:%New," IS NOT NULL AND") */
      
      NUMROWS = 0
    )
    THEN
      raise_application_error(
        -20002,
        'Cannot insert TBL_STORE_MENU because TBL_STORE does not exist.'
      );
    END IF;


-- ERwin Builtin Trigger
END;
/

CREATE  TRIGGER tU_TBL_STORE_MENU AFTER UPDATE ON TBL_STORE_MENU for each row
-- ERwin Builtin Trigger
-- UPDATE trigger on TBL_STORE_MENU 
DECLARE NUMROWS INTEGER;
BEGIN
  /* ERwin Builtin Trigger */
  /* TBL_STORE  TBL_STORE_MENU on child update restrict */
  /* ERWIN_RELATION:CHECKSUM="0000f4e2", PARENT_OWNER="", PARENT_TABLE="TBL_STORE"
    CHILD_OWNER="", CHILD_TABLE="TBL_STORE_MENU"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_7", FK_COLUMNS="storeKey" */
  SELECT count(*) INTO NUMROWS
    FROM TBL_STORE
    WHERE
      /* %JoinFKPK(:%New,TBL_STORE," = "," AND") */
      :new.storeKey = TBL_STORE.storeKey;
  IF (
    /* %NotnullFK(:%New," IS NOT NULL AND") */
    
    NUMROWS = 0
  )
  THEN
    raise_application_error(
      -20007,
      'Cannot update TBL_STORE_MENU because TBL_STORE does not exist.'
    );
  END IF;


-- ERwin Builtin Trigger
END;
/


CREATE  TRIGGER tI_TBL_USER BEFORE INSERT ON TBL_USER for each row
-- ERwin Builtin Trigger
-- INSERT trigger on TBL_USER 
DECLARE NUMROWS INTEGER;
BEGIN
    /* ERwin Builtin Trigger */
    /* TBL_REPLY  TBL_USER on child insert restrict */
    /* ERWIN_RELATION:CHECKSUM="0000fd28", PARENT_OWNER="", PARENT_TABLE="TBL_REPLY"
    CHILD_OWNER="", CHILD_TABLE="TBL_USER"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_15", FK_COLUMNS="replyKey""storeKey" */
    SELECT count(*) INTO NUMROWS
      FROM TBL_REPLY
      WHERE
        /* %JoinFKPK(:%New,TBL_REPLY," = "," AND") */
        :new.replyKey = TBL_REPLY.replyKey AND
        :new.storeKey = TBL_REPLY.storeKey;
    IF (
      /* %NotnullFK(:%New," IS NOT NULL AND") */
      
      NUMROWS = 0
    )
    THEN
      raise_application_error(
        -20002,
        'Cannot insert TBL_USER because TBL_REPLY does not exist.'
      );
    END IF;


-- ERwin Builtin Trigger
END;
/

CREATE  TRIGGER tU_TBL_USER AFTER UPDATE ON TBL_USER for each row
-- ERwin Builtin Trigger
-- UPDATE trigger on TBL_USER 
DECLARE NUMROWS INTEGER;
BEGIN
  /* ERwin Builtin Trigger */
  /* TBL_REPLY  TBL_USER on child update restrict */
  /* ERWIN_RELATION:CHECKSUM="000101f0", PARENT_OWNER="", PARENT_TABLE="TBL_REPLY"
    CHILD_OWNER="", CHILD_TABLE="TBL_USER"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_15", FK_COLUMNS="replyKey""storeKey" */
  SELECT count(*) INTO NUMROWS
    FROM TBL_REPLY
    WHERE
      /* %JoinFKPK(:%New,TBL_REPLY," = "," AND") */
      :new.replyKey = TBL_REPLY.replyKey AND
      :new.storeKey = TBL_REPLY.storeKey;
  IF (
    /* %NotnullFK(:%New," IS NOT NULL AND") */
    
    NUMROWS = 0
  )
  THEN
    raise_application_error(
      -20007,
      'Cannot update TBL_USER because TBL_REPLY does not exist.'
    );
  END IF;


-- ERwin Builtin Trigger
END;
/

