page 76049 "Config. acciones personal"
{
    ApplicationArea = all;
    Caption = 'Reason personnel action';
    PageType = List;
    SourceTable = "Tipos de acciones personal";

    layout
    {
        area(content)
        {
            repeater(Control1000000004)
            {
                ShowCaption = false;
                field("Tipo de accion"; rec."Tipo de accion")
                {
                }
                field(Codigo; rec.Codigo)
                {
                }
                field(Descripcion; rec.Descripcion)
                {
                }
                field("Emitir documento"; rec."Emitir documento")
                {
                    Visible = false;
                }
                field("ID Documento"; rec."ID Documento")
                {
                    Visible = false;
                }
                field("Pagar preaviso"; rec."Pagar preaviso")
                {
                    Visible = false;
                }
                field("Pagar cesantia"; rec."Pagar cesantia")
                {
                    Visible = false;
                }
                field("Pagar regalia"; rec."Pagar regalia")
                {
                    Caption = 'Staff actions Setup';
                    Visible = false;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Authorizations)
            {
                Caption = 'Authorizations';
                action(Config)
                {
                    Caption = 'Setup Actions';
                    Image = Setup;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page "Tipos de acciones de personal";
                    RunPageLink = "Tipo de accion" = FIELD ("Tipo de accion");
                }
            }
        }
    }

    var
        Text19014587: Label 'Dynasoft S.A.\Dominican Republic \Contact: guillermo.roman@dynasoftsolutions.com \Phone: (809)848-1149';
}

