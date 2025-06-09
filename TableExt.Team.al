tableextension 50091 tableextension50091 extends Team
{
    fields
    {
        field(76012; "Campaña"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Campaign;
        }
    }
}

