table 64823 DatabaseUPG
{
    DataCaptionFields = "Code", Description;
    //DrillDownPageID = 64833;
    //LookupPageID = 64833;

    fields
    {
        field(1; "Code"; Code[20])
        {
            NotBlank = true;
        }
        field(5; Description; Text[80])
        {
        }
        field(10; "Server No."; Integer)
        {
        }
        field(11; NetType; Text[30])
        {
        }
        field(12; "Database Name"; Text[80])
        {
        }
        field(14; Company; Text[30])
        {
            TableRelation = "Database Company"."Company Name" WHERE ("Database Code" = FIELD (Code));
            ValidateTableRelation = false;
        }
        field(15; UserID; Text[10])
        {
        }
        field(16; Password; Text[30])
        {
        }
        field(17; Type; Option)
        {
            InitValue = "MS Dynamics NAV";
            OptionMembers = "3.56","MS Dynamics NAV";
        }
        field(18; "Server Name"; Text[30])
        {
        }
        field(19; "Assume Design"; Code[20])
        {
            TableRelation = DatabaseUPG.Code;
        }
        field(20; "Read Design"; Boolean)
        {

            trigger OnValidate()
            begin
                if "Read Design" then
                    "Assume Design" := Code
                else
                    if "Assume Design" = Code then
                        "Assume Design" := '';
            end;
        }
        field(21; "Installation Path"; Text[80])
        {
        }
        field(22; Directory; Text[80])
        {
        }
        field(23; "Database Driver"; Text[10])
        {
            Description = 'NDBCN or NDBCS';
            InitValue = 'NDBCN';

            trigger OnValidate()
            begin
                "Database Driver" := UpperCase("Database Driver");
                if (("Database Driver" <> 'NDBCN') and ("Database Driver" <> 'NDBCS')) then
                    FieldError("Database Driver", 'must be either NDBCN (Navision Financials) or NDBCS (MS-SQL 7) server.');
            end;
        }
        field(24; "Use NT Authentication"; Boolean)
        {
        }
        field(25; "Use Codeunits Permissions"; Integer)
        {
        }
        field(26; "Local Db. Cache"; Integer)
        {
        }
        field(27; "Local Db. Commit Cache"; Integer)
        {
        }
        field(28; "Single User Database"; Boolean)
        {
        }
        field(30; "Remote Server Address"; Text[30])
        {
        }
        field(31; "Remote Server Port"; Text[30])
        {
        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        Specification.SetRange("Source Design", Code);
        if Specification.Find('-') then
            Error('This database is used as %1 and can not be deleted.',
              Specification.FieldName("Source Design"));
        Specification.SetRange("Source Design");
        Specification.SetRange("Dest. Design", Code);
        if Specification.Find('-') then
            Error('This database is used as %1 and can not be deleted.',
              Specification.FieldName("Dest. Design"));

        if not Confirm('Deleting the database will remove the entire database design,\' +
          'if present, and also delete related Todo and Log entries, continue?', false)
        then
            exit;

        ToDo.SetRange("Sender Database", Code);
        ToDo.DeleteAll();
        ToDo.Reset();
        ToDo.SetRange("Receiver Database", Code);
        ToDo.DeleteAll();
        Log.SetRange("Source Database", Code);
        Log.DeleteAll();
        Log.Reset();
        Log.SetRange("Dest. Database", Code);
        Log.DeleteAll();
        Table.SetRange("Database Code", Code);
        Table.DeleteAll();
        Field.SetRange("Database Code", Code);
        Field.DeleteAll();
        Accounts.SetRange("Database Code", Code);
        Accounts.DeleteAll();
        Keys.SetRange("Database Code", Code);
        Keys.DeleteAll();
    end;

    var
        Specification: Record Specification;
        SpecFields: Record "Field List";
        ToDo: Record ToDo;
        Log: Record "Activity Register";
        "Table": Record "Database Table";
        "Field": Record "Database Field";
        Accounts: Record "Database Company";
        "Keys": Record "Database Key";
}

