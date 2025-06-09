tableextension 50031 tableextension50031 extends "Post Code"
{
    fields
    {
        modify(City)
        {

            //Unsupported feature: Property Modification (Data type) on "City(Field 2)".

            Caption = 'City';
        }

        //Unsupported feature: Property Modification (Data type) on ""Search City"(Field 3)".

        modify(County)
        {

            //Unsupported feature: Property Modification (Data type) on "County(Field 5)".

            Caption = 'State';
        }
        field(52500; Colonia; Text[50])
        {
            Caption = 'Parroquia';
            DataClassification = ToBeClassified;
        }
    }
}

