page 76010 "Lista historico nóminas"
{
    ApplicationArea = all;
    CardPageID = "Historico Cab. Nóminas";
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Historico Cab. nomina";
    SourceTableView = SORTING("No. empleado", Ano, "Período")
                      ORDER(Descending);

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("No. empleado"; rec."No. empleado")
                {
                }
                field("Empresa cotización"; rec."Empresa cotización")
                {
                }
                field("Full name"; rec."Full name")
                {
                }
                field(Cargo; rec.Cargo)
                {
                }
                field("Tipo de nomina"; rec."Tipo de nomina")
                {
                }
                field("Período"; rec.Período)
                {
                }
                field(Fin; rec.Fin)
                {
                    Visible = false;
                }
                field("Total Ingresos"; rec."Total Ingresos")
                {
                }
                field("Total deducciones"; rec."Total deducciones")
                {
                }
                field("Forma de Cobro"; rec."Forma de Cobro")
                {
                }
                field(Departamento; rec.Departamento)
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Nómina")
            {
                Caption = '&Nómina';
                action("Calculate payroll")
                {
                    Caption = 'Calculate payroll';
                    Image = Post;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Report "Registrar nóminas por lotes";

                    trigger OnAction()
                    begin
                        CurrPage.Update(true);
                    end;
                }
                action("Post to Journal")
                {
                    Caption = 'Post to Journal';
                    Ellipsis = true;
                    Image = PostInventoryToGL;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Report "Contabilizar Nominas - new";
                }
                separator(Action43)
                {
                }
                action(Statistics)
                {
                    Caption = 'Statistics';
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
            }
        }
        area(processing)
        {
            action(Print)
            {
                Caption = 'Print';
                Image = Print;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                begin
                    Modelorecibsalario.Run(Rec);
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        if Emp.Get(rec."No. empleado") then
            CurrPage.Caption := Emp."Full Name";
    end;

    var
        Emp: Record Employee;
        Modelorecibsalario: Codeunit "Modelo recib.salario";
}

