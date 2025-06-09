table 80018 "MIG Customer"
{
    Caption = 'Customer';

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
        }
        field(53000; "Permite venta a credito"; Boolean)
        {
            Caption = 'Credit Sales Allowed';
        }
        field(55002; "Colegio por defecto POS"; Code[10])
        {
            Caption = 'POS default School';
            Description = 'Ecuador';
            TableRelation = Contact;
        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "No.")
        {
        }
    }

    trigger OnDelete()
    var
        CampaignTargetGr: Record "Campaign Target Group";
        ContactBusRel: Record "Contact Business Relation";
        Job: Record Job;
        CampaignTargetGrMgmt: Codeunit "Campaign Target Group Mgt";
        StdCustSalesCode: Record "Standard Customer Sales Code";
    begin
    end;
}

