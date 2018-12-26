CREATE TABLE "RightInfo"(
  "Guid" VARCHAR(32) NOT NULL,
  "ParentGuid" VARCHAR(32),
  "SerialId" INTEGER,
  "RightName" VARCHAR(50) NOT NULL,
  "FunName" VARCHAR(50),
  "LibName" VARCHAR(50),
  "ImageIndex" INTEGER,
  "IsModal" INTEGER,
  "IsHide" INTEGER,
  "IsAdmin" INTEGER,
  PRIMARY KEY ("Guid")
);

CREATE TABLE "UserRole"(
  "Guid" VARCHAR(32) NOT NULL,
  "RoleCode" VARCHAR(50) NOT NULL,
  "RoleName" VARCHAR(200) NOT NULL,
  PRIMARY KEY ("Guid")
);

CREATE TABLE "UserDept"(
  "Guid" VARCHAR(32) NOT NULL,
  "DeptCode" VARCHAR(50) NOT NULL,
  "DeptName" VARCHAR(200) NOT NULL,
  PRIMARY KEY ("Guid")
);

CREATE TABLE "UserInfo"(
  "Guid" VARCHAR(32) NOT NULL,
  "UserCode" VARCHAR(50) NOT NULL,
  "UserName" VARCHAR(100) NOT NULL,
  "UserPass" VARCHAR(100),
  "RoleGuid" VARCHAR(32),
  "DeptGuid" VARCHAR(32),
  "CreateBy" VARCHAR(20),
  "CreateTime" DATETIME,
  "Remark" VARCHAR(255),
  "IsStop" INTEGER,
  PRIMARY KEY ("Guid")
);

CREATE TABLE "UserRight"(
  "Guid" VARCHAR(32) NOT NULL,
  "RoleGuid" VARCHAR(32) NOT NULL,
  "RightGuid" VARCHAR(32) NOT NULL,
  PRIMARY KEY ("Guid")
);

