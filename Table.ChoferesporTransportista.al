table 56042 "Choferes por Transportista"
{

    fields
    {
        field(1; "Cod. Transportista"; Code[20])
        {
            Caption = 'Shiping Agent';
            TableRelation = "Shipping Agent";

            trigger OnValidate()
            begin
                if SA.Get("Cod. Transportista") then
                    "Nombre Transportista" := SA.Name
                else
                    "Nombre Transportista" := '';
            end;
        }
        field(2; "Nombre Transportista"; Text[100])
        {
        }
        field(3; "Cod. Chofer"; Code[20])
        {
            Caption = 'Driver Code';
            TableRelation = Choferes;

            trigger OnValidate()
            begin
                if Cho.Get("Cod. Chofer") then
                    "Nombre Chofer" := Cho.Nombre
                else
                    "Nombre Chofer" := '';
            end;
        }
        field(4; "Nombre Chofer"; Text[100])
        {
            Caption = 'Driver Name';
        }
    }

    keys
    {
        key(Key1; "Cod. Transportista", "Cod. Chofer")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        SA: Record "Shipping Agent";
        Cho: Record Choferes;
}

