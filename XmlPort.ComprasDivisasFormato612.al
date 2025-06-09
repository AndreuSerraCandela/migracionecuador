xmlport 76080 "Compras Divisas Formato 612"
{
    Direction = Export;
    Format = FixedText;
    TableSeparator = '<NewLine>';
    UseRequestPage = false;

    schema
    {
        textelement(ITBIS612)
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
                textelement(TotalMontoFacturadotxt)
                {
                    Width = 16;
                }

                trigger OnAfterGetRecord()
                begin


                    rConfCompany.Get();
                    CodigoInformacion := '612';
                    CabPeriodo := CopyStr(rTranfITBIS."Fecha Documento", 1, 4) + CopyStr(rTranfITBIS."Fecha Documento", 5, 2);
                    rTranfITBIS.RNC := DelChr(rConfCompany."VAT Registration No.", '=', '- ');
                    rTranfITBIS.RNC := DelChr(rTranfITBIS.RNC, '=', '- ');
                    Espacios := PadStr(Espacios, 11 - StrLen(rTranfITBIS.RNC), ' ');
                    CabRncTxt := rTranfITBIS.RNC + Espacios;
                    CantidadRegistrostxt := Format((CantidadRegistros), 12, '<integer,12><Filler Character,0>');
                    TotalMontoFacturadotxt := Format((dTotFact), 16, '<integer><Decimal,3>');
                    TotalMontoFacturadotxt := ConvertStr(TotalMontoFacturadotxt, ' ', '0');
                end;

                trigger OnPreXmlItem()
                begin
                    rTranfITBIS.Reset;
                    rTranfITBIS.SetRange(rTranfITBIS."Codigo reporte", '612');
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
                SourceTableView = SORTING("Número Documento", "Fecha Documento", RNC, "Cédula", "Codigo reporte") WHERE("Codigo reporte" = CONST('606'));
                textelement(RncTxt)
                {
                    Width = 11;
                }
                textelement(TipoID)
                {
                    Width = 1;
                }
                fieldelement(RazonSocial; "Archivo Transferencia ITBIS"."Razón Social")
                {
                    Width = 45;
                }
                fieldelement(Fecha; "Archivo Transferencia ITBIS"."Fecha Documento")
                {
                    Width = 8;
                }
                fieldelement(Apellidos; "Archivo Transferencia ITBIS"."NCF Relacionado")
                {
                    Width = 19;
                }
                fieldelement(Nombres; "Archivo Transferencia ITBIS".Nombres)
                {
                    Width = 2;
                }
                textelement(TotFact)
                {
                    Width = 7;
                }
                textelement(TotITBIS)
                {
                    Width = 12;
                }

                trigger OnAfterGetRecord()
                begin

                    TipoID := '1';
                    Clear(Espacios);

                    if "Archivo Transferencia ITBIS".RNC = '' then begin
                        "Archivo Transferencia ITBIS".RNC := "Archivo Transferencia ITBIS".Cédula;
                        TipoID := '2';
                    end;

                    "Archivo Transferencia ITBIS".RNC := DelChr("Archivo Transferencia ITBIS".RNC, '=', '- ');
                    Espacios := PadStr(Espacios, 11 - StrLen("Archivo Transferencia ITBIS".RNC), ' ');
                    RncTxt := "Archivo Transferencia ITBIS".RNC + Espacios;

                    if "Archivo Transferencia ITBIS"."Fecha Documento" <= '20061231' then
                        Clear("Archivo Transferencia ITBIS"."Número Documento");

                    if "Archivo Transferencia ITBIS"."Total Documento" > 0 then
                        BienServ := '1'
                    else
                        BienServ := '3';

                    Clear(Espacios);
                    TotFact := Format(("Archivo Transferencia ITBIS"."Total Documento"), 12, '<Integer><Decimals,3>');
                    TotFact := ConvertStr(TotFact, ' ', '0');

                    Clear(Espacios);
                    TotITBIS := Format(("Archivo Transferencia ITBIS"."ITBIS Pagado"), 12, '<Integer><Decimal,3>');
                    TotITBIS := ConvertStr(TotITBIS, ' ', '0');
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
        BienServ: Code[10];
}

