report 76041 "Compra Bienes - Sevicios (606)"
{
    DefaultLayout = RDLC;
    RDLCLayout = './CompraBienesSevicios606.rdlc';

    dataset
    {
        dataitem("Purch. Inv. Header"; "Purch. Inv. Header")
        {
            DataItemTableView = SORTING("No.") ORDER(Ascending);
            RequestFilterFields = "No.", "Pay-to Vendor No.", "Posting Date";
            column(BuyfromVendorNo_PurchInvHeader; "Purch. Inv. Header"."Buy-from Vendor No.")
            {
            }
            column(No_PurchInvHeader; "Purch. Inv. Header"."No.")
            {
            }
            column(PostingDate_PurchInvHeader; "Purch. Inv. Header"."Posting Date")
            {
            }
            column(VendorInvoiceNo_PurchInvHeader; "Purch. Inv. Header"."Vendor Invoice No.")
            {
            }
            column(VATRegistrationNo_PurchInvHeader; "Purch. Inv. Header"."VAT Registration No.")
            {
            }
            column(PaytoName_PurchInvHeader; "Purch. Inv. Header"."Pay-to Name")
            {
            }
            column(NoComprobanteFiscal_PurchInvHeader; "Purch. Inv. Header"."No. Comprobante Fiscal")
            {
            }
            column(RNCProveedor; Vendor."VAT Registration No.")
            {
            }
            column(DirEmpresa1; DirEmpresa[1])
            {
            }
            column(DirEmpresa2; DirEmpresa[2])
            {
            }
            column(DirEmpresa3; DirEmpresa[3])
            {
            }
            column(DirEmpresa4; DirEmpresa[4])
            {
            }
            column(FiltrosPIH; FiltrosPIH)
            {
            }
            column(FiltrosCMH; FiltrosCMH)
            {
            }
            column(FiltrosGLE; FiltrosGLE)
            {
            }
            column(ImporteBase; ImporteBase)
            {
            }
            column(ImporteExento; ImporteExento)
            {
            }
            column(ImporteGravado; ImporteGravado)
            {
            }
            column(ImporteTotal; ImporteTotal)
            {
            }
            column(CodClasifGasto; "Purch. Inv. Header"."Cod. Clasificacion Gasto")
            {
            }
            column(ITBISPagado; ArchITBIS."ITBIS Pagado")
            {
            }
            column(ITBISRetenido; ArchITBIS."ITBIS Retenido")
            {
            }
            column(ISRRetenido; ArchITBIS."ISR Retenido")
            {
            }

            trigger OnAfterGetRecord()
            begin
                if (CopyStr("No. Comprobante Fiscal", 1, 10) = 'CORRECCION') or (CopyStr("No. Comprobante Fiscal", 1, 10) = 'CORRECTION') then
                    CurrReport.Skip;

                ImporteBase := 0;
                ImporteTotal := 0;
                ImporteITBIS := 0;
                ISRRetenido := 0;
                ImporteGravado := 0;
                ImporteExento := 0;
                "%ITBIS" := 0;
                ITBISRetenido := 0;
                ISRRetenido := 0;
                OtrasRetenciones := 0;
                Clear(txtCostosGastos);

                //ISR Retenido
                GLE.Reset;
                GLE.SetFilter("G/L Account No.", CtasRetencionISR);
                GLE.SetRange("Posting Date", "Posting Date");
                GLE.SetRange("Document Type", GLE."Document Type"::Payment);
                GLE.SetRange("Document No.", "No.");
                if GLE.FindSet() then
                    repeat
                        ISRRetenido += GLE.Amount * -1;
                    until GLE.Next = 0;

                GLE.Reset;
                GLE.SetFilter("G/L Account No.", CtasRetencionITBIS);
                GLE.SetRange("Posting Date", "Posting Date");
                GLE.SetRange("Document Type", GLE."Document Type"::Payment);
                GLE.SetRange("Document No.", "No.");
                if GLE.Find('-') then
                    repeat
                        ITBISRetenido += GLE.Amount * -1;
                    until GLE.Next = 0;

                //si se elige divisa local tenemos que hacer la conversion
                if DivAd then begin
                    VLE.Reset;
                    VLE.SetCurrentKey("Document No.", "Document Type", "Vendor No.");
                    VLE.SetRange("Document No.", "No.");
                    VLE.SetRange("Document Type", GLE."Document Type"::Payment);
                    VLE.SetRange("Vendor No.", "Buy-from Vendor No.");
                    VLE.SetRange("Posting Date", "Posting Date");
                    VLE.SetRange("Bal. Account Type", 0);
                    VLE.SetFilter("Bal. Account No.", CtasRetencionITBIS);
                    if VLE.FindFirst then begin
                        VLE.CalcFields(Amount);
                        ITBISRetenido := VLE.Amount * -1;
                    end;
                end;

                VE.Reset;
                VE.SetCurrentKey("Document No.", "Posting Date");
                VE.SetRange("Document No.", "No.");
                VE.SetRange("Posting Date", "Posting Date");
                VE.SetRange("Document Type", VE."Document Type"::Invoice);
                if VE.FindSet() then
                    repeat
                        if DivAd then begin
                            if VE.Amount <> 0 then
                                ImporteGravado += VE."Additional-Currency Base"
                            else
                                ImporteExento += VE."Additional-Currency Base";

                            ImporteITBIS += VE."Additional-Currency Amount";
                        end
                        else begin
                            if VE.Amount <> 0 then begin
                                ImporteGravado += VE.Base;
                                ImporteITBIS += VE.Amount;
                            end
                            else
                                ImporteExento += VE.Base;
                        end;
                    until VE.Next = 0;

                ImporteBase += ImporteGravado + ImporteExento;
                ImporteTotal := ImporteGravado + ImporteExento + ImporteITBIS;

                if not Vendor.Get("Buy-from Vendor No.") then
                    Vendor.Init;


                //Se llena la tabla ITBIS
                GpoContProv.Get("Vendor Posting Group");
                Clear(ArchITBIS);
                CalcFields("Amount Including VAT", Amount);
                ArchITBIS."Número Documento" := "No.";
                ArchITBIS.Dia := Format("Posting Date", 0, '<day,2>');
                ArchITBIS."Fecha Documento" := Format("Posting Date", 0, '<year4>') + Format("Posting Date", 0, '<Month,2>') +
                                                               Format("Posting Date", 0, '<day,2>');
                ArchITBIS.Apellidos := '';
                ArchITBIS.Nombres := '';
                ArchITBIS."Razón Social" := DelChr("Pay-to Name", '=', ',');
                ArchITBIS."Nombre Comercial" := ArchITBIS."Razón Social";

                if "VAT Registration No." <> '' then
                    RNCTxt := DelChr("VAT Registration No.", '=', '- ')
                else begin
                    Vendor.Get("Buy-from Vendor No.");
                    RNCTxt := DelChr(Vendor."VAT Registration No.", '=', '- ');
                end;
                RNCTxt := DelChr(RNCTxt, '=', '- ');
                if StrLen(RNCTxt) < 10 then
                    ArchITBIS.RNC := RNCTxt
                else
                    ArchITBIS.Cédula := CopyStr(RNCTxt, 1, 11);
                ArchITBIS."Total Documento" := ImporteBase;
                ArchITBIS."ITBIS Pagado" := ImporteITBIS;
                ArchITBIS."ITBIS Retenido" := ITBISRetenido;
                ArchITBIS."ISR Retenido" := ISRRetenido;

                if ArchITBIS.RNC <> '' then
                    ArchITBIS."RNC/Cedula" := ArchITBIS.RNC
                else
                    ArchITBIS."RNC/Cedula" := ArchITBIS.Cédula;

                //Para calcular el dia de pago
                VLE.Reset;
                VLE.SetRange(VLE."Vendor No.", "Purch. Inv. Header"."Buy-from Vendor No.");
                VLE.SetRange(VLE."Posting Date", "Posting Date");
                VLE.SetRange(VLE."Document Type", VLE."Document Type"::Invoice);
                VLE.SetRange("Document No.", "No.");
                VLE.SetFilter("Closed at Date", '<>%1', 0D);
                if VLE.FindFirst then
                    ArchITBIS."Dia Pago" := Format(VLE."Closed at Date", 0, '<day,2>')
                else begin
                    VLE.Reset;
                    VLE.SetRange(VLE."Vendor No.", "Purch. Inv. Header"."Buy-from Vendor No.");
                    VLE.SetRange(VLE."Posting Date", "Posting Date");
                    VLE.SetRange(VLE."Document Type", VLE."Document Type"::Invoice);
                    VLE.SetRange("Document No.", "No.");
                    if VLE.FindFirst then begin
                        VLE1.Reset;
                        VLE1.SetRange("Vendor No.", "Buy-from Vendor No.");
                        VLE1.SetRange("Document Type", VLE1."Document Type"::Payment);
                        VLE1.SetRange("Closed by Entry No.", VLE."Entry No.");
                        if VLE1.FindFirst then
                            ArchITBIS."Dia Pago" := Format(VLE."Posting Date", 0, '<day,2>');
                    end
                end;

                ArchITBIS.NCF := "No. Comprobante Fiscal";
                ArchITBIS."Clasific. Gastos y Costos NCF" := "Cod. Clasificacion Gasto";
                ArchITBIS."Tipo documento" := 1; //Factura
                ArchITBIS."Codigo reporte" := '606';
                if not ArchITBIS.Insert then
                    Error(Error001);
            end;

            trigger OnPreDataItem()
            begin
                InfoEmpresa.Get;
                DirEmpresa[1] := InfoEmpresa.Name;
                DirEmpresa[2] := InfoEmpresa."Name 2";
                DirEmpresa[3] := InfoEmpresa.Address;
                DirEmpresa[4] := InfoEmpresa."Address 2";
                DirEmpresa[5] := InfoEmpresa.City;
                DirEmpresa[6] := InfoEmpresa."Post Code" + ' ' + InfoEmpresa.County;
                DirEmpresa[7] := txt001 + InfoEmpresa."VAT Registration No.";
                CompressArray(DirEmpresa);

                FiltroGpoContProv := GetFilter("Vendor Posting Group");
                FechaIni := GetRangeMin("Posting Date");
                FechaFin := GetRangeMax("Posting Date");
            end;
        }
        dataitem("Purch. Cr. Memo Hdr."; "Purch. Cr. Memo Hdr.")
        {
            DataItemTableView = SORTING("No.") ORDER(Ascending);
            column(VATRegistrationNo_PurchCrMemoHdr; "Purch. Cr. Memo Hdr."."VAT Registration No.")
            {
            }
            column(BuyfromVendorNo_PurchCrMemoHdr; "Purch. Cr. Memo Hdr."."Buy-from Vendor No.")
            {
            }
            column(No_PurchCrMemoHdr; "Purch. Cr. Memo Hdr."."No.")
            {
            }
            column(PaytoName_PurchCrMemoHdr; "Purch. Cr. Memo Hdr."."Pay-to Name")
            {
            }
            column(PostingDate_PurchCrMemoHdr; "Purch. Cr. Memo Hdr."."Posting Date")
            {
            }
            column(VendorCrMemoNo_PurchCrMemoHdr; "Purch. Cr. Memo Hdr."."Vendor Cr. Memo No.")
            {
            }
            column(NoComprobanteFiscal_PurchCrMemoHdr; "Purch. Cr. Memo Hdr."."No. Comprobante Fiscal")
            {
            }
            column(NoComprobanteFiscalRel_PurchCrMemoHdr; "Purch. Cr. Memo Hdr."."No. Comprobante Fiscal Rel.")
            {
            }
            column(ImporteBaseNCr; ImporteBaseNCr)
            {
            }
            column(PorcentITBISNCr; "%ITBISNCr")
            {
            }
            column(CodClasifGtoNCr; "Purch. Cr. Memo Hdr."."Cod. Clasificacion Gasto")
            {
            }
            column(ImporteITBISNCr; ImporteITBISNCr)
            {
            }
            column(ImporteGravadoNCr; ImporteGravadoNCr)
            {
            }
            column(ImporteExentoNCr; ImporteExentoNCr)
            {
            }
            column(ImporteTotalNCr; ImporteTotalNCr)
            {
            }
            column(ImporteGpoNCr; ImporteGpoNCr)
            {
            }

            trigger OnAfterGetRecord()
            begin
                if CopyStr("No. Comprobante Fiscal", 1, 10) = 'CORRECCION' then
                    CurrReport.Skip;

                if "Applies-to Doc. No." <> '' then begin
                    if PIH.Get("Applies-to Doc. No.") then
                        if (CopyStr(PIH."No. Comprobante Fiscal", 1, 10) = 'CORRECCION') or
                           (CopyStr(PIH."No. Comprobante Fiscal", 1, 10) = 'CORRECTION') then
                            CurrReport.Skip;
                end;

                if "Purch. Cr. Memo Hdr."."Correccion Doc. NCF" then
                    CurrReport.Skip;

                ImporteBaseNCr := 0;
                ImporteTotalNCr := 0;
                ImporteITBISNCr := 0;
                "%ITBISNCr" := 0;
                ISRRetenidoNCR := 0;

                //Retencion ISR
                GLE.Reset;
                GLE.SetFilter("G/L Account No.", CtasRetencionISR);
                GLE.SetRange("Posting Date", "Posting Date");
                GLE.SetRange("Document Type", GLE."Document Type"::Payment);
                GLE.SetRange("Document No.", "No.");
                if GLE.FindSet() then
                    repeat
                        ISRRetenidoNCR += GLE.Amount;
                    until GLE.Next = 0;
                //Retencion ISR


                //Retencion ITBIS
                GLE.Reset;
                GLE.SetFilter("G/L Account No.", CtasRetencionITBIS);
                GLE.SetRange("Posting Date", "Posting Date");
                GLE.SetRange("Document Type", GLE."Document Type"::Payment);
                GLE.SetRange("Document No.", "No.");
                if GLE.FindSet() then
                    repeat
                        ITBISRetenidoNCR += GLE.Amount;
                    until GLE.Next = 0;
                //Retencion ITBIS

                if DivAd then begin
                    VLE.Reset;
                    VLE.SetCurrentKey("Document No.", "Document Type", "Vendor No.");
                    VLE.SetRange("Document No.", "No.");
                    VLE.SetRange("Document Type", VLE."Document Type"::Payment);
                    VLE.SetRange("Vendor No.", "Buy-from Vendor No.");
                    VLE.SetRange("Posting Date", "Posting Date");
                    VLE.SetRange("Bal. Account Type", 0);
                    VLE.SetRange("Bal. Account No.", CtasRetencionITBIS);
                    if VLE.FindFirst then begin
                        VLE.CalcFields(Amount);
                        ITBISRetenidoNCR := VLE.Amount;
                    end;
                end;


                VE.Reset;
                VE.SetCurrentKey("Document No.", "Posting Date");
                VE.SetRange("Document No.", "No.");
                VE.SetRange("Posting Date", "Posting Date");
                VE.SetRange("Document Type", VE."Document Type"::"Credit Memo");
                if VE.FindSet then
                    repeat
                        if DivAd then begin
                            if VE.Amount <> 0 then
                                ImporteGravadoNCr += VE."Additional-Currency Base" * -1
                            else
                                ImporteExentoNCr += VE."Additional-Currency Base" * -1;

                            ImporteITBISNCr += VE."Additional-Currency Amount" * -1;
                        end
                        else begin
                            if VE.Amount <> 0 then
                                ImporteGravadoNCr += VE.Base * -1
                            else
                                ImporteExentoNCr += VE.Base * -1;

                            ImporteITBISNCr += VE.Amount * -1;
                        end;
                    until VE.Next = 0;

                ImporteTotalNCr := ImporteGravadoNCr + ImporteExentoNCr + ImporteITBISNCr;
                ImporteBaseNCr := ImporteGravadoNCr + ImporteExentoNCr;

                if not Vendor.Get("Buy-from Vendor No.") then
                    Vendor.Init;

                //Se llena la tabla ITBIS
                Clear(ArchITBIS);
                CalcFields("Amount Including VAT", Amount);
                ArchITBIS."Número Documento" := "No.";
                ArchITBIS.Dia := Format("Posting Date", 0, '<day,2>');
                ArchITBIS."Fecha Documento" := Format("Posting Date", 0, '<year4>') + Format("Posting Date", 0, '<Month,2>') +
                                                    Format("Posting Date", 0, '<day,2>');
                ArchITBIS.Apellidos := '';
                ArchITBIS.Nombres := '';
                ArchITBIS."Razón Social" := DelChr("Pay-to Name", '=', ',');
                ArchITBIS."Nombre Comercial" := ArchITBIS."Razón Social";
                RNCTxt := DelChr(Vendor."VAT Registration No.", '=', '- ');
                if StrLen(RNCTxt) < 10 then
                    ArchITBIS.RNC := RNCTxt
                else
                    ArchITBIS.Cédula := CopyStr(RNCTxt, 1, 11);
                ArchITBIS."Total Documento" := Amount;
                ArchITBIS."ITBIS Pagado" := "Amount Including VAT" - Amount;
                ArchITBIS.NCF := "No. Comprobante Fiscal";
                ArchITBIS."ITBIS Retenido" := ITBISRetenidoNCR;
                ArchITBIS."ISR Retenido" := ISRRetenidoNCR;


                if ArchITBIS.RNC <> '' then
                    ArchITBIS."RNC/Cedula" := ArchITBIS.RNC
                else
                    ArchITBIS."RNC/Cedula" := ArchITBIS.Cédula;


                //002 de los NCF relacionados buscamos el del importe mayor
                //Buscamos el mov. cliente perteneciente al abono.
                NCFLiq.Reset;
                if NCFLiq.FindSet then
                    NCFLiq.DeleteAll;

                VLE.Reset;
                VLE.SetCurrentKey("Document No.", "Document Type", "Vendor No.");
                VLE.SetRange("Vendor No.", "Buy-from Vendor No.");
                VLE.SetRange("Posting Date", "Posting Date");
                VLE.SetRange("Document Type", VLE."Document Type"::"Credit Memo");
                VLE.SetRange("Document No.", "No.");
                if VLE.FindFirst then begin
                    //Buscamos los movimientos que la cerraron
                    if VLE."Closed by Entry No." <> 0 then begin
                        if VLECopy.Get(VLE."Closed by Entry No.") then begin
                            //Buscamos el historico de factura para capturar el NCF
                            PIH.Reset;
                            PIH.SetRange("No.", VLECopy."Document No.");
                            if PIH.FindFirst then begin
                                NCFLiq.NCF := PIH."No. Comprobante Fiscal";
                                if not NCFLiq.Insert then
                                    NCFLiq.Modify;
                            end;
                        end;
                    end;

                    //Buscamos movimientos cerrados por ella
                    VLECopy.Reset;
                    VLECopy.SetCurrentKey("Closed by Entry No.");
                    VLECopy.SetRange("Closed by Entry No.", VLE."Entry No.");
                    if VLECopy.FindSet() then
                        repeat
                            //Buscamos el historico de factura para capturar el NCF
                            PIH.Reset;
                            PIH.SetRange("No.", VLECopy."Document No.");
                            if PIH.FindFirst then begin
                                NCFLiq.NCF := PIH."No. Comprobante Fiscal";
                                if not NCFLiq.Insert then
                                    NCFLiq.Modify;
                            end;
                        until VLECopy.Next = 0;
                end;

                NCFLiq.SetCurrentKey(NCFLiq.Importe);
                if NCFLiq.Find('+') then
                    ArchITBIS."NCF Relacionado" := NCFLiq.NCF;

                NCFLiq.Reset;
                if NCFLiq.Find('-') then
                    repeat
                        NCFLiq.Delete;
                    until NCFLiq.Next = 0;

                //ArchITBIS."Clasific. Gastos y Costos NCF" := txtCostosGastos;
                ArchITBIS."Clasific. Gastos y Costos NCF" := "Cod. Clasificacion Gasto";
                ArchITBIS."Tipo documento" := 2; //Nota de credito
                ArchITBIS."Codigo reporte" := '606';
                if not ArchITBIS.Insert then
                    Error(Error001);
            end;

            trigger OnPreDataItem()
            begin
                //CurrReport.PageNo := 1;

                SetFilter("Vendor Posting Group", FiltroGpoContProv);
                SetRange("Posting Date", FechaIni, FechaFin);
                if "Purch. Inv. Header".GetFilter("Shortcut Dimension 1 Code") <> '' then
                    SetFilter("Shortcut Dimension 1 Code", "Purch. Inv. Header".GetFilter("Shortcut Dimension 1 Code"));
                if "Purch. Inv. Header".GetFilter("Shortcut Dimension 2 Code") <> '' then
                    SetFilter("Shortcut Dimension 2 Code", "Purch. Inv. Header".GetFilter("Shortcut Dimension 2 Code"));

                //CurrReport.CreateTotals(ImporteBaseNCr, ImporteTotalNCr, ImporteITBISNCr, ImporteExentoNCr, ImporteGravadoNCr);
            end;
        }
        dataitem("G/L Entry"; "G/L Entry")
        {
            DataItemTableView = SORTING("G/L Account No.", "Posting Date") ORDER(Ascending);
            RequestFilterFields = "G/L Account No.";
            column(GLAccountNo_GLEntry; "G/L Entry"."G/L Account No.")
            {
            }
            column(PostingDate_GLEntry; "G/L Entry"."Posting Date")
            {
            }
            column(Amount_GLEntry; "G/L Entry".Amount)
            {
            }
            column(NoComprobanteFiscal_GLEntry; "G/L Entry"."No. Comprobante Fiscal")
            {
            }

            trigger OnAfterGetRecord()
            begin
                Clear(ArchITBIS);
                ArchITBIS."Número Documento" := "Document No.";
                ArchITBIS.Dia := Format("Posting Date", 0, '<day,2>');
                ArchITBIS."Fecha Documento" := Format("Posting Date", 0, '<year4>') + Format("Posting Date", 0, '<Month,2>') +
                                                    Format("Posting Date", 0, '<day,2>');
                ArchITBIS.Apellidos := '';
                ArchITBIS.Nombres := '';
                ArchITBIS."Razón Social" := '';
                ArchITBIS."Nombre Comercial" := '';
                RNCTxt := DelChr(InfoEmpresa."VAT Registration No.", '=', '- ');
                if StrLen(RNCTxt) < 10 then
                    ArchITBIS.RNC := RNCTxt
                else
                    ArchITBIS.Cédula := CopyStr(RNCTxt, 1, 11);

                ArchITBIS."Total Documento" := Amount;
                ArchITBIS."ITBIS Pagado" := 0;
                ArchITBIS.NCF := "No. Comprobante Fiscal";
                ArchITBIS."NCF Relacionado" := '';
                ArchITBIS."Clasific. Gastos y Costos NCF" := "Cod. Clasificacion Gasto";
                ArchITBIS."Codigo reporte" := '606';

                if ArchITBIS.RNC <> '' then
                    ArchITBIS."RNC/Cedula" := ArchITBIS.RNC
                else
                    ArchITBIS."RNC/Cedula" := ArchITBIS.Cédula;
                ArchITBIS."No. Mov." := "Entry No.";
                ArchITBIS.Insert;
            end;

            trigger OnPreDataItem()
            begin
                SetRange("Posting Date", FechaIni, FechaFin);
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
                field(CtasRetencionITBIS; CtasRetencionITBIS)
                {
                ApplicationArea = All;
                    Caption = 'ITBIS Retention Account';
                    TableRelation = "G/L Account";
                }
                field(CtasRetencionISR; CtasRetencionISR)
                {
                ApplicationArea = All;
                    Caption = 'ISR Retention Account';
                    TableRelation = "G/L Account";
                }
                field(DivAd; DivAd)
                {
                ApplicationArea = All;
                    Caption = 'Currency';
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
        ArchITBIS.Reset;
        ArchITBIS.SetRange("Codigo reporte", '606');
        ArchITBIS.DeleteAll;

        FiltrosPIH := "Purch. Inv. Header".GetFilters;
        FiltrosCMH := "Purch. Cr. Memo Hdr.".GetFilters;
        FiltrosGLE := "G/L Entry".GetFilters;

        if "G/L Entry".GetFilter("G/L Account No.") = '' then
            Error(Error002, "G/L Entry".FieldCaption("G/L Entry"."G/L Account No."), txt002);

        if "G/L Entry".GetFilter("Posting Date") = '' then
            Error(Error002, "G/L Entry".FieldCaption("Posting Date"), txt002);
    end;

    var
        InfoEmpresa: Record "Company Information";
        DirEmpresa: array[7] of Text[50];
        ImporteBase: Decimal;
        "%ITBIS": Decimal;
        ImporteITBIS: Decimal;
        ImporteGravado: Decimal;
        ImporteExento: Decimal;
        ImporteTotal: Decimal;
        ImporteGpo: Decimal;
        DebeGpo: Decimal;
        HaberGpo: Decimal;
        FiltroGpoContProv: Text[150];
        FechaIni: Date;
        FechaFin: Date;
        ImporteBaseNCr: Decimal;
        "%ITBISNCr": Decimal;
        ImporteITBISNCr: Decimal;
        ImporteGravadoNCr: Decimal;
        ImporteExentoNCr: Decimal;
        ImporteTotalNCr: Decimal;
        ImporteGpoNCr: Decimal;
        RNCTxt: Text[30];
        GeneraArchivoITBIS: Boolean;
        Clasificacion: Code[2];
        ITBISRetenido: Decimal;
        CtasRetencionITBIS: Code[100];
        OtrasRetenciones: Decimal;
        CtasRetencionISR: Code[100];
        ISRRetenido: Decimal;
        ISRRetenidoNCR: Decimal;
        txt001: Label 'RNC/Cédula ';
        txtCostosGastos: Text[2];
        GLE: Record "G/L Entry";
        DivAd: Boolean;
        VLE: Record "Vendor Ledger Entry";
        VLE1: Record "Vendor Ledger Entry";
        VE: Record "VAT Entry";
        Vendor: Record Vendor;
        PIH: Record "Purch. Inv. Header";
        ITBISRetenidoNCR: Decimal;
        ArchITBIS: Record "Archivo Transferencia ITBIS";
        FiltrosPIH: Text[1024];
        FiltrosCMH: Text[1024];
        FiltrosGLE: Text[1024];
        GpoContProv: Record "Vendor Posting Group";
        txt002: Label 'G/L Entry';
        Error001: Label 'Ya existen registro similares en la tabla de archivo NCF, favor limpiarla';
        Error002: Label 'Filter Required for the field %1 of the table %2';
        NCFLiq: Record "NCF liquidados";
        VLECopy: Record "Vendor Ledger Entry";
}

