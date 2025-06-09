query 76031 "NOMDS Query entrenamientos"
{
    Caption = 'Training query';

    elements
    {
        dataitem(Employee_Qualification; "Employee Qualification")
        {
            column(Employee_No; "Employee No.")
            {
            }
            column(Description; Description)
            {
            }
            column(From_Date; "From Date")
            {
            }
            column(To_Date; "To Date")
            {
            }
            column(Cost; Cost)
            {
            }
            column(Expiration_Date; "Expiration Date")
            {
            }
            dataitem(Employee; Employee)
            {
                DataItemLink = "No." = Employee_Qualification."Employee No.";
                column(Company; Company)
                {
                }
                column(Full_Name; "Full Name")
                {
                }
            }
        }
    }
}

