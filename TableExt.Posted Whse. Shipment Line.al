tableextension 50153 tableextension50153 extends "Posted Whse. Shipment Line"
{
    fields
    {
        modify("Unit of Measure Code")
        {
            Caption = 'Unit of Measure Code';
        }

        //Unsupported feature: Property Modification (Data type) on "Description(Field 32)".


        //Unsupported feature: Property Modification (Data type) on ""Description 2"(Field 33)".

        field(55048; "Numero Guia"; Code[20])
        {
            CalcFormula = Lookup ("Sales Invoice Header"."Numero Guia" WHERE ("No." = FIELD ("Source No.")));
            Caption = 'Número de Guía';
            Description = 'SANTINAV-1401';
            FieldClass = FlowField;
        }
        field(55049; "Nombre Guia"; Code[20])
        {
            CalcFormula = Lookup ("Sales Invoice Header"."Nombre Guia" WHERE ("No." = FIELD ("Source No.")));
            Caption = 'Nombre de Guía';
            Description = 'SANTINAV-1401';
            FieldClass = FlowField;
        }
    }
}

