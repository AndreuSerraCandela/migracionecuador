page 76245 "Historico Docentes - CDS"
{
    ApplicationArea = all;
    Editable = false;
    PageType = List;
    SourceTable = "Historico Docentes - CDS";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Cod. Docente"; rec."Cod. Docente")
                {
                    Visible = false;
                }
                field(Campana; rec.Campana)
                {
                }
                field("Cod. Colegio"; rec."Cod. Colegio")
                {
                }
                field("Pertenece al CDS"; rec."Pertenece al CDS")
                {
                }
                field("Cod. CDS"; rec."Cod. CDS")
                {
                }
                field("Ult. fecha activacion"; rec."Ult. fecha activacion")
                {
                }
            }
        }
    }

    actions
    {
    }
}

