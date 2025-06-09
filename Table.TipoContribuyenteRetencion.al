table 55002 "Tipo Contribuyente - Retencion"
{

    fields
    {
        field(1; "Codigo Retencion"; Code[20])
        {
            Caption = 'Retention Code';
        }
        field(2; "Tipos Agente de Retencion"; Code[20])
        {
            TableRelation = "SRI - Tabla Parametros".Code WHERE ("Tipo Registro" = FILTER ("TIPOS AGENTE DE RETENCION"));

            trigger OnValidate()
            begin
                if TPSRI.Get(2, "Tipos Agente de Retencion") then
                    Descripcion := TPSRI.Description
                else
                    Descripcion := '';
            end;
        }
        field(3; Descripcion; Text[60])
        {
            Caption = 'Description';
        }
    }

    keys
    {
        key(Key1; "Codigo Retencion", "Tipos Agente de Retencion")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        TPSRI: Record "SRI - Tabla Parametros";
}

