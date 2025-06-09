report 76055 "Proceso Gtos. Nomina"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem("G/L Entry"; "G/L Entry")
        {
            DataItemTableView = SORTING("G/L Account No.", "Posting Date");
            RequestFilterFields = "G/L Account No.", "Posting Date";

            trigger OnAfterGetRecord()
            begin
                Counter := Counter + 1;
                Window.Update(1, "Entry No.");
                Window.Update(2, Round(Counter / CounterTotal * 10000, 1));
                /*
                LED.RESET;
                LED.SETRANGE("Table ID",17);
                LED.SETRANGE("Entry No.","Entry No.");
                LED.SETRANGE("Dimension Code",CodDimension);
                LED.SETRANGE("Dimension Value Code",CodValorDim);
                IF LED.FINDSET THEN
                   REPEAT
                    GenJnlLine2.RESET;
                    GenJnlLine2.SETRANGE("Journal Template Name",CodigoDiario);
                    GenJnlLine2.SETRANGE("Journal Batch Name",CodigoSeccion);
                    IF GenJnlLine2.FINDLAST THEN;
                    GenJnlLine2."Line No." += 1000;
                
                    CLEAR(GenJnlLine);
                    GenJnlLine.VALIDATE("Journal Template Name",CodigoDiario);
                    GenJnlLine.VALIDATE("Journal Batch Name",CodigoSeccion);
                    GenJnlLine."Line No." := GenJnlLine2."Line No.";
                    GenJnlLine."Account Type" := GenJnlLine."Account Type"::"G/L Account";
                    GenJnlLine.VALIDATE("Account No.","G/L Account No.");
                    GenJnlLine.VALIDATE("Posting Date",WORKDATE);
                    GenJnlLine."Document Type" := GenJnlLine."Document Type"::Payment;
                //    GenJnlLine."Document No."  :=
                    GenJnlLine.Description := Text002 + CodDimension;
                    GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"Bank Account";
                    GenJnlLine.VALIDATE("Bal. Account No.",CodigoBanco);
                    GenJnlLine.VALIDATE(Amount,Amount *-1);
                    GenJnlLine.INSERT(TRUE);
                
                    LED2.RESET;
                    LED2.SETRANGE("Table ID",17);
                    LED2.SETRANGE("Entry No.","Entry No.");
                    IF LED2.FINDSET THEN
                       REPEAT
                        JnlLDim.INIT;
                        JnlLDim."Table ID" := 81;
                        JnlLDim."Journal Template Name" := CodigoDiario;
                        JnlLDim."Journal Batch Name"    := CodigoSeccion;
                        JnlLDim."Journal Line No."      := GenJnlLine."Line No.";
                        JnlLDim."Dimension Code"        := LED2."Dimension Code";
                        JnlLDim.VALIDATE("Dimension Value Code",LED2."Dimension Value Code");
                        JnlLDim.INSERT(TRUE);
                       UNTIL LED2.NEXT = 0;
                   UNTIL LED.NEXT =0;
                */

            end;

            trigger OnPostDataItem()
            begin
                Window.Close;
            end;

            trigger OnPreDataItem()
            begin
                Window.Open(Text001);
                CounterTotal := Count;
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
                group(Control1000000001)
                {
                    ShowCaption = false;
                    field(Dimension; CodDimension)
                    {
                    ApplicationArea = All;
                        Caption = 'Dimension Code';
                        TableRelation = Dimension;
                    }
                    field("Valor dimension"; CodValorDim)
                    {
                    ApplicationArea = All;
                        Caption = 'Dimension Value Code';

                        trigger OnLookup(var Text: Text): Boolean
                        var
                            DimForm: Page "Dimension Value List";
                        begin
                            DimVal.Reset;
                            DimVal.SetRange("Dimension Code", CodDimension);
                            DimVal.SetRange("Dimension Value Type", DimVal."Dimension Value Type"::Standard);
                            DimForm.SetTableView(DimVal);
                            DimForm.SetRecord(DimVal);
                            DimForm.LookupMode(true);
                            if DimForm.RunModal = ACTION::LookupOK then begin
                                DimForm.GetRecord(DimVal);
                                CodValorDim := DimVal.Code;
                            end;

                            Clear(DimForm);
                        end;

                        trigger OnValidate()
                        begin
                            DimVal.Get(CodDimension, CodValorDim);
                        end;
                    }
                    field(Banco; CodigoBanco)
                    {
                    ApplicationArea = All;
                        Caption = 'Bank Account';
                        //Comentado OptionCaption = 'Bank Account';
                        TableRelation = "Bank Account";
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        GenJnlLine: Record "Gen. Journal Line";
        GenJnlLine2: Record "Gen. Journal Line";
        GLE: Record "G/L Entry";
        CodigoDiario: Code[20];
        CodigoSeccion: Code[20];
        CodDimension: Code[20];
        CodValorDim: Code[20];
        ConceptoSalarial: Code[20];
        CodigoBanco: Code[20];
        Window: Dialog;
        CounterTotal: Integer;
        Counter: Integer;
        Text001: Label 'Processing  #1########## @2@@@@@@@@@@@@@';
        Text002: Label 'Transfer of ';
        DimVal: Record "Dimension Value";


    procedure RecibeParametros(CodDiario: Code[20]; CodSeccion: Code[20])
    begin
        CodigoDiario := CodDiario;
        CodigoSeccion := CodSeccion;
    end;
}

