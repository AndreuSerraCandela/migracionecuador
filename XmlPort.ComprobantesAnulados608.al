xmlport 76079 "Comprobantes Anulados 608"
{
    Direction = Export;
    Format = FixedText;
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
                    CabRncTxt := rTranfITBIS.RNC + Espacios;
                    CantidadRegistrostxt := Format((CantidadRegistros), 12, '<integer,12><Filler Character,0>');
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
                SourceTableView = SORTING (NCF, "Codigo reporte") WHERE ("Codigo reporte" = CONST ('608'));
                fieldelement(NCF; "Archivo Transferencia ITBIS"."NCF Relacionado")
                {
                    Width = 19;
                }
                fieldelement(Fecha; "Archivo Transferencia ITBIS"."Fecha Documento")
                {
                    Width = 8;
                }
                fieldelement(ClasificGastosCostosNCF; "Archivo Transferencia ITBIS"."Clasific. Gastos y Costos NCF")
                {
                    Width = 2;
                }
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

