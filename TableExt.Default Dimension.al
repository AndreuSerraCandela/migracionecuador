tableextension 50065 tableextension50065 extends "Default Dimension"
{
    fields
    {
        modify("Dimension Value Code")
        {
            TableRelation = "Dimension Value".Code WHERE("Dimension Code" = FIELD("Dimension Code"),
                                                          Blocked = CONST(false));
        }
    }

    trigger OnAfterInsert()
    var
        myInt: Integer;
    begin
        cRep.Dimension("Dimension Code");

        //+MdE
        if not FromMdE then
            InfCompMdE.HorariosCeco(Rec);
        //-MdE
        cFunMdm.GetDimEditable(Rec, true); // MdM
    end;

    trigger OnAfterModify()
    var
        myInt: Integer;
    begin
        cRep.Dimension("Dimension Code");

        //+MdE
        if not FromMdE then
            if "Dimension Value Code" <> xRec."Dimension Value Code" then
                InfCompMdE.HorariosCeco(Rec);
        //-MdE
        cFunMdm.GetDimEditable(Rec, true); // MdM
    end;

    procedure SetFromMde(New_FromMdE: Boolean)
    begin
        FromMdE := New_FromMdE;
    end;

    var
        cRep: Codeunit "Funciones Replicador DsPOS";
        InfCompMdE: Codeunit "Informacion Complementaria MDE";
        FromMdE: Boolean;
        cFunMdm: Codeunit "Funciones MdM";
}

