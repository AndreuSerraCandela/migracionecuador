#pragma implicitwith disable
page 76181 "DSNOM Activities"
{
    ApplicationArea = all;
    PageType = CardPart;
    SourceTable = "DSPayroll Cue";

    layout
    {
        area(content)
        {
            cuegroup("Human Resource")
            {
                Caption = 'Human Resource';
                field("Active Employees"; rec."Active Employees")
                {
                }
                field("Inactives Employees"; rec."Inactives Employees")
                {
                }
                field("New hires"; rec."New hires")
                {
                }
                field("Employee departures"; rec."Employee departures")
                {
                }
                field("Contract to expire"; rec."Contract to expire")
                {
                }
            }
            cuegroup(Employees)
            {
                Caption = 'Employees';
                field(Cumple; rec."Birthday of the month")
                {
                    Caption = 'Current month birthdays';
                }
                field("Male Employees"; rec."Male Employees")
                {
                }
                field("Female Employees"; rec."Female Employees")
                {
                }
            }
            cuegroup(Vacation)
            {
                Caption = 'Vacation';
                /*          field("FuncionesNom.VacacionesporVencer"; rec.FuncionesNom.VacacionesporVencer)
                         {
                             Caption = 'vacation to expire';

                             Image = Calendar;

                             trigger OnDrillDown()
                             begin

                             end;
                         } */
                field("Vacation to start"; rec."Vacation to start")
                {
                    Image = Calendar;
                }
                field("Vacation to finish"; rec."Vacation to finish")
                {
                    Image = Calendar;
                }
            }
            cuegroup(Payroll)
            {
                Caption = 'Payroll';
                field("Employees with wire transfer"; rec."Employees with wire transfer")
                {
                }
                field("Employees with check"; rec."Employees with check")
                {
                }
                field(Loans; rec.Loans)
                {
                }
            }
            cuegroup(Cooperative)
            {
                Caption = 'Cooperative';
                field("Afiliados cooperativa"; rec."Afiliados cooperativa")
                {
                }
                field("Miembros activos"; rec."Miembros activos")
                {
                }
                field("Miembros inactivos"; rec."Miembros inactivos")
                {
                }
                field("Prestamos activos"; rec."Prestamos activos")
                {
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

        Fecha: Record Date;
}

#pragma implicitwith restore

