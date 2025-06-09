page 76249 "Historico Promotor - Ppto Mtt"
{
    ApplicationArea = all;
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Historico Promotor - Ppto Mt";

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
                field("Extended Quantity"; rec."Extended Quantity")
                {
                }
                field("Cantidad camp. anterior"; rec."Cantidad camp. anterior")
                {
                }
                field("Cod. producto equivalente"; rec."Cod. producto equivalente")
                {
                }
                field("Cantidad consumida"; rec."Cantidad consumida")
                {
                }
                field("Cantidad seleccionada"; rec."Cantidad seleccionada")
                {
                }
                field("No. documento"; rec."No. documento")
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

