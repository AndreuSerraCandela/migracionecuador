codeunit 55029 "Events DimensionManagement"
{
    //Pendiente modificar metodo GetLastDimErrorID 
    //cambiar GetCachedLastErrorID por GetLastErrorID

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"DimensionManagement", 'OnAfterDefaultDimObjectNoWithoutGlobalDimsList', '', false, false)]
    local procedure OnAfterDefaultDimObjectNoWithoutGlobalDimsList(var TempAllObjWithCaption: Record AllObjWithCaption temporary)
    begin
        //001+
        DimMgt.DefaultDimInsertTempObject(TempAllObjWithCaption, DATABASE::Location);
        //001-

        //DSNOM1.03
        DimMgt.DefaultDimInsertTempObject(TempAllObjWithCaption, DATABASE::"Puestos laborales"); //DSNOM1.01
        DimMgt.DefaultDimInsertTempObject(TempAllObjWithCaption, DATABASE::"Perfil Salarial"); //DSNOM1.01
        DimMgt.DefaultDimInsertTempObject(TempAllObjWithCaption, DATABASE::"Conceptos salariales"); //DSNOM1.01
        DimMgt.DefaultDimInsertTempObject(TempAllObjWithCaption, DATABASE::"Dist. Ctas. Gpo. Cont. Empl."); //DSNOM1.01
    end;

    var
        //Pendiente Traducción Frances Text014
        DimMgt: Codeunit DimensionManagement;

    /*
  Proyecto: Implementacion Microsoft Dynamics Nav
  AMS     : Agustin Mendez
  GRN     : Guillermo Roman
  ------------------------------------------------------------------------
  No.         Fecha          Firma   Descripcion
  ------------------------------------------------------------------------
  DSNOM1.03   16/06/2020      GRN    Modificaciones para manejar modulo de nominas

  001         16-Julio-11     AMS    Agregar dimensiones a los almacenes
                                     para poder tener la tienda en el POS

  002         01-Oct-11       AMS    Agregar tipo de documento a las dimensiones
                                     registradas para poder replicar desde el
                                     historico a borrador.
    */
}