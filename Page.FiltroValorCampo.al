#pragma implicitwith disable
page 75014 "Filtro Valor Campo"
{
    ApplicationArea = all;
    // YA SE que codigo en la page no es lo suyo
    // El problema es que NO puede estar en la tabla ya que se trata como una tabla "Temporal" todo el tiempo y no cosume licencia
    // Si introducimos código dentro de la tabla, El sistema Si solicitará licencia para este objeto.

    Editable = false;
    PageType = List;
    SourceTable = "Filtro Valor Campo Buffer";
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Value; rec.Value)
                {
                }
                field(Description; rec.Description)
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        RellenaTemp;
    end;

    var
        Text001: Label 'El tipo de dato %1 no está permitido. Campo %2';
        Text002: Label '%1 No es un valor permitido para %2.\ Los valores permitidos son %3';
        cFunMdM: Codeunit "Funciones MdM";


    procedure RellenaTemp()
    var
        lwTableId: Integer;
        lwFieldNo: Integer;
        lwRecRf: RecordRef;
        lwFieldRf: FieldRef;
        lwRecRf2: RecordRef;
        lwFieldRf2: FieldRef;
        lwKeyRef: KeyRef;
        lwIdRel: Integer;
        lwTotal: Integer;
        lwId: Integer;
        lwIdDim: Integer;
        lwOptionValue: Text;
        lwIdfVal: Integer;
        lwIdfDesc: Integer;
        lwText: Text;
        lwDescrpt: Text;
        lwCodDim: Code[20];
        lrValDim: Record "Dimension Value";
    begin
        // RellenaTemp

        // Recuerde que la tabla en cuestión debe de ser temporal

        lwTableId := Rec.GetRangeMin("Table Id");
        lwFieldNo := Rec.GetRangeMin("Field No");

        if (lwTableId = 0) or (lwFieldNo = 0) then
            exit;

        Clear(Rec);
        Rec.DeleteAll;
        Clear(lwId);

        // Campos virtuales de la tabla producto
        if (lwTableId = 27) and (lwFieldNo < 0) then begin
            case lwFieldNo of
                -299 .. -200:
                    begin // Dimensiones
                        lwIdDim := -(lwFieldNo + 200);
                        lwCodDim := cFunMdM.GetDimCode(lwIdDim, true);
                        Clear(lrValDim);
                        lrValDim.SetRange("Dimension Code", lwCodDim);
                        lrValDim.SetRange(Blocked, false);
                        if lrValDim.FindSet then begin
                            repeat
                                lwId += 1;
                                InsertReg(lwId, lwTableId, lwFieldNo, lrValDim.Code, lrValDim.Name);
                            until lrValDim.Next = 0;
                        end;
                    end;
            end;
        end
        else begin
            lwRecRf.Open(lwTableId);
            lwFieldRf := lwRecRf.Field(lwFieldNo);
            if UpperCase(Format(lwFieldRf.Type)) = 'BOOLEAN' then begin
                InsertReg(1, lwTableId, lwFieldNo, 'Sí', '');
                InsertReg(2, lwTableId, lwFieldNo, 'No', '');
            end else
                if UpperCase(Format(lwFieldRf.Type)) = 'OPTION' then begin
                    CurrPage.Caption := lwFieldRf.Caption;
                    lwOptionValue := lwFieldRf.OptionMembers;
                    //lwOptionValue := lwFieldRf.OptionCaption;
                    lwTotal := GeOptionNums(lwOptionValue);
                    for lwId := 1 to lwTotal do begin
                        InsertReg(lwId, lwTableId, lwFieldNo, SelectStr(lwId, lwOptionValue), '');
                    end;
                end
                else begin
                    lwIdRel := lwFieldRf.Relation;

                    if lwIdRel <> 0 then begin
                        lwRecRf2.Open(lwIdRel);
                        CurrPage.Caption := lwRecRf2.Caption;
                        lwIdfVal := 0; // Id del campo Valor
                        lwIdfDesc := 0; // Id del campo Descripción, por defecto en blanco
                        RelFilter(lwTableId, lwFieldNo, lwRecRf2, lwIdfVal, lwIdfDesc); // Añade filtros adicionales
                        if lwIdfVal = 0 then begin
                            // Buscamos el primer campo de la clave primaria
                            lwKeyRef := lwRecRf2.KeyIndex(1);
                            lwFieldRf2 := lwKeyRef.FieldIndex(1);
                            lwIdfVal := lwFieldRf2.Number;
                        end;
                        if lwRecRf2.FindSet then begin
                            repeat
                                lwId += 1;
                                lwFieldRf2 := lwRecRf2.Field(lwIdfVal);
                                lwText := Format(lwFieldRf2.Value);
                                //lwText := COPYSTR(lwText, 1, MAXSTRLEN(Value));
                                Clear(lwDescrpt);
                                if lwIdfDesc <> 0 then begin
                                    lwFieldRf2 := lwRecRf2.Field(lwIdfDesc);
                                    lwDescrpt := Format(lwFieldRf2.Value);
                                    lwDescrpt := CopyStr(lwDescrpt, 1, MaxStrLen(Rec.Description));
                                end;
                                InsertReg(lwId, lwTableId, lwFieldNo, lwText, lwDescrpt);
                            until lwRecRf2.Next = 0;
                        end;
                    end;
                end;
        end;
    end;


    procedure RelFilter(pwTableId: Integer; pwFieldNo: Integer; var pwRelRf: RecordRef; var pwIdfVal: Integer; var pwIdfDesc: Integer)
    var
        lwFieldRf: FieldRef;
        lwOptionValue: Text;
        lwId: Integer;
    begin
        // RelFilter
        // Añade filtros adicionales que no he sabido manejar de otro modo
        // pwIdfVal, pwIdfDesc Devuelve el numero de código y descripción para cada caso


        case pwRelRf.Number of // Tabla relacionada
            76014:
                begin // Datos auxiliares
                    pwIdfVal := 2;  // Código
                    pwIdfDesc := 3;  // Descripción
                    lwFieldRf := pwRelRf.Field(1);
                    //lwOptionValue := lwFieldRf.OPTIONCAPTION;
                    lwOptionValue := lwFieldRf.OptionMembers;
                    lwId := 0;
                    case pwTableId of
                        27:
                            begin // Producto
                                case pwFieldNo of
                                    56022:
                                        lwId := GeOptionValueId(lwOptionValue, 'Grupo de Negocio');// Grupo Negocio
                                    55000:
                                        lwId := GeOptionValueId(lwOptionValue, 'Materia'); // Materia
                                end;
                            end;
                    end;
                    if lwId > 0 then
                        lwFieldRf.SetRange(lwId);
                end;
            75001:
                begin  // Datos MdM
                    pwIdfVal := 2;  // Código
                    pwIdfDesc := 3;  // Descripción
                    lwFieldRf := pwRelRf.Field(1);
                    //lwOptionValue := lwFieldRf.OPTIONCAPTION;
                    lwOptionValue := lwFieldRf.OptionMembers;
                    lwId := 0;
                    case pwTableId of
                        27:
                            begin // Producto
                                case pwFieldNo of
                                    50005:
                                        lwId := GeOptionValueId(lwOptionValue, 'Grado');// Nivel Escolar (Grado)
                                    56007:
                                        lwId := GeOptionValueId(lwOptionValue, 'Edicion');// Edicion
                                    56008:
                                        lwId := GeOptionValueId(lwOptionValue, 'Estado');// Estado
                                    56010:
                                        lwId := GeOptionValueId(lwOptionValue, 'Sello');// Sello
                                    75001:
                                        lwId := GeOptionValueId(lwOptionValue, 'Tipo Producto');// Tipo Producto
                                    75002:
                                        lwId := GeOptionValueId(lwOptionValue, 'Soporte');// Soporte
                                    75003:
                                        lwId := GeOptionValueId(lwOptionValue, 'Editora');// Empresa Editora
                                    75005:
                                        lwId := GeOptionValueId(lwOptionValue, 'Editora');// Sociedad
                                    75004:
                                        lwId := GeOptionValueId(lwOptionValue, 'Linea');// Linea de Negocio
                                    75006:
                                        lwId := GeOptionValueId(lwOptionValue, 'Plan Editorial');// Plan Editorial
                                    75010:
                                        lwId := GeOptionValueId(lwOptionValue, 'Asignatura');// Asignatura
                                    75011:
                                        lwId := GeOptionValueId(lwOptionValue, 'Campaña');// Campaña
                                    56015:
                                        lwId := GeOptionValueId(lwOptionValue, 'Autor');// Autor
                                end;
                            end;
                    end;


                    if lwId > 0 then
                        lwFieldRf.SetRange(lwId);
                end;
        end;
    end;


    procedure TestCampo(pwIdTable: Integer; pwIdField: Integer)
    var
        lrFields: Record "Field";
        lwIdDim: Integer;
    begin
        // TestCampo
        if (pwIdTable = 0) or (pwIdField = 0) then
            exit;

        if (pwIdTable = 27) and (pwIdField < 0) then begin // Campos Virtuales
            case pwIdField of
                -299 .. -200:
                    begin // Dimensiones
                        lwIdDim := -(pwIdField + 200);
                        cFunMdM.GetDimCode(lwIdDim, true);
                    end;
            end;
        end
        else
            lrFields.Get(pwIdTable, pwIdField);
    end;


    procedure GetFieldValue(var pwFieRef: FieldRef; pwValue: Text; var pwVariant: Variant)
    var
        ValDecimal: Decimal;
        ValInteger: Integer;
        ValDate: Date;
        ValDateTime: DateTime;
        ValBoolean: Boolean;
        lwIsNULL: Boolean;
        lwOK: Boolean;
        lwValue2: Text;
    begin
        // GetFieldValue
        // Devuelve un valor a un campo
        // pwVariant Es el valor de retorno

        pwValue := DelChr(pwValue, '<>');
        lwIsNULL := EsNulo(pwValue);

        Clear(pwVariant);
        case UpperCase(Format(pwFieRef.Type)) of
            'OPTION':
                begin
                    if lwIsNULL then
                        ValInteger := 0
                    else begin
                        if not Evaluate(ValInteger, pwValue) then begin
                            ValInteger := GeOptionValueId(pwFieRef.OptionCaption, pwValue);
                            if ValInteger = -1 then
                                ValInteger := GeOptionValueId(pwFieRef.OptionMembers, pwValue);
                            if ValInteger = -1 then
                                Error(Text002, pwValue, pwFieRef.Caption, pwFieRef.OptionCaption);
                        end;
                    end;
                    pwVariant := ValInteger;
                end;
            'INTEGER', 'BIGINTEGER':
                begin
                    if lwIsNULL then
                        ValInteger := 0
                    else
                        Evaluate(ValInteger, pwValue);
                    pwVariant := ValInteger;
                end;
            'DECIMAL':
                begin
                    if lwIsNULL then
                        ValDecimal := 0
                    else
                        Evaluate(ValDecimal, pwValue);
                    pwVariant := ValDecimal;
                end;
            'DATE':
                begin
                    if lwIsNULL then
                        ValDate := 0D
                    else begin
                        lwOK := Evaluate(ValDate, pwValue);
                        if not lwOK then begin
                            lwValue2 := StrSubstNo('%1/%2/%3', CopyStr(pwValue, 9, 2), CopyStr(pwValue, 6, 2), CopyStr(pwValue, 1, 4));
                            lwOK := Evaluate(ValDate, lwValue2);
                        end;
                        if not lwOK then begin
                            lwValue2 := StrSubstNo('%1/%2/%3', CopyStr(pwValue, 6, 2), CopyStr(pwValue, 9, 2), CopyStr(pwValue, 1, 4));
                            lwOK := Evaluate(ValDate, lwValue2);
                        end;
                        if not lwOK then
                            Evaluate(ValDate, pwValue); // Genera Error
                    end;
                    pwVariant := ValDate;
                end;
            'DATETIME':
                begin
                    if lwIsNULL then
                        ValDateTime := 0DT
                    else
                        Evaluate(ValDateTime, pwValue);
                    pwVariant := ValDateTime;
                end;
            'BOOLEAN':
                begin
                    if lwIsNULL then
                        ValBoolean := false
                    else
                        Evaluate(ValBoolean, pwValue);
                    pwVariant := ValBoolean;
                end;
            'TEXT', 'BIGTEXT', 'CODE':
                begin
                    if lwIsNULL then
                        pwValue := '';
                    pwVariant := pwValue;
                end
            else
                Error(Text001, Format(pwFieRef.Type), pwFieRef.Caption);
        end;
    end;


    procedure EsNulo(pwValue: Text) wIsNull: Boolean
    begin
        // EsNulo
        // Determina si es un valor Nulo

        pwValue := DelChr(pwValue, '<>');
        wIsNull := (UpperCase(pwValue) = 'NULL') or (pwValue = '');
    end;


    procedure GeOptionValueId(pwOptionValue: Text; pwValue: Text) wId: Integer
    var
        lwId: Integer;
        lwTotal: Integer;
    begin
        // GeOptionValueId
        // Devolvemos el valor del Id del option (valores separados por comas)
        // Si no lo encuetra devuelve -1;

        wId := -1;

        pwOptionValue := UpperCase(DelChr(pwOptionValue, '<>'));
        pwValue := UpperCase(DelChr(pwValue, '<>')); // Le quitamos los valors vacios al principio y fin

        lwTotal := GeOptionNums(pwOptionValue);

        for lwId := 1 to lwTotal do begin
            if pwValue = SelectStr(lwId, pwOptionValue) then
                exit(lwId - 1); // Los option empiezan por 0
        end;
    end;


    procedure GeOptionNums(pwOptionValue: Text) Result: Integer
    var
        lwOptValues: Text;
        lwPs: Integer;
        lwId: Integer;
    begin
        // GeOptionNums
        // Devolvemos la cantidad de posiciones que tiene un option

        pwOptionValue := UpperCase(DelChr(pwOptionValue, '<>'));
        lwOptValues := pwOptionValue;

        // Contamos cuantas posiciones tiene (comas +1)
        Result := 0;
        if lwOptValues <> '' then begin
            repeat
                lwPs := StrPos(lwOptValues, ',');
                if lwPs > 0 then
                    lwOptValues := CopyStr(lwOptValues, lwPs + 1);
                Result += 1;
            until (lwPs = 0);
        end;
    end;


    procedure InsertReg(pwId: Integer; pwTableId: Integer; pwFieldId: Integer; pwValue: Text; pwDescripcion: Text)
    begin
        // InsertReg

        pwValue := DelChr(pwValue, '<>');

        if pwValue = '' then
            exit;

        Rec.Init;
        Rec.Id := pwId;
        Rec."Table Id" := pwTableId;
        Rec."Field No" := pwFieldId;
        Rec.Value := pwValue;
        Rec.Description := pwDescripcion;
        Rec.Insert;
    end;
}

#pragma implicitwith restore

