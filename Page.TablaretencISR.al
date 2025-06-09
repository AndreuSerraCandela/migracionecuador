page 76409 "Tabla retenc. ISR"
{
    ApplicationArea = all;
    AdditionalSearchTerms = 'Income Tax Setup';
    //ApplicationArea = Basic, Suite, BasicHR;
    Caption = 'Income Tax Setup';
    InstructionalText = 'Configuration of parameters for the income tax scale';
    PageType = List;
    SourceTable = "Tabla retencion ISR";
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
                field("No. orden"; rec."No. orden")
                {
                }
                field("Importe Máximo"; rec."Importe Máximo")
                {
                }
                field("Importe retención"; rec."Importe retención")
                {
                }
                field("% Retención"; rec."% Retención")
                {
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
                    ISR.SetRange(Ano, rec.Ano);
                    if ISR.FindFirst then
                        repeat
                            ISR2.TransferFields(ISR);
                            ISR2.Ano := IncStr(ISR2.Ano);
                            if ISR2.Insert then;
                        until ISR.Next = 0;
                end;
            }
        }
    }

    var
        ISR: Record "Tabla retencion ISR";
        ISR2: Record "Tabla retencion ISR";
}

