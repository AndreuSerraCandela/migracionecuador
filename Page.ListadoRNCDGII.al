page 76289 "Listado RNC DGII"
{
    ApplicationArea = all;
    PageType = List;
    SourceTable = "RNC DGII";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("VAT Registration No."; rec."VAT Registration No.")
                {
                }
                field(Name; rec.Name)
                {
                }
                field("Search Name"; rec."Search Name")
                {
                }
                field("Campo 4"; rec."Campo 4")
                {
                    Caption = 'Description';
                }
                field(Estado; rec.Estado)
                {
                    Editable = false;
                }
                field(Tipo; rec.Tipo)
                {
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action("RNC New Dowload")
            {
                Caption = 'RNC New Dowload';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    ConsultasDGII: Codeunit "Validaciones Loc. Guatemala";
                begin
                    /*ConsultasDGII.DescargarListadoRNC;
                    CurrPage.UPDATE;*/ //fes mig

                end;
            }
        }
    }
}

