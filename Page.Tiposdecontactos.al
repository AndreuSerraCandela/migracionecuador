page 76413 "Tipos de contactos"
{
    ApplicationArea = all;

    Caption = 'Types of contacts';
    PageType = Card;
    SourceTable = "Datos auxiliares";
    SourceTableView = SORTING("Tipo registro", Codigo)
                      WHERE("Tipo registro" = CONST("Tipos de contactos"));
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
            }
        }
    }

    actions
    {
    }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        rec."Tipo registro" := rec."Tipo registro"::"Tipos de contactos";
    end;
}

