page 56017 "Cab. Hoja de Ruta Reg. List"
{
    ApplicationArea = all;

    Caption = 'Posted Route sheet list';
    CardPageID = "Cab. Hoja de Ruta Reg.";
    Editable = false;
    PageType = List;
    SourceTable = "Cab. Hoja de Ruta Reg.";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No. Hoja Ruta"; rec."No. Hoja Ruta")
                {
                }
                field("Cod. Transportista"; rec."Cod. Transportista")
                {
                }
                field("Nombre Chofer"; rec."Nombre Chofer")
                {
                }
                field("Fecha Planificacion Transporte"; rec."Fecha Planificacion Transporte")
                {
                }
                field(Comentario; rec.Comentario)
                {
                }
                field(Hora; rec.Hora)
                {
                }
                field("Fecha Registro"; rec."Fecha Registro")
                {
                }
                field("Cantidad de cajas"; rec."Cantidad de cajas")
                {
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1000000009; Notes)
            {
            }
            systempart(Control1000000010; Links)
            {
            }
        }
    }

    actions
    {
    }
}

