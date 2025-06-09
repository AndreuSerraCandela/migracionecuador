tableextension 50059 tableextension50059 extends "VAT Product Posting Group"
{
    fields
    {
        field(55000; Propina; Boolean)
        {
            Caption = 'Tips';
            DataClassification = ToBeClassified;
            Description = 'Ecuador';
        }
        field(55001; "_ ITBIS"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'ITPV';
        }
        field(76042; "Tipo de bien-servicio"; Option)
        {
            Caption = 'Type of Good/Service';
            DataClassification = ToBeClassified;
            Description = 'DSLoc1.03';
            OptionCaption = 'Good,Service,Selective,Tips,Other';
            OptionMembers = Bienes,Servicios,"Selectivo al consumo","Propina legal",Otros;
        }
    }
}

