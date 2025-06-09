page 76321 Materiales
{
    ApplicationArea = all;

    Caption = 'Materials';
    PageType = Card;
    SourceTable = "Datos auxiliares";
    SourceTableView = SORTING("Tipo registro", Codigo)
                      WHERE("Tipo registro" = CONST(Materiales));
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
                field("Costo Unitario"; rec."Costo Unitario")
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        rec."Tipo registro" := rec."Tipo registro"::Materiales;
    end;
}

