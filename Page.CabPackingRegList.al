page 56014 "Cab. Packing Reg. List"
{
    ApplicationArea = all;

    Caption = 'Posted Packing Header';
    CardPageID = "Cab. Packing Registrado";
    Editable = false;
    PageType = List;
    SourceTable = "Cab. Packing Registrado";
    UsageCategory = Lists;

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
                field("No. Packing Origen"; rec."No. Packing Origen")
                {
                }
                field("Total de Productos"; rec."Total de Productos")
                {
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1000000011; Notes)
            {
            }
        }
    }

    actions
    {
    }
}

