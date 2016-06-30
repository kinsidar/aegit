strSQL="CREATE TABLE [_tblChart] ([id] Long,[VersionApp] Text (255),[VersionData] Text (255),[EnterDate] DateTime,[FLD01] Long,[FLD02] Long,[FLD03] Long,[FLD04] Long,[FLD05] Long,[FLD06] Long,[FLD07] Long,[FLD08] Long,[FLD09] Long,[FLD10] Long,[FLD11] Long,[FLD12] Long,[FLD13] Long,[FLD14] Long,[FLD15] Long,[FLD16] Long,[FLD17] Long,[FLD18] Long,[FLD19] Long,[FLD20] Long,[FLD21] Long,[FLD22] Long,[FLD23] Long,[FLD24] Long,[FLD25] Long,[FLD26] Long,[FLD27] Long,[FLD28] Long,[FLD29] Long,[FLD30] Long,[FLD31] Long,[FLD32] Long,[FLD33] Long,[FLD34] Long,[FLD35] Long,[FLD36] Long,[FLD37] Long,[FLD38] Long,[FLD39] Long,[FLD40] Long,[FLD41] Long,[FLD42] Long,[FLD43] Long,[FLD44] Long,[FLD45] Long,[FLD46] Long,[FLD47] Long,[FLD48] Long,[FLD49] Long,[FLD50] Long,[FLD51] Long,[FLD52] Long,[FLD53] Long,[FLD54] Long,[FLD55] Long,[FLD56] Long,[FLD57] Long,[FLD58] Long,[FLD59] Long,[FLD60] Long,[FLD61] Long,[FLD62] Long,[FLD63] Long,[FLD64] Long,[FLD65] "
strSQL=strSQL & "Long,[FLD66] Long,[FLD67] Long,[FLD68] Long,[FLD69] Long,[FLD70] Long )"
strSQL="CREATE UNIQUE INDEX [PrimaryKey] ON [_tblChart] ([id]) WITH PRIMARY DISALLOW NULL"
strSQL="CREATE TABLE [_tblPersist] ([id] Counter,[persist] Text (255) )"
strSQL="CREATE INDEX [id] ON [_tblPersist] ([persist])"
strSQL="CREATE UNIQUE INDEX [PrimaryKey] ON [_tblPersist] ([id]) WITH PRIMARY DISALLOW NULL"
strSQL="CREATE TABLE [_tlkpChart] ([id] Counter,[ChartNum] Text (255),[ChartDesc] Text (255),[ChartTitle] Text (255) )"
strSQL="CREATE INDEX [id] ON [_tlkpChart] ([ChartTitle])"
strSQL="CREATE UNIQUE INDEX [PrimaryKey] ON [_tlkpChart] ([id]) WITH PRIMARY DISALLOW NULL"
strSQL="CREATE INDEX [QAQCnum] ON [_tlkpChart] ([ChartTitle])"
strSQL="CREATE TABLE [_tlkpMonth] ([id] Counter,[TheMonthShort] Text (3),[TheMonthLong] Text (9),[TheMonthCode] Text (2) )"
strSQL="CREATE UNIQUE INDEX [PrimaryKey] ON [_tlkpMonth] ([id]) WITH PRIMARY DISALLOW NULL"
strSQL="CREATE INDEX [TheMonthCode] ON [_tlkpMonth] ([TheMonthCode])"
strSQL="CREATE TABLE [_tlkpYear] ([id] Counter,[TheYear] Text (4) )"
strSQL="CREATE UNIQUE INDEX [PrimaryKey] ON [_tlkpYear] ([id]) WITH PRIMARY DISALLOW NULL"
strSQL="CREATE TABLE [aeItems] ([Item] Text (255),[Quantity] Long,[Status] Text (255),[YNO] Text (255),[CHK] YesNo,[CBO] Text (255) )"
strSQL="CREATE TABLE [aetblThisTableHasSomeReallyLongNameButItCouldBeMuchLonger] ([id] Counter,[Desc] Text (255),[Description] Text (255) )"
strSQL="CREATE INDEX [id] ON [aetblThisTableHasSomeReallyLongNameButItCouldBeMuchLonger] ([Description])"
strSQL="CREATE UNIQUE INDEX [PrimaryKey] ON [aetblThisTableHasSomeReallyLongNameButItCouldBeMuchLonger] ([id]) WITH PRIMARY DISALLOW NULL"
strSQL="CREATE TABLE [aetlkpStates] ([StateCode] Text (3),[StateAbbreviation] Text (2),[StateName] Text (15) )"
strSQL="CREATE UNIQUE INDEX [PrimaryKey] ON [aetlkpStates] ([StateCode]) WITH PRIMARY DISALLOW NULL"
strSQL="CREATE INDEX [State Code] ON [aetlkpStates] ([StateName])"
strSQL="CREATE TABLE [tblBinary] ([id] Counter,[FileName] Text (255),[binary] OLEObject )"
strSQL="CREATE UNIQUE INDEX [ID] ON [tblBinary] ([id]) WITH PRIMARY DISALLOW NULL"
strSQL="CREATE TABLE [tblDummy0] ([Num] Long )"
strSQL="CREATE UNIQUE INDEX [PrimaryKey] ON [tblDummy0] ([Num]) WITH PRIMARY DISALLOW NULL"
strSQL="CREATE TABLE [tblDummy1] ([Num] Long )"
strSQL="CREATE UNIQUE INDEX [PrimaryKey] ON [tblDummy1] ([Num]) WITH PRIMARY DISALLOW NULL"
strSQL="CREATE TABLE [tblDummy2] ([Num] Long )"
strSQL="CREATE UNIQUE INDEX [PrimaryKey] ON [tblDummy2] ([Num]) WITH PRIMARY DISALLOW NULL"
strSQL="CREATE TABLE [USysRibbons] ([id] Counter,[RibbonName] Text (255),[RibbonXML] Memo )"
strSQL="CREATE INDEX [ID] ON [USysRibbons] ([RibbonXML])"
strSQL="CREATE UNIQUE INDEX [PrimaryKey] ON [USysRibbons] ([id]) WITH PRIMARY DISALLOW NULL"
