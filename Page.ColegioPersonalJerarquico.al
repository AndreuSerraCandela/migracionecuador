page 76141 "Colegio - Personal Jerarquico"
{
    ApplicationArea = all;
    PageType = Card;
    SourceTable = "Colegio - Cab. Jerarquia puest";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Cod. Colegio"; rec."Cod. Colegio")
                {
                }
                field("Cod. Local"; rec."Cod. Local")
                {
                }
                field("Cod. Turno"; rec."Cod. Turno")
                {
                }
                field("Nombre Colegio"; rec."Nombre Colegio")
                {
                }
                field("Cod. Nivel"; rec."Cod. Nivel")
                {
                }
            }
            part(Control1000000012; "Colegio - Personal J. subform")
            {
                SubPageLink = "Cod. Colegio" = FIELD("Cod. Colegio"),
                              "Cod. Docente" = FIELD("Cod. Local"),
                              "Nombre colegio" = FIELD("Cod. Nivel"),
                              "Nombre docente" = FIELD("Cod. Turno");
            }
        }
    }

    actions
    {
    }
}

