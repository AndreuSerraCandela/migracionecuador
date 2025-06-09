codeunit 55002 "Export Payments Formato EC"
{

    trigger OnRun()
    begin
    end;

    var
        Vendor: Record Vendor;
        BankAccount: Record "Bank Account";
        CompanyInformation: Record "Company Information";
        VendorBankAccount: Record "Vendor Bank Account";
        CheckLedgerEntry: Record "Check Ledger Entry";
        CheckManagement: Codeunit CheckManagement;
        RBMgt: Codeunit "File Management";
        TotalFileDebit: Decimal;
        TotalFileCredit: Decimal;
        TotalBatchDebit: Decimal;
        TotalBatchCredit: Decimal;
        RecordLength: Integer;
        BlockingFactor: Integer;
        BlockCount: Integer;
        EntryAddendaCount: Integer;
        FileEntryAddendaCount: Integer;
        NoOfRec: Integer;
        PrnString: Text[422];
        ExportFile: File;
        Justification: Option Left,Right;
        BatchNo: Integer;
        BatchCount: Integer;
        EntryHash: Decimal;
        FileHashTotal: Decimal;
        BatchHashTotal: Decimal;
        AdendaSeqNo: Integer;
        FileName: Text[250];
        FileNameFound: Boolean;
        FileIsInProcess: Boolean;
        BatchIsInProcess: Boolean;
        FileIDModifier: Code[1];
        FileDate: Date;
        FileTime: Time;
        ModifierValues: array[26] of Code[1];
        PayeeAcctType: Integer;
        I: Integer;
        TraceNo: Integer;
        BatchDay: Integer;
        Text000: Label 'Cannot start new Export File while %1 is in process.';
        Text001: Label 'is not valid.';
        Text002: Label '%1 in %2 %3 is invalid.';
        Text003: Label 'File %1 already exists. Check the %2 in %3 %4.';
        Text004: Label 'Cannot start export batch until an export file is started.';
        Text005: Label 'Cannot start new export batch until previous batch is completed.';
        Text006: Label 'Cannot export details until an export file is started.';
        Text007: Label 'Cannot export details until an export batch is started.';
        Text008: Label 'Vendor No. %1 has no bank account setup for electronic payments.';
        Text009: Label 'Vendor No. %1 has more than one bank account setup for electronic payments.';
        Text010: Label 'Customer No. %1 has no bank account setup for electronic payments.';
        Text011: Label 'Customer No. %1 has more than one bank account setup for electronic payments.';
        Text012: Label 'Cannot end export batch until an export file is started.';
        Text013: Label 'Cannot end export batch until an export batch is started.';
        Text014: Label 'Cannot end export file until an export file is started.';
        Text015: Label 'Cannot end export file until export batch is ended.';
        Text016: Label 'File %1 does not exist.';
        Text017: Label 'Did the transmission work properly?';
        Text018: Label 'Either %1 or %2 must refer to either a %3 or a %4 for an electronic payment.';
        Text1020100: Label '%1 is blocked for %2 processing';
        Text019: Label 'You must now run the program that transmits the payments file to the bank. Transmit the file named %1 located at %2 to %3 (%4 %5 %6).  After the transmission is completed, you will be asked if it worked correctly.  Are you ready to transmit (answer No to cancel the transmission process)?';
        Text1480004: Label 'Bank Account number must be either the 18 character CLABE format for checking, or 16 characters for Debit Card.';
        SequenceNo: Integer;
        OpCode: Integer;
        ClientFile: Text[250];


    // procedure StartExportFile(BankAccountNo: Code[20]; ReferenceCode: Code[10])
    // var
    //     FileHeaderRec: Text[422];
    //     i: Integer;
    // begin
    //     BuildIDModifier;
    //     if FileIsInProcess then
    //         Error(Text000, FileName);

    //     CompanyInformation.Get;
    //     CompanyInformation.TestField("Federal ID No.");

    //     BankAccount.LockTable;
    //     BankAccount.Get(BankAccountNo);
    //     BankAccount.TestField("Export Format", BankAccount."Export Format"::MX);
    //     BankAccount.TestField("Transit No.");
    //     BankAccount.TestField("E-Pay Export File Path");
    //     if BankAccount."E-Pay Export File Path"[StrLen(BankAccount."E-Pay Export File Path")] <> '\' then
    //         Error(Text002,
    //               BankAccount.FieldCaption("E-Pay Export File Path"),
    //               BankAccount.TableCaption,
    //               BankAccount."No.");
    //     //TESTFIELD("Last E-Pay Export File Name");
    //     BankAccount.TestField("Bank Acc. Posting Group");
    //     BankAccount.TestField(Blocked, false);

    //     FileName := ExportFileName();
    //     BankAccount."Last E-Pay Export File Name" := FileName;
    //     /*             if IsServiceTier then
    //                     FileName := RBMgt.TempFile()
    //                 else */
    //     FileName := BankAccount."E-Pay Export File Path" + FileName;
    //     BankAccount.Modify;

    //     /*             if Exists(FileName) then
    //                     Error(Text003,
    //                           FileName,
    //                           FieldCaption("Last E-Pay Export File Name"),
    //                           TableCaption,
    //                           "No.");
    //                 ExportFile.TextMode(true);
    //                 ExportFile.WriteMode(true);
    //                 if not IsServiceTier then
    //                     if File.Exists(FileName) then
    //                         File.Erase(FileName);
    //                 //ExportFile.QueryReplace(true);
    //                 ExportFile.Create(FileName);
    //                 if not IsServiceTier then
    //                     ExportFile.Open(FileName); */

    //     FileIsInProcess := true;
    //     FileDate := Today;
    //     FileTime := Time;
    //     NoOfRec := 0;
    //     FileHashTotal := 0;
    //     TotalFileDebit := 0;
    //     TotalFileCredit := 0;
    //     FileEntryAddendaCount := 0;
    //     BatchCount := 0;
    //     BlockingFactor := 10;
    //     RecordLength := 422;
    //     BatchNo := 0;
    // end;


    procedure StartExportBatch(OperationCode: Integer; SourceCode: Code[10]; SettleDate: Date)
    var
        BatchHeaderRec: Text[422];
    begin
        if not FileIsInProcess then
            Error(Text004);
        if BatchIsInProcess then
            Error(Text005);

        BatchIsInProcess := true;
        BatchNo := BatchNo + 1;
        BatchHashTotal := 0;
        TotalBatchDebit := 0;
        TotalBatchCredit := 0;
        EntryAddendaCount := 0;
        TraceNo := 0;
        SequenceNo := 1;
        BatchHeaderRec := '';
        OpCode := OperationCode;
        Evaluate(BatchDay, Format(Today, 2, '<Day>'));
        // Cecoban layout
        AddToPrnString(BatchHeaderRec, '1', 1, 2, Justification::Right, '0');                  // Record Type of Input "01" is Batch Header
        AddNumToPrnString(BatchHeaderRec, SequenceNo, 3, 7);                                          // Sequence Number
        AddNumToPrnString(BatchHeaderRec, OpCode, 10, 2);                                    // Operation Code
        AddToPrnString(BatchHeaderRec, BankAccount."Bank Account No.", 12, 3, Justification::Left, ' ');    // Bank 3 digit #
        AddToPrnString(BatchHeaderRec, 'E', 15, 1, Justification::Right, '');                    //  Export Type
        AddNumToPrnString(BatchHeaderRec, 2, 16, 1);                                          //  Service
        AddNumToPrnString(BatchHeaderRec, BatchDay, 17, 2);                                  //  Batch Number day of month part
        AddNumToPrnString(BatchHeaderRec, BatchNo, 19, 5);                                   //  Batch Number sequence part
        AddToPrnString(BatchHeaderRec, Format(SettleDate, 0, '<Year,2><Month,2><Day,2>'), 24, 8, Justification::Right, '0');
        //  Date of Presentation  AAAAMMDD
        AddToPrnString(BatchHeaderRec, '01', 32, 2, Justification::Left, ' ');                    // Currency Code, 01 - MX peso 05 - USD
        AddNumToPrnString(BatchHeaderRec, 0, 34, 2);                                           // Rejection code
        AddNumToPrnString(BatchHeaderRec, 2, 36, 1);                                          // System
        AddToPrnString(BatchHeaderRec, '', 37, 41, Justification::Left, ' ');                     // future Cecoban use
        AddToPrnString(BatchHeaderRec, '', 78, 345, Justification::Left, ' ');                     // future Bank use
        ExportPrnString(BatchHeaderRec);
    end;


    procedure ExportElectronicPayment(GenJnlLine: Record "Gen. Journal Line"; PaymentAmount: Decimal; SettleDate: Date): Code[30]
    var
        Vendor: Record Vendor;
        VendorBankAcct: Record "Vendor Bank Account";
        Customer: Record Customer;
        CustBankAcct: Record "Customer Bank Account";
        AcctType: Text[1];
        AcctNo: Code[20];
        AcctName: Text[30];
        BankAcctNo: Text[30];
        TransitNo: Text[20];
        RFCNo: Text[20];
        DetailRec: Text[422];
        DemandCredit: Boolean;
    begin
        /*GRN 11/03/2013
        IF NOT FileIsInProcess THEN
          ERROR(Text006);
        IF NOT BatchIsInProcess THEN
          ERROR(Text007);
        
        // NOTE:  If PaymentAmount is Positive, then we are Receiving money.
        //        If PaymentAmount is Negative, then we are Sending money.
        IF PaymentAmount = 0 THEN
          EXIT('');
        DemandCredit := (PaymentAmount < 0);
        PaymentAmount := ABS(PaymentAmount);
        
        WITH GenJnlLine DO BEGIN
          IF "Account Type" = "Account Type"::Vendor THEN BEGIN
            AcctType := 'V';
            AcctNo := "Account No.";
          END ELSE IF "Account Type" = "Account Type"::Customer THEN BEGIN
            AcctType := 'C';
            AcctNo := "Account No.";
          END ELSE IF "Bal. Account Type" = "Bal. Account Type"::Vendor THEN BEGIN
            AcctType := 'V';
            AcctNo := "Bal. Account No.";
          END ELSE IF "Bal. Account Type" = "Bal. Account Type"::Customer THEN BEGIN
            AcctType := 'C';
            AcctNo := "Bal. Account No.";
          END ELSE
            ERROR(Text018,
                  FIELDCAPTION("Account Type"),FIELDCAPTION("Bal. Account Type"),Vendor.TABLECAPTION,Customer.TABLECAPTION);
        
          IF AcctType = 'V' THEN BEGIN
            Vendor.GET(AcctNo);
            Vendor.TESTFIELD(Blocked,Vendor.Blocked::" ");
            AcctName := Vendor.Name;
            RFCNo := Vendor."VAT Registration No.";
        
            VendorBankAcct.SETRANGE("Vendor No.", AcctNo);
            VendorBankAcct.SETRANGE( "Use for Electronic Payments", TRUE);
            VendorBankAcct.FIND('-');
        
            IF VendorBankAcct.COUNT < 1 THEN
              ERROR(Text008, AcctNo);
            IF VendorBankAcct.COUNT > 1 THEN
              ERROR(Text009, AcctNo);
            IF NOT PayeeCheckDigit(VendorBankAcct."Transit No.") THEN
              VendorBankAcct.FIELDERROR("Transit No.",Text001 + ' ' + Text1480004);
        
            VendorBankAcct.TESTFIELD("Bank Account No.");
            TransitNo := VendorBankAcct."Transit No.";
            BankAcctNo := VendorBankAcct."Bank Account No.";
          END ELSE IF AcctType = 'C' THEN BEGIN
            Customer.GET(AcctNo);
              IF Customer.Blocked = Customer.Blocked::All THEN
              ERROR(
                STRSUBSTNO(
                  Text1020100,
                  "Account Type",Customer.Blocked));
            AcctName := Customer.Name;
            RFCNo := Customer."VAT Registration No.";
        
            CustBankAcct.SETRANGE("Customer No.", AcctNo);
            CustBankAcct.SETRANGE( "Use for Electronic Payments", TRUE);
            CustBankAcct.FIND('-');
        
            IF CustBankAcct.COUNT < 1 THEN
              ERROR(Text010, AcctNo);
              ERROR(Text011, AcctNo);
            IF NOT PayeeCheckDigit(CustBankAcct."Transit No.") THEN
              CustBankAcct.FIELDERROR("Transit No.",Text001 + ' ' + Text1480004);
            CustBankAcct.TESTFIELD("Bank Account No.");
            TransitNo := CustBankAcct."Transit No.";
            BankAcctNo := CustBankAcct."Bank Account No.";
          END;
        
          TraceNo := TraceNo + 1;
          SequenceNo := SequenceNo + 1;
          DetailRec := '';
          //  Cecoban Detail rec
          AddToPrnString(DetailRec,'2',1,2,Justification::Right,'0');                      // Record Type of Input "02" is Detail
          AddNumToPrnString(DetailRec,SequenceNo,3,7);                                     // Sequence Number
          AddNumToPrnString(DetailRec,OpCode,10,2);                                            // Operation Code
          AddToPrnString(DetailRec,'01',12,2,Justification::Left,' ');                    // Currency Code, 01 - MX peso 05 - USD
          AddToPrnString(DetailRec,FORMAT(FileDate,0,'<Year,4><Month,2><Day,2>'),14,8,Justification::Right,'0');
          //  Transfer Date AAAAMMDD
        
          AddToPrnString(DetailRec,BankAccount."Bank Account No.",22,3,Justification::Left,' ');                    // ODFI
          AddToPrnString(DetailRec,BankAcctNo,25,3,Justification::Left,' ');                // RDFI
          AddAmtToPrnString(DetailRec,PaymentAmount,28,15);                                           // Operation Fee
          AddToPrnString(DetailRec,' ',43,16,Justification::Left,' ');                    // Future use
          AddNumToPrnString(DetailRec,OpCode,59,2);                                        // Operation Type
          AddToPrnString(DetailRec,FORMAT(SettleDate,0,'<Year,2><Month,2><Day,2>'),61,8,Justification::Right,'0');
        //  Date Entered AAAAMMDD
          AddNumToPrnString(DetailRec,1,69,2);                    // '?????' Originator Account Type
          AddToPrnString(DetailRec,BankAccount."Transit No.",71,20,Justification::Left,'');          // Originator Account No.
          AddToPrnString(DetailRec,AcctName,91,40,Justification::Left,'');                    // Originator Account Name
          AddToPrnString(DetailRec,'',131,18,Justification::Left,'');                   // Originator RFC/CURP
          AddNumToPrnString(DetailRec,PayeeAcctType,149,2);                    // Payee Account Type
          AddToPrnString(DetailRec,TransitNo,151,20,Justification::Left,'');              // Payee Account No.
          AddToPrnString(DetailRec,AcctName,171,40,Justification::Left,'');                    // Payee Account Name
          AddToPrnString(DetailRec,RFCNo,211,18,Justification::Left,'');                   // Payee RFC/CURP
          AddToPrnString(DetailRec,'',229,40,Justification::Left,'');                   // Transmitter Service Reference
          AddToPrnString(DetailRec,'',269,40,Justification::Left,'');                   // Service Owner
          AddAmtToPrnString(DetailRec,0,309,15);                                            // Operation Tax Cost
          AddNumToPrnString(DetailRec,0,324,7);                                       // Originator Numeric reference
          AddToPrnString(DetailRec,'',331,40,Justification::Left,'');                   // Originator alpha reference
          AddToPrnString(DetailRec,GenerateTraceNoCode(TraceNo),371,30,Justification::Left,'');                   // Tracking code
          AddNumToPrnString(DetailRec,0,401,2);                                            // Return Reason
          AddToPrnString(DetailRec,FORMAT(TODAY,0,'<Year><Month,2><Day,2>'),403,8,Justification::Left,' ');   // Initial Presentation Date
          AddToPrnString(DetailRec,'',411,12,Justification::Left,' ');                   // future use
          //AddAmtToPrnString(DetailRec,0,423,7);                                         // for untimely returns
          //AddNumToPrnString(DetailRec,0,430,3);                                         // delayed days for untimely returns
          //AddAmtToPrnString(DetailRec,0,433,15);                                         // for untimely returns
        
          ExportPrnString(DetailRec);
          EntryAddendaCount := EntryAddendaCount + 1;
          IF DemandCredit THEN
            TotalBatchCredit := TotalBatchCredit + PaymentAmount
          ELSE
            TotalBatchDebit := TotalBatchDebit + PaymentAmount;
          IncrementHashTotal(BatchHashTotal,MakeHash(COPYSTR(TransitNo,1,8)));
        END;
        */
        exit(GenerateFullTraceNoCode(TraceNo));

    end;


    procedure EndExportBatch()
    var
        BatchControlRec: Text[422];
    begin
        if not FileIsInProcess then
            Error(Text012);
        if not BatchIsInProcess then
            Error(Text013);

        BatchIsInProcess := false;
        BatchControlRec := '';
        SequenceNo := SequenceNo + 1;
        //cecoban batch summary
        AddNumToPrnString(BatchControlRec, 9, 1, 2);                  // Record Type
        AddNumToPrnString(BatchControlRec, SequenceNo, 3, 7);                  // sequence number
        AddNumToPrnString(BatchControlRec, OpCode, 10, 2);                  // op code
        AddNumToPrnString(BatchControlRec, BatchDay, 12, 2);                  //  Batch Number day of month part
        AddNumToPrnString(BatchControlRec, BatchNo, 14, 5);                  // batch number sequence part
        AddNumToPrnString(BatchControlRec, (SequenceNo - 2), 19, 7);          // operation number
        AddAmtToPrnString(BatchControlRec, BatchHashTotal, 26, 18);                  // TCO
        AddToPrnString(BatchControlRec, ' ', 44, 40, Justification::Left, ' ');            // future use
        AddToPrnString(BatchControlRec, ' ', 84, 339, Justification::Left, ' ');            // future use
        ExportPrnString(BatchControlRec);

        BatchCount := BatchCount + 1;
        IncrementHashTotal(FileHashTotal, BatchHashTotal);
        TotalFileDebit := TotalFileDebit + TotalBatchDebit;
        TotalFileCredit := TotalFileCredit + TotalBatchCredit;
        FileEntryAddendaCount := FileEntryAddendaCount + EntryAddendaCount;
    end;


    procedure EndExportFile(): Boolean
    var
        FileControlRec: Text[422];
    begin
        if not FileIsInProcess then
            Error(Text014);
        if BatchIsInProcess then
            Error(Text015);

        FileIsInProcess := false;
        /*       ExportFile.Close;
              if IsServiceTier then begin
                  ClientFile := BankAccount."E-Pay Export File Path" + BankAccount."Last E-Pay Export File Name";
                  if not Download(FileName, '', '', '', ClientFile) then begin
                      Erase(FileName);
                      exit(false);
                  end;
                  Erase(FileName);
              end; */

        exit(true);
    end;

    local procedure GenerateFullTraceNoCode(TraceNo: Integer): Code[30]
    var
        TraceCode: Text[250];
    begin
        TraceCode := '';
        AddToPrnString(TraceCode, Format(FileDate, 0, '<Year,2><Month,2><Day,2>'), 1, 6, Justification::Left, ' ');
        //AddToPrnString(TraceCode, BankAccount."Last ACH File ID Modifier", 7, 1, Justification::Right, '0');
        AddNumToPrnString(TraceCode, BatchNo, 8, 7);
        AddToPrnString(TraceCode, GenerateTraceNoCode(TraceNo), 15, 15, Justification::Left, ' ');
        exit(TraceCode);
    end;

    local procedure GenerateTraceNoCode(TraceNo: Integer): Code[15]
    var
        TraceCode: Text[250];
    begin
        TraceCode := '';
        AddToPrnString(TraceCode, BankAccount."Transit No.", 1, 8, Justification::Left, ' ');
        AddNumToPrnString(TraceCode, TraceNo, 9, 7);
        exit(TraceCode);
    end;

    local procedure AddNumToPrnString(var PrnString: Text[422]; Number: Integer; StartPos: Integer; Length: Integer)
    var
        TmpString: Text[422];
        I: Integer;
    begin
        TmpString := DelChr(Format(Number), '=', '.,-');
        AddToPrnString(PrnString, TmpString, StartPos, Length, Justification::Right, '0');
    end;

    local procedure AddAmtToPrnString(var PrnString: Text[422]; Amount: Decimal; StartPos: Integer; Length: Integer)
    var
        TmpString: Text[422];
        I: Integer;
    begin
        TmpString := Format(Amount);
        I := StrPos(TmpString, '.');
        case true of
            I = 0:
                TmpString := TmpString + '.00';
            I = StrLen(TmpString) - 1:
                TmpString := TmpString + '0';
        end;
        TmpString := DelChr(TmpString, '=', '.,-');
        AddToPrnString(PrnString, TmpString, StartPos, Length, Justification::Right, '0');
    end;

    local procedure AddToPrnString(var PrnString: Text[422]; SubString: Text[345]; StartPos: Integer; Length: Integer; Justification: Option Left,Right; Filler: Text[1])
    var
        TmpString: Text[422];
        I: Integer;
        SubStrLen: Integer;
    begin
        SubString := UpperCase(DelChr(SubString, '<>', ' '));
        SubStrLen := StrLen(SubString);

        if SubStrLen > Length then begin
            SubString := CopyStr(SubString, 1, Length);
            SubStrLen := Length;
        end;

        if Justification = Justification::Right then
            for I := 1 to (Length - SubStrLen) do
                SubString := Filler + SubString
        else
            for I := SubStrLen + 1 to Length do
                SubString := SubString + Filler;

        if StrLen(PrnString) >= StartPos then
            if StartPos > 1 then
                PrnString := CopyStr(PrnString, 1, StartPos - 1) + SubString + CopyStr(PrnString, StartPos)
            else
                PrnString := SubString + PrnString
        else begin
            for I := StrLen(PrnString) + 1 to StartPos - 1 do
                PrnString := PrnString + ' ';
            PrnString := PrnString + SubString;
        end;
    end;

    local procedure ExportPrnString(var PrnString: Text[422])
    begin
        PrnString := PadStr(PrnString, RecordLength, ' ');
        //ExportFile.Write(PrnString);
        NoOfRec := NoOfRec + 1;
        PrnString := '';
    end;


    procedure PayeeCheckDigit(DigitString: Code[20]): Boolean
    var
        Weight: Code[8];
        Digit: Integer;
        I: Integer;
        Digit1: Integer;
        Digit2: Integer;
        CheckChar: Code[1];
    begin
        //Weight := '37137137';
        //Digit := 0;
        if StrLen(DigitString) = 18 then begin
            PayeeAcctType := 1;
            exit(true);                                   //checking Account
        end else
            if StrLen(DigitString) = 16 then begin
                PayeeAcctType := 3;                                   //debit card
                exit(true);                                   //checking Account
            end else
                exit(false);
        /*
        IF STRLEN(DigitString) <= STRLEN(Weight) THEN
          EXIT(FALSE);
        
        FOR I := 1 TO STRLEN(Weight) DO BEGIN
          EVALUATE(Digit1,COPYSTR(DigitString,I,1));
          EVALUATE(Digit2,COPYSTR(Weight,I,1));
          Digit := Digit + Digit1 * Digit2;
        END;
        
        Digit := 10 - Digit MOD 10;
        IF Digit = 10 THEN
          CheckChar := '0'
        ELSE
          CheckChar := FORMAT(Digit);
        EXIT(DigitString[STRLEN(Weight)+1] = CheckChar[1]);
        */

    end;

    local procedure IncrementHashTotal(var HashTotal: Decimal; HashIncrement: Decimal)
    var
        SubTotal: Decimal;
    begin
        SubTotal := HashTotal + HashIncrement;
        if SubTotal < 10000000000.0 then
            HashTotal := SubTotal
        else
            HashTotal := SubTotal - 10000000000.0;
    end;

    local procedure MakeHash(InputString: Text[30]): Decimal
    var
        HashAmt: Decimal;
    begin
        InputString := DelChr(InputString, '=', '.,- ');
        if Evaluate(HashAmt, InputString) then
            exit(HashAmt)
        else
            exit(0);
    end;

    local procedure BuildIDModifier()
    begin
        ModifierValues[1] := 'A';
        ModifierValues[2] := 'B';
        ModifierValues[3] := 'C';
        ModifierValues[4] := 'D';
        ModifierValues[5] := 'E';
        ModifierValues[6] := 'F';
        ModifierValues[7] := 'G';
        ModifierValues[8] := 'H';
        ModifierValues[9] := 'I';
        ModifierValues[10] := 'J';
        ModifierValues[11] := 'K';
        ModifierValues[12] := 'L';
        ModifierValues[13] := 'M';
        ModifierValues[14] := 'N';
        ModifierValues[15] := 'O';
        ModifierValues[16] := 'P';
        ModifierValues[17] := 'Q';
        ModifierValues[18] := 'R';
        ModifierValues[19] := 'S';
        ModifierValues[20] := 'T';
        ModifierValues[21] := 'U';
        ModifierValues[22] := 'V';
        ModifierValues[23] := 'W';
        ModifierValues[24] := 'X';
        ModifierValues[25] := 'Y';
        ModifierValues[26] := 'Z';
    end;


    procedure TransmitExportedFile(BankAccountNo: Code[20]; FName: Text[30])
    var
        ExportFullPathName: Text[250];
        TransmitFullPathName: Text[250];
    begin
        BankAccount.Get(BankAccountNo);
        BankAccount.TestField("E-Pay Export File Path");
        if BankAccount."E-Pay Export File Path"[StrLen(BankAccount."E-Pay Export File Path")] <> '\' then
            Error(Text002,
                  BankAccount.FieldCaption("E-Pay Export File Path"),
                  BankAccount.TableCaption,
                  BankAccount."No.");
        // BankAccount.TestField("E-Pay Trans. Program Path");
        // if BankAccount."E-Pay Trans. Program Path"[StrLen(BankAccount."E-Pay Trans. Program Path")] <> '\' then
        //     Error(Text002,
        //           BankAccount.FieldCaption("E-Pay Trans. Program Path"),
        //           BankAccount.TableCaption,
        //           BankAccount."No.");
        // ExportFullPathName := BankAccount."E-Pay Export File Path" + FName;
        // TransmitFullPathName := BankAccount."E-Pay Trans. Program Path" + FName;
        // /*         if not Exists(ExportFullPathName) then
        //             Error(Text016, FName);
        //         Copy(ExportFullPathName, TransmitFullPathName); */
        // if Confirm(Text019, true, FName, BankAccount."E-Pay Trans. Program Path", BankAccount.Name, BankAccount.TableCaption, BankAccount.FieldCaption("No."), BankAccount."No.")
        // then begin
        //     if Confirm(Text017) then;
        //     // Erase(ExportFullPathName);
        // end;
    end;


    procedure ExportFileName(): Text[250]
    begin
        if BankAccount."Last E-Pay Export File Name" = '' then begin
            FileName := '';
            AddToPrnString(FileName, 'S01', 1, 3, Justification::Right, '');                      // Record Type of Input "02" is Detail
            AddToPrnString(FileName, BankAccount."Bank Account No.", 4, 3, Justification::Left, ' ');    // Bank 3 digit #
            AddToPrnString(FileName, 'A2.A10 ', 7, 6, Justification::Right, '');
            AddToPrnString(FileName, Format(Today, 2, '0' + '<weekDay>'), 13, 2, Justification::Right, ''); //weekday
            AddNumToPrnString(FileName, BatchNo + 1, 15, 2);                                     // Sequence Number
        end else begin
            FileName := BankAccount."Last E-Pay Export File Name";
            AddToPrnString(FileName, Format(Today, 2, '0' + '<weekDay>'), 13, 2, Justification::Right, ''); //weekday
            AddNumToPrnString(FileName, BatchNo + 1, 15, 2);                                     // Sequence Number
        end;
        exit(FileName);
    end;
}

