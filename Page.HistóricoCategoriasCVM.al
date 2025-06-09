page 76252 "Histórico Categorias CVM"
{
    ApplicationArea = all;
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Histórico Categorias CVM";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Campaña"; rec.Campaña)
                {
                }
                field("Cod. Colegio"; rec."Cod. Colegio")
                {
                }
                field("Nombre Colegio"; rec."Nombre Colegio")
                {
                }
                field("Grupo Negocio"; rec."Grupo Negocio")
                {
                }
                field("Cod. Nivel"; rec."Cod. Nivel")
                {
                }
                field(Categoria; rec.Categoria)
                {
                }
            }
        }
    }

    actions
    {
    }
}

