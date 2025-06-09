table 75004 "Imp.MdM Tabla"
{

    fields
    {
        field(1; Id; Integer)
        {
            AutoIncrement = true;
        }
        field(2; "Id Cab."; Integer)
        {
            Description = 'Id de la cabecera';
        }
        field(3; Operacion; Option)
        {
            OptionMembers = Insert,Update,Delete;
        }
        field(5; "Id Tabla"; Integer)
        {
        }
        field(10; "Code"; Code[30])
        {
        }
        field(11; "Code MdM"; Code[30])
        {
            Caption = 'Code MdM';
        }
        field(12; Rename; Boolean)
        {
            CalcFormula = Exist("Imp.MdM Campos" WHERE("Id Rel" = FIELD(Id),
                                                        "Renamed Val" = FILTER(<> '')));
            Description = 'FlowField';
            Editable = false;
            FieldClass = FlowField;
        }
        field(20; Descripcion; Text[100])
        {
        }
        field(30; Tipo; Integer)
        {
        }
        field(40; Procesado; Boolean)
        {
        }
        field(41; Visible; Option)
        {
            OptionMembers = Ind,"Sí",No;
        }
        field(50; "Nombre Elemento"; Text[50])
        {
        }
    }

    keys
    {
        key(Key1; Id)
        {
            Clustered = true;
        }
        key(Key2; "Id Cab.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        lrFields: Record "Imp.MdM Campos";
    begin

        // Borramos todos los campos relacionados

        Clear(lrFields);
        lrFields.SetRange("Id Rel", Id);
        lrFields.DeleteAll;
    end;

    var
        cFuncMdM: Codeunit "Funciones MdM";
        cGenProd: Codeunit "MdM Gen. Prod.";
        ConfMdM: Record "Configuracion MDM";
        Text0001: Label 'Dim. ';
        Text0002: Label 'Alto';
        Text0003: Label 'Ancho';
        Text0004: Label 'Peso';
        wRecRef: RecordRef;
        ft: Integer;


    procedure GetTableName() TableName: Text[50]
    var
    /*         lrTables: Record "Object"; */
    begin
        // GetTableName

        /*         Clear(lrTables);
                lrTables.SetRange(Type, lrTables.Type::Table);
                lrTables.SetRange(ID, "Id Tabla");
                if lrTables.Find('-') then
                    TableName := lrTables.Name; */
    end;


    procedure GetFieldName(pwFieldNo: Integer) FieldName: Text[50]
    var
        rlFields: Record "Field";
    begin
        // GetFieldName

        FieldName := '';
        if pwFieldNo > 0 then begin
            Clear(rlFields);
            rlFields.SetRange(TableNo, "Id Tabla");
            rlFields.SetRange("No.", pwFieldNo);
            if rlFields.Find('-') then
                FieldName := rlFields.FieldName;
        end
        else begin  // Estos son valores "Virtuales"
            case "Id Tabla" of
                27:
                    begin // Productos
                        case pwFieldNo of
                            -101:
                                FieldName := Text0002;  // Alto
                            -102:
                                FieldName := Text0003;  // Ancho
                            -103:
                                FieldName := Text0004;  // Peso
                                                        // Dimensiones
                            -299 .. -200:
                                FieldName := Text0001 + cFuncMdM.GetDimCode(Abs("Id Tabla" + 200), false);
                        end;
                    end;
            end;
        end;
    end;


    procedure ValidaCampos()
    var
        lrField: Record "Imp.MdM Campos";
        lrField2: Record "Field";
        lrRF: FieldRef;
        lwType: Option;
        lwIntT: Integer;
    begin
        // ValidaCampos

        wRecRef.Open("Id Tabla");

        Clear(lrField);
        lrField.SetRange("Id Rel", Id);
        if lrField.FindSet then begin
            repeat
                if lrField."Id Field" > 0 then begin
                    if wRecRef.FieldExist(lrField."Id Field") then begin
                        // Buscamos el tipo de dato (lrRF.TYPE no nos sirve)
                        //lrField2.Type := lrRF.TYPE;

                        lrRF := wRecRef.Field(lrField."Id Field");
                        case lrField2.Type of
                            lrField2.Type::Integer:
                                begin
                                    Evaluate(lwIntT, lrField.Value);
                                    lrRF.Validate(lwIntT);
                                end;
                        end;
                    end;
                end;
            until lrField.Next = 0;
        end;
    end;


    procedure GetIdTipoField() wId: Integer
    begin
        // GetIdTipoField
        // Devuelve el Id de Campo del valor tipo según la tabla

        wId := 0;
        case "Id Tabla" of
            75001, 349:
                wId := 1;
            90:
                wId := 2;
        //75002     : wId := 10; // El nivel de estructura analitica se determina por la longitud del campo Code
        end;
    end;


    procedure GetIdCodeField() wId: Integer
    begin
        // GetIdTipoField
        // Devuelve el Id de Campo del valor Codigo según la tabla

        wId := 0;
        case "Id Tabla" of
            27, 5722, 90, 56003, 8, 75010, 9, 56007, 75002, 56008, 75009
                  :
                wId := 1;
            75001, 349
                  :
                wId := 2;
        end;
    end;


    procedure GetIdDescField() wId: Integer
    begin
        // GetIdDescField
        // Devuelve el Id de Campo del valor Descripcion según la tabla

        wId := 0;
        case "Id Tabla" of
            56003, 8, 9, 56007, 56008, 75009
                     :
                wId := 2;
            27, 349, 5722, 75001
                     :
                wId := 3;
            75010:
                wId := 5;
            75002:
                wId := 11;
        end;
    end;


    procedure GetTipoText() wText: Text
    var
        lwId: Integer;
    begin
        // GetTipoText

        wText := '';
        case "Id Tabla" of
            349:
                begin
                    lwId := Abs(Tipo + 200);
                    wText := cFuncMdM.GetDimCode(lwId, false); // Dimensiones MdM
                end;
            else
                wText := Format(Tipo);
        end;
    end;


    procedure SetVisibleTx(pwVisibleTx: Text[10])
    var
        lwBool: Boolean;
    begin
        // SetVisibleTx

        if Evaluate(lwBool, pwVisibleTx) then begin
            if lwBool then
                Visible := Visible::"Sí"
            else
                Visible := Visible::No
        end
        else
            Visible := Visible::Ind;
    end;


    procedure GetVisibleTx() Value: Text
    begin
        // GetVisibleTx
        Value := '';

        case Visible of
            Visible::"Sí":
                Value := Format(true);
            Visible::No:
                Value := Format(false);
        end;
    end;


    procedure GetVisibleDef(pwDef: Boolean) Value: Boolean
    begin
        // GetVisibleDef

        if Visible = Visible::Ind then
            Value := pwDef
        else
            Value := (Visible = Visible::"Sí");
    end;


    procedure GetBloqueadoTx() Value: Text
    begin
        // GetBloqueadoTx
        // Es lo contrario GetVisibleTx
        // Devuelve trues si está bloqueado, eso es si no está visible
        Value := '';

        case Visible of
            Visible::"Sí":
                Value := Format(false);
            Visible::No:
                Value := Format(true);
        end;
    end;


    procedure VerFicha()
    var
        lrPK: KeyRef;
        lwN: Integer;
        lrField: Record "Imp.MdM Campos";
        lwRecRef: RecordRef;
        lwField2: FieldRef;
        lwCod: Code[20];
        lwNo: Code[20];
        lwOK: Boolean;
        lwVarRecRef: Variant;
        lwidPg: Integer;
    begin
        // VerFicha

        if "Id Tabla" = 0 then
            exit;

        lwRecRef.Open("Id Tabla");

        // Buscamos el registro
        lrPK := lwRecRef.KeyIndex(1);

        Clear(lrField);

        for lwN := 1 to lrPK.FieldCount do begin
            lwField2 := lrPK.FieldIndex(lwN);
            if lrField.Get(Id, lwField2.Number) then begin // Los campos de la clave primaria deben de existir
                cGenProd.SetFieldValue(lwField2, lrField.Value, false); // Por defecto No validamos la clave primaria
            end
            else begin
                case lwField2.Number of
                    GetIdTipoField:
                        cGenProd.SetFieldValue(lwField2, GetTipoText, false); // Por defecto No validamos la clave primaria
                    GetIdCodeField:
                        cGenProd.SetFieldValue(lwField2, Code, false);
                    GetIdDescField:
                        cGenProd.SetFieldValue(lwField2, Descripcion, false);
                end;
            end;
        end;

        case "Id Tabla" of
            27:
                lwidPg := 30
            else
                lwidPg := 0;
        end;

        if "Id Tabla" = 75001 then begin // Datos MdM
                                         // Filtramos por el tipo de dato
            lwField2 := lwRecRef.Field(1); // Tipo
            lwField2.SetRange(Tipo);
        end;


        if lwRecRef.Find then begin
            lwVarRecRef := lwRecRef;
            PAGE.Run(lwidPg, lwVarRecRef);
        end;
    end;
}

