codeunit 56301 ModificarCaracterIncorrectoFA2
{
    // FAA #13689 Modificar caracter extraño por Ñ. Santillana Ecuador

    Permissions = TableData "Sales Invoice Header" = rm;

    trigger OnRun()
    begin

        recHistFactVentas.Reset;
        recHistFactVentas.SetRange(recHistFactVentas."No.", 'VFR-032963');
        if recHistFactVentas.FindSet then begin
            recHistFactVentas."VAT Registration No." := '1706063896001';
            recHistFactVentas.Modify;
        end;
    end;

    var
        recHistFactVentas: Record "Sales Invoice Header";
}

