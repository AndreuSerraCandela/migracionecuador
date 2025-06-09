page 56042 "Puestos de empaque"
{
    ApplicationArea = all;
    PageType = List;
    SourceTable = "Puestos de Pcking";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Codigo; rec.Codigo)
                {
                }
                field("Control Peso"; rec."Control Peso")
                {
                }
                field("Usuario Asignado"; rec."Usuario Asignado")
                {
                }
                field(Descripcion; rec.Descripcion)
                {
                }
            }
        }
    }

    actions
    {
    }
}

