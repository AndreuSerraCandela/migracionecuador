xmlport 76003 "Archivo 607 - 2018"
{
    Direction = Export;
    FieldDelimiter = '<None>';
    FieldSeparator = '|';
    Format = VariableText;
    TableSeparator = '<NewLine>';
    UseRequestPage = false;

    schema
    {
        textelement(ITBIS607)
        {
            tableelement(Integer; Integer)
            {
                XmlName = 'Cabecera';
                SourceTableView = SORTING(Number) WHERE(Number = CONST(1));
                textelement(CodigoInformacion)
                {
                    Width = 3;
                }
                textelement(CabRncTxt)
                {
                    Width = 11;
                }
                textelement(CabPeriodo)
                {
                    Width = 6;
                }
                textelement(CantidadRegistrostxt)
                {
                    Width = 12;
                }

                trigger OnAfterGetRecord()
                begin


                    ConfCompany.Get();
                    CodigoInformacion := '607';
                    Fecha := TranfITBIS."Fecha Documento";
                    CabPeriodo := CopyStr(Fecha, 1, 4) + CopyStr(Fecha, 5, 2);
                    TranfITBIS.RNC := DelChr(ConfCompany."VAT Registration No.", '=', '- ');
                    TranfITBIS.RNC := DelChr(TranfITBIS.RNC, '=', '- ');
                    CabRncTxt := TranfITBIS.RNC;
                    CantidadRegistrostxt := Format(CantidadRegistros);
                    currXMLport.Filename('DGII_F_607_' + CabRncTxt + '_' + CabPeriodo + '.txt');
                    //ejmplo DGII_F_607_130329737_202101.TXT
                end;

                trigger OnPreXmlItem()
                begin
                    TranfITBIS.Reset;
                    TranfITBIS.SetRange(TranfITBIS."Codigo reporte", '607');
                    if TranfITBIS.Find('-') then begin
                        CantidadRegistros := TranfITBIS.Count;
                        repeat
                            if TranfITBIS."Tipo documento" = 1 then
                                dTotFact += TranfITBIS."Total Documento"
                            else
                                dTotFact -= TranfITBIS."Total Documento";
                        until TranfITBIS.Next = 0;
                    end;
                end;
            }
            tableelement("Archivo Transferencia ITBIS"; "Archivo Transferencia ITBIS")
            {
                XmlName = 'ITBIS';
                SourceTableView = SORTING("Número Documento", "Fecha Documento", RNC, "Cédula", "Codigo reporte") ORDER(Ascending) WHERE("Codigo reporte" = CONST('607'));
                textelement(RncTxt)
                {
                    Width = 11;
                }
                textelement(TipoID)
                {
                    Width = 1;
                }
                fieldelement(NCF; "Archivo Transferencia ITBIS".NCF)
                {
                    Width = 19;
                }
                fieldelement(NCFRelacionado; "Archivo Transferencia ITBIS"."NCF Relacionado")
                {
                    Width = 19;
                }
                fieldelement(TipoIngreso; "Archivo Transferencia ITBIS"."Tipo de ingreso")
                {
                }
                textelement(Fecha)
                {
                    Width = 8;
                }
                textelement(FechaRetencion)
                {
                }
                textelement(TotFact)
                {
                    Width = 12;
                }
                textelement(TotITBIS)
                {
                    Width = 12;
                }
                textelement(ITBISRetenido)
                {
                }
                textelement(ITBISPercibido)
                {
                }
                textelement(RetencionRenta)
                {
                }
                textelement(ISRpercibido)
                {
                }
                textelement(Selectivo)
                {
                }
                textelement(OtroImpuestos)
                {
                }
                textelement(Propina)
                {
                }
                textelement(Efectivo)
                {
                }
                textelement(Cheque)
                {
                }
                textelement(Tarjeta)
                {
                }
                textelement(Credito)
                {
                }
                textelement(Bonos)
                {
                }
                textelement(Permuta)
                {
                }
                textelement(Otros)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    TotITBIS := '';
                    ITBISRetenido := '';
                    ITBISPercibido := '';
                    RetencionRenta := '';
                    ISRpercibido := '';
                    Selectivo := '';
                    OtroImpuestos := '';
                    Propina := '';
                    Efectivo := '';
                    Cheque := '';
                    Tarjeta := '';
                    Credito := '';
                    Bonos := '';
                    Permuta := '';
                    Otros := '';
                    FechaRetencion := '';

                    if (CopyStr("Archivo Transferencia ITBIS".NCF, 1, 3) = 'B02') and (("Archivo Transferencia ITBIS"."Total Documento") <= 250000) then
                        currXMLport.Skip;

                    //with  do begin
                    TipoID := '1';
                    Clear(Espacios);

                    if "Archivo Transferencia ITBIS".RNC = '' then begin
                        "Archivo Transferencia ITBIS".RNC := "Archivo Transferencia ITBIS"."RNC/Cedula";
                        TipoID := '2';
                    end;

                    if "Archivo Transferencia ITBIS".RNC = '' then
                        TipoID := '3';

                    "Archivo Transferencia ITBIS".RNC := DelChr("Archivo Transferencia ITBIS".RNC, '=', '- ');
                    RncTxt := "Archivo Transferencia ITBIS".RNC;

                    Clear(Espacios);
                    NumDoc := "Archivo Transferencia ITBIS"."Número Documento";

                    if "Archivo Transferencia ITBIS"."Fecha Documento" <= '20061231' then
                        Clear("Archivo Transferencia ITBIS".NCF)
                    else
                        Clear(NumDoc);

                    Fecha := "Archivo Transferencia ITBIS"."Fecha Documento";

                    if "Archivo Transferencia ITBIS"."Total Documento" > 0 then
                        BienServ := '1'
                    else
                        BienServ := '3';


                    Clear(Espacios);
                    TotFact := DelChr(Format("Archivo Transferencia ITBIS"."Total Documento"), '=', ', ');
                    TotFact := ConvertStr(TotFact, ' ', '0');

                    TotITBIS := Format("Archivo Transferencia ITBIS"."ITBIS Pagado");
                    TotITBIS := DelChr(TotITBIS, '=', ', ');

                    if "Archivo Transferencia ITBIS"."ISR Retenido" <> 0 then begin
                        RetencionRenta := Format("Archivo Transferencia ITBIS"."ISR Retenido");
                        RetencionRenta := DelChr(RetencionRenta, '=', ', ');
                        if "Archivo Transferencia ITBIS"."Fecha Retencion Venta" <> '' then //jpg 17-11-2020 para capturar fecha retencion "Fecha Retencion" si el campo "Fecha Retencion Venta" es null
                            FechaRetencion := "Archivo Transferencia ITBIS"."Fecha Retencion Venta"
                        else
                            FechaRetencion := Format("Archivo Transferencia ITBIS"."Fecha Retencion", 0, '<year4>') + Format("Archivo Transferencia ITBIS"."Fecha Retencion", 0, '<Month,2>') +
                                                        Format("Archivo Transferencia ITBIS"."Fecha Retencion", 0, '<day,2>');

                    end;

                    if "Archivo Transferencia ITBIS"."ITBIS Retenido" <> 0 then begin
                        ITBISRetenido := Format("Archivo Transferencia ITBIS"."ITBIS Retenido");
                        ITBISRetenido := DelChr(ITBISRetenido, '=', ', ');
                        if "Archivo Transferencia ITBIS"."Fecha Retencion Venta" <> '' then //jpg 17-11-2020 para capturar fecha retencion "Fecha Retencion" si el campo "Fecha Retencion Venta" es null
                            FechaRetencion := "Archivo Transferencia ITBIS"."Fecha Retencion Venta"
                        else
                            FechaRetencion := Format("Archivo Transferencia ITBIS"."Fecha Retencion", 0, '<year4>') + Format("Archivo Transferencia ITBIS"."Fecha Retencion", 0, '<Month,2>') +
                                                        Format("Archivo Transferencia ITBIS"."Fecha Retencion", 0, '<day,2>');

                    end;

                    if "Archivo Transferencia ITBIS"."Monto Selectivo" <> 0 then
                        Selectivo := DelChr(Format("Archivo Transferencia ITBIS"."Monto Selectivo"), '=', ', ');
                    if "Archivo Transferencia ITBIS"."Monto Propina" <> 0 then
                        Propina := DelChr(Format("Archivo Transferencia ITBIS"."Monto Propina"), '=', ', ');
                    if "Archivo Transferencia ITBIS"."Monto otros" <> 0 then
                        Otros := DelChr(Format("Archivo Transferencia ITBIS"."Monto otros"), '=', ', ');

                    if "Archivo Transferencia ITBIS"."Monto Efectivo" <> 0 then
                        Efectivo := DelChr(Format("Archivo Transferencia ITBIS"."Monto Efectivo"), '=', ', ')
                    else
                        Efectivo := '0';
                    if "Archivo Transferencia ITBIS"."Monto Cheque" <> 0 then
                        Cheque := DelChr(Format("Archivo Transferencia ITBIS"."Monto Cheque"), '=', ', ')
                    else
                        Cheque := '0';
                    if "Archivo Transferencia ITBIS"."Monto otros" <> 0 then
                        Otros := DelChr(Format("Archivo Transferencia ITBIS"."Monto otros"), '=', ', ');
                    if "Archivo Transferencia ITBIS"."Monto tarjetas" <> 0 then
                        Tarjeta := DelChr(Format("Archivo Transferencia ITBIS"."Monto tarjetas"), '=', ', ')
                    else
                        Tarjeta := '0';
                    if "Archivo Transferencia ITBIS"."Venta a credito" <> 0 then
                        Credito := DelChr(Format("Archivo Transferencia ITBIS"."Venta a credito"), '=', ', ')
                    else
                        Credito := '0';
                    if "Archivo Transferencia ITBIS"."Venta bonos" <> 0 then
                        Bonos := DelChr(Format("Archivo Transferencia ITBIS"."Venta bonos"), '=', ', ')
                    else
                        Bonos := '0';
                    if "Archivo Transferencia ITBIS"."Venta Permuta" <> 0 then
                        Permuta := DelChr(Format("Archivo Transferencia ITBIS"."Venta Permuta"), '=', ', ')
                    else
                        Permuta := '0';
                    //end;
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
        CantidadRegistros: Integer;
        dTotFact: Decimal;
        Espacios: Text[30];
        BienServ: Code[10];
        NumDoc: Text[30];
        Periodo: Code[8];
}

