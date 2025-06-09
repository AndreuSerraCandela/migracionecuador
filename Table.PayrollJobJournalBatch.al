table 76099 "Payroll - Job Journal Batch"
{
    DrillDownPageID = "Payroll - Job Journal Batches";
    LookupPageID = "Payroll - Job Journal Batches";

    fields
    {
        field(1; "Journal Template Name"; Code[10])
        {
            Caption = 'Journal Template Name';
            NotBlank = true;
            TableRelation = "Payroll - Job Journal Template";
        }
        field(2; Name; Code[10])
        {
            Caption = 'Name';
            NotBlank = true;
        }
        field(3; Description; Text[50])
        {
            Caption = 'Description';
        }
    }

    keys
    {
        key(Key1; "Journal Template Name", Name)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        JobJnlTemplate: Record "Payroll - Job Journal Template";


    procedure SetupNewBatch()
    begin
        JobJnlTemplate.Get("Journal Template Name");
    end;
}

