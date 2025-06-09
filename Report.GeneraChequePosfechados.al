report 55019 "Genera Cheque Posfechados"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem("Cust. Ledger Entry"; "Cust. Ledger Entry")
        {
            DataItemTableView = SORTING ("Customer No.", Open, Positive, "Due Date", "Currency Code") ORDER(Ascending) WHERE ("Cheque Posfechado" = FILTER (true), Open = FILTER (true));
            RequestFilterFields = "Due Date";

            trigger OnAfterGetRecord()
            begin
                Counter := Counter + 1;
                Window.Update(1, "Document No.");
                Window.Update(2, Round(Counter / CounterTotal * 10000, 1));

                GJL1.Reset;
                GJL1.SetRange("Journal Template Name", ConfSant."Libro Diario Cheques Posf.");
                GJL1.SetRange("Journal Batch Name", ConfSant."Seccion Diario Cheques Posf.");
                if GJL1.FindLast then
                    NoLinea := GJL1."Line No."
                else
                    NoLinea := 0;

                NoLinea += 10000;
                GJL.Validate("Journal Template Name", ConfSant."Libro Diario Cheques Posf.");
                GJL.Validate("Journal Batch Name", ConfSant."Seccion Diario Cheques Posf.");
                GJL.Validate("Line No.", NoLinea);
                GJL.Validate("Account Type", GJL."Account Type"::Customer);
                GJL.Validate("Account No.", "Customer No.");
                GJL.Validate("Posting Date", WorkDate);
                GJL.Validate("Document Type", GJL."Document Type"::Payment);
                GJL.Validate("Document No.", "Document No.");
                GJL.Validate("Bal. Account Type", GJL."Bal. Account Type"::"Bank Account");
                GJL.Validate("Bal. Account No.", Banco);
                GJL.Validate("Currency Code", "Currency Code");
                CalcFields("Remaining Amount");
                GJL.Validate(Amount, "Remaining Amount" * -1);
                GJL.Validate("Applies-to Doc. Type", "Document Type");
                GJL.Validate("Applies-to Doc. No.", "Document No.");
                GJL.Insert;
            end;

            trigger OnPostDataItem()
            begin
                Window.Close;
            end;

            trigger OnPreDataItem()
            begin
                ConfSant.Get;
                ConfSant.TestField("Libro Diario Cheques Posf.");
                ConfSant.TestField("Seccion Diario Cheques Posf.");

                CounterTotal := Count;
                Window.Open(Text001);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(Banco; Banco)
                {
                ApplicationArea = All;
                    TableRelation = "Bank Account";
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

    trigger OnPreReport()
    begin
        if "Cust. Ledger Entry".GetFilter("Due Date") = '' then
            Error(Error001, "Cust. Ledger Entry".FieldCaption("Due Date"));
    end;

    var
        Error001: Label '%1 Must be specified';
        ConfSant: Record "Config. Empresa";
        BA: Record "Bank Account";
        Banco: Code[20];
        GJL: Record "Gen. Journal Line";
        GJL1: Record "Gen. Journal Line";
        NoLinea: Integer;
        Window: Dialog;
        CounterTotal: Integer;
        Counter: Integer;
        Text001: Label 'Reading  #1########## @2@@@@@@@@@@@@@';
}

