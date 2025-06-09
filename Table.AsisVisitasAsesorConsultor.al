table 76350 "Asis. Visitas Asesor/Consultor"
{

    fields
    {
        field(1; "No. Visita"; Code[20])
        {
            Editable = false;
        }
        field(2; "No. Linea Progr."; Integer)
        {
            Editable = false;
        }
        field(3; "No. Linea"; Integer)
        {
            Editable = false;
        }
        field(4; "Cod. Docente"; Code[20])
        {
            TableRelation = Docentes;

            trigger OnValidate()
            var
                Prof: Record Docentes;
            begin

                if "Cod. Docente" <> '' then begin
                    Prof.Get("Cod. Docente");
                    "Nombre Docente" := Prof."Full Name";
                    "Document ID" := Prof."Document ID";
                    Inscrito := true;
                end;
            end;
        }
        field(5; "Nombre Docente"; Text[60])
        {
            Editable = false;
        }
        field(6; Asistio; Boolean)
        {
            Caption = 'Attended';

            trigger OnValidate()
            begin

                if (not Confirmado) and (Asistio) then
                    Confirmado := Asistio;

                if (Asistio) then begin
                    Inscrito := Asistio;
                    Confirmado := Asistio;
                end;
            end;
        }
        field(7; Inscrito; Boolean)
        {
        }
        field(8; Confirmado; Boolean)
        {
        }
        field(9; "Fecha inscripcion"; Date)
        {
            Editable = false;
        }
        field(10; "Fecha programación"; Date)
        {
            CalcFormula = Lookup ("Prog. Visitas Asesor/Consultor"."Fecha Programada" WHERE ("No. Visita" = FIELD ("No. Visita")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(11; "Document ID"; Text[20])
        {
            Caption = 'Document ID';
            Editable = false;

            trigger OnValidate()
            var
                VATRegNoFormat: Record "VAT Registration No. Format";
            begin
            end;
        }
    }

    keys
    {
        key(Key1; "No. Visita", "No. Linea Progr.", "No. Linea")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    var
        rRec: Record "Asis. Visitas Asesor/Consultor";
        Error001: Label 'La fecha de la visita (%1) es inferior a la fecha de registro (%2).';
    begin

        rRec.Reset;
        rRec.SetRange(rRec."No. Visita", "No. Visita");
        rRec.SetRange(rRec."No. Linea Progr.", "No. Linea Progr.");
        if rRec.FindLast then
            "No. Linea" := rRec."No. Linea" + 1
        else
            "No. Linea" := 1;

        "Fecha inscripcion" := Today;
    end;
}

