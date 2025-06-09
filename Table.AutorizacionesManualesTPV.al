table 76408 "Autorizaciones Manuales TPV"
{
    // #81410  17/07/2017  PLB: Renumerado de 76427
    // #348662 25.11.2020  RRT: Actualizar DS-POS para ajustar a version 43c. Redenominar tambien campos con caracteres conflictivos.


    fields
    {
        field(10; Tienda; Code[20])
        {
            Description = 'DsPOS Bolivia';
            TableRelation = Tiendas."Cod. Tienda";
        }
        field(20; Autorizacion; Code[30])
        {
            Description = 'DsPOS Bolivia';
            Editable = true;
            TableRelation = "No. Series Line"."No. Autorizacion" WHERE ("Fecha Caducidad" = FIELD ("Filtro Fecha"),
                                                                        Tipo = CONST ("Pre-Impreso"),
                                                                        "Tipo Autorizacion" = CONST (Definitiva),
                                                                        "No. Autorizacion" = FILTER (<> ''));

            trigger OnValidate()
            var
                rLinSerie: Record "No. Series Line";
                rCabSeries: Record "No. Series";
            begin

                rLinSerie.Reset;
                rLinSerie.SetCurrentKey("No. Autorizacion");
                rLinSerie.SetRange("No. Autorizacion", Autorizacion);
                if rLinSerie.FindFirst then begin
                    "Fecha Inicial" := rLinSerie."Fecha Autorizacion";
                    "Fecha Final" := rLinSerie."Fecha Caducidad";
                    "No. Inicial" := rLinSerie."Starting No.";
                    "No Final" := rLinSerie."Ending No.";
                    rCabSeries.Get(rLinSerie."Series Code");
                    Descripcion := rCabSeries.Description;
                end;
            end;
        }
        field(30; "Fecha Inicial"; Date)
        {
            Description = 'DsPOS Bolivia';
        }
        field(40; "Fecha Final"; Date)
        {
            Description = 'DsPOS Bolivia';
        }
        field(50; "No. Inicial"; Code[40])
        {
            Description = 'DsPOS Bolivia';
        }
        field(60; "No Final"; Code[40])
        {
            Description = 'DsPOS Bolivia';
        }
        field(70; Descripcion; Text[50])
        {
            Description = 'DsPOS Bolivia';
        }
        field(80; "Filtro Fecha"; Date)
        {
            FieldClass = FlowFilter;
        }
    }

    keys
    {
        key(Key1; Tienda, Autorizacion, "Fecha Inicial")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

