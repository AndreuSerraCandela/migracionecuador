#pragma implicitwith disable
page 76067 "Historico Cab. Nóminas"
{
    ApplicationArea = all;
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = Document;
    SourceTable = "Historico Cab. nomina";
    SourceTableView = SORTING(Ano, "Período", "No. empleado");

    layout
    {
        area(content)
        {
            label(Control24)
            {
                CaptionClass = Format('Filtros : ' + Rec.GetFilters);
                Editable = false;
                ShowCaption = false;
            }
            group(General)
            {
                Caption = 'General';
                field("No. empleado"; rec."No. empleado")
                {
                    Editable = false;
                    Importance = Promoted;
                }
                field("Full name"; rec."Full name")
                {
                    Editable = false;
                    Importance = Promoted;
                }
                field("Centro trabajo"; rec."Centro trabajo")
                {
                    Editable = false;
                }
                field(Inicio; rec.Inicio)
                {
                    Editable = false;
                    Importance = Promoted;
                }
                field(Fin; rec.Fin)
                {
                    Editable = false;
                    Importance = Promoted;
                }
                field("Tipo Empleado"; rec."Tipo Empleado")
                {
                    Editable = false;
                }
                field("Tipo de nomina"; rec."Tipo de nomina")
                {
                    Editable = false;
                }
                field("Tipo Nomina"; rec."Tipo Nomina")
                {
                    Editable = false;
                }
                field("Fecha Entrada"; rec."Fecha Entrada")
                {
                    Editable = false;
                }
                field("Fecha Salida"; rec."Fecha Salida")
                {
                    Editable = false;
                }
                field("Shortcut Dimension 1 Code"; rec."Shortcut Dimension 1 Code")
                {
                    Editable = false;
                }
                field("Shortcut Dimension 2 Code"; rec."Shortcut Dimension 2 Code")
                {
                    Editable = false;
                }
            }
            part(HistLinNom; "Historico lineas nomina")
            {
                SubPageLink = "No. empleado" = FIELD("No. empleado"),
                              "Tipo de nomina" = FIELD("Tipo de nomina"),
                              "Período" = FIELD("Período");
            }
            group(Bases)
            {
                Caption = 'Bases';
                field("Base ISR"; rec."Base ISR")
                {
                    Caption = 'Base ISR';
                    Editable = false;
                }
                field("Total Ingresos"; rec."Total Ingresos")
                {
                    Caption = 'Total Ingresos';
                    Editable = false;
                }
                field("Total deducciones"; rec."Total deducciones")
                {
                    Editable = false;
                }
                field("Forma de Cobro"; rec."Forma de Cobro")
                {
                    Editable = false;
                }
                field("Tipo Cuenta"; rec."Tipo Cuenta")
                {
                    Editable = false;
                }
                field(Cuenta; rec.Cuenta)
                {
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Payroll")
            {
                Caption = '&Payroll';
                action(Statistic)
                {
                    Caption = 'Statistic';
                    Image = Statistics;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page "Visualizar nómina histórico";
                    RunPageLink = "No. Documento" = FIELD("No. Documento"),
                                  "No. empleado" = FIELD("No. empleado"),
                                  "Tipo de nomina" = FIELD("Tipo de nomina"),
                                  "Período" = FIELD("Período");
                    ShortCutKey = 'F7';
                }
                action(Dimensions)
                {
                    Caption = 'Dimensions';
                    Image = Dimensions;

                    trigger OnAction()
                    begin
                        Rec.ShowDimensions;
                    end;
                }
                separator(Action46)
                {
                }
                action("<Action83>$")
                {
                    Caption = 'Batch voids';
                    Image = Cancel;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    RunObject = Report "Anular nóminas por lotes";

                    trigger OnAction()
                    begin
                        CurrPage.Update;
                    end;
                }
            }
            separator(Action1000000000)
            {
            }
            action(editar)
            {
                Enabled = false;
                Visible = false;

                trigger OnAction()
                begin
                    CurrPage.Editable := true;
                end;
            }
        }
        area(processing)
        {
            action("P&rint")
            {
                Caption = 'P&rint';
                Image = Print;
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Codeunit "Modelo recib.salario";
            }
        }
    }

    var
        RegEmpCotizacion: Record "Empresas Cotizacion";
        TipoEmpleado: Option Fijos,Temporales,Otros,Todos;
}

#pragma implicitwith restore

