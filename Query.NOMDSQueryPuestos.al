query 76000 "NOMDS Query Puestos"
{
    Caption = 'Job position query';

    elements
    {
        dataitem(Puestos_laborales; "Puestos laborales")
        {
            column(Cod_departamento; "Cod. departamento")
            {
            }
            column(Codigo; Codigo)
            {
            }
            column(Descripcion; Descripcion)
            {
            }
            column(Cod_nivel; "Cod. nivel")
            {
            }
            column(Puesto_Supervisor; "Puesto Supervisor")
            {
            }
            column(Desc_puesto_supervisor; "Desc. puesto supervisor")
            {
            }
            column(Maximo_de_posiciones; "Maximo de posiciones")
            {
            }
            column(Total_Empleados; "Total Empleados")
            {
            }
            dataitem(Employee; Employee)
            {
                DataItemLink = "Job Type Code" = Puestos_laborales.Codigo;
                column(Company; Company)
                {
                }
            }
        }
    }
}

