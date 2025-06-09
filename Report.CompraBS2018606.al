report 76090 "Compra B-S 2018 (606)"
{
    // Proyecto: Microsoft Dynamics Nav
    // ---------------------------------
    // JPG    : John Peralta Guzman
    // ------------------------------------------------------------------------
    // No.         Fecha       Firma      Descripcion
    // ------------------------------------------------------------------------
    // DSLoc1.04   11-jun-2019  JPG       Texto CORREC Incluido y tipo identificacion
    DefaultLayout = RDLC;
    RDLCLayout = './CompraBS2018606.rdlc';


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
                if (CopyStr("No. Comprobante Fiscal", 1, 10) = 'CORRECCION')
                  or (CopyStr("No. Comprobante Fiscal", 1, 10) = 'CORRECTION')
                  or (CopyStr("No. Comprobante Fiscal", 1, 6) = 'CORREC') then
                    CurrReport.Skip;

                //jpg no facturas en 0 para evitar errores
                CalcFields(Amount);
                if (Amount = 0) then begin
                    PIH.Reset;
                    PIH.SetRange("Prepayment Order No.", "Order No.");
                    PIH.SetRange("Buy-from Vendor No.", "Buy-from Vendor No.");
                    PIH.SetRange("Prepayment Invoice", true);
                    if not PIH.FindFirst then    //jpg 13-09-2021 si no es de una factura anticipo no pasar
                        CurrReport.Skip;
                end;

                //para excluir las que tiene corregida por "Applies-to Doc. No.".
                PCMH.Reset;
                PCMH.SetRange("Applies-to Doc. No.", "No.");
                PCMH.SetRange(Correction, true);
                PCMH.SetRange("Buy-from Vendor No.", "Buy-from Vendor No.");
                if PCMH.FindFirst then begin // verificar si no hay una Factura correctiva anulando la nc
                    PIH.Reset;
                    PIH.SetRange("Applies-to Doc. No.", PCMH."No.");
                    PIH.SetRange(Correction, true);
                    PIH.SetRange("Buy-from Vendor No.", PCMH."Buy-from Vendor No.");
                    if not PIH.FindFirst then
                        CurrReport.Skip;
                end;

                //para excluir las que tiene corregida por "No. Comprobante Fiscal Rel.".
                if (CopyStr("No. Comprobante Fiscal", 1, 3) = 'B11')
                   and (CopyStr("No. Comprobante Fiscal", 1, 3) = 'B13') then begin
                    PCMH.Reset;
                    PCMH.SetRange("No. Comprobante Fiscal Rel.", "No. Comprobante Fiscal");
                    PCMH.SetRange(Correction, true);
                    PCMH.SetRange("Buy-from Vendor No.", "Buy-from Vendor No.");
                    if PCMH.FindFirst then begin // verificar si no hay una Factura correctiva anulando la nc
                        PIH.Reset;
                        PIH.SetRange("Applies-to Doc. No.", PCMH."No.");
                        PIH.SetRange(Correction, true);
                        PIH.SetRange("Buy-from Vendor No.", PCMH."Buy-from Vendor No.");
                        if not PIH.FindFirst then
                            CurrReport.Skip;
                    end;
                end;

                if Correction then
                    CurrReport.Skip;

                if "No. Comprobante Fiscal" = '' then
                    CurrReport.Skip;

                ImporteBase := 0;
                ImporteTotal := 0;
                ImporteITBIS := 0;
                ISRRetenido := 0;
                ImporteGravado := 0;
                ImporteExento := 0;
                ImporteSelectivo := 0;
                ImporteBien := 0;
                ImporteServicios := 0;
                ImportePropina := 0;
                ImporteOtros := 0;
                ITBISRetenido := 0;
                ISRRetenido := 0;
                OtrasRetenciones := 0;
                FactorDivisaAdicional := 0;
                FactorDivisa := 0;

                ImporteITBIS16 := 0;
                ImporteITBIS18 := 0;
                BaseITBIS16 := 0;
                BaseITBIS18 := 0;

                Clear(txtCostosGastos);

                //ISR Retenido
                GLE.Reset;
                GLE.SetFilter("G/L Account No.", CtasRetencionISR);
                GLE.SetRange("Posting Date", "Posting Date");
                GLE.SetRange("Document Type", GLE."Document Type"::Payment);
                GLE.SetRange("Document No.", "No.");
                if GLE.FindSet() then
                    repeat
                    begin
                        if DivAd then //++ 21-11+2019 jpg mod para divisa adicional
                            ISRRetenido += Abs(GLE."Additional-Currency Amount")
                        else //-- 21-11+2019 jpg mod para divisa adicional
                            ISRRetenido += Abs(GLE.Amount);
                    end
                    until GLE.Next = 0;


                GLE.Reset;
                GLE.SetFilter("G/L Account No.", CtasRetencionITBIS);
                GLE.SetRange("Posting Date", "Posting Date");
                GLE.SetRange("Document Type", GLE."Document Type"::Payment);
                GLE.SetRange("Document No.", "No.");
                if GLE.Find('-') then
                    repeat
                        if DivAd then //jpg para divisa adicional
                            ITBISRetenido += Abs(GLE."Additional-Currency Amount")
                        else
                            ITBISRetenido += Abs(GLE.Amount);
                    until GLE.Next = 0;

                //++ 21-11+2019 jpg mod para divisa adicional
                //si se elige divisa local tenemos que hacer la conversion
                /*IF DivAd THEN
                  BEGIN
                    VLE.RESET;
                    VLE.SETCURRENTKEY("Document No.","Document Type","Vendor No.");
                    VLE.SETRANGE("Document No.","No.");
                    VLE.SETRANGE("Document Type",GLE."Document Type"::Payment);
                    VLE.SETRANGE("Vendor No.","Buy-from Vendor No.");
                    VLE.SETRANGE("Posting Date","Posting Date");
                    VLE.SETRANGE("Bal. Account Type",0);
                    VLE.SETFILTER("Bal. Account No.",CtasRetencionISR);
                    IF VLE.FINDFIRST THEN
                      BEGIN
                        VLE.CALCFIELDS(Amount);
                        ISRRetenido := ABS(VLE.Amount);
                      END;
                  END;
                
                IF DivAd THEN
                  BEGIN
                    VLE.RESET;
                    VLE.SETCURRENTKEY("Document No.","Document Type","Vendor No.");
                    VLE.SETRANGE("Document No.","No.");
                    VLE.SETRANGE("Document Type",GLE."Document Type"::Payment);
                    VLE.SETRANGE("Vendor No.","Buy-from Vendor No.");
                    VLE.SETRANGE("Posting Date","Posting Date");
                    VLE.SETRANGE("Bal. Account Type",0);
                    VLE.SETFILTER("Bal. Account No.",CtasRetencionITBIS);
                    IF VLE.FINDFIRST THEN
                      BEGIN
                        VLE.CALCFIELDS(Amount);
                        ITBISRetenido := ABS(VLE.Amount) ;
                      END;
                  END;*/
                //-- 21-11+2019 jpg mod para divisa adicional

                VE.Reset;
                VE.SetCurrentKey("Document No.", "Posting Date");
                VE.SetRange("Document No.", "No.");
                VE.SetRange("Posting Date", "Posting Date");
                VE.SetRange("Document Type", VE."Document Type"::Invoice);
                if PIH."Prepayment Invoice" then //jpg  13-09-2021 si es de una factura anticipo filtrar positivo
                    VE.SetFilter(Base, '>0');
                if VE.FindSet() then
                    repeat
                        if DivAd then begin
                            if VE.Amount <> 0 then begin
                                ImporteGravado += VE."Additional-Currency Base";
                                ImporteITBIS += VE."Additional-Currency Amount";

                                if VPSetup.Get(VE."VAT Bus. Posting Group", VE."VAT Prod. Posting Group") then begin
                                    if VPSetup."VAT %" = 18 then begin
                                        ImporteITBIS18 += VE."Additional-Currency Amount";
                                        BaseITBIS18 += VE."Additional-Currency Base";
                                    end;

                                    if VPSetup."VAT %" = 16 then begin
                                        ImporteITBIS16 += VE."Additional-Currency Amount";
                                        BaseITBIS16 += VE."Additional-Currency Base";
                                    end;
                                end;

                            end
                            else
                                ImporteExento += VE."Additional-Currency Base";

                            //para capturar factor divisa adicional.
                            if (FactorDivisaAdicional = 0) and ("Purch. Inv. Header"."Currency Code" = '') then
                                FactorDivisaAdicional := VE."Additional-Currency Base" / VE.Base;
                        end
                        else begin
                            if VE.Amount <> 0 then begin
                                ImporteGravado += VE.Base;
                                ImporteITBIS += VE.Amount;

                                if VPSetup.Get(VE."VAT Bus. Posting Group", VE."VAT Prod. Posting Group") then begin
                                    if VPSetup."VAT %" = 18 then begin
                                        ImporteITBIS18 += VE.Amount;
                                        BaseITBIS18 += VE.Base;
                                    end;

                                    if VPSetup."VAT %" = 16 then begin
                                        ImporteITBIS16 += VE.Amount;
                                        BaseITBIS16 += VE.Base;
                                    end;
                                end;

                            end
                            else
                                ImporteExento += VE.Base;

                        end;
                    until VE.Next = 0;
                //jpg 15-11-2019
                //ImporteBase  += ImporteGravado + ImporteExento;
                //ImporteTotal := ImporteGravado + ImporteExento + ImporteITBIS;

                if not Vendor.Get("Buy-from Vendor No.") then
                    Vendor.Init;

                //Se buscan los importes por su clasificacion en lineas del historico
                PIL.Reset;
                PIL.SetRange("Document No.", "No.");
                if PIH."Prepayment Invoice" then //jpg 13-09-2021 si es de una factura anticipo filtrar positivo
                    PIL.SetFilter(Quantity, '>0');
                if PIL.FindSet then
                    repeat
                        if not VPPG.Get(PIL."VAT Prod. Posting Group") then
                            VPPG.Init;
                        if DivAd and ("Currency Code" = '') then begin
                            case VPPG."Tipo de bien-servicio" of
                                0: //Bien
                                    ImporteBien += PIL.Amount * FactorDivisaAdicional;
                                1: //Servicio
                                    ImporteServicios += PIL.Amount * FactorDivisaAdicional;
                                2: //Selectivo
                                    ImporteSelectivo += PIL.Amount * FactorDivisaAdicional;
                                3: //Propina
                                    ImportePropina += PIL.Amount * FactorDivisaAdicional;
                                else //Otro
                                    ImporteOtros += PIL.Amount * FactorDivisaAdicional
                            end;
                        end else begin
                            ///008 conversion factura otra monedas.
                            if "Currency Code" <> '' then
                                FactorDivisa := "Currency Factor"
                            else
                                FactorDivisa := 1;

                            case VPPG."Tipo de bien-servicio" of
                                0: //Bien
                                    ImporteBien += PIL.Amount / FactorDivisa;
                                1: //Servicio
                                    ImporteServicios += PIL.Amount / FactorDivisa;
                                2: //Selectivo
                                    ImporteSelectivo += PIL.Amount / FactorDivisa;
                                3: //Propina
                                    ImportePropina += PIL.Amount / FactorDivisa;
                                else //Otro
                                    ImporteOtros += PIL.Amount / FactorDivisa;
                            end;
                        end;
                    until PIL.Next = 0;

                //jpg 15-11-2019
                ImporteBase += ImporteGravado + ImporteExento - ImporteSelectivo - ImportePropina - ImporteOtros;
                ImporteTotal := ImporteGravado + ImporteExento + ImporteITBIS;

                //Busco tipo de retencion
                Clear(TipoRetISR);
                HRP.Reset;
                HRP.SetRange("No. documento", "No.");
                if HRP.FindSet then
                    repeat
                        CRP.Get(HRP."Código Retención");
                        if CRP."Tipo retencion ISR" <> 0 then
                            TipoRetISR := CRP."Tipo retencion ISR";
                    until HRP.Next = 0;

                //Busco la forma de pago
                if not FormaPago.Get("Payment Method Code") then
                    FormaPago.Init;

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
                ArchITBIS."Razón Social" := DelChr("Buy-from Vendor Name", '=', ',');
                ArchITBIS."Cod. Proveedor" := "Buy-from Vendor No.";
                //ArchITBIS."Razon Social"                    := DELCHR("Pay-to Name",'=',',');
                ArchITBIS."Nombre Comercial" := ArchITBIS."Razón Social";
                ArchITBIS."Tipo retencion ISR" := TipoRetISR;
                ArchITBIS."Monto Bienes" := ImporteBien;
                ArchITBIS."Monto Servicios" := ImporteServicios;
                ArchITBIS."Monto Selectivo" := ImporteSelectivo;
                ArchITBIS."Monto Propina" := ImportePropina;
                ArchITBIS."Monto otros" := ImporteOtros;
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
                //DSLoc1.04 jpg 08-07-2020
                ArchITBIS."Total Documento" := ImporteBien + ImporteServicios;
                //ArchITBIS."Total Documento"                 := ImporteBase;


                //DSLoc1.04 jpg 08-07-2020
                //ArchITBIS."ITBIS Por adelantar"                    := ImporteITBIS - ArchITBIS."ITBIS llevado al costo" ;

                //ArchITBIS."ITBIS Pagado"                    := ImporteITBIS;

                //DSLoc1.04
                /*IF rGeneralLedgerSetup."ITBIS al costo activo" THEN
                ArchITBIS."ITBIS llevado al costo"                    := ImporteITBIS
                ELSE  */
                ArchITBIS."ITBIS Pagado" := ImporteITBIS;

                //ITBIS al costo ++
                ArchITBIS."ITBIS Por adelantar" := ImporteITBIS;

                if "Tipo ITBIS" = "Tipo ITBIS"::"ITBIS sujeto a prop." then begin
                    ArchITBIS."ITBIS llevado al costo" := 0;
                    ArchITBIS."ITBIS Por adelantar" := 0;
                    ArchITBIS."ITBIS sujeto a proporc." := ImporteITBIS;
                end
                else
                    if ("Tipo ITBIS" = "Tipo ITBIS"::"ITBIS al costo") then begin
                        ArchITBIS."ITBIS Por adelantar" := 0;
                        ArchITBIS."ITBIS sujeto a proporc." := 0;
                        ArchITBIS."ITBIS llevado al costo" := ImporteITBIS;
                    end;

                //ITBIS al costo --

                ArchITBIS."ITBIS Retenido" := ITBISRetenido;
                ArchITBIS."ISR Retenido" := ISRRetenido;
                ArchITBIS."Forma de pago DGII" := FormaPago."Forma de pago DGII";

                //Proporcionalidad
                ArchITBIS.Proporcionalidad := Proporcionalidad;

                //DSLoc1.04
                if ArchITBIS.RNC <> '' then begin
                    ArchITBIS."RNC/Cedula" := ArchITBIS.RNC;
                    ArchITBIS."Tipo Identificacion" := 1;
                end
                else begin
                    ArchITBIS."RNC/Cedula" := ArchITBIS.Cédula;
                    if ArchITBIS."RNC/Cedula" <> '' then
                        ArchITBIS."Tipo Identificacion" := 2;
                end;



                //jpg 1-03-2021 para colocar fecha de pago si es a credito y fecha de vencimiento esta dentro del mes de facturacion ++
                if ArchITBIS."Forma de pago DGII" = ArchITBIS."Forma de pago DGII"::"4 - Compra a credito" then begin
                    if ("Due Date" <= CalcDate('<CM>', "Posting Date")) then begin
                        ArchITBIS."Dia Pago" := Format("Due Date", 0, '<day,2>');
                        ArchITBIS."Fecha Pago" := Format("Due Date", 0, '<year4>') + Format("Due Date", 0, '<Month,2>') +
                                                            Format("Due Date", 0, '<day,2>');
                    end;

                    if (ITBISRetenido <> 0) or (ISRRetenido <> 0) then begin
                        ArchITBIS."Dia Pago" := Format(GetRangeMax("Posting Date"), 0, '<day,2>');
                        ArchITBIS."Fecha Pago" := Format(GetRangeMax("Posting Date"), 0, '<year4>') + Format(GetRangeMax("Posting Date"), 0, '<Month,2>') +
                                                            Format(GetRangeMax("Posting Date"), 0, '<day,2>');
                    end;

                end else  // si no es acredito siempre colocar la fecha
                  begin
                    ArchITBIS."Dia Pago" := Format("Posting Date", 0, '<day,2>');
                    ArchITBIS."Fecha Pago" := Format("Posting Date", 0, '<year4>') + Format("Posting Date", 0, '<Month,2>') +
                                                            Format("Posting Date", 0, '<day,2>');
                end;
                //jpg 1-03-2021 para colocar fecha de pago si es a credito y fecha de vencimiento esta dentro del mes de facturacion --


                /*
                //jpg si no encontro fecha de pago
                IF  ArchITBIS."Fecha Pago" = '' THEN BEGIN
                
                //Para calcular el dia de pago
                VLE.RESET;
                VLE.SETRANGE(VLE."Vendor No.","Purch. Inv. Header"."Buy-from Vendor No.");
                VLE.SETRANGE(VLE."Posting Date","Posting Date");
                VLE.SETRANGE(VLE."Document Type",VLE."Document Type"::Invoice);
                VLE.SETRANGE("Document No.","No.");
                VLE.SETFILTER("Closed at Date",'<>%1',0D);
                IF VLE.FINDFIRST THEN BEGIN
                  ArchITBIS."Dia Pago" := FORMAT(VLE."Closed at Date",0,'<day,2>');
                  //jpg 15-11-2019
                    ArchITBIS."Fecha Pago" :=  FORMAT(VLE."Closed at Date",0,'<year4>') + FORMAT(VLE."Closed at Date",0,'<Month,2>') +
                                                            FORMAT(VLE."Closed at Date",0,'<day,2>');
                  END
                ELSE
                  BEGIN
                    VLE.RESET;
                    VLE.SETRANGE(VLE."Vendor No.","Purch. Inv. Header"."Buy-from Vendor No.");
                    VLE.SETRANGE(VLE."Posting Date","Posting Date");
                    VLE.SETRANGE(VLE."Document Type",VLE."Document Type"::Invoice);
                    VLE.SETRANGE("Document No.","No.");
                    IF VLE.FINDFIRST THEN
                      BEGIN
                        VLE1.RESET;
                        VLE1.SETRANGE("Vendor No.","Buy-from Vendor No.");
                        VLE1.SETRANGE("Document Type",VLE1."Document Type"::Payment);
                        VLE1.SETRANGE("Closed by Entry No.",VLE."Entry No.");
                        IF VLE1.FINDFIRST THEN BEGIN
                          ArchITBIS."Dia Pago" := FORMAT(VLE."Posting Date",0,'<day,2>');
                  //jpg 15-11-2019
                          ArchITBIS."Fecha Pago" :=  FORMAT(VLE."Posting Date",0,'<year4>') + FORMAT(VLE."Posting Date",0,'<Month,2>') +
                                                               FORMAT(VLE."Posting Date",0,'<day,2>');
                        END
                      END
                  END;
                
                END;
                */

                ArchITBIS.NCF := "No. Comprobante Fiscal";
                ArchITBIS."Clasific. Gastos y Costos NCF" := "Cod. Clasificacion Gasto";
                case "Cod. Clasificacion Gasto" of
                    '01':
                        ArchITBIS."Tipo Bienes y Serv. comprados" := 1; //'01-GASTOS DE PERSONAL'
                    '02':
                        ArchITBIS."Tipo Bienes y Serv. comprados" := 2; //'02-GASTOS POR TRABAJOS, SUMINISTROS Y SERVICIOS'
                    '03':
                        ArchITBIS."Tipo Bienes y Serv. comprados" := 3; //'03-ARRENDAMIENTOS'
                    '04':
                        ArchITBIS."Tipo Bienes y Serv. comprados" := 4; //'04-GASTOS DE ACTIVOS FIJO'
                    '05':
                        ArchITBIS."Tipo Bienes y Serv. comprados" := 5; //'05 -GASTOS DE REPRESENTACION'
                    '06':
                        ArchITBIS."Tipo Bienes y Serv. comprados" := 6; //'06 -OTRAS DEDUCCIONES ADMITIDAS'
                    '07':
                        ArchITBIS."Tipo Bienes y Serv. comprados" := 7; //'07 -GASTOS FINANCIEROS'
                    '08':
                        ArchITBIS."Tipo Bienes y Serv. comprados" := 8; //'08 -GASTOS EXTRAORDINARIOS'
                    '09':
                        ArchITBIS."Tipo Bienes y Serv. comprados" := 9; //'09 -COMPRAS Y GASTOS QUE FORMARAN PARTE DEL COSTO DE VENTA'
                    '10':
                        ArchITBIS."Tipo Bienes y Serv. comprados" := 10; //'10 -ADQUISICIONES DE ACTIVOS'
                    '11':
                        ArchITBIS."Tipo Bienes y Serv. comprados" := 11; //'11- GASTOS DE SEGUROS'
                end;
                ArchITBIS."Tipo documento" := 1; //Factura

                NumeroLinea += 1;
                ArchITBIS."Line No." := NumeroLinea;

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
                //FechaIni          := GETRANGEMIN("Posting Date");
                //FechaFin          := GETRANGEMAX("Posting Date");

                //"G/L Entry".SETRANGE("Posting Date", FechaIni,FechaFin);

                FiltrosPIH := "Purch. Inv. Header".GetFilters;
                FiltrosCMH := "Purch. Cr. Memo Hdr.".GetFilters;
                FiltrosGLE := "G/L Entry".GetFilters;

                if "G/L Entry".GetFilter("G/L Account No.") = '' then
                    Error(Error002, "G/L Entry".FieldCaption("G/L Entry"."G/L Account No."), txt002);
            end;
        }
        dataitem("Purch. Cr. Memo Hdr."; "Purch. Cr. Memo Hdr.")
        {
            DataItemTableView = SORTING("No.") ORDER(Ascending);
            RequestFilterFields = "No.", "Pay-to Vendor No.", "Posting Date";
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
                if (CopyStr("No. Comprobante Fiscal", 1, 10) = 'CORRECCION') or (CopyStr("No. Comprobante Fiscal", 1, 10) = 'CORRECTION') or (CopyStr("No. Comprobante Fiscal", 1, 6) = 'CORREC') then
                    CurrReport.Skip;

                if "Applies-to Doc. No." <> '' then begin
                    if PIH.Get("Applies-to Doc. No.") then
                        if (CopyStr(PIH."No. Comprobante Fiscal", 1, 10) = 'CORRECCION') or
                           (CopyStr(PIH."No. Comprobante Fiscal", 1, 10) = 'CORRECTION') or
                           (CopyStr(PIH."No. Comprobante Fiscal", 1, 6) = 'CORREC') then
                            CurrReport.Skip;
                end;

                //para excluir las que tiene corregida por "Applies-to Doc. No.".
                PIH.Reset;
                PIH.SetRange("Applies-to Doc. No.", "No.");
                PIH.SetRange(Correction, true);
                PIH.SetRange("Buy-from Vendor No.", "Buy-from Vendor No.");
                if PIH.FindFirst then begin  // verificar si no hay una nc correctiva anulando la fc
                    PCMH.Reset;
                    PCMH.SetRange("Applies-to Doc. No.", PIH."No.");
                    PCMH.SetRange(Correction, true);
                    PCMH.SetRange("Buy-from Vendor No.", PIH."Buy-from Vendor No.");
                    if not PCMH.FindFirst then
                        CurrReport.Skip;
                end;


                if "Purch. Cr. Memo Hdr.".Correction then
                    CurrReport.Skip;

                //jpg no facturas en 0 para evitar errores
                CalcFields(Amount);
                if (Amount = 0) then
                    CurrReport.Skip;

                if "No. Comprobante Fiscal" = '' then
                    CurrReport.Skip;

                NCFLiq.DeleteAll;

                ImporteGravadoNCr := 0;
                ImporteExentoNCr := 0;
                ImporteSelectivoNCr := 0;
                ImporteBienNCr := 0;
                ImporteServiciosNCr := 0;
                ImportePropinaNCr := 0;
                ImporteOtrosNCr := 0;
                ITBISRetenidoNCR := 0;
                ISRRetenidoNCR := 0;
                FactorDivisaAdicional := 0;
                FactorDivisa := 0;
                Clear(txtCostosGastos);

                ImporteBaseNCr := 0;
                ImporteTotalNCr := 0;
                ImporteITBISNCr := 0;

                ImporteITBIS16NCr := 0;
                ImporteITBIS18NCr := 0;
                BaseITBIS16NCr := 0;
                BaseITBIS18NCr := 0;

                //ISR Retenido
                GLE.Reset;
                GLE.SetFilter("G/L Account No.", CtasRetencionISR);
                GLE.SetRange("Posting Date", "Posting Date");
                GLE.SetRange("Document Type", GLE."Document Type"::Payment);
                GLE.SetRange("Document No.", "No.");
                if GLE.FindSet() then
                    repeat
                    begin
                        if DivAd then //++ 21-11+2019 jpg mod para divisa adicional
                            ISRRetenidoNCR += Abs(GLE."Additional-Currency Amount")
                        else //-- 21-11+2019 jpg mod para divisa adicional
                            ISRRetenidoNCR += Abs(GLE.Amount);
                    end
                    until GLE.Next = 0;


                GLE.Reset;
                GLE.SetFilter("G/L Account No.", CtasRetencionITBIS);
                GLE.SetRange("Posting Date", "Posting Date");
                GLE.SetRange("Document Type", GLE."Document Type"::Payment);
                GLE.SetRange("Document No.", "No.");
                if GLE.Find('-') then
                    repeat
                        if DivAd then //jpg para divisa adicional
                            ITBISRetenidoNCR += Abs(GLE."Additional-Currency Amount")
                        else
                            ITBISRetenidoNCR += Abs(GLE.Amount);
                    until GLE.Next = 0;

                //++ 21-11+2019 jpg mod para divisa adicional
                //si se elige divisa local tenemos que hacer la conversion
                /*IF DivAd THEN
                  BEGIN
                    VLE.RESET;
                    VLE.SETCURRENTKEY("Document No.","Document Type","Vendor No.");
                    VLE.SETRANGE("Document No.","No.");
                    VLE.SETRANGE("Document Type",GLE."Document Type"::Payment);
                    VLE.SETRANGE("Vendor No.","Buy-from Vendor No.");
                    VLE.SETRANGE("Posting Date","Posting Date");
                    VLE.SETRANGE("Bal. Account Type",0);
                    VLE.SETFILTER("Bal. Account No.",CtasRetencionISR);
                    IF VLE.FINDFIRST THEN
                      BEGIN
                        VLE.CALCFIELDS(Amount);
                        ISRRetenido := ABS(VLE.Amount);
                      END;
                  END;
                
                IF DivAd THEN
                  BEGIN
                    VLE.RESET;
                    VLE.SETCURRENTKEY("Document No.","Document Type","Vendor No.");
                    VLE.SETRANGE("Document No.","No.");
                    VLE.SETRANGE("Document Type",GLE."Document Type"::Payment);
                    VLE.SETRANGE("Vendor No.","Buy-from Vendor No.");
                    VLE.SETRANGE("Posting Date","Posting Date");
                    VLE.SETRANGE("Bal. Account Type",0);
                    VLE.SETFILTER("Bal. Account No.",CtasRetencionITBIS);
                    IF VLE.FINDFIRST THEN
                      BEGIN
                        VLE.CALCFIELDS(Amount);
                        ITBISRetenido := ABS(VLE.Amount) ;
                      END;
                  END;*/
                //-- 21-11+2019 jpg mod para divisa adicional

                VE.Reset;
                VE.SetCurrentKey("Document No.", "Posting Date");
                VE.SetRange("Document No.", "No.");
                VE.SetRange("Posting Date", "Posting Date");
                VE.SetRange("Document Type", VE."Document Type"::"Credit Memo");
                if VE.FindSet then
                    repeat
                        if DivAd then begin
                            if VE.Amount <> 0 then begin
                                ImporteGravadoNCr += VE."Additional-Currency Base" * -1;
                                ImporteITBISNCr += VE."Additional-Currency Amount" * -1;

                                if VPSetup.Get(VE."VAT Bus. Posting Group", VE."VAT Prod. Posting Group") then begin
                                    if VPSetup."VAT %" = 18 then begin
                                        ImporteITBIS18NCr += VE."Additional-Currency Amount" * -1;
                                        BaseITBIS18NCr += VE."Additional-Currency Base" * -1;
                                    end;

                                    if VPSetup."VAT %" = 16 then begin
                                        ImporteITBIS16NCr += VE."Additional-Currency Amount" * -1;
                                        BaseITBIS16NCr += VE."Additional-Currency Base" * -1;
                                    end;
                                end;

                            end
                            else
                                ImporteExentoNCr += VE."Additional-Currency Base" * -1;

                            //para capturar factor divisa adicional.
                            if (FactorDivisaAdicional = 0) and ("Purch. Cr. Memo Hdr."."Currency Code" = '') then
                                FactorDivisaAdicional := Abs((VE."Additional-Currency Base" / VE.Base) * -1);

                        end
                        else begin
                            if VE.Amount <> 0 then begin
                                ImporteGravadoNCr += VE.Base * -1;
                                ImporteITBISNCr += VE.Amount * -1;

                                if VPSetup.Get(VE."VAT Bus. Posting Group", VE."VAT Prod. Posting Group") then begin
                                    if VPSetup."VAT %" = 18 then begin
                                        ImporteITBIS18NCr += VE.Amount * -1;
                                        BaseITBIS18NCr += VE.Base * -1;
                                    end;

                                    if VPSetup."VAT %" = 16 then begin
                                        ImporteITBIS16NCr += VE.Amount * -1;
                                        BaseITBIS16NCr += VE.Base * -1;
                                    end;
                                end;

                            end
                            else
                                ImporteExentoNCr += VE.Base * -1;

                        end;
                    until VE.Next = 0;



                //jpg 15-11-2019
                //ImporteTotalNCr   := ImporteGravadoNCr + ImporteExentoNCr + ImporteITBISNCr;
                //ImporteBaseNCr    := ImporteGravadoNCr + ImporteExentoNCr;

                if not Vendor.Get("Buy-from Vendor No.") then
                    Vendor.Init;

                //Se buscan los importes por su clasificacion en lineas del historico
                PCmL.Reset;
                PCmL.SetRange("Document No.", "No.");
                if PCmL.FindSet then
                    repeat
                        if not VPPG.Get(PCmL."VAT Prod. Posting Group") then
                            VPPG.Init;
                        if DivAd and ("Currency Code" = '') then begin
                            case VPPG."Tipo de bien-servicio" of
                                0: //Bien
                                    ImporteBienNCr += Abs(PCmL.Amount * FactorDivisaAdicional);
                                1: //Servicio
                                    ImporteServiciosNCr += Abs(PCmL.Amount * FactorDivisaAdicional);
                                2: //Selectivo
                                    ImporteSelectivoNCr += Abs(PCmL.Amount * FactorDivisaAdicional);
                                3: //Propina
                                    ImportePropinaNCr += Abs(PCmL.Amount * FactorDivisaAdicional);
                                else //Otro
                                    ImporteOtrosNCr += Abs(PCmL.Amount * FactorDivisaAdicional)
                            end;
                        end else begin
                            ///008 conversion factura otra monedas.
                            if "Currency Code" <> '' then
                                FactorDivisa := "Currency Factor"
                            else
                                FactorDivisa := 1;

                            case VPPG."Tipo de bien-servicio" of
                                0: //Bien
                                    ImporteBienNCr += Abs(PCmL.Amount) / FactorDivisa;
                                1: //Servicio
                                    ImporteServiciosNCr += Abs(PCmL.Amount) / FactorDivisa;
                                2: //Selectivo
                                    ImporteSelectivoNCr += Abs(PCmL.Amount) / FactorDivisa;
                                3: //Propina
                                    ImportePropinaNCr += Abs(PCmL.Amount) / FactorDivisa;
                                else //Otro
                                    ImporteOtrosNCr += Abs(PCmL.Amount) / FactorDivisa;
                            end;
                        end;
                    until PCmL.Next = 0;

                //jpg 15-11-2019
                ImporteBaseNCr := ImporteGravadoNCr + ImporteExentoNCr - ImporteSelectivoNCr - ImportePropinaNCr - ImporteOtrosNCr;
                ImporteTotalNCr := ImporteGravadoNCr + ImporteExentoNCr + ImporteITBISNCr;

                //Busco tipo de retencion
                Clear(TipoRetISR);
                HRP.Reset;
                HRP.SetRange("No. documento", "No.");
                if HRP.FindSet then
                    repeat
                        CRP.Get(HRP."Código Retención");
                        if CRP."Tipo retencion ISR" <> 0 then
                            TipoRetISR := CRP."Tipo retencion ISR";
                    until HRP.Next = 0;

                //Busco la forma de pago
                if not FormaPago.Get("Payment Method Code") then
                    FormaPago.Init;

                GpoContProv.Get("Vendor Posting Group");
                Clear(ArchITBIS);
                CalcFields("Amount Including VAT", Amount);
                ArchITBIS."Número Documento" := "No.";
                ArchITBIS.Dia := Format("Posting Date", 0, '<day,2>');
                ArchITBIS."Fecha Documento" := Format("Posting Date", 0, '<year4>') + Format("Posting Date", 0, '<Month,2>') +
                                                               Format("Posting Date", 0, '<day,2>');
                ArchITBIS.Apellidos := '';
                ArchITBIS.Nombres := '';
                //ArchITBIS."Razon Social"                    := DELCHR("Pay-to Name",'=',',');
                ArchITBIS."Cod. Proveedor" := "Buy-from Vendor No.";
                ArchITBIS."Razón Social" := DelChr("Buy-from Vendor Name", '=', ',');
                ArchITBIS."Nombre Comercial" := ArchITBIS."Razón Social";
                ArchITBIS."Tipo retencion ISR" := TipoRetISR;
                ArchITBIS."Monto Bienes" := ImporteBienNCr;
                ArchITBIS."Monto Servicios" := ImporteServiciosNCr;
                ArchITBIS."Monto Selectivo" := ImporteSelectivoNCr;
                ArchITBIS."Monto Propina" := ImportePropinaNCr;
                ArchITBIS."Monto otros" := ImporteOtrosNCr;
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

                //Proporcionalidad
                ArchITBIS.Proporcionalidad := Proporcionalidad;

                //DSLoc1.04
                if ArchITBIS.RNC <> '' then begin
                    ArchITBIS."RNC/Cedula" := ArchITBIS.RNC;
                    ArchITBIS."Tipo Identificacion" := 1;
                end
                else begin
                    ArchITBIS."RNC/Cedula" := ArchITBIS.Cédula;
                    if ArchITBIS."RNC/Cedula" <> '' then
                        ArchITBIS."Tipo Identificacion" := 2;
                end;

                //DSLoc1.04 jpg 08-07-2020
                ArchITBIS."Total Documento" := ImporteBienNCr + ImporteServiciosNCr;
                //ArchITBIS."Total Documento"                 := ImporteBase;


                //DSLoc1.04
                //IF rGeneralLedgerSetup."ITBIS al costo activo" THEN
                //ArchITBIS."ITBIS llevado al costo"                    := ImporteITBISNCr ;

                //DSLoc1.04 jpg 08-07-2020
                //ArchITBIS."ITBIS Por adelantar"                    := ImporteITBISNCr - ArchITBIS."ITBIS llevado al costo" ;

                //ArchITBIS."ITBIS Pagado"                    := ImporteITBISNCr;


                //DSLoc1.04
                /*IF rGeneralLedgerSetup."ITBIS al costo activo" THEN
                ArchITBIS."ITBIS llevado al costo"                    := ImporteITBIS
                ELSE  */
                ArchITBIS."ITBIS Pagado" := ImporteITBISNCr;

                //ITBIS al costo ++
                ArchITBIS."ITBIS Por adelantar" := ImporteITBISNCr;

                if "Tipo ITBIS" = "Tipo ITBIS"::"ITBIS sujeto a prop." then begin
                    ArchITBIS."ITBIS llevado al costo" := 0;
                    ArchITBIS."ITBIS Por adelantar" := 0;
                    ArchITBIS."ITBIS sujeto a proporc." := ImporteITBISNCr;
                end
                else
                    if ("Tipo ITBIS" = "Tipo ITBIS"::"ITBIS al costo") then begin
                        ArchITBIS."ITBIS Por adelantar" := 0;
                        ArchITBIS."ITBIS sujeto a proporc." := 0;
                        ArchITBIS."ITBIS llevado al costo" := ImporteITBISNCr;
                    end;

                //ITBIS al costo --

                //IF ITBISRetenidoNCR <> 0 THEN
                //ArchITBIS."Fecha Pago"                      := ArchITBIS."Fecha Documento";

                // jpg 15-03-2021 colocar siempre fecha de pago para nc ++

                ArchITBIS."Dia Pago" := Format("Posting Date", 0, '<day,2>');
                ArchITBIS."Fecha Pago" := Format("Posting Date", 0, '<year4>') + Format("Posting Date", 0, '<Month,2>') +
                                                        Format("Posting Date", 0, '<day,2>');
                // jpg 15-03-2021 colocar siempre fecha de pago para nc --

                ArchITBIS."ITBIS Retenido" := ITBISRetenidoNCR;
                ArchITBIS."ISR Retenido" := ISRRetenidoNCR;
                ArchITBIS."Forma de pago DGII" := FormaPago."Forma de pago DGII";
                ArchITBIS.NCF := "No. Comprobante Fiscal";
                //jpg comentado -- 12-05-2020
                //002 de los NCF relacionados buscamos el del importe mayor
                //Buscamos el mov. proveedor perteneciente al abono.
                /*NCFLiq.RESET;
                IF NCFLiq.FINDSET THEN
                  NCFLiq.DELETEALL;
                
                VLE.RESET;
                VLE.SETCURRENTKEY("Document No.","Document Type","Vendor No.");
                VLE.SETRANGE("Vendor No.","Buy-from Vendor No.");
                VLE.SETRANGE("Posting Date","Posting Date");
                VLE.SETRANGE("Document Type",VLE."Document Type"::"Credit Memo");
                VLE.SETRANGE("Document No.","No.");
                IF VLE.FINDFIRST THEN
                  BEGIN
                    //Buscamos los movimientos que la cerraron
                    IF VLE."Closed by Entry No." <> 0 THEN
                      BEGIN
                        IF VLECopy.GET(VLE."Closed by Entry No.") THEN
                          BEGIN
                            //Buscamos el historico de factura para capturar el NCF
                            PIH.RESET;
                            PIH.SETRANGE("No.",VLECopy."Document No.");
                            IF PIH.FINDFIRST THEN
                              BEGIN
                                NCFLiq.NCF := PIH."No. Comprobante Fiscal";
                                IF NOT NCFLiq.INSERT THEN
                                  NCFLiq.MODIFY;
                              END;
                          END;
                      END;
                
                    //Buscamos movimientos cerrados por ella
                    VLECopy.RESET;
                    VLECopy.SETCURRENTKEY("Closed by Entry No.");
                    VLECopy.SETRANGE("Closed by Entry No.",VLE."Entry No.");
                    IF VLECopy.FINDSET(FALSE,FALSE) THEN
                      REPEAT
                        //Buscamos el historico de factura para capturar el NCF
                        PIH.RESET;
                        PIH.SETRANGE("No.",VLECopy."Document No.");
                        IF PIH.FINDFIRST THEN
                          BEGIN
                            NCFLiq.NCF := PIH."No. Comprobante Fiscal";
                            IF NOT NCFLiq.INSERT THEN
                              NCFLiq.MODIFY;
                          END;
                      UNTIL VLECopy.NEXT = 0;
                  END;
                
                NCFLiq.SETCURRENTKEY(NCFLiq.Importe);
                IF NCFLiq.FINDLAST THEN
                  ArchITBIS."NCF Relacionado"         := NCFLiq.NCF;*/
                ArchITBIS."NCF Relacionado" := "No. Comprobante Fiscal Rel."; //jpg-- 12-05-2020

                //ArchITBIS."Clasific. Gastos y Costos NCF" := txtCostosGastos;
                ArchITBIS."Clasific. Gastos y Costos NCF" := "Cod. Clasificacion Gasto";
                case "Cod. Clasificacion Gasto" of
                    '01':
                        ArchITBIS."Tipo Bienes y Serv. comprados" := 1; //'01-GASTOS DE PERSONAL'
                    '02':
                        ArchITBIS."Tipo Bienes y Serv. comprados" := 2; //'02-GASTOS POR TRABAJOS, SUMINISTROS Y SERVICIOS'
                    '03':
                        ArchITBIS."Tipo Bienes y Serv. comprados" := 3; //'03-ARRENDAMIENTOS'
                    '04':
                        ArchITBIS."Tipo Bienes y Serv. comprados" := 4; //'04-GASTOS DE ACTIVOS FIJO'
                    '05':
                        ArchITBIS."Tipo Bienes y Serv. comprados" := 5; //'05 -GASTOS DE REPRESENTACION'
                    '06':
                        ArchITBIS."Tipo Bienes y Serv. comprados" := 6; //'06 -OTRAS DEDUCCIONES ADMITIDAS'
                    '07':
                        ArchITBIS."Tipo Bienes y Serv. comprados" := 7; //'07 -GASTOS FINANCIEROS'
                    '08':
                        ArchITBIS."Tipo Bienes y Serv. comprados" := 8; //'08 -GASTOS EXTRAORDINARIOS'
                    '09':
                        ArchITBIS."Tipo Bienes y Serv. comprados" := 9; //'09 -COMPRAS Y GASTOS QUE FORMARAN PARTE DEL COSTO DE VENTA'
                    '10':
                        ArchITBIS."Tipo Bienes y Serv. comprados" := 10; //'10 -ADQUISICIONES DE ACTIVOS'
                    '11':
                        ArchITBIS."Tipo Bienes y Serv. comprados" := 11; //'11- GASTOS DE SEGUROS'
                end;
                ArchITBIS."Tipo documento" := 2; //Nota de credito
                ArchITBIS."Codigo reporte" := '606';

                NumeroLinea += 1;
                ArchITBIS."Line No." := NumeroLinea;

                if not ArchITBIS.Insert then
                    Error(Error001);

            end;

            trigger OnPreDataItem()
            begin
                //CurrReport.PageNo := 1;
                /*
                SETFILTER("Vendor Posting Group", FiltroGpoContProv);
                SETRANGE("Posting Date", FechaIni,FechaFin);
                IF "Purch. Inv. Header".GETFILTER("Shortcut Dimension 1 Code") <> '' THEN
                   SETFILTER("Shortcut Dimension 1 Code","Purch. Inv. Header".GETFILTER("Shortcut Dimension 1 Code"));
                IF "Purch. Inv. Header".GETFILTER("Shortcut Dimension 2 Code") <> '' THEN
                   SETFILTER("Shortcut Dimension 2 Code","Purch. Inv. Header".GETFILTER("Shortcut Dimension 2 Code"));
                   */
                //CurrReport.CreateTotals(ImporteBaseNCr, ImporteTotalNCr, ImporteITBISNCr, ImporteExentoNCr, ImporteGravadoNCr);

            end;
        }
        dataitem("G/L Entry"; "G/L Entry")
        {
            DataItemTableView = SORTING("Document No.", "Posting Date") ORDER(Ascending);
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

                //jpg no facturas en 0 para evitar errores
                if (Amount = 0) then
                    CurrReport.Skip;

                if "No. Comprobante Fiscal" = '' then
                    CurrReport.Skip;


                ImporteBase := 0;
                ImporteTotal := 0;
                ImporteITBIS := 0;
                ISRRetenido := 0;
                ImporteGravado := 0;
                ImporteExento := 0;
                ImporteSelectivo := 0;
                ImporteBien := 0;
                ImporteServicios := 0;
                ImportePropina := 0;
                ImporteOtros := 0;
                ITBISRetenido := 0;
                ISRRetenido := 0;
                OtrasRetenciones := 0;
                FactorDivisaAdicional := 0;
                FactorDivisa := 0;

                ImporteITBIS16 := 0;
                ImporteITBIS18 := 0;
                BaseITBIS16 := 0;
                BaseITBIS18 := 0;


                Clear(ArchITBIS);
                ArchITBIS."Número Documento" := "Document No.";
                ArchITBIS.Dia := Format("Posting Date", 0, '<day,2>');
                ArchITBIS."Fecha Documento" := Format("Posting Date", 0, '<year4>') + Format("Posting Date", 0, '<Month,2>') +
                                                    Format("Posting Date", 0, '<day,2>');
                ArchITBIS.Apellidos := '';
                ArchITBIS.Nombres := '';
                ArchITBIS."Razón Social" := '';
                ArchITBIS."Nombre Comercial" := '';

                //jpg 14-08-2020 buscar datos del proveedor si no se enuentra saltar mov ++
                ArchITBIS."Forma de pago DGII" := FormaPago."Forma de pago DGII"::"2 - Cheques/Transferencias/Depositos";
                ArchITBIS."Monto Servicios" := Abs(Amount);
                ArchITBIS."Fecha Pago" := ArchITBIS."Fecha Documento";
                ArchITBIS."Dia Pago" := Format("Posting Date", 0, '<day,2>');

                Vendor.Reset;
                Vendor.SetRange("VAT Registration No.", RNC);
                if Vendor.FindFirst then begin
                    ArchITBIS.Nombres := DelChr(Vendor.Name, '=', ',');

                    ArchITBIS."Cod. Proveedor" := Vendor."No.";
                    ArchITBIS."Razón Social" := DelChr(Vendor.Name, '=', ',');
                    ArchITBIS."Nombre Comercial" := ArchITBIS."Razón Social";
                end;
                //RNCTxt                              := DELCHR(Vendor."VAT Registration No.",'=','- ');
                //jpg buscar datos del proveedor si no se enuentra saltar mov --

                /*
                IF RNCTxt = '' THEN
                    RNCTxt                              := DELCHR(InfoEmpresa."VAT Registration No.",'=','- ')
                ELSE
                  RNCTxt                              := DELCHR(RNC,'=','- ');
                */
                //AMS -  11-Sept-2020
                if RNCTxt = '' then
                    RNCTxt := DelChr(RNC, '=', '- ')
                else
                    RNCTxt := DelChr(RNC, '=', '- ');


                if StrLen(RNCTxt) < 10 then
                    ArchITBIS.RNC := RNCTxt
                else
                    ArchITBIS.Cédula := CopyStr(RNCTxt, 1, 11);



                ArchITBIS."Total Documento" := Amount;
                ArchITBIS."ITBIS Pagado" := 0;
                ArchITBIS."ITBIS llevado al costo" := 0;
                ArchITBIS.NCF := "No. Comprobante Fiscal";
                ArchITBIS."NCF Relacionado" := '';
                ArchITBIS."Clasific. Gastos y Costos NCF" := "Cod. Clasificacion Gasto";
                case "Cod. Clasificacion Gasto" of
                    '01':
                        ArchITBIS."Tipo Bienes y Serv. comprados" := 1; //'01-GASTOS DE PERSONAL'
                    '02':
                        ArchITBIS."Tipo Bienes y Serv. comprados" := 2; //'02-GASTOS POR TRABAJOS, SUMINISTROS Y SERVICIOS'
                    '03':
                        ArchITBIS."Tipo Bienes y Serv. comprados" := 3; //'03-ARRENDAMIENTOS'
                    '04':
                        ArchITBIS."Tipo Bienes y Serv. comprados" := 4; //'04-GASTOS DE ACTIVOS FIJO'
                    '05':
                        ArchITBIS."Tipo Bienes y Serv. comprados" := 5; //'05 -GASTOS DE REPRESENTACION'
                    '06':
                        ArchITBIS."Tipo Bienes y Serv. comprados" := 6; //'06 -OTRAS DEDUCCIONES ADMITIDAS'
                    '07':
                        ArchITBIS."Tipo Bienes y Serv. comprados" := 7; //'07 -GASTOS FINANCIEROS'
                    '08':
                        ArchITBIS."Tipo Bienes y Serv. comprados" := 8; //'08 -GASTOS EXTRAORDINARIOS'
                    '09':
                        ArchITBIS."Tipo Bienes y Serv. comprados" := 9; //'09 -COMPRAS Y GASTOS QUE FORMARAN PARTE DEL COSTO DE VENTA'
                    '10':
                        ArchITBIS."Tipo Bienes y Serv. comprados" := 10; //'10 -ADQUISICIONES DE ACTIVOS'
                    '11':
                        ArchITBIS."Tipo Bienes y Serv. comprados" := 11; //'11- GASTOS DE SEGUROS'
                end;
                ArchITBIS."Codigo reporte" := '606';


                //DSLoc1.04
                if ArchITBIS.RNC <> '' then begin
                    ArchITBIS."RNC/Cedula" := ArchITBIS.RNC;
                    ArchITBIS."Tipo Identificacion" := 1;
                end
                else begin
                    ArchITBIS."RNC/Cedula" := ArchITBIS.Cédula;
                    if ArchITBIS."RNC/Cedula" <> '' then
                        ArchITBIS."Tipo Identificacion" := 2;
                end;


                ArchITBIS."No. Mov." := "Entry No.";

                NumeroLinea += 1;
                ArchITBIS."Line No." := NumeroLinea;

                ArchITBIS.Insert;

            end;

            trigger OnPreDataItem()
            begin
                //SETRANGE("Posting Date", FechaIni,FechaFin);
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

        NumeroLinea += 1;

        /*
        IF "G/L Entry".GETFILTER("Posting Date") = '' THEN
          ERROR(Error002,"G/L Entry".FIELDCAPTION("Posting Date"),txt002);
        */
        rGeneralLedgerSetup.Get;

    end;

    var
        InfoEmpresa: Record "Company Information";
        GLE: Record "G/L Entry";
        VLE: Record "Vendor Ledger Entry";
        VPSetup: Record "VAT Posting Setup";
        VLE1: Record "Vendor Ledger Entry";
        VE: Record "VAT Entry";
        Vendor: Record Vendor;
        PIH: Record "Purch. Inv. Header";
        PIL: Record "Purch. Inv. Line";
        PCmL: Record "Purch. Cr. Memo Line";
        VPPG: Record "VAT Product Posting Group";
        ArchITBIS: Record "Archivo Transferencia ITBIS";
        GpoContProv: Record "Vendor Posting Group";
        NCFLiq: Record "NCF liquidados" temporary;
        VLECopy: Record "Vendor Ledger Entry";
        FormaPago: Record "Payment Method";
        CRP: Record "Config. Retencion Proveedores";
        HRP: Record "Historico Retencion Prov.";
        DirEmpresa: array[7] of Text[250];
        ImporteBase: Decimal;
        ImporteITBIS: Decimal;
        ImporteGravado: Decimal;
        ImporteExento: Decimal;
        ImporteTotal: Decimal;
        ImporteSelectivo: Decimal;
        ImportePropina: Decimal;
        ImporteBien: Decimal;
        ImporteServicios: Decimal;
        ImporteOtros: Decimal;
        FiltroGpoContProv: Text[150];
        FechaIni: Date;
        FechaFin: Date;
        ImporteBaseNCr: Decimal;
        ImporteITBISNCr: Decimal;
        ImporteGravadoNCr: Decimal;
        ImporteExentoNCr: Decimal;
        ImporteTotalNCr: Decimal;
        ImporteSelectivoNCr: Decimal;
        ImportePropinaNCr: Decimal;
        ImporteBienNCr: Decimal;
        ImporteServiciosNCr: Decimal;
        ImporteOtrosNCr: Decimal;
        ITBISRetenidoNCR: Decimal;
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
        DivAd: Boolean;
        FiltrosPIH: Text[1024];
        FiltrosCMH: Text[1024];
        FiltrosGLE: Text[1024];
        txt002: Label 'G/L Entry';
        Error001: Label 'Ya existen registro similares en la tabla de archivo NCF, favor limpiarla';
        Error002: Label 'Filter Required for the field %1 of the table %2';
        TipoRetISR: Integer;
        ImporteITBIS16: Decimal;
        ImporteITBIS18: Decimal;
        BaseITBIS16: Decimal;
        BaseITBIS18: Decimal;
        ImporteITBIS16NCr: Decimal;
        ImporteITBIS18NCr: Decimal;
        BaseITBIS16NCr: Decimal;
        BaseITBIS18NCr: Decimal;
        rGeneralLedgerSetup: Record "General Ledger Setup";
        FactorDivisaAdicional: Decimal;
        FactorDivisa: Decimal;
        NumeroLinea: Integer;
        PCMH: Record "Purch. Cr. Memo Hdr.";
}

