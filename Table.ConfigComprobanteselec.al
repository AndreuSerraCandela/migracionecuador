table 55014 "Config. Comprobantes elec."
{

    fields
    {
        field(10; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
        }
        field(20; Activado; Option)
        {
            Caption = 'Activado';
            OptionCaption = 'Desactivado,Envío automático,Envío manual';
            OptionMembers = Desactivado,"Automático",Manual;

            trigger OnValidate()
            begin
                if Activado <> Activado::Desactivado then begin
                    TestField("Web Service Recepcion pruebas");
                    TestField("Web Service recep. produccion");

                    TestField("Web Service Autoriza. pruebas");
                    TestField("Web Service Autori. produccion");

                    TestField("Ruta ficheros XML Facturas");
                    TestField("Ruta ficheros XML Remisiones");
                    TestField("Ruta ficheros XML Nota Credito");
                    TestField("Ruta ficheros XML Nota Debito");
                    TestField("Ruta ficheros XML Retencion");
                    TestField("Subcarpeta generados");
                    TestField("Subcarpeta firmados");
                    TestField("Subcarpeta enviados");

                    TestField("Ruta Ejecutable Firma");
                    TestField("Ruta certificado firma");
                end;
            end;
        }
        field(30; Ambiente; Option)
        {
            Caption = 'Ambiente';
            OptionCaption = 'Pruebas,Producción';
            OptionMembers = Pruebas,Produccion;
        }
        field(40; "Web Service Recepcion pruebas"; Text[250])
        {
            Caption = 'Web Service Recepción pruebas';
        }
        field(45; "Web Service Autoriza. pruebas"; Text[250])
        {
            Caption = 'Web Service Autorización pruebas';
        }
        field(50; "Web Service recep. produccion"; Text[250])
        {
            Caption = 'Web Service Recepción Producción';
        }
        field(55; "Web Service Autori. produccion"; Text[250])
        {
            Caption = 'Web Service Autorización Producción';
        }
        field(70; "Ruta certificado firma"; Text[250])
        {
            Caption = 'Ruta certificado firma';
        }
        field(80; "Contraseña certificado firma"; Text[30])
        {
            Caption = 'Contraseña certificado firma';
            ExtendedDatatype = Masked;
        }
        field(90; "Ruta ficheros XML Facturas"; Text[250])
        {
            Caption = 'Ruta ficheros XML Facturas';
        }
        field(100; "Ruta ficheros XML Remisiones"; Text[250])
        {
            Caption = 'Ruta ficheros XML Remisiones';
        }
        field(110; "Ruta ficheros XML Nota Credito"; Text[250])
        {
            Caption = 'Ruta ficheros XML Notas Crédito';
        }
        field(120; "Ruta ficheros XML Nota Debito"; Text[250])
        {
            Caption = 'Ruta ficheros XML Notas Débito';
        }
        field(130; "Ruta ficheros XML Retencion"; Text[250])
        {
            Caption = 'Ruta Ficheros XML Comprobantes Retención';
        }
        field(140; "Subcarpeta generados"; Text[30])
        {
            Caption = 'Subcarpeta generados';
        }
        field(150; "Subcarpeta firmados"; Text[30])
        {
            Caption = 'Subcarpeta firmados';
        }
        field(160; "Subcarpeta enviados"; Text[30])
        {
            Caption = 'Subcarpeta enviados';
        }
        field(165; "Subcarpeta autorizados"; Text[30])
        {
            Caption = 'Subcarpeta autorizados';
        }
        field(170; "Ruta Ejecutable Firma"; Text[250])
        {
            Caption = 'Ruta Ejecutable Firma';
        }
        field(180; "Ruta exportacion clientes"; Text[250])
        {
            Caption = 'Ruta exportación clientes';
        }
        field(181; "Ruta exportacion prov."; Text[250])
        {
            Caption = 'Ruta exportación prov.';
        }
        field(182; "Ruta ficheros XML Liquidacion"; Text[250])
        {
            Caption = 'Ruta ficheros XML Liquidacion';
        }
        field(50000; "Activar Cod. Contribuyente Esp"; Boolean)
        {
            Caption = 'Activar Cod. Contribuyente Esp';
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Primary Key")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }


    procedure TraerAmbiente(): Text[1]
    begin
        case Ambiente of
            Ambiente::Pruebas:
                exit('1');
            Ambiente::Produccion:
                exit('2');
        end;
    end;
}

