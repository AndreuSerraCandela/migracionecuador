xmlport 76116 "RNC DGII Import"
{
    Caption = 'RNC DGII Import';
    Direction = Import;
    FieldDelimiter = '<None>';
    FieldSeparator = '|';
    Format = VariableText;
    FormatEvaluate = Legacy;
    TextEncoding = WINDOWS;

    schema
    {
        textelement(Root)
        {
            tableelement("RNC DGII"; "RNC DGII")
            {
                XmlName = 'RNCDGII';
                textelement(RNC)
                {
                    MinOccurs = Zero;
                }
                textelement(Name)
                {
                    MinOccurs = Zero;
                }
                textelement(SearchName)
                {
                    MinOccurs = Zero;
                    TextType = Text;
                }
                textelement(Campo4)
                {
                    MinOccurs = Zero;
                }
                textelement(Campo5)
                {
                    MinOccurs = Zero;
                }
                textelement(Campo6)
                {
                    MinOccurs = Zero;
                }
                textelement(Campo7)
                {
                    MinOccurs = Zero;
                }
                textelement(Campo8)
                {
                    MinOccurs = Zero;
                }
                textelement(FechaRegistro)
                {
                    MinOccurs = Zero;
                }
                textelement(Estado)
                {
                    MinOccurs = Zero;
                }
                textelement(Tipo)
                {
                    MinOccurs = Zero;
                }

                trigger OnBeforeInsertRecord()
                var
                    n: Char;
                    NM: Char;
                begin
                    contador := contador + 1;
                    if GuiAllowed then begin
                        Window.Update(1, (contador / 705000 * 10000) div 1);
                        Window.Update(2, contador);
                    end;

                    if RNC = '' then
                        currXMLport.Skip;

                    //IF NOT EVALUATE(EvaluarVat,COPYSTR(RNC,1,4))THEN
                    if not Evaluate(EvaluarVat, RNC) then
                        currXMLport.Skip;

                    //IF RNCDGII.GET(RNC) THEN
                    // currXMLport.SKIP;

                    "RNC DGII"."VAT Registration No." := RNC;

                    if Name <> '' then begin
                        // Name := DELCHR(Name,'=',DELCHR(Name,'=','ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789&áéíóúñÑÁÉÍÓÚü '));
                        Name := ConvertStr(Name, 'áéíóúñÑÁÉÍÓÚü', 'aeiounNAEIOUu');
                        //n := 165;
                        //NM := 164;
                        //Name := CONVERTSTR(Name,FORMAT(NM),'N');
                        "RNC DGII".Name := CopyStr(Name, 1, MaxStrLen("RNC DGII".Name));
                    end;

                    if SearchName <> '' then begin
                        //SearchName := DELCHR(SearchName,'=',DELCHR(SearchName,'=','ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789&áéíóúñÑÁÉÍÓÚü '));
                        SearchName := ConvertStr(SearchName, 'áéíóúñÑÁÉÍÓÚü', 'aeiounNAEIOUu');
                        "RNC DGII"."Search Name" := CopyStr(SearchName, 1, MaxStrLen("RNC DGII"."Search Name"));
                    end;

                    if Campo4 <> '' then begin
                        //Campo4 := DELCHR(Campo4,'=',DELCHR(Campo4,'=','ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789&áéíóúñÑÁÉÍÓÚü '));
                        Campo4 := ConvertStr(Campo4, 'áéíóúñÑÁÉÍÓÚü', 'aeiounNAEIOUu');
                        "RNC DGII"."Campo 4" := CopyStr(Campo4, 1, MaxStrLen("RNC DGII"."Campo 4"));
                    end;

                    if Campo5 <> '' then
                        "RNC DGII"."Campo 5" := CopyStr(Campo5, 1, MaxStrLen("RNC DGII"."Campo 5"));

                    if Campo6 <> '' then
                        "RNC DGII"."Campo 6" := CopyStr(Campo6, 1, MaxStrLen("RNC DGII"."Campo 6"));

                    if Campo7 <> '' then
                        "RNC DGII"."Campo 7" := CopyStr(Campo7, 1, MaxStrLen("RNC DGII"."Campo 7"));

                    if Campo8 <> '' then
                        "RNC DGII"."Campo 8" := CopyStr(Campo8, 1, MaxStrLen("RNC DGII"."Campo 8"));

                    if FechaRegistro <> '' then
                        "RNC DGII"."Fecha Registro DGII" := CopyStr(FechaRegistro, 1, MaxStrLen("RNC DGII"."Fecha Registro DGII"));

                    if Estado <> '' then
                        "RNC DGII".Estado := CopyStr(Estado, 1, MaxStrLen("RNC DGII".Estado));

                    if Tipo <> '' then
                        "RNC DGII".Tipo := CopyStr(Tipo, 1, MaxStrLen("RNC DGII".Tipo));

                    //COMMIT;
                    CantInsertMod := CantInsertMod + 1;
                end;
            }
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    trigger OnPostXmlPort()
    begin
        if GuiAllowed then
            Window.Close;

        if GuiAllowed then
            Message('%1 RNC Importado con exito.!!!', CantInsertMod);
    end;

    trigger OnPreXmlPort()
    begin

        if GuiAllowed then
            Window.Open('Importando datos... @1@@@@@@@@@@\ Cantidad RNC Leidos: #2############');

    end;

    var
        RNCDGII: Record "RNC DGII";
        Window: Dialog;
        contador: Integer;
        EvaluarVat: BigInteger;
        CantInsertMod: Integer;
}

