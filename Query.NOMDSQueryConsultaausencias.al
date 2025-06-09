query 76049 "NOMDS Query Consulta ausencias"
{
    Caption = 'Absence query';

    elements
    {
        dataitem(Employee_Absence; "Employee Absence")
        {
            column(Employee_No; "Employee No.")
            {
            }
            column(From_Date; "From Date")
            {
            }
            column(To_Date; "To Date")
            {
            }
            column(Cause_of_Absence_Code; "Cause of Absence Code")
            {
            }
            column(Description; Description)
            {
            }
            column(Quantity; Quantity)
            {
            }
            column(Full_name; "Full name")
            {
            }
            dataitem(Employee; Employee)
            {
                DataItemLink = "No." = Employee_Absence."Employee No.";
                column(Company; Company)
                {
                }
            }
        }
    }
}

