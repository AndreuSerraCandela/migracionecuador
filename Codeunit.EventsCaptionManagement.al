codeunit 55016 "Events Caption Class Impl."
{
    //Nuevo Codeunit en Nav se utilizaba Caption Managment

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Caption Class", 'OnResolveCaptionClass', '', false, false)]
    local procedure OnResolveCaptionClass(CaptionArea: Text; CaptionExpr: Text; var Caption: Text; var Resolved: Boolean)
    var
        lrFiltMdM: Record "Conf.Filtros Tipologias MdM";
    begin
        IF CaptionArea = '75000' THEN BEGIN
            Caption := lrFiltMdM.GetFiltDescrptTx(CaptionExpr); // MdM
            Resolved := TRUE;
        end;
    end;

    var
    //MdM JPT 20/10/17 Determinamos el codigo de filtrado de tipologias seg£n configuración
}