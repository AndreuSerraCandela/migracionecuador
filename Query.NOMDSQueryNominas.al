query 76060 "NOMDS Query Nominas"
{
    Caption = 'Payroll query';

    elements
    {
        dataitem(Historico_Lin_nomina; "Historico Lin. nomina")
        {
            column(No_empleado; "No. empleado")
            {
            }
            column(Nombre; Nombre)
            {
            }
            column("Período"; "Período")
            {
            }
            column(Tipo_de_nomina; "Tipo de nomina")
            {
            }
            column(Tipo_concepto; "Tipo concepto")
            {
            }
            column("Descripción"; "Descripción")
            {
            }
            column(Total; Total)
            {
            }
            column(Departamento; Departamento)
            {
            }
            column(No_Documento; "No. Documento")
            {
            }
            dataitem(Employee; Employee)
            {
                DataItemLink = "No." = Historico_Lin_nomina."No. empleado";
                column(Company; Company)
                {
                }
                dataitem(Departamentos; Departamentos)
                {
                    DataItemLink = Codigo = Historico_Lin_nomina.Departamento;
                    column(Depto_Descripcion; Descripcion)
                    {
                    }
                    dataitem(Puestos_laborales; "Puestos laborales")
                    {
                        DataItemLink = Codigo = Employee."Job Type Code";
                        column(Cargo_Descripcion; Descripcion)
                        {
                        }
                    }
                }
            }
        }
    }
}

