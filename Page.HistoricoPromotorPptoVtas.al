page 76250 "Historico Promotor - Ppto Vtas"
{
    ApplicationArea = all;
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Historico Promotor - Ppto Vtas";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Cod. Promotor"; rec."Cod. Promotor")
                {
                }
                field("Cod. Producto"; rec."Cod. Producto")
                {
                }
                field("Nombre Promotor"; rec."Nombre Promotor")
                {
                }
                field("Item Description"; rec."Item Description")
                {
                }
                field(Quantity; rec.Quantity)
                {
                }
                field("Cantidad camp. anterior"; rec."Cantidad camp. anterior")
                {
                }
                field("Cod. producto equivalente"; rec."Cod. producto equivalente")
                {
                }
                field(Adopcion; rec.Adopcion)
                {
                }
                field("Adopcion anterior"; rec."Adopcion anterior")
                {
                }
                field("Campaña"; rec.Campaña)
                {
                }
            }
        }
    }

    actions
    {
    }
}

