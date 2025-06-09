report 76355 "Facturas de Consumo (607-A)"
{
    DefaultLayout = RDLC;
    RDLCLayout = './FacturasdeConsumo607A.rdlc';

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
                FactorDivisaAdicional := 0;
                FactorDivisa := 0;

                CalcFields("Amount Including VAT", Amount);
                if "Amount Including VAT" = 0 then
                    CurrReport.Skip;

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

                /*Solo funciona para UB
                IF Promocion THEN
                   BEGIN
                    ImporteITBIS    := 0;
                    ImporteGravado  := 0;
                    VPSetup.RESET;
                    VPSetup.SETRANGE("VAT Bus. Posting Group","VAT Bus. Posting Group");
                    VPSetup.FINDFIRST;
                
                    GLE.RESET;
                    GLE.SETCURRENTKEY("Posting Date",Description);
                    GLE.SETRANGE("G/L Account No.",VPSetup."Sales VAT Account");
                    GLE.SETFILTER("Posting Date",FiltroFecha);
                    GLE.SETFILTER(Description,'%1','*' + "No." + '*');
                    IF GLE.FINDSET THEN
                       REPEAT
                        ImporteITBIS += GLE.Amount *-1;
                       UNTIL GLE.NEXT = 0;
                
                
                     GLE.RESET;
                     GLE.SETCURRENTKEY("Document No.","Posting Date");
                     GLE.SETRANGE("Document No.","No.");
                     GLE.SETRANGE("Posting Date","Posting Date");
                     GLE.SETFILTER("Debit Amount",'<>%1',0);
                     IF GLE.FINDSET THEN
                       REPEAT
                        ImporteGravado += GLE."Debit Amount";
                       UNTIL GLE.NEXT = 0;
                
                    SIL.RESET;
                    SIL.SETRANGE("Document No.","No.");
                    SIL.SETFILTER(Quantity,'<>%1',0);
                    SIL.SETRANGE(Amount,0);
                    SIL.SETRANGE(Type,SIL.Type::Item);
                    SIL.SETFILTER("No.",'<>%1','');
                    IF SIL.FINDFIRST THEN
                       BEGIN
                         IF SIL."Posting Group" = 'POP' THEN
                            BEGIN
                              ImporteGravado := 0;
                              ImporteITBIS := 0;
                            END;
                       END;
                
                
                {
                    SIL.RESET;
                    SIL.SETRANGE("Document No.","No.");
                    SIL.SETFILTER(Quantity,'<>%1',0);
                    SIL.SETRANGE(Amount,0);
                    SIL.SETRANGE(Type,SIL.Type::Item);
                    SIL.SETFILTER("No.",'<>%1','');
                    IF SIL.FINDSET THEN
                       REPEAT
                        ImporteGravado += SIL."Unit Cost (LCY)" * SIL.Quantity;
                       UNTIL SIL.NEXT = 0;
                    ImporteGravado := ROUND(ImporteGravado,0.01);
                }
                   END;
                */



                if not Cust.Get("Sell-to Customer No.") then
                    Cust.Init;

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
                ImporteBase := ImporteGravado + ImporteExento - ImporteSelectivo - ImportePropina - ImporteOtros;

                tImporteBase += Abs(ImporteBase);
                tImporteTotal += Abs(ImporteTotal);
                tImporteITBIS += Abs(ImporteITBIS);
                tImporteGravado += Abs(ImporteGravado);
                tImporteExento += Abs(ImporteExento);

                //Busco la forma de pago
                if FormaPago.Get("Payment Method Code") then;

                //Se llena la tabla de ITBIS
                GCC.Get("Customer Posting Group");
                Clear(ArchITBIS);
                CalcFields("Amount Including VAT", Amount);
                ArchITBIS."Número Documento" := "No.";
                ArchITBIS."Fecha Documento" := Format("Posting Date", 0, '<year4>') + Format("Posting Date", 0, '<Month,2>') +
                                                    Format("Posting Date", 0, '<day,2>');

                ArchITBIS.Apellidos := '';
                ArchITBIS.Nombres := '';
                ArchITBIS."Cod. Proveedor" := "Sell-to Customer No.";
                ArchITBIS."Razón Social" := DelChr(CopyStr("Sell-to Customer Name", 1, 60), '=', ',');
                //ArchITBIS."Razon Social"       := DELCHR(COPYSTR("Bill-to Name",1,60),'=',',');
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
                ArchITBIS."Codigo reporte" := '607-A';

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
                            // ArchITBIS."Monto mixto" := "amount including vat";
                        end;

                //jpg pago mixto --
                end;

                if ArchITBIS.RNC <> '' then begin
                    ArchITBIS."RNC/Cedula" := ArchITBIS.RNC;
                    ArchITBIS."Tipo Identificacion" := 1;
                end
                else begin
                    ArchITBIS."RNC/Cedula" := ArchITBIS.Cédula;
                    ArchITBIS."Tipo Identificacion" := 2;
                end;

                //jpg 27/07/2020
                if (CopyStr(ArchITBIS.NCF, 1, 3) <> 'B02') or
                  ((CopyStr(ArchITBIS.NCF, 1, 3) = 'B02') and ((ArchITBIS."Total Documento") > 250000)) then
                    CurrReport.Skip;

                NumeroLinea += 1;
                ArchITBIS."Line No." := NumeroLinea;

                if not ArchITBIS.Insert then
                    Error(Error001);

            end;
        }
        dataitem("Service Invoice Header"; "Service Invoice Header")
        {
            DataItemTableView = SORTING("No.") ORDER(Ascending);
            RequestFilterFields = "Posting Date", "Customer Posting Group";
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
                ImporteSelectivo := 0;
                ImporteBien := 0;
                ImporteServicios := 0;
                ImportePropina := 0;
                ImporteOtros := 0;
                FactorDivisaAdicional := 0;
                FactorDivisa := 0;

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
                ArchITBIS."Razón Social" := DelChr(CopyStr("Bill-to Name", 1, 60), '=', ',');
                ArchITBIS."Cod. Proveedor" := "Customer No.";
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
                ArchITBIS."Monto Bienes" := ImporteBien;
                ArchITBIS."Monto Servicios" := ImporteServicios;
                ArchITBIS."Monto Selectivo" := ImporteSelectivo;
                ArchITBIS."Monto Propina" := ImportePropina;
                ArchITBIS."Monto otros" := ImporteOtros;
                ArchITBIS."Codigo reporte" := '607-A';
                if ArchITBIS.RNC <> '' then begin
                    ArchITBIS."RNC/Cedula" := ArchITBIS.RNC;
                    ArchITBIS."Tipo Identificacion" := 1;
                end
                else begin
                    ArchITBIS."RNC/Cedula" := ArchITBIS.Cédula;
                    ArchITBIS."Tipo Identificacion" := 2;
                end;

                if FormaPago.Get("Payment Method Code") then;

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
                        begin
                            //jpg pago mixto +
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

                                    if DivAd and ("Currency Code" = '') then
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
                            // ArchITBIS."Monto mixto" := "amount including vat";
                        end
                end;

                //jpg pago mixto --

                //jpg 27/07/2020
                if (CopyStr(ArchITBIS.NCF, 1, 3) <> 'B02') or
                  ((CopyStr(ArchITBIS.NCF, 1, 3) = 'B02') and ((ArchITBIS."Total Documento") > 250000)) then // jpg 02/07/2021 evaluar sin itbis
                    CurrReport.Skip;

                NumeroLinea += 1;
                ArchITBIS."Line No." := NumeroLinea;

                if not ArchITBIS.Insert then
                    Error(Error001);

            end;

            trigger OnPreDataItem()
            begin
                "Sales Invoice Header".CopyFilter("Posting Date", "Service Invoice Header"."Posting Date");


                if "Service Invoice Header".GetFilter("Posting Date") = '' then
                    Error(Error002, "Service Invoice Header".FieldCaption("Posting Date"));
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
                ImporteBase := ImporteGravado + ImporteExento - ImporteSelectivo - ImportePropina - ImporteOtros;


                tImporteBase += Abs(ImporteBase);
                tImporteTotal += Abs(ImporteTotal);
                tImporteITBIS += Abs(ImporteITBIS);
                tImporteGravado += Abs(ImporteGravado);
                tImporteExento += Abs(ImporteExento);

                if not Cust.Get("Customer No.") then
                    Cust.Init;

                //Busco la forma de pago
                //IF NOT FormaPago.GET("Payment Method Code") OR ("Payment Method Code" = '')  THEN
                FormaPago."Forma de pago DGII" := FormaPago."Forma de pago DGII"::"7 - Mixto";


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
                ArchITBIS."Codigo reporte" := '607-A';
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
                            // ArchITBIS."Monto mixto" := "amount including vat";
                        end
                end;
                //jpg pago mixto --

                if ArchITBIS.RNC <> '' then begin
                    ArchITBIS."RNC/Cedula" := ArchITBIS.RNC;
                    ArchITBIS."Tipo Identificacion" := 1;
                end
                else begin
                    ArchITBIS."RNC/Cedula" := ArchITBIS.Cédula;
                    ArchITBIS."Tipo Identificacion" := 2;
                end;


                //jpg 27/07/2020
                if (CopyStr(ArchITBIS.NCF, 1, 3) <> 'B02') or
                  ((CopyStr(ArchITBIS.NCF, 1, 3) = 'B02') and ((ArchITBIS."Total Documento") > 250000)) then
                    CurrReport.Skip;

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
        ArchITBIS.SetRange("Codigo reporte", '607-A');
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
        FiltrosIFCM := "Issued Fin. Charge Memo Header".GetFilters;
        FiltrosSIH_S := "Service Invoice Header".GetFilters;

        if "Sales Invoice Header".GetFilter("Posting Date") = '' then
            Error(Error002, "Sales Invoice Header".FieldCaption("Posting Date"), "Sales Invoice Header".TableName);


        if "Service Invoice Header".GetFilter("Posting Date") = '' then
            Error(Error002, "Service Invoice Header".FieldCaption("Posting Date"), "Service Invoice Header".TableName);


        if "Issued Fin. Charge Memo Header".GetFilter("Posting Date") = '' then
            Error(Error002, "Issued Fin. Charge Memo Header".FieldCaption("Posting Date"), "Issued Fin. Charge Memo Header".TableName);

        FiltroFecha := "Sales Invoice Header".GetFilter("Posting Date");

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
        FiltrosIFCM: Text[1024];
        SalesCrMemoLine: Record "Sales Cr.Memo Line";
        SalesInvoiceLine: Record "Sales Invoice Line";
        ServiceInvoiceLine: Record "Service Invoice Line";
        ServiceCrMemoLine: Record "Service Cr.Memo Line";
        FactorDivisaAdicional: Decimal;
        FactorDivisa: Decimal;
        IssuedFinChargeMemoLine: Record "Issued Fin. Charge Memo Line";
        NumeroLinea: Integer;
}

