page 76418 "Tipos de nominas"
{
    ApplicationArea = all;
    AdditionalSearchTerms = 'Payroll type';
    //ApplicationArea = Basic, Suite, BasicHR;
    Caption = 'Payroll type';
    PageType = List;
    SourceTable = "Tipos de nominas";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                ShowCaption = false;
                field(Codigo; rec.Codigo)
                {
                }
                field(Descripcion; rec.Descripcion)
                {
                }
                field("Frecuencia de pago"; rec."Frecuencia de pago")
                {
                }
                field("Validar contrato"; rec."Validar contrato")
                {
                    Visible = false;
                }
                field("Tipo de nomina"; rec."Tipo de nomina")
                {
                }
                field("Incluir salario"; rec."Incluir salario")
                {
                    Visible = false;
                }
                field("Cotiza ISR"; rec."Cotiza ISR")
                {
                    Visible = false;
                }
                field("Cotiza AFP"; rec."Cotiza AFP")
                {
                    Visible = false;
                }
                field("Cotiza SFS"; rec."Cotiza SFS")
                {
                    Visible = false;
                }
                field("Cotiza INFOTEP"; rec."Cotiza INFOTEP")
                {
                    Visible = false;
                }
                field("Cotiza SRL"; rec."Cotiza SRL")
                {
                    Visible = false;
                }
                field("Dia inicio 1ra"; rec."Dia inicio 1ra")
                {
                    Visible = false;
                }
                field("Dia inicio 2da"; rec."Dia inicio 2da")
                {
                    Visible = false;
                }
                field("Calcular ISR Mes en Bonific"; rec."Calcular ISR Mes en Bonific")
                {
                    Visible = false;
                }
            }
        }
    }

    actions
    {
    }
}

