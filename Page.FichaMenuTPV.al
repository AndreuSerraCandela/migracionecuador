#pragma implicitwith disable
page 76025 "Ficha Menu TPV"
{
    ApplicationArea = all;
    DelayedInsert = true;
    SourceTable = "Menus TPV";

    layout
    {
        area(content)
        {
            group("Información :")
            {
                Visible = wPagos;
                field(wText; wText)
                {
                    Editable = false;
                    MultiLine = false;
                    Style = Attention;
                    StyleExpr = TRUE;
                }
            }
            group("Confguración :")
            {
                field("Menu ID"; Rec."Menu ID")
                {
                }
                field(Descripcion; Rec.Descripcion)
                {
                }
                field("Tipo Menu"; Rec."Tipo Menu")
                {
                    BlankZero = true;

                    trigger OnValidate()
                    begin
                        CurrPage.Update;
                    end;
                }
                field("Cantidad de botones"; Rec."Cantidad de botones")
                {
                    BlankZero = true;
                    Editable = false;
                }
            }
            part(Lineas; "SubLista - Botones Menu TPV")
            {
                SubPageLink = "ID Menu" = FIELD("Menu ID");
            }
        }
    }

    actions
    {
    }

    trigger OnInit()
    var

        Error001: Label 'Función Sólo Disponible en Servidor Central';
    begin


    end;

    trigger OnOpenPage()
    begin

        wPagos := (Rec."Tipo Menu" = Rec."Tipo Menu"::Pagos);
        wText := Text001;
        Rec.CalcFields("Cantidad de botones");
    end;

    var
        wPagos: Boolean;
        Text001: Label ' Efectivo Local y Tarjeta se añaden automáticamente en el TPV';
        wText: Text[250];
}

#pragma implicitwith restore

