page 76305 "Lista Planificacion Promotor"
{
    ApplicationArea = all;
    CardPageID = "Cab. Planificacion";
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Cab. Planificacion";
    SourceTableView = SORTING("Cod. Promotor", Semana)
                      ORDER(Descending);

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                ShowCaption = false;
                field("Cod. Promotor"; rec."Cod. Promotor")
                {
                }
                field(Fecha; rec.Fecha)
                {
                }
                field("Fecha Inicial"; rec."Fecha Inicial")
                {
                }
                field("Fecha Final"; rec."Fecha Final")
                {
                }
                field(Semana; rec.Semana)
                {
                }
                field("Nombre promotor"; rec."Nombre promotor")
                {
                }
                field(Estado; rec.Estado)
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        if gCodPromotor <> '' then
            rec.SetRange("Cod. Promotor", gCodPromotor);

        rec.SetRange(Ano, Date2DMY(Today, 3));
    end;

    var
        gCodPromotor: Code[20];


    procedure RecibeParametros(CodPromotor: Code[20])
    begin
        gCodPromotor := CodPromotor;
    end;
}

