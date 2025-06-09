table 75008 "Conf.Filtros Tipologias MdM"
{
    DrillDownPageID = "Conf.Filtros Tipologias MdM";
    LookupPageID = "Conf.Filtros Tipologias MdM";

    fields
    {
        field(1; Id; Integer)
        {
            MaxValue = 7;
            MinValue = 1;
        }
        field(11; Tipo; Option)
        {
            OptionMembers = Dimension,"Dato MdM",Otros;

            trigger OnValidate()
            begin
                "Valor Id" := 0;
            end;
        }
        field(12; "Valor Id"; Integer)
        {
            TableRelation = "Tipo Filtros Tipo. MdM Buffer".Id WHERE(Tipo = FIELD(Tipo));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnValidate()
            begin
                ControlRangoId;
            end;
        }
    }

    keys
    {
        key(Key1; Id)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        ControlRangoId;
        ContDupl;
    end;

    trigger OnModify()
    begin
        ContDupl;
    end;

    var
        ErrorRango: Label 'El rango permitido está entre 1 y %1';
        cFunMdM: Codeunit "Funciones MdM";
        ErrorDupl: Label 'Ya existe el registro';
        Text001: Label 'Filtro %1';


    procedure GetIdName() Result: Text
    var
        lwN: Integer;
        lrTmpDts: Record "Datos MDM" temporary;
    begin
        // GetIdName

        Result := '';

        case Tipo of
            Tipo::Dimension:
                begin
                    Result := cFunMdM.GetDimNameField("Valor Id");
                end;
            Tipo::"Dato MdM":
                begin
                    if "Valor Id" <= lrTmpDts.TotalTipos then begin
                        lrTmpDts.Tipo := "Valor Id";
                        Result := Format(lrTmpDts.Tipo);
                    end;
                end;
            Tipo::Otros:
                begin
                    Result := cFunMdM.GetOtrosName("Valor Id");
                end;
        end;
    end;


    procedure GetFiltDescrpt(pwNo: Integer) Result: Text
    var
        lrConfF: Record "Conf.Filtros Tipologias MdM";
    begin
        // GetFiltDescrpt

        Result := '';

        if lrConfF.Get(pwNo) then
            Result := StrSubstNo(Text001, lrConfF.GetIdName);
    end;


    procedure GetFiltDescrptTx(pwText: Text): Text
    var
        lwNo: Integer;
    begin
        // GetFiltDescrptTx

        if Evaluate(lwNo, pwText) then
            exit(GetFiltDescrpt(lwNo));
    end;


    procedure MaxId(): Integer
    begin
        // MaxId
        // Cantidad máxima de Id que permitimos

        exit(7);
    end;


    procedure ControlRangoId()
    begin
        // ControlRangoId

        if (Id < 1) or (Id > MaxId) then
            Error(ErrorRango, MaxId);
    end;


    procedure ContDupl()
    var
        lrCnfFlt: Record "Conf.Filtros Tipologias MdM";
    begin
        // ContDupl
        // Comprueba duplicidades

        Clear(lrCnfFlt);
        lrCnfFlt.SetRange("Valor Id", "Valor Id");
        lrCnfFlt.SetRange(Tipo, Tipo);
        lrCnfFlt.SetFilter(Id, '<>%1', Id);
        if lrCnfFlt.FindFirst then
            Error(ErrorDupl);
    end;
}

