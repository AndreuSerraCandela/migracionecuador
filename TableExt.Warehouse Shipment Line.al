tableextension 50151 tableextension50151 extends "Warehouse Shipment Line"
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
            CalcFormula = Lookup ("Sales Header"."Numero Guia" WHERE ("No." = FIELD ("Source No.")));
            Caption = 'Número de Guía';
            Description = 'SANTINAV-1401';
            FieldClass = FlowField;
        }
        field(55049; "Nombre Guia"; Code[20])
        {
            CalcFormula = Lookup ("Sales Header"."Nombre Guia" WHERE ("No." = FIELD ("Source No.")));
            Caption = 'Nombre de Guía';
            Description = 'SANTINAV-1401';
            FieldClass = FlowField;
        }
    }

    //Unsupported feature: Variable Insertion (Variable: SalesHeader) (VariableCollection) on "CreatePickDoc(PROCEDURE 7)".

}

