table 75010 "Conf. Campos Relacionados"
{
    Caption = 'Configuración Campos Relacionados';

    fields
    {
        field(1; Id; Integer)
        {
            AutoIncrement = true;
            Description = 'PK';
            Editable = false;
        }
        field(100; "Id Fld Origen"; Integer)
        {
            Caption = 'Campo Origen';
            TableRelation = "Filtro Campo Buffer"."Field No" WHERE("Table Id" = CONST(27));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnValidate()
            var
                lrFiltrCmp: Page "Filtro Valor Campo";
            begin
                Controles;
                lrFiltrCmp.TestCampo(IdTbl, "Id Fld Origen");
                "Valor Origen" := '';
            end;
        }
        field(110; "Valor Origen"; Text[100])
        {
            TableRelation = "Filtro Valor Campo Buffer".Value WHERE("Table Id" = CONST(27),
                                                                     "Field No" = FIELD("Id Fld Origen"));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnValidate()
            begin
                "Valor Origen" := DelChr("Valor Origen", '<>');
            end;
        }
        field(200; "Id Fld Destino"; Integer)
        {
            Caption = 'Campo Destino';
            TableRelation = "Filtro Campo Buffer"."Field No" WHERE("Table Id" = CONST(27));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnValidate()
            var
                lrFiltrCmp: Page "Filtro Valor Campo";
            begin
                Controles;
                lrFiltrCmp.TestCampo(IdTbl, "Id Fld Destino");
                "Valor Destino" := '';
            end;
        }
        field(210; "Valor Destino"; Text[100])
        {
            TableRelation = "Filtro Valor Campo Buffer".Value WHERE("Table Id" = CONST(27),
                                                                     "Field No" = FIELD("Id Fld Destino"));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnValidate()
            begin
                "Valor Destino" := DelChr("Valor Destino", '<>');
            end;
        }
    }

    keys
    {
        key(Key1; Id)
        {
            Clustered = true;
        }
        key(Key2; "Id Fld Origen", "Valor Origen")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        Controles;
        GestDupl;
    end;

    trigger OnModify()
    begin
        Controles;
        GestDupl;
    end;

    var
        Text001: Label 'Los Valores %1 y %2 No pueden ser iguales';
        cGestMaest: Codeunit "Gest. Maestros MdM";
        Text002: Label 'Ya existe un registro %1  %2  %3';


    procedure Controles()
    begin
        // Controles

        if ("Id Fld Origen" = "Id Fld Destino") and ("Id Fld Origen" <> 0) then
            Error(Text001, FieldCaption("Id Fld Origen"), FieldCaption("Id Fld Destino"));
    end;


    procedure GetNomCampo(pwTipo: Option Origen,Destino) Result: Text
    var
        lwIdF: Integer;
    begin
        // GetNomCampo

        Result := '';
        lwIdF := 0;
        case pwTipo of
            pwTipo::Origen:
                lwIdF := "Id Fld Origen";
            pwTipo::Destino:
                lwIdF := "Id Fld Destino";
        end;

        if lwIdF = 0 then
            exit;

        Result := cGestMaest.GetFieldCaption(IdTbl, lwIdF);
    end;

    local procedure IdTbl() Resullt: Integer
    begin
        // IdTbl
        // Por defecto será siempre la tabla Producto 27
        Resullt := 27;
    end;

    local procedure GestDupl()
    var
        lrConfCR: Record "Conf. Campos Relacionados";
    begin
        // GestDupl

        Clear(lrConfCR);
        lrConfCR.SetRange("Id Fld Origen", "Id Fld Origen");
        lrConfCR.SetRange("Valor Origen", "Valor Origen");
        lrConfCR.SetRange("Id Fld Destino", "Id Fld Destino");
        lrConfCR.SetFilter(Id, '<>%1', Id);
        if lrConfCR.FindFirst then
            Error(Text002, GetNomCampo(0), "Valor Origen", GetNomCampo(1));
    end;
}

