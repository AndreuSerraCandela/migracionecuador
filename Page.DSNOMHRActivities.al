#pragma implicitwith disable
page 76185 "DSNOM HR Activities"
{
    ApplicationArea = all;
    Caption = 'HR Activities';
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
                    Image = People;
                }
                field("Inactives Employees"; rec."Inactives Employees")
                {
                    Image = People;
                }
                /*          field("FuncionesNom.AniversarioEmpleados"; rec.FuncionesNom.AniversarioEmpleados)
                         {
                             Caption = 'Empl. anniversary';

                             Image = Time;
                             Style = Attention;
                             StyleExpr = TRUE;

                             trigger OnDrillDown()
                             begin
                                 FuncionesNom.MuestraAniversarioEmpl;
                             end;
                         } */
                field("New hires"; rec."New hires")
                {
                    Image = People;
                }
                field("Employee departures"; rec."Employee departures")
                {
                    Image = People;
                }
                field("Contract to expire"; rec."Contract to expire")
                {
                    Enabled = false;
                    Image = People;
                    Visible = false;
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

