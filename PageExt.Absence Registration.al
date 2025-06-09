pageextension 50084 pageextension50084 extends "Absence Registration"
{
    //SourceTableView=WHERE(Closed=CONST(No));

    layout
    {
        modify("Unit of Measure Code")
        {
            ToolTip = 'Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.';
        }
        modify("Employee No.")
        {
            trigger OnAfterValidate()
            var
                myInt: Integer;
            begin
                Rec.CalcFields("Full name");
            end;
        }

        addafter("Employee No.")
        {
            field("Full name"; rec."Full name")
            {
                ApplicationArea = All;

                Editable = false;

            }
        }
        addafter(Quantity)
        {
            field("% To deduct"; rec."% To deduct")
            {
                ApplicationArea = All;

            }
        }
    }
    actions
    {
        addfirst("A&bsence")
        {
            action(Vacaciones)
            {
                ApplicationArea = All;

                Caption = 'Post Absence';
                Image = Holiday;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                trigger OnAction()
                var
                    HVacaciones: Record "Historico Vacaciones";
                begin
                    if not Confirm(Text0001) then
                        exit;

                    ConfNom.Get();
                    RegAusencias.SetFilter("Cause of Absence Code", '<>%1', '');
                    RegAusencias.SetRange(Closed, false);
                    if RegAusencias.FindSet(true) then
                        repeat
                            if CausasAusencias.Get(rec."Cause of Absence Code") then begin
                                if CausasAusencias."Cod. concepto salarial" = ConfNom."Concepto Vacaciones" then begin
                                    HVacaciones.Init;
                                    HVacaciones."No. empleado" := rec."Employee No.";
                                    HVacaciones."Fecha Inicio" := rec."From Date";
                                    HVacaciones."Fecha Fin" := rec."To Date";
                                    HVacaciones.Dias := rec.Quantity * -1;
                                    if not HVacaciones.Insert then
                                        HVacaciones.Modify;
                                end;
                            end;
                            RegAusencias.Closed := true;
                            RegAusencias.Modify;
                        until RegAusencias.Next = 0;
                    ;
                end;
            }
            separator(Action1000000002)
            {
            }
        }
    }

    var
        Text0001: Label 'Are you sure you want to post the Vacation manually?';
        ConfNom: Record "Configuracion nominas";
        CausasAusencias: Record "Cause of Absence";
        RegAusencias: Record "Employee Absence";
}

