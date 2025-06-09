#pragma implicitwith disable
page 76183 "DSNOM Cooperativa Activities"
{
    ApplicationArea = all;
    Caption = 'Employee fund''s activities';
    PageType = CardPart;
    SourceTable = "DSPayroll Cue";

    layout
    {
        area(content)
        {
            cuegroup(Cooperative)
            {
                Caption = 'Cooperative';
                field("Afiliados cooperativa"; rec."Afiliados cooperativa")
                {
                    Image = People;
                }
                field("Miembros activos"; rec."Miembros activos")
                {
                    Image = Person;
                }
                field("Miembros inactivos"; rec."Miembros inactivos")
                {
                    Image = Person;
                }
                field("Prestamos activos"; rec."Prestamos activos")
                {
                    Image = Cash;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        Rec.Reset;
        if not Rec.Get then begin
            Rec.Init;
            Rec.Insert;
        end;

        Fecha.Reset;
        Fecha.SetRange("Period Start", DMY2Date(1, Date2DMY(WorkDate, 2), Date2DMY(WorkDate, 3)));
        Fecha.SetRange("Period Type", Fecha."Period Type"::Month);
        Fecha.FindFirst;
        Rec.SetRange("Date Filter", Fecha."Period Start", Fecha."Period End");

        Rec.SetRange("Birth Month filter", Date2DMY(WorkDate, 2));
    end;

    var
        /*        FuncionesNom: Codeunit "Funciones Nomina"; */
        Fecha: Record Date;
}

#pragma implicitwith restore

