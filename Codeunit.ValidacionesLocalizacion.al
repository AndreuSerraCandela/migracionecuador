codeunit 76079 "Validaciones Localizacion"
{
    // Proyecto: Microsoft Dynamics Nav
    // ---------------------------------
    // AMS     : Agustín Méndez
    // GRN     : Guillermo Román
    // JPG     : John Peralta
    // FES     : Fausto Serrata
    // SSM     : Sebastian Soto Matos
    // ------------------------------------------------------------------------
    // No.         Fecha       Firma      Descripcion
    // ------------------------------------------------------------------------
    // DSLoc1.01   01-Ene-2007   AMS/GRN     Funcionalidad de NCF
    // DSLoc1.03   17-Abr-2018   AMS/GRN     Funcionalidad de NCF nuevo 2018
    // DSLoc1.04   04-jun-2019   JPG         Funcionalidad de NCF nuevo 2019 B16 y E, texto correcion a Correc ya que se corto ncf a 11  y 13
    // 001         10-Ene-2020   FES         Corrección validación cantidad digitos NCF inician con B o E.
    //                                       Cambio mensaje error para NCF Electrónicos (13 posiciones)
    // DSLoc2.0   18-may-2020   JPG         Modificaciones para validar letra inicial y vat regi
    // 002         28-Oct-2022  SSM         Quitar el control sobre validación de NCF letras B, E

    Permissions = TableData "Sales Invoice Header" = rimd,
                  TableData "Sales Cr.Memo Header" = rimd,
                  TableData "Purch. Inv. Header" = rimd,
                  TableData "Purch. Cr. Memo Hdr." = rimd;

    trigger OnRun()
    begin
    end;

    var
        Err001: Label 'Invalid NCF, this is for Credit Memo';
        Err002: Label 'Invalid NCF, this is for End users';
        Err003: Label 'First character must be A';
        Err004: Label 'Invalid NCF there''s not classification for it';
        Err005: Label 'Invalid NCF this is for Unique Income';
        Err006: Label 'Invalid NCF lenght, must be 19 char long';
        Err007: Label 'Character after position 1 must be numerics';
        Err008: Label 'NCF # %1 is duplicated for \Vendor No. %2';
        Err009: Label 'Specify %1 for %2 %3';
        Err010: Label 'The length of the NCF from May 2018 must be 11 ';
        Err011: Label 'First character must be B or E';
        Err012: Label 'Invalid NCF lenght, must be 11 char long';
        Err013: Label 'The Income type for %1 %2 must be %3, it will not allow any other value';
        Err014: Label 'The Income type must be 05 when selling FA';
        Text001: Label 'CORREC';
        Error012: Label 'NCF Already exist in %1 %2';
        Text002: Label 'Invoice';
        Text003: Label 'Credit Memo';
        I: Integer;
        Err015: Label '%1 must have value in %2. Verify the %3 with %4 %5, %6 %7';
        Err016: Label 'Invalid NCF lenght, must be 13 char long';
        Vendor: Record Vendor;
        Err017: Label 'First character NCF Rel must be A, B or C';
        Err018: Label 'Invalid NCF Rel. there''s not classification for it';
        Err020: Label 'The invoice must have Retention';
        Err019: Label 'You cannot Use %1 Type 04 in Document Type %2';
        Error021: Label 'You cannot Use %1 Type 34 in Document Type %2';
        Err0022: Label 'Invalid NCF, this is not for Credit Memo';


    procedure ValidaNCFCompras(PurchHeader: Record "Purchase Header")
    var
        VendorPostingGr: Record "Vendor Posting Group";
        PurchCrMemoHeader: Record "Purch. Cr. Memo Hdr.";
        PurchInvHeader: Record "Purch. Inv. Header";
    begin
        if PurchHeader."Posting Date" >= DMY2Date(1, 5, 2018) then begin
            ValidaNCFCompras2018(PurchHeader);
            exit;
        end;
        VendorPostingGr.Get(PurchHeader."Vendor Posting Group");

        if (VendorPostingGr."NCF Obligatorio") and (not PurchHeader.Correction) then
            PurchHeader.TestField("No. Comprobante Fiscal");

        if PurchHeader."No. Comprobante Fiscal" <> '' then begin

            //AMS Este control debe estar en la tabla, en el campo NCF. cuando se genera un error despues que se ha generado el NCF Navision
            //guarda este NCF en la cabecera y sigue la funcionalidad de No. Siguiente Fact.
            //IF NOT rVendorPostingGr."NCF Obligatorio" THEN
            //   TESTFIELD("No. Comprobante Fiscal",'');

            if StrLen(PurchHeader."No. Comprobante Fiscal") <> 19 then
                Error(Err006);

            //GRN Para que no se digite un NCF en un proveedor que no lo requiera

            if CopyStr(PurchHeader."No. Comprobante Fiscal", 10, 2) = '02' then
                Error(Err002);

            if (PurchHeader."Document Type" = PurchHeader."Document Type"::Invoice) or (PurchHeader."Document Type" = PurchHeader."Document Type"::Order) then
                case CopyStr(PurchHeader."No. Comprobante Fiscal", 10, 2) of
                    '05' .. '10':
                        Error(Err004);
                    '12':
                        Error(Err005);
                    '15' .. '99':
                        Error(Err004);
                end;

            if PurchHeader."Document Type" = PurchHeader."Document Type"::"Credit Memo" then begin
                if (CopyStr(PurchHeader."No. Comprobante Fiscal", 10, 2) <> '04') and (not PurchHeader.Correction) then
                    Error(Err002);
            end
            else
                if (PurchHeader."Document Type" in [PurchHeader."Document Type"::Order, PurchHeader."Document Type"::Invoice]) then
                    if (CopyStr(PurchHeader."No. Comprobante Fiscal", 10, 2) = '04') and (not PurchHeader.Correction) then
                        Error(Err001);


            //jpg++ 13-05-2020 validar que solo sean A
            if (CopyStr(PurchHeader."No. Comprobante Fiscal", 1, 1) <> 'A') then
                Error(Err003);

            /*
             CASE COPYSTR("No. Comprobante Fiscal",1,1) OF
              'K'..'O':
                ERROR(Err003);
              'V'..'Z':
                ERROR(Err003);
             END;
              */
            //jpg -- 13-05-2020 validar que solo sean A

            //Para validar caracteres numericos solamente despues la posicion 1
            ValidaCaracteres(PurchHeader."No. Comprobante Fiscal", 19);
        end;

        //DSLoc1.01 To avoid a non-requested Vendor's NCF
        if not PurchHeader.Correction then begin
            if (not VendorPostingGr."NCF Obligatorio") and (not VendorPostingGr."Permite Emitir NCF") then
                PurchHeader.TestField("No. Comprobante Fiscal", '');
        end
        else
            PurchHeader.TestField("Applies-to Doc. No."); //DSLoc1.01 To avoid a error in Corrected Documents

        if (PurchHeader."Document Type" in [PurchHeader."Document Type"::"Credit Memo"]) and (PurchHeader."No. Comprobante Fiscal" <> '') then begin
            PurchCrMemoHeader.SetCurrentKey("VAT Registration No.", "No. Comprobante Fiscal");
            PurchCrMemoHeader.SetRange("VAT Registration No.", PurchHeader."VAT Registration No.");
            PurchCrMemoHeader.SetRange("No. Comprobante Fiscal", PurchHeader."No. Comprobante Fiscal");
            if PurchCrMemoHeader.FindFirst then
                Error(Err008, PurchHeader."No. Comprobante Fiscal", PurchHeader."Buy-from Vendor No.");
        end
        else
            if PurchHeader."No. Comprobante Fiscal" <> '' then begin
                PurchInvHeader.SetCurrentKey("VAT Registration No.", "No. Comprobante Fiscal");
                PurchInvHeader.SetRange("VAT Registration No.", PurchHeader."VAT Registration No.");
                PurchInvHeader.SetRange("No. Comprobante Fiscal", PurchHeader."No. Comprobante Fiscal");
                if PurchInvHeader.FindFirst then
                    Error(Err008, PurchHeader."No. Comprobante Fiscal", PurchHeader."Buy-from Vendor No.");
            end;

        //DSLoc1.01 To let the NCF available
        if PurchHeader.Correction then
            if (PurchHeader."Document Type" in [PurchHeader."Document Type"::"Credit Memo"]) and (PurchHeader.Correction) then begin
                PurchInvHeader.Get(PurchHeader."Applies-to Doc. No.");
                PurchInvHeader."No. Comprobante Fiscal" := Text001 + CopyStr(PurchInvHeader."No. Comprobante Fiscal", 11, 9);
                PurchInvHeader.Modify;
            end;

    end;


    procedure ValidaNCFVentas(SalesHeader: Record "Sales Header")
    var
        rCustPostingGr: Record "Customer Posting Group";
    begin
        //fes mig+  //No aplica a Santillana Ecuador
        /*
        IF SalesHeader."Posting Date" >= DMY2DATE(1,5,2018) THEN
           BEGIN
            ValidaNCFVentas2018(SalesHeader);
            EXIT;
           END;
        
        WITH SalesHeader DO
          BEGIN
            IF "Document Type" = "Document Type"::"Credit Memo" THEN
              IF Correction THEN
                SalesHeader.TESTFIELD("Razon anulacion NCF");
        
           IF "No. Comprobante Fiscal" <> '' THEN
              BEGIN
               IF STRLEN("No. Comprobante Fiscal") <> 19 THEN
                  ERROR(Err006);
        
               IF ("Document Type" = "Document Type"::Invoice) OR ("Document Type" = "Document Type"::Order) THEN
                   CASE COPYSTR("No. Comprobante Fiscal",10,2) OF
                  // AMS '05'..'10':
                  //   ERROR(Err004);
                   '12' :
                     ERROR(Err005);
                 //  '15'..'99':
                 //    ERROR(Err004);
                   END;
        
               IF "Document Type" = "Document Type"::"Credit Memo" THEN
                 BEGIN
                  IF COPYSTR("No. Comprobante Fiscal",10,2) <> '04' THEN
                     ERROR(Err002);
                  IF Correction THEN
                    SalesHeader.TESTFIELD("Razon anulacion NCF");
                 END;
               CASE COPYSTR("No. Comprobante Fiscal",1,1) OF
                'K'..'O':
                  ERROR(Err003);
                'V'..'Z':
                  ERROR(Err003);
               END;
               //Para validar caracteres numericos solamente despues la posicion 1
               ValidaCaracteres("No. Comprobante Fiscal",19);
             END;
          END;
        */
        //fes mig -


        if SalesHeader."No. Comprobante Fiscal" <> '' then begin
            if StrLen(SalesHeader."No. Comprobante Fiscal") <> 19 then
                Error(Err006);

            if (SalesHeader."Document Type" = SalesHeader."Document Type"::Invoice) or (SalesHeader."Document Type" = SalesHeader."Document Type"::Order) then
                case CopyStr(SalesHeader."No. Comprobante Fiscal", 10, 2) of
                    // AMS '05'..'10':
                    //   ERROR(Err004);
                    '12':
                        Error(Err005);
                //  '15'..'99':
                //    ERROR(Err004);
                end;

            if SalesHeader."Document Type" = SalesHeader."Document Type"::"Credit Memo" then
                if CopyStr(SalesHeader."No. Comprobante Fiscal", 10, 2) <> '04' then
                    Error(Err002);

            case CopyStr(SalesHeader."No. Comprobante Fiscal", 1, 1) of
                'K' .. 'O':
                    Error(Err003);
                'V' .. 'Z':
                    Error(Err003);
            end;
            //Para validar caracteres numericos solamente despues la posicion 1
            ValidaCaracteres(SalesHeader."No. Comprobante Fiscal", 19);
        end;

    end;


    procedure ValidaNCFVentasServ(ServHeader: Record "Service Header")
    var
        rCustPostingGr: Record "Customer Posting Group";
    begin
        if ServHeader."Posting Date" >= DMY2Date(1, 5, 2018) then begin
            ValidaNCFVentasServ2018(ServHeader);
            exit;
        end;

        if ServHeader."Document Type" = ServHeader."Document Type"::"Credit Memo" then
            if ServHeader.Correction then
                ServHeader.TestField("Razon anulacion NCF");

        if ServHeader."No. Comprobante Fiscal" <> '' then begin
            if StrLen(ServHeader."No. Comprobante Fiscal") <> 19 then
                Error(Err006);

            if (ServHeader."Document Type" = ServHeader."Document Type"::Invoice) or (ServHeader."Document Type" = ServHeader."Document Type"::Order) then
                case CopyStr(ServHeader."No. Comprobante Fiscal", 10, 2) of
                    // AMS '05'..'10':
                    //   ERROR(Err004);
                    '12':
                        Error(Err005);
                //  '15'..'99':
                //    ERROR(Err004);
                end;

            if ServHeader."Document Type" = ServHeader."Document Type"::"Credit Memo" then begin
                if CopyStr(ServHeader."No. Comprobante Fiscal", 10, 2) <> '04' then
                    Error(Err002);
                if ServHeader.Correction then
                    ServHeader.TestField("Razon anulacion NCF");
            end;
            case CopyStr(ServHeader."No. Comprobante Fiscal", 1, 1) of
                'K' .. 'O':
                    Error(Err003);
                'V' .. 'Z':
                    Error(Err003);
            end;
            //Para validar caracteres numericos solamente despues la posicion 1
            ValidaCaracteres(ServHeader."No. Comprobante Fiscal", 19);
        end;
    end;


    procedure ValidaNCFED(GJL: Record "Gen. Journal Line")
    begin
        if StrLen(GJL."No. Comprobante Fiscal") <> 19 then
            Error(Err006);

        if CopyStr(GJL."No. Comprobante Fiscal", 10, 2) = '02' then
            Error(Err002);

        case CopyStr(GJL."No. Comprobante Fiscal", 10, 2) of
            '05' .. '10':
                Error(Err004);
            '12':
                Error(Err005);
        // AMS '15'..'99':
        // AMS   ERROR(Err004);
        end;

        if GJL."Document Type" = GJL."Document Type"::"Credit Memo" then
            if CopyStr(GJL."No. Comprobante Fiscal", 10, 2) <> '04' then
                Error(Err002);

        case CopyStr(GJL."No. Comprobante Fiscal", 1, 1) of
            'K' .. 'O':
                Error(Err003);
            'V' .. 'Z':
                Error(Err003);
        end;

        //Para validar caracteres numericos solamente despues la posicion 1
        ValidaCaracteres(GJL."No. Comprobante Fiscal", 19);
    end;


    procedure ValidaNCFReLCompras(PurchHeader: Record "Purchase Header")
    var
        VLE: Record "Vendor Ledger Entry";
    begin
        if StrLen(PurchHeader."No. Comprobante Fiscal") <> 19 then
            Error(Err006);

        if CopyStr(PurchHeader."No. Comprobante Fiscal Rel.", 10, 2) = '04' then
            Error(Err001)
        else
            if PurchHeader."Document Type" = PurchHeader."Document Type"::"Credit Memo" then
                if CopyStr(PurchHeader."No. Comprobante Fiscal Rel.", 10, 2) <> '01' then
                    Error(Err002);

        case CopyStr(PurchHeader."No. Comprobante Fiscal", 10, 2) of
            '05' .. '10':
                Error(Err004);
            '12':
                Error(Err005);
            '15' .. '99':
                Error(Err004);
        end;

        case CopyStr(PurchHeader."No. Comprobante Fiscal Rel.", 1, 1) of
            'K' .. 'O':
                Error(Err003);
            'V' .. 'Z':
                Error(Err003);
        end;
        //Para validar caracteres numericos solamente despues la posicion 1
        ValidaCaracteres(PurchHeader."No. Comprobante Fiscal Rel.", 19);
    end;


    procedure ValidaNCFReLVentas(SalesHeader: Record "Sales Header")
    begin
        if StrLen(SalesHeader."No. Comprobante Fiscal") <> 19 then
            Error(Err006);

        if CopyStr(SalesHeader."No. Comprobante Fiscal Rel.", 10, 2) = '04' then
            Error(Err001)
        else
            if SalesHeader."Document Type" = SalesHeader."Document Type"::"Credit Memo" then
                if CopyStr(SalesHeader."No. Comprobante Fiscal Rel.", 10, 2) <> '01' then
                    Error(Err002);

        case CopyStr(SalesHeader."No. Comprobante Fiscal", 10, 2) of
            '05' .. '10':
                Error(Err004);
            '12':
                Error(Err005);
        //AMS   '15'..'99':
        //AMS    ERROR(Err004);
        end;

        case CopyStr(SalesHeader."No. Comprobante Fiscal Rel.", 1, 1) of
            'K' .. 'O':
                Error(Err003);
            'V' .. 'Z':
                Error(Err003);
        end;
        //Para validar caracteres numericos solamente despues la posicion 1
        ValidaCaracteres(SalesHeader."No. Comprobante Fiscal", 19);
    end;


    procedure ValidaCaracteres(NCF: Code[19]; Longitud: Integer)
    begin
        //Para validar caracteres numericos solamente despues la posicion 1
        for I := 2 to Longitud do begin
            case CopyStr(NCF, I, 1) of
                '0' .. '9':
                    begin
                    end;
                else
                    Error(Err007);
            end;
        end;
    end;


    procedure ValidaClasifGasto(PurchHeader: Record "Purchase Header")
    var
        VPG: Record "Vendor Posting Group";
    begin
        VPG.Get(PurchHeader."Vendor Posting Group");
        if ((VPG."NCF Obligatorio") and (not PurchHeader.Correction)) or ((VPG."Permite Emitir NCF") and (not PurchHeader.Correction)) then
            if PurchHeader."Cod. Clasificacion Gasto" = '' then
                Error(Err009, PurchHeader.FieldCaption("Cod. Clasificacion Gasto"), PurchHeader.FieldCaption("Document Type"), PurchHeader."Document Type");
    end;


    procedure ValidaExiste(SalesHeader: Record "Sales Header"; NCF: Code[19])
    var
        SIH_: Record "Sales Invoice Header";
        SCMH_: Record "Sales Cr.Memo Header";
    begin
        // Removed 'with' statement for cloud compatibility
        if (SalesHeader."Document Type" in [SalesHeader."Document Type"::Order, SalesHeader."Document Type"::Invoice]) then begin
            SIH_.Reset;
            SIH_.SetCurrentKey("No. Comprobante Fiscal");
            SIH_.SetRange("No. Comprobante Fiscal", NCF);
            if SIH_.FindFirst then
                Error(Error012, Text002, SIH_."No.");
        end;

        if (SalesHeader."Document Type" in [SalesHeader."Document Type"::"Credit Memo", SalesHeader."Document Type"::"Return Order"]) then begin
            SCMH_.Reset;
            SCMH_.SetCurrentKey("No. Comprobante Fiscal");
            SCMH_.SetRange("No. Comprobante Fiscal", NCF);
            if SCMH_.FindFirst then
                Error(Error012, Text003, SCMH_."No.");
        end;
    end;


    procedure ValidaExisteServ(ServHeader: Record "Service Header"; NCF: Code[19])
    var
        SSIH_: Record "Service Invoice Header";
        SSCMH_: Record "Service Cr.Memo Header";
    begin
        if (ServHeader."Document Type" in [ServHeader."Document Type"::Order, ServHeader."Document Type"::Invoice]) then begin
            SSIH_.Reset;
            SSIH_.SetCurrentKey("No. Comprobante Fiscal");
            SSIH_.SetRange("No. Comprobante Fiscal", NCF);
            if SSIH_.FindFirst then
                Error(Error012, Text002, SSIH_."No.");
        end;

        if (ServHeader."Document Type" = ServHeader."Document Type"::"Credit Memo") then begin
            SSCMH_.Reset;
            SSCMH_.SetCurrentKey("No. Comprobante Fiscal");
            SSCMH_.SetRange("No. Comprobante Fiscal", NCF);
            if SSCMH_.FindFirst then
                Error(Error012, Text003, SSCMH_."No.");
        end;
    end;


    procedure ValidaNCFCompras2018(PurchHeader: Record "Purchase Header")
    var
        VendorPostingGr: Record "Vendor Posting Group";
        PurchCrMemoHeader: Record "Purch. Cr. Memo Hdr.";
        PurchInvHeader: Record "Purch. Inv. Header";
        PurchLines: Record "Purchase Line";
        RetencionDocProveedores: Record "Retencion Doc. Proveedores";
    begin
        //DS//DSLoc1.03
        //DSLoc1.04
        /*//fes mig
        IF (COPYSTR("No. Comprobante Fiscal",1,1) = 'B')AND (STRLEN(PurchHeader."No. Comprobante Fiscal") <> 11) THEN
            ERROR(Err010)
        ELSE
        IF ((COPYSTR("No. Comprobante Fiscal",1,1) = 'E') AND (STRLEN(PurchHeader."No. Comprobante Fiscal") <> 13)) THEN
            ERROR(Err016);
        */

        // para generar y validar comprobante a nivel de "Buy-from Vendor No." ya que el pay vendor cambia el Vendor Posting Group al cambiarlo
        Vendor.Reset;
        Vendor.Get(PurchHeader."Buy-from Vendor No.");
        VendorPostingGr.Get(Vendor."Vendor Posting Group");

        if (VendorPostingGr."NCF Obligatorio") and (not PurchHeader.Correction) then
            PurchHeader.TestField("No. Comprobante Fiscal")
        else
            if (VendorPostingGr."NCF Obligatorio") and (PurchHeader."No. Comprobante Fiscal" = '') then
                exit;

        if PurchHeader."No. Comprobante Fiscal" <> '' then begin

            // DSLoc2.0 validar rnc si hay comprobante
            PurchHeader.TestField("VAT Registration No.");

            //GRN Para que no se digite un NCF en un proveedor que no lo requiera
            if CopyStr(PurchHeader."No. Comprobante Fiscal", 2, 2) = '02' then
                Error(Err002);

            //DSLoc1.04
            if CopyStr(PurchHeader."No. Comprobante Fiscal", 2, 2) = '32' then
                Error(Err002);

            //GRN Si es informal, debe llevar retencion
            if CopyStr(PurchHeader."No. Comprobante Fiscal", 2, 2) = '11' then begin
                //Buscamos al menos una linea con ITBIS
                PurchLines.Reset;
                PurchLines.SetRange("Document Type", PurchHeader."Document Type");
                PurchLines.SetRange("Document No.", PurchHeader."No.");
                PurchLines.SetFilter(Quantity, '<>%1', 0);
                PurchLines.SetFilter("VAT %", '<>%1', 0);
                if PurchLines.FindFirst then begin
                    //Verificamos si hay retencion
                    RetencionDocProveedores.Reset;
                    RetencionDocProveedores.SetRange("Tipo documento", PurchHeader."Document Type");
                    RetencionDocProveedores.SetRange("No. documento", PurchHeader."No.");
                    if not RetencionDocProveedores.FindFirst then
                        Error(Err020);
                end;
            end;

            /*//fes mig
           //DSLoc1.04
             IF (COPYSTR("No. Comprobante Fiscal",1,1) = 'B') THEN
               IF ("Document Type" = "Document Type"::Invoice) OR ("Document Type" = "Document Type"::Order) THEN
                   CASE COPYSTR("No. Comprobante Fiscal",2,2) OF
                   '05'..'10':
                     ERROR(Err004);
                   '12' :
                     ERROR(Err005);
                   '18'..'99':
                     ERROR(Err004);
                   END;
          //DSLoc1.04
             IF (COPYSTR("No. Comprobante Fiscal",1,1) = 'E') THEN
               IF ("Document Type" = "Document Type"::Invoice) OR ("Document Type" = "Document Type"::Order) THEN
                   CASE COPYSTR("No. Comprobante Fiscal",2,2) OF
                   '01'..'30':
                     ERROR(Err004);
                   '35'..'40':
                     ERROR(Err004);
                    '42':
                     ERROR(Err004);
                    '48'..'99':
                     ERROR(Err004);
                   END;

          //DSLoc1.04
             IF (COPYSTR("No. Comprobante Fiscal",1,1) = 'B') THEN
               BEGIN
                 IF "Document Type" = "Document Type"::"Credit Memo" THEN
                    BEGIN
                    IF (COPYSTR("No. Comprobante Fiscal",2,2) <> '04') AND (NOT Correction) THEN
                       ERROR(Err0022);
                    END
                 ELSE
                 IF ("Document Type" IN ["Document Type"::Order,"Document Type"::Invoice]) THEN
                    IF (COPYSTR("No. Comprobante Fiscal",2,2) = '04') AND (NOT Correction) THEN
                     ERROR(Err001);
               END;

          //DSLoc1.04
          IF (COPYSTR("No. Comprobante Fiscal",1,1) = 'E') THEN
           BEGIN
             IF "Document Type" = "Document Type"::"Credit Memo" THEN
                BEGIN
                IF (COPYSTR("No. Comprobante Fiscal",2,2) <> '34') AND (NOT Correction) THEN
                   ERROR(Err0022);
                END
             ELSE
             IF ("Document Type" IN ["Document Type"::Order,"Document Type"::Invoice]) THEN
                IF (COPYSTR("No. Comprobante Fiscal",2,2) = '34') AND (NOT Correction) THEN
                   ERROR(Err001);
           END;
           */

            //DSLoc2.0  validar que solo sean B o E
            /*IF  (COPYSTR("No. Comprobante Fiscal",1,1) <> 'B') AND (COPYSTR("No. Comprobante Fiscal",1,1) <> 'E') THEN
                ERROR(Err011);*/ //002

            /* CASE COPYSTR("No. Comprobante Fiscal",1,1) OF
              'A':
                ERROR(Err011);
              'C'..'D':
                ERROR(Err011);
              'F'..'Z':
                ERROR(Err011);
              '0'..'9':
                ERROR(Err011);
             END;*/
            //jpg -- 13-05-2020 validar que solo sean B o E

            //Para validar caracteres numericos solamente despues la posicion 1
            //DSLoc1.04
            /*IF (COPYSTR("No. Comprobante Fiscal",1,1) = 'B') THEN
            ValidaCaracteres("No. Comprobante Fiscal",11);
         //DSLoc1.04
            IF (COPYSTR("No. Comprobante Fiscal",1,1) = 'E') THEN
            ValidaCaracteres("No. Comprobante Fiscal",13);*/ //002
        end;

        //DSLoc1.01 To avoid a non-requested Vendor's NCF
        if not PurchHeader.Correction then begin
            if (not VendorPostingGr."NCF Obligatorio") and (not VendorPostingGr."Permite Emitir NCF") then
                PurchHeader.TestField("No. Comprobante Fiscal", '');
        end
        else
            PurchHeader.TestField("Applies-to Doc. No."); //DSLoc1.01 To avoid a error in Corrected Documents

        if (PurchHeader."Document Type" in [PurchHeader."Document Type"::"Credit Memo"]) and (PurchHeader."No. Comprobante Fiscal" <> '') then begin
            PurchCrMemoHeader.SetCurrentKey("VAT Registration No.", "No. Comprobante Fiscal");
            PurchCrMemoHeader.SetRange("VAT Registration No.", PurchHeader."VAT Registration No.");
            PurchCrMemoHeader.SetRange("No. Comprobante Fiscal", PurchHeader."No. Comprobante Fiscal");
            PurchCrMemoHeader.SetFilter("No.", '<>%1', PurchHeader."Posting No.");
            if PurchCrMemoHeader.FindFirst then
                Error(Err008, PurchHeader."No. Comprobante Fiscal", PurchHeader."Buy-from Vendor No.");
        end
        else
            if PurchHeader."No. Comprobante Fiscal" <> '' then begin
                PurchInvHeader.SetCurrentKey("VAT Registration No.", "No. Comprobante Fiscal");
                PurchInvHeader.SetRange("VAT Registration No.", PurchHeader."VAT Registration No.");
                PurchInvHeader.SetRange("No. Comprobante Fiscal", PurchHeader."No. Comprobante Fiscal");
                PurchInvHeader.SetFilter("No.", '<>%1', PurchHeader."Posting No.");
                if PurchInvHeader.FindFirst then
                    Error(Err008, PurchHeader."No. Comprobante Fiscal", PurchHeader."Buy-from Vendor No.");
            end;

        //DSLoc1.01 To let the NCF available
        if PurchHeader.Correction then
            if (PurchHeader."Document Type" in [PurchHeader."Document Type"::"Credit Memo"]) and (PurchHeader.Correction) then begin
                PurchInvHeader.Get(PurchHeader."Applies-to Doc. No.");
                PurchInvHeader."No. Comprobante Fiscal" := Text001 + CopyStr(PurchInvHeader."No. Comprobante Fiscal", 6, 8);
                PurchInvHeader.Modify;
            end;
        if PurchHeader.Correction then
            if (PurchHeader."Document Type" in [PurchHeader."Document Type"::Invoice]) and (PurchHeader.Correction) then begin
                PurchCrMemoHeader.Reset;
                PurchCrMemoHeader.Get(PurchHeader."Applies-to Doc. No.");
                PurchCrMemoHeader."No. Comprobante Fiscal" := Text001 + CopyStr(PurchCrMemoHeader."No. Comprobante Fiscal", 6, 8);
                PurchCrMemoHeader.Modify;
            end;

        ValidaClasifGasto(PurchHeader);

        //Verifico las lineas
        if not PurchHeader.Invoice then
            exit;
        PurchLines.Reset;
        PurchLines.SetRange("Document Type", PurchHeader."Document Type");
        PurchLines.SetRange("Document No.", PurchHeader."No.");
        PurchLines.SetFilter(Quantity, '<>%1', 0);
        PurchLines.SetFilter("Direct Unit Cost", '<>%1', 0);
        if PurchLines.FindSet then
            repeat
                if PurchLines."VAT Prod. Posting Group" = '' then
                    Error(StrSubstNo(Err015, PurchLines.FieldCaption("VAT Prod. Posting Group"), PurchLines.TableCaption, PurchLines.TableCaption, PurchLines.Type, PurchLines."No.", PurchLines.FieldCaption(Description), PurchLines.Description));
            until PurchLines.Next = 0;

    end;


    procedure ValidaNCFVentas2018(SalesHeader: Record "Sales Header")
    var
        CustPostingGr: Record "Customer Posting Group";
        SalesLines: Record "Sales Line";
        GLAccount: Record "G/L Account";
    begin
        // Remove deprecated 'with' statement and use explicit references
        if SalesHeader."Document Type" = SalesHeader."Document Type"::"Credit Memo" then
            if SalesHeader.Correction then
                SalesHeader.TestField("Razon anulacion NCF");

        if SalesHeader."No. Comprobante Fiscal" <> '' then begin
            if (CopyStr(SalesHeader."No. Comprobante Fiscal", 2, 2) <> '02') and (CopyStr(SalesHeader."No. Comprobante Fiscal", 2, 2) <> '04')
              and (CopyStr(SalesHeader."No. Comprobante Fiscal", 2, 2) <> '12') then  //05/08/2021 jpg
                SalesHeader.TestField("Ultimo. No. NCF");
            //DSLoc1.04
            /*//fes mig+
              IF (COPYSTR("No. Comprobante Fiscal",1,1) = 'B')AND (STRLEN("No. Comprobante Fiscal") <> 11) THEN
               ERROR(Err010)
              ELSE
              IF ((COPYSTR("No. Comprobante Fiscal",1,1) = 'E') AND (STRLEN("No. Comprobante Fiscal") <> 13)) THEN
                  ERROR(Err016);

             IF ("Document Type" = "Document Type"::Invoice) OR ("Document Type" = "Document Type"::Order) THEN
                 CASE COPYSTR("No. Comprobante Fiscal",2,2) OF
                 '12' :
                   ERROR(Err005);
                 END;

       //DSLoc1.04
             IF (COPYSTR("No. Comprobante Fiscal",1,1) = 'B') THEN
                BEGIN
                   IF "Document Type" = "Document Type"::"Credit Memo" THEN
                     BEGIN
                      IF COPYSTR("No. Comprobante Fiscal",2,2) <> '04' THEN
                         ERROR(Err0022);
                      IF Correction THEN
                        SalesHeader.TESTFIELD("Razon anulacion NCF");
                     END;
                END;

       //DSLoc1.04
             IF (COPYSTR("No. Comprobante Fiscal",1,1) = 'E') THEN
                BEGIN
                   IF "Document Type" = "Document Type"::"Credit Memo" THEN
                     BEGIN
                      IF COPYSTR("No. Comprobante Fiscal",2,2) <> '34' THEN
                         ERROR(Err0022);
                      IF Correction THEN
                        SalesHeader.TESTFIELD("Razon anulacion NCF");
                     END;
                END;


      //DSLoc2.0  validar que solo sean B o E
             IF (COPYSTR("No. Comprobante Fiscal",1,1) <> 'B') AND (COPYSTR("No. Comprobante Fiscal",1,1) <> 'E') THEN
                ERROR(Err011);
      { //DSLoc1.04
              CASE COPYSTR("No. Comprobante Fiscal",1,1) OF
              'A':
                ERROR(Err011);
              'C'..'D':
                ERROR(Err011);
              'F'..'Z':
                ERROR(Err011);
             END;}

        //Para validar caracteres numericos solamente despues la posicion 1
       //DSLoc1.04
             IF (COPYSTR("No. Comprobante Fiscal",1,1) = 'B') THEN
             ValidaCaracteres("No. Comprobante Fiscal",11);
       //DSLoc1.04
             IF (COPYSTR("No. Comprobante Fiscal",1,1) = 'E') THEN
             ValidaCaracteres("No. Comprobante Fiscal",13);

          *///fes mig-

        end else begin //jpg 2-9-2020 validar que no. comprobante no este vacio si debe generarlo
            CustPostingGr.Reset;
            if SalesHeader.Invoice then
                if CustPostingGr.Get(SalesHeader."Customer Posting Group") then
                    if (CustPostingGr."Permite emitir NCF") and (not SalesHeader.Correction) then
                        SalesHeader.TestField("No. Comprobante Fiscal");
        end;

        //Verifico las lineas
        SalesLines.Reset;
        SalesLines.SetRange("Document Type", SalesHeader."Document Type");
        SalesLines.SetRange("Document No.", SalesHeader."No.");
        SalesLines.SetFilter(Quantity, '<>%1', 0);
        SalesLines.SetFilter("Unit Price", '<>%1', 0);
        if SalesLines.FindSet then
            repeat
                if SalesLines.Type = SalesLines.Type::"G/L Account" then begin
                    GLAccount.Get(SalesLines."No.");
                    if (SalesHeader."Tipo de ingreso" <> GLAccount."Cod. Clasificacion Gasto") and (GLAccount."Cod. Clasificacion Gasto" <> '') then
                        Error(StrSubstNo(Err013, SalesLines.FieldCaption(Type), SalesLines."No.", GLAccount."Cod. Clasificacion Gasto"));
                end
                else
                    if SalesLines.Type = SalesLines.Type::"Fixed Asset" then begin
                        if SalesHeader."Tipo de ingreso" <> '05' then
                            Error(Err014);
                    end;
                SalesLines.TestField("VAT Prod. Posting Group");
            until SalesLines.Next = 0;

    end;


    procedure ValidaNCFVentasServ2018(ServHeader: Record "Service Header")
    var
        CustPostingGr: Record "Customer Posting Group";
    begin
        if ServHeader."Document Type" = ServHeader."Document Type"::"Credit Memo" then
            if ServHeader.Correction then
                ServHeader.TestField("Razon anulacion NCF");

        if ServHeader."No. Comprobante Fiscal" <> '' then begin
            if (CopyStr(ServHeader."No. Comprobante Fiscal", 2, 2) <> '02') and (CopyStr(ServHeader."No. Comprobante Fiscal", 2, 2) <> '04')
              and (CopyStr(ServHeader."No. Comprobante Fiscal", 2, 2) <> '12') then  //05/08/2021 jpg
                ServHeader.TestField("Fecha vencimiento NCF");
            if StrLen(ServHeader."No. Comprobante Fiscal") <> 11 then
                Error(Err006);

            if (ServHeader."Document Type" = ServHeader."Document Type"::Invoice) or (ServHeader."Document Type" = ServHeader."Document Type"::Order) then
                case CopyStr(ServHeader."No. Comprobante Fiscal", 2, 2) of
                    '12':
                        Error(Err005);
                end;

            if ServHeader."Document Type" = ServHeader."Document Type"::"Credit Memo" then begin
                if CopyStr(ServHeader."No. Comprobante Fiscal", 2, 2) <> '04' then
                    Error(Err002);
                if ServHeader.Correction then
                    ServHeader.TestField("Razon anulacion NCF");
            end;
            case CopyStr(ServHeader."No. Comprobante Fiscal", 1, 1) of
                'A':
                    Error(Err003);
                'C' .. 'Z':
                    Error(Err003);
            end;
            //Para validar caracteres numericos solamente despues la posicion 1
            ValidaCaracteres(ServHeader."No. Comprobante Fiscal", 11);
        end;
    end;


    procedure ValidaNCFRelacionadoCompras(PurchHeader: Record "Purchase Header")
    var
        VendorPostingGr: Record "Vendor Posting Group";
        PurchCrMemoHeader: Record "Purch. Cr. Memo Hdr.";
        PurchInvHeader: Record "Purch. Inv. Header";
        PurchLines: Record "Purchase Line";
        RetencionDocProveedores: Record "Retencion Doc. Proveedores";
    begin
        //DSLoc2.0
        if PurchHeader."No. Comprobante Fiscal Rel." <> '' then begin

            /*//fes mig +
            IF (COPYSTR("No. Comprobante Fiscal Rel.",1,1) = 'B')AND (STRLEN("No. Comprobante Fiscal Rel.") <> 11) THEN
                ERROR(Err010)
           ELSE
            IF ((COPYSTR("No. Comprobante Fiscal Rel.",1,1) = 'E') AND (STRLEN("No. Comprobante Fiscal Rel.") <> 13)) THEN
                ERROR(Err016)
            ELSE
            IF ((COPYSTR("No. Comprobante Fiscal Rel.",1,1) = 'A') AND (STRLEN("No. Comprobante Fiscal Rel.") <> 19)) THEN
                ERROR(Err006);


          // validar que solo sean B o E  A
            IF  (COPYSTR("No. Comprobante Fiscal Rel.",1,1) <> 'B') AND (COPYSTR("No. Comprobante Fiscal Rel.",1,1) <> 'E') AND (COPYSTR("No. Comprobante Fiscal Rel.",1,1) <> 'A') THEN
                ERROR(Err017);



             IF (COPYSTR("No. Comprobante Fiscal Rel.",1,1) = 'B') THEN
                   CASE COPYSTR("No. Comprobante Fiscal Rel.",2,2) OF
                   '05'..'10':
                     ERROR(Err018);
                   '18'..'99':
                     ERROR(Err018);
                     '04':
                     IF PurchHeader."Document Type" = PurchHeader."Document Type"::"Credit Memo" THEN
                        ERROR(STRSUBSTNO(Err019,PurchHeader.FIELDCAPTION("No. Comprobante Fiscal Rel."),PurchHeader."Document Type"));

                   END;

             IF (COPYSTR("No. Comprobante Fiscal Rel.",1,1) = 'A') THEN
                   CASE COPYSTR("No. Comprobante Fiscal Rel.",2,2) OF
                   '05'..'10':
                     ERROR(Err018);
                   '18'..'99':
                     ERROR(Err018);

                   END;

             IF (COPYSTR("No. Comprobante Fiscal Rel.",1,1) = 'E') THEN
                   CASE COPYSTR("No. Comprobante Fiscal Rel.",2,2) OF
                   '01'..'30':
                     ERROR(Err018);
                   '34':
                     IF PurchHeader."Document Type" = PurchHeader."Document Type"::"Credit Memo" THEN
                        ERROR(STRSUBSTNO(Error021,PurchHeader.FIELDCAPTION("No. Comprobante Fiscal Rel."),PurchHeader."Document Type"));
                   '35'..'40':
                     ERROR(Err018);
                    '42':
                     ERROR(Err018);
                    '48'..'99':
                     ERROR(Err018);
                   END;


             //Para validar caracteres numericos solamente despues la posicion 1
             IF (COPYSTR("No. Comprobante Fiscal Rel.",1,1) = 'B') THEN
             ValidaCaracteres(PurchHeader."No. Comprobante Fiscal Rel.",11);

             IF (COPYSTR("No. Comprobante Fiscal Rel.",1,1) = 'E') THEN
             ValidaCaracteres(PurchHeader."No. Comprobante Fiscal Rel.",13);

           IF (COPYSTR("No. Comprobante Fiscal Rel.",1,1) = 'A') THEN
             ValidaCaracteres(PurchHeader."No. Comprobante Fiscal Rel.",19);
             */ //fes mig-
        end;

    end;


    procedure ValidaNCFRelacionadoVentas(SalesHeader: Record "Sales Header")
    begin
        //DSLoc2.0
        if SalesHeader."No. Comprobante Fiscal Rel." <> '' then begin
            /*//fes mig+
            IF (COPYSTR("No. Comprobante Fiscal Rel.",1,1) = 'B')AND (STRLEN("No. Comprobante Fiscal Rel.") <> 11) THEN
              ERROR(Err010)
         ELSE
          IF ((COPYSTR("No. Comprobante Fiscal Rel.",1,1) = 'E') AND (STRLEN("No. Comprobante Fiscal Rel.") <> 13)) THEN
              ERROR(Err016)
          ELSE
          IF ((COPYSTR("No. Comprobante Fiscal Rel.",1,1) = 'A') AND (STRLEN("No. Comprobante Fiscal Rel.") <> 19)) THEN
              ERROR(Err006);


        // validar que solo sean B o E  A
          IF  (COPYSTR("No. Comprobante Fiscal Rel.",1,1) <> 'B') AND (COPYSTR("No. Comprobante Fiscal Rel.",1,1) <> 'E') AND (COPYSTR("No. Comprobante Fiscal Rel.",1,1) <> 'A') THEN
              ERROR(Err017);


           IF (COPYSTR("No. Comprobante Fiscal Rel.",1,1) = 'B') THEN
                 CASE COPYSTR("No. Comprobante Fiscal Rel.",2,2) OF
                 '05'..'10':
                   ERROR(Err018);
                 '18'..'99':
                   ERROR(Err018);
                 END;

           IF (COPYSTR("No. Comprobante Fiscal Rel.",1,1) = 'A') THEN
                 CASE COPYSTR("No. Comprobante Fiscal Rel.",2,2) OF
                 '05'..'10':
                   ERROR(Err018);
                 '18'..'99':
                   ERROR(Err018);
                 END;

           IF (COPYSTR("No. Comprobante Fiscal Rel.",1,1) = 'E') THEN
                 CASE COPYSTR("No. Comprobante Fiscal Rel.",2,2) OF
                 '01'..'30':
                   ERROR(Err018);
                 '35'..'40':
                   ERROR(Err018);
                  '42':
                   ERROR(Err018);
                  '48'..'99':
                   ERROR(Err018);
                 END;


           //Para validar caracteres numericos solamente despues la posicion 1
           IF (COPYSTR("No. Comprobante Fiscal Rel.",1,1) = 'B') THEN
           ValidaCaracteres(SalesHeader."No. Comprobante Fiscal Rel.",11);

           IF (COPYSTR("No. Comprobante Fiscal Rel.",1,1) = 'E') THEN
           ValidaCaracteres(SalesHeader."No. Comprobante Fiscal Rel.",13);

         IF (COPYSTR("No. Comprobante Fiscal Rel.",1,1) = 'A') THEN
           ValidaCaracteres(SalesHeader."No. Comprobante Fiscal Rel.",19);
          *///fes mig -
        end;

    end;
}

