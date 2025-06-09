pageextension 50070 pageextension50070 extends "Contact Card"
{
    layout
    {
        /*modify("Last Date Modified") //nuevo campo validar y traer funcionalidad de nav
        {
            Visible = false;
        }*/
        modify("Date of Last Interaction")
        {
            Visible = false;
        }
        modify("Last Date Attempted")
        {
            Visible = false;
        }
        modify("Next Task Date")
        {
            Visible = false;
        }
        modify("Post Code")
        {
            ToolTip = 'Specifies the ZIP Code.';
        }
        moveafter("Post Code"; City)

        addafter("Parental Consent Received")
        {
            field("Colegio Activo"; rec."Colegio Activo")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Codigo Modular"; rec."Codigo Modular")
            {
                ApplicationArea = Basic, Suite;
            }
        }
        addafter("Post Code")
        {
            field("Región"; rec.Región)
            {
            ApplicationArea = All;
            }
            field(Zona; rec.Zona)
            {
            ApplicationArea = All;
            }
        }
        addafter(Control37)
        {
            field("Samples Location Code"; rec."Samples Location Code")
            {
            ApplicationArea = All;
            }
        }
        addafter("Foreign Trade")
        {
            group(Santillana)
            {
                Caption = 'Santillana';
                field("% Descuento Cupon"; rec."% Descuento Cupon")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Canal de compra"; rec."Canal de compra")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Nombre canal"; rec."Nombre canal")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Microempresario; rec.Microempresario)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Comisionista; rec.Comisionista)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Orden religiosa"; rec."Orden religiosa")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Asociacion Educativa"; rec."Asociacion Educativa")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Pension INI"; rec."Pension INI")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Pension PRI"; rec."Pension PRI")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Pension SEC"; rec."Pension SEC")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Pension BA"; rec."Pension BA")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Tipo de colegio"; rec."Tipo de colegio")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Tipo educacion"; rec."Tipo educacion")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Fecha decision"; rec."Fecha decision")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Periodo; rec.Periodo)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Bilingue; rec.Bilingue)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Ruta; rec.Ruta)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Grupo; rec.Grupo)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Fecha Aniversario"; rec."Fecha Aniversario")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Importe Pension INI"; rec."Importe Pension INI")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Importe Pension PRI"; rec."Importe Pension PRI")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Importe Pension SEC"; rec."Importe Pension SEC")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Importe Pension BA"; rec."Importe Pension BA")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
        }
    }
    actions
    {
        modify("Oppo&rtunities")
        {
            ToolTip = 'View the sales opportunities that are handled by salespeople for the contact. Opportunities must involve a contact and can be linked to campaigns.';
        }

        moveafter("Online Map"; "Office Customer/Vendor")

        addafter("Online Map")
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
                    PromotedCategory = Process;
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
                separator(Action1000000008)
                {
                }
                action("<Action1000000046>")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = '&Gift';
                    RunObject = Page "Atenciones Colegios";
                    RunPageLink = "Cod. Colegio" = FIELD("No.");
                }
                action("<Action1000000036>")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = '&Events';
                }
                action("<Action1000000047>")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = '&Training';
                }
                separator(Action1000000004)
                {
                }
                action("<Action1000000050>")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = '&Fathers';
                }
                action("<Action1000000051>")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = '&Students';
                }
                separator(Action1000000001)
                {
                }
                action("<Action1000000006>")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = '&Estructura de puestos';
                    RunObject = Page "Colegio - Personal J. subform";
                    RunPageLink = "Cod. Colegio" = FIELD("No.");
                }
            }
        }
    }

    var
        PageColNivel: Page "Colegio - Nivel";
}

