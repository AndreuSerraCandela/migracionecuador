#pragma implicitwith disable
page 76193 "DSNOM Vacaciones Activities"
{
    ApplicationArea = all;
    Caption = 'Vacation''s Activities';
    PageType = CardPart;
    SourceTable = "DSPayroll Cue";

    layout
    {
        area(content)
        {
            cuegroup(Vacation)
            {
                Caption = 'Vacation';
                /*                 field("FuncionesNom.VacacionesporVencer"; rec.FuncionesNom.VacacionesporVencer)
                                {
                                    Caption = 'vacation to expire';

                                    Image = Calendar;

                                    trigger OnDrillDown()
                                    begin
                                        FuncionesNom.MuestraVacporVencer;
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

