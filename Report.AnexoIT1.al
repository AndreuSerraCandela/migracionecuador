report 76089 "Anexo IT-1"
{
    DefaultLayout = RDLC;
    RDLCLayout = './AnexoIT1.rdlc';
    Caption = 'Anexo IT-1';
    EnableHyperlinks = true;

    dataset
    {
        dataitem("Sales Invoice Header"; "Sales Invoice Header")
        {
            CalcFields = Amount, "Amount Including VAT";
            DataItemTableView = SORTING("Posting Date");
            RequestFilterFields = "Posting Date", "Customer Posting Group", "Shortcut Dimension 1 Code";

            trigger OnAfterGetRecord()
            begin
                if Correction then
                    CurrReport.Skip;

                if CopyStr("No. Comprobante Fiscal", 1, 6) = 'CORREC' then
                    CurrReport.Skip;

                if "No. Comprobante Fiscal" <> '' then
                    NCF := CopyStr("No. Comprobante Fiscal", 10, 2)
                else
                    /*
                    IF ("No. Comprobante Fiscal" = '') AND ("No. Comprobante Fiscal Borr." <> '') THEN
                       BEGIN
                        "No. Comprobante Fiscal" := "No. Comprobante Fiscal Borr.";
                        NCF := COPYSTR("No. Comprobante Fiscal",10,2);
                       END
                    ELSE
                    */
                   NCF := '99';

                //IF (STRPOS("Sell-to Customer No.",'CONTADO') <> 0) AND (NCF = '02') THEN
                //   CurrReport.SKIP;
                ImporteVta := 0;
                VE.Reset;
                VE.SetCurrentKey("Document No.", "Posting Date");
                VE.SetRange("Document No.", "No.");
                VE.SetRange("Posting Date", "Posting Date");
                VE.SetRange("Document Type", VE."Document Type"::Invoice);
                if VE.FindSet() then
                    repeat
                        ImporteVta += Abs(VE.Base)
                    until VE.Next = 0;

                case NCF of
                    '01':
                        begin
                            Importe[1] += ImporteVta;
                            Cantidad[1] += 1;
                        end;
                    '02':
                        begin
                            Importe[2] += ImporteVta;
                            Cantidad[2] += 1;
                        end;
                    '03':
                        begin
                            Importe[3] += ImporteVta;
                            Cantidad[3] += 1;
                        end;
                    '11' .. '12':
                        begin
                            Importe[5] += ImporteVta;
                            Cantidad[5] += 1;
                        end;
                    '14':
                        begin
                            Importe[6] += ImporteVta;
                            Cantidad[6] += 1;
                        end;
                    '15':
                        begin
                            Importe[7] += ImporteVta;
                            Cantidad[7] += 1;
                        end;
                /*'99' :
                  BEGIN
                   Importe[8] += Amount;
                   Cantidad[8] += 1;
                  END;
               */
                end;

                if PaymtMethod.Get("Payment Method Code") then begin
                    if PaymtMethod."Forma de pago DGII" = PaymtMethod."Forma de pago DGII"::"1 - Efectivo" then
                        Importe[8] += ImporteVta
                    else
                        if PaymtMethod."Forma de pago DGII" = PaymtMethod."Forma de pago DGII"::"3 - Tarjeta Credito/Debito" then
                            Importe[10] += ImporteVta
                        else
                            if PaymtMethod."Forma de pago DGII" = PaymtMethod."Forma de pago DGII"::"4 - Compra a credito" then
                                Importe[11] += ImporteVta
                            else
                                if PaymtMethod."Forma de pago DGII" = PaymtMethod."Forma de pago DGII"::"2 - Cheques/Transferencias/Depositos" then
                                    Importe[9] += ImporteVta;
                end;

            end;

            trigger OnPreDataItem()
            begin
                Clear(Importe);
                Clear(Cantidad);

                Filtros := GetFilters;
                FechaDesde := GetRangeMin("Posting Date");
                FechaHasta := GetRangeMax("Posting Date");
            end;
        }
        dataitem("Service Invoice Header"; "Service Invoice Header")
        {
            CalcFields = Amount, "Amount Including VAT";
            DataItemTableView = SORTING("Posting Date");

            trigger OnAfterGetRecord()
            begin
                if "No. Comprobante Fiscal" <> '' then
                    NCF := CopyStr("No. Comprobante Fiscal", 10, 2)
                else
                    /*
                    IF ("No. Comprobante Fiscal" = '') AND ("No. Comprobante Fiscal Borr." <> '') THEN
                       BEGIN
                        "No. Comprobante Fiscal" := "No. Comprobante Fiscal Borr.";
                        NCF := COPYSTR("No. Comprobante Fiscal",10,2);
                       END
                    ELSE
                    */
                   NCF := '99';

                //IF (STRPOS("Sell-to Customer No.",'CONTADO') <> 0) AND (NCF = '02') THEN
                //   CurrReport.SKIP;
                ImporteVta := 0;
                VE.Reset;
                VE.SetCurrentKey("Document No.", "Posting Date");
                VE.SetRange("Document No.", "No.");
                VE.SetRange("Posting Date", "Posting Date");
                VE.SetRange("Document Type", VE."Document Type"::Invoice);
                if VE.FindSet() then
                    repeat
                        ImporteVta += Abs(VE.Base)
                    until VE.Next = 0;

                case NCF of
                    '01':
                        begin
                            Importe[1] += ImporteVta;
                            Cantidad[1] += 1;
                        end;
                    '02':
                        begin
                            Importe[2] += ImporteVta;
                            Cantidad[2] += 1;
                        end;
                    '03':
                        begin
                            Importe[3] += ImporteVta;
                            Cantidad[3] += 1;
                        end;
                    '11' .. '12':
                        begin
                            Importe[5] += ImporteVta;
                            Cantidad[5] += 1;
                        end;
                    '14':
                        begin
                            Importe[6] += ImporteVta;
                            Cantidad[6] += 1;
                        end;
                    '15':
                        begin
                            Importe[7] += ImporteVta;
                            Cantidad[7] += 1;
                        end;
                /*'99' :
                  BEGIN
                   Importe[8] += Amount;
                   Cantidad[8] += 1;
                  END;
               */
                end;

                if PaymtMethod.Get("Payment Method Code") then begin
                    if PaymtMethod."Forma de pago DGII" = PaymtMethod."Forma de pago DGII"::"1 - Efectivo" then
                        Importe[8] += ImporteVta
                    else
                        if PaymtMethod."Forma de pago DGII" = PaymtMethod."Forma de pago DGII"::"3 - Tarjeta Credito/Debito" then
                            Importe[10] += ImporteVta
                        else
                            if PaymtMethod."Forma de pago DGII" = PaymtMethod."Forma de pago DGII"::"4 - Compra a credito" then
                                Importe[11] += ImporteVta
                            else
                                if PaymtMethod."Forma de pago DGII" = PaymtMethod."Forma de pago DGII"::"2 - Cheques/Transferencias/Depositos" then
                                    Importe[9] += ImporteVta;
                end;

            end;

            trigger OnPreDataItem()
            begin
                //CLEAR(Importe);
                //CLEAR(Cantidad);
                SetFilter("Posting Date", "Sales Invoice Header".GetFilter("Posting Date"));
                if "Sales Invoice Header".GetFilter("Customer Posting Group") <> '' then
                    SetFilter("Customer Posting Group", "Sales Invoice Header".GetFilter("Customer Posting Group"));

                Filtros := GetFilters;
            end;
        }
        dataitem("Sales Cr.Memo Header"; "Sales Cr.Memo Header")
        {
            CalcFields = Amount, "Amount Including VAT";
            DataItemTableView = SORTING("Posting Date");

            trigger OnAfterGetRecord()
            begin
                if Correction then
                    CurrReport.Skip;

                if "No. Comprobante Fiscal" <> '' then
                    NCF := CopyStr("No. Comprobante Fiscal", 2, 2)
                else
                    NCF := '99';

                ImporteVta := 0;
                VE.Reset;
                VE.SetCurrentKey("Document No.", "Posting Date");
                VE.SetRange("Document No.", "No.");
                VE.SetRange("Posting Date", "Posting Date");
                VE.SetRange("Document Type", VE."Document Type"::"Credit Memo");
                if VE.FindSet() then
                    repeat
                        ImporteVta += Abs(VE.Base)
                    until VE.Next = 0;

                Importe[4] += ImporteVta;
                Cantidad[4] += 1;

                if "No. Comprobante Fiscal Rel." <> '' then begin
                    "Sales Invoice Header".Reset;
                    "Sales Invoice Header".SetCurrentKey("No. Comprobante Fiscal");
                    "Sales Invoice Header".SetRange("No. Comprobante Fiscal", "No. Comprobante Fiscal Rel.");

                    "Service Invoice Header".Reset;
                    "Service Invoice Header".SetCurrentKey("No. Comprobante Fiscal");
                    "Service Invoice Header".SetRange("No. Comprobante Fiscal", "No. Comprobante Fiscal Rel.");

                    if "Sales Invoice Header".FindFirst then begin
                        Dias := "Posting Date" - "Sales Invoice Header"."Posting Date";
                        if Dias > 30 then begin
                            Importe[15] += ImporteVta;
                            //           MESSAGE('%1',"Sales Invoice Header"."No.");
                        end;
                    end
                    else
                        if "Service Invoice Header".FindFirst then begin

                            Dias := "Posting Date" - "Service Invoice Header"."Posting Date";
                            if Dias > 30 then begin
                                Importe[15] += ImporteVta;
                                //         MESSAGE('%1',"Service Invoice Header"."No.");
                            end;
                        end

                end;
            end;

            trigger OnPreDataItem()
            begin
                SetFilter("Posting Date", "Sales Invoice Header".GetFilter("Posting Date"));
                if "Sales Invoice Header".GetFilter("Customer Posting Group") <> '' then
                    SetFilter("Customer Posting Group", "Sales Invoice Header".GetFilter("Customer Posting Group"));
            end;
        }
        dataitem("Integer"; "Integer")
        {
            DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));
            column(Nombre_Empresa; CompanyName)
            {
            }
            column(Filtros; Filtros)
            {
            }
            column(FORMAT_TODAY_0_4_; Format(Today, 0, 4))
            {
            }
            column(Fecha_Desde; FechaDesde)
            {
            }
            column(Fecha_Hasta; FechaHasta)
            {
            }
            column(USERID; UserId)
            {
            }
            column(ncfvalido_txt; ncfvalidotxt)
            {
            }
            column(ncfconsfinal_txt; ncfconsfinaltxt)
            {
            }
            column(ncfnotadb_txt; ncfnotadbtxt)
            {
            }
            column(ncfnotacr_txt; ncfnotacrtxt)
            {
            }
            column(ncfunicoingreso_txt; ncfunicoingresotxt)
            {
            }
            column(ncfregesp_txt; ncfregesptxt)
            {
            }
            column(ncfgobierno_txt; ncfgobiernotxt)
            {
            }
            column(noncf_txt; noncftxt)
            {
            }
            column(Efectivo_txt; Efectivotxt)
            {
            }
            column(Cheque_txt; Chequetxt)
            {
            }
            column(Tarjeta_txt; Tarjetatxt)
            {
            }
            column(ACredito_txt; ACreditotxt)
            {
            }
            column(Bonos_txt; Bonostxt)
            {
            }
            column(Permutas_txt; Permutastxt)
            {
            }
            column(Otros_txt; Otrostxt)
            {
            }
            column(NotasCr_txt; NotasCrtxt)
            {
            }
            column(importe_1; Importe[1])
            {
            }
            column(importe_2; Importe[2])
            {
            }
            column(importe_3; Importe[3])
            {
            }
            column(importe_4; Importe[4])
            {
            }
            column(importe_5; Importe[5])
            {
            }
            column(importe_6; Importe[6])
            {
            }
            column(importe_7; Importe[7])
            {
            }
            column(importe_8; Importe[8])
            {
            }
            column(importe_9; Importe[9])
            {
            }
            column(importe_10; Importe[10])
            {
            }
            column(importe_11; Importe[11])
            {
            }
            column(importe_12; Importe[12])
            {
            }
            column(importe_13; Importe[13])
            {
            }
            column(importe_14; Importe[14])
            {
            }
            column(importe_15; Importe[15])
            {
            }
            column(importe_16; Importe[16])
            {
            }
            column(Cantidad_1; Cantidad[1])
            {
            }
            column(Cantidad_2; Cantidad[2])
            {
            }
            column(Cantidad_3; Cantidad[3])
            {
            }
            column(Cantidad_4; Cantidad[4])
            {
            }
            column(Cantidad_5; Cantidad[5])
            {
            }
            column(Cantidad_6; Cantidad[6])
            {
            }
            column(Cantidad_7; Cantidad[7])
            {
            }
            column(Cantidad_8; Cantidad[8])
            {
            }
            column(Cantidad_9; Cantidad[9])
            {
            }
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
        PaymtMethod: Record "Payment Method";
        VE: Record "VAT Entry";
        NCF: Code[2];
        Importe: array[16] of Decimal;
        ncfvalidotxt: Label '1.- VALIDO PARA CREDITO FISCAL';
        ncfconsfinaltxt: Label '2.- CONSUMIDOR FINAL';
        ncfnotadbtxt: Label '3.- NOTA DE DEBITO';
        ncfnotacrtxt: Label '4.- NOTA DE CREDITO';
        ncfunicoingresotxt: Label '5.- REGISTRO UNICO DE INGRESOS';
        ncfregesptxt: Label '6.- REGISTRO REGIMENES ESPECIALES';
        ncfgobiernotxt: Label '7.- GUBERNAMENTALES';
        noncftxt: Label 'NO REQUIERE COMPROBANTES';
        Efectivotxt: Label '11.- EFECTIVO';
        Chequetxt: Label '12.- CHEQUE / TRANSFERENCIA';
        Tarjetatxt: Label '13.- TARJETA DEBITO / CREDITO';
        ACreditotxt: Label '14.- A CREDITO';
        Bonostxt: Label '15.- BONOS O CERTIFICADOS DE REGALO';
        Permutastxt: Label '16.- PERMUTAS';
        Otrostxt: Label '17.- OTRAS FORMAS DE PAGO';
        NotasCrtxt: Label '50.- NOTAS DE CREDITOS EMITIDAS CON MAS DE 30 DIAS DESDE LA FACTURACION';
        Cantidad: array[9] of Decimal;
        Filtros: Text[1020];
        Dias: Integer;
        ImporteVta: Decimal;
        FechaDesde: Date;
        FechaHasta: Date;
}

