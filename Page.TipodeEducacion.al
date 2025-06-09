page 76411 "Tipo de Educacion"
{
    ApplicationArea = all;
    Caption = 'Education type';
    PageType = Card;
    SourceTable = "Datos auxiliares";
    SourceTableView = SORTING("Tipo registro", Codigo)
                      WHERE("Tipo registro" = CONST("Tipo de educacion"));

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
        rec."Tipo registro" := rec."Tipo registro"::"Tipo de educacion";
    end;
}

