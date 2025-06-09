xmlport 55018 "Importar claves contingencia"
{
    Direction = Import;
    Format = FixedText;
    FormatEvaluate = Legacy;
    RecordSeparator = '<LF>';

    schema
    {
        textelement(root)
        {
            tableelement(claves; "Claves contingencia")
            {
                XmlName = 'Claves';
                SourceTableView = SORTING(Ambiente, Clave);
                fieldelement(Clave; Claves.Clave)
                {
                    Width = 37;
                }

                trigger OnAfterInitRecord()
                begin
                    Claves.Ambiente := optAmbiente;
                    Claves.Utilizada := false;
                end;

                trigger OnBeforeInsertRecord()
                begin
                    intImportadas += 1;
                    if intImportadas mod 1000 = 0 then
                        dlgProgreso.Update(1, intImportadas);
                end;
            }
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Opciones)
                {
                    field(Ambiente; optAmbiente)
                    {
                    ApplicationArea = All;
                    }
                }
            }
        }

        actions
        {
        }
    }

    trigger OnPostXmlPort()
    begin
        Message(Text002, intImportadas, optAmbiente);
    end;

    trigger OnPreXmlPort()
    begin
        dlgProgreso.Open(Text001);
    end;

    var
        dlgProgreso: Dialog;
        intImportadas: Integer;
        optAmbiente: Option Pruebas,"Producción";
        Text001: Label 'Claves importadas #########1';
        Text002: Label 'Se han importado %1 nuevas claves en ambiente de %2';
}

