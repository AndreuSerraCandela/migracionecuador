page 56091 "Grupo Neogocio auxiliares"
{
    ApplicationArea = all;
    Caption = '<Grupo Negocio auxiliares>';
    PageType = List;
    SourceTable = "Datos auxiliares";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Tipo registro"; rec."Tipo registro")
                {
                }
                field(Codigo; rec.Codigo)
                {
                }
                field(Descripcion; rec.Descripcion)
                {
                }
                field(Mostrar; rec.Mostrar)
                {
                }
            }
        }
    }

    actions
    {
    }
}

