#pragma implicitwith disable
page 76184 "DSNOM Employees Activities"
{
    ApplicationArea = all;
    Caption = 'Employee Activities';
    PageType = CardPart;
    SourceTable = "DSPayroll Cue";

    layout
    {
        area(content)
        {
            cuegroup(Employees)
            {
                Caption = 'Employees';
                field(Cumple; rec."Birthday of the month")
                {
                    Caption = 'Current month birthdays';
                    Image = Calendar;
                }
                field("Male Employees"; rec."Male Employees")
                {
                    Image = Person;
                }
                field("Female Employees"; rec."Female Employees")
                {
                    Image = Person;
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
        /*    FuncionesNom: Codeunit "Funciones Nomina"; */
        Fecha: Record Date;
}

#pragma implicitwith restore

