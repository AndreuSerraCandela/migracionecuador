tableextension 50129 tableextension50129 extends "Service Zone"
{
    fields
    {
        field(50000; "Cod. Cobrador"; Code[20])
        {
            Caption = 'Collector Code';
            DataClassification = ToBeClassified;
            TableRelation = "Salesperson/Purchaser"."Code";
            trigger OnValidate()
            begin
                if SP.Get(Code) then
                    "Nombre Cobrador" := SP.Name
                else
                    SP.Name := '';
            end;
        }
        field(50001; "Nombre Cobrador"; Text[200])
        {
            Caption = 'Collector Code';
            DataClassification = ToBeClassified;
        }
    }

    var
        SP: Record "Salesperson/Purchaser";
}

