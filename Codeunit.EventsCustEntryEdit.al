codeunit 55020 " Events Cust. Entry-Edit"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Cust. Entry-Edit", 'OnBeforeCustLedgEntryModify', '', false, false)]
    local procedure OnBeforeCustLedgEntryModify(FromCustLedgEntry: Record "Cust. Ledger Entry"; var CustLedgEntry: Record "Cust. Ledger Entry")
    begin
        if CustLedgEntry.Open then begin
            //001
            CustLedgEntry."ID Retencion Venta" := FromCustLedgEntry."ID Retencion Venta";
            CustLedgEntry."Importe Retencion Venta" := FromCustLedgEntry."Importe Retencion Venta";
            //001

            //+#34822
            CustLedgEntry."Importe Ret. Renta a liquidar" := FromCustLedgEntry."Importe Ret. Renta a liquidar";
            CustLedgEntry."Importe Ret. IVA a liquidar" := FromCustLedgEntry."Importe Ret. IVA a liquidar";
            //-#34822
        end;
    end;

    /*
          Proyecto: Implementacion Microsoft Dynamics Nav
          AMS     : Agustin Mendez
          GRN     : Guillermo Roman
          ------------------------------------------------------------------------
          No.     Fecha            Firma         Descripcion
          ------------------------------------------------------------------------
          001     01-Marzo-2013    AMS           Para modificar el ID de Retencion desde Liquidacion de movimientos cliente.
          #34822  02/12/2015       CAT           Para modificar el "Importe Ret. Renta a liquidar", "Importe Ret. IVA a liquidar" desde los movimientos de cliente
    */
}