#pragma implicitwith disable
page 76254 "Histórico Lin. Impuestos"
{
    ApplicationArea = all;
    AutoSplitKey = true;
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    PageType = ListPart;
    SourceTable = "Lin. Aportes Empresas";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("No. Documento"; rec."No. Documento")
                {
                    Visible = false;
                }
                field("Empresa cotización"; rec."Empresa cotización")
                {
                    Visible = false;
                }
                field("No. Empleado"; rec."No. Empleado")
                {
                }
                field("Apellidos y Nombre"; rec."Apellidos y Nombre")
                {
                    Editable = false;
                }
                field("Período"; rec.Período)
                {
                    Visible = false;
                }
                field("Concepto Salarial"; rec."Concepto Salarial")
                {
                    Editable = false;
                }
                field(Descripcion; rec.Descripcion)
                {
                    Editable = false;
                }
                field("% Cotizable"; rec."% Cotizable")
                {
                    Editable = false;
                }
                field("Base Imponible"; rec."Base Imponible")
                {
                }
                field(Importe; rec.Importe)
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("&Line")
            {
                Caption = '&Line';
                action(Action1903306504)
                {
                    Caption = 'Dimensiones';
                    ShortCutKey = 'Shift+Ctrl+D';

                    trigger OnAction()
                    begin
                        //This functionality was copied from page #76251. Unsupported part was commented. Please check it.
                        /*CurrPage.HistLinNom.FORM.*/
                        _ShowDimensions;

                    end;
                }
            }
        }
    }


    procedure _ShowDimensions()
    begin
        Rec.ShowDimensions;
    end;


    /*procedure ShowDimensions()
    begin
        Rec.ShowDimensions;
    end;*/
}

#pragma implicitwith restore

