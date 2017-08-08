CREATE TABLE IF NOT EXISTS "T_home" (
"userid" INTEGER NOT NULL,
"statusid" INTEGER NOT NULL,
"status" TEXT,
"createtime" TEXT DEFAULT (datetime('now','localtime')),
PRIMARY KEY("userid","statusid")
)
