table 76227 "Tipos de Tarjeta"
{
    DrillDownPageID = "Lista Tipos de Tarjeta";
    LookupPageID = "Ficha Tipos de Tajerta";

    fields
    {
        field(76046; Codigo; Code[10])
        {
            Description = 'DsPOS Standar';
        }
        field(76029; Descripcion; Text[30])
        {
            Description = 'DsPOS Standar';
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
        fieldgroup(DropDown; Codigo, Descripcion)
        {
        }
    }

    trigger OnDelete()
    var
        rFPago: Record "Formas de Pago";
    begin

        rFPago.Reset;
        rFPago.SetCurrentKey("Tipo Tarjeta");
        rFPago.SetRange("Tipo Tarjeta", Codigo);
        if rFPago.FindSet then
            Error(Error001, rFPago."ID Pago");
    end;

    var
        Error001: Label 'El Tipo de Tarjeta que intenta borrar esta definido para la forma de pago %1';
}

