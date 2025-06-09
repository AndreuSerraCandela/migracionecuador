page 76144 "Colegios -  Docentes ListPart"
{
    ApplicationArea = all;
    Caption = 'Schoold - Teachers';
    PageType = ListPart;
    SourceTable = "Colegio - Docentes";

    layout
    {
        area(content)
        {
            repeater(Control1000000004)
            {
                ShowCaption = false;
                field("Cod. Colegio"; rec."Cod. Colegio")
                {
                }
                field("Nombre colegio"; rec."Nombre colegio")
                {
                }
                field("Cod. Cargo"; rec."Cod. Cargo")
                {
                }
                field("Cod. Nivel"; rec."Cod. Nivel")
                {
                }
                field("Cod. Promotor"; rec."Cod. Promotor")
                {
                    Visible = false;
                }
                field("Nombre Promotor"; rec."Nombre Promotor")
                {
                }
            }
        }
    }

    actions
    {
    }

    var
        gCodDocente: Code[20];


    procedure RecibeParametro(CodDocente: Code[20])
    begin
        gCodDocente := CodDocente;
    end;
}

