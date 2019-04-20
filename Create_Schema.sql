CREATE TABLE IF NOT EXISTS ROOM
(
  Capacity INT NOT NULL,
  RoomID INT NOT NULL,
  PRIMARY KEY (RoomID)
);

CREATE TABLE IF NOT EXISTS TRAINER
(
  Name INT NOT NULL,
  Address INT NOT NULL,
  Email INT NOT NULL,
  Phone INT NOT NULL,
  TrainerID INT NOT NULL,
  PRIMARY KEY (TrainerID)
);

CREATE TABLE IF NOT EXISTS ROOM_CType
(
  CType INT NOT NULL,
  RoomID INT NOT NULL,
  PRIMARY KEY (CType, RoomID),
  FOREIGN KEY (RoomID) REFERENCES ROOM(RoomID)
);

CREATE TABLE IF NOT EXISTS TRAINER_Certification
(
  Certification INT NOT NULL,
  TrainerID INT NOT NULL,
  PRIMARY KEY (Certification, TrainerID),
  FOREIGN KEY (TrainerID) REFERENCES TRAINER(TrainerID)
);

CREATE TABLE IF NOT EXISTS MEMBER
(
  Address INT NOT NULL,
  Email INT NOT NULL,
  Phone INT NOT NULL,
  Name INT NOT NULL,
  MemberID INT NOT NULL,
  Credits INT NOT NULL,
  UnlimitedPlanExpiration INT NOT NULL,
  TrainerID INT NOT NULL,
  PRIMARY KEY (MemberID),
  FOREIGN KEY (TrainerID) REFERENCES TRAINER(TrainerID)
);

CREATE TABLE IF NOT EXISTS CLASS
(
  Time TIME NOT NULL,
  CNumber INT NOT NULL,
  Cost INT NOT NULL,
  CType INT NOT NULL,
  Discount_Cost INT NOT NULL,
  TrainerID INT NOT NULL,
  RoomID INT NOT NULL,
  PRIMARY KEY (CNumber),
  FOREIGN KEY (TrainerID) REFERENCES TRAINER(TrainerID),
  FOREIGN KEY (RoomID) REFERENCES ROOM(RoomID)
);

CREATE TABLE IF NOT EXISTS ATTENDS
(
  MemberID INT NOT NULL,
  CNumber INT NOT NULL,
  PRIMARY KEY (MemberID, CNumber),
  FOREIGN KEY (MemberID) REFERENCES MEMBER(MemberID),
  FOREIGN KEY (CNumber) REFERENCES CLASS(CNumber)
);

CREATE TABLE IF NOT EXISTS MEMBER_Waiver
(
  Waiver INT NOT NULL,
  MemberID INT NOT NULL,
  PRIMARY KEY (Waiver, MemberID),
  FOREIGN KEY (MemberID) REFERENCES MEMBER(MemberID)
);

DELIMITER $
CREATE PROCEDURE `check_credits`(IN InMemberID INT, IN InCnumber INT)
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
CREATE PROCEDURE `check_class`(IN InCNumber INT, IN InTime TIME, IN InCost INT, IN InCType INT, IN InDiscount_Cost INT, IN InTrainerID INT, IN InRoomID INT)
BEGIN
	IF ((SELECT Time.start_at FROM CLASS WHERE TrainerID = InTrainerID) > InTime.start_at AND (SELECT Time.end_at FROM CLASS WHERE TrainerID = InTrainerID) < InTime.start_at) OR ((SELECT Time.start_at FROM CLASS WHERE TrainerID = InTrainerID) > InTime.send_at AND (SELECT Time.end_at FROM CLASS WHERE TrainerID = InTrainerID) < InTime.end_at)
		THEN SIGNAL SQLSTATE '45003'
			SET MESSAGE_TEXT = 'Check constraint on Class Time failed';
	END IF;
END $

DELIMITER $	
CREATE TRIGGER `check_class_insert` BEFORE INSERT ON `CLASS`
FOR EACH ROW 
BEGIN 
	CALL check_class(new.CNumber, new.Time, new.Cost, new.CType, new.Discount_Cost, new.TrainerID, new.RoomID);
END $

DELIMITER $	
CREATE TRIGGER `check_class_update` BEFORE UPDATE ON `CLASS`
FOR EACH ROW 
BEGIN 
	CALL check_class(new.CNumber, new.Time, new.Cost, new.CType, new.Discount_Cost, new.TrainerID, new.RoomID);
END $
