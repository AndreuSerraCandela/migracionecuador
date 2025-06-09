table 75005 "Imp.MdM Campos"
{

    fields
    {
        field(1; Id; Integer)
        {
        }
        field(2; "Id Rel"; Integer)
        {
            TableRelation = "Imp.MdM Tabla".Id;
        }
        field(5; "Id Cab."; Integer)
        {
        }
        field(9; "Table Id"; Integer)
        {
        }
        field(10; "Id Field"; Integer)
        {
        }
        field(20; Value; Text[250])
        {
        }
        field(21; PK; Boolean)
        {
            Description = 'Determina si forma parte de la clave primaria';
        }
        field(22; Orden; Integer)
        {
            InitValue = 100;
        }
        field(23; "Renamed Val"; Text[250])
        {
            Description = 'Valor por el que se renombra';
        }
        field(30; "MdM Value"; Text[250])
        {
            Caption = 'MdM Value';
        }
        field(50; "Nombre Elemento"; Text[50])
        {
            Caption = 'Nombre Elemento';
        }
    }

    keys
    {
        key(Key1; "Id Rel", "Id Field")
        {
            Clustered = true;
        }
        key(Key2; "Id Cab.")
        {
        }
        key(Key3; "Id Rel", Orden, Id)
        {
        }
        key(Key4; "Id Rel", Orden, "Id Field")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        SetOrden;
    end;

    var
        cTrasp: Codeunit "MdM Gen. Prod.";


    procedure SetOrden()
    var
        lwOrden: Integer;
        lwMdMTabla: Record "Imp.MdM Tabla" temporary;
        lwRecRef: RecordRef;
        lwPKIds: array[10] of Integer;
        lwTotal: Integer;
        lwN: Integer;
    begin
        //  SetOrden
        // Define cierto orden

        lwOrden := 100; // Por defecto
        case "Table Id" of
            27:
                begin // Producto
                    case "Id Field" of
                        1:
                            lwOrden := 1;
                        2:
                            lwOrden := 2;
                        8:
                            lwOrden := 3; // Unidad Medida Base
                        -310:
                            lwOrden := 4; // Articulo Pack
                        -311:
                            lwOrden := 5; // Unidades Articulo Pack
                    end;
                end;
            else begin
                if "Table Id" > 0 then begin
                    lwRecRef.Open("Table Id");
                    lwTotal := cTrasp.FindPrimKeyIdField(lwRecRef, lwPKIds);
                    for lwN := 1 to lwTotal do begin
                        if lwPKIds[lwN] = "Id Field" then
                            lwOrden := lwN;
                    end;
                end;

                /*
                CLEAR(lwMdMTabla);
                lwMdMTabla."Id Tabla" := "Table Id";
                IF lwMdMTabla.GetIdCodeField = "Id Field" THEN
                  lwOrden := 1;
                */
            end;
        end;

        Orden := lwOrden;

    end;


    procedure GetValue() wValue: Text
    begin
        // GetValue

        wValue := DelChr(Value, '<>');
        if cTrasp.EsNulo(wValue) then
            wValue := '';
    end;
}

