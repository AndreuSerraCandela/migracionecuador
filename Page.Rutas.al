page 76379 Rutas
{
    ApplicationArea = all;

    Caption = 'Routes';
    PageType = Card;
    SourceTable = "Datos auxiliares";
    SourceTableView = WHERE("Tipo registro" = CONST(Rutas));
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                ShowCaption = false;
                field(Codigo; rec.Codigo)
                {
                }
                field(Descripcion; rec.Descripcion)
                {
                }
                field(Delegacion; rec.Delegacion)
                {
                }
                field("Descripcion delegacion"; rec."Descripcion delegacion")
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Route)
            {
                Caption = 'Route';
                action("&Districts")
                {
                    Caption = '&Districts';
                    RunObject = Page "Rutas - Distribucion Geo.";
                    RunPageLink = "Cod. Ruta" = FIELD(Codigo);
                }
                action("&Salesrep")
                {
                    Caption = '&Salesrep';
                    RunObject = Page "Promotor - Rutas";
                    RunPageLink = "Cod. Ruta" = FIELD(Codigo);
                }
            }
        }
    }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        rec."Tipo registro" := rec."Tipo registro"::Rutas;
    end;
}

