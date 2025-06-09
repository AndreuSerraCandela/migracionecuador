codeunit 55031 "Events Release Purch Document"
{

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release Purchase Document", 'OnCodeOnAfterCheckPurchaseReleaseRestrictions', '', false, false)]
    local procedure OnCodeOnAfterCheckPurchaseReleaseRestrictions(var PurchaseHeader: Record "Purchase Header")
    begin
        TestDim(PurchaseHeader); //001
    end;

    PROCEDURE TestDim(PurchaseHeader: Record "Purchase Header");
    VAR
        PL: Record "Purchase Line";
        recDim: Record "Dimension Set Entry";
        ConfEmpresa: Record "Config. Empresa";
    BEGIN
        ConfEmpresa.GET();
        IF ConfEmpresa."Dim. Tipo Facturacion" <> '' THEN BEGIN
            PL.RESET;
            PL.SETRANGE("Document Type", PurchaseHeader."Document Type");
            PL.SETRANGE("Document No.", PurchaseHeader."No.");
            PL.SETRANGE(Type, PL.Type::Item);
            PL.SETFILTER(Quantity, '<>%1', 0);
            IF PL.FINDFIRST THEN BEGIN
                recDim.RESET;
                recDim.SETRANGE("Dimension Set ID", PL."Dimension Set ID");
                recDim.SETRANGE("Dimension Code", ConfEmpresa."Dim. Tipo Facturacion");
                IF NOT recDim.FINDFIRST THEN
                    ERROR(Err001, recDim.FIELDCAPTION("Dimension Code"), ConfEmpresa."Dim. Tipo Facturacion",
                                 PurchaseHeader.FIELDCAPTION("Document Type"), PurchaseHeader."Document Type");
            END;
        END;
    END;

    var
        //Traducción francés Text002
        //Traducción español Text005
        Err001: Label 'You must specify %1 %2 for %3 %4';//ESP=Se debe especificar %1 %2 para el %3 %4;ESM=Se debe especificar %1 %2 para el %3 %4';

    /*
  ------------------------------------------------------------------------
  No.     Fecha           Firma         Descripcion
  ------------------------------------------------------------------------
  001     07-Agosto-11     GRN          Se creo la funcion TestDim para validar
                                        la dimension de tipo de facturacion
    */
}