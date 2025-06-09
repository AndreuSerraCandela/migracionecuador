xmlport 58013 "cta Empleados"
{
    Format = VariableText;

    schema
    {
        textelement(ImpCtaEmpleados)
        {
            tableelement(Integer; Integer)
            {
                AutoReplace = false;
                AutoSave = false;
                AutoUpdate = false;
                XmlName = 'CtaEmpleados';
                textelement(CodEmpl)
                {
                }
                textelement(ctaban)
                {
                }

                trigger OnBeforeInsertRecord()
                begin

                    DistCta."Cod. Banco" := '017';
                    DistCta."No. empleado" := CodEmpl;
                    DistCta."Tipo Cuenta" := 1;
                    DistCta."Numero Cuenta" := ctaban;
                    if DistCta.Insert then;
                end;
            }
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    var
        DistCta: Record "Distrib. Ingreso Pagos Elect.";
}

