table 56051 "Revisar estado documentos"
{

    fields
    {
        field(1; Documento; Code[20])
        {
            Editable = false;
        }
        field(2; "Estado envio actual"; Option)
        {
            Editable = false;
            OptionMembers = Pendiente,Enviado,Rechazado;
        }
        field(3; "Estado autorizacion actual"; Option)
        {
            Editable = false;
            OptionMembers = Pendiente,Autorizado,"No autorizado";
        }
        field(4; "Estado envio (Presunto)"; Option)
        {
            Editable = false;
            OptionMembers = Pendiente,Enviado,Rechazado;
        }
        field(5; "Estado autorizacion (Presunto)"; Option)
        {
            Editable = false;
            OptionMembers = Pendiente,Autorizado,"No autorizado";
        }
        field(6; "Fecha emision"; Date)
        {
            Editable = false;
        }
        field(10; Revisar; Boolean)
        {
            Editable = false;
        }
        field(20; "Estado envio real"; Option)
        {
            CalcFormula = Lookup ("Documento FE"."Estado envio" WHERE ("No. documento" = FIELD (Documento)));
            Editable = false;
            FieldClass = FlowField;
            OptionMembers = Pendiente,Enviado,Rechazado;
        }
        field(21; "Estado autorizacion real"; Option)
        {
            CalcFormula = Lookup ("Documento FE"."Estado autorizacion" WHERE ("No. documento" = FIELD (Documento)));
            Editable = false;
            FieldClass = FlowField;
            OptionMembers = Pendiente,Autorizado,"No autorizado";
        }
        field(99; DUMMY; Boolean)
        {
        }
    }

    keys
    {
        key(Key1; Documento)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

