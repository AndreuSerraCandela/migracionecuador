table 75016 "Fechas Productos MdM Buffer"
{

    fields
    {
        field(1; "Cod Producto"; Code[20])
        {
            TableRelation = Item;
        }
        field(10; "Fecha Alb Compra"; Date)
        {
            CalcFormula = Min ("Purch. Rcpt. Line"."Posting Date" WHERE (Type = CONST (Item),
                                                                        "No." = FIELD ("Cod Producto"),
                                                                        Quantity = FILTER (<> 0),
                                                                        Correction = CONST (false)));
            Description = 'Flowfield';
            Editable = false;
            FieldClass = FlowField;
        }
        field(20; "Fecha Alb Venta"; Date)
        {
            CalcFormula = Min ("Sales Shipment Line"."Posting Date" WHERE (Type = CONST (Item),
                                                                          "No." = FIELD ("Cod Producto"),
                                                                          Quantity = FILTER (<> 0),
                                                                          Correction = CONST (false)));
            Description = 'Flowfield';
            Editable = false;
            FieldClass = FlowField;
        }
        field(21; "Fecha Fact Venta"; Date)
        {
            CalcFormula = Min ("Sales Invoice Line"."Posting Date" WHERE (Type = CONST (Item),
                                                                         "No." = FIELD ("Cod Producto"),
                                                                         Quantity = FILTER (<> 0)));
            Description = 'Flowfield';
            Editable = false;
            FieldClass = FlowField;
        }
        field(22; "Tiene Componentes"; Boolean)
        {
            CalcFormula = Exist ("BOM Component" WHERE ("Parent Item No." = FIELD ("Cod Producto"),
                                                       Type = CONST (Item)));
            Description = 'Flowfield';
            Editable = false;
            FieldClass = FlowField;
        }
        field(23; "Es Componente"; Boolean)
        {
            CalcFormula = Exist ("BOM Component" WHERE (Type = CONST (Item),
                                                       "No." = FIELD ("Cod Producto")));
            Description = 'Flowfield';
            Editable = false;
            FieldClass = FlowField;
        }
        field(24; "Fecha Ensamblado"; Date)
        {
            CalcFormula = Min ("Posted Assembly Header"."Posting Date" WHERE ("Item No." = FIELD ("Cod Producto"),
                                                                             Quantity = FILTER (<> 0)));
            Description = 'Flowfield';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25; CodProdEsamblado; Code[20])
        {
            CalcFormula = Lookup ("BOM Component"."Parent Item No." WHERE ("No." = FIELD ("Cod Producto"),
                                                                          Type = CONST (Item)));
            Description = 'Flowfield, Si es componente, el producto ensamblado al que pertenece';
            Editable = false;
            FieldClass = FlowField;
        }
        field(75008; "Fecha Almacen"; Date)
        {
            Description = 'MdM';
        }
        field(75009; "Fecha Comercializacion"; Date)
        {
            Description = 'MdM';
        }
    }

    keys
    {
        key(Key1; "Cod Producto")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

