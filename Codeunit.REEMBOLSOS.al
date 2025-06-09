codeunit 56014 REEMBOLSOS
{

    trigger OnRun()
    var
        Aut: Record "Autorizaciones SRI Proveedores";
        AdopDetalle: Record "Colegio - Adopciones Detalle";
    begin
        //Aut.RESET;
        //Aut.SETRANGE("Tipo Comprobante",'01');
        //Aut.MODIFYALL(Aut."Permitir Comprobante Reembolso",TRUE);
        AdopDetalle.FindSet;
        repeat
            AdopDetalle.DescTotal;
            AdopDetalle.Modify;
        until AdopDetalle.Next = 0;
        Message('FIN');
    end;
}

