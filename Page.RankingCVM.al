page 76372 "Ranking CVM"
{
    ApplicationArea = all;
    Editable = false;
    PageType = Card;
    SourceTable = "Ranking CVM Colegio";
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                ShowCaption = false;
                field("Cod. Colegio"; rec."Cod. Colegio")
                {
                    Visible = false;
                }
                field("Grupo de Negocio"; rec."Grupo de Negocio")
                {
                    Editable = false;
                }
                field("CVM GN"; rec."CVM GN")
                {
                    Editable = false;
                }
                field(INI; rec.INI)
                {
                    Editable = false;
                }
                field(PRI; rec.PRI)
                {
                    Editable = false;
                }
                field(SEC; rec.SEC)
                {
                    Editable = false;
                }
                field("% Compra"; rec."% Compra")
                {
                    Editable = false;
                }
            }
        }
    }

    actions
    {
    }


    procedure CalcularRanking(CodCol: Code[20])
    var
        Colegio: Record Contact;
        ColCateg: Record "Categorias CVM";
        HistColAdopciones: Record "Historico Adopciones";
        TarifVta: Record "Price List Line";
        Porciento: Decimal;
        Total: Decimal;
        TotalGpoNivel: Decimal;
        wAntGpo: Code[20];
        Config: Record "Commercial Setup";
        HistColCateg: Record "Histórico Categorias CVM";
        ColAdopciones: Record "Colegio - Adopciones Detalle";
        ultCamp: Code[20];
        Text001: Label 'Ranking CVM (calculado con datos de la temporada: %1)';
    begin

        Total := 0;

        Config.Get;
        CurrPage.Caption(StrSubstNo(Text001, Format(Config."Campaña Ranking Solicitud")));

        case Config."Campaña Ranking Solicitud" of
            Config."Campaña Ranking Solicitud"::"Última Cerrada":
                begin
                    HistColAdopciones.Reset;
                    HistColAdopciones.SetCurrentKey(Campana, "Cod. Colegio", "Linea de negocio");
                    HistColAdopciones.FindLast;
                    ultCamp := HistColAdopciones.Campana;
                    HistColAdopciones.SetCurrentKey("Cod. Colegio", Campana, Adopcion, "Cod. Editorial", "Grupo de Negocio", "Linea de negocio");
                    HistColAdopciones.SetRange(Campana, ultCamp);
                    HistColAdopciones.SetRange("Cod. Colegio", CodCol);
                    HistColAdopciones.SetRange(Adopcion, 1, 2); //Mantener, Conquista
                    if HistColAdopciones.FindSet then
                        repeat
                            HistColAdopciones.CalcFields("Sales Price - Unit Price");
                            HistColAdopciones.TestField("Sales Price - Unit Price");
                            Total += HistColAdopciones."Sales Price - Unit Price" * HistColAdopciones."Adopcion Real";
                        until HistColAdopciones.Next = 0;

                    Clear(wAntGpo);
                    TotalGpoNivel := 0;
                    HistColCateg.Reset;
                    HistColCateg.SetRange("Cod. Colegio", CodCol);
                    if HistColCateg.FindSet then begin
                        repeat
                            if wAntGpo <> HistColCateg."Grupo Negocio" then begin
                                if wAntGpo <> '' then begin
                                    HistColAdopciones.Reset;
                                    HistColAdopciones.SetCurrentKey("Cod. Colegio", Campana, Adopcion, "Cod. Editorial", "Grupo de Negocio", "Linea de negocio");
                                    HistColAdopciones.SetRange(Campana, ultCamp);
                                    HistColAdopciones.SetRange("Cod. Colegio", CodCol);
                                    HistColAdopciones.SetRange(Adopcion, 1, 2); //Mantener, Conquista
                                    HistColAdopciones.SetRange("Grupo de Negocio", wAntGpo);
                                    if HistColAdopciones.FindSet then
                                        repeat
                                            HistColAdopciones.CalcFields("Sales Price - Unit Price");
                                            HistColAdopciones.TestField("Sales Price - Unit Price");
                                            TotalGpoNivel += HistColAdopciones."Sales Price - Unit Price" * HistColAdopciones."Adopcion Real";
                                        until HistColAdopciones.Next = 0;
                                    if (Total <> 0) and (TotalGpoNivel <> 0) then
                                        rec."% Compra" := Round(TotalGpoNivel / Total, 0.01) * 100;
                                    rec.Insert;
                                end;
                                TotalGpoNivel := 0;
                                wAntGpo := HistColCateg."Grupo Negocio";
                                rec.Init;
                                rec."Cod. Colegio" := HistColCateg."Cod. Colegio";
                                rec."Grupo de Negocio" := HistColCateg."Grupo Negocio";
                            end;
                            case HistColCateg."Cod. Nivel" of
                                'GEN':
                                    rec."CVM GN" := HistColCateg.Categoria;
                                'INI':
                                    rec.INI := HistColCateg.Categoria;
                                'PRI':
                                    rec.PRI := HistColCateg.Categoria;
                                'SEC':
                                    rec.SEC := HistColCateg.Categoria;
                            end;

                        until HistColCateg.Next = 0;
                        HistColAdopciones.Reset;
                        HistColAdopciones.SetCurrentKey("Cod. Colegio", Campana, Adopcion, "Cod. Editorial", "Grupo de Negocio", "Linea de negocio");
                        HistColAdopciones.SetRange(Campana, ultCamp);
                        HistColAdopciones.SetRange("Cod. Colegio", CodCol);
                        HistColAdopciones.SetRange(Adopcion, 1, 2); //Mantener, Conquista
                        HistColAdopciones.SetRange("Grupo de Negocio", wAntGpo);
                        if HistColAdopciones.FindSet then
                            repeat
                                HistColAdopciones.CalcFields("Sales Price - Unit Price");
                                HistColAdopciones.TestField("Sales Price - Unit Price");
                                TotalGpoNivel += HistColAdopciones."Sales Price - Unit Price" * HistColAdopciones."Adopcion Real";
                            until HistColAdopciones.Next = 0;
                        if (Total <> 0) and (TotalGpoNivel <> 0) then
                            rec."% Compra" := Round(TotalGpoNivel / Total, 0.01) * 100;
                        rec.Insert;
                    end;
                end;//FIN ULTIMA

            Config."Campaña Ranking Solicitud"::Vigente:
                begin
                    ColAdopciones.Reset;
                    ColAdopciones.SetCurrentKey("Cod. Colegio", Adopcion, "Cod. Editorial", "Grupo de Negocio", "Linea de negocio");
                    ColAdopciones.SetRange("Cod. Colegio", CodCol);
                    ColAdopciones.SetRange(Adopcion, 1, 2); //Mantener, Conquista
                    if ColAdopciones.FindSet then
                        repeat
                            ColAdopciones.CalcFields("Sales Price - Unit Price");
                            ColAdopciones.TestField("Sales Price - Unit Price");
                            Total += ColAdopciones."Sales Price - Unit Price" * ColAdopciones."Adopcion Real";
                        until ColAdopciones.Next = 0;

                    Clear(wAntGpo);
                    TotalGpoNivel := 0;
                    ColCateg.Reset;
                    ColCateg.SetRange("Cod. Colegio", CodCol);
                    if ColCateg.FindSet then begin
                        repeat
                            if wAntGpo <> ColCateg."Grupo Negocio" then begin
                                if wAntGpo <> '' then begin
                                    ColAdopciones.Reset;
                                    ColAdopciones.SetCurrentKey("Cod. Colegio", Adopcion, "Cod. Editorial", "Grupo de Negocio", "Linea de negocio");
                                    ColAdopciones.SetRange("Cod. Colegio", CodCol);
                                    ColAdopciones.SetRange(Adopcion, 1, 2); //Mantener, Conquista
                                    ColAdopciones.SetRange("Grupo de Negocio", wAntGpo);
                                    if ColAdopciones.FindSet then
                                        repeat
                                            ColAdopciones.CalcFields("Sales Price - Unit Price");
                                            ColAdopciones.TestField("Sales Price - Unit Price");
                                            TotalGpoNivel += ColAdopciones."Sales Price - Unit Price" * ColAdopciones."Adopcion Real";
                                        until ColAdopciones.Next = 0;
                                    if (Total <> 0) and (TotalGpoNivel <> 0) then
                                        rec."% Compra" := Round(TotalGpoNivel / Total, 0.01) * 100;
                                    rec.Insert;
                                end;
                                TotalGpoNivel := 0;
                                wAntGpo := ColCateg."Grupo Negocio";
                                rec.Init;
                                rec."Cod. Colegio" := ColCateg."Cod. Colegio";
                                rec."Grupo de Negocio" := ColCateg."Grupo Negocio";
                            end;
                            case ColCateg."Cod. Nivel" of
                                'GEN':
                                    rec."CVM GN" := ColCateg.Categoria;
                                'INI':
                                    rec.INI := ColCateg.Categoria;
                                'PRI':
                                    rec.PRI := ColCateg.Categoria;
                                'SEC':
                                    rec.SEC := ColCateg.Categoria;
                            end;

                        until ColCateg.Next = 0;
                        ColAdopciones.Reset;
                        ColAdopciones.SetCurrentKey("Cod. Colegio", Adopcion, "Cod. Editorial", "Grupo de Negocio", "Linea de negocio");
                        ColAdopciones.SetRange("Cod. Colegio", CodCol);
                        ColAdopciones.SetRange(Adopcion, 1, 2); //Mantener, Conquista
                        ColAdopciones.SetRange("Grupo de Negocio", wAntGpo);
                        if ColAdopciones.FindSet then
                            repeat
                                ColAdopciones.CalcFields("Sales Price - Unit Price");
                                ColAdopciones.TestField("Sales Price - Unit Price");
                                TotalGpoNivel += ColAdopciones."Sales Price - Unit Price" * ColAdopciones."Adopcion Real";
                            until ColAdopciones.Next = 0;
                        if (Total <> 0) and (TotalGpoNivel <> 0) then
                            rec."% Compra" := Round(TotalGpoNivel / Total, 0.01) * 100;
                        rec.Insert;
                    end;
                end;//FIN VIGENTE
        end;//FIN CASE
    end;
}

