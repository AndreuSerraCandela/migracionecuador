#pragma implicitwith disable
page 76123 "Cab. prestamos cooperativa"
{
    ApplicationArea = all;
    Caption = 'Cooperative loan header';
    PageType = Card;
    SourceTable = "Cab. Prestamos cooperativa";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("No. Prestamo"; rec."No. Prestamo")
                {

                    trigger OnAssistEdit()
                    begin
                        if Rec.AssistEdit() then
                            CurrPage.Update;
                    end;
                }
                field("Employee No."; rec."Employee No.")
                {
                    TableRelation = Employee;
                }
                field("Full name"; rec."Full name")
                {
                }
                field("No. afiliado"; rec."No. afiliado")
                {
                }
                field("Tipo de miembro"; rec."Tipo de miembro")
                {
                    Editable = false;
                }
                field("Tipo prestamo"; rec."Tipo prestamo")
                {
                }
                field("% Interes"; rec."% Interes")
                {
                }
                field(Importe; rec.Importe)
                {
                }
                field("Cantidad de Cuotas"; rec."Cantidad de Cuotas")
                {
                }
                field("Fecha Inicio Deduccion"; rec."Fecha Inicio Deduccion")
                {
                }
                field("Concepto Salarial"; rec."Concepto Salarial")
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
            }
            part(Control1000000018; "Lin. prestamos cooperativa")
            {
                SubPageLink = "No. Prestamo" = FIELD("No. Prestamo");
                SubPageView = SORTING("No. Prestamo", "No. Cuota");
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("Calculate fee")
            {
                Caption = 'Calculate fee';
                action(Action1000000015)
                {
                    Caption = 'Calculate fee';
                    Image = Calculate;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    PromotedOnly = true;

                    trigger OnAction()
                    begin
                        FuncCoop.CrearCuotasCoop(Rec);
                    end;
                }
                separator(Action1000000019)
                {
                }
                action(Post)
                {
                    Caption = 'Post';
                    Image = Post;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    PromotedOnly = true;

                    trigger OnAction()
                    begin
                        FuncCoop.RegistrarPrestCoop(Rec);
                    end;
                }
            }
        }
    }

    var
        FuncCoop: Codeunit "Funciones cooperativa";
}

#pragma implicitwith restore

