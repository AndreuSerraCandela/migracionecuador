report 76091 "ITBIS Ventas 2018 (607)"
{
    DefaultLayout = RDLC;
    RDLCLayout = './ITBISVentas2018607.rdlc';

    dataset
    {
        dataitem("Sales Invoice Header"; "Sales Invoice Header")
        {
            CalcFields = Amount, "Amount Including VAT";
            DataItemTableView = SORTING("No.") ORDER(Ascending) WHERE(Correction = CONST(false));
            RequestFilterFields = "Posting Date", "Customer Posting Group", "Shortcut Dimension 1 Code";
            column(No_SalesInvoiceHeader; "Sales Invoice Header"."No.")
            {
            }
            column(BilltoCustomerNo_SalesInvoiceHeader; "Sales Invoice Header"."Bill-to Customer No.")
            {
            }
            column(BilltoName_SalesInvoiceHeader; "Sales Invoice Header"."Bill-to Name")
            {
            }
            column(PostingDate_SalesInvoiceHeader; "Sales Invoice Header"."Posting Date")
            {
            }
            column(NoComprobanteFiscal_SalesInvoiceHeader; "Sales Invoice Header"."No. Comprobante Fiscal")
            {
            }
            column(RNCCliente; Cust."VAT Registration No.")
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
            column(ImporteITBIS; ImporteITBIS)
            {
            }
            column(ImporteTotal; ImporteTotal)
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
            column(FiltrosSIH; FiltrosSIH)
            {
            }
            column(FiltrosSCMH; FiltrosSCMH)
            {
            }
            column(FiltrosDPP; FiltrosHDPP)
            {
            }
            column(ImporteITBIS16; ImporteITBIS16)
            {
            }
            column(ImporteITBIS18; ImporteITBIS18)
            {
            }
            column(BaseITBIS16; BaseITBIS16)
            {
            }
            column(BaseITBIS18; BaseITBIS18)
            {
            }
            column(FiltrosSIH_S; FiltrosSIH)
            {
            }
            column(FiltrosSCMH_S; FiltrosSCMH)
            {
            }

            trigger OnAfterGetRecord()
            begin
                ImporteBase := 0;
                ImporteTotal := 0;
                ImporteITBIS := 0;
                "%ITBIS" := 0;
                ImporteExento := 0;
                ImporteGravado := 0;
                ImporteGravado := 0;
                ImporteExento := 0;
                ImporteSelectivo := 0;
                ImporteBien := 0;
                ImporteServicios := 0;
                ImportePropina := 0;
                ImporteOtros := 0;
                ITBISRetenido := 0;
                ImporteITBIS16 := 0;
                ImporteITBIS18 := 0;
                BaseITBIS16 := 0;
                BaseITBIS18 := 0;
                FactorDivisaAdicional := 0;
                FactorDivisa := 0;

                if "No. Comprobante Fiscal" = '' then
                    CurrReport.Skip;

                //para excluir las que tiene corregida.
                SCMH.Reset;
                SCMH.SetRange("No. Comprobante Fiscal Rel.", "No. Comprobante Fiscal");
                SCMH.SetRange(Correction, true);
                SCMH.SetRange("Sell-to Customer No.", "Sell-to Customer No.");
                if SCMH.FindLast then begin // verificar si no hay una Factura correctiva anulando la nc
                    SIH.Reset;
                    SIH.SetRange("Applies-to Doc. No.", SCMH."No.");
                    SIH.SetRange(Correction, true);
                    SIH.SetRange("Sell-to Customer No.", SCMH."Sell-to Customer No.");
                    if not SIH.FindFirst then
                        CurrReport.Skip;
                end;

                //jpg 03-08-2021 validar si es una nc valida por correcion de texto no monto o si es un nc eliminada con ncf
                CalcFields("Amount Including VAT", Amount);
                if "Amount Including VAT" = 0 then begin
                    SalesInvoiceLine.Reset;
                    SalesInvoiceLine.SetRange("Document No.", "No.");
                    SalesInvoiceLine.SetRange(Description, 'Deleted Document');
                    if SalesInvoiceLine.FindFirst then
                        CurrReport.Skip;
                end;


                if DivAd then begin
                    VE.Reset;
                    VE.SetCurrentKey("Document No.", "Posting Date");
                    VE.SetRange("Document No.", "No.");
                    VE.SetRange("Posting Date", "Posting Date");
                    VE.SetRange(VE."Document Type", VE."Document Type"::Invoice);
                    VE.SetFilter(Base, '<0'); //para excluir lineas anticipo
                    if VE.FindSet() then
                        repeat
                            if VE.Amount <> 0 then begin
                                ImporteGravado += VE."Additional-Currency Base" * -1;
                                ImporteITBIS += VE."Additional-Currency Amount" * -1;

                                if VPSetup.Get(VE."VAT Bus. Posting Group", VE."VAT Prod. Posting Group") then begin
                                    if VPSetup."VAT %" = 18 then begin
                                        ImporteITBIS18 += VE."Additional-Currency Amount" * -1;
                                        BaseITBIS18 += VE."Additional-Currency Base" * -1;
                                    end;

                                    if VPSetup."VAT %" = 16 then begin
                                        ImporteITBIS16 += VE."Additional-Currency Amount" * -1;
                                        BaseITBIS16 += VE."Additional-Currency Base" * -1;
                                    end;
                                end;

                            end
                            else
                                ImporteExento += VE."Additional-Currency Base" * -1;

                            //para capturar factor divisa adicional.
                            if (FactorDivisaAdicional = 0) and ("Currency Code" = '') then
                                FactorDivisaAdicional := Abs(VE."Additional-Currency Base") / Abs(VE.Base);


                        until VE.Next = 0;
                end
                else begin
                    VE.Reset;
                    VE.SetCurrentKey("Document No.", "Posting Date");
                    VE.SetRange("Document No.", "No.");
                    VE.SetRange("Posting Date", "Posting Date");
                    VE.SetRange(VE."Document Type", VE."Document Type"::Invoice);
                    VE.SetFilter(Base, '<0'); //para excluir lineas anticipo
                    if VE.FindSet() then
                        repeat
                            if VE.Amount <> 0 then begin
                                ImporteGravado += VE.Base * -1;
                                ImporteITBIS += VE.Amount * -1;

                                if VPSetup.Get(VE."VAT Bus. Posting Group", VE."VAT Prod. Posting Group") then begin
                                    if VPSetup."VAT %" = 18 then begin
                                        ImporteITBIS18 += VE.Amount * -1;
                                        BaseITBIS18 += VE.Base * -1;
                                    end;

                                    if VPSetup."VAT %" = 16 then begin
                                        ImporteITBIS16 += VE.Amount * -1;
                                        BaseITBIS16 += VE.Base * -1;
                                    end;
                                end;

                            end
                            else
                                ImporteExento += VE.Base * -1;
                        until VE.Next = 0;
                end;

                /*
               IF DivAd THEN
                 BEGIN
                   VE.RESET;
                   VE.SETCURRENTKEY("Document No.","Posting Date");
                   VE.SETRANGE("Document No.","No.");
                   VE.SETRANGE("Posting Date","Posting Date");
                   VE.SETRANGE("Document Type",VE."Document Type"::Invoice);
                   IF VE.FINDSET(FALSE,FALSE) THEN
                     REPEAT
                       IF NOT VPPG.GET(VE."VAT Prod. Posting Group") THEN
                         VPPG.INIT;
                       CASE VPPG."Tipo de bien-servicio" OF
                         0: //Bien
                           ImporteBien += VE."Additional-Currency Base"*-1;
                         1: //Servicio
                           ImporteServicios += VE."Additional-Currency Base"*-1;
                         2: //Selectivo
                           ImporteSelectivo += VE."Additional-Currency Base"*-1;
                         3: //Propina
                           ImportePropina += VE."Additional-Currency Base"*-1;
                         ELSE //Otro
                           ImporteOtros += VE."Additional-Currency Base"*-1;
                       END;
                     UNTIL VE.NEXT = 0;
                 END
               ELSE
                 BEGIN
                   VE.RESET;
                   VE.SETCURRENTKEY("Document No.","Posting Date");
                   VE.SETRANGE("Document No.","No.");
                   VE.SETRANGE("Posting Date","Posting Date");
                   VE.SETRANGE("Document Type",VE."Document Type"::Invoice);
                   IF VE.FINDSET(FALSE,FALSE) THEN
                     REPEAT
                       IF NOT VPPG.GET(VE."VAT Prod. Posting Group") THEN
                         VPPG.INIT;
                       CASE VPPG."Tipo de bien-servicio" OF
                         0: //Bien
                           ImporteBien += VE.Base*-1;
                         1: //Servicio
                           ImporteServicios += VE.Base*-1;
                         2: //Selectivo
                           ImporteSelectivo += VE.Base*-1;
                         3: //Propina
                           ImportePropina += VE.Base*-1;
                         ELSE //Otro
                           ImporteOtros += VE.Base*-1;
                       END;
                     UNTIL VE.NEXT = 0;
                 END;
                 */

                SIL.Reset;
                SIL.SetRange("Document No.", "No.");
                SIL.SetFilter(Quantity, '>0');
                if SIL.FindSet then
                    repeat
                        if not VPPG.Get(SIL."VAT Prod. Posting Group") then
                            VPPG.Init;
                        if DivAd and ("Currency Code" = '') then begin
                            case VPPG."Tipo de bien-servicio" of
                                0: //Bien
                                    ImporteBien += SIL.Amount * FactorDivisaAdicional;
                                1: //Servicio
                                    ImporteServicios += SIL.Amount * FactorDivisaAdicional;
                                2: //Selectivo
                                    ImporteSelectivo += SIL.Amount * FactorDivisaAdicional;
                                3: //Propina
                                    ImportePropina += SIL.Amount * FactorDivisaAdicional;
                                else //Otro
                                    ImporteOtros += SIL.Amount * FactorDivisaAdicional
                            end;
                        end else begin
                            ///008 conversion factura otra monedas.
                            if "Currency Code" <> '' then
                                FactorDivisa := "Currency Factor"
                            else
                                FactorDivisa := 1;

                            case VPPG."Tipo de bien-servicio" of
                                0: //Bien
                                    ImporteBien += SIL.Amount / FactorDivisa;
                                1: //Servicio
                                    ImporteServicios += SIL.Amount / FactorDivisa;
                                2: //Selectivo
                                    ImporteSelectivo += SIL.Amount / FactorDivisa;
                                3: //Propina
                                    ImportePropina += SIL.Amount / FactorDivisa;
                                else //Otro
                                    ImporteOtros += SIL.Amount / FactorDivisa;
                            end;
                        end;
                    until SIL.Next = 0;

                ImporteTotal := ImporteGravado + ImporteExento + ImporteITBIS;
                ImporteBase += ImporteGravado + ImporteExento - ImporteSelectivo - ImportePropina - ImporteOtros;

                tImporteBase += Abs(ImporteBase);
                tImporteTotal += Abs(ImporteTotal);
                tImporteITBIS += Abs(ImporteITBIS);
                tImporteGravado += Abs(ImporteGravado);
                tImporteExento += Abs(ImporteExento);

                if not Cust.Get("Sell-to Customer No.") then
                    Cust.Init;



                //Busco la forma de pago
                if not FormaPago.Get("Payment Method Code") or ("Payment Method Code" = '') then
                    FormaPago."Forma de pago DGII" := FormaPago."Forma de pago DGII"::"2 - Cheques/Transferencias/Depositos";


                //Se llena la tabla de ITBIS
                GCC.Get("Customer Posting Group");
                Clear(ArchITBIS);
                CalcFields("Amount Including VAT", Amount);
                ArchITBIS."Número Documento" := "No.";
                ArchITBIS."Fecha Documento" := Format("Posting Date", 0, '<year4>') + Format("Posting Date", 0, '<Month,2>') +
                                                    Format("Posting Date", 0, '<day,2>');

                ArchITBIS.Apellidos := '';
                ArchITBIS.Nombres := '';
                ArchITBIS."Cod. Proveedor" := "Bill-to Customer No.";
                ArchITBIS."Razón Social" := DelChr(CopyStr("Bill-to Name", 1, 60), '=', ',');
                ArchITBIS."Nombre Comercial" := ArchITBIS."Razón Social";
                RNCTxt := DelChr("VAT Registration No.", '=', '- ');
                if StrLen(RNCTxt) < 10 then
                    ArchITBIS.RNC := RNCTxt
                else
                    ArchITBIS.Cédula := CopyStr(RNCTxt, 1, 11);
                ArchITBIS."Total Documento" := ImporteBase;
                ArchITBIS."ITBIS Pagado" := Abs(ImporteITBIS);
                ArchITBIS."Fecha Pago" := ArchITBIS."Fecha Documento";
                ArchITBIS.NCF := "No. Comprobante Fiscal";
                ArchITBIS."Tipo documento" := 1; //Factura
                ArchITBIS."Forma de pago DGII" := FormaPago."Forma de pago DGII";
                ArchITBIS."Tipo de ingreso" := DelChr("Tipo de ingreso", '=', '0');
                ArchITBIS."Monto Bienes" := ImporteBien;
                ArchITBIS."Monto Servicios" := ImporteServicios;
                ArchITBIS."Monto Selectivo" := ImporteSelectivo;
                ArchITBIS."Monto Propina" := ImportePropina;
                ArchITBIS."Monto otros" := ImporteOtros;
                ArchITBIS."Codigo reporte" := '607';
                case FormaPago."Forma de pago DGII" of
                    1:
                        ArchITBIS."Monto Efectivo" := ImporteTotal;
                    2:
                        ArchITBIS."Monto Cheque" := ImporteTotal;
                    3:
                        ArchITBIS."Monto tarjetas" := ImporteTotal;
                    4:
                        ArchITBIS."Venta a credito" := ImporteTotal;
                    5:
                        ArchITBIS."Venta bonos" := ImporteTotal;
                    6:
                        ArchITBIS."Venta Permuta" := ImporteTotal;
                    7:
                        begin //jpg pago mixto +
                            Clear(ImporteTotal2);
                            CustLedgerEntry.Reset;
                            CustLedgerEntry.SetRange("Document No.", "No.");
                            CustLedgerEntry.SetFilter("Document Type", '%1|%2', CustLedgerEntry."Document Type"::" ", CustLedgerEntry."Document Type"::Payment);
                            CustLedgerEntry.SetRange("Posting Date", "Posting Date");
                            if CustLedgerEntry.FindSet then
                                repeat

                                    Clear(ImporteTotal2);
                                    DetailedCustLedgEntry.Reset;
                                    DetailedCustLedgEntry.SetRange("Ledger Entry Amount", true);
                                    DetailedCustLedgEntry.SetRange("Cust. Ledger Entry No.", CustLedgerEntry."Entry No.");
                                    DetailedCustLedgEntry.SetRange("Posting Date", CustLedgerEntry."Posting Date");
                                    DetailedCustLedgEntry.CalcSums(Amount);
                                    ImporteTotal2 := Abs(DetailedCustLedgEntry.Amount);

                                    if DivAd and ("Currency Code" = '') and (FactorDivisaAdicional <> 0) then
                                        ImporteTotal2 := Abs(DetailedCustLedgEntry.Amount) * FactorDivisaAdicional;

                                    FormaPago.Reset;
                                    FormaPago.SetRange(Code, DelChr(SelectStr(2, CustLedgerEntry.Description), '=', ' '));
                                    if FormaPago.FindFirst then
                                        case FormaPago."Forma de pago DGII" of
                                            1:
                                                ArchITBIS."Monto Efectivo" += ImporteTotal2;
                                            2:
                                                ArchITBIS."Monto Cheque" += ImporteTotal2;
                                            3:
                                                ArchITBIS."Monto tarjetas" += ImporteTotal2;
                                            4:
                                                ArchITBIS."Venta a credito" += ImporteTotal2;
                                            5:
                                                ArchITBIS."Venta bonos" += ImporteTotal2;
                                            6:
                                                ArchITBIS."Venta Permuta" += ImporteTotal2;
                                        end;

                                until CustLedgerEntry.Next = 0;
                            //jpg si no encontro improte en ninguna forma pago coloco a credito
                            if ((ArchITBIS."Monto Efectivo" + ArchITBIS."Monto Cheque" + ArchITBIS."Monto tarjetas" + ArchITBIS."Venta a credito"
                             + ArchITBIS."Venta bonos" + ArchITBIS."Venta Permuta") = 0) then begin
                                FormaPago."Forma de pago DGII" := FormaPago."Forma de pago DGII"::"2 - Cheques/Transferencias/Depositos";
                                ArchITBIS."Monto Cheque" := ImporteTotal;
                            end;
                            // ArchITBIS."Monto mixto" := "amount including vat";
                        end
                end;
                //jpg pago mixto --
                ArchITBIS."Forma de pago DGII" := FormaPago."Forma de pago DGII";

                if ArchITBIS.RNC <> '' then begin
                    ArchITBIS."RNC/Cedula" := ArchITBIS.RNC;
                    ArchITBIS."Tipo Identificacion" := 1;
                end
                else begin
                    ArchITBIS."RNC/Cedula" := ArchITBIS.Cédula;
                    ArchITBIS."Tipo Identificacion" := 2;
                end;

                if (CopyStr(ArchITBIS.NCF, 1, 3) = 'B02') and ((ArchITBIS."Total Documento") <= 250000) then // jpg 02/07/2021 evaluar sin itbis
                    CurrReport.Skip;

                NumeroLinea += 1;
                ArchITBIS."Line No." := NumeroLinea;

                if not ArchITBIS.Insert then
                    Error(Error001);

            end;
        }
        dataitem("Sales Cr.Memo Header"; "Sales Cr.Memo Header")
        {
            CalcFields = Amount, "Amount Including VAT";
            DataItemTableView = SORTING("No.") ORDER(Ascending) WHERE(Correction = CONST(false));
            RequestFilterFields = "Posting Date", "Customer Posting Group", "Shortcut Dimension 1 Code";
            column(NoComprobanteFiscal_SalesCrMemoHeader; "Sales Cr.Memo Header"."No. Comprobante Fiscal")
            {
            }
            column(NoComprobanteFiscalRel_SalesCrMemoHeader; "Sales Cr.Memo Header"."No. Comprobante Fiscal Rel.")
            {
            }
            column(No_SalesCrMemoHeader; "Sales Cr.Memo Header"."No.")
            {
            }
            column(BilltoCustomerNo_SalesCrMemoHeader; "Sales Cr.Memo Header"."Bill-to Customer No.")
            {
            }
            column(BilltoName_SalesCrMemoHeader; "Sales Cr.Memo Header"."Bill-to Name")
            {
            }
            column(PostingDate_SalesCrMemoHeader; "Sales Cr.Memo Header"."Posting Date")
            {
            }
            column(RNCCliente_NCR; Cust."VAT Registration No.")
            {
            }
            column(ImporteBaseNCr; ImporteBaseNCr)
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
            column(ImporteITBIS16NCr; ImporteITBIS16NCr)
            {
            }
            column(ImporteITBIS18NCr; ImporteITBIS18NCr)
            {
            }
            column(BaseITBIS16NCr; BaseITBIS16NCr)
            {
            }
            column(BaseITBIS18NCr; BaseITBIS18NCr)
            {
            }

            trigger OnAfterGetRecord()
            begin
                ImporteBaseNCr := 0;
                ImporteTotalNCr := 0;
                ImporteITBISNCr := 0;
                "%ITBISNCr" := 0;
                ImporteGravadoNCr := 0;
                ImporteExentoNCr := 0;


                ImporteSelectivo := 0;
                ImporteBien := 0;
                ImporteServicios := 0;
                ImportePropina := 0;
                ImporteOtros := 0;
                ITBISRetenido := 0;

                ImporteITBIS16NCr := 0;
                ImporteITBIS18NCr := 0;
                BaseITBIS16NCr := 0;
                BaseITBIS18NCr := 0;

                FactorDivisaAdicional := 0;
                FactorDivisa := 0;

                if "No. Comprobante Fiscal" = '' then
                    CurrReport.Skip;

                //jpg 03-08-2021 validar si es una nc valida por correcion de texto no monto o si es un nc eliminada con ncf
                CalcFields("Amount Including VAT", Amount);
                if "Amount Including VAT" = 0 then begin
                    SalesCrMemoLine.Reset;
                    SalesCrMemoLine.SetRange("Document No.", "No.");
                    SalesCrMemoLine.SetRange(Description, 'Deleted Document');
                    if SalesCrMemoLine.FindFirst then
                        CurrReport.Skip;
                end;

                //para excluir las que tiene corregida.
                SIH.Reset;
                SIH.SetRange("No. Comprobante Fiscal Rel.", "No. Comprobante Fiscal");
                SIH.SetRange(Correction, true);
                SIH.SetRange("Sell-to Customer No.", "Sell-to Customer No.");
                if SIH.FindFirst then begin // verificar si no hay una Factura correctiva anulando la nc
                    SCMH.Reset;
                    SCMH.SetRange("Applies-to Doc. No.", SIH."No.");
                    SCMH.SetRange(Correction, true);
                    SCMH.SetRange("Sell-to Customer No.", SIH."Sell-to Customer No.");
                    if not SCMH.FindFirst then
                        CurrReport.Skip;
                end;

                if DivAd then begin
                    VE.Reset;
                    VE.SetCurrentKey("Document No.", "Posting Date");
                    VE.SetRange("Document No.", "No.");
                    VE.SetRange("Posting Date", "Posting Date");
                    VE.SetRange(VE."Document Type", VE."Document Type"::"Credit Memo");
                    if VE.FindSet() then
                        repeat

                            if VE.Amount <> 0 then begin
                                ImporteGravadoNCr += VE."Additional-Currency Base";
                                ImporteITBISNCr += VE."Additional-Currency Amount";

                                if VPSetup.Get(VE."VAT Bus. Posting Group", VE."VAT Prod. Posting Group") then begin
                                    if VPSetup."VAT %" = 18 then begin
                                        ImporteITBIS18NCr += VE."Additional-Currency Amount";
                                        BaseITBIS18NCr += VE."Additional-Currency Base";
                                    end;

                                    if VPSetup."VAT %" = 16 then begin
                                        ImporteITBIS16NCr += VE."Additional-Currency Amount";
                                        BaseITBIS16NCr += VE."Additional-Currency Base";
                                    end;
                                end;

                            end
                            else
                                ImporteExentoNCr += VE."Additional-Currency Base";

                            //para capturar factor divisa adicional.
                            if (FactorDivisaAdicional = 0) and ("Currency Code" = '') then
                                FactorDivisaAdicional := Abs(VE."Additional-Currency Base") / Abs(VE.Base);



                        until VE.Next = 0;
                end
                else begin
                    VE.Reset;
                    VE.SetCurrentKey("Document No.", "Posting Date");
                    VE.SetRange("Document No.", "No.");
                    VE.SetRange("Posting Date", "Posting Date");
                    VE.SetRange(VE."Document Type", VE."Document Type"::"Credit Memo");
                    if VE.FindSet() then
                        repeat
                            if VE.Amount <> 0 then begin
                                ImporteGravadoNCr += VE.Base;
                                ImporteITBISNCr += VE.Amount;

                                if VPSetup.Get(VE."VAT Bus. Posting Group", VE."VAT Prod. Posting Group") then begin
                                    if VPSetup."VAT %" = 18 then begin
                                        ImporteITBIS18NCr += VE.Amount;
                                        BaseITBIS18NCr += VE.Base;
                                    end;

                                    if VPSetup."VAT %" = 16 then begin
                                        ImporteITBIS16NCr += VE.Amount;
                                        BaseITBIS16NCr += VE.Base;
                                    end;
                                end;

                            end
                            else
                                ImporteExentoNCr += VE.Base;
                        until VE.Next = 0;
                end;



                /*
                IF DivAd THEN
                  BEGIN
                    VE.RESET;
                    VE.SETCURRENTKEY("Document No.","Posting Date");
                    VE.SETRANGE("Document No.","No.");
                    VE.SETRANGE("Posting Date","Posting Date");
                    VE.SETRANGE("Document Type",VE."Document Type"::"Credit Memo");
                    IF VE.FINDSET(FALSE,FALSE) THEN
                      REPEAT
                        IF NOT VPPG.GET(VE."VAT Prod. Posting Group") THEN
                          VPPG.INIT;
                        CASE VPPG."Tipo de bien-servicio" OF
                          0: //Bien
                            ImporteBien += VE."Additional-Currency Base";
                          1: //Servicio
                            ImporteServicios += VE."Additional-Currency Base";
                          2: //Selectivo
                            ImporteSelectivo += VE."Additional-Currency Base";
                          3: //Propina
                            ImportePropina += VE."Additional-Currency Base";
                          ELSE //Otro
                            ImporteOtros += VE."Additional-Currency Base";
                        END;
                      UNTIL VE.NEXT = 0;
                  END
                ELSE
                  BEGIN
                    VE.RESET;
                    VE.SETCURRENTKEY("Document No.","Posting Date");
                    VE.SETRANGE("Document No.","No.");
                    VE.SETRANGE("Posting Date","Posting Date");
                    VE.SETRANGE("Document Type",VE."Document Type"::"Credit Memo");
                    IF VE.FINDSET(FALSE,FALSE) THEN
                      REPEAT
                        IF NOT VPPG.GET(VE."VAT Prod. Posting Group") THEN
                          VPPG.INIT;
                        CASE VPPG."Tipo de bien-servicio" OF
                          0: //Bien
                            ImporteBien += VE.Base;
                          1: //Servicio
                            ImporteServicios += VE.Base;
                          2: //Selectivo
                            ImporteSelectivo += VE.Base;
                          3: //Propina
                            ImportePropina += VE.Base;
                          ELSE //Otro
                            ImporteOtros += VE.Base;
                        END;
                      UNTIL VE.NEXT = 0;
                  END;
                   */

                SalesCrMemoLine.Reset;
                SalesCrMemoLine.SetRange("Document No.", "No.");
                SalesCrMemoLine.SetFilter(Quantity, '>0');
                if SalesCrMemoLine.FindSet then
                    repeat
                        if not VPPG.Get(SalesCrMemoLine."VAT Prod. Posting Group") then
                            VPPG.Init;
                        if DivAd and ("Currency Code" = '') then begin
                            case VPPG."Tipo de bien-servicio" of
                                0: //Bien
                                    ImporteBien += SalesCrMemoLine.Amount * FactorDivisaAdicional;
                                1: //Servicio
                                    ImporteServicios += SalesCrMemoLine.Amount * FactorDivisaAdicional;
                                2: //Selectivo
                                    ImporteSelectivo += SalesCrMemoLine.Amount * FactorDivisaAdicional;
                                3: //Propina
                                    ImportePropina += SalesCrMemoLine.Amount * FactorDivisaAdicional;
                                else //Otro
                                    ImporteOtros += SalesCrMemoLine.Amount * FactorDivisaAdicional
                            end;
                        end else begin
                            ///008 conversion factura otra monedas.
                            if "Currency Code" <> '' then
                                FactorDivisa := "Currency Factor"
                            else
                                FactorDivisa := 1;

                            case VPPG."Tipo de bien-servicio" of
                                0: //Bien
                                    ImporteBien += SalesCrMemoLine.Amount / FactorDivisa;
                                1: //Servicio
                                    ImporteServicios += SalesCrMemoLine.Amount / FactorDivisa;
                                2: //Selectivo
                                    ImporteSelectivo += SalesCrMemoLine.Amount / FactorDivisa;
                                3: //Propina
                                    ImportePropina += SalesCrMemoLine.Amount / FactorDivisa;
                                else //Otro
                                    ImporteOtros += SalesCrMemoLine.Amount / FactorDivisa;
                            end;
                        end;
                    until SalesCrMemoLine.Next = 0;

                ImporteTotalNCr := ImporteGravadoNCr + ImporteExentoNCr + ImporteITBISNCr;
                ImporteBaseNCr := ImporteGravadoNCr + ImporteExentoNCr - ImporteSelectivo - ImportePropina - ImporteOtros;

                tImporteBase += Abs(ImporteBaseNCr);
                tImporteTotal += Abs(ImporteTotalNCr);
                tImporteITBIS += Abs(ImporteITBISNCr);
                tImporteGravado += Abs(ImporteGravadoNCr);
                tImporteExento += Abs(ImporteExentoNCr);

                if not Cust.Get("Sell-to Customer No.") then
                    Cust.Init;



                //Se llena la tabla de ITIBS
                Clear(ArchITBIS);
                ArchITBIS."Número Documento" := "No.";
                ArchITBIS."Fecha Documento" := Format("Posting Date", 0, '<year4>') + Format("Posting Date", 0, '<Month,2>') +
                                                       Format("Posting Date", 0, '<day,2>');
                ArchITBIS.Apellidos := '';
                ArchITBIS.Nombres := '';
                ArchITBIS."Razón Social" := DelChr(CopyStr("Bill-to Name", 1, 60), '=', ',');
                ArchITBIS."Nombre Comercial" := ArchITBIS."Razón Social";
                RNCTxt := DelChr("VAT Registration No.", '=', '- ');
                if StrLen(RNCTxt) < 10 then
                    ArchITBIS.RNC := RNCTxt
                else
                    ArchITBIS.Cédula := CopyStr(RNCTxt, 1, 11);
                ArchITBIS."Total Documento" := ImporteBaseNCr;
                ArchITBIS."ITBIS Pagado" := Abs(ImporteITBISNCr);
                ArchITBIS.NCF := "No. Comprobante Fiscal";
                ArchITBIS."NCF Relacionado" := "No. Comprobante Fiscal Rel.";
                ArchITBIS."Tipo documento" := 2; //Nota de credito
                ArchITBIS."Codigo reporte" := '607';

                if ArchITBIS.RNC <> '' then begin
                    ArchITBIS."RNC/Cedula" := ArchITBIS.RNC;
                    ArchITBIS."Tipo Identificacion" := 1;
                end
                else begin
                    ArchITBIS."RNC/Cedula" := ArchITBIS.Cédula;
                    ArchITBIS."Tipo Identificacion" := 2;
                end;

                //jpg 03-08-2020 ++
                //Busco la forma de pago
                //Busco la forma de pago
                if not FormaPago.Get("Payment Method Code") or ("Payment Method Code" = '') then
                    FormaPago."Forma de pago DGII" := FormaPago."Forma de pago DGII"::"2 - Cheques/Transferencias/Depositos";


                ArchITBIS."Forma de pago DGII" := FormaPago."Forma de pago DGII";

                case FormaPago."Forma de pago DGII" of
                    1:
                        ArchITBIS."Monto Efectivo" := ImporteTotalNCr;
                    2:
                        ArchITBIS."Monto Cheque" := ImporteTotalNCr;
                    3:
                        ArchITBIS."Monto tarjetas" := ImporteTotalNCr;
                    4:
                        ArchITBIS."Venta a credito" := ImporteTotalNCr;
                    5:
                        ArchITBIS."Venta bonos" := ImporteTotalNCr;
                    6:
                        ArchITBIS."Venta Permuta" := ImporteTotalNCr;
                    7:
                        begin //jpg pago mixto +
                            Clear(ImporteTotal2);
                            CustLedgerEntry.Reset;
                            CustLedgerEntry.SetRange("Document No.", "No.");
                            CustLedgerEntry.SetFilter("Document Type", '%1|%2', CustLedgerEntry."Document Type"::" ", CustLedgerEntry."Document Type"::Payment);
                            CustLedgerEntry.SetRange("Posting Date", "Posting Date");
                            if CustLedgerEntry.FindSet then
                                repeat

                                    Clear(ImporteTotal2);
                                    DetailedCustLedgEntry.Reset;
                                    DetailedCustLedgEntry.SetRange("Ledger Entry Amount", true);
                                    DetailedCustLedgEntry.SetRange("Cust. Ledger Entry No.", CustLedgerEntry."Entry No.");
                                    DetailedCustLedgEntry.SetRange("Posting Date", CustLedgerEntry."Posting Date");
                                    DetailedCustLedgEntry.CalcSums(Amount);
                                    ImporteTotal2 := Abs(DetailedCustLedgEntry.Amount);

                                    if DivAd and ("Currency Code" = '') and (FactorDivisaAdicional = 0) then
                                        ImporteTotal2 := Abs(DetailedCustLedgEntry.Amount) * FactorDivisaAdicional;

                                    FormaPago.Reset;
                                    FormaPago.SetRange(Code, DelChr(SelectStr(2, CustLedgerEntry.Description), '=', ' '));
                                    if FormaPago.FindFirst then
                                        case FormaPago."Forma de pago DGII" of
                                            1:
                                                ArchITBIS."Monto Efectivo" += ImporteTotal2;
                                            2:
                                                ArchITBIS."Monto Cheque" += ImporteTotal2;
                                            3:
                                                ArchITBIS."Monto tarjetas" += ImporteTotal2;
                                            4:
                                                ArchITBIS."Venta a credito" += ImporteTotal2;
                                            5:
                                                ArchITBIS."Venta bonos" += ImporteTotal2;
                                            6:
                                                ArchITBIS."Venta Permuta" += ImporteTotal2;
                                        end;

                                until CustLedgerEntry.Next = 0;
                            //jpg si no encontro improte en ninguna forma pago coloco a credito
                            if ((ArchITBIS."Monto Efectivo" + ArchITBIS."Monto Cheque" + ArchITBIS."Monto tarjetas" + ArchITBIS."Venta a credito"
                             + ArchITBIS."Venta bonos" + ArchITBIS."Venta Permuta") = 0) then begin
                                FormaPago."Forma de pago DGII" := FormaPago."Forma de pago DGII"::"2 - Cheques/Transferencias/Depositos";
                                ArchITBIS."Monto Cheque" := ImporteTotal;
                            end;
                            // ArchITBIS."Monto mixto" := "amount including vat";
                        end
                end;
                //jpg pago mixto --
                ArchITBIS."Forma de pago DGII" := FormaPago."Forma de pago DGII";

                NumeroLinea += 1;
                ArchITBIS."Line No." := NumeroLinea;

                if not ArchITBIS.Insert then
                    Error(Error001);

            end;

            trigger OnPreDataItem()
            begin
                /*GRN
                SETFILTER("Posting Date","Sales Invoice Header".GETFILTER("Posting Date"));
                IF "Sales Invoice Header".GETFILTER("Customer Posting Group") <> '' THEN
                   SETFILTER("Customer Posting Group","Sales Invoice Header".GETFILTER("Customer Posting Group"));
                */

            end;
        }
        dataitem("Service Invoice Header"; "Service Invoice Header")
        {
            DataItemTableView = SORTING("No.") ORDER(Ascending) WHERE(Correction = CONST(false));
            RequestFilterFields = "Posting Date", "Customer Posting Group", "Shortcut Dimension 1 Code";
            column(No_SalesInvoiceHeader_S; "Service Invoice Header"."No.")
            {
            }
            column(BilltoCustomerNo_SalesInvoiceHeader_S; "Service Invoice Header"."Customer No.")
            {
            }
            column(BilltoName_SalesInvoiceHeader_S; "Service Invoice Header"."Bill-to Name")
            {
            }
            column(PostingDate_SalesInvoiceHeader_S; "Service Invoice Header"."Posting Date")
            {
            }
            column(NoComprobanteFiscal_SalesInvoiceHeader_S; "Service Invoice Header"."No. Comprobante Fiscal")
            {
            }
            column(RNCCliente_S; Cust."VAT Registration No.")
            {
            }
            column(ImporteBase_S; ImporteBase)
            {
            }
            column(ImporteExento_S; ImporteExento)
            {
            }
            column(ImporteGravado_S; ImporteGravado)
            {
            }
            column(ImporteITBIS_S; ImporteITBIS)
            {
            }
            column(ImporteTotal_S; ImporteTotal)
            {
            }
            column(ImporteITBIS16_S; ImporteITBIS16)
            {
            }
            column(ImporteITBIS18_S; ImporteITBIS18)
            {
            }
            column(BaseITBIS16_S; BaseITBIS16)
            {
            }
            column(BaseITBIS18_S; BaseITBIS18)
            {
            }
            column(DirEmpresa1_S; DirEmpresa[1])
            {
            }
            column(DirEmpresa2_S; DirEmpresa[2])
            {
            }
            column(DirEmpresa3_S; DirEmpresa[3])
            {
            }
            column(DirEmpresa4_S; DirEmpresa[4])
            {
            }

            trigger OnAfterGetRecord()
            begin
                ImporteBase := 0;
                ImporteTotal := 0;
                ImporteITBIS := 0;
                "%ITBIS" := 0;
                ImporteExento := 0;
                ImporteGravado := 0;
                ImporteSelectivo := 0;
                ImporteBien := 0;
                ImporteServicios := 0;
                ImportePropina := 0;
                ImporteOtros := 0;
                ITBISRetenido := 0;
                FactorDivisaAdicional := 0;
                FactorDivisa := 0;

                ImporteITBIS16 := 0;
                ImporteITBIS18 := 0;
                BaseITBIS16 := 0;
                BaseITBIS18 := 0;

                if "No. Comprobante Fiscal" = '' then
                    CurrReport.Skip;

                //para excluir las que tiene corregida.
                SCMH.Reset;
                SCMH.SetRange("No. Comprobante Fiscal Rel.", "No. Comprobante Fiscal");
                SCMH.SetRange(Correction, true);
                SCMH.SetRange("Sell-to Customer No.", "Customer No.");
                if SCMH.FindLast then begin // verificar si no hay una Factura correctiva anulando la nc
                    SIH.Reset;
                    SIH.SetRange("Applies-to Doc. No.", SCMH."No.");
                    SIH.SetRange(Correction, true);
                    SIH.SetRange("Sell-to Customer No.", SCMH."Sell-to Customer No.");
                    if not SIH.FindFirst then
                        CurrReport.Skip;
                end;


                //jpg 03-08-2021 validar si es una nc valida por correcion de texto no monto o si es un nc eliminada con ncf
                CalcFields("Amount Including VAT", Amount);
                if "Amount Including VAT" = 0 then begin
                    ServiceInvoiceLine.Reset;
                    ServiceInvoiceLine.SetRange("Document No.", "No.");
                    ServiceInvoiceLine.SetRange(Description, 'Deleted Document');
                    if ServiceInvoiceLine.FindFirst then
                        CurrReport.Skip;
                end;


                if DivAd then begin
                    VE.Reset;
                    VE.SetCurrentKey("Document No.", "Posting Date");
                    VE.SetRange("Document No.", "No.");
                    VE.SetRange("Posting Date", "Posting Date");
                    VE.SetRange(VE."Document Type", VE."Document Type"::Invoice);
                    if VE.FindSet() then
                        repeat
                            if VE.Amount <> 0 then begin
                                ImporteGravado += (VE."Additional-Currency Base") * -1;
                                ImporteITBIS += VE."Additional-Currency Amount" * -1;

                                if VPSetup.Get(VE."VAT Bus. Posting Group", VE."VAT Prod. Posting Group") then begin
                                    if VPSetup."VAT %" = 18 then begin
                                        ImporteITBIS18 += (VE."Additional-Currency Amount") * -1;
                                        BaseITBIS18 += VE."Additional-Currency Base" * -1;
                                    end;

                                    if VPSetup."VAT %" = 16 then begin
                                        ImporteITBIS16 += (VE."Additional-Currency Amount") * -1;
                                        BaseITBIS16 += VE."Additional-Currency Base" * -1;
                                    end;
                                end;

                            end
                            else
                                ImporteExento += VE."Additional-Currency Base" * -1;
                            //para capturar factor divisa adicional.
                            if (FactorDivisaAdicional = 0) and ("Currency Code" = '') then
                                FactorDivisaAdicional := Abs(VE."Additional-Currency Base") / Abs(VE.Base);

                        until VE.Next = 0;
                end
                else begin
                    VE.Reset;
                    VE.SetCurrentKey("Document No.", "Posting Date");
                    VE.SetRange("Document No.", "No.");
                    VE.SetRange("Posting Date", "Posting Date");
                    VE.SetRange(VE."Document Type", VE."Document Type"::Invoice);
                    if VE.FindSet() then
                        repeat
                            if VE.Amount <> 0 then begin
                                ImporteGravado += VE.Base * -1;
                                ImporteITBIS += VE.Amount * -1;

                                if VPSetup.Get(VE."VAT Bus. Posting Group", VE."VAT Prod. Posting Group") then begin
                                    if VPSetup."VAT %" = 18 then begin
                                        ImporteITBIS18 += VE.Amount * -1;
                                        BaseITBIS18 += VE.Base * -1;
                                    end;

                                    if VPSetup."VAT %" = 16 then begin
                                        ImporteITBIS16 += VE.Amount * -1;
                                        BaseITBIS16 += VE.Base * -1;
                                    end;
                                end;

                            end
                            else
                                ImporteExento += VE.Base * -1;

                        until VE.Next = 0;
                end;


                /*
                IF DivAd THEN
                  BEGIN
                    VE.RESET;
                    VE.SETCURRENTKEY("Document No.","Posting Date");
                    VE.SETRANGE("Document No.","No.");
                    VE.SETRANGE("Posting Date","Posting Date");
                    VE.SETRANGE("Document Type",VE."Document Type"::Invoice);
                    IF VE.FINDSET(FALSE,FALSE) THEN
                      REPEAT
                        IF NOT VPPG.GET(VE."VAT Prod. Posting Group") THEN
                          VPPG.INIT;
                        CASE VPPG."Tipo de bien-servicio" OF
                          0: //Bien
                            ImporteBien += VE."Additional-Currency Base"*-1;
                          1: //Servicio
                            ImporteServicios += VE."Additional-Currency Base"*-1;
                          2: //Selectivo
                            ImporteSelectivo += VE."Additional-Currency Base"*-1;
                          3: //Propina
                            ImportePropina += VE."Additional-Currency Base"*-1;
                          ELSE //Otro
                            ImporteOtros += VE."Additional-Currency Base"*-1;
                        END;
                      UNTIL VE.NEXT = 0;
                  END
                ELSE
                  BEGIN
                    VE.RESET;
                    VE.SETCURRENTKEY("Document No.","Posting Date");
                    VE.SETRANGE("Document No.","No.");
                    VE.SETRANGE("Posting Date","Posting Date");
                    VE.SETRANGE("Document Type",VE."Document Type"::Invoice);
                    IF VE.FINDSET(FALSE,FALSE) THEN
                      REPEAT
                        IF NOT VPPG.GET(VE."VAT Prod. Posting Group") THEN
                          VPPG.INIT;
                        CASE VPPG."Tipo de bien-servicio" OF
                          0: //Bien
                            ImporteBien += VE.Base*-1;
                          1: //Servicio
                            ImporteServicios += VE.Base*-1;
                          2: //Selectivo
                            ImporteSelectivo += VE.Base*-1;
                          3: //Propina
                            ImportePropina += VE.Base*-1;
                          ELSE //Otro
                            ImporteOtros += VE.Base*-1;
                        END;
                      UNTIL VE.NEXT = 0;
                  END;
                  */
                ServiceInvoiceLine.Reset;
                ServiceInvoiceLine.SetRange("Document No.", "No.");
                ServiceInvoiceLine.SetFilter(Quantity, '>0');
                if ServiceInvoiceLine.FindSet then
                    repeat
                        if not VPPG.Get(ServiceInvoiceLine."VAT Prod. Posting Group") then
                            VPPG.Init;
                        if DivAd and ("Currency Code" = '') then begin
                            case VPPG."Tipo de bien-servicio" of
                                0: //Bien
                                    ImporteBien += ServiceInvoiceLine.Amount * FactorDivisaAdicional;
                                1: //Servicio
                                    ImporteServicios += ServiceInvoiceLine.Amount * FactorDivisaAdicional;
                                2: //Selectivo
                                    ImporteSelectivo += ServiceInvoiceLine.Amount * FactorDivisaAdicional;
                                3: //Propina
                                    ImportePropina += ServiceInvoiceLine.Amount * FactorDivisaAdicional;
                                else //Otro
                                    ImporteOtros += ServiceInvoiceLine.Amount * FactorDivisaAdicional
                            end;
                        end else begin
                            ///008 conversion factura otra monedas.
                            if "Currency Code" <> '' then
                                FactorDivisa := "Currency Factor"
                            else
                                FactorDivisa := 1;

                            case VPPG."Tipo de bien-servicio" of
                                0: //Bien
                                    ImporteBien += ServiceInvoiceLine.Amount / FactorDivisa;
                                1: //Servicio
                                    ImporteServicios += ServiceInvoiceLine.Amount / FactorDivisa;
                                2: //Selectivo
                                    ImporteSelectivo += ServiceInvoiceLine.Amount / FactorDivisa;
                                3: //Propina
                                    ImportePropina += ServiceInvoiceLine.Amount / FactorDivisa;
                                else //Otro
                                    ImporteOtros += ServiceInvoiceLine.Amount / FactorDivisa;
                            end;
                        end;
                    until ServiceInvoiceLine.Next = 0;


                ImporteTotal := ImporteGravado + ImporteExento + ImporteITBIS;
                ImporteBase += ImporteGravado + ImporteExento - ImporteSelectivo - ImportePropina - ImporteOtros;

                tImporteBase += Abs(ImporteBase);
                tImporteTotal += Abs(ImporteTotal);
                tImporteITBIS += Abs(ImporteITBIS);
                tImporteGravado += Abs(ImporteGravado);
                tImporteExento += Abs(ImporteExento);

                if not Cust.Get("Customer No.") then
                    Cust.Init;


                //Se llena la tabla de ITBIS
                GCC.Get("Customer Posting Group");
                Clear(ArchITBIS);
                CalcFields("Amount Including VAT", Amount);
                ArchITBIS."Número Documento" := "No.";
                ArchITBIS."Fecha Documento" := Format("Posting Date", 0, '<year4>') + Format("Posting Date", 0, '<Month,2>') +
                                                    Format("Posting Date", 0, '<day,2>');

                ArchITBIS.Apellidos := '';
                ArchITBIS.Nombres := '';
                ArchITBIS."Cod. Proveedor" := "Bill-to Customer No.";
                ArchITBIS."Razón Social" := DelChr(CopyStr("Bill-to Name", 1, 60), '=', ',');
                ArchITBIS."Nombre Comercial" := ArchITBIS."Razón Social";
                RNCTxt := DelChr("VAT Registration No.", '=', '- ');
                if StrLen(RNCTxt) < 10 then
                    ArchITBIS.RNC := RNCTxt
                else
                    ArchITBIS.Cédula := CopyStr(RNCTxt, 1, 11);
                ArchITBIS."Total Documento" := ImporteBase;
                ArchITBIS."ITBIS Pagado" := Abs(ImporteITBIS);
                ArchITBIS."Fecha Pago" := ArchITBIS."Fecha Documento";
                ArchITBIS.NCF := "No. Comprobante Fiscal";
                ArchITBIS."Tipo documento" := 1; //Factura
                ArchITBIS."Forma de pago DGII" := FormaPago."Forma de pago DGII";
                ArchITBIS."Tipo de ingreso" := DelChr("Tipo de ingreso", '=', '0');
                ArchITBIS."Monto Bienes" := ImporteBien;
                ArchITBIS."Monto Servicios" := ImporteServicios;
                ArchITBIS."Monto Selectivo" := ImporteSelectivo;
                ArchITBIS."Monto Propina" := ImportePropina;
                ArchITBIS."Monto otros" := ImporteOtros;
                ArchITBIS."Codigo reporte" := '607';
                if ArchITBIS.RNC <> '' then begin
                    ArchITBIS."RNC/Cedula" := ArchITBIS.RNC;
                    ArchITBIS."Tipo Identificacion" := 1;
                end
                else begin
                    ArchITBIS."RNC/Cedula" := ArchITBIS.Cédula;
                    ArchITBIS."Tipo Identificacion" := 2;
                end;

                if not FormaPago.Get("Payment Method Code") or ("Payment Method Code" = '') then
                    FormaPago."Forma de pago DGII" := FormaPago."Forma de pago DGII"::"2 - Cheques/Transferencias/Depositos";


                ArchITBIS."Forma de pago DGII" := FormaPago."Forma de pago DGII";

                case FormaPago."Forma de pago DGII" of
                    1:
                        ArchITBIS."Monto Efectivo" := ImporteTotalNCr;
                    2:
                        ArchITBIS."Monto Cheque" := ImporteTotalNCr;
                    3:
                        ArchITBIS."Monto tarjetas" := ImporteTotalNCr;
                    4:
                        ArchITBIS."Venta a credito" := ImporteTotalNCr;
                    5:
                        ArchITBIS."Venta bonos" := ImporteTotalNCr;
                    6:
                        ArchITBIS."Venta Permuta" := ImporteTotalNCr;
                    7:
                        begin //jpg pago mixto +
                            Clear(ImporteTotal2);
                            CustLedgerEntry.Reset;
                            CustLedgerEntry.SetRange("Document No.", "No.");
                            CustLedgerEntry.SetFilter("Document Type", '%1|%2', CustLedgerEntry."Document Type"::" ", CustLedgerEntry."Document Type"::Payment);
                            CustLedgerEntry.SetRange("Posting Date", "Posting Date");
                            if CustLedgerEntry.FindSet then
                                repeat

                                    Clear(ImporteTotal2);
                                    DetailedCustLedgEntry.Reset;
                                    DetailedCustLedgEntry.SetRange("Ledger Entry Amount", true);
                                    DetailedCustLedgEntry.SetRange("Cust. Ledger Entry No.", CustLedgerEntry."Entry No.");
                                    DetailedCustLedgEntry.SetRange("Posting Date", CustLedgerEntry."Posting Date");
                                    DetailedCustLedgEntry.CalcSums(Amount);
                                    ImporteTotal2 := Abs(DetailedCustLedgEntry.Amount);
                                    if DivAd and ("Currency Code" = '') and (FactorDivisaAdicional = 0) then
                                        ImporteTotal2 := Abs(DetailedCustLedgEntry.Amount) * FactorDivisaAdicional;

                                    FormaPago.Reset;
                                    FormaPago.SetRange(Code, DelChr(SelectStr(2, CustLedgerEntry.Description), '=', ' '));
                                    if FormaPago.FindFirst then
                                        case FormaPago."Forma de pago DGII" of
                                            1:
                                                ArchITBIS."Monto Efectivo" += ImporteTotal2;
                                            2:
                                                ArchITBIS."Monto Cheque" += ImporteTotal2;
                                            3:
                                                ArchITBIS."Monto tarjetas" += ImporteTotal2;
                                            4:
                                                ArchITBIS."Venta a credito" += ImporteTotal2;
                                            5:
                                                ArchITBIS."Venta bonos" += ImporteTotal2;
                                            6:
                                                ArchITBIS."Venta Permuta" += ImporteTotal2;
                                        end;

                                until CustLedgerEntry.Next = 0;

                            //jpg si no encontro improte en ninguna forma pago coloco a credito
                            if ((ArchITBIS."Monto Efectivo" + ArchITBIS."Monto Cheque" + ArchITBIS."Monto tarjetas" + ArchITBIS."Venta a credito"
                             + ArchITBIS."Venta bonos" + ArchITBIS."Venta Permuta") = 0) then begin
                                FormaPago."Forma de pago DGII" := FormaPago."Forma de pago DGII"::"2 - Cheques/Transferencias/Depositos";
                                ArchITBIS."Monto Cheque" := ImporteTotal;
                            end;
                            // ArchITBIS."Monto mixto" := "amount including vat";
                        end
                end;
                //jpg pago mixto --
                ArchITBIS."Forma de pago DGII" := FormaPago."Forma de pago DGII";

                if (CopyStr(ArchITBIS.NCF, 1, 3) = 'B02') and ((ArchITBIS."Total Documento") <= 250000) then // jpg 02/07/2021 evaluar sin itbis
                    CurrReport.Skip;

                NumeroLinea += 1;
                ArchITBIS."Line No." := NumeroLinea;

                if not ArchITBIS.Insert then
                    Error(Error001);

            end;

            trigger OnPreDataItem()
            begin
                FiltrosSIH_S := "Service Invoice Header".GetFilters;
                FiltrosSCMH_S := "Service Cr.Memo Header".GetFilters;

                if "Service Invoice Header".GetFilter("Posting Date") = '' then
                    Error(Error002, "Service Invoice Header".FieldCaption("Posting Date"));

                //FiltroFecha := "Service Invoice Header".GETFILTER("Posting Date");
            end;
        }
        dataitem("Service Cr.Memo Header"; "Service Cr.Memo Header")
        {
            CalcFields = "Amount Including VAT";
            DataItemTableView = SORTING("No.") ORDER(Ascending) WHERE(Correction = CONST(false));
            RequestFilterFields = "Posting Date", "Customer Posting Group", "Shortcut Dimension 1 Code";
            column(NoComprobanteFiscal_SalesCrMemoHeader_S; "Service Cr.Memo Header"."No. Comprobante Fiscal")
            {
            }
            column(NoComprobanteFiscalRel_SalesCrMemoHeader_S; "Service Cr.Memo Header"."No. Comprobante Fiscal Rel.")
            {
            }
            column(No_SalesCrMemoHeader_S; "Service Cr.Memo Header"."No.")
            {
            }
            column(BilltoCustomerNo_SalesCrMemoHeader_S; "Service Cr.Memo Header"."Bill-to Customer No.")
            {
            }
            column(BilltoName_SalesCrMemoHeader_S; "Service Cr.Memo Header"."Bill-to Name")
            {
            }
            column(PostingDate_SalesCrMemoHeader_S; "Service Cr.Memo Header"."Posting Date")
            {
            }
            column(RNCCliente_NCR_S; Cust."VAT Registration No.")
            {
            }
            column(ImporteBaseNCr_S; ImporteBaseNCr)
            {
            }
            column(ImporteITBISNCr_S; ImporteITBISNCr)
            {
            }
            column(ImporteGravadoNCr_S; ImporteGravadoNCr)
            {
            }
            column(ImporteExentoNCr_S; ImporteExentoNCr)
            {
            }
            column(ImporteTotalNCr_S; ImporteTotalNCr)
            {
            }
            column(ImporteITBIS16NCr_S; ImporteITBIS16NCr)
            {
            }
            column(ImporteITBIS18NCr_S; ImporteITBIS18NCr)
            {
            }
            column(BaseITBIS16NCr_S; BaseITBIS16NCr)
            {
            }
            column(BaseITBIS18NCr_S; BaseITBIS18NCr)
            {
            }

            trigger OnAfterGetRecord()
            begin
                ImporteBaseNCr := 0;
                ImporteTotalNCr := 0;
                ImporteITBISNCr := 0;
                "%ITBISNCr" := 0;
                ImporteGravadoNCr := 0;
                ImporteExentoNCr := 0;

                ImporteSelectivo := 0;
                ImporteBien := 0;
                ImporteServicios := 0;
                ImportePropina := 0;
                ImporteOtros := 0;
                FactorDivisaAdicional := 0;
                FactorDivisa := 0;

                if "No. Comprobante Fiscal" = '' then
                    CurrReport.Skip;

                //para excluir las que tiene corregida.
                SIH.Reset;
                SIH.SetRange("No. Comprobante Fiscal Rel.", "No. Comprobante Fiscal");
                SIH.SetRange(Correction, true);
                SIH.SetRange("Sell-to Customer No.", "Customer No.");
                if SIH.FindFirst then begin // verificar si no hay una Factura correctiva anulando la nc
                    SCMH.Reset;
                    SCMH.SetRange("Applies-to Doc. No.", SIH."No.");
                    SCMH.SetRange(Correction, true);
                    SCMH.SetRange("Sell-to Customer No.", SIH."Sell-to Customer No.");
                    if not SCMH.FindFirst then
                        CurrReport.Skip;
                end;

                //jpg 03-08-2021 validar si es una nc valida por correcion de texto no monto o si es un nc eliminada con ncf
                CalcFields("Amount Including VAT");
                if "Amount Including VAT" = 0 then begin
                    ServiceCrMemoLine.Reset;
                    ServiceCrMemoLine.SetRange("Document No.", "No.");
                    ServiceCrMemoLine.SetRange(Description, 'Deleted Document');
                    if ServiceCrMemoLine.FindFirst then
                        CurrReport.Skip;
                end;


                if DivAd then begin
                    VE.Reset;
                    VE.SetCurrentKey("Document No.", "Posting Date");
                    VE.SetRange("Document No.", "No.");
                    VE.SetRange("Posting Date", "Posting Date");
                    VE.SetRange(VE."Document Type", VE."Document Type"::"Credit Memo");
                    if VE.FindSet() then
                        repeat

                            if VE.Amount <> 0 then begin
                                ImporteGravadoNCr += (VE."Additional-Currency Base");
                                ImporteITBISNCr += VE."Additional-Currency Amount";

                                if VPSetup.Get(VE."VAT Bus. Posting Group", VE."VAT Prod. Posting Group") then begin
                                    if VPSetup."VAT %" = 18 then begin
                                        ImporteITBIS18NCr += (VE."Additional-Currency Amount");
                                        BaseITBIS18NCr += VE."Additional-Currency Base";
                                    end;

                                    if VPSetup."VAT %" = 16 then begin
                                        ImporteITBIS16NCr += (VE."Additional-Currency Amount");
                                        BaseITBIS16NCr += VE."Additional-Currency Base";
                                    end;
                                end;

                            end
                            else
                                ImporteExentoNCr += (VE."Additional-Currency Base");
                            //para capturar factor divisa adicional.
                            if (FactorDivisaAdicional = 0) and ("Currency Code" = '') then
                                FactorDivisaAdicional := Abs(VE."Additional-Currency Base") / Abs(VE.Base);


                        until VE.Next = 0;
                end
                else begin
                    VE.Reset;
                    VE.SetCurrentKey("Document No.", "Posting Date");
                    VE.SetRange("Document No.", "No.");
                    VE.SetRange("Posting Date", "Posting Date");
                    VE.SetRange(VE."Document Type", VE."Document Type"::"Credit Memo");
                    if VE.FindSet() then
                        repeat
                            if VE.Amount <> 0 then begin
                                ImporteGravadoNCr += VE.Base;
                                ImporteITBISNCr += VE.Amount;

                                if VPSetup.Get(VE."VAT Bus. Posting Group", VE."VAT Prod. Posting Group") then begin
                                    if VPSetup."VAT %" = 18 then begin
                                        ImporteITBIS18NCr += VE.Amount;
                                        BaseITBIS18NCr += VE.Base;
                                    end;

                                    if VPSetup."VAT %" = 16 then begin
                                        ImporteITBIS16NCr += VE.Amount;
                                        BaseITBIS16NCr += VE.Base;
                                    end;
                                end;

                            end
                            else
                                ImporteExentoNCr += VE.Base;
                        until VE.Next = 0;
                end;


                /*
                IF DivAd THEN
                  BEGIN
                    VE.RESET;
                    VE.SETCURRENTKEY("Document No.","Posting Date");
                    VE.SETRANGE("Document No.","No.");
                    VE.SETRANGE("Posting Date","Posting Date");
                    VE.SETRANGE("Document Type",VE."Document Type"::"Credit Memo");
                    IF VE.FINDSET(FALSE,FALSE) THEN
                      REPEAT
                        IF NOT VPPG.GET(VE."VAT Prod. Posting Group") THEN
                          VPPG.INIT;
                        CASE VPPG."Tipo de bien-servicio" OF
                          0: //Bien
                            ImporteBien += VE."Additional-Currency Base";
                          1: //Servicio
                            ImporteServicios += VE."Additional-Currency Base";
                          2: //Selectivo
                            ImporteSelectivo += VE."Additional-Currency Base";
                          3: //Propina
                            ImportePropina += VE."Additional-Currency Base";
                          ELSE //Otro
                            ImporteOtros += VE."Additional-Currency Base";
                        END;
                      UNTIL VE.NEXT = 0;
                  END
                ELSE
                  BEGIN
                    VE.RESET;
                    VE.SETCURRENTKEY("Document No.","Posting Date");
                    VE.SETRANGE("Document No.","No.");
                    VE.SETRANGE("Posting Date","Posting Date");
                    VE.SETRANGE("Document Type",VE."Document Type"::"Credit Memo");
                    IF VE.FINDSET(FALSE,FALSE) THEN
                      REPEAT
                        IF NOT VPPG.GET(VE."VAT Prod. Posting Group") THEN
                          VPPG.INIT;
                        CASE VPPG."Tipo de bien-servicio" OF
                          0: //Bien
                            ImporteBien += VE.Base;
                          1: //Servicio
                            ImporteServicios += VE.Base;
                          2: //Selectivo
                            ImporteSelectivo += VE.Base;
                          3: //Propina
                            ImportePropina += VE.Base;
                          ELSE //Otro
                            ImporteOtros += VE.Base;
                        END;
                      UNTIL VE.NEXT = 0;
                  END;
                   */

                ServiceCrMemoLine.Reset;
                ServiceCrMemoLine.SetRange("Document No.", "No.");
                ServiceCrMemoLine.SetFilter(Quantity, '>0');
                if ServiceCrMemoLine.FindSet then
                    repeat
                        if not VPPG.Get(ServiceCrMemoLine."VAT Prod. Posting Group") then
                            VPPG.Init;
                        if DivAd and ("Currency Code" = '') then begin
                            case VPPG."Tipo de bien-servicio" of
                                0: //Bien
                                    ImporteBien += ServiceCrMemoLine.Amount * FactorDivisaAdicional;
                                1: //Servicio
                                    ImporteServicios += ServiceCrMemoLine.Amount * FactorDivisaAdicional;
                                2: //Selectivo
                                    ImporteSelectivo += ServiceCrMemoLine.Amount * FactorDivisaAdicional;
                                3: //Propina
                                    ImportePropina += ServiceCrMemoLine.Amount * FactorDivisaAdicional;
                                else //Otro
                                    ImporteOtros += ServiceCrMemoLine.Amount * FactorDivisaAdicional
                            end;
                        end else begin
                            ///008 conversion factura otra monedas.
                            if "Currency Code" <> '' then
                                FactorDivisa := "Currency Factor"
                            else
                                FactorDivisa := 1;

                            case VPPG."Tipo de bien-servicio" of
                                0: //Bien
                                    ImporteBien += ServiceCrMemoLine.Amount / FactorDivisa;
                                1: //Servicio
                                    ImporteServicios += ServiceCrMemoLine.Amount / FactorDivisa;
                                2: //Selectivo
                                    ImporteSelectivo += ServiceCrMemoLine.Amount / FactorDivisa;
                                3: //Propina
                                    ImportePropina += ServiceCrMemoLine.Amount / FactorDivisa;
                                else //Otro
                                    ImporteOtros += ServiceCrMemoLine.Amount / FactorDivisa;
                            end;
                        end;
                    until ServiceCrMemoLine.Next = 0;


                ImporteTotalNCr := ImporteGravadoNCr + ImporteExentoNCr + ImporteITBISNCr;
                ImporteBaseNCr := ImporteGravadoNCr + ImporteExentoNCr - ImporteSelectivo - ImportePropina - ImporteOtros;

                tImporteBase += Abs(ImporteBaseNCr);
                tImporteTotal += Abs(ImporteTotalNCr);
                tImporteITBIS += Abs(ImporteITBISNCr);
                tImporteGravado += Abs(ImporteGravadoNCr);
                tImporteExento += Abs(ImporteExentoNCr);

                if not Cust.Get("Customer No.") then
                    Cust.Init;

                //Se llena la tabla de ITIBS
                Clear(ArchITBIS);
                ArchITBIS."Número Documento" := "No.";
                ArchITBIS."Fecha Documento" := Format("Posting Date", 0, '<year4>') + Format("Posting Date", 0, '<Month,2>') +
                                                       Format("Posting Date", 0, '<day,2>');
                ArchITBIS.Apellidos := '';
                ArchITBIS.Nombres := '';
                ArchITBIS."Cod. Proveedor" := "Bill-to Customer No.";
                ArchITBIS."Razón Social" := DelChr(CopyStr("Bill-to Name", 1, 60), '=', ',');
                ArchITBIS."Nombre Comercial" := ArchITBIS."Razón Social";
                RNCTxt := DelChr("VAT Registration No.", '=', '- ');
                if StrLen(RNCTxt) < 10 then
                    ArchITBIS.RNC := RNCTxt
                else
                    ArchITBIS.Cédula := CopyStr(RNCTxt, 1, 11);
                ArchITBIS."Total Documento" := ImporteBaseNCr;
                ArchITBIS."ITBIS Pagado" := Abs(ImporteITBISNCr);
                //ArchITBIS.NCF                       := "No. Comprobante Fiscal";
                //ArchITBIS."NCF Relacionado"         := "No. Comprobante Fiscal Rel.";
                ArchITBIS."Codigo reporte" := '607';


                if not FormaPago.Get("Payment Method Code") or ("Payment Method Code" = '') then
                    FormaPago."Forma de pago DGII" := FormaPago."Forma de pago DGII"::"2 - Cheques/Transferencias/Depositos";


                ArchITBIS."Forma de pago DGII" := FormaPago."Forma de pago DGII";

                case FormaPago."Forma de pago DGII" of
                    1:
                        ArchITBIS."Monto Efectivo" := ImporteTotalNCr;
                    2:
                        ArchITBIS."Monto Cheque" := ImporteTotalNCr;
                    3:
                        ArchITBIS."Monto tarjetas" := ImporteTotalNCr;
                    4:
                        ArchITBIS."Venta a credito" := ImporteTotalNCr;
                    5:
                        ArchITBIS."Venta bonos" := ImporteTotalNCr;
                    6:
                        ArchITBIS."Venta Permuta" := ImporteTotalNCr;
                    7:
                        begin
                            //jpg pago mixto +
                            Clear(ImporteTotal2);
                            CustLedgerEntry.Reset;
                            CustLedgerEntry.SetRange("Document No.", "No.");
                            CustLedgerEntry.SetFilter("Document Type", '%1|%2', CustLedgerEntry."Document Type"::Payment, CustLedgerEntry."Document Type"::Payment);
                            CustLedgerEntry.SetRange("Posting Date", "Posting Date");
                            if CustLedgerEntry.FindSet then
                                repeat

                                    Clear(ImporteTotal2);
                                    DetailedCustLedgEntry.Reset;
                                    DetailedCustLedgEntry.SetRange("Ledger Entry Amount", true);
                                    DetailedCustLedgEntry.SetRange("Cust. Ledger Entry No.", CustLedgerEntry."Entry No.");
                                    DetailedCustLedgEntry.SetRange("Posting Date", CustLedgerEntry."Posting Date");
                                    DetailedCustLedgEntry.CalcSums(Amount);
                                    ImporteTotal2 := Abs(DetailedCustLedgEntry.Amount);
                                    if DivAd and ("Currency Code" = '') and (FactorDivisaAdicional = 0) then
                                        ImporteTotal2 := Abs(DetailedCustLedgEntry.Amount) * FactorDivisaAdicional;

                                    FormaPago.Reset;
                                    FormaPago.SetRange(Code, DelChr(SelectStr(2, CustLedgerEntry.Description), '=', ' '));
                                    if FormaPago.FindFirst then
                                        case FormaPago."Forma de pago DGII" of
                                            1:
                                                ArchITBIS."Monto Efectivo" += ImporteTotal2;
                                            2:
                                                ArchITBIS."Monto Cheque" += ImporteTotal2;
                                            3:
                                                ArchITBIS."Monto tarjetas" += ImporteTotal2;
                                            4:
                                                ArchITBIS."Venta a credito" += ImporteTotal2;
                                            5:
                                                ArchITBIS."Venta bonos" += ImporteTotal2;
                                            6:
                                                ArchITBIS."Venta Permuta" += ImporteTotal2;
                                        end;

                                until CustLedgerEntry.Next = 0;
                            //jpg si no encontro improte en ninguna forma pago coloco a credito
                            if ((ArchITBIS."Monto Efectivo" + ArchITBIS."Monto Cheque" + ArchITBIS."Monto tarjetas" + ArchITBIS."Venta a credito"
                             + ArchITBIS."Venta bonos" + ArchITBIS."Venta Permuta") = 0) then begin
                                FormaPago."Forma de pago DGII" := FormaPago."Forma de pago DGII"::"2 - Cheques/Transferencias/Depositos";
                                ArchITBIS."Monto Cheque" := ImporteTotal;
                            end;
                            // ArchITBIS."Monto mixto" := "amount including vat";
                        end
                end;
                ArchITBIS."Forma de pago DGII" := FormaPago."Forma de pago DGII";

                if ArchITBIS.RNC <> '' then begin
                    ArchITBIS."RNC/Cedula" := ArchITBIS.RNC;
                    ArchITBIS."Tipo Identificacion" := 1;
                end
                else begin
                    ArchITBIS."RNC/Cedula" := ArchITBIS.Cédula;
                    ArchITBIS."Tipo Identificacion" := 2;
                end;

                NumeroLinea += 1;
                ArchITBIS."Line No." := NumeroLinea;

                if not ArchITBIS.Insert then
                    Error(Error001);

            end;

            trigger OnPreDataItem()
            begin
                //SETFILTER("Posting Date","Service Invoice Header".GETFILTER("Posting Date"));
                //IF "Service Invoice Header".GETFILTER("Customer Posting Group") <> '' THEN
                // SETFILTER("Customer Posting Group","Service Invoice Header".GETFILTER("Customer Posting Group"));
            end;
        }
        dataitem("Cust. Ledger Entry"; "Cust. Ledger Entry")
        {
            DataItemTableView = SORTING("Document No.", "Document Type", "Customer No.") ORDER(Ascending) WHERE(Open = CONST(false), "Pmt. Disc. Given (LCY)" = FILTER(> 0), "No. Comprobante Fiscal DPP" = FILTER(<> ''));
            column(PostingDate_DetailedCustLedgEntry; rDetailedMovCliente."Posting Date")
            {
            }
            column(DocumentNo_DetailedCustLedgEntry; rDetailedMovCliente."Document No.")
            {
            }
            column(AmountLCY_DetailedCustLedgEntry; "Cust. Ledger Entry"."Pmt. Disc. Given (LCY)")
            {
            }
            column(NoComprobanteFiscal_DetailedCustLedgEntry; "Cust. Ledger Entry"."No. Comprobante Fiscal DPP")
            {
            }
            column(RNCClientedt; Cust."VAT Registration No.")
            {
            }
            column(NoComprobanteFiscalRel_DetailedCustLedgEntry; "Cust. Ledger Entry"."No. Comprobante Fiscal")
            {
            }
            column(ImporteBaseNCrDetailedCustLedgEntry; ImporteBaseNCr)
            {
            }
            column(ImporteITBISNCrDetailedCustLedgEntry; ImporteITBISNCr)
            {
            }
            column(ImporteGravadoNCrDetailedCustLedgEntry; ImporteGravadoNCr)
            {
            }
            column(ImporteExentoNCrDetailedCustLedgEntry; ImporteExentoNCr)
            {
            }
            column(ImporteTotalNCrDetailedCustLedgEntry; ImporteTotalNCr)
            {
            }
            column(BilltoNameDetailedCustLedgEntry; Cust.Name)
            {
            }
            column(NoDetailedCustLedgEntry; Cust."No.")
            {
            }
            column(ImporteITBIS16NCrCustLedgEntry; ImporteITBIS16NCr)
            {
            }
            column(ImporteITBIS18NCrCustLedgEntry; ImporteITBIS18NCr)
            {
            }
            column(BaseITBIS16NCrCustLedgEntry; BaseITBIS16NCr)
            {
            }
            column(BaseITBIS18NCrCustLedgEntry; BaseITBIS18NCr)
            {
            }

            trigger OnAfterGetRecord()
            begin
                ImporteBaseNCr := 0;
                ImporteTotalNCr := 0;
                ImporteITBISNCr := 0;
                "%ITBISNCr" := 0;
                ImporteGravadoNCr := 0;
                ImporteExentoNCr := 0;

                ImporteITBIS16NCr := 0;
                ImporteITBIS18NCr := 0;
                BaseITBIS16NCr := 0;
                BaseITBIS18NCr := 0;

                //para excluir las que tiene corregida.
                SIH.Reset;
                SIH.SetRange("No. Comprobante Fiscal Rel.", "No. Comprobante Fiscal");
                SIH.SetRange(Correction, true);
                SIH.SetRange("Sell-to Customer No.", "Customer No.");
                if SIH.FindFirst then
                    CurrReport.Skip;

                ImporteTotalNCr := Abs("Pmt. Disc. Given (LCY)");
                ImporteBaseNCr := ImporteTotalNCr;
                ImporteExentoNCr := ImporteTotalNCr;

                /*tImporteBase    += ABS(ImporteBaseNCr);
                tImporteTotal   += ABS(ImporteTotalNCr);
                tImporteITBIS   += ABS(ImporteITBISNCr);
                tImporteGravado += ABS(ImporteGravadoNCr);
                tImporteExento  += ABS(ImporteTotalNCr);*/

                if not Cust.Get("Customer No.") then
                    Cust.Init;

                rDetailedMovCliente.Reset;
                rDetailedMovCliente.SetRange("Cust. Ledger Entry No.", "Cust. Ledger Entry"."Closed by Entry No.");
                rDetailedMovCliente.SetRange("Entry Type", rDetailedMovCliente."Entry Type"::"Payment Discount");
                //rDetailedMovCliente.SETFILTER("Posting Date","Sales Cr.Memo Header".GETFILTER("Posting Date"));
                if not rDetailedMovCliente.FindFirst then
                    CurrReport.Skip;

                //Se llena la tabla de ITIBS
                Clear(ArchITBIS);
                ArchITBIS."Número Documento" := rDetailedMovCliente."Document No.";
                ArchITBIS."No. Mov." := "Entry No.";
                ArchITBIS."Fecha Documento" := Format(rDetailedMovCliente."Posting Date", 0, '<year4>') + Format(rDetailedMovCliente."Posting Date", 0, '<Month,2>') +
                                                       Format(rDetailedMovCliente."Posting Date", 0, '<day,2>');
                ArchITBIS.Apellidos := '';
                ArchITBIS.Nombres := '';
                ArchITBIS."Cod. Proveedor" := "Customer No.";
                ArchITBIS."Razón Social" := DelChr(CopyStr(Cust.Name, 1, 60), '=', ',');
                ArchITBIS."Nombre Comercial" := ArchITBIS."Razón Social";
                RNCTxt := DelChr(Cust."VAT Registration No.", '=', '- ');
                if StrLen(RNCTxt) < 10 then
                    ArchITBIS.RNC := RNCTxt
                else
                    ArchITBIS.Cédula := CopyStr(RNCTxt, 1, 11);
                ArchITBIS."Total Documento" := ImporteBaseNCr;
                //ArchITBIS."ITBIS Pagado"            := ABS(ImporteITBISNCr);
                ArchITBIS.NCF := "No. Comprobante Fiscal DPP";
                ArchITBIS."NCF Relacionado" := "No. Comprobante Fiscal";
                ArchITBIS."Tipo documento" := 2; //Nota de credito
                ArchITBIS."Codigo reporte" := '607';



                if ArchITBIS.RNC <> '' then begin
                    ArchITBIS."RNC/Cedula" := ArchITBIS.RNC;
                    ArchITBIS."Tipo Identificacion" := 1;
                end
                else begin
                    ArchITBIS."RNC/Cedula" := ArchITBIS.Cédula;
                    ArchITBIS."Tipo Identificacion" := 2;
                end;

                NumeroLinea += 1;
                ArchITBIS."Line No." := NumeroLinea;

                if not ArchITBIS.Insert then
                    Error(Error001);

            end;

            trigger OnPreDataItem()
            begin
                /*FiltrosNCDPP  := "Cust. Ledger Entry".GETFILTERS;
                
                IF "Cust. Ledger Entry".GETFILTER("Posting Date") = '' THEN
                  ERROR(Error002,"Cust. Ledger Entry".FIELDCAPTION("Posting Date"));
                
                FiltroFecha := "Cust. Ledger Entry".GETFILTER("Posting Date");
                SETFILTER("Posting Date",'');*/
                //SETFILTER("Cust. Ledger Entry"."Pmt. Discount Date","Sales Cr.Memo Header".GETFILTER("Posting Date"));
                //SETFILTER("Cust. Ledger Entry"."Customer Posting Group","Sales Cr.Memo Header".GETFILTER("Customer Posting Group"));

            end;
        }
        dataitem("Issued Fin. Charge Memo Header"; "Issued Fin. Charge Memo Header")
        {
            CalcFields = "VAT Amount", "Remaining Amount", "Interest Amount";
            DataItemTableView = SORTING("No.") ORDER(Ascending) WHERE("No. Comprobante Fiscal" = FILTER(<> ''));
            RequestFilterFields = "Posting Date", "Customer Posting Group", "Shortcut Dimension 1 Code";
            column(FiltrosSIHIssuedFinChargeMemoHeader; FiltrosIFCM)
            {
            }
            column(No_IssuedFinChargeMemoHeader; "No.")
            {
            }
            column(BilltoCustomerNo_IssuedFinChargeMemoHeader; "Customer No.")
            {
            }
            column(BilltoName_IssuedFinChargeMemoHeader; Name)
            {
            }
            column(PostingDate_SIssuedFinChargeMemoHeader; "Posting Date")
            {
            }
            column(NoComprobanteFiscal_IssuedFinChargeMemoHeader; "No. Comprobante Fiscal")
            {
            }
            column(RNCClienteIssuedFinChargeMemoHeader; Cust."VAT Registration No.")
            {
            }
            column(ImporteBaseIssuedFinChargeMemoHeader; ImporteBase)
            {
            }
            column(ImporteExentoIssuedFinChargeMemoHeader; ImporteExento)
            {
            }
            column(ImporteGravadoIssuedFinChargeMemoHeader; ImporteGravado)
            {
            }
            column(ImporteITBISIssuedFinChargeMemoHeader; ImporteITBIS)
            {
            }
            column(ImporteTotalIssuedFinChargeMemoHeader; ImporteTotal)
            {
            }
            column(ImporteITBIS16IssuedFinChargeMemoHeader; ImporteITBIS16)
            {
            }
            column(ImporteITBIS18IssuedFinChargeMemoHeader; ImporteITBIS18)
            {
            }
            column(BaseITBIS16IssuedFinChargeMemoHeader; BaseITBIS16)
            {
            }
            column(BaseITBIS18IssuedFinChargeMemoHeader; BaseITBIS18)
            {
            }

            trigger OnAfterGetRecord()
            begin
                ImporteBase := 0;
                ImporteTotal := 0;
                ImporteITBIS := 0;
                "%ITBIS" := 0;
                ImporteExento := 0;
                ImporteGravado := 0;
                ImporteExento := 0;
                ImporteSelectivo := 0;
                ImporteBien := 0;
                ImporteServicios := 0;
                ImportePropina := 0;
                ImporteOtros := 0;
                ITBISRetenido := 0;
                ImporteITBIS16 := 0;
                ImporteITBIS18 := 0;
                BaseITBIS16 := 0;
                BaseITBIS18 := 0;

                FactorDivisaAdicional := 0;
                FactorDivisa := 0;

                CalcFields("Issued Fin. Charge Memo Header"."Interest Amount", "Issued Fin. Charge Memo Header"."VAT Amount");
                if "Interest Amount" = 0 then
                    CurrReport.Skip;

                if "No. Comprobante Fiscal" = '' then
                    CurrReport.Skip;

                //para excluir las que tiene corregida.
                SCMH.Reset;
                SCMH.SetRange("No. Comprobante Fiscal Rel.", "No. Comprobante Fiscal");
                SCMH.SetRange(Correction, true);
                SCMH.SetRange("Sell-to Customer No.", "Customer No.");
                if SCMH.FindFirst then
                    CurrReport.Skip;



                if DivAd then begin
                    VE.Reset;
                    VE.SetCurrentKey("Document No.", "Posting Date");
                    VE.SetRange("Document No.", "No.");
                    VE.SetRange("Posting Date", "Posting Date");
                    VE.SetRange(VE."Document Type", VE."Document Type"::"Finance Charge Memo");
                    if VE.FindSet() then
                        repeat
                            if VE.Amount <> 0 then begin
                                ImporteGravado += (VE."Additional-Currency Base") * -1;
                                ImporteITBIS += VE."Additional-Currency Amount" * -1;

                                if VPSetup.Get(VE."VAT Bus. Posting Group", VE."VAT Prod. Posting Group") then begin
                                    if VPSetup."VAT %" = 18 then begin
                                        ImporteITBIS18 += Abs(VE."Additional-Currency Amount") * -1;
                                        BaseITBIS18 += VE."Additional-Currency Base" * -1;
                                    end;

                                    if VPSetup."VAT %" = 16 then begin
                                        ImporteITBIS16 += (VE."Additional-Currency Amount") * -1;
                                        BaseITBIS16 += VE."Additional-Currency Base";
                                    end;
                                end;

                            end
                            else
                                ImporteExento += VE."Additional-Currency Base";

                            //para capturar factor divisa adicional.
                            if (FactorDivisaAdicional = 0) and ("Currency Code" = '') then
                                FactorDivisaAdicional := Abs(VE."Additional-Currency Base") / Abs(VE.Base);

                        until VE.Next = 0;
                end
                else begin
                    VE.Reset;
                    VE.SetCurrentKey("Document No.", "Posting Date");
                    VE.SetRange("Document No.", "No.");
                    VE.SetRange("Posting Date", "Posting Date");
                    VE.SetRange(VE."Document Type", VE."Document Type"::"Finance Charge Memo");
                    if VE.FindSet() then
                        repeat
                            if VE.Amount <> 0 then begin
                                ImporteGravado += VE.Base * -1;
                                ImporteITBIS += VE.Amount * -1;

                                if VPSetup.Get(VE."VAT Bus. Posting Group", VE."VAT Prod. Posting Group") then begin
                                    if VPSetup."VAT %" = 18 then begin
                                        ImporteITBIS18 += VE.Amount * -1;
                                        BaseITBIS18 += VE.Base * -1;
                                    end;

                                    if VPSetup."VAT %" = 16 then begin
                                        ImporteITBIS16 += VE.Amount * -1;
                                        BaseITBIS16 += VE.Base * -1;
                                    end;
                                end;

                            end
                            else
                                ImporteExento += VE.Base * -1;

                            ///008 conversion factura otra monedas.
                            if "Currency Code" <> '' then
                                FactorDivisa := Abs(VE."Additional-Currency Base") / Abs(VE.Base)
                            else
                                FactorDivisa := 1;

                        until VE.Next = 0;
                end;



                /*
                IF DivAd THEN
                  BEGIN
                    VE.RESET;
                    VE.SETCURRENTKEY("Document No.","Posting Date");
                    VE.SETRANGE("Document No.","No.");
                    VE.SETRANGE("Posting Date","Posting Date");
                    VE.SETRANGE("Document Type",VE."Document Type"::"Finance Charge Memo");
                    IF VE.FINDSET(FALSE,FALSE) THEN
                      REPEAT
                        IF NOT VPPG.GET(VE."VAT Prod. Posting Group") THEN
                          VPPG.INIT;
                        CASE VPPG."Tipo de bien-servicio" OF
                          0: //Bien
                            ImporteBien += VE."Additional-Currency Base"*-1;
                          1: //Servicio
                            ImporteServicios += VE."Additional-Currency Base"*-1;
                          2: //Selectivo
                            ImporteSelectivo += VE."Additional-Currency Base"*-1;
                          3: //Propina
                            ImportePropina += VE."Additional-Currency Base"*-1;
                          ELSE //Otro
                            ImporteOtros += VE."Additional-Currency Base"*-1;
                        END;
                      UNTIL VE.NEXT = 0;
                  END
                ELSE
                  BEGIN
                    VE.RESET;
                    VE.SETCURRENTKEY("Document No.","Posting Date");
                    VE.SETRANGE("Document No.","No.");
                    VE.SETRANGE("Posting Date","Posting Date");
                    VE.SETRANGE("Document Type",VE."Document Type"::"Finance Charge Memo");
                    IF VE.FINDSET(FALSE,FALSE) THEN
                      REPEAT
                        IF NOT VPPG.GET(VE."VAT Prod. Posting Group") THEN
                          VPPG.INIT;
                        CASE VPPG."Tipo de bien-servicio" OF
                          0: //Bien
                            ImporteBien += VE.Base*-1;
                          1: //Servicio
                            ImporteServicios += VE.Base*-1;
                          2: //Selectivo
                            ImporteSelectivo += VE.Base*-1;
                          3: //Propina
                            ImportePropina += VE.Base*-1;
                          ELSE //Otro
                            ImporteOtros += VE.Base*-1;
                        END;
                      UNTIL VE.NEXT = 0;
                  END;
                  */

                IssuedFinChargeMemoLine.Reset;
                IssuedFinChargeMemoLine.SetRange("Document No.", "No.");
                //IssuedFinChargeMemoLine.SETFILTER(Quantity,'>0');
                if IssuedFinChargeMemoLine.FindSet then
                    repeat
                        if not VPPG.Get(IssuedFinChargeMemoLine."VAT Prod. Posting Group") then
                            VPPG.Init;
                        if DivAd and ("Currency Code" = '') then begin

                            case VPPG."Tipo de bien-servicio" of
                                0: //Bien
                                    ImporteBien += IssuedFinChargeMemoLine.Amount * FactorDivisaAdicional;
                                1: //Servicio
                                    ImporteServicios += IssuedFinChargeMemoLine.Amount * FactorDivisaAdicional;
                                2: //Selectivo
                                    ImporteSelectivo += IssuedFinChargeMemoLine.Amount * FactorDivisaAdicional;
                                3: //Propina
                                    ImportePropina += IssuedFinChargeMemoLine.Amount * FactorDivisaAdicional;
                                else //Otro
                                    ImporteOtros += IssuedFinChargeMemoLine.Amount * FactorDivisaAdicional;
                            end;

                        end else begin

                            case VPPG."Tipo de bien-servicio" of
                                0: //Bien
                                    ImporteBien += IssuedFinChargeMemoLine.Amount / FactorDivisa;
                                1: //Servicio
                                    ImporteServicios += IssuedFinChargeMemoLine.Amount / FactorDivisa;
                                2: //Selectivo
                                    ImporteSelectivo += IssuedFinChargeMemoLine.Amount / FactorDivisa;
                                3: //Propina
                                    ImportePropina += IssuedFinChargeMemoLine.Amount / FactorDivisa;
                                else //Otro
                                    ImporteOtros += IssuedFinChargeMemoLine.Amount / FactorDivisa;
                            end;

                        end;

                    until IssuedFinChargeMemoLine.Next = 0;



                ImporteTotal := ImporteGravado + ImporteExento + ImporteITBIS;
                ImporteBase += ImporteGravado + ImporteExento - ImporteSelectivo - ImportePropina - ImporteOtros;

                tImporteBase += Abs(ImporteBase);
                tImporteTotal += Abs(ImporteTotal);
                tImporteITBIS += Abs(ImporteITBIS);
                tImporteGravado += Abs(ImporteGravado);
                tImporteExento += Abs(ImporteExento);

                if not Cust.Get("Customer No.") then
                    Cust.Init;


                //Busco la forma de pago
                //IF NOT FormaPago.GET("Payment Method Code") OR ("Payment Method Code" = '')  THEN
                FormaPago."Forma de pago DGII" := FormaPago."Forma de pago DGII"::"4 - Compra a credito";


                //Se llena la tabla de ITBIS
                GCC.Get("Customer Posting Group");
                Clear(ArchITBIS);
                ArchITBIS."Número Documento" := "No.";
                ArchITBIS."Fecha Documento" := Format("Posting Date", 0, '<year4>') + Format("Posting Date", 0, '<Month,2>') +
                                                    Format("Posting Date", 0, '<day,2>');

                ArchITBIS.Apellidos := '';
                ArchITBIS.Nombres := '';
                ArchITBIS."Cod. Proveedor" := "Customer No.";
                ArchITBIS."Razón Social" := DelChr(CopyStr("Issued Fin. Charge Memo Header".Name, 1, 60), '=', ',');
                ArchITBIS."Nombre Comercial" := ArchITBIS."Razón Social";
                RNCTxt := DelChr("VAT Registration No.", '=', '- ');
                if StrLen(RNCTxt) < 10 then
                    ArchITBIS.RNC := RNCTxt
                else
                    ArchITBIS.Cédula := CopyStr(RNCTxt, 1, 11);
                ArchITBIS."Total Documento" := ImporteBase;
                ArchITBIS."ITBIS Pagado" := Abs(ImporteITBIS);
                ArchITBIS."Fecha Pago" := ArchITBIS."Fecha Documento";
                ArchITBIS.NCF := "No. Comprobante Fiscal";
                ArchITBIS."Tipo documento" := 1; //Factura
                ArchITBIS."Forma de pago DGII" := FormaPago."Forma de pago DGII";
                ArchITBIS."Tipo de ingreso" := DelChr("Tipo de ingreso", '=', '0');
                ArchITBIS."Monto Bienes" := ImporteBien;
                ArchITBIS."Monto Servicios" := ImporteServicios;
                ArchITBIS."Monto Selectivo" := ImporteSelectivo;
                ArchITBIS."Monto Propina" := ImportePropina;
                ArchITBIS."Monto otros" := ImporteOtros;
                ArchITBIS."Codigo reporte" := '607';
                case FormaPago."Forma de pago DGII" of
                    1:
                        ArchITBIS."Monto Efectivo" := ImporteTotal;
                    2:
                        ArchITBIS."Monto Cheque" := ImporteTotal;
                    3:
                        ArchITBIS."Monto tarjetas" := ImporteTotal;
                    4:
                        ArchITBIS."Venta a credito" := ImporteTotal;
                    5:
                        ArchITBIS."Venta bonos" := ImporteTotal;
                    6:
                        ArchITBIS."Venta Permuta" := ImporteTotal;
                    7:
                        begin //jpg pago mixto +
                            Clear(ImporteTotal2);
                            CustLedgerEntry.Reset;
                            CustLedgerEntry.SetRange("Document No.", "No.");
                            CustLedgerEntry.SetFilter("Document Type", '%1|%2', CustLedgerEntry."Document Type"::" ", CustLedgerEntry."Document Type"::Payment);
                            CustLedgerEntry.SetRange("Posting Date", "Posting Date");
                            if CustLedgerEntry.FindSet then
                                repeat

                                    Clear(ImporteTotal2);
                                    DetailedCustLedgEntry.Reset;
                                    DetailedCustLedgEntry.SetRange("Ledger Entry Amount", true);
                                    DetailedCustLedgEntry.SetRange("Cust. Ledger Entry No.", CustLedgerEntry."Entry No.");
                                    DetailedCustLedgEntry.SetRange("Posting Date", CustLedgerEntry."Posting Date");
                                    DetailedCustLedgEntry.CalcSums(Amount);
                                    ImporteTotal2 := Abs(DetailedCustLedgEntry.Amount);

                                    if DivAd and ("Currency Code" = '') and (FactorDivisaAdicional = 0) then
                                        ImporteTotal2 := Abs(DetailedCustLedgEntry.Amount) * FactorDivisaAdicional;

                                    FormaPago.Reset;
                                    FormaPago.SetRange(Code, DelChr(SelectStr(2, CustLedgerEntry.Description), '=', ' '));
                                    if FormaPago.FindFirst then
                                        case FormaPago."Forma de pago DGII" of
                                            1:
                                                ArchITBIS."Monto Efectivo" += ImporteTotal2;
                                            2:
                                                ArchITBIS."Monto Cheque" += ImporteTotal2;
                                            3:
                                                ArchITBIS."Monto tarjetas" += ImporteTotal2;
                                            4:
                                                ArchITBIS."Venta a credito" += ImporteTotal2;
                                            5:
                                                ArchITBIS."Venta bonos" += ImporteTotal2;
                                            6:
                                                ArchITBIS."Venta Permuta" += ImporteTotal2;
                                        end;

                                until CustLedgerEntry.Next = 0;
                            //jpg si no encontro improte en ninguna forma pago coloco a credito
                            if ((ArchITBIS."Monto Efectivo" + ArchITBIS."Monto Cheque" + ArchITBIS."Monto tarjetas" + ArchITBIS."Venta a credito"
                             + ArchITBIS."Venta bonos" + ArchITBIS."Venta Permuta") = 0) then begin
                                FormaPago."Forma de pago DGII" := FormaPago."Forma de pago DGII"::"2 - Cheques/Transferencias/Depositos";
                                ArchITBIS."Monto Cheque" := ImporteTotal;
                            end;
                            // ArchITBIS."Monto mixto" := "amount including vat";
                        end
                end;
                //jpg pago mixto --
                ArchITBIS."Forma de pago DGII" := FormaPago."Forma de pago DGII";

                if ArchITBIS.RNC <> '' then begin
                    ArchITBIS."RNC/Cedula" := ArchITBIS.RNC;
                    ArchITBIS."Tipo Identificacion" := 1;
                end
                else begin
                    ArchITBIS."RNC/Cedula" := ArchITBIS.Cédula;
                    ArchITBIS."Tipo Identificacion" := 2;
                end;

                NumeroLinea += 1;
                ArchITBIS."Line No." := NumeroLinea;

                if not ArchITBIS.Insert then
                    Error(Error001);

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
                field(DivAd; DivAd)
                {
                    Caption = 'Currency';
                    ApplicationArea = Basic, Suite;
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
        ArchITBIS.SetRange("Codigo reporte", '607');
        ArchITBIS.DeleteAll;

        NumeroLinea += 1;


        InfoEmpresa.Get;
        DirEmpresa[1] := InfoEmpresa.Name;
        DirEmpresa[2] := InfoEmpresa."Name 2";
        DirEmpresa[3] := InfoEmpresa.Address;
        DirEmpresa[4] := InfoEmpresa."Address 2";
        DirEmpresa[5] := InfoEmpresa.City;
        DirEmpresa[6] := InfoEmpresa."Post Code" + ' ' + InfoEmpresa.County;
        DirEmpresa[7] := txt001 + InfoEmpresa."VAT Registration No.";
        CompressArray(DirEmpresa);

        FiltrosSIH := "Sales Invoice Header".GetFilters;
        FiltrosSCMH := "Sales Cr.Memo Header".GetFilters;
        FiltrosSIH_S := "Service Invoice Header".GetFilters;
        FiltrosSCMH_S := "Service Cr.Memo Header".GetFilters;


        if "Sales Invoice Header".GetFilter("Posting Date") = '' then
            Error(Error002, "Sales Invoice Header".FieldCaption("Posting Date"), "Sales Invoice Header".TableName);


        if "Sales Cr.Memo Header".GetFilter("Posting Date") = '' then
            Error(Error002, "Sales Cr.Memo Header".FieldCaption("Posting Date"), "Sales Cr.Memo Header".TableName);


        if "Service Invoice Header".GetFilter("Posting Date") = '' then
            Error(Error002, "Service Invoice Header".FieldCaption("Posting Date"), "Service Invoice Header".TableName);


        if "Service Cr.Memo Header".GetFilter("Posting Date") = '' then
            Error(Error002, "Service Cr.Memo Header".FieldCaption("Posting Date"), "Service Cr.Memo Header".TableName);

        if "Issued Fin. Charge Memo Header".GetFilter("Posting Date") = '' then
            Error(Error002, "Issued Fin. Charge Memo Header".FieldCaption("Posting Date"), "Issued Fin. Charge Memo Header".TableName);

        "Cust. Ledger Entry".SetFilter("Cust. Ledger Entry"."Pmt. Discount Date", "Sales Cr.Memo Header".GetFilter("Posting Date"));
        "Cust. Ledger Entry".SetFilter("Cust. Ledger Entry"."Customer Posting Group", "Sales Cr.Memo Header".GetFilter("Customer Posting Group"));

        FiltrosHDPP := "Cust. Ledger Entry".GetFilters;
    end;

    var
        Cust: Record Customer;
        ArchITBIS: Record "Archivo Transferencia ITBIS";
        GCC: Record "Customer Posting Group";
        InfoEmpresa: Record "Company Information";
        VE: Record "VAT Entry";
        GLE: Record "G/L Entry";
        VPSetup: Record "VAT Posting Setup";
        SIL: Record "Sales Invoice Line";
        FormaPago: Record "Payment Method";
        VPPG: Record "VAT Product Posting Group";
        DirEmpresa: array[7] of Text[250];
        ImporteBase: Decimal;
        "%ITBIS": Decimal;
        ImporteITBIS: Decimal;
        ImporteGravado: Decimal;
        ImporteExento: Decimal;
        ImporteTotal: Decimal;
        ImporteBaseCta: Decimal;
        "%ITBISCta": Decimal;
        ImporteITBISCta: Decimal;
        ImporteGravadoCta: Decimal;
        ImporteExentoCta: Decimal;
        ImporteSelectivo: Decimal;
        ImportePropina: Decimal;
        ImporteBien: Decimal;
        ImporteServicios: Decimal;
        ImporteOtros: Decimal;
        FiltroGpoContProv: Text[30];
        FechaIni: Date;
        FechaFin: Date;
        ImporteBaseNCr: Decimal;
        "%ITBISNCr": Decimal;
        ImporteITBISNCr: Decimal;
        ImporteGravadoNCr: Decimal;
        ImporteExentoNCr: Decimal;
        ImporteTotalNCr: Decimal;
        DivAd: Boolean;
        RNCTxt: Text[30];
        GeneraArchivoITBIS: Boolean;
        Clasificacion: Code[2];
        ITBISRetenido: Decimal;
        CtasRetencionITBIS: Text[30];
        NoDoc: Code[20];
        tImporteBase: Decimal;
        tImporteITBIS: Decimal;
        tImporteGravado: Decimal;
        tImporteExento: Decimal;
        tImporteTotal: Decimal;
        DivisaAdicional: Boolean;
        RNCCliente: Text[30];
        txt001: Label 'RNC/Cédula ';
        Error001: Label 'Please Delete all the files in the NCF Table';
        FiltrosSIH: Text[1024];
        FiltrosSCMH: Text[1024];
        txt002: Label 'Sales Invoice Header';
        txt003: Label 'Sales Cr.Memo Header';
        Error002: Label 'Filter Required for the field %1 of the table %2';
        FiltrosSIH_S: Text[1024];
        FiltrosSCMH_S: Text[1024];
        FiltroFecha: Text[60];
        ImporteITBIS16: Decimal;
        ImporteITBIS18: Decimal;
        BaseITBIS16: Decimal;
        BaseITBIS18: Decimal;
        BaseExento: Decimal;
        ImporteITBIS16NCr: Decimal;
        ImporteITBIS18NCr: Decimal;
        BaseITBIS16NCr: Decimal;
        BaseITBIS18NCr: Decimal;
        BaseExentoNCr: Decimal;
        SCMH: Record "Sales Cr.Memo Header";
        SIH: Record "Sales Invoice Header";
        rDetailedMovCliente: Record "Detailed Cust. Ledg. Entry";
        FiltrosHDPP: Text[1024];
        CustLedgerEntry: Record "Cust. Ledger Entry";
        DetailedCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
        ImporteTotal2: Decimal;
        SalesCrMemoLine: Record "Sales Cr.Memo Line";
        SalesInvoiceLine: Record "Sales Invoice Line";
        ServiceInvoiceLine: Record "Service Invoice Line";
        ServiceCrMemoLine: Record "Service Cr.Memo Line";
        FiltrosIFCM: Text[1024];
        FactorDivisaAdicional: Decimal;
        IssuedFinChargeMemoLine: Record "Issued Fin. Charge Memo Line";
        FactorDivisa: Decimal;
        NumeroLinea: Integer;
}

