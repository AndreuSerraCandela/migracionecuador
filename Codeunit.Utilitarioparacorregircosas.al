codeunit 55008 "Utilitario para corregir cosas"
{
    Permissions = TableData "G/L Entry" = rimd,
                  TableData "Cust. Ledger Entry" = rimd,
                  TableData "Purch. Inv. Header" = rimd,
                  TableData "Value Entry" = rm,
                  TableData "Retencion Doc. Reg. Prov." = rimd;

    trigger OnRun()
    begin
        //CorrigeNom;
        //CorrigeNCFCompras;
        //actfechavencmovcliente;
        //MarcarCorrecionCompras;

        //CorrigeVEGE;
        //ActualizaProveedor;

        //ActMovProveedor;

        //AcTMovCliente;

        CorrigeProd;
    end;

    var
        Item: Record Item;

    local procedure AcTMovCliente()
    var
        DCLE: Record "Detailed Cust. Ledg. Entry";
    begin

        DCLE.Reset;
        //DCLE.SETRANGE("Cust. Ledger Entry No.",21203015);
        if DCLE.FindSet then
            repeat
                DCLE."Ledger Entry Amount" := not ((DCLE."Entry Type" = DCLE."Entry Type"::Application) or
                (DCLE."Entry Type" = DCLE."Entry Type"::"Appln. Rounding"));
                DCLE.Modify;
            until DCLE.Next = 0;

        Message('Proceso finalizado');
    end;

    local procedure ActMovProveedor()
    var
        MovProveedor: Record "Vendor Ledger Entry";
        Proveedor: Record Vendor;
    begin
        MovProveedor.Reset;
        MovProveedor.SetFilter("Vendor No.", '<>%1', '');
        if MovProveedor.FindSet then
            repeat
                Proveedor.Reset;
                if Proveedor.Get(MovProveedor."Vendor No.") then begin
                    MovProveedor."Vendor Name" := Proveedor.Name;
                    MovProveedor.Modify;
                end;
            until MovProveedor.Next = 0;

        Message('Proceso finalizado');
    end;

    local procedure ActualizaProveedor()
    var
        VendorBC: Record Vendor;
        Vendor2013: Record Vendor2;
    begin
        Vendor2013.Reset;
        Vendor2013.SetFilter("Tipo Contribuyente", '<>%1', '');
        //Vendor2013.SETRANGE("No.", '000006');
        if Vendor2013.FindSet then
            repeat
                VendorBC.Reset;
                if VendorBC.Get(Vendor2013."No.") then begin
                    VendorBC."Tipo Contribuyente" := Vendor2013."Tipo Contribuyente";
                    VendorBC.Modify;
                end;
            until Vendor2013.Next = 0;
        Message('Proceso finalizado');
    end;


    procedure CorrigeNCFCompras()
    var
        PIH: Record "Purch. Inv. Header";
        Retencion: Record "Retencion Doc. Reg. Prov.";
        MovCont: Record "G/L Entry";
    begin
        PIH.Get('CFR-023316');

        PIH."No. Comprobante Fiscal" := '10141';
        PIH.Modify;

        Retencion.Reset;
        Retencion.SetRange("No. documento", 'CFR-023316');
        Retencion.SetRange("Tipo documento", Retencion."Tipo documento"::Invoice);
        Retencion.FindSet();
        repeat
            Retencion.NCF := '10141';
            Retencion.Modify;
        until Retencion.Next = 0;

        MovCont.Reset;
        MovCont.SetCurrentKey("Document No.", "Posting Date");
        MovCont.SetRange("Document No.", PIH."No.");
        MovCont.FindSet();
        repeat
            if MovCont."No. Comprobante Fiscal" <> '' then begin
                MovCont."No. Comprobante Fiscal" := '10141';
                MovCont.Modify;
            end;
        until MovCont.Next = 0;
    end;


    procedure actfechavencmovcliente()
    var
        CLE: Record "Cust. Ledger Entry";
    begin
        CLE.Get(16537615);
        CLE.Validate("Due Date", CLE."Posting Date");
        CLE.Modify;
        Message('Final');
    end;


    procedure MarcarCorrecionCompras()
    var
        PIH: Record "Purch. Inv. Header";
        Retencion: Record "Retencion Doc. Reg. Prov.";
        MovCont: Record "G/L Entry";
    begin
        PIH.Get('CFR-051444');
        PIH."No. Comprobante Fiscal" := '100025';
        //PIH.Correction := TRUE;
        PIH.Modify;
        Message('Done!')
    end;


    procedure CorrigeVEGE()
    var
        VEGE: Record "G/L - Item Ledger Relation";
        aa: Record borrar;
        GLE: Record "G/L Entry";
        VE: Record "Value Entry";
    begin
        //aa.setrange("no mov",7115916);
        aa.Find('-');
        repeat
            VEGE.Reset;
            VEGE.SetCurrentKey("Value Entry No.");
            VEGE.SetRange("Value Entry No.", aa."no mov");
            VEGE.FindSet;
            repeat
                GLE.Get(VEGE."G/L Entry No.");
                GLE.Amount := 0;
                GLE."Debit Amount" := 0;
                GLE."Credit Amount" := 0;
                GLE.Modify;

                VE.Get(aa."no mov");
                VE."Cost per Unit" := 0;
                VE."Cost Amount (Actual)" := 0;
                VE."Cost Posted to G/L" := 0;
                VE."Cost Amount (Actual) (ACY)" := 0;
                VE."Cost Posted to G/L (ACY)" := 0;
                VE."Cost per Unit (ACY)" := 0;
                VE.Modify;

            until VEGE.Next = 0;

        until aa.Next = 0;
    end;

    local procedure CorrigeNom()
    var
        Empl: Record Employee;
        Cargo: Record "Puestos laborales";
    begin
        Empl.Find('-');
        repeat
            if (Empl.Departamento = '') or (Empl."Job Type Code" = '') then begin
                Empl.Departamento := '511100';
                Empl."Job Type Code" := '539';
                Empl.Modify;
                Empl.Validate(Departamento);
                Empl.Validate("Job Type Code");
                Empl.Modify;

            end;
        until Empl.Next = 0;
    end;

    local procedure CorrigeProd()
    begin
        Item.Reset();
        Item.SetFilter("No.", 'EC003190'); //|STER-EC010000|EC002479|101001701|101001711|EC002889|EC004600|EC012406');
        Item.Find('-');
        repeat
            /* IF Item."No. 2" <> '' THEN BEGIN
               Item."Common Item No." := Item."No. 2";
             */
            if not Item."Cost is Adjusted" then begin
                Item."Cost is Adjusted" := true;
                Item.Modify;
            end;
        until Item.Next = 0;

        Message('Products updated.');

    end;
}

