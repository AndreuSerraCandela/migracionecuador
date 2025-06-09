#pragma implicitwith disable
page 76189 "DSNOM Nomina Activities"
{
    ApplicationArea = all;
    Caption = 'Payroll Activities';
    PageType = CardPart;
    SourceTable = "DSPayroll Cue";

    layout
    {
        area(content)
        {
            cuegroup(Payroll)
            {
                Caption = 'Payroll';
                field("Employees with wire transfer"; rec."Employees with wire transfer")
                {
                    Image = Receipt;
                }
                field("Employees with check"; rec."Employees with check")
                {
                    Image = Receipt;
                }
                field(Loans; rec.Loans)
                {
                    Image = Receipt;
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
        /*         FuncionesNom: Codeunit "Funciones Nomina"; */
        Fecha: Record Date;
}

#pragma implicitwith restore

