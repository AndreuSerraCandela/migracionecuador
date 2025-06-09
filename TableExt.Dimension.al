tableextension 50061 tableextension50061 extends Dimension
{
    fields
    {

        field(50000; "Code Caption 2"; Text[95])
        {
            DataClassification = ToBeClassified;
            Caption = 'Code Caption';
        }
        field(50001; "Filter Caption 2"; Text[95])
        {
            DataClassification = ToBeClassified;
            Caption = 'Filter Caption';
        }
        field(75000; "Tipo MdM"; Option)
        {
            DataClassification = ToBeClassified;
            Description = 'MdM';
            OptionMembers = Ninguno,"Serie/Metodo",Destino,Cuenta,"Tipo Texto",Materia,"Carga Horaria",Origen;

            trigger OnValidate()
            begin

                ControlDuplicadoMdM;
            end;
        }
        field(76228; "Source Counter POS"; Integer)
        {
            Caption = 'Source Counter POS';
            DataClassification = ToBeClassified;
            Description = 'DsPOS Standard';
        }
    }

    trigger OnAfterInsert()
    var
        myInt: Integer;
    begin
        "Source Counter POS" += 1;
    end;

    trigger OnAfterModify()
    var
        myInt: Integer;
    begin
        "Source Counter POS" += 1;
    end;

    procedure ControlDuplicadoMdM()
    var
        lrDim: Record Dimension;
        LText0001: Label 'Ya existe un registro (%1) con valor %2 = %3';
    begin
        // ControlDuplicadoMdM
        // MdM

        if "Tipo MdM" = "Tipo MdM"::Ninguno then
            exit;

        Clear(lrDim);
        lrDim.SetRange("Tipo MdM", "Tipo MdM");
        lrDim.SetFilter(Code, '<>%1', Code);
        if lrDim.FindFirst then
            Error(LText0001, lrDim.Code, FieldCaption("Tipo MdM"), "Tipo MdM");
    end;
}

