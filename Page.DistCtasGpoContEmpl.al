#pragma implicitwith disable
page 76002 "Dist. Ctas. Gpo. Cont. Empl."
{
    ApplicationArea = all;
    PageType = List;
    SourceTable = "Dist. Ctas. Gpo. Cont. Empl.";

    layout
    {
        area(content)
        {
            repeater(Control1100000)
            {
                ShowCaption = false;
                field("Shortcut Dimension"; rec."Shortcut Dimension")
                {
                    Visible = false;
                }
                field("Código Concepto Salarial"; rec."Código Concepto Salarial")
                {
                }
                field("Código"; rec.Código)
                {
                    Visible = false;
                }
                field("Descripción"; rec.Descripción)
                {
                    Editable = false;
                    Visible = false;
                }
                field("% a Distribuir"; rec."% a Distribuir")
                {
                }
                field("Tipo Cuenta Cuota Obrera"; rec."Tipo Cuenta Cuota Obrera")
                {
                }
                field("No. Cuenta Cuota Obrera"; rec."No. Cuenta Cuota Obrera")
                {
                }
                field("Tipo Cuenta Contrapartida CO"; rec."Tipo Cuenta Contrapartida CO")
                {
                }
                field("No. Cuenta Contrapartida CO"; rec."No. Cuenta Contrapartida CO")
                {
                }
                field("Tipo Cuenta Cuota Patronal"; rec."Tipo Cuenta Cuota Patronal")
                {
                }
                field("No. Cuenta Cuota Patronal"; rec."No. Cuenta Cuota Patronal")
                {
                }
                field("Tipo Cuenta Contrapartida CP"; rec."Tipo Cuenta Contrapartida CP")
                {
                }
                field("No. Cuenta Contrapartida CP"; rec."No. Cuenta Contrapartida CP")
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Action")
            {
                Caption = '&Action';
                action("&Copy all")
                {
                    Caption = '&Copy all';
                    Image = CopyFromChartOfAccounts;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        NoLin: Integer;
                    begin
                        ConfNominas.Get();
                        ConceptosSal.SetRange("Dimension Nomina", ConfNominas."Dimension Conceptos Salariales");
                        if ConceptosSal.Find('-') then
                            repeat
                                NoLin += 1000;
                                Rec."Shortcut Dimension" := ConceptosSal."Dimension Nomina";
                                Rec."Código Concepto Salarial" := ConceptosSal.Codigo;
                                Rec."Descripción" := ConceptosSal.Descripcion;
                                Rec."Tipo Cuenta Cuota Obrera" := ConceptosSal."Tipo Cuenta Cuota Obrera";
                                Rec."Tipo Cuenta Cuota Patronal" := ConceptosSal."Tipo Cuenta Cuota Patronal";
                                Rec."No. Cuenta Cuota Patronal" := ConceptosSal."No. Cuenta Cuota Patronal";
                                Rec."No. Linea" := NoLin;
                                Rec.Insert;
                            until ConceptosSal.Next = 0;
                    end;
                }
                separator(Action1000000004)
                {
                }
                action(Dimensions)
                {
                    Caption = 'Dimentions';
                    Image = Dimensions;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        Dimension;
                    end;
                }
            }
        }
        area(processing)
        {
            action("&Prorrated Wedges")
            {
                Caption = '&Prorrated Wedges';
                Image = SetupPayment;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "Conceptos Salariales Prorrateo";
                RunPageLink = "Código" = FIELD("Código Concepto Salarial"),
                              "Gpo. Contable Empleado" = FIELD("Código");
            }
        }
    }

    var
        ConfNominas: Record "Configuracion nominas";
        ConceptosSal: Record "Conceptos salariales";


    procedure Dimension()
    var
        Dimension: Record "Default Dimension";
        DefDimension: Page "Default Dimensions";
    begin
        Dimension.Reset;
        Dimension.SetRange("Table ID", 76053);
        Dimension.SetRange("No.", Rec."Código" + Rec."Código Concepto Salarial");
        DefDimension.SetTableView(Dimension);
        DefDimension.RunModal;
    end;
}

#pragma implicitwith restore

