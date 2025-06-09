page 56011 "Cab. Hoja de Ruta List"
{
    ApplicationArea = all;

    Caption = 'Route Sheet list';
    CardPageID = "Cab. Hoja de Ruta";
    Editable = false;
    PageType = List;
    SourceTable = "Cab. Hoja de Ruta";
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

