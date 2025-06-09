table 76075 "Param. Inic. Conceptos Sal."
{
    Caption = 'Clear Wedges';
    DrillDownPageID = "Param. Inic. Concepto Sal.";
    LookupPageID = "Param. Inic. Concepto Sal.";

    fields
    {
        field(1; Codigo; Code[20])
        {
            Caption = 'Code';
            TableRelation = "Conceptos salariales".Codigo;

            trigger OnValidate()
            var
                ConfNom: Record "Configuracion nominas";
            begin
                ConfNom.Get();
                rConceptoSalarial.Get(Codigo);
                Descripcion := rConceptoSalarial.Descripcion;
                "Tipo concepto" := rConceptoSalarial."Tipo concepto";
            end;
        }
        field(2; Descripcion; Text[60])
        {
            Caption = 'Description';
        }
        field(3; "Tipo concepto"; Option)
        {
            Caption = 'Wedge type';
            Description = 'Ingresos,Deducciones,Bases';
            OptionCaption = 'Income,Deduction';
            OptionMembers = Ingresos,Deducciones;
        }
        field(4; "Inicializa Cantidad"; Boolean)
        {
            Caption = 'Clear Quantity';
        }
        field(5; "Inicializa Importe"; Boolean)
        {
            Caption = 'Clear Amount';

            trigger OnValidate()
            begin
                rLinPerfilSal.Reset;
                rLinPerfilSal.SetRange("Concepto salarial", Codigo);
                rLinPerfilSal.SetFilter("Formula calculo", '<>%1', ' ');
                if rLinPerfilSal.FindFirst then
                    if "Inicializa Importe" then
                        Error(Err001);
            end;
        }
    }

    keys
    {
        key(Key1; Codigo)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        rConceptoSalarial: Record "Conceptos salariales";
        rLinPerfilSal: Record "Perfil Salarial";
        Err001: Label 'This wedge''s concept has formula, amount can''t be cleared';
}

