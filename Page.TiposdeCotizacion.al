page 76414 "Tipos de Cotizacion"
{
    ApplicationArea = all;
    AdditionalSearchTerms = 'Social Security Setup';
    //ApplicationArea = Basic, Suite, BasicHR;
    Caption = 'SS Setup';
    InstructionalText = 'Configure the values for Social Security';
    PageType = List;
    SourceTable = "Tipos de Cotización";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field(Ano; rec.Ano)
                {
                }
                field("Código"; rec.Código)
                {
                }
                field("Descripción"; rec.Descripción)
                {
                }
                field("Porciento Empresa"; rec."Porciento Empresa")
                {
                }
                field("Porciento Empleado"; rec."Porciento Empleado")
                {
                }
                field("Cuota Empresa"; rec."Cuota Empresa")
                {
                    Visible = false;
                }
                field("Cuota Empleado"; rec."Cuota Empleado")
                {
                    Visible = false;
                }
                field("Base aplicar"; rec."Base aplicar")
                {
                    Visible = false;
                }
                field("Tope Salarial/Acumulado Anual"; rec."Tope Salarial/Acumulado Anual")
                {
                }
                field("Acumula por"; rec."Acumula por")
                {
                }
                field("Porciento Empresa Pensionados"; rec."Porciento Empresa Pensionados")
                {
                    Visible = false;
                }
                field("Porciento Empleado Pensionados"; rec."Porciento Empleado Pensionados")
                {
                    Visible = false;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("&Copy")
            {
                Caption = '&Copy';
                Image = Copy;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    TC.SetRange(Ano, rec.Ano);
                    if TC.FindFirst then
                        repeat
                            TC2.TransferFields(TC);
                            TC2.Ano += 1;
                            if TC2.Insert then;
                        until TC.Next = 0;
                end;
            }
        }
    }

    trigger OnInit()
    begin
        CurrPage.LookupMode := false;
    end;

    var
        TC: Record "Tipos de Cotización";
        TC2: Record "Tipos de Cotización";
}

