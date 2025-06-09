query 76200 "NOMDS HR Query"
{
    Caption = 'HR Query';

    elements
    {
        dataitem(Employee; Employee)
        {
            column(Company; Company)
            {
            }
            column(No; "No.")
            {
            }
            column(Full_Name; "Full Name")
            {
            }
            column(Job_Title; "Job Title")
            {
            }
            column(Birth_Date; "Birth Date")
            {
            }
            column(Gender; Gender)
            {
            }
            column(Emplymt_Contract_Code; "Emplymt. Contract Code")
            {
            }
            column(Employment_Date; "Employment Date")
            {
            }
            column(Status; Status)
            {
            }
            column(Termination_Date; "Termination Date")
            {
            }
            column(Global_Dimension_1_Code; "Global Dimension 1 Code")
            {
            }
            column(Global_Dimension_2_Code; "Global Dimension 2 Code")
            {
            }
            column(Nombre_Supervisor; "Nombre Supervisor")
            {
            }
            column(Desc_Departamento; "Desc. Departamento")
            {
            }
            column(Nacionalidad; Nacionalidad)
            {
            }
            column(Tipo_de_Sangre; "Tipo de Sangre")
            {
            }
            column(Estado_civil; "Estado civil")
            {
            }
            column(Employee_Level; "Employee Level")
            {
            }
            column(Salario; Salario)
            {
            }
            column(Mes_Nacimiento; "Mes Nacimiento")
            {
            }
            column(Working_Center_Name; "Working Center Name")
            {
            }
            column(Document_ID; "Document ID")
            {
            }
            column(E_Mail; "E-Mail")
            {
            }
            column(Company_E_Mail; "Company E-Mail")
            {
            }
            dataitem(Contratos; Contratos)
            {
                DataItemLink = "No. empleado" = Employee."No.";
                SqlJoinType = InnerJoin;
                column(Duracion; Duracion)
                {
                }
                column("Fecha_finalización"; "Fecha finalización")
                {
                }
                column(Causa_de_la_Baja; "Causa de la Baja")
                {
                }
            }
        }
    }
}

