tableextension 50062 tableextension50062 extends "Dimension Value"
{
    fields
    {
        field(51000; "Fecha desde recep. devol."; Date)
        {
            Caption = 'From date to receive returns';
            DataClassification = ToBeClassified;
        }
        field(51001; "Fecha hasta recep. devol."; Date)
        {
            Caption = 'To date to receive returns';
            DataClassification = ToBeClassified;
        }
        field(56000; "Fecha creacion"; Date)
        {
            DataClassification = ToBeClassified;
            Description = 'Santillana MdE';
        }
    }

    trigger OnAfterDelete()
    var
        myInt: Integer;
    begin
        InfCompMdE.Ceco(Rec, Rec, InfCompMdE.CeCoTipoDelete()); //+MdE
    end;

    trigger OnAfterInsert()
    var
        myInt: Integer;
    begin
        cRep.Dimension("Dimension Code");

        InfCompMdE.Ceco(Rec, Rec, InfCompMdE.CeCoTipoInsert()); //+MdE

        SetLastModifiedDateTime;
    end;

    trigger OnAfterModify()
    var
        myInt: Integer;
    begin
        cRep.Dimension("Dimension Code");

        InfCompMdE.Ceco(Rec, xRec, InfCompMdE.CeCoTipoModify()); //+MdE

        SetLastModifiedDateTime;
    end;

    trigger OnAfterRename()
    var
        myInt: Integer;
    begin
        InfCompMdE.Ceco(Rec, xRec, InfCompMdE.CeCoTipoRename()); //+MdE

        SetLastModifiedDateTime;
    end;

    local procedure SetLastModifiedDateTime()
    begin
        "Last Modified Date Time" := CurrentDateTime;
    end;

    var
        cRep: Codeunit "Funciones Replicador DsPOS";
        InfCompMdE: Codeunit "Informacion Complementaria MDE";
}

