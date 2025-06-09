xmlport 76041 "ITBIS Ventas NCF Formato 607"
{
    Direction = Export;
    Format = FixedText;
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
                textelement(TotalMontoFacturadotxt)
                {
                    Width = 16;
                }

                trigger OnAfterGetRecord()
                begin


                    ConfCompany.Get();
                    CodigoInformacion := '607';
                    Fecha := TranfITBIS."Fecha Documento";
                    CabPeriodo := CopyStr(Fecha, 1, 4) + CopyStr(Fecha, 5, 2);
                    TranfITBIS.RNC := DelChr(ConfCompany."VAT Registration No.", '=', '- ');
                    TranfITBIS.RNC := DelChr(TranfITBIS.RNC, '=', '- ');
                    Espacios := PadStr(Espacios, 11 - StrLen(TranfITBIS.RNC), ' ');
                    CabRncTxt := Espacios + TranfITBIS.RNC;
                    CantidadRegistrostxt := Format((CantidadRegistros), 12, '<integer,12><Filler Character,0>');
                    Clear(Espacios);
                    TotalMontoFacturadotxt := Format((dTotFact), 16, '<integer><Decimal,3>');
                    TotalMontoFacturadotxt := ConvertStr(TotalMontoFacturadotxt, ' ', '0');
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
                SourceTableView = SORTING("Número Documento", "Fecha Documento", RNC, "Cédula", "Codigo reporte") WHERE("Codigo reporte" = CONST('607'));
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
                textelement(Fecha)
                {
                    Width = 8;
                }
                textelement(TotITBIS)
                {
                    Width = 12;
                }
                textelement(TotFact)
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

                    if "Archivo Transferencia ITBIS".RNC = '' then
                        TipoID := '3';

                    "Archivo Transferencia ITBIS".RNC := DelChr("Archivo Transferencia ITBIS".RNC, '=', '- ');
                    Espacios := PadStr(Espacios, 11 - StrLen("Archivo Transferencia ITBIS".RNC), ' ');
                    RncTxt := "Archivo Transferencia ITBIS".RNC + Espacios;

                    Clear(Espacios);
                    Espacios := PadStr(Espacios, 25 - StrLen("Archivo Transferencia ITBIS"."Número Documento"), ' ');
                    NumDoc := "Archivo Transferencia ITBIS"."Número Documento" + Espacios;

                    if "Archivo Transferencia ITBIS"."Fecha Documento" <= '20061231' then
                        Clear("Archivo Transferencia ITBIS".NCF)
                    else
                        Clear(NumDoc);

                    Fecha := "Archivo Transferencia ITBIS"."Fecha Documento";
                    Periodo := '00000000';


                    if "Archivo Transferencia ITBIS"."Total Documento" > 0 then
                        BienServ := '1'
                    else
                        BienServ := '3';


                    Clear(Espacios);
                    TotFact := Format(("Archivo Transferencia ITBIS"."Total Documento"), 12, '<Integer><Decimals,3>');
                    //  Espacios             := PADSTR(Espacios,12 - STRLEN(TotFact),'0');
                    //  TotFact              := Espacios + TotFact;
                    TotFact := ConvertStr(TotFact, ' ', '0');

                    Clear(Espacios);
                    TotITBIS := Format(("Archivo Transferencia ITBIS"."ITBIS Pagado"), 12, '<Integer><Decimal,3>');
                    //  Espacios             := PADSTR(Espacios,12 - STRLEN(TotITBIS),'0');
                    //  TotITBIS             := Espacios + TotITBIS;
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
        ConfCompany: Record "Company Information";
        TranfITBIS: Record "Archivo Transferencia ITBIS";
        CantidadRegistros: Integer;
        dTotFact: Decimal;
        Espacios: Text[30];
        BienServ: Code[10];
        NumDoc: Text[30];
        Periodo: Code[8];
}

