xmlport 76058 "Archivo ITBIS ComprasNCF606_14"
{
    Direction = Export;
    Format = FixedText;
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
                textelement(periodo)
                {
                    XmlName = 'Periodo';
                    Width = 6;
                }
                textelement(cantidadregistrostxt)
                {
                    XmlName = 'CantidadRegistrostxt';
                    Width = 12;
                }
                textelement(totalmontofacturadotxt)
                {
                    XmlName = 'TotalMontoFacturadotxt';
                    Width = 16;
                }

                trigger OnAfterGetRecord()
                begin

                    ConfCompany.Get();
                    CodigoInformacion := '606';
                    Fecha := ATI."Fecha Documento";
                    Periodo := CopyStr(Fecha, 1, 4) + CopyStr(Fecha, 5, 2);
                    RNC := DelChr(ConfCompany."VAT Registration No.", '=', '- ');
                    RNC := DelChr(RNC, '=', '- ');
                    Espacios := PadStr(Espacios, 11 - StrLen(RNC), ' ');
                    RncTxt := Espacios + RNC;
                    CantidadRegistrostxt := Format((CantidadRegistros), 12, '<integer,12><Filler Character,0>');
                    Clear(Ceros);
                    Ceros := PadStr(Ceros, 16 - StrLen(Format((dTotFact), 0, '<integer><Decimal>')), '0');
                    TotalMontoFacturadotxt := Ceros + Format((dTotFact), 0, '<integer><Decimal>');
                    Clear(Ceros);
                    Ceros := PadStr(Ceros, 12 - StrLen(Format((RetencionRenta), 0, '<integer><Decimal>')), '0');
                    //RetencionRentatxt      := Ceros + FORMAT((RetencionRenta),0,'<integer><Decimal>');
                end;

                trigger OnPreXmlItem()
                begin
                    TranfITBIS.Reset;
                    TranfITBIS.SetRange("Codigo reporte", '606');
                    if TranfITBIS.FindSet then begin
                        CantidadRegistros := TranfITBIS.Count;
                        repeat
                            dTotFact += TranfITBIS."Total Documento";
                            RetencionRenta += TranfITBIS."ISR Retenido";
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
                textelement(fecha)
                {
                    XmlName = 'Fecha';
                    Width = 8;
                }
                textelement(periodo2)
                {
                    XmlName = 'Periodo2';
                    Width = 8;
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
                textelement(totfact)
                {
                    XmlName = 'TotFact';
                    Width = 12;
                }

                trigger OnAfterGetRecord()
                begin
                    TipoID := '1';
                    Clear(Espacios);

                    if ATI_2.RNC = '' then
                        TipoID := '2';

                    RNCProveedor := ATI_2."RNC/Cedula";

                    RNC := DelChr(RNCProveedor, '=', '- ');
                    Espacios := PadStr(Espacios, 11 - StrLen(RNC), ' ');
                    RncTxt2 := RNC + Espacios;

                    Fecha := ATI_2."Fecha Documento" + ATI_2.Dia;

                    //Fecha de pago
                    VLE.Reset;
                    VLE.SetCurrentKey("Document No.", "Document Type", "Vendor No.");
                    VLE.SetRange("Document No.", ATI_2."Número Documento");
                    VLE.SetRange("Posting Date", ATI_2."fecha registro");
                    VLE.SetRange(Open, false);
                    if VLE.FindFirst then begin
                        if VLE."Closed at Date" <> 0D then;
                        Periodo2 := ATI_2."Fecha Pago" + ATI_2."Dia Pago";
                    end
                    else
                        Periodo2 := '00000000';

                    if ATI_2."Total Documento" > 0 then
                        BienServ := '1'
                    else
                        BienServ := '3';


                    Clear(Espacios);
                    Espacios := PadStr(Espacios, 12 - StrLen(Format((ATI_2."ITBIS Pagado"), 0, '<integer><Decimal,3>')), '0');
                    TotITBIS := Espacios + Format((ATI_2."ITBIS Pagado"), 0, '<integer><Decimal,3>');

                    Clear(Espacios);
                    Espacios := PadStr(Espacios, 12 - StrLen(Format((ATI_2."ITBIS Retenido"), 0, '<integer><Decimal,3>')), '0');
                    ITBISRet := Espacios + Format((ATI_2."ITBIS Retenido"), 0, '<integer><Decimal,3>');

                    Clear(Espacios);
                    Espacios := PadStr(Espacios, 12 - StrLen(Format((ATI_2."Total Documento"), 0, '<integer><Decimal,3>')), '0');
                    TotFact := Espacios + Format((ATI_2."Total Documento"), 0, '<integer><Decimal,3>');

                    Clear(Espacios);
                    Espacios := PadStr(Espacios, 12 - StrLen(Format((ATI_2."ISR Retenido"), 0, '<integer><Decimal,3>')), '0');
                    //RetencionISR         := Espacios + FORMAT((ATI_2."ISR Retenido"),0,'<integer><Decimal,3>');


                    IDClasificacion := ATI_2."Clasific. Gastos y Costos NCF";
                    if StrLen(IDClasificacion) = 1 then
                        IDClasificacion := '0' + IDClasificacion;
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
}

