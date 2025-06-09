table 56029 "Auxiliar proceso docum. SRI"
{

    fields
    {
        field(1; "Tipo operacion"; Option)
        {
            OptionMembers = Enviar,Autorizar;
        }
        field(2; "ID Tabla (Solo enviar)"; Option)
        {
            Description = ',110,112,114,122,124,5744';
            OptionMembers = " ","110","112","114","122","124","5744";

            trigger OnValidate()
            begin
                PonerDescripcion;
            end;
        }
        field(3; Descripcion; Text[50])
        {
            Editable = false;
        }
        field(4; Procesar; Boolean)
        {
        }
        field(7; "Filtrar por fecha"; Boolean)
        {
        }
        field(8; Filtro; Text[100])
        {
        }
    }

    keys
    {
        key(Key1; "Tipo operacion", "ID Tabla (Solo enviar)")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        Validar;
    end;

    trigger OnModify()
    begin
        Validar;
    end;

    trigger OnRename()
    begin
        Validar;
    end;


    procedure Validar()
    var
        TextL001: Label 'Si el valor del campo <Tipo de operacion> es "Autorizar", no se espera valor en el campo <ID Tabla (Solo enviar)>';
        TextL002: Label 'Si el valor del campo <Tipo de operacion> es "Enviar", se debe introducir valor en el campo <ID Tabla (Solo enviar)>';
    /*      lrObject: Record "Object"; */
    begin
        case "Tipo operacion" of
            "Tipo operacion"::Enviar:
                begin
                    if "ID Tabla (Solo enviar)" = "ID Tabla (Solo enviar)"::" " then
                        Error(TextL002);
                end;

            "Tipo operacion"::Autorizar:
                begin
                    if "ID Tabla (Solo enviar)" <> "ID Tabla (Solo enviar)"::" " then
                        Error(TextL001);
                end;
        end;

        PonerDescripcion;
    end;


    procedure PonerDescripcion()
    begin
        Descripcion := '';
        case "ID Tabla (Solo enviar)" of
            "ID Tabla (Solo enviar)"::" ":
                Descripcion := '';
            "ID Tabla (Solo enviar)"::"110":
                Descripcion := 'Histórico cab. remisión venta';
            "ID Tabla (Solo enviar)"::"112":
                Descripcion := 'Histórico cab. factura venta';
            "ID Tabla (Solo enviar)"::"114":
                Descripcion := 'Histórico cab. nota crédito venta';
            "ID Tabla (Solo enviar)"::"122":
                Descripcion := 'Histórico cab. factura compra';
            "ID Tabla (Solo enviar)"::"124":
                Descripcion := 'Histórico cab. nota crédito compra';
            "ID Tabla (Solo enviar)"::"5744":
                Descripcion := 'Cab. transferencia envío';
        end;
    end;
}

