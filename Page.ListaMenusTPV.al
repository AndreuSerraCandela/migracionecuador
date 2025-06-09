page 76027 "Lista Menus TPV"
{
    ApplicationArea = all;
    CardPageID = "Ficha Menu TPV";
    Editable = false;
    PageType = List;
    SourceTable = "Menus TPV";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Menu ID"; rec."Menu ID")
                {
                }
                field(Descripcion; rec.Descripcion)
                {
                }
                field("Cantidad de botones"; rec."Cantidad de botones")
                {
                }
                field("Tipo Menu"; rec."Tipo Menu")
                {
                    BlankZero = true;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnInit()
    var

    begin


    end;

    trigger OnOpenPage()
    begin
        cfAddin.CrearAcciones;
    end;

    var
        cfAddin: Codeunit "Funciones Addin DSPos";
}

