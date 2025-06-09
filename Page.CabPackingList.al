page 56013 "Cab. Packing List"
{
    ApplicationArea = all;
    CardPageID = Packing;
    Editable = false;
    PageType = List;
    SourceTable = "Cab. Packing";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; rec."No.")
                {
                }
                field("Cod. Empleado"; rec."Cod. Empleado")
                {
                }
                field("No. Mesa"; rec."No. Mesa")
                {
                }
                field("Picking No."; rec."Picking No.")
                {
                }
                field("Fecha Apertura"; rec."Fecha Apertura")
                {
                }
                field("Fecha Registro"; rec."Fecha Registro")
                {
                }
                field("Total de Productos"; rec."Total de Productos")
                {
                }
            }
        }
    }

    actions
    {
    }
}

