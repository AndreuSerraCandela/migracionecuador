pageextension 50071 pageextension50071 extends "Contact List"
{
    layout
    {
        modify("Post Code")
        {
            ToolTip = 'Specifies the ZIP Code.';
        }
        moveafter("Language Code"; "Search Name")

        addafter("Language Code")
        {
            field(City; rec.City)
            {
                ApplicationArea = Basic, Suite;
            }
            field("Región"; rec.Región)
            {
                ApplicationArea = Basic, Suite;
            }
            field("Nombre Región"; rec."Nombre Región")
            {
                ApplicationArea = Basic, Suite;
            }
            field(County; rec.County)
            {
                ApplicationArea = Basic, Suite;
            }
            field(Zona; rec.Zona)
            {
                ApplicationArea = Basic, Suite;
            }
            field("VAT Registration No."; rec."VAT Registration No.")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
            field("Address 2"; rec."Address 2")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Codigo Modular"; rec."Codigo Modular")
            {
                ApplicationArea = Basic, Suite;
            }
        }
        addafter("Parental Consent Received")
        {
            field("Colegio SIC"; rec."Colegio SIC")
            {
            ApplicationArea = All;
            }
        }
    }
    actions
    {
        modify(NewSalesQuote)
        {
            ToolTip = 'Offer items or services to a customer.';
        }
        addafter(History)
        {
            group("<Action1000000001>")
            {
                Caption = '&School';
                action("<Action1000000002>")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = '&Teachers';
                    RunObject = Page "Lista Colegio - Docentes";
                    RunPageLink = "Cod. Colegio" = FIELD("No.");
                }
                action("<Action1000000000>")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = '&Grades';
                    Image = GetLines;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    RunObject = Page "Colegio - Grados";
                    RunPageLink = "Cod. Colegio" = FIELD("No.");
                }
                action("<Action1000000003>")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = '&Levels';
                    Image = Allocations;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        rec.TestField(City);
                        rec.TestField(County);
                        rec.TestField("Post Code");
                        PageColNivel.RecibeParametros(rec."No.", rec.City, rec.County, rec."Post Code");
                        PageColNivel.RunModal;
                        Clear(PageColNivel);
                    end;
                }
                action("<Action1000000040>")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Rank by Level';
                    Image = AdjustEntries;
                    Promoted = true;
                    PromotedCategory = Category4;
                    RunObject = Page "Colegio - Ranking - Nivel";
                    RunPageLink = "Cod. Colegio" = FIELD("No.");
                }
                action("<Action1000000004>")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = '&Adoptions';
                    RunObject = Page "Colegio - Adopciones";
                    RunPageLink = "Cod. Colegio" = FIELD("No.");
                }
                separator(Action1000000004)
                {
                }
                action("<Action1000000013>")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Search Related Customers';
                    Image = Link;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        Cust.SetRange("Primary Contact No.", rec."No.");
                        if Cust.FindFirst then
                            FuncionesSantillana.MuestraCtes(Cust);
                    end;
                }
                action("<Action1000000046>")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = '&Solicitud de Asistencia Técnica';
                    RunObject = Page "Lista Solicitudes T&E";
                    RunPageLink = "Cod. Colegio" = FIELD("No.");
                }
                separator(Action1000000001)
                {
                }
                action("<Action1000000006>")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = '&Estructura de puestos';
                    RunObject = Page "Colegio - Personal Jerarquico";
                    RunPageLink = "Cod. Colegio" = FIELD("No.");
                }
            }
        }
    }

    var
        PageColNivel: Page "Colegio - Nivel";
        FuncionesSantillana: Codeunit "Funciones Santillana";
        Cust: Record Customer;
}

