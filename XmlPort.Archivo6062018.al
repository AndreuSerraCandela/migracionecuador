xmlport 76007 "Archivo 606 - 2018"
{
    // Proyecto: Microsoft Dynamics Nav
    // ---------------------------------
    // JPG    : John Peralta Guzman
    // ------------------------------------------------------------------------
    // No.         Fecha       Firma      Descripcion
    // ------------------------------------------------------------------------
    // DSLoc1.04   26-jul-2019  JPG       itbis llevado al costo

    Direction = Export;
    FieldDelimiter = '<None>';
    FieldSeparator = '|';
    Format = VariableText;
    TableSeparator = '<NewLine><None>';
    UseRequestPage = false;

    schema
    {
        textelement(Root)
        {
            tableelement(ati; "Archivo Transferencia ITBIS")
            {
                MaxOccurs = Once;
                XmlName = 'ATI';
                SourceTableView = SORTING ("Número Documento", "Fecha Documento", RNC, "Cédula", "Codigo reporte") ORDER(Ascending) WHERE ("Codigo reporte" = FILTER ('606'));
                textelement(codigoinformacion)
                {
                    XmlName = 'CodigoInformacion';
                    Width = 3;
                }
                textelement(rnctxt)
                {
                    XmlName = 'RncTxt';
                    Width = 11;
                }
                textelement(Periodo)
                {
                    Width = 6;
                }
                textelement(cantidadregistrostxt)
                {
                    XmlName = 'CantidadRegistrostxt';
                    Width = 12;
                }

                trigger OnAfterGetRecord()
                begin

                    ConfCompany.Get();
                    CodigoInformacion := '606';
                    Periodo := CopyStr(ATI."Fecha Documento", 1, 4) + CopyStr(ATI."Fecha Documento", 5, 2);
                    RNC := DelChr(ConfCompany."VAT Registration No.", '=', '- ');
                    RNC := DelChr(RNC, '=', '- ');
                    RncTxt := RNC;
                    CantidadRegistrostxt := DelChr(Format(CantidadRegistros), '=', ',');
                    currXMLport.Filename('DGII_F_606_' + RNC + '_' + Periodo + '.txt');
                    //ejmplo DGII_F_606_130329737_202101.TXT
                end;

                trigger OnPreXmlItem()
                begin
                    TranfITBIS.Reset;
                    TranfITBIS.SetRange("Codigo reporte", '606');
                    if TranfITBIS.FindSet then begin
                        CantidadRegistros := TranfITBIS.Count;
                        repeat
                            if TranfITBIS."Tipo documento" = 1 then begin
                                dTotFact += TranfITBIS."Total Documento";
                                RetencionRenta += TranfITBIS."ISR Retenido";
                            end
                            else begin
                                dTotFact -= TranfITBIS."Total Documento";
                                RetencionRenta -= TranfITBIS."ISR Retenido";
                            end;
                        until TranfITBIS.Next = 0;
                    end;
                end;
            }
            tableelement(ati_2; "Archivo Transferencia ITBIS")
            {
                XmlName = 'ATI_2';
                SourceTableView = SORTING ("Número Documento", "Fecha Documento", RNC, "Cédula", "Codigo reporte") ORDER(Ascending) WHERE ("Codigo reporte" = FILTER ('606'));
                textelement(rnctxt2)
                {
                    XmlName = 'RncTxt2';
                    Width = 11;
                }
                textelement(tipoid)
                {
                    XmlName = 'TipoID';
                    Width = 1;
                }
                textelement(idclasificacion)
                {
                    XmlName = 'IDClasificacion';
                    Width = 2;
                }
                fieldelement(NCF; ATI_2.NCF)
                {
                    Width = 19;
                }
                fieldelement(NCRRel; ATI_2."NCF Relacionado")
                {
                    Width = 19;
                }
                fieldelement(FechaComprobante; ATI_2."Fecha Documento")
                {
                }
                fieldelement(FechaPago; ATI_2."Fecha Pago")
                {
                    Width = 8;
                }
                textelement(Servicios)
                {
                }
                textelement(Bienes)
                {
                }
                textelement(MontoFacturado)
                {
                }
                textelement(totitbis)
                {
                    XmlName = 'TotITBIS';
                    Width = 12;
                }
                textelement(itbisret)
                {
                    XmlName = 'ITBISRet';
                    Width = 12;
                }
                textelement(ITBISProp)
                {
                }
                textelement(ITBISCosto)
                {
                }
                textelement(ITBISAdelantado)
                {
                }
                textelement(ITBISCompras)
                {
                }
                textelement(TipoRetISR)
                {
                }
                textelement(RetencionISR)
                {
                    Width = 12;
                }
                textelement(ISRCompra)
                {
                }
                textelement(Selectivo)
                {
                }
                textelement(Otros)
                {
                }
                textelement(Propina)
                {
                }
                textelement(FormaPago)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    Servicios := '';
                    TotITBIS := '';
                    ITBISRet := '';
                    MontoFacturado := '';
                    RetencionISR := '';
                    Bienes := '';
                    Propina := '';
                    Selectivo := '';
                    Otros := '';
                    ITBISProp := '';
                    ITBISCosto := '';
                    ITBISAdelantado := '';
                    ITBISCompras := '';
                    TipoRetISR := '';
                    ISRCompra := '';


                    TipoID := '1';
                    Clear(Espacios);

                    if ATI_2.RNC = '' then
                        TipoID := '2';

                    RNCProveedor := ATI_2."RNC/Cedula";

                    RNC := DelChr(RNCProveedor, '=', '- ');
                    RncTxt2 := RNC;

                    /*
                    //Fecha de pago
                    VLE.RESET;
                    VLE.SETCURRENTKEY("Document No.","Document Type","Vendor No.");
                    VLE.SETRANGE("Document No.",ATI_2."Numero Documento");
                    VLE.SETRANGE("Posting Date",ATI_2."fecha registro");
                    VLE.SETRANGE(Open,FALSE);
                    IF VLE.FINDFIRST THEN
                      BEGIN
                        IF VLE."Closed at Date" <> 0D THEN;
                      //  Periodo2 := ATI_2."Fecha Pago"+ATI_2."Dia Pago";
                      END;
                    */

                    if ATI_2."Total Documento" > 0 then
                        BienServ := '1'
                    else
                        BienServ := '3';

                    if ATI_2."Monto Servicios" <> 0 then
                        Servicios := DelChr(Format(ATI_2."Monto Servicios"), '=', ',');

                    if ATI_2."Monto Bienes" <> 0 then
                        Bienes := DelChr(Format(ATI_2."Monto Bienes"), '=', ',');

                    if ATI_2."ITBIS Pagado" <> 0 then
                        TotITBIS := DelChr(Format(ATI_2."ITBIS Pagado"), '=', ',');

                    if ATI_2."ITBIS Retenido" <> 0 then
                        ITBISRet := DelChr(Format(ATI_2."ITBIS Retenido"), '=', ',');

                    if ATI_2."Total Documento" <> 0 then
                        MontoFacturado := DelChr(Format(ATI_2."Total Documento"), '=', ',');

                    if ATI_2."ISR Retenido" <> 0 then
                        RetencionISR := DelChr(Format(ATI_2."ISR Retenido"), '=', ',');

                    if ATI_2."Monto Selectivo" <> 0 then
                        Selectivo := DelChr(Format(ATI_2."Monto Selectivo"), '=', ',');
                    // DSLoc1.04
                    if ATI_2."ITBIS llevado al costo" <> 0 then
                        ITBISCosto := DelChr(Format(ATI_2."ITBIS llevado al costo"), '=', ',');

                    // DSLoc1.04 jpg 08-07-2020
                    if ATI_2."ITBIS Por adelantar" <> 0 then
                        ITBISAdelantado := DelChr(Format(ATI_2."ITBIS Por adelantar"), '=', ',');


                    // DSLoc1.04 jpg 08-07-2020
                    if ATI_2."ITBIS sujeto a proporc." <> 0 then
                        ITBISProp := DelChr(Format(ATI_2."ITBIS sujeto a proporc."), '=', ',');



                    RetISR := ATI_2."Tipo retencion ISR";
                    TipoRetISR := Format(RetISR);
                    IDClasificacion := ATI_2."Clasific. Gastos y Costos NCF";
                    if StrLen(IDClasificacion) = 1 then
                        IDClasificacion := '0' + IDClasificacion;


                    if ATI_2."Forma de pago DGII" = 0 then
                        Error(Err001);

                    case ATI_2."Forma de pago DGII" of
                        0:
                            begin
                            end;
                        1:
                            FormaPago := '01';
                        2:
                            FormaPago := '02';
                        3:
                            FormaPago := '03';
                        4:
                            FormaPago := '04';
                        5:
                            FormaPago := '05';
                        6:
                            FormaPago := '06';
                        7:
                            FormaPago := '07';
                        else
                            FormaPago := '08';
                    end;


                    if ATI_2."Monto otros" <> 0 then
                        Otros := Format(ATI_2."Monto otros");
                    if ATI_2."Monto Propina" <> 0 then
                        Propina := Format(ATI_2."Monto Propina");

                end;
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

    var
        ConfCompany: Record "Company Information";
        TranfITBIS: Record "Archivo Transferencia ITBIS";
        AnoTxt: Text[4];
        MesTxt: Text[2];
        DiaTxt: Text[2];
        PrimeraVez: Integer;
        Espacios: Text[30];
        dTotFact: Decimal;
        dTotITBIS: Decimal;
        CantidadRegistros: Integer;
        BienServ: Code[10];
        RNC: Text[20];
        Ceros: Text[30];
        RetencionRenta: Decimal;
        RNCProveedor: Text[20];
        VLE: Record "Vendor Ledger Entry";
        VLE1: Record "Vendor Ledger Entry";
        RetISR: Integer;
        Err001: Label 'Forma de pago DGII debe tener un valor segun la legislación fiscal';
}

