#pragma implicitwith disable
page 76117 "Cab. Hist. prest. cooperativa"
{
    ApplicationArea = all;
    Caption = 'Posted Cooperative Loans Header';
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = Card;
    SourceTable = "Hist. Cab. Prest. cooperativa";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("No. Prestamo"; rec."No. Prestamo")
                {
                }
                field("Employee No."; rec."Employee No.")
                {
                }
                field("Full name"; rec."Full name")
                {
                }
                field("Tipo de miembro"; rec."Tipo de miembro")
                {
                }
                field("Tipo prestamo"; rec."Tipo prestamo")
                {
                }
                field(Importe; rec.Importe)
                {
                }
                field("% Interes"; rec."% Interes")
                {
                }
                field("Cantidad de Cuotas"; rec."Cantidad de Cuotas")
                {
                }
                field("Concepto Salarial"; rec."Concepto Salarial")
                {
                }
                field("Fecha Inicio Deduccion"; rec."Fecha Inicio Deduccion")
                {
                }
                field("1ra Quincena"; rec."1ra Quincena")
                {
                }
                field("2da Quincena"; rec."2da Quincena")
                {
                }
                field("Motivo Prestamo"; rec."Motivo Prestamo")
                {
                }
                field("Importe Pendiente"; rec."Importe Pendiente")
                {
                    Style = StrongAccent;
                    StyleExpr = TRUE;
                }
                field(Pendiente; rec.Pendiente)
                {
                }
                field("Motivo de cierre"; rec."Motivo de cierre")
                {
                }
            }
            part("Cooperative loans lines"; "Lin. Hist. prest. cooperativa")
            {
                Caption = 'Cooperative loans lines';
                SubPageLink = "No. Prestamo" = FIELD("No. Prestamo");
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Loan)
            {
                Caption = 'Loan';
                action("Pause fee")
                {
                    Caption = 'Pause fee';
                    Image = Pause;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    PromotedOnly = true;

                    trigger OnAction()
                    begin
                        if not Confirm(Msg001, false) then
                            exit;

                        if Rec.Status = Rec.Status::Pausado then
                            exit;

                        Rec.Status := Rec.Status::Pausado;
                        Rec."Fecha de pausa" := Today;
                        Rec.Modify
                    end;
                }
                action("Activate fee")
                {
                    Caption = 'Activate fee';
                    Image = ActivateDiscounts;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    PromotedOnly = true;

                    trigger OnAction()
                    begin
                        if Rec.Status <> Rec.Status::Pausado then
                            exit;

                        Rec.Status := Rec.Status::Activo;
                        Rec."Fecha de pausa" := 0D;
                        Rec.Modify
                    end;
                }
            }
        }
    }

    var
        Msg001: Label 'If you put the loan on pause, the system will not calculate the discount for the fe payment in the next payroll. \ Do you want to continue?';
}

#pragma implicitwith restore

