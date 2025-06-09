page 56007 "Puestos de Packing"
{
    ApplicationArea = all;

    Caption = 'Packing Position';
    PageType = List;
    SourceTable = "Puestos de Pcking";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Codigo; rec.Codigo)
                {
                }
                field(Descripcion; rec.Descripcion)
                {
                }
                field("Control Peso"; rec."Control Peso")
                {
                }
                field("Usuario Asignado"; rec."Usuario Asignado")
                {
                }
            }
        }
    }

    actions
    {
    }
}

