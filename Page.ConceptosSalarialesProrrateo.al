#pragma implicitwith disable
page 76150 "Conceptos Salariales Prorrateo"
{
    ApplicationArea = all;
    DataCaptionFields = "Código";
    PageType = List;
    SourceTable = "Conceptos Salariales Provision";

    layout
    {
        area(content)
        {
            repeater(Control1100000)
            {
                ShowCaption = false;
                field("Código"; rec.Código)
                {
                    Editable = false;
                    Visible = false;
                }
                field("Tipo provision"; rec."Tipo provision")
                {
                }
                field("Gpo. Contable Empleado"; rec."Gpo. Contable Empleado")
                {
                    Visible = false;
                }
                field("Fórmula cálculo"; rec."Fórmula cálculo")
                {
                }
                field("No. Cuenta"; rec."No. Cuenta")
                {
                }
                field("No. Cuenta Contrapartida"; rec."No. Cuenta Contrapartida")
                {
                }
                field("Validar Contrapartida"; rec."Validar Contrapartida")
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
        ConceptoSal.SetRange(Codigo, Rec."Código");
        ConceptoSal.FindFirst;
        ConceptoSal.TestField(Provisionar);
    end;

    var
        ConceptoSal: Record "Conceptos salariales";
}

#pragma implicitwith restore

