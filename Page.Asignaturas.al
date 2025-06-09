page 76101 Asignaturas
{
    ApplicationArea = all;

    Caption = 'Subjects';
    PageType = Card;
    SourceTable = Asignaturas;
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                ShowCaption = false;
                field("Code"; rec.Code)
                {
                }
                field(Description; rec.Description)
                {
                }
                field(Nivel; rec.Nivel)
                {
                }
                field(Turno; rec.Turno)
                {
                }
                field(Grado; rec.Grado)
                {
                }
                field("Carga horaria"; rec."Carga horaria")
                {
                }
            }
        }
    }

    actions
    {
    }
}

