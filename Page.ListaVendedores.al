page 76315 "Lista Vendedores"
{
    ApplicationArea = all;
    CardPageID = "Ficha Vendedor";
    Editable = false;
    PageType = List;
    SourceTable = Vendedores;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Tienda; rec.Tienda)
                {
                }
                field(Codigo; rec.Codigo)
                {
                }
                field(Nombre; rec.Nombre)
                {
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
}

