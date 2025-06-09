xmlport 76006 "Comprob. Anulados 608 - 2020"
{
    Direction = Export;
    FieldDelimiter = '<None>';
    FieldSeparator = '|';
    Format = VariableText;
    TableSeparator = '<NewLine>';
    UseRequestPage = false;

    schema
    {
        textelement(ITBIS608)
        {
            tableelement(Integer; Integer)
            {
                XmlName = 'Cabecera';
                SourceTableView = SORTING (Number) WHERE (Number = CONST (1));
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


                    rConfCompany.Get();
                    CodigoInformacion := '608';
                    CabPeriodo := CopyStr(rTranfITBIS."Fecha Documento", 1, 4) + CopyStr(rTranfITBIS."Fecha Documento", 5, 2);
                    rTranfITBIS.RNC := DelChr(rConfCompany."VAT Registration No.", '=', '- ');
                    rTranfITBIS.RNC := DelChr(rTranfITBIS.RNC, '=', '- ');
                    Espacios := PadStr(Espacios, 11 - StrLen(rTranfITBIS.RNC), ' ');
                    //CabRncTxt              := rTranfITBIS.RNC+Espacios;
                    CabRncTxt := rTranfITBIS.RNC;
                    //CantidadRegistrostxt   := FORMAT((CantidadRegistros),12,'<integer,12><Filler Character,0>');
                    CantidadRegistrostxt := Format((CantidadRegistros));
                    currXMLport.Filename('DGII_F_608_' + CabRncTxt + '_' + CabPeriodo + '.txt');
                    //ejmplo DGII_F_608_130329737_202101.TXT
                end;

                trigger OnPreXmlItem()
                begin
                    rTranfITBIS.Reset;
                    rTranfITBIS.SetRange(rTranfITBIS."Codigo reporte", '608');
                    if rTranfITBIS.Find('-') then begin
                        CantidadRegistros := rTranfITBIS.Count;
                        repeat
                            dTotFact += rTranfITBIS."Total Documento";
                        until rTranfITBIS.Next = 0;
                    end;
                end;
            }
            tableelement("Archivo Transferencia ITBIS"; "Archivo Transferencia ITBIS")
            {
                XmlName = 'ITBIS';
                SourceTableView = SORTING ("Line No.", "Codigo reporte", "Número Documento", "Fecha Documento", RNC, "Cédula", "No. Mov.") ORDER(Ascending) WHERE ("NCF Relacionado" = FILTER (<> ''), "Codigo reporte" = FILTER ('608'));
                textelement(NCFtxt)
                {
                    Width = 19;
                }
                fieldelement(Fecha; "Archivo Transferencia ITBIS"."Fecha Documento")
                {
                    Width = 8;
                }
                fieldelement(RazonAnulacion; "Archivo Transferencia ITBIS"."Razon Anulacion")
                {
                    Width = 2;
                }

                trigger OnAfterGetRecord()
                begin
                    if "Archivo Transferencia ITBIS"."NCF Relacionado" = '' then
                        currXMLport.Skip;
                    NCFtxt := "Archivo Transferencia ITBIS"."NCF Relacionado";
                    if StrLen(NCFtxt) = 11 then
                        NCFtxt := "Archivo Transferencia ITBIS"."NCF Relacionado" + '        ';
                    if StrLen(NCFtxt) = 13 then
                        NCFtxt := "Archivo Transferencia ITBIS"."NCF Relacionado" + '      ';
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
        rConfCompany: Record "Company Information";
        rTranfITBIS: Record "Archivo Transferencia ITBIS";
        CantidadRegistros: Integer;
        dTotFact: Decimal;
        Espacios: Text[30];
        NumDoc: Text[30];
        Periodo: Code[8];
}

