CREATE TABLE IF NOT EXISTS ROOM
(
  Capacity TINYINT NOT NULL,
  RoomID TINYINT NOT NULL,
  PRIMARY KEY (RoomID)
);

CREATE TABLE IF NOT EXISTS TRAINER
(
  Name VARCHAR(40) NOT NULL,
  Address TINYTEXT NOT NULL,
  Email VARCHAR(40) NOT NULL,
  Phone VARCHAR(20) NOT NULL,
  TrainerID SMALLINT NOT NULL,
  PRIMARY KEY (TrainerID)
);

CREATE TABLE IF NOT EXISTS CLASS
(
  Time_Start DATETIME NOT NULL,
  Time_End DATETIME NOT NULL,
  CNumber INT NOT NULL,
  Cost TINYINT NOT NULL,
  CType ENUM('yoga', 'aerobics', 'weightlifting'),
  Discount_Cost TINYINT NOT NULL,
  TrainerID SMALLINT NOT NULL,
  RoomID TINYINT NOT NULL,
  PRIMARY KEY (CNumber),
  FOREIGN KEY (TrainerID) REFERENCES TRAINER(TrainerID),
  FOREIGN KEY (RoomID) REFERENCES ROOM(RoomID)
);

CREATE TABLE IF NOT EXISTS ROOM_CType
(
  CType ENUM('yoga', 'aerobics', 'weightlifting'),
  RoomID TINYINT NOT NULL,
  PRIMARY KEY (CType, RoomID),
  FOREIGN KEY (RoomID) REFERENCES ROOM(RoomID)
);

CREATE TABLE IF NOT EXISTS TRAINER_Certification
(
  Certification ENUM('yoga', 'aerobics', 'weightlifting'),
  TrainerID SMALLINT NOT NULL,
  PRIMARY KEY (Certification, TrainerID),
  FOREIGN KEY (TrainerID) REFERENCES TRAINER(TrainerID)
);
CREATE TABLE IF NOT EXISTS MEMBER
(
  Address TINYTEXT NOT NULL,
  Email VARCHAR(40) NOT NULL,
  Phone VARCHAR(20) NOT NULL,
  Name VARCHAR(40) NOT NULL,
  MemberID SMALLINT NOT NULL,
  Credits SMALLINT NOT NULL,
  UnlimitedPlanExpiration DATETIME NOT NULL,
  TrainerID SMALLINT NOT NULL,
  PRIMARY KEY (MemberID),
  FOREIGN KEY (TrainerID) REFERENCES TRAINER(TrainerID)
);

CREATE TABLE IF NOT EXISTS ATTENDS
(
  MemberID SMALLINT NOT NULL,
  CNumber INT NOT NULL,
  PRIMARY KEY (MemberID, CNumber),
  FOREIGN KEY (MemberID) REFERENCES MEMBER(MemberID),
  FOREIGN KEY (CNumber) REFERENCES CLASS(CNumber)
);

CREATE TABLE IF NOT EXISTS MEMBER_Waiver
(
  Waiver varchar(100) NOT NULL,
  MemberID SMALLINT NOT NULL,
  PRIMARY KEY (Waiver, MemberID),
  FOREIGN KEY (MemberID) REFERENCES MEMBER(MemberID)
);

DELIMITER $
CREATE PROCEDURE `check_credits`(IN InMemberID SMALLINT, IN InCnumber INT)
BEGIN
	IF ((SELECT Discount_Cost FROM CLASS WHERE Cnumber = InCnumber) IS NOT NULL) AND (SELECT Credits FROM MEMBER WHERE MemberID = InMemberID) < (SELECT Discount_cost FROM CLASS WHERE Cnumber = InCnumber)
		THEN SIGNAL SQLSTATE '45001'
			SET MESSAGE_TEXT = 'Check constraint on Discount_cost failed';
	END IF;
    
	IF (SELECT Credits FROM MEMBER WHERE MemberID = InMemberID) < (SELECT Cost FROM CLASS WHERE Cnumber = InCnumber)
		THEN SIGNAL SQLSTATE '45002'
			SET MESSAGE_TEXT = 'Check constraint on Cost failed';
	END IF;
END $

DELIMITER $	
CREATE TRIGGER `check_attends_insert` BEFORE INSERT ON `ATTENDS`
FOR EACH ROW 
BEGIN 
	CALL check_credits(new.MemberID, new.Cnumber);
END $

DELIMITER $	
CREATE TRIGGER `check_attends_update` BEFORE UPDATE ON `ATTENDS`
FOR EACH ROW 
BEGIN 
	CALL check_credits(new.MemberID, new.Cnumber);
END $

DELIMITER $
CREATE PROCEDURE `check_class`(IN InCNumber INT, IN InTime_Start DATETIME, IN InTime_End DATETIME, IN InCost TINYINT, IN InCType ENUM('yoga', 'aerobics', 'weightlifting'), IN InDiscount_Cost TINYINT, IN InTrainerID SMALLINT, IN InRoomID TINYINT)
BEGIN
	IF ((SELECT Time_Start FROM CLASS WHERE TrainerID = InTrainerID) > InTime_Start AND (SELECT Time_End FROM CLASS WHERE TrainerID = InTrainerID) < InTime_Start) OR ((SELECT Time_Start FROM CLASS WHERE TrainerID = InTrainerID) > InTime_End AND (SELECT Time_End FROM CLASS WHERE TrainerID = InTrainerID) < InTime_End)
		THEN SIGNAL SQLSTATE '45003'
			SET MESSAGE_TEXT = 'Check constraint on Class Time failed';
	END IF;
END $

DELIMITER $	
CREATE TRIGGER `check_class_insert` BEFORE INSERT ON `CLASS`
FOR EACH ROW 
BEGIN 
	CALL check_class(new.CNumber, new.Time_Start, new.Time_End, new.Cost, new.CType, new.Discount_Cost, new.TrainerID, new.RoomID);
END $

DELIMITER $	
CREATE TRIGGER `check_class_update` BEFORE UPDATE ON `CLASS`
FOR EACH ROW 
BEGIN 
	CALL check_class(new.CNumber, new.Time_Start, new.Time_End, new.Cost, new.CType, new.Discount_Cost, new.TrainerID, new.RoomID);
END $