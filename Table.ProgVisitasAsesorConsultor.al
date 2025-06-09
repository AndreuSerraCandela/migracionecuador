table 76386 "Prog. Visitas Asesor/Consultor"
{

    fields
    {
        field(1; "No. Visita"; Code[20])
        {
        }
        field(2; "No. Linea"; Integer)
        {
        }
        field(3; "Fecha Programada"; Date)
        {
        }
        field(4; "Hora Inicio Programada"; Time)
        {
        }
        field(5; "Hora Fin Programada"; Time)
        {
        }
        field(6; "Cod. Grado"; Code[20])
        {
            TableRelation = "Datos auxiliares".Codigo WHERE ("Tipo registro" = CONST (Grados));
        }
        field(8; "No. asistentes"; Integer)
        {
        }
        field(9; "Tipo Asesor/Consultor"; Option)
        {
            Editable = false;
            Enabled = false;
            OptionCaption = 'Docente,Proveedor';
            OptionMembers = Docente,Proveedor;
        }
        field(10; "Cod. Asesor/Consultor"; Code[20])
        {
            Editable = false;
            TableRelation = Vendor."No.";
        }
        field(11; "Nombre Asesor/Consultor"; Text[100])
        {
            Editable = false;
        }
        field(12; "Delegación"; Code[20])
        {
            Editable = false;
            TableRelation = "Dimension Value".Code;
        }
        field(13; "Grupo Negocio"; Code[20])
        {
            Editable = false;
            TableRelation = "Datos auxiliares".Codigo WHERE ("Tipo registro" = CONST ("Grupo de Negocio"));
        }
        field(14; "Cod. promotor"; Code[20])
        {
            Editable = false;
            TableRelation = "Salesperson/Purchaser";
        }
        field(15; "Nombre promotor"; Text[100])
        {
            Editable = false;
        }
        field(16; "Estado Visita"; Option)
        {
            CalcFormula = Lookup ("Cab. Visita Asesor/Consultor".Estado WHERE ("No. Visita Asesor/Consultor" = FIELD ("No. Visita")));
            Editable = false;
            FieldClass = FlowField;
            OptionCaption = 'Programada,Ejecutada';
            OptionMembers = Programada,Ejecutada;
        }
        field(17; "Cod. Colegio"; Code[20])
        {
            Editable = false;
            TableRelation = Contact."No." WHERE (Type = CONST (Company));
        }
        field(18; "Nombre Colegio"; Text[100])
        {
            Editable = false;
        }
        field(19; "Fecha Realizada"; Date)
        {
        }
        field(20; "Hora Inicio Realizada"; Time)
        {
        }
        field(21; "Hora Fin Realizada"; Time)
        {
        }
        field(22; "Cod. Docente"; Code[20])
        {
            TableRelation = "Colegio - Docentes"."Cod. Docente" WHERE ("Cod. Colegio" = FIELD ("Cod. Colegio"));

            trigger OnLookup()
            var
                rColDoc: Record "Colegio - Docentes";
                pColDoc: Page "Lista Colegio - Docentes";
                Cab: Record "Cab. Visita Asesor/Consultor";
            begin

                Cab.Get("No. Visita");
                Cab.TestField("Programa Seguimiento Uno a Uno", true);


                rColDoc.Reset;
                rColDoc.SetRange("Cod. Colegio", "Cod. Colegio");
                rColDoc.SetRange("Pertenece al CDS", true);
                pColDoc.SetTableView(rColDoc);
                pColDoc.LookupMode(true);
                if pColDoc.RunModal = ACTION::LookupOK then begin
                    pColDoc.GetRecord(rColDoc);
                    Validate("Cod. Docente", rColDoc."Cod. Docente");
                end;
            end;

            trigger OnValidate()
            var
                ColegioDoc: Record "Colegio - Docentes";
                Cab: Record "Cab. Visita Asesor/Consultor";
            begin
                Cab.Get("No. Visita");
                Cab.TestField("Programa Seguimiento Uno a Uno", true);

                if "Cod. Docente" <> '' then begin
                    ColegioDoc.SetRange("Cod. Colegio", "Cod. Colegio");
                    ColegioDoc.SetRange("Cod. Docente", "Cod. Docente");
                    if ColegioDoc.FindSet then
                        "Nombre Docente" := ColegioDoc."Nombre docente";
                end
                else
                    "Nombre Docente" := '';
            end;
        }
        field(23; "Nombre Docente"; Text[100])
        {
            Editable = false;
        }
        field(24; "Cod. Sección"; Code[20])
        {

            trigger OnLookup()
            var
                rColGrado: Record "Colegio - Grados";
                pColGrado: Page "Colegio - Grados";
            begin

                /*rColGrado.FILTERGROUP(2);
                rColGrado.SETRANGE("Cod. Colegio","Cod. Colegio");
                IF "Cod. Grado" <> '' THEN
                  rColGrado.SETRANGE("Cod. Grado","Cod. Grado");
                rColGrado.FILTERGROUP(0);
                pColGrado.SETTABLEVIEW(rColGrado);
                pColGrado.LOOKUPMODE(TRUE);
                pColGrado.EDITABLE(FALSE);
                IF pColGrado.RUNMODAL = ACTION::LookupOK THEN BEGIN
                  pColGrado.GETRECORD(rColGrado);
                  "Cod. Sección" := rColGrado.Seccion;
                END;
                */

            end;
        }
    }

    keys
    {
        key(Key1; "No. Visita", "No. Linea")
        {
            Clustered = true;
        }
        key(Key2; "Cod. Asesor/Consultor", "Fecha Programada", "No. Visita", "Hora Inicio Programada", "Hora Fin Programada", "Delegación", "Grupo Negocio")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    var
        rRec: Record "Prog. Visitas Asesor/Consultor";
        rCab: Record "Cab. Visita Asesor/Consultor";
        Error001: Label 'La fecha de la visita (%1) es inferior a la fecha de registro (%2).';
    begin

        TestField("Fecha Programada");
        TestField("Hora Inicio Programada");
        TestField("Hora Fin Programada");

        rRec.Reset;
        rRec.SetRange(rRec."No. Visita", "No. Visita");
        if rRec.FindLast then
            "No. Linea" := rRec."No. Linea" + 1
        else
            "No. Linea" := 1;

        if "Fecha Programada" <> 0D then
            if rCab.Get("No. Visita") then
                if "Fecha Programada" < rCab."Fecha Registro" then
                    Error(StrSubstNo(Error001, "Fecha Programada", rCab."Fecha Registro"));

        if rCab.Get("No. Visita") then begin
            "Tipo Asesor/Consultor" := rCab."Tipo Asesor/Consultor";
            "Cod. Asesor/Consultor" := rCab."Cod. Asesor/Consultor";
            "Nombre Asesor/Consultor" := rCab."Nombre Asesor/Consultor";
            Delegación := rCab.Delegación;
            "Grupo Negocio" := rCab."Grupo Negocio";
            "Cod. promotor" := rCab."Cod. promotor";
            "Nombre promotor" := rCab."Nombre promotor";
            "Cod. Colegio" := rCab."Cod. Colegio";
            "Nombre Colegio" := rCab."Nombre Colegio";
        end;
    end;

    trigger OnModify()
    var
        Error001: Label 'La fecha de la visita (%1) es inferior a la fecha de registro (%2).';
        rCab: Record "Cab. Visita Asesor/Consultor";
    begin


        TestField("Fecha Programada");
        TestField("Hora Inicio Programada");
        TestField("Hora Fin Programada");

        if "Fecha Programada" <> 0D then
            if rCab.Get("No. Visita") then
                if "Fecha Programada" < rCab."Fecha Registro" then
                    Error(StrSubstNo(Error001, "Fecha Programada", rCab."Fecha Registro"));
    end;
}

