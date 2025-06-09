tableextension 50030 tableextension50030 extends "Ship-to Address"
{
    fields
    {
        modify("Address 2")
        {
            Caption = 'Address 2';
        }

        //Unsupported feature: Property Modification (Data type) on "City(Field 7)".

        modify(County)
        {
            Description = 'estaba en caption class: ''5,1,'' + "Country/Region Code"';
        }

        //Unsupported feature: Code Modification on ""Post Code"(Field 91).OnLookup".

        //trigger OnLookup(var Text: Text): Boolean
        //>>>> ORIGINAL CODE:
        //begin
        /*
        PostCode.LookupPostCode(City,"Post Code",County,"Country/Region Code");
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        PostCode.LookupPostCode(City,"Post Code",County,"Country/Region Code");
        //001+-
        if PostCode.Get("Post Code", City) then
          "Address 2" := PostCode.Colonia;
        //001--
        */
        //end;


        //Unsupported feature: Code Modification on ""Post Code"(Field 91).OnValidate".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        PostCode.ValidatePostCode(City,"Post Code",County,"Country/Region Code",(CurrFieldNo <> 0) and GuiAllowed);
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        PostCode.ValidatePostCode(City,"Post Code",County,"Country/Region Code",(CurrFieldNo <> 0) and GuiAllowed);
        //005
        if PostCode.Get("Post Code", City) then
          "Address 2" := PostCode.Colonia;
        //005
        */
        //end;

        //Unsupported feature: Property Deletion (CaptionClass) on "County(Field 92)".

        field(55000; "Horario Entrega"; Text[100])
        {
            DataClassification = ToBeClassified;
            Description = 'Santinav-599';
        }
        field(55001; "Entrega En"; Text[100])
        {
            DataClassification = ToBeClassified;
            Description = 'Santinav-599';
        }
        field(55002; Colonia; Text[50])
        {
            DataClassification = ToBeClassified;
            Description = 'SANTINAV-2267';
        }
    }
}

