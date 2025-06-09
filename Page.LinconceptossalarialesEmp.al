page 76072 "Lin. conceptos salariales Emp."
{
    ApplicationArea = all;
    Caption = 'Employee profile';
    PageType = ListPart;
    SourceTable = "Perfil Salarial";

    layout
    {
        area(content)
        {
            repeater(Control1100000)
            {
                ShowCaption = false;
                field("Empresa cotizacion"; rec."Empresa cotizacion")
                {
                    Visible = false;
                }
                field("No. empleado"; rec."No. empleado")
                {
                    Visible = false;
                }
                field("Perfil salarial"; rec."Perfil salarial")
                {
                    Visible = false;
                }
                field("Concepto salarial"; rec."Concepto salarial")
                {
                }
                field("Salario Base"; rec."Salario Base")
                {
                }
                field("Currency Code"; rec."Currency Code")
                {
                }
                field(Descripcion; rec.Descripcion)
                {
                }
                field(Cantidad; rec.Cantidad)
                {
                }
                field(Importe; rec.Importe)
                {
                    Editable = ImporteEditable;
                }
                field("1ra Quincena"; rec."1ra Quincena")
                {
                }
                field("2da Quincena"; rec."2da Quincena")
                {
                }
                field("Tipo concepto"; rec."Tipo concepto")
                {
                }
                field("Sujeto Cotizacion"; rec."Sujeto Cotizacion")
                {
                    Visible = false;
                }
                field("% ISR Pago Empleado"; rec."% ISR Pago Empleado")
                {
                    Visible = false;
                }
                field("Cotiza ISR"; rec."Cotiza ISR")
                {
                    Visible = false;
                }
                field("Cotiza AFP"; rec."Cotiza AFP")
                {
                }
                field("Cotiza SFS"; rec."Cotiza SFS")
                {
                }
                field("Cotiza SRL"; rec."Cotiza SRL")
                {
                    Visible = false;
                }
                field("Cotiza INFOTEP"; rec."Cotiza INFOTEP")
                {
                    Visible = false;
                }
                field("Aplica para Regalia"; rec."Aplica para Regalia")
                {
                    Visible = false;
                }
                field("Texto Informativo"; rec."Texto Informativo")
                {
                }
                field(Provisionar; rec.Provisionar)
                {
                    Visible = false;
                }
                field("Formula calculo"; rec."Formula calculo")
                {
                    Editable = false;
                }
                field(Imprimir; rec.Imprimir)
                {
                    Visible = false;
                }
                field("Deducir dias"; rec."Deducir dias")
                {
                    Visible = false;
                }
                field(Status; rec.Status)
                {
                    Visible = false;
                }
                field("Tipo de nomina"; rec."Tipo de nomina")
                {
                }
                field("% Retencion Ingreso Salario"; rec."% Retencion Ingreso Salario")
                {
                    Visible = false;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("&Payroll")
            {
                Caption = '&Payroll';
                action("Dist. by Dimension")
                {
                    Caption = 'Dist. by Dimension';
                    Image = CalculateHierarchy;
                    RunObject = Page "Distribucion ED Empleados";
                    RunPageLink = "Employee no." = FIELD("No. empleado"),
                                  "Concepto salarial" = FIELD("Concepto salarial");
                }
                separator(Action1000000007)
                {
                }
                action(Dimensions)
                {
                    Caption = 'Dimensions';
                    Image = Dimensions;

                    trigger OnAction()
                    begin
                        Dimension;
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        ImporteEditable := true;
        if rec."Formula calculo" <> '' then
            ImporteEditable := false
        else
            if rec."Concepto salarial" = ConfNom."Concepto Sal. Base" then
                ImporteEditable := not ConfNom."Usar Acciones de personal";
    end;

    trigger OnInit()
    begin
        ImporteEditable := true;
    end;

    trigger OnOpenPage()
    begin
        ConfNom.Get();
    end;

    var
        ConfNom: Record "Configuracion nominas";
        ImporteEditable: Boolean;


    procedure Dimension()
    var
        Dimension: Record "Default Dimension";
        DefDimension: Page "Default Dimensions";
    begin
        Dimension.Reset;
        Dimension.SetRange("Table ID", 76061);
        Dimension.SetRange("No.", rec."No. empleado" + rec."Concepto salarial");
        DefDimension.SetTableView(Dimension);
        DefDimension.RunModal;
    end;
}

