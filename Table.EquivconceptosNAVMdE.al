table 56201 "Equiv. conceptos NAV-MdE"
{

    fields
    {
        field(1; "Concepto NAV"; Code[20])
        {
        }
        field(2; "Concepto IRM"; Option)
        {
            OptionMembers = ,SalanFI,CompSalanFIJ,CompVariable,SaFijTot,BonoDeven,BonoPagado,VarComercial,VarComerialDE,Gratificacion,ILPDeven,ILPPagado,Colaboraciones,CargasSociales,OtrosGastos,Indemnizacion;
        }
        field(3; "Concepto CT"; Option)
        {
            OptionMembers = ,Salario,Comple,Bono,ILP,VarCom,Rappel;
        }
        field(4; Porcentaje; Decimal)
        {
            MaxValue = 1;
            MinValue = 0;
        }
    }

    keys
    {
        key(Key1; "Concepto NAV", "Concepto IRM", "Concepto CT")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }


    procedure GetNoConcepts(MdEConceptType: Option IRM,CT): Integer
    begin
        if MdEConceptType = MdEConceptType::IRM then
            exit(15)
        else
            exit(6);
    end;
}

