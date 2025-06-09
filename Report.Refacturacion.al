report 56001 Refacturacion
{
    Caption = 'Re invoice';
    ProcessingOnly = true;

    dataset
    {
        dataitem("Sales Invoice Header"; "Sales Invoice Header")
        {
            DataItemTableView = SORTING("No.") WHERE(Refacturar = CONST(true));
            RequestFilterFields = "No.", "Posting Date";
            dataitem("Sales Invoice Line"; "Sales Invoice Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemTableView = SORTING("Document No.", "Line No.") WHERE(Type = CONST(Item), "No." = FILTER(<> ''));

                trigger OnAfterGetRecord()
                begin

                    BuscaAbono1;

                    //Se crea el Credit memo
                    SL.Init;
                    SL."Document Type" := SH."Document Type";
                    SL."Document No." := SH."No.";
                    SL."Line No." := "Line No.";
                    SL.Validate("Sell-to Customer No.", "Sell-to Customer No.");
                    SL.Type := Type;
                    SL.Validate("No.", "No.");
                    SL.Validate("Location Code", ConfSantillana."Almacen refacturacion");
                    SL.Validate("Unit of Measure", "Unit of Measure");
                    if CantAbono < Quantity then
                        SL.Validate(Quantity, Quantity - CantAbono)
                    else
                        if CantAbono <> Quantity then
                            SL.Validate(Quantity, Abs(Quantity - CantAbono));

                    SL.Validate("Unit Price", "Unit Price");
                    SL.Validate("Line Discount %", "Line Discount %");
                    SL.Validate("Unit Cost (LCY)", "Unit Cost (LCY)");
                    SL."Dimension Set ID" := "Dimension Set ID";
                    if SL.Quantity <> 0 then
                        SL.Insert(true);

                    //Se crea la Factura
                    SL2.Init;
                    SL2."Document Type" := SH2."Document Type";
                    SL2."Document No." := SH2."No.";
                    SL2."Line No." := "Line No.";
                    SL2.Validate("Sell-to Customer No.", "Sell-to Customer No.");
                    SL2.Type := Type;
                    SL2.Validate("No.", "No.");
                    SL2.Validate("Location Code", ConfSantillana."Almacen refacturacion");
                    SL2.Validate("Unit of Measure", "Unit of Measure");
                    if CantAbono < Quantity then
                        SL2.Validate(Quantity, Quantity - CantAbono)
                    else
                        if CantAbono <> Quantity then
                            SL2.Validate(Quantity, Abs(Quantity - CantAbono));
                    SL2.Validate("Unit Price", "Unit Price");
                    SL2.Validate("Line Discount %", "Line Discount %");
                    SL2.Validate("Unit Cost (LCY)", "Unit Cost (LCY)");
                    SL2."Dimension Set ID" := "Dimension Set ID";
                    if SL2.Quantity <> 0 then
                        SL2.Insert(true);
                end;

                trigger OnPreDataItem()
                begin
                    if Filtro <> '' then
                        SetFilter("No.", Filtro);
                end;
            }

            trigger OnAfterGetRecord()
            begin
                Clear(Filtro);
                Counter := Counter + 1;
                Window.Update(1, "No.");
                Window.Update(2, Round(Counter / CounterTotal * 10000, 1));

                CLE.Reset;
                CLE.SetCurrentKey("Customer No.", "Posting Date", "Currency Code");
                CLE.SetRange("Customer No.", "Sell-to Customer No.");
                CLE.SetRange("Posting Date", "Posting Date");
                CLE.SetRange("Document Type", CLE."Document Type"::Invoice);
                CLE.SetRange("Document No.", "No.");
                if CLE.FindFirst then
                    CLE.CalcFields("Original Amount", CLE."Remaining Amount");

                if CLE."Remaining Amount" = 0 then
                    CurrReport.Skip;

                /*GRN
                IF CLE."Original Amount" <> CLE."Remaining Amount" THEN
                   FiltraAbono;
                */

                Clear(SH);
                SH.SetRange("Document Type", SH."Document Type"::"Credit Memo");
                SH.SetRange("Posting Description", StrSubstNo(Text019, "No. Comprobante Fiscal", "No."));
                SH.SetRange("Re facturacion", true);
                if SH.FindFirst then
                    CurrReport.Skip;

                //Se crea el Credit memo
                Clear(SH);
                SH."Document Type" := SH."Document Type"::"Credit Memo";
                SH.Insert(true);
                SH.Validate("Sell-to Customer No.", "Sell-to Customer No.");
                SH.Validate("Posting Date", Today);
                SH.Validate("Location Code", ConfSantillana."Almacen refacturacion");
                SH."Applies-to Doc. Type" := CLE."Document Type";
                SH.Validate("Applies-to Doc. No.", "No.");
                SH.Validate("Salesperson Code", "Sales Invoice Header"."Salesperson Code");
                SH."No. Comprobante Fiscal Rel." := "Sales Invoice Header"."No. Comprobante Fiscal";
                SH."Posting Description" := StrSubstNo(Text019, "No. Comprobante Fiscal", "No.");
                SH."Re facturacion" := true;
                SH."Dimension Set ID" := "Dimension Set ID";
                SH.Modify;

                //Inserto comentario a la Nota de credito
                SCL.Reset;
                SCL.SetRange("Document Type", SCL."Document Type"::"Credit Memo");
                SCL.SetRange("No.", SH."No.");
                SCL.SetRange("Document Line No.", 0);
                if SCL.FindLast then begin
                    SCL.Reset;
                    SCL."Document Type" := SCL."Document Type"::"Credit Memo";
                    SCL."No." := SH."No.";
                    SCL."Document Line No." := 0;
                    SCL."Line No." += 100;
                    SCL.Date := Today;
                    SCL.Comment := StrSubstNo(Text019, "No. Comprobante Fiscal", "No.");
                    SCL.Insert;
                end
                else begin
                    Clear(SCL);
                    SCL."Document Type" := SCL."Document Type"::"Credit Memo";
                    SCL."No." := SH."No.";
                    SCL."Document Line No." := 0;
                    SCL."Line No." += 100;
                    SCL.Date := Today;
                    SCL.Comment := StrSubstNo(Text019, "No. Comprobante Fiscal", "No.");
                    SCL.Insert;
                end;

                //Se crea la Factura
                Clear(SH2);
                SH2."Document Type" := SH."Document Type"::Invoice;
                SH2.Insert(true);
                SH2.Validate("Sell-to Customer No.", "Sell-to Customer No.");
                SH2.Validate("Posting Date", Today);
                SH2.Validate("Location Code", ConfSantillana."Almacen refacturacion");
                SH2."No. Comprobante Fiscal Rel." := "Sales Invoice Header"."No. Comprobante Fiscal";
                SH2."Posting Description" := StrSubstNo(Text018, "No. Comprobante Fiscal", "No.");
                SH2.Validate("Salesperson Code", "Sales Invoice Header"."Salesperson Code");
                SH2."Re facturacion" := true;
                SH2."Dimension Set ID" := "Dimension Set ID";
                SH2.Modify;

                //Inserto comentario a la factura
                SCL.Reset;
                SCL.SetRange("Document Type", SCL."Document Type"::Invoice);
                SCL.SetRange("No.", SH2."No.");
                SCL.SetRange("Document Line No.", 0);
                if SCL.FindLast then begin
                    SCL.Reset;
                    SCL."Document Type" := SCL."Document Type"::Invoice;
                    SCL."No." := SH2."No.";
                    SCL."Document Line No." := 0;
                    SCL."Line No." += 100;
                    SCL.Date := Today;
                    SCL.Comment := StrSubstNo(Text018, "No. Comprobante Fiscal", "No.");
                    SCL.Insert;
                end
                else begin
                    Clear(SCL);
                    SCL."Document Type" := SCL."Document Type"::Invoice;
                    SCL."No." := SH2."No.";
                    SCL."Document Line No." := 0;
                    SCL."Line No." += 100;
                    SCL.Date := Today;
                    SCL.Comment := StrSubstNo(Text018, "No. Comprobante Fiscal", "No.");
                    SCL.Insert;
                end;

            end;

            trigger OnPostDataItem()
            begin
                Window.Close;
            end;

            trigger OnPreDataItem()
            begin
                ConfSantillana.Get();
                ConfSantillana.TestField("Almacen refacturacion");
                ConfSantillana.TestField("Cod. Dimemsion Refacturacion");
                ConfSantillana.TestField("Valor Dimemsion Refacturacion");

                CounterTotal := Count;
                Window.Open(Text001);
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        Text001: Label 'Processing...  #1########## @2@@@@@@@@@@@@@';
        ConfSantillana: Record "Config. Empresa";
        SH: Record "Sales Header";
        SL: Record "Sales Line";
        SH2: Record "Sales Header";
        SL2: Record "Sales Line";
        CLE: Record "Cust. Ledger Entry";
        SCL: Record "Sales Comment Line";
        Filtro: Text[1024];
        Window: Dialog;
        CounterTotal: Integer;
        Counter: Integer;
        cm: Boolean;
        Text003: Label 'The %1 entered must not be before the %2 on the %3.';
        Text006: Label '%1 No. %2 does not have an application entry.';
        Text007: Label 'Do you want to unapply the entries?';
        Text008: Label 'Unapplying and posting...';
        Text009: Label 'The entries were successfully unapplied.';
        Text010: Label 'There is nothing to unapply. ';
        Text011: Label 'To unapply these entries, the program will post correcting entries.\';
        MaxPostingDate: Date;
        Text012: Label 'Before you can unapply this entry, you must first unapply all application entries in %1 No. %2 that were posted after this entry.';
        Text013: Label '%1 is not within your range of allowed posting dates in %2 No. %3.';
        Text014: Label '%1 is not within your range of allowed posting dates.';
        Text015: Label 'The latest %3 must be an application in %1 No. %2.';
        Text016: Label 'You cannot unapply the entry with the posting date %1, because the exchange rate for the additional reporting currency has been changed. ';
        Text017: Label 'You cannot unapply %1 No. %2 because the entry has been involved in a reversal.';
        CantAbono: Decimal;
        Text018: Label 'Void invoice %1, %2 by change of date';
        Text019: Label 'Apply to Inv. %1 %2 by Change of date';


    procedure FiltraAbono()
    var
        CLE2: Record "Cust. Ledger Entry";
        DCLE: Record "Detailed Cust. Ledg. Entry";
        CML: Record "Sales Cr.Memo Line";
        FirstTime: Boolean;
    begin
        FirstTime := true;
        DCLE.Reset;
        DCLE.SetCurrentKey("Cust. Ledger Entry No.", "Posting Date");
        DCLE.SetRange("Cust. Ledger Entry No.", CLE."Entry No.");
        DCLE.SetRange("Document Type", DCLE."Document Type"::"Credit Memo");
        if DCLE.FindSet then
            repeat
                CML.SetRange("Document No.", DCLE."Document No.");
                CML.SetRange(Type, CML.Type::Item);
                CML.SetFilter("No.", '<>%1', '');
                if CML.FindSet then
                    repeat
                        if FirstTime then begin
                            if StrPos(Filtro, CML."No.") = 0 then
                                Filtro := '<>' + CML."No.";
                            FirstTime := false;
                        end
                        else
                            if StrPos(Filtro, CML."No.") = 0 then
                                Filtro += '&<>' + CML."No.";
                    until CML.Next = 0;
            until DCLE.Next = 0;
    end;


    procedure BuscaAbono()
    var
        ILE: Record "Item Ledger Entry";
        VE: Record "Value Entry";
        VE2: Record "Value Entry";
    begin
        VE.Reset;
        VE.SetCurrentKey("Document No.");
        VE.SetRange("Document No.", "Sales Invoice Line"."Document No.");
        VE.SetRange("Item No.", "Sales Invoice Line"."No.");
        if VE.FindFirst then begin
            ILE.Get(VE."Item Ledger Entry No.");
            VE2.Reset;
            VE2.SetCurrentKey("Item Ledger Entry No.", "Document Type");

        end;
    end;


    procedure BuscaAbono1()
    var
        SCMH: Record "Sales Cr.Memo Header";
        SCML: Record "Sales Cr.Memo Line";
    begin
        CantAbono := 0;
        SCMH.Reset;
        SCMH.SetCurrentKey("Applies-to Doc. Type", "Applies-to Doc. No.");
        SCMH.SetRange("Applies-to Doc. Type", SCMH."Applies-to Doc. Type"::Invoice);
        SCMH.SetRange("Applies-to Doc. No.", "Sales Invoice Header"."No.");
        if SCMH.FindSet then
            repeat
                SCML.Reset;
                SCML.SetRange("Document No.", SCMH."No.");
                SCML.SetRange(Type, SCML.Type::Item);
                SCML.SetRange("No.", "Sales Invoice Line"."No.");
                if SCML.FindSet then
                    repeat
                        CantAbono += SCML.Quantity;
                    until SCML.Next = 0;
            until SCMH.Next = 0;
    end;


    procedure BuscaIAE()
    var
        IAE: Record "Item Application Entry";
    begin
        /*iac.reset;
        iae.setcurrentkey("Outbound Item Entry No.","Item Ledger Entry No.","Cost Application","Transferred-from Entry No.");
        IAE.setrange("Outbound Item Entry No.",
        */

    end;
}

