report 55005 "Cheque Ecuador"
{
    // #3467  09/07/2014  PLB: Ampliado el tipo de letra en la ciudad y fecha ya que en la impresora matricial no se imprimían
    //                         correctamente ciertos días
    // #5183  30/09/2014  PLB: Cambiado el formato de la fecha "dia. mes en letras año" (5. Julio 2014) a "aaaa/mm/dd" (2014/07/05)
    // 
    // MOI - 16/01/2015 (#9514): La cantidad de decimales en el CheckAmountText pasan a ser 2.
    // MOI - 22/01/2015 (#9514):Ñapa
    // MOI - 21/05/2015 (#20754): Se elimina la cantidad de MaxIteration del dataitem PrintSettledLoop.
    DefaultLayout = RDLC;
    RDLCLayout = './ChequeEcuador.rdlc';

    Caption = 'Check';
    Permissions = TableData "Bank Account" = m;

    dataset
    {
        dataitem(VoidGenJnlLine; "Gen. Journal Line")
        {
            DataItemTableView = SORTING("Journal Template Name", "Journal Batch Name", "Posting Date", "Document No.");
            RequestFilterFields = "Journal Template Name", "Journal Batch Name", "Posting Date";

            trigger OnAfterGetRecord()
            begin
                CheckManagement.VoidCheck(VoidGenJnlLine);
            end;

            trigger OnPreDataItem()
            begin
                //IF CurrReport.PREVIEW THEN    $001
                //  ERROR(Text000);

                if UseCheckNo = '' then
                    Error(Text001);

                if IncStr(UseCheckNo) = '' then
                    Error(USText004);

                if TestPrint then
                    CurrReport.Break;

                if not ReprintChecks then
                    CurrReport.Break;

                if (GetFilter("Line No.") <> '') or (GetFilter("Document No.") <> '') then
                    Error(
                      Text002, FieldCaption("Line No."), FieldCaption("Document No."));
                SetRange("Bank Payment Type", "Bank Payment Type"::"Computer Check");
                SetRange("Check Printed", true);
            end;
        }
        dataitem(TestGenJnlLine; "Gen. Journal Line")
        {
            DataItemTableView = SORTING("Journal Template Name", "Journal Batch Name", "Line No.");

            trigger OnAfterGetRecord()
            begin
                if Amount = 0 then
                    CurrReport.Skip;

                TestField("Bal. Account Type", "Bal. Account Type"::"Bank Account");
                if "Bal. Account No." <> BankAcc2."No." then
                    CurrReport.Skip;
                case "Account Type" of
                    "Account Type"::"G/L Account":
                        begin
                            // if BankAcc2."Check Date Format" = BankAcc2."Check Date Format"::" " then
                            //     Error(USText006, BankAcc2.FieldCaption("Check Date Format"), BankAcc2.TableCaption, BankAcc2."No.");
                            // if BankAcc2."Bank Communication" = BankAcc2."Bank Communication"::"S Spanish" then
                            //     Error(USText007, BankAcc2.FieldCaption("Bank Communication"), BankAcc2.TableCaption, BankAcc2."No.");
                        end;
                    "Account Type"::Customer:
                        begin
                            Cust.Get("Account No.");
                            // if Cust."Check Date Format" = Cust."Check Date Format"::" " then
                            //     Error(USText006, Cust.FieldCaption("Check Date Format"), Cust.TableCaption, "Account No.");
                            // if Cust."Bank Communication" = Cust."Bank Communication"::"S Spanish" then
                            //     Error(USText007, Cust.FieldCaption("Bank Communication"), Cust.TableCaption, "Account No.");
                        end;
                    "Account Type"::Vendor:
                        begin
                            Vend.Get("Account No.");
                            // if Vend."Check Date Format" = Vend."Check Date Format"::" " then
                            //     Error(USText006, Vend.FieldCaption("Check Date Format"), Vend.TableCaption, "Account No.");
                            // if Vend."Bank Communication" = Vend."Bank Communication"::"S Spanish" then
                            //     Error(USText007, Vend.FieldCaption("Bank Communication"), Vend.TableCaption, "Account No.");
                        end;
                    "Account Type"::"Bank Account":
                        begin
                            BankAcc.Get("Account No.");
                            // if BankAcc."Check Date Format" = BankAcc."Check Date Format"::" " then
                            //     Error(USText006, BankAcc.FieldCaption("Check Date Format"), BankAcc.TableCaption, "Account No.");
                            // if BankAcc."Bank Communication" = BankAcc."Bank Communication"::"S Spanish" then
                            //     Error(USText007, BankAcc.FieldCaption("Bank Communication"), BankAcc.TableCaption, "Account No.");
                        end;
                end;
            end;

            trigger OnPreDataItem()
            begin
                if TestPrint then begin
                    CompanyInfo.Get;
                    BankAcc2.Get(BankAcc2."No.");
                    BankCurrencyCode := BankAcc2."Currency Code";
                end;

                if TestPrint then
                    CurrReport.Break;
                CompanyInfo.Get;
                BankAcc2.Get(BankAcc2."No.");
                BankCurrencyCode := BankAcc2."Currency Code";

                if BankAcc2."Country/Region Code" <> 'CA' then
                    CurrReport.Break;
                BankAcc2.TestField(Blocked, false);
                Copy(VoidGenJnlLine);
                BankAcc2.Get(BankAcc2."No.");
                BankAcc2.TestField(Blocked, false);
                SetRange("Bank Payment Type", "Bank Payment Type"::"Computer Check");
                SetRange("Check Printed", false);
            end;
        }
        dataitem(GenJnlLine; "Gen. Journal Line")
        {
            DataItemTableView = SORTING("Journal Template Name", "Journal Batch Name", "Posting Date", "Document No.");
            column(GenJnlLine_Journal_Template_Name; "Journal Template Name")
            {
            }
            column(GenJnlLine_Journal_Batch_Name; "Journal Batch Name")
            {
            }
            column(GenJnlLine_Line_No_; "Line No.")
            {
            }
            dataitem(CheckPages; "Integer")
            {
                DataItemTableView = SORTING(Number);
                dataitem(PrintSettledLoop; "Integer")
                {
                    DataItemTableView = SORTING(Number);

                    trigger OnAfterGetRecord()
                    begin
                        if not TestPrint then begin
                            if FoundLast then begin
                                if RemainingAmount <> 0 then begin
                                    DocType := Text015;
                                    DocNo := '';
                                    ExtDocNo := '';
                                    LineAmount := RemainingAmount;
                                    LineAmount2 := RemainingAmount;
                                    CurrentLineAmount := LineAmount2;
                                    LineDiscount := 0;
                                    RemainingAmount := 0;
                                    PostingDesc := CheckToAddr[1];

                                end else
                                    CurrReport.Break;
                            end else begin
                                case ApplyMethod of
                                    ApplyMethod::OneLineOneEntry:
                                        begin
                                            case BalancingType of
                                                BalancingType::Customer:
                                                    begin
                                                        CustLedgEntry.Reset;
                                                        CustLedgEntry.SetCurrentKey("Document No.");
                                                        CustLedgEntry.SetRange("Document Type", GenJnlLine."Applies-to Doc. Type");
                                                        CustLedgEntry.SetRange("Document No.", GenJnlLine."Applies-to Doc. No.");
                                                        CustLedgEntry.SetRange("Customer No.", BalancingNo);
                                                        CustLedgEntry.Find('-');
                                                        CustUpdateAmounts(CustLedgEntry, RemainingAmount);
                                                    end;
                                                BalancingType::Vendor:
                                                    begin
                                                        VendLedgEntry.Reset;
                                                        VendLedgEntry.SetCurrentKey("Document No.");
                                                        VendLedgEntry.SetRange("Document Type", GenJnlLine."Applies-to Doc. Type");
                                                        VendLedgEntry.SetRange("Document No.", GenJnlLine."Applies-to Doc. No.");
                                                        VendLedgEntry.SetRange("Vendor No.", BalancingNo);
                                                        VendLedgEntry.Find('-');
                                                        VendUpdateAmounts(VendLedgEntry, RemainingAmount);
                                                    end;
                                            end;
                                            RemainingAmount := RemainingAmount - LineAmount2;
                                            CurrentLineAmount := LineAmount2;
                                            FoundLast := true;
                                        end;
                                    ApplyMethod::OneLineID:
                                        begin
                                            case BalancingType of
                                                BalancingType::Customer:
                                                    begin
                                                        CustUpdateAmounts(CustLedgEntry, RemainingAmount);
                                                        FoundLast := (CustLedgEntry.Next = 0) or (RemainingAmount <= 0);
                                                        if FoundLast and not FoundNegative then begin
                                                            CustLedgEntry.SetRange(Positive, false);
                                                            FoundLast := not CustLedgEntry.Find('-');
                                                            FoundNegative := true;
                                                        end;
                                                    end;
                                                BalancingType::Vendor:
                                                    begin
                                                        VendUpdateAmounts(VendLedgEntry, RemainingAmount);
                                                        FoundLast := (VendLedgEntry.Next = 0) or (RemainingAmount <= 0);
                                                        if FoundLast and not FoundNegative then begin
                                                            VendLedgEntry.SetRange(Positive, false);
                                                            FoundLast := not VendLedgEntry.Find('-');
                                                            FoundNegative := true;
                                                        end;
                                                    end;
                                            end;
                                            RemainingAmount := RemainingAmount - LineAmount2;
                                            CurrentLineAmount := LineAmount2;
                                        end;
                                    ApplyMethod::MoreLinesOneEntry:
                                        begin
                                            CurrentLineAmount := GenJnlLine2.Amount;
                                            LineAmount2 := CurrentLineAmount;
                                            if GenJnlLine2."Applies-to ID" <> '' then
                                                Error(
                                                  Text016 +
                                                  Text017);
                                            GenJnlLine2.TestField("Check Printed", false);
                                            GenJnlLine2.TestField("Bank Payment Type", GenJnlLine2."Bank Payment Type"::"Computer Check");

                                            if GenJnlLine2."Applies-to Doc. No." = '' then begin
                                                DocType := Text015;
                                                DocNo := '';
                                                ExtDocNo := '';
                                                LineAmount := CurrentLineAmount;
                                                LineDiscount := 0;
                                                PostingDesc := GenJnlLine2.Description;
                                            end else begin
                                                case BalancingType of
                                                    BalancingType::"G/L Account":
                                                        begin
                                                            DocType := Format(GenJnlLine2."Document Type");
                                                            DocNo := GenJnlLine2."Document No.";
                                                            ExtDocNo := GenJnlLine2."External Document No.";
                                                            LineAmount := CurrentLineAmount;
                                                            LineDiscount := 0;
                                                            PostingDesc := GenJnlLine2.Description;

                                                        end;
                                                    BalancingType::Customer:
                                                        begin
                                                            CustLedgEntry.Reset;
                                                            CustLedgEntry.SetCurrentKey("Document No.");
                                                            CustLedgEntry.SetRange("Document Type", GenJnlLine2."Applies-to Doc. Type");
                                                            CustLedgEntry.SetRange("Document No.", GenJnlLine2."Applies-to Doc. No.");
                                                            CustLedgEntry.SetRange("Customer No.", BalancingNo);
                                                            CustLedgEntry.Find('-');
                                                            CustUpdateAmounts(CustLedgEntry, CurrentLineAmount);
                                                            LineAmount := CurrentLineAmount;
                                                        end;
                                                    BalancingType::Vendor:
                                                        begin
                                                            VendLedgEntry.Reset;
                                                            VendLedgEntry.SetCurrentKey("Document No.");
                                                            VendLedgEntry.SetRange("Document Type", GenJnlLine2."Applies-to Doc. Type");
                                                            VendLedgEntry.SetRange("Document No.", GenJnlLine2."Applies-to Doc. No.");
                                                            VendLedgEntry.SetRange("Vendor No.", BalancingNo);
                                                            VendLedgEntry.Find('-');
                                                            VendUpdateAmounts(VendLedgEntry, CurrentLineAmount);
                                                            LineAmount := CurrentLineAmount;
                                                        end;
                                                    BalancingType::"Bank Account":
                                                        begin
                                                            DocType := Format(GenJnlLine2."Document Type");
                                                            DocNo := GenJnlLine2."Document No.";
                                                            ExtDocNo := GenJnlLine2."External Document No.";
                                                            LineAmount := CurrentLineAmount;
                                                            LineDiscount := 0;
                                                            PostingDesc := GenJnlLine2.Description;

                                                        end;
                                                end;
                                            end;
                                            FoundLast := GenJnlLine2.Next = 0;
                                        end;
                                end;
                            end;

                            TotalLineAmount := TotalLineAmount + CurrentLineAmount;
                            TotalLineDiscount := TotalLineDiscount + LineDiscount;
                        end else begin
                            if FoundLast then
                                CurrReport.Break;
                            FoundLast := true;
                            DocType := Text018;
                            DocNo := Text010;
                            ExtDocNo := Text010;
                            LineAmount := 0;
                            LineDiscount := 0;
                            PostingDesc := '';

                        end;

                        if DocNo = '' then
                            CurrencyCode2 := GenJnlLine."Currency Code";
                    end;

                    trigger OnPreDataItem()
                    begin
                        if not TestPrint then
                            if FirstPage then begin
                                FoundLast := true;
                                case ApplyMethod of
                                    ApplyMethod::OneLineOneEntry:
                                        FoundLast := false;
                                    ApplyMethod::OneLineID:
                                        case BalancingType of
                                            BalancingType::Customer:
                                                begin
                                                    CustLedgEntry.Reset;
                                                    CustLedgEntry.SetCurrentKey("Customer No.", Open, Positive);
                                                    CustLedgEntry.SetRange("Customer No.", BalancingNo);
                                                    CustLedgEntry.SetRange(Open, true);
                                                    CustLedgEntry.SetRange(Positive, true);
                                                    CustLedgEntry.SetRange("Applies-to ID", GenJnlLine."Applies-to ID");
                                                    FoundLast := not CustLedgEntry.Find('-');
                                                    if FoundLast then begin
                                                        CustLedgEntry.SetRange(Positive, false);
                                                        FoundLast := not CustLedgEntry.Find('-');
                                                        FoundNegative := true;
                                                    end else
                                                        FoundNegative := false;
                                                end;
                                            BalancingType::Vendor:
                                                begin
                                                    VendLedgEntry.Reset;
                                                    VendLedgEntry.SetCurrentKey("Vendor No.", Open, Positive);
                                                    VendLedgEntry.SetRange("Vendor No.", BalancingNo);
                                                    VendLedgEntry.SetRange(Open, true);
                                                    VendLedgEntry.SetRange(Positive, true);
                                                    VendLedgEntry.SetRange("Applies-to ID", GenJnlLine."Applies-to ID");
                                                    FoundLast := not VendLedgEntry.Find('-');
                                                    if FoundLast then begin
                                                        VendLedgEntry.SetRange(Positive, false);
                                                        FoundLast := not VendLedgEntry.Find('-');
                                                        FoundNegative := true;
                                                    end else
                                                        FoundNegative := false;
                                                end;
                                        end;
                                    ApplyMethod::MoreLinesOneEntry:
                                        FoundLast := false;
                                end;
                            end
                            else
                                FoundLast := false;

                        if DocNo = '' then
                            CurrencyCode2 := GenJnlLine."Currency Code";

                        if PreprintedStub then
                            TotalText := ''
                        else
                            TotalText := Text019;

                        if GenJnlLine."Currency Code" <> '' then
                            NetAmount := StrSubstNo(Text063, GenJnlLine."Currency Code")
                        else begin
                            GLSetup.Get;
                            NetAmount := StrSubstNo(Text063, GLSetup."LCY Code");
                        end;

                        PageNo := PageNo + 1;
                    end;
                }
                dataitem(PrintCheck; "Integer")
                {
                    DataItemTableView = SORTING(Number);
                    MaxIteration = 1;
                    column(Beneficiario; GenJnlLine.Beneficiario)
                    {
                    }
                    column(CheckDateText; Format(CheckDateText))
                    {
                    }
                    column(CheckNoText; CheckNoText)
                    {
                    }
                    column(PreprintedStub; PreprintedStub)
                    {
                    }
                    column(Descripcion; GenJnlLine.Description)
                    {
                    }
                    column(Chk_Amount; GenJnlLine.Amount)
                    {
                    }
                    column(Posting_Date; Format(GenJnlLine."Posting Date", 0, '<year4>/<month,2>/<day,2>'))
                    {
                    }
                    column(Ciudad; CompanyInfo.City)
                    {
                    }
                    column(DocNo; DocNo)
                    {
                    }
                    column(DocDate; DocDate)
                    {
                    }
                    column(PostingDesc; PostingDesc)
                    {
                    }
                    column(PageNo; PageNo)
                    {
                    }
                    column(DescriptionLine_1__; DescriptionLine[1])
                    {
                    }
                    column(TotalLineAmount; Format(TotalLineAmount, 0))
                    {
                        AutoFormatExpression = GenJnlLine."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(TotalText; Format(TotalText, 0))
                    {
                    }
                    column(CompanyAddr_1_; CompanyAddr[1])
                    {
                    }
                    column(CheckNoText_Control1020006; CheckNoText)
                    {
                    }
                    column(CheckDateText2; CheckDateText)
                    {
                    }
                    column(DateIndicator; DateIndicator)
                    {
                    }
                    column(DescriptionLine_2__; DescriptionLine[2])
                    {
                    }
                    column(CheckAmountText; DollarSignBefore + CheckAmountText + DollarSignAfter)
                    {
                    }
                    column(CurrencyCode; BankAcc."Currency Code")
                    {
                    }
                    column(VoidText; VoidText)
                    {
                    }
                    column(CheckStyleIndex; CheckStyleIndex)
                    {
                    }
                    column(BankCurrencyCode; BankCurrencyCode)
                    {
                    }
                    column(PageNo_Control1020023; PageNo)
                    {
                    }
                    column(PrintCheck_Number; Number)
                    {
                    }

                    trigger OnAfterGetRecord()
                    var
                        Decimals: Decimal;
                    begin
                        if not TestPrint then begin

                            CheckLedgEntry.Init;
                            CheckLedgEntry."Bank Account No." := BankAcc2."No.";
                            CheckLedgEntry."Posting Date" := GenJnlLine."Posting Date";
                            CheckLedgEntry."Document Type" := GenJnlLine."Document Type";
                            CheckLedgEntry."Document No." := UseCheckNo;
                            CheckLedgEntry.Description := CheckToAddr[1];
                            CheckLedgEntry."Bank Payment Type" := GenJnlLine."Bank Payment Type";
                            CheckLedgEntry."Bal. Account Type" := "Gen. Journal Account Type".FromInteger(BalancingType);
                            CheckLedgEntry."Bal. Account No." := BalancingNo;
                            if FoundLast then begin
                                if TotalLineAmount < 0 then
                                    Error(
                                        Text020,
                                        UseCheckNo, TotalLineAmount);
                                CheckLedgEntry."Entry Status" := CheckLedgEntry."Entry Status"::Printed;
                                CheckLedgEntry.Amount := TotalLineAmount;
                            end else begin
                                CheckLedgEntry."Entry Status" := CheckLedgEntry."Entry Status"::Voided;
                                CheckLedgEntry.Amount := 0;
                            end;
                            CheckLedgEntry."Check Date" := GenJnlLine."Posting Date";
                            CheckLedgEntry."Check No." := UseCheckNo;
                            CheckManagement.InsertCheck(CheckLedgEntry, RecordId);

                            if FoundLast then begin
                                if BankAcc2."Currency Code" <> '' then
                                    Currency.Get(BankAcc2."Currency Code")
                                else
                                    Currency.InitRoundingPrecision;
                                //MOI - 22/01/2015:Inicio
                                CheckAmountText := Format(Round(CheckLedgEntry.Amount, 0.01, '='), 0, 0);

                                if CheckLedgEntry.Amount = Round(CheckLedgEntry.Amount, 1, '=') then
                                    CheckAmountText += '.00'
                                else
                                    if CheckLedgEntry.Amount = Round(CheckLedgEntry.Amount, 0.1, '=') then
                                        CheckAmountText += '0';


                                //MOI - 22/01/2015:Fin
                                /*
                                Decimals := CheckLedgEntry.Amount - ROUND(CheckLedgEntry.Amount,1,'<');

                                IF STRLEN(FORMAT(Decimals)) < STRLEN(FORMAT(Currency."Amount Rounding Precision")) THEN
                                    IF Decimals = 0 THEN
                                    CheckAmountText := FORMAT(Round(CheckLedgEntry.Amount,0.01,'='),0,0) +
                            //            PADSTR('',STRLEN(FORMAT(Currency."Amount Rounding Precision"))-4,'0')//MOI - 16/01/2015(#9514)
                                    ELSE
                                    //MOI - 16/01/2015(#9514)
                                    BEGIN
                                    IF STRLEN(FORMAT(Currency."Amount Rounding Precision"))<>4 THEN
                                        CheckAmountText := FORMAT(CheckLedgEntry.Amount,0,0) +//MOI - 16/01/2015(#9514)
                                        PADSTR('',STRLEN(FORMAT(Currency."Amount Rounding Precision"))-STRLEN(FORMAT(Decimals,0,0)),'0')
                                    ELSE
                                        CheckAmountText := FORMAT(CheckLedgEntry.Amount,0,0) +//MOI - 16/01/2015(#9514)
                                        PADSTR('',STRLEN(FORMAT(Currency."Amount Rounding Precision")));
                                    END
                                    //MOI - 16/01/2015(#9514)

                                ELSE
                                    CheckAmountText := FORMAT(CheckLedgEntry.Amount,0,0);
                                */
                                if CheckLanguage = 3084 then begin   // French
                                    DollarSignBefore := '';
                                    DollarSignAfter := Currency.Symbol;
                                end else begin
                                    DollarSignBefore := Currency.Symbol;
                                    DollarSignAfter := ' ';
                                end;
                                // if not ChkTransMgt.FormatNoText(DescriptionLine, CheckLedgEntry.Amount, CheckLanguage, BankAcc2."Currency Code") then
                                //     Error(DescriptionLine[1]);
                                VoidText := '';
                            end else begin
                                Clear(CheckAmountText);
                                Clear(DescriptionLine);
                                DescriptionLine[1] := Text021;
                                DescriptionLine[2] := DescriptionLine[1];
                                VoidText := Text022;
                            end;
                        end else begin
                            CheckLedgEntry.Init;
                            CheckLedgEntry."Bank Account No." := BankAcc2."No.";
                            CheckLedgEntry."Posting Date" := GenJnlLine."Posting Date";
                            CheckLedgEntry."Document No." := UseCheckNo;
                            CheckLedgEntry.Description := Text023;
                            CheckLedgEntry."Bank Payment Type" := "Bank Payment Type"::"Computer Check";
                            CheckLedgEntry."Entry Status" := CheckLedgEntry."Entry Status"::"Test Print";
                            CheckLedgEntry."Check Date" := GenJnlLine."Posting Date";
                            CheckLedgEntry."Check No." := UseCheckNo;
                            CheckManagement.InsertCheck(CheckLedgEntry, RecordId);

                            CheckAmountText := Text024;
                            DescriptionLine[1] := Text025;
                            DescriptionLine[2] := DescriptionLine[1];
                            VoidText := Text022;
                        end;

                        ChecksPrinted := ChecksPrinted + 1;
                        FirstPage := false;

                        Clear(PrnChkCompanyAddr);
                        Clear(PrnChkCheckToAddr);
                        Clear(PrnChkCheckNoText);
                        Clear(PrnChkCheckDateText);
                        Clear(PrnChkDescriptionLine);
                        Clear(PrnChkVoidText);
                        Clear(PrnChkDateIndicator);
                        Clear(PrnChkCurrencyCode);
                        Clear(PrnChkCheckAmountText);
                        CopyArray(PrnChkCompanyAddr[CheckStyle], CompanyAddr, 1);
                        CopyArray(PrnChkCheckToAddr[CheckStyle], CheckToAddr, 1);
                        PrnChkCheckNoText[CheckStyle] := CheckNoText;
                        PrnChkCheckDateText[CheckStyle] := CheckDateText;
                        CopyArray(PrnChkDescriptionLine[CheckStyle], DescriptionLine, 1);
                        PrnChkVoidText[CheckStyle] := VoidText;
                        PrnChkDateIndicator[CheckStyle] := DateIndicator;
                        PrnChkCurrencyCode[CheckStyle] := BankAcc2."Currency Code";
                        StartingLen := StrLen(CheckAmountText);
                        if CheckStyle = CheckStyle::US then
                            ControlLen := 27
                        else
                            ControlLen := 29;
                        CheckAmountText := CheckAmountText + DollarSignBefore + DollarSignAfter;
                        Index := 0;
                        if CheckAmountText = Text024 then begin
                            if StrLen(CheckAmountText) < (ControlLen - 12) then begin
                                repeat
                                    Index := Index + 1;
                                    CheckAmountText := InsStr(CheckAmountText, '*', StrLen(CheckAmountText) + 1);
                                until (Index = ControlLen) or (StrLen(CheckAmountText) >= (ControlLen - 12))
                            end;
                        end else begin
                            if StrLen(CheckAmountText) < (ControlLen - 11) then begin
                                repeat
                                    Index := Index + 1;
                                    CheckAmountText := InsStr(CheckAmountText, '*', StrLen(CheckAmountText) + 1);
                                until (Index = ControlLen) or (StrLen(CheckAmountText) >= (ControlLen - 11))
                            end;
                        end;
                        // ParagraphHandling.PadStrProportional(
                        //     CheckAmountText + DollarSignBefore + DollarSignAfter, ControlLen, 10, '*');
                        CheckAmountText :=
                            DelStr(CheckAmountText, StartingLen + 1, StrLen(DollarSignBefore + DollarSignAfter));
                        NewLen := StrLen(CheckAmountText);
                        if NewLen <> StartingLen then
                            CheckAmountText :=
                                CopyStr(CheckAmountText, StartingLen + 1) +
                                CopyStr(CheckAmountText, 1, StartingLen);
                        PrnChkCheckAmountText[CheckStyle] :=
                            DollarSignBefore + CheckAmountText + DollarSignAfter;

                        CheckStyleIndex := CheckStyle;

                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    if FoundLast then
                        CurrReport.Break;

                    UseCheckNo := IncStr(UseCheckNo);
                    if not TestPrint then
                        CheckNoText := UseCheckNo
                    else
                        CheckNoText := Text011;
                end;

                trigger OnPostDataItem()
                begin
                    if not TestPrint then begin
                        if UseCheckNo <> GenJnlLine."Document No." then begin
                            GenJnlLine3.Reset;
                            GenJnlLine3.SetCurrentKey("Journal Template Name", "Journal Batch Name", "Posting Date", "Document No.");
                            GenJnlLine3.SetRange("Journal Template Name", GenJnlLine."Journal Template Name");
                            GenJnlLine3.SetRange("Journal Batch Name", GenJnlLine."Journal Batch Name");
                            GenJnlLine3.SetRange("Posting Date", GenJnlLine."Posting Date");
                            GenJnlLine3.SetRange("Document No.", UseCheckNo);
                            if GenJnlLine3.Find('-') then
                                GenJnlLine3.FieldError("Document No.", StrSubstNo(Text013, UseCheckNo));
                        end;

                        if ApplyMethod <> ApplyMethod::MoreLinesOneEntry then begin
                            GenJnlLine3 := GenJnlLine;
                            GenJnlLine3.TestField("Posting No. Series", '');
                            GenJnlLine3."Document No." := UseCheckNo;
                            GenJnlLine3."Check Printed" := true;
                            GenJnlLine3.Modify;
                        end else begin
                            "TotalLineAmount$" := 0;
                            if GenJnlLine2.Find('-') then begin
                                HighestLineNo := GenJnlLine2."Line No.";
                                repeat
                                    if GenJnlLine2."Line No." > HighestLineNo then
                                        HighestLineNo := GenJnlLine2."Line No.";
                                    GenJnlLine3 := GenJnlLine2;
                                    GenJnlLine3.TestField("Posting No. Series", '');
                                    GenJnlLine3."Bal. Account No." := '';
                                    GenJnlLine3."Bank Payment Type" := GenJnlLine3."Bank Payment Type"::" ";
                                    GenJnlLine3."Document No." := UseCheckNo;
                                    GenJnlLine3."Check Printed" := true;
                                    GenJnlLine3.Validate(Amount);
                                    "TotalLineAmount$" := "TotalLineAmount$" + GenJnlLine3."Amount (LCY)";
                                    GenJnlLine3.Modify;
                                until GenJnlLine2.Next = 0;
                            end;

                            GenJnlLine3.Reset;
                            GenJnlLine3 := GenJnlLine;
                            GenJnlLine3.SetRange("Journal Template Name", GenJnlLine."Journal Template Name");
                            GenJnlLine3.SetRange("Journal Batch Name", GenJnlLine."Journal Batch Name");
                            GenJnlLine3."Line No." := HighestLineNo;
                            if GenJnlLine3.Next = 0 then
                                GenJnlLine3."Line No." := HighestLineNo + 10000
                            else begin
                                while GenJnlLine3."Line No." = HighestLineNo + 1 do begin
                                    HighestLineNo := GenJnlLine3."Line No.";
                                    if GenJnlLine3.Next = 0 then
                                        GenJnlLine3."Line No." := HighestLineNo + 20000;
                                end;
                                GenJnlLine3."Line No." := (GenJnlLine3."Line No." + HighestLineNo) div 2;
                            end;
                            GenJnlLine3.Init;
                            GenJnlLine3.Validate("Posting Date", GenJnlLine."Posting Date");
                            GenJnlLine3."Document Type" := GenJnlLine."Document Type";
                            GenJnlLine3."Document No." := UseCheckNo;
                            GenJnlLine3."Account Type" := GenJnlLine3."Account Type"::"Bank Account";
                            GenJnlLine3.Validate("Account No.", BankAcc2."No.");
                            if BalancingType <> BalancingType::"G/L Account" then
                                GenJnlLine3.Description := StrSubstNo(Text014, SelectStr(BalancingType + 1, Text062), BalancingNo);
                            GenJnlLine3.Validate(Amount, -TotalLineAmount);
                            if TotalLineAmount <> "TotalLineAmount$" then
                                GenJnlLine3.Validate("Amount (LCY)", -"TotalLineAmount$");
                            GenJnlLine3."Bank Payment Type" := GenJnlLine3."Bank Payment Type"::"Computer Check";
                            GenJnlLine3."Check Printed" := true;
                            GenJnlLine3."Source Code" := GenJnlLine."Source Code";
                            GenJnlLine3."Reason Code" := GenJnlLine."Reason Code";
                            GenJnlLine3."Allow Zero-Amount Posting" := true;
                            GenJnlLine3.Insert;
                        end;
                    end;

                    BankAcc2."Last Check No." := UseCheckNo;
                    BankAcc2.Modify;
                    if CommitEachCheck then begin
                        Commit;
                        Clear(CheckManagement);
                    end;
                end;

                trigger OnPreDataItem()
                begin
                    FirstPage := true;
                    FoundLast := false;
                    TotalLineAmount := 0;
                    TotalLineDiscount := 0;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                if OneCheckPrVendor and (GenJnlLine."Currency Code" <> '') and
                   (GenJnlLine."Currency Code" <> Currency.Code)
                then begin
                    Currency.Get(GenJnlLine."Currency Code");
                    Currency.TestField("Conv. LCY Rndg. Debit Acc.");
                    Currency.TestField("Conv. LCY Rndg. Credit Acc.");
                end;

                if not TestPrint then begin
                    if Amount = 0 then
                        CurrReport.Skip;

                    TestField("Bal. Account Type", "Bal. Account Type"::"Bank Account");
                    if "Bal. Account No." <> BankAcc2."No." then
                        CurrReport.Skip;

                    if ("Account No." <> '') and ("Bal. Account No." <> '') then begin
                        BalancingType := "Account Type".AsInteger();
                        BalancingNo := "Account No.";
                        RemainingAmount := Amount;
                        if OneCheckPrVendor then begin
                            ApplyMethod := ApplyMethod::MoreLinesOneEntry;
                            GenJnlLine2.Reset;
                            GenJnlLine2.SetCurrentKey("Journal Template Name", "Journal Batch Name", "Posting Date", "Document No.");
                            GenJnlLine2.SetRange("Journal Template Name", "Journal Template Name");
                            GenJnlLine2.SetRange("Journal Batch Name", "Journal Batch Name");
                            GenJnlLine2.SetRange("Posting Date", "Posting Date");
                            GenJnlLine2.SetRange("Document No.", "Document No.");
                            GenJnlLine2.SetRange("Account Type", "Account Type");
                            GenJnlLine2.SetRange("Account No.", "Account No.");
                            GenJnlLine2.SetRange("Bal. Account Type", "Bal. Account Type");
                            GenJnlLine2.SetRange("Bal. Account No.", "Bal. Account No.");
                            GenJnlLine2.SetRange("Bank Payment Type", "Bank Payment Type");
                            GenJnlLine2.Find('-');
                            RemainingAmount := 0;
                        end else
                            if "Applies-to Doc. No." <> '' then
                                ApplyMethod := ApplyMethod::OneLineOneEntry
                            else
                                if "Applies-to ID" <> '' then
                                    ApplyMethod := ApplyMethod::OneLineID
                                else
                                    ApplyMethod := ApplyMethod::Payment;
                    end else
                        if "Account No." = '' then
                            FieldError("Account No.", Text004)
                        else
                            FieldError("Bal. Account No.", Text004);

                    Clear(CheckToAddr);
                    ContactText := '';
                    Clear(SalesPurchPerson);
                    case BalancingType of
                        BalancingType::"G/L Account":
                            begin
                                CheckToAddr[1] := GenJnlLine.Description;
                                // SetCheckPrintParams(
                                //   BankAcc2."Check Date Format",
                                //   BankAcc2."Check Date Separator",
                                //   BankAcc2."Country/Region Code",
                                //   BankAcc2."Bank Communication");
                            end;
                        BalancingType::Customer:
                            begin
                                Cust.Get(BalancingNo);
                                if Cust.Blocked = Cust.Blocked::All then
                                    Error(Text064, Cust.FieldCaption(Blocked), Cust.Blocked, Cust.TableCaption, Cust."No.");
                                Cust.Contact := '';
                                FormatAddr.Customer(CheckToAddr, Cust);
                                if BankAcc2."Currency Code" <> "Currency Code" then
                                    Error(Text005);
                                if Cust."Salesperson Code" <> '' then begin
                                    ContactText := Text006;
                                    SalesPurchPerson.Get(Cust."Salesperson Code");
                                end;
                                // SetCheckPrintParams(
                                // Cust."Check Date Format",
                                // Cust."Check Date Separator",
                                // BankAcc2."Country/Region Code",
                                // Cust."Bank Communication");
                            end;
                        BalancingType::Vendor:
                            begin
                                Vend.Get(BalancingNo);
                                if Vend.Blocked in [Vend.Blocked::All, Vend.Blocked::Payment] then
                                    Error(Text064, Vend.FieldCaption(Blocked), Vend.Blocked, Vend.TableCaption, Vend."No.");
                                Vend.Contact := '';
                                FormatAddr.Vendor(CheckToAddr, Vend);
                                if BankAcc2."Currency Code" <> "Currency Code" then
                                    Error(Text005);
                                if Vend."Purchaser Code" <> '' then begin
                                    ContactText := Text007;
                                    SalesPurchPerson.Get(Vend."Purchaser Code");
                                end;
                                // SetCheckPrintParams(
                                //   Vend."Check Date Format",
                                //   Vend."Check Date Separator",
                                //   BankAcc2."Country/Region Code",
                                //   Vend."Bank Communication");
                            end;
                        BalancingType::"Bank Account":
                            begin
                                BankAcc.Get(BalancingNo);
                                BankAcc.TestField(Blocked, false);
                                BankAcc.Contact := '';
                                FormatAddr.BankAcc(CheckToAddr, BankAcc);
                                if BankAcc2."Currency Code" <> BankAcc."Currency Code" then
                                    Error(Text008);
                                if BankAcc."Our Contact Code" <> '' then begin
                                    ContactText := Text009;
                                    SalesPurchPerson.Get(BankAcc."Our Contact Code");
                                end;
                                // SetCheckPrintParams(
                                //   BankAcc."Check Date Format",
                                //   BankAcc."Check Date Separator",
                                //   BankAcc2."Country/Region Code",
                                //   BankAcc."Bank Communication");
                            end;
                    end;

                    // CheckDateText :=
                    //   ChkTransMgt.FormatDate("Posting Date", CheckDateFormat, DateSeparator, CheckLanguage, DateIndicator);
                end else begin
                    if ChecksPrinted > 0 then
                        CurrReport.Break;
                    // SetCheckPrintParams(
                    //   BankAcc2."Check Date Format",
                    //   BankAcc2."Check Date Separator",
                    //   BankAcc2."Country/Region Code",
                    //   BankAcc2."Bank Communication");
                    BalancingType := BalancingType::Vendor;
                    BalancingNo := Text010;
                    Clear(CheckToAddr);
                    for i := 1 to 5 do
                        CheckToAddr[i] := Text003;
                    ContactText := '';
                    Clear(SalesPurchPerson);
                    CheckNoText := Text011;
                    if CheckStyle = CheckStyle::CA then
                        CheckDateText := DateIndicator
                    else
                        CheckDateText := Text010;
                end;
            end;

            trigger OnPreDataItem()
            begin
                GenJnlLine.Copy(VoidGenJnlLine);
                CompanyInfo.Get;
                if not TestPrint then begin
                    FormatAddr.Company(CompanyAddr, CompanyInfo);
                    BankAcc2.Get(BankAcc2."No.");
                    BankAcc2.TestField(Blocked, false);
                    Copy(VoidGenJnlLine);
                    SetRange("Bank Payment Type", "Bank Payment Type"::"Computer Check");
                    SetRange("Check Printed", false);
                end else begin
                    Clear(CompanyAddr);
                    for i := 1 to 5 do
                        CompanyAddr[i] := Text003;
                end;
                ChecksPrinted := 0;

                SetRange("Account Type", GenJnlLine."Account Type"::"Fixed Asset");
                if Find('-') then
                    GenJnlLine.FieldError("Account Type");
                SetRange("Account Type");
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field("BankAcc2.""No."""; BankAcc2."No.")
                    {
                        applicationArea = Basic, Suite;
                        Caption = 'Bank Account';
                        TableRelation = "Bank Account";

                        trigger OnValidate()
                        begin
                            if BankAcc2."No." <> '' then begin
                                BankAcc2.Get(BankAcc2."No.");
                                BankAcc2.TestField("Last Check No.");
                                UseCheckNo := BankAcc2."Last Check No.";
                            end;
                        end;
                    }
                    field(UseCheckNo; UseCheckNo)
                    {
                        ApplicationArea = All;
                        Caption = 'Last Check No.';
                    }
                    field(OneCheckPrVendor; OneCheckPrVendor)
                    {
                        ApplicationArea = All;
                        Caption = 'One Check per Vendor per Document No.';
                        MultiLine = true;
                    }
                    field(ReprintChecks; ReprintChecks)
                    {
                        ApplicationArea = All;
                        Caption = 'Reprint Checks';
                    }
                    field(TestPrint; TestPrint)
                    {
                        ApplicationArea = All;
                        Caption = 'Test Print';
                    }
                    field(PreprintedStub; PreprintedStub)
                    {
                        ApplicationArea = All;
                        Caption = 'Preprinted Stub';
                    }
                    field(CommitEachCheck; CommitEachCheck)
                    {
                        ApplicationArea = All;
                        Caption = 'Commit Each Check';
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            if BankAcc2."No." <> '' then begin
                if BankAcc2.Get(BankAcc2."No.") then
                    UseCheckNo := BankAcc2."Last Check No."
                else begin
                    BankAcc2."No." := '';
                    UseCheckNo := '';
                end;
            end;
        end;
    }

    labels
    {
    }

    trigger OnPreReport()
    begin

        GenJnlTemplate.Get(VoidGenJnlLine.GetFilter("Journal Template Name"));
        if not GenJnlTemplate."Force Doc. Balance" then
            if not Confirm(USText001, true) then
                Error(USText002);

        PageNo := 0;

        CompanyInfo.Get;
    end;

    var
        Text000: Label 'Preview is not allowed.';
        Text001: Label 'Last Check No. must be filled in.';
        Text002: Label 'Filters on %1 and %2 are not allowed.';
        Text003: Label 'XXXXXXXXXXXXXXXX';
        Text004: Label 'must be entered.';
        Text005: Label 'The Bank Account and the General Journal Line must have the same currency.';
        Text006: Label 'Salesperson';
        Text007: Label 'Purchaser';
        Text008: Label 'Both Bank Accounts must have the same currency.';
        Text009: Label 'Our Contact';
        Text010: Label 'XXXXXXXXXX';
        Text011: Label 'XXXX';
        Text012: Label 'XX.XXXXXXXXXX.XXXX';
        Text013: Label '%1 already exists.';
        Text014: Label 'Check for %1 %2';
        Text015: Label 'Payment';
        Text016: Label 'In the Check report, One Check per Vendor and Document No.\';
        Text017: Label 'must not be activated when Applies-to ID is specified in the journal lines.';
        Text018: Label 'XXX';
        Text019: Label 'Total';
        Text020: Label 'The total amount of check %1 is %2. The amount must be positive.';
        Text021: Label 'VOID VOID VOID VOID VOID VOID VOID VOID VOID VOID VOID VOID VOID VOID VOID VOID';
        Text022: Label 'NON-NEGOTIABLE';
        Text023: Label 'Test print';
        Text024: Label 'XXXX.XX';
        Text025: Label 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX';
        Text030: Label ' is already applied to %1 %2 for customer %3.';
        Text031: Label ' is already applied to %1 %2 for vendor %3.';
        CompanyInfo: Record "Company Information";
        SalesPurchPerson: Record "Salesperson/Purchaser";
        GenJnlLine2: Record "Gen. Journal Line";
        GenJnlLine3: Record "Gen. Journal Line";
        Cust: Record Customer;
        CustLedgEntry: Record "Cust. Ledger Entry";
        Vend: Record Vendor;
        VendLedgEntry: Record "Vendor Ledger Entry";
        BankAcc: Record "Bank Account";
        BankAcc2: Record "Bank Account";
        CheckLedgEntry: Record "Check Ledger Entry";
        Currency: Record Currency;
        GenJnlTemplate: Record "Gen. Journal Template";
        WindowsLang: Record "Windows Language";
        FormatAddr: Codeunit "Format Address";
        CheckManagement: Codeunit CheckManagement;
        //ParagraphHandling: Codeunit "Paragraph Handling";
        //ChkTransMgt: Report "Check Translation Management";
        CompanyAddr: array[8] of Text[100];
        CheckToAddr: array[8] of Text[100];
        BalancingType: Option "G/L Account",Customer,Vendor,"Bank Account";
        BalancingNo: Code[20];
        ContactText: Text[30];
        CheckNoText: Text[30];
        CheckDateText: Text[30];
        CheckAmountText: Text[30];
        DescriptionLine: array[2] of Text[80];
        DocType: Text[30];
        DocNo: Text[30];
        ExtDocNo: Text[30];
        VoidText: Text[30];
        LineAmount: Decimal;
        LineDiscount: Decimal;
        TotalLineAmount: Decimal;
        "TotalLineAmount$": Decimal;
        TotalLineDiscount: Decimal;
        RemainingAmount: Decimal;
        CurrentLineAmount: Decimal;
        UseCheckNo: Code[20];
        FoundLast: Boolean;
        ReprintChecks: Boolean;
        TestPrint: Boolean;
        FirstPage: Boolean;
        OneCheckPrVendor: Boolean;
        FoundNegative: Boolean;
        CommitEachCheck: Boolean;
        ApplyMethod: Option Payment,OneLineOneEntry,OneLineID,MoreLinesOneEntry;
        ChecksPrinted: Integer;
        HighestLineNo: Integer;
        PreprintedStub: Boolean;
        TotalText: Text[10];
        DocDate: Date;
        i: Integer;
        CurrencyCode2: Code[10];
        NetAmount: Text[30];
        CurrencyExchangeRate: Record "Currency Exchange Rate";
        LineAmount2: Decimal;
        Text063: Label 'Net Amount %1';
        GLSetup: Record "General Ledger Setup";
        Text064: Label '%1 must not be %2 for %3 %4.';
        Text062: Label 'G/L Account,Customer,Vendor,Bank Account';
        USText001: Label 'Warning:  Checks cannot be financially voided when Force Doc. Balance is set to No in the Journal Template.  Do you want to continue anyway?';
        USText002: Label 'Process canceled at user request.';
        USText003: Label '%1 must not be %2 on %3 %4.';
        USText004: Label 'Last Check No. must include at least one digit, so that it can be incremented.';
        USText005: Label '%1 language is not enabled. %2 is set up for checks in %1.';
        DateIndicator: Text[10];
        CheckDateFormat: Option " ","MM DD YYYY","DD MM YYYY","YYYY MM DD";
        CheckStyle: Option ,US,CA;
        CheckLanguage: Integer;
        DateSeparator: Option " ","-",".","/";
        DollarSignBefore: Code[5];
        DollarSignAfter: Code[5];
        PrnChkCompanyAddr: array[2, 8] of Text[50];
        PrnChkCheckToAddr: array[2, 8] of Text[50];
        PrnChkCheckNoText: array[2] of Text[30];
        PrnChkCheckDateText: array[2] of Text[30];
        PrnChkCheckAmountText: array[2] of Text[30];
        PrnChkDescriptionLine: array[2, 2] of Text[80];
        PrnChkVoidText: array[2] of Text[30];
        PrnChkDateIndicator: array[2] of Text[10];
        PrnChkCurrencyCode: array[2] of Code[10];
        USText006: Label 'You cannot use the <blank> %1 option with a Canadian style check. Please check %2 %3.';
        USText007: Label 'You cannot use the Spanish %1 option with a Canadian style check. Please check %2 %3.';
        PostingDesc: Text[200];
        CompanyAddresses: array[6] of Text[30];
        CheckStyleIndex: Integer;
        BankCurrencyCode: Text[30];
        StartingLen: Integer;
        ControlLen: Integer;
        Index: Integer;
        NewLen: Integer;
        PageNo: Integer;

    local procedure CustUpdateAmounts(var CustLedgEntry2: Record "Cust. Ledger Entry"; RemainingAmount2: Decimal)
    begin
        if (ApplyMethod = ApplyMethod::OneLineOneEntry) or
           (ApplyMethod = ApplyMethod::MoreLinesOneEntry)
        then begin
            GenJnlLine3.Reset;
            GenJnlLine3.SetCurrentKey(
              "Account Type", "Account No.", "Applies-to Doc. Type", "Applies-to Doc. No.");
            GenJnlLine3.SetRange("Account Type", GenJnlLine3."Account Type"::Customer);
            GenJnlLine3.SetRange("Account No.", CustLedgEntry2."Customer No.");
            GenJnlLine3.SetRange("Applies-to Doc. Type", CustLedgEntry2."Document Type");
            GenJnlLine3.SetRange("Applies-to Doc. No.", CustLedgEntry2."Document No.");
            if ApplyMethod = ApplyMethod::OneLineOneEntry then
                GenJnlLine3.SetFilter("Line No.", '<>%1', GenJnlLine."Line No.")
            else
                GenJnlLine3.SetFilter("Line No.", '<>%1', GenJnlLine2."Line No.");
            if CustLedgEntry2."Document Type" <> CustLedgEntry2."Document Type"::" " then
                if GenJnlLine3.Find('-') then
                    GenJnlLine3.FieldError(
                      "Applies-to Doc. No.",
                      StrSubstNo(
                        Text030,
                        CustLedgEntry2."Document Type", CustLedgEntry2."Document No.",
                        CustLedgEntry2."Customer No."));
        end;

        DocType := Format(CustLedgEntry2."Document Type");
        DocNo := CustLedgEntry2."Document No.";
        ExtDocNo := CustLedgEntry2."External Document No.";
        DocDate := CustLedgEntry2."Document Date";
        PostingDesc := CustLedgEntry2.Description;
        CurrencyCode2 := CustLedgEntry2."Currency Code";
        CustLedgEntry2.CalcFields("Remaining Amount");

        LineAmount :=
          -ABSMin(
            CustLedgEntry2."Remaining Amount" -
            CustLedgEntry2."Remaining Pmt. Disc. Possible" -
            CustLedgEntry2."Accepted Payment Tolerance",
            CustLedgEntry2."Amount to Apply");
        LineAmount2 :=
          Round(
            ExchangeAmt(CustLedgEntry2."Posting Date", GenJnlLine."Currency Code", CurrencyCode2, LineAmount),
            Currency."Amount Rounding Precision");

        if ((((CustLedgEntry2."Document Type" = CustLedgEntry2."Document Type"::Invoice) and
              (LineAmount2 >= RemainingAmount2)) or
             ((CustLedgEntry2."Document Type" = CustLedgEntry2."Document Type"::"Credit Memo") and
              (LineAmount2 <= RemainingAmount2)) and
             (GenJnlLine."Posting Date" <= CustLedgEntry2."Pmt. Discount Date")) or
            CustLedgEntry2."Accepted Pmt. Disc. Tolerance")
        then begin
            LineDiscount := -CustLedgEntry2."Remaining Pmt. Disc. Possible";
            if CustLedgEntry2."Accepted Payment Tolerance" <> 0 then
                LineDiscount := LineDiscount - CustLedgEntry2."Accepted Payment Tolerance";
        end else begin
            if RemainingAmount2 >=
               Round(
                 -ExchangeAmt(CustLedgEntry2."Posting Date", GenJnlLine."Currency Code", CurrencyCode2,
                   CustLedgEntry2."Amount to Apply"), Currency."Amount Rounding Precision")
            then
                LineAmount2 :=
                  Round(
                    -ExchangeAmt(CustLedgEntry2."Posting Date", GenJnlLine."Currency Code", CurrencyCode2,
                      CustLedgEntry2."Amount to Apply"), Currency."Amount Rounding Precision")
            else begin
                LineAmount2 := RemainingAmount2;
                LineAmount :=
                  Round(
                    ExchangeAmt(CustLedgEntry2."Posting Date", CurrencyCode2, GenJnlLine."Currency Code",
                      LineAmount2), Currency."Amount Rounding Precision");
            end;
            LineDiscount := 0;
        end;
    end;

    local procedure VendUpdateAmounts(var VendLedgEntry2: Record "Vendor Ledger Entry"; RemainingAmount2: Decimal)
    begin
        if (ApplyMethod = ApplyMethod::OneLineOneEntry) or
           (ApplyMethod = ApplyMethod::MoreLinesOneEntry)
        then begin
            GenJnlLine3.Reset;
            GenJnlLine3.SetCurrentKey(
              "Account Type", "Account No.", "Applies-to Doc. Type", "Applies-to Doc. No.");
            GenJnlLine3.SetRange("Account Type", GenJnlLine3."Account Type"::Vendor);
            GenJnlLine3.SetRange("Account No.", VendLedgEntry2."Vendor No.");
            GenJnlLine3.SetRange("Applies-to Doc. Type", VendLedgEntry2."Document Type");
            GenJnlLine3.SetRange("Applies-to Doc. No.", VendLedgEntry2."Document No.");
            if ApplyMethod = ApplyMethod::OneLineOneEntry then
                GenJnlLine3.SetFilter("Line No.", '<>%1', GenJnlLine."Line No.")
            else
                GenJnlLine3.SetFilter("Line No.", '<>%1', GenJnlLine2."Line No.");
            if VendLedgEntry2."Document Type" <> VendLedgEntry2."Document Type"::" " then
                if GenJnlLine3.Find('-') then
                    GenJnlLine3.FieldError(
                      "Applies-to Doc. No.",
                      StrSubstNo(
                        Text031,
                        VendLedgEntry2."Document Type", VendLedgEntry2."Document No.",
                        VendLedgEntry2."Vendor No."));
        end;

        DocType := Format(VendLedgEntry2."Document Type");
        DocNo := VendLedgEntry2."Document No.";
        ExtDocNo := VendLedgEntry2."External Document No.";
        DocNo := ExtDocNo;
        DocDate := VendLedgEntry2."Document Date";

        PostingDesc := VendLedgEntry2.Description;

        CurrencyCode2 := VendLedgEntry2."Currency Code";
        VendLedgEntry2.CalcFields("Remaining Amount");

        LineAmount :=
          -ABSMin(
            VendLedgEntry2."Remaining Amount" -
            VendLedgEntry2."Remaining Pmt. Disc. Possible" -
            VendLedgEntry2."Accepted Payment Tolerance",
            VendLedgEntry2."Amount to Apply");

        LineAmount2 :=
          Round(
            ExchangeAmt(VendLedgEntry2."Posting Date", GenJnlLine."Currency Code", CurrencyCode2, LineAmount),
            Currency."Amount Rounding Precision");

        if ((((VendLedgEntry2."Document Type" = VendLedgEntry2."Document Type"::Invoice) and
              (LineAmount2 <= RemainingAmount2)) or
             ((VendLedgEntry2."Document Type" = VendLedgEntry2."Document Type"::"Credit Memo") and
              (LineAmount2 >= RemainingAmount2))) and
            (GenJnlLine."Posting Date" <= VendLedgEntry2."Pmt. Discount Date")) or
           VendLedgEntry2."Accepted Pmt. Disc. Tolerance"
        then begin
            LineDiscount := -VendLedgEntry2."Remaining Pmt. Disc. Possible";
            if VendLedgEntry2."Accepted Payment Tolerance" <> 0 then
                LineDiscount := LineDiscount - VendLedgEntry2."Accepted Payment Tolerance";
        end else begin
            if RemainingAmount2 >=
                Round(
                 -(ExchangeAmt(VendLedgEntry2."Posting Date", GenJnlLine."Currency Code", CurrencyCode2,
                   VendLedgEntry2."Amount to Apply")), Currency."Amount Rounding Precision")
             then begin
                LineAmount2 :=
                  Round(
                    -(ExchangeAmt(VendLedgEntry2."Posting Date", GenJnlLine."Currency Code", CurrencyCode2,
                      VendLedgEntry2."Amount to Apply")), Currency."Amount Rounding Precision");
                LineAmount :=
                  Round(
                    ExchangeAmt(VendLedgEntry2."Posting Date", CurrencyCode2, GenJnlLine."Currency Code",
                    LineAmount2), Currency."Amount Rounding Precision");
            end else begin
                LineAmount2 := RemainingAmount2;
                LineAmount :=
                  Round(
                    ExchangeAmt(VendLedgEntry2."Posting Date", CurrencyCode2, GenJnlLine."Currency Code",
                    LineAmount2), Currency."Amount Rounding Precision");
            end;
            LineDiscount := 0;
        end;
    end;


    procedure InitializeRequest(BankAcc: Code[20]; LastCheckNo: Code[20]; NewOneCheckPrVend: Boolean; NewReprintChecks: Boolean; NewTestPrint: Boolean; NewPreprintedStub: Boolean)
    begin
        if BankAcc <> '' then
            if BankAcc2.Get(BankAcc) then begin
                UseCheckNo := LastCheckNo;
                OneCheckPrVendor := NewOneCheckPrVend;
                ReprintChecks := NewReprintChecks;
                TestPrint := NewTestPrint;
                PreprintedStub := NewPreprintedStub;
            end;
    end;


    procedure ExchangeAmt(PostingDate: Date; CurrencyCode: Code[10]; CurrencyCode2: Code[10]; Amount: Decimal) Amount2: Decimal
    begin
        if (CurrencyCode <> '') and (CurrencyCode2 = '') then
            Amount2 :=
              CurrencyExchangeRate.ExchangeAmtLCYToFCY(
                PostingDate, CurrencyCode, Amount, CurrencyExchangeRate.ExchangeRate(PostingDate, CurrencyCode))
        else
            if (CurrencyCode = '') and (CurrencyCode2 <> '') then
                Amount2 :=
                  CurrencyExchangeRate.ExchangeAmtFCYToLCY(
                    PostingDate, CurrencyCode2, Amount, CurrencyExchangeRate.ExchangeRate(PostingDate, CurrencyCode2))
            else
                if (CurrencyCode <> '') and (CurrencyCode2 <> '') and (CurrencyCode <> CurrencyCode2) then
                    Amount2 := CurrencyExchangeRate.ExchangeAmtFCYToFCY(PostingDate, CurrencyCode2, CurrencyCode, Amount)
                else
                    Amount2 := Amount;
    end;


    procedure ABSMin(Decimal1: Decimal; Decimal2: Decimal): Decimal
    begin
        if Abs(Decimal1) < Abs(Decimal2) then
            exit(Decimal1);
        exit(Decimal2);
    end;

    local procedure SetCheckPrintParams(NewDateFormat: Option " ","MM DD YYYY","DD MM YYYY","YYYY MM DD"; NewDateSeparator: Option " ","-",".","/"; NewCountryCode: Code[10]; NewCheckLanguage: Option "E English","F French","S Spanish")
    var
        WindowsLanguage: Record "Windows Language";
    begin
        CheckDateFormat := NewDateFormat;
        DateSeparator := NewDateSeparator;
        case NewCheckLanguage of
            NewCheckLanguage::"E English":
                if NewCountryCode = 'CA' then
                    CheckLanguage := 4105
                else
                    CheckLanguage := 1033;
            NewCheckLanguage::"F French":
                CheckLanguage := 3084;
            NewCheckLanguage::"S Spanish":
                CheckLanguage := 2058;
            else
                CheckLanguage := 1033;
        end;
        CompanyInfo.Get;
        case CompanyInfo.GetCountryRegionCode(NewCountryCode) of
            'US', 'MX':
                CheckStyle := CheckStyle::US;
            'CA':
                CheckStyle := CheckStyle::CA;
            else
                CheckStyle := CheckStyle::US;
        end;
        if CheckLanguage <> WindowsLanguage."Language ID" then
            WindowsLanguage.Get(CheckLanguage);
        if not WindowsLanguage."Globally Enabled" then begin
            if CheckLanguage = 4105 then
                CheckLanguage := 1033
            else
                Error(USText005, WindowsLanguage.Name, CheckToAddr[1]);
        end;
    end;
}

