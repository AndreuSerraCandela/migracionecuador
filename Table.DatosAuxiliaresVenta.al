table 76405 "Datos Auxiliares Venta"
{
    // #348662 25.11.2020  RRT: Actualizar DS-POS para ajustar a version 43c. Redenominar tambien campos con caracteres conflictivos.


    fields
    {
        field(10; "No. Venta"; Code[20])
        {
            Description = 'DsPOS Standar';
        }
        field(11; "Nuevo Cliente"; Code[20])
        {
            Description = 'DsPOS Standar';
            TableRelation = Customer;
        }
        field(20; "No. Autorizacion Manual"; Code[20])
        {
            Description = 'DsPOS Bolivia';
        }
        field(30; "No. Factura Manual"; Code[40])
        {
            Description = 'DsPOS Bolivia';
        }
        field(40; "Fecha Registro"; Date)
        {
            Description = 'DsPOS Bolivia';
        }
    }

    keys
    {
        key(Key1; "No. Venta")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

