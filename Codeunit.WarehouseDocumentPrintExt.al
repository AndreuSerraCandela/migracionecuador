codeunit 55043 "Warehouse Document-Print Ext"
{
      /*
      Proyecto: Implementacion Microsoft Dynamics Nav
      AMS     : Agustin Mendez
      GRN     : Guillermo Roman
      ------------------------------------------------------------------------
      No.     Fecha           Firma         Descripcion
      ------------------------------------------------------------------------
      002     23-Oct-12       AMS           Picking List Santillana
    */
    
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Warehouse Document-Print", 'OnBeforePrintPickHeader', '', false, false)]
    local procedure OnBeforePrintPickHeaderHandler(var WarehouseActivityHeader: Record "Warehouse Activity Header"; var IsHandled: Boolean)
    var
        WhsePick_Sant: Report 55022;
    begin
        // Aplicar lógica personalizada para ejecutar el reporte WhsePick_Sant
        WarehouseActivityHeader.SetRange(Type, WarehouseActivityHeader.Type::Pick);
        WarehouseActivityHeader.SetRange("No.", WarehouseActivityHeader."No.");
        WhsePick_Sant.SetTableView(WarehouseActivityHeader);
        WhsePick_Sant.RunModal();

        // Evita que se ejecute la lógica estándar
        IsHandled := true;
    end;
}
