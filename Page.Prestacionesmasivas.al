page 76356 "Prestaciones masivas"
{
    ApplicationArea = all;
    Caption = 'Bulk settlement calculation';
    PageType = List;
    SourceTable = "Prestaciones masivas";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Cod. Empleado"; rec."Cod. Empleado")
                {
                }
                field("Full name"; rec."Full name")
                {
                }
                field("Document Type"; rec."Document Type")
                {
                }
                field("Document ID"; rec."Document ID")
                {
                }
                field(Departamento; rec.Departamento)
                {
                }
                field("Desc. Departamento"; rec."Desc. Departamento")
                {
                }
                field("Job Type Code"; rec."Job Type Code")
                {
                }
                field("Job Title"; rec."Job Title")
                {
                }
                field("Employment Date"; rec."Employment Date")
                {
                }
                field(Status; rec.Status)
                {
                }
                field("Importe Dias trabajados"; rec."Importe Dias trabajados")
                {
                }
                field("Importe Vacaciones"; rec."Importe Vacaciones")
                {
                }
                field("Importe Preaviso"; rec."Importe Preaviso")
                {
                }
                field("Importe Cesantia"; rec."Importe Cesantia")
                {
                }
                field("Importe Regalia"; rec."Importe Regalia")
                {
                }
                field("Importe Otros"; rec."Importe Otros")
                {
                }
                field("Importe AFP"; rec."Importe AFP")
                {
                }
                field("Importe SFS"; rec."Importe SFS")
                {
                }
                field("Importe ISR"; rec."Importe ISR")
                {
                }
                field("Importe AFP patronal"; rec."Importe AFP patronal")
                {
                }
                field("Importe SFS patronal"; rec."Importe SFS patronal")
                {
                }
                field("Importe SRL"; rec."Importe SRL")
                {
                }
                field("Importe INFOTEP"; rec."Importe INFOTEP")
                {
                }
                field("Grounds for Term. Code"; rec."Grounds for Term. Code")
                {
                }
                field("Termination Date"; rec."Termination Date")
                {
                }
                field(Comentario; rec.Comentario)
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action("Propose bulk settlement calculation")
            {
                Caption = 'Propose bulk settlement calculation';
                Image = CalculateRemainingUsage;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                RunObject = Report "Proponer prestaciones x grupos";
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        rec.CalcularPrestaciones()
    end;
}

